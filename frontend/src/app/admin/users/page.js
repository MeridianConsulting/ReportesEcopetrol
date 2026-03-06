// app/admin/users/page.js
'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Layout from '../../../components/Layout';
import { apiRequest } from '../../../lib/api';
import { 
  Plus, 
  X, 
  Users, 
  Loader2, 
  Pencil, 
  Trash2, 
  Check,
  AlertTriangle,
  Search,
  Eye,
  EyeOff
} from 'lucide-react';

export default function UsersPage() {
  const router = useRouter();
  const [users, setUsers] = useState([]);
  const [roles, setRoles] = useState([]);
  const [serviceOrders, setServiceOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [saving, setSaving] = useState(false);
  const [deleting, setDeleting] = useState(null);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    role_id: '',
    service_order_ids: [],
  });

  useEffect(() => {
    async function loadUser() {
      try {
        const data = await apiRequest('/auth/me');
        if (data.data.role !== 'admin') {
          router.push('/my-tasks/');
          return;
        }
        setUser(data.data);
      } catch (e) {
        router.push('/login/');
      }
    }
    loadUser();
  }, [router]);

  useEffect(() => {
    if (!user) return;
    loadData();
  }, [user]);

  async function loadData() {
    try {
      const [usersData, rolesData, ordersData] = await Promise.all([
        apiRequest('/users'),
        apiRequest('/roles'),
        apiRequest('/reports/service-orders').catch(() => ({ data: [] })),
      ]);
      setUsers(usersData.data || []);
      setRoles(rolesData.data || []);
      setServiceOrders(ordersData.data || []);
    } catch (e) {
      // Error loading data
    } finally {
      setLoading(false);
    }
  }

  function resetForm() {
    setFormData({
      name: '',
      email: '',
      password: '',
      role_id: '',
      service_order_ids: [],
    });
    setEditingId(null);
    setShowForm(false);
    setShowPassword(false);
  }

  function handleEdit(u) {
    setFormData({
      name: u.name ?? '',
      email: u.email ?? '',
      password: '',
      role_id: u.role_id || '',
      service_order_ids: Array.isArray(u.service_order_ids) ? u.service_order_ids.map(id => parseInt(id, 10)) : [],
    });
    setEditingId(u.id);
    setShowForm(true);
  }

  function toggleServiceOrder(soId) {
    const id = parseInt(soId, 10);
    setFormData(prev => {
      const current = prev.service_order_ids || [];
      if (current.includes(id)) {
        return { ...prev, service_order_ids: current.filter(x => x !== id) };
      }
      return { ...prev, service_order_ids: [...current, id] };
    });
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    try {
      const dataToSend = {
        name: formData.name,
        email: formData.email,
        role_id: formData.role_id,
        service_order_ids: Array.isArray(formData.service_order_ids) ? formData.service_order_ids : [],
      };
      if (formData.password && formData.password.trim()) {
        dataToSend.password = formData.password;
      }
      if (editingId) {
        await apiRequest(`/users/${editingId}`, {
          method: 'PUT',
          body: JSON.stringify(dataToSend),
        });
      } else {
        if (!dataToSend.password) {
          alert('La contraseña es obligatoria para nuevos usuarios.');
          setSaving(false);
          return;
        }
        await apiRequest('/users', {
          method: 'POST',
          body: JSON.stringify(dataToSend),
        });
      }
      resetForm();
      await loadData();
    } catch (e) {
      alert('Error al guardar usuario: ' + e.message);
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete(id) {
    setDeleting(id);
    try {
      await apiRequest(`/users/${id}`, {
        method: 'DELETE',
      });
      setShowDeleteConfirm(null);
      await loadData();
    } catch (e) {
      alert('Error al eliminar: ' + e.message);
    } finally {
      setDeleting(null);
    }
  }

  const filteredUsers = users.filter(u => {
    const term = searchTerm.toLowerCase();
    return (u.name ?? '').toLowerCase().includes(term) ||
           (u.email ?? '').toLowerCase().includes(term) ||
           (u.role ?? '').toLowerCase().includes(term);
  });

  if (loading) {
    return (
      <Layout>
        <div className="flex items-center justify-center h-64">
          <Loader2 className="h-10 w-10 text-green-600 animate-spin" strokeWidth={1.75} />
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className="mx-auto max-w-6xl p-6 lg:p-8">
        <section className="mb-8 overflow-hidden rounded-[28px] border border-slate-200/80 bg-white/95 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.28)]">
          <div className="bg-gradient-to-r from-slate-900 via-slate-800 to-slate-900 px-6 py-6 text-white sm:px-8">
            <div className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
              <div className="space-y-3">
                <div className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs font-semibold uppercase tracking-wide text-slate-100 backdrop-blur">
                  <Users className="h-4 w-4" />
                  Administración
                </div>
                <div>
                  <h1 className="text-2xl font-semibold tracking-tight sm:text-3xl">Gestión de usuarios</h1>
                  <p className="mt-2 text-sm text-slate-300 sm:text-base">Administra accesos, roles y ODS asociadas de los usuarios del sistema.</p>
                </div>
              </div>
          <button
            onClick={() => {
              if (showForm && !editingId) {
                resetForm();
              } else {
                resetForm();
                setShowForm(true);
              }
            }}
                className={`inline-flex items-center gap-2 rounded-2xl px-4 py-3 text-sm font-medium transition focus:outline-none focus:ring-2 focus:ring-offset-2 ${
              showForm && !editingId
                    ? 'bg-white/10 text-white hover:bg-white/15 focus:ring-white/40'
                    : 'bg-emerald-500 text-white hover:bg-emerald-400 focus:ring-emerald-300'
            }`}
          >
            {showForm && !editingId ? (
              <>
                <X className="w-5 h-5" strokeWidth={2} />
                Cancelar
              </>
            ) : (
              <>
                <Plus className="w-5 h-5" strokeWidth={2} />
                Nuevo Usuario
              </>
            )}
          </button>
            </div>
          </div>
        </section>

        {/* Formulario de crear/editar */}
        {showForm && (
          <div className="mb-6 rounded-[28px] border border-slate-200/80 bg-white/95 p-6 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.24)]">
            <h2 className="text-base font-semibold text-slate-900 mb-5">
              {editingId ? 'Editar Usuario' : 'Crear Nuevo Usuario'}
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                <div className="rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                  <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                    Nombre <span className="text-rose-500">*</span>
                  </label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={e => setFormData({ ...formData, name: e.target.value })}
                    required
                    placeholder="Nombre completo"
                    className="w-full rounded-2xl border border-slate-300 px-3 py-2.5 text-sm placeholder:text-slate-400 focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-100"
                  />
                </div>
                <div className="rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                  <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                    Email <span className="text-rose-500">*</span>
                  </label>
                  <input
                    type="email"
                    value={formData.email}
                    onChange={e => setFormData({ ...formData, email: e.target.value })}
                    required
                    placeholder="usuario@empresa.com"
                    className="w-full rounded-2xl border border-slate-300 px-3 py-2.5 text-sm placeholder:text-slate-400 focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-100"
                  />
                </div>
              </div>
              <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                <div className="rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                  <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                    Contraseña {!editingId && <span className="text-rose-500">*</span>}
                  </label>
                  <div className="relative">
                    <input
                      type={showPassword ? 'text' : 'password'}
                      value={formData.password}
                      onChange={e => setFormData({ ...formData, password: e.target.value })}
                      required={!editingId}
                      placeholder={editingId ? 'Dejar vacío para mantener' : 'Mínimo 8 caracteres'}
                      className="w-full rounded-2xl border border-slate-300 px-3 py-2.5 pr-10 text-sm placeholder:text-slate-400 focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-100"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute right-2 top-1/2 -translate-y-1/2 p-1 text-slate-400 hover:text-slate-600"
                    >
                      {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>
                </div>
                <div className="rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                  <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                    Rol <span className="text-rose-500">*</span>
                  </label>
                  <select
                    value={formData.role_id}
                    onChange={e => setFormData({ ...formData, role_id: e.target.value })}
                    required
                    className="w-full rounded-2xl border border-slate-300 bg-white px-3 py-2.5 text-sm focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-100"
                  >
                    <option value="">Seleccionar rol</option>
                    {roles.map(role => (
                      <option key={role.id} value={role.id}>{role.name}</option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="rounded-2xl border border-slate-200 bg-slate-50/70 p-4">
                <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                  ODS asociados al perfil
                </label>
                <p className="text-xs text-slate-500 mb-2">Selecciona las órdenes de servicio (ODS) con las que trabaja este usuario. Se usan para asignar automáticamente el ODS al crear reportes.</p>
                <div className="max-h-48 space-y-1 overflow-y-auto rounded-2xl border border-slate-300 bg-white p-2">
                  {serviceOrders.length === 0 ? (
                    <p className="text-sm text-slate-500 py-2">No hay ODS cargados en el sistema.</p>
                  ) : (
                    serviceOrders.map(so => (
                      <label key={so.id} className="flex items-center gap-2 px-2 py-1.5 rounded hover:bg-slate-50 cursor-pointer">
                        <input
                          type="checkbox"
                          checked={(formData.service_order_ids || []).includes(parseInt(so.id, 10))}
                          onChange={() => toggleServiceOrder(so.id)}
                          className="rounded border-slate-300 text-green-600 focus:ring-green-500"
                        />
                        <span className="text-sm text-slate-700 font-mono">{so.ods_code}</span>
                      </label>
                    ))
                  )}
                </div>
                {(formData.service_order_ids || []).length > 0 && (
                  <p className="text-xs text-slate-500 mt-1">
                    {formData.service_order_ids.length} ODS seleccionado(s)
                  </p>
                )}
              </div>

              <div className="flex justify-end gap-3 pt-2">
                {editingId && (
                  <button
                    type="button"
                    onClick={resetForm}
                    className="rounded-2xl bg-slate-100 px-4 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-200"
                  >
                    Cancelar
                  </button>
                )}
                <button
                  type="submit"
                  disabled={saving}
                  className="inline-flex items-center gap-2 rounded-2xl bg-emerald-600 px-4 py-2.5 text-sm font-medium text-white shadow-sm transition-colors hover:bg-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-offset-2 disabled:opacity-50"
                >
                  {saving ? (
                    <Loader2 className="w-4 h-4 animate-spin" />
                  ) : editingId ? (
                    <Check className="w-4 h-4" strokeWidth={2} />
                  ) : (
                    <Plus className="w-4 h-4" strokeWidth={2} />
                  )}
                  {saving ? 'Guardando...' : editingId ? 'Guardar Cambios' : 'Crear Usuario'}
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Buscador */}
        <div className="mb-4 rounded-[28px] border border-slate-200/80 bg-white/95 p-4 shadow-sm">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input
              type="text"
              placeholder="Buscar usuarios..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              className="w-full rounded-2xl border border-slate-300 py-2.5 pl-10 pr-4 text-sm focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-100"
            />
          </div>
        </div>

        {/* Tabla de usuarios */}
        <div className="overflow-hidden rounded-[28px] border border-slate-200/80 bg-white/95 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.24)]">
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead>
                <tr className="border-b border-slate-200 bg-slate-50/80">
                  <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Usuario</th>
                  <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Email</th>
                  <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Rol</th>
                  <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">ODS</th>
                  <th className="px-5 py-3 text-right text-xs font-semibold text-slate-600 uppercase tracking-wider">Acciones</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {filteredUsers.length > 0 ? (
                  filteredUsers.map(u => (
                    <tr key={u.id} className="transition-colors hover:bg-emerald-50/30">
                      <td className="px-5 py-3.5">
                        <div className="flex items-center gap-3">
                          <div className="flex h-9 w-9 items-center justify-center rounded-2xl bg-gradient-to-br from-emerald-500 to-emerald-600 text-xs font-medium text-white">
                            {u.name?.charAt(0).toUpperCase()}
                          </div>
                          <span className="text-sm font-medium text-slate-900">{u.name}</span>
                        </div>
                      </td>
                      <td className="px-5 py-3.5 text-sm text-slate-600">{u.email}</td>
                      <td className="px-5 py-3.5">
                        <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded ${
                          u.role === 'admin' ? 'bg-teal-50 text-teal-700' :
                          u.role === 'profesional_proyectos' ? 'bg-blue-50 text-blue-700' :
                          u.role === 'interventoria' ? 'bg-amber-50 text-amber-700' :
                          u.role === 'gerencia' ? 'bg-slate-100 text-slate-700' :
                          'bg-slate-100 text-slate-700'
                        }`}>
                          {u.role || 'Sin rol'}
                        </span>
                      </td>
                      <td className="px-5 py-3.5 text-sm text-slate-600 max-w-[200px]">
                        {u.service_orders?.length > 0 ? (
                          <span className="flex flex-wrap gap-1">
                            {u.service_orders.map(so => (
                              <span key={so.id} className="inline-flex px-1.5 py-0.5 text-xs font-mono bg-slate-100 text-slate-700 rounded">
                                {so.ods_code}
                              </span>
                            ))}
                          </span>
                        ) : (
                          <span className="text-slate-400">—</span>
                        )}
                      </td>
                      <td className="px-5 py-3.5">
                        <div className="flex items-center justify-end gap-2">
                          <button
                            onClick={() => handleEdit(u)}
                            className="rounded-xl p-1.5 text-slate-500 transition-colors hover:bg-emerald-50 hover:text-emerald-600"
                            title="Editar"
                          >
                            <Pencil className="w-4 h-4" />
                          </button>
                          <button
                            onClick={() => setShowDeleteConfirm(u.id)}
                            className="rounded-xl p-1.5 text-slate-500 transition-colors hover:bg-rose-50 hover:text-rose-600"
                            title="Eliminar"
                          >
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="5" className="px-5 py-12 text-center">
                      <div className="flex flex-col items-center">
                        <Users className="w-10 h-10 text-slate-300 mb-3" strokeWidth={1.5} />
                        <p className="text-sm font-medium text-slate-900 mb-1">
                          {searchTerm ? 'No se encontraron usuarios' : 'No hay usuarios registrados'}
                        </p>
                        <p className="text-sm text-slate-500">
                          {searchTerm ? 'Intenta con otro término de búsqueda' : 'Crea tu primer usuario para comenzar'}
                        </p>
                      </div>
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Contador */}
        {users.length > 0 && (
          <p className="mt-4 text-sm text-slate-500">
            Mostrando {filteredUsers.length} de {users.length} usuarios
          </p>
        )}
      </div>

      {/* Modal de confirmación de eliminación */}
      {showDeleteConfirm && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="w-full max-w-md rounded-[28px] border border-slate-200 bg-white p-6 shadow-xl">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-rose-100 rounded-full flex items-center justify-center">
                <AlertTriangle className="w-5 h-5 text-rose-600" />
              </div>
              <div>
                <h3 className="text-lg font-semibold text-slate-900">Eliminar Usuario</h3>
                <p className="text-sm text-slate-500">Esta acción no se puede deshacer</p>
              </div>
            </div>
            <p className="text-slate-600 mb-6">
              ¿Estás seguro de que deseas eliminar este usuario? Si tiene reportes o vínculos asociados, no podrá ser eliminado.
            </p>
            <div className="flex justify-end gap-3">
              <button
                onClick={() => setShowDeleteConfirm(null)}
                disabled={deleting}
                className="px-4 py-2 text-sm font-medium text-slate-700 bg-slate-100 rounded-lg hover:bg-slate-200 transition-colors disabled:opacity-50"
              >
                Cancelar
              </button>
              <button
                onClick={() => handleDelete(showDeleteConfirm)}
                disabled={deleting}
                className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-rose-600 rounded-lg hover:bg-rose-700 transition-colors disabled:opacity-50"
              >
                {deleting ? (
                  <Loader2 className="w-4 h-4 animate-spin" />
                ) : (
                  <Trash2 className="w-4 h-4" />
                )}
                {deleting ? 'Eliminando...' : 'Eliminar'}
              </button>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
}
