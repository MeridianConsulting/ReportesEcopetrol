'use client';

import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import {
  BriefcaseBusiness,
  ClipboardList,
  Filter,
  Loader2,
  Pencil,
  Plus,
  Search,
  Trash2,
  Users,
} from 'lucide-react';
import Layout from '../../../components/Layout';
import Alert from '../../../components/Alert';
import ConfirmDialog from '../../../components/ConfirmDialog';
import OdsActivityFormModal from '../../../components/OdsActivityFormModal';
import { apiRequest } from '../../../lib/api';

const STATUS_OPTIONS = ['all', 'Borrador', 'Activa', 'En pausa', 'Finalizada', 'Cancelada'];

function formatDate(dateString) {
  if (!dateString) return '—';
  return new Intl.DateTimeFormat('es-CO', {
    dateStyle: 'medium',
  }).format(new Date(`${dateString}T00:00:00`));
}

function formatDateTime(dateString) {
  if (!dateString) return '—';
  return new Intl.DateTimeFormat('es-CO', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(dateString));
}

function getStatusClasses(status) {
  switch (status) {
    case 'Activa':
      return 'bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200';
    case 'En pausa':
      return 'bg-amber-50 text-amber-700 ring-1 ring-amber-200';
    case 'Finalizada':
      return 'bg-sky-50 text-sky-700 ring-1 ring-sky-200';
    case 'Cancelada':
      return 'bg-rose-50 text-rose-700 ring-1 ring-rose-200';
    default:
      return 'bg-slate-100 text-slate-700 ring-1 ring-slate-200';
  }
}

export default function OdsActivitiesPage() {
  const router = useRouter();
  const [currentUser, setCurrentUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [loadingActivities, setLoadingActivities] = useState(true);
  const [saving, setSaving] = useState(false);
  const [deletingId, setDeletingId] = useState(null);
  const [activities, setActivities] = useState([]);
  const [serviceOrders, setServiceOrders] = useState([]);
  const [deliveryMedia, setDeliveryMedia] = useState([]);
  const [users, setUsers] = useState([]);
  const [filters, setFilters] = useState({
    service_order_id: '',
    assigned_user_id: '',
    status: 'all',
    search: '',
  });
  const [alert, setAlert] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingActivity, setEditingActivity] = useState(null);
  const [activityToDelete, setActivityToDelete] = useState(null);

  useEffect(() => {
    let cancelled = false;

    async function loadInitialData() {
      try {
        const [meData, serviceOrdersData, deliveryMediaData, usersData] = await Promise.all([
          apiRequest('/auth/me'),
          apiRequest('/reports/service-orders'),
          apiRequest('/reports/delivery-media').catch(() => ({ data: [] })),
          apiRequest('/users'),
        ]);

        if (cancelled) return;

        if (meData?.data?.role !== 'admin') {
          router.push('/my-tasks/');
          return;
        }

        setCurrentUser(meData.data);
        setServiceOrders(serviceOrdersData.data || []);
        setDeliveryMedia(deliveryMediaData.data || []);
        setUsers(usersData.data || []);
      } catch (error) {
        if (!cancelled) {
          router.push('/login/');
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }

    loadInitialData();

    return () => {
      cancelled = true;
    };
  }, [router]);

  useEffect(() => {
    if (!currentUser) return;

    let cancelled = false;

    async function loadActivities() {
      try {
        setLoadingActivities(true);
        const searchParams = new URLSearchParams();

        if (filters.service_order_id) {
          searchParams.set('service_order_id', filters.service_order_id);
        }
        if (filters.assigned_user_id) {
          searchParams.set('assigned_user_id', filters.assigned_user_id);
        }
        if (filters.status && filters.status !== 'all') {
          searchParams.set('status', filters.status);
        }
        if (filters.search.trim()) {
          searchParams.set('search', filters.search.trim());
        }

        const response = await apiRequest(
          `/admin/ods-activities${searchParams.toString() ? `?${searchParams.toString()}` : ''}`
        );

        if (!cancelled) {
          setActivities(response.data || []);
        }
      } catch (error) {
        if (!cancelled) {
          setAlert({
            type: 'error',
            message: error.message || 'No fue posible cargar las actividades.',
          });
        }
      } finally {
        if (!cancelled) {
          setLoadingActivities(false);
        }
      }
    }

    loadActivities();

    return () => {
      cancelled = true;
    };
  }, [currentUser, filters]);

  const filteredUsersForSelect = useMemo(() => {
    if (!filters.service_order_id) return users;
    return users.filter((user) =>
      Array.isArray(user.service_order_ids) &&
      user.service_order_ids.map(Number).includes(Number(filters.service_order_id))
    );
  }, [filters.service_order_id, users]);

  useEffect(() => {
    if (!filters.assigned_user_id) return;
    const exists = filteredUsersForSelect.some(
      (user) => Number(user.id) === Number(filters.assigned_user_id)
    );

    if (!exists) {
      setFilters((prev) => ({ ...prev, assigned_user_id: '' }));
    }
  }, [filteredUsersForSelect, filters.assigned_user_id]);

  const summary = useMemo(() => {
    return activities.reduce(
      (acc, activity) => {
        acc.total += 1;
        acc.byStatus[activity.status] = (acc.byStatus[activity.status] || 0) + 1;
        acc.assigned += Number(activity.assigned_users_count || 0);
        return acc;
      },
      {
        total: 0,
        assigned: 0,
        byStatus: {},
      }
    );
  }, [activities]);

  function openCreateModal() {
    setEditingActivity(null);
    setIsModalOpen(true);
  }

  function openEditModal(activity) {
    setEditingActivity(activity);
    setIsModalOpen(true);
  }

  function closeModal() {
    if (saving) return;
    setEditingActivity(null);
    setIsModalOpen(false);
  }

  async function refreshActivities() {
    const searchParams = new URLSearchParams();

    if (filters.service_order_id) {
      searchParams.set('service_order_id', filters.service_order_id);
    }
    if (filters.assigned_user_id) {
      searchParams.set('assigned_user_id', filters.assigned_user_id);
    }
    if (filters.status && filters.status !== 'all') {
      searchParams.set('status', filters.status);
    }
    if (filters.search.trim()) {
      searchParams.set('search', filters.search.trim());
    }

    const response = await apiRequest(
      `/admin/ods-activities${searchParams.toString() ? `?${searchParams.toString()}` : ''}`
    );
    setActivities(response.data || []);
  }

  async function handleSubmitActivity(payload) {
    try {
      setSaving(true);

      if (editingActivity?.id) {
        await apiRequest(`/admin/ods-activities/${editingActivity.id}`, {
          method: 'PUT',
          body: JSON.stringify(payload),
        });
        setAlert({ type: 'success', message: 'Actividad actualizada correctamente.' });
      } else {
        await apiRequest('/admin/ods-activities', {
          method: 'POST',
          body: JSON.stringify(payload),
        });
        setAlert({ type: 'success', message: 'Actividad creada correctamente.' });
      }

      await refreshActivities();
      setIsModalOpen(false);
      setEditingActivity(null);
    } catch (error) {
      setAlert({
        type: 'error',
        message: error.message || 'No fue posible guardar la actividad.',
      });
    } finally {
      setSaving(false);
    }
  }

  async function handleDeleteActivity() {
    if (!activityToDelete?.id) return;

    try {
      setDeletingId(activityToDelete.id);
      await apiRequest(`/admin/ods-activities/${activityToDelete.id}`, {
        method: 'DELETE',
      });
      await refreshActivities();
      setAlert({ type: 'success', message: 'Actividad eliminada correctamente.' });
      setActivityToDelete(null);
    } catch (error) {
      setAlert({
        type: 'error',
        message: error.message || 'No fue posible eliminar la actividad.',
      });
    } finally {
      setDeletingId(null);
    }
  }

  if (loading) {
    return (
      <Layout>
        <div className="flex h-80 items-center justify-center">
          <Loader2 className="h-10 w-10 animate-spin text-slate-500" />
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className="min-h-full bg-[radial-gradient(circle_at_top,_rgba(16,185,129,0.08),_transparent_28%),linear-gradient(to_bottom,_#f8fafc,_#eef2f7)]">
        <div className="mx-auto max-w-7xl space-y-6 p-4 sm:p-6 lg:p-8">
          <section className="overflow-hidden rounded-[28px] border border-slate-200/80 bg-white/95 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.28)]">
            <div className="bg-gradient-to-r from-slate-900 via-slate-800 to-slate-900 px-6 py-6 text-white sm:px-8">
              <div className="flex flex-col gap-5 lg:flex-row lg:items-end lg:justify-between">
                <div className="space-y-3">
                  <div className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs font-medium text-slate-100 backdrop-blur">
                    <ClipboardList className="h-4 w-4" />
                    Módulo administrativo
                  </div>
                  <div>
                    <h1 className="text-2xl font-semibold tracking-tight sm:text-3xl">
                      Gestión de actividades ODS
                    </h1>
                    <p className="mt-2 max-w-3xl text-sm text-slate-300 sm:text-base">
                      Crea, asigna y administra actividades por orden de servicio y profesional. El acceso está restringido a administradores del sistema.
                    </p>
                  </div>
                </div>

                <button
                  type="button"
                  onClick={openCreateModal}
                  className="inline-flex items-center justify-center gap-2 rounded-2xl bg-emerald-500 px-4 py-3 text-sm font-medium text-white shadow-lg shadow-emerald-950/15 transition hover:bg-emerald-400"
                >
                  <Plus className="h-4 w-4" />
                  Nueva actividad
                </button>
              </div>
            </div>

            <div className="grid gap-4 border-t border-slate-200 bg-gradient-to-b from-white to-slate-50/60 p-4 sm:grid-cols-2 xl:grid-cols-4 sm:p-6">
              <StatCard
                icon={<ClipboardList className="h-5 w-5" />}
                label="Actividades visibles"
                value={summary.total}
                helper="Aplicando filtros actuales"
              />
              <StatCard
                icon={<Users className="h-5 w-5" />}
                label="Asignaciones activas"
                value={summary.assigned}
                helper="Profesionales vinculados"
              />
              <StatCard
                icon={<BriefcaseBusiness className="h-5 w-5" />}
                label="Activas"
                value={summary.byStatus['Activa'] || 0}
                helper="En ejecución"
              />
              <StatCard
                icon={<Filter className="h-5 w-5" />}
                label="Finalizadas"
                value={summary.byStatus['Finalizada'] || 0}
                helper="Con cierre registrado"
              />
            </div>
          </section>

          {alert ? (
            <Alert
              type={alert.type}
              dismissible
              onDismiss={() => setAlert(null)}
            >
              {alert.message}
            </Alert>
          ) : null}

          <section className="rounded-[28px] border border-slate-200/80 bg-white/95 p-4 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.24)] sm:p-5">
            <div className="grid gap-4 lg:grid-cols-[1.1fr_1fr_1fr_1.4fr_auto]">
              <label className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                <span className="text-sm font-medium text-slate-700">ODS</span>
                <select
                  value={filters.service_order_id}
                  onChange={(event) =>
                    setFilters((prev) => ({
                      ...prev,
                      service_order_id: event.target.value,
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                >
                  <option value="">Todas</option>
                  {serviceOrders.map((item) => (
                    <option key={item.id} value={item.id}>
                      {item.ods_code}
                    </option>
                  ))}
                </select>
              </label>

              <label className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                <span className="text-sm font-medium text-slate-700">Profesional</span>
                <select
                  value={filters.assigned_user_id}
                  onChange={(event) =>
                    setFilters((prev) => ({
                      ...prev,
                      assigned_user_id: event.target.value,
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                >
                  <option value="">Todos</option>
                  {filteredUsersForSelect.map((user) => (
                    <option key={user.id} value={user.id}>
                      {user.name}
                    </option>
                  ))}
                </select>
              </label>

              <label className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                <span className="text-sm font-medium text-slate-700">Estado</span>
                <select
                  value={filters.status}
                  onChange={(event) =>
                    setFilters((prev) => ({
                      ...prev,
                      status: event.target.value,
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                >
                  {STATUS_OPTIONS.map((status) => (
                    <option key={status} value={status}>
                      {status === 'all' ? 'Todos' : status}
                    </option>
                  ))}
                </select>
              </label>

              <label className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                <span className="text-sm font-medium text-slate-700">Buscar</span>
                <div className="relative">
                  <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                  <input
                    type="text"
                    value={filters.search}
                    onChange={(event) =>
                      setFilters((prev) => ({
                        ...prev,
                        search: event.target.value,
                      }))
                    }
                    placeholder="Título, descripción, ítem, soporte..."
                    className="w-full rounded-2xl border border-slate-300 bg-white py-2.5 pl-9 pr-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                  />
                </div>
              </label>

              <div className="flex items-end">
                <button
                  type="button"
                  onClick={() =>
                    setFilters({
                      service_order_id: '',
                      assigned_user_id: '',
                      status: 'all',
                      search: '',
                    })
                  }
                  className="w-full rounded-2xl border border-slate-300 bg-white px-4 py-2.5 text-sm font-medium text-slate-700 transition hover:bg-slate-50"
                >
                  Limpiar
                </button>
              </div>
            </div>
          </section>

          <section className="overflow-hidden rounded-[28px] border border-slate-200/80 bg-white/95 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.24)]">
            <div className="flex items-center justify-between border-b border-slate-200 px-4 py-4 sm:px-5">
              <div>
                <h2 className="text-base font-semibold text-slate-900">Actividades registradas</h2>
                <p className="mt-1 text-sm text-slate-500">
                  Tabla principal con búsqueda, filtros, edición y eliminación segura.
                </p>
              </div>
            </div>

            <div className="overflow-x-auto">
              <table className="min-w-[1200px] w-full text-sm">
                <thead className="bg-slate-100 text-slate-700">
                  <tr>
                    <th className="px-4 py-3 text-left font-semibold">ODS</th>
                    <th className="px-4 py-3 text-left font-semibold">Actividad</th>
                    <th className="px-4 py-3 text-left font-semibold">Profesionales</th>
                    <th className="px-4 py-3 text-left font-semibold">Estado</th>
                    <th className="px-4 py-3 text-left font-semibold">Días</th>
                    <th className="px-4 py-3 text-left font-semibold">Vigencia</th>
                    <th className="px-4 py-3 text-left font-semibold">Actualización</th>
                    <th className="px-4 py-3 text-right font-semibold">Acciones</th>
                  </tr>
                </thead>
                <tbody className="bg-white">
                  {loadingActivities ? (
                    <tr>
                      <td colSpan={8} className="px-4 py-12 text-center">
                        <div className="inline-flex items-center gap-2 text-sm text-slate-500">
                          <Loader2 className="h-4 w-4 animate-spin" />
                          Cargando actividades...
                        </div>
                      </td>
                    </tr>
                  ) : activities.length === 0 ? (
                    <tr>
                      <td colSpan={8} className="px-4 py-14 text-center">
                        <div className="flex flex-col items-center gap-2 text-slate-500">
                          <ClipboardList className="h-10 w-10 text-slate-300" />
                          <p className="text-sm font-medium text-slate-900">
                            No hay actividades registradas con los filtros actuales.
                          </p>
                          <p className="text-sm text-slate-500">
                            Crea una nueva actividad o ajusta la búsqueda.
                          </p>
                        </div>
                      </td>
                    </tr>
                  ) : (
                    activities.map((activity) => (
                      <tr key={activity.id} className="border-t border-slate-200 align-top hover:bg-emerald-50/30">
                        <td className="px-4 py-4">
                          <div className="space-y-1">
                            <p className="font-semibold text-slate-900">{activity.ods_code}</p>
                            <p className="max-w-[280px] text-xs text-slate-500">
                              {activity.project_name || 'Sin proyecto asociado'}
                            </p>
                          </div>
                        </td>
                        <td className="px-4 py-4">
                          <div className="space-y-2">
                            <p className="font-semibold text-slate-900">{activity.title}</p>
                            <p className="max-w-[360px] whitespace-normal text-slate-600">
                              {activity.description}
                            </p>
                            <div className="flex flex-wrap gap-2 text-xs text-slate-500">
                              {activity.item_general ? (
                                <span className="rounded-full bg-slate-100 px-2.5 py-1">
                                  Ítem general: {activity.item_general}
                                </span>
                              ) : null}
                              {activity.item_activity ? (
                                <span className="rounded-full bg-slate-100 px-2.5 py-1">
                                  Ítem actividad: {activity.item_activity}
                                </span>
                              ) : null}
                            </div>
                          </div>
                        </td>
                        <td className="px-4 py-4">
                          <div className="flex max-w-[270px] flex-wrap gap-2">
                            {activity.assigned_users?.length ? (
                              activity.assigned_users.map((user) => (
                                <span
                                  key={user.id}
                                  className="inline-flex rounded-full bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-700"
                                >
                                  {user.name}
                                </span>
                              ))
                            ) : (
                              <span className="text-slate-400">Sin asignaciones</span>
                            )}
                          </div>
                        </td>
                        <td className="px-4 py-4">
                          <span
                            className={`inline-flex rounded-full px-2.5 py-1 text-xs font-medium ${getStatusClasses(
                              activity.status
                            )}`}
                          >
                            {activity.status}
                          </span>
                        </td>
                        <td className="px-4 py-4 text-slate-700">
                          {activity.contracted_days ?? '—'}
                        </td>
                        <td className="px-4 py-4 text-slate-700">
                          <div className="space-y-1">
                            <p>{formatDate(activity.planned_start_date)}</p>
                            <p className="text-xs text-slate-500">
                              hasta {formatDate(activity.planned_end_date)}
                            </p>
                          </div>
                        </td>
                        <td className="px-4 py-4 text-slate-700">
                          <div className="space-y-1">
                            <p className="text-sm text-slate-900">{formatDateTime(activity.updated_at)}</p>
                            <p className="text-xs text-slate-500">
                              por {activity.updated_by_name || activity.created_by_name || 'Sistema'}
                            </p>
                          </div>
                        </td>
                        <td className="px-4 py-4">
                          <div className="flex items-center justify-end gap-2">
                            <button
                              type="button"
                              onClick={() => openEditModal(activity)}
                              className="rounded-xl p-2 text-slate-500 transition hover:bg-emerald-50 hover:text-emerald-700"
                              title="Editar actividad"
                            >
                              <Pencil className="h-4 w-4" />
                            </button>
                            <button
                              type="button"
                              onClick={() => setActivityToDelete(activity)}
                              className="rounded-xl p-2 text-slate-500 transition hover:bg-rose-50 hover:text-rose-600"
                              title="Eliminar actividad"
                            >
                              <Trash2 className="h-4 w-4" />
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </section>
        </div>
      </div>

      <OdsActivityFormModal
        key={`${isModalOpen ? editingActivity?.id ?? 'new' : 'closed'}`}
        isOpen={isModalOpen}
        activity={editingActivity}
        serviceOrders={serviceOrders}
        users={users}
        deliveryMedia={deliveryMedia}
        saving={saving}
        onClose={closeModal}
        onSubmit={handleSubmitActivity}
      />

      <ConfirmDialog
        isOpen={Boolean(activityToDelete)}
        title="Eliminar actividad"
        message={
          activityToDelete
            ? `Se eliminará de forma segura la actividad "${activityToDelete.title}" y se desactivarán sus asignaciones actuales.`
            : ''
        }
        confirmText="Eliminar"
        cancelText="Cancelar"
        type="error"
        loading={deletingId !== null}
        onCancel={() => {
          if (deletingId !== null) return;
          setActivityToDelete(null);
        }}
        onConfirm={handleDeleteActivity}
      />
    </Layout>
  );
}

function StatCard({ icon, label, value, helper }) {
  return (
    <div className="rounded-3xl border border-slate-200 bg-white p-4 shadow-sm shadow-slate-200/60 transition-transform duration-200 hover:-translate-y-0.5">
      <div className="flex items-center gap-3">
        <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-gradient-to-br from-emerald-50 to-white text-emerald-700 shadow-sm ring-1 ring-emerald-100">
          {icon}
        </div>
        <div className="min-w-0">
          <p className="text-xs font-medium uppercase tracking-wide text-slate-500">{label}</p>
          <p className="mt-1 text-2xl font-semibold tracking-tight text-slate-900">{value}</p>
          <p className="mt-1 text-xs text-slate-500">{helper}</p>
        </div>
      </div>
    </div>
  );
}
