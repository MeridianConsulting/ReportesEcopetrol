// components/AssignTaskModal.js
'use client';

import { useState, useEffect } from 'react';
import { apiRequest } from '../lib/api';
import Alert from './Alert';
import { 
  X, 
  Send, 
  Search, 
  Loader2, 
  User,
  FileText,
  Building2,
  CheckCircle2,
  ChevronLeft,
  Calendar,
  Flag,
  AlertCircle,
  BarChart3
} from 'lucide-react';

export default function AssignTaskModal({ isOpen, onClose, onSuccess, currentUser = null }) {
  const [step, setStep] = useState(1); // 1: seleccionar usuario, 2: crear tarea
  const [users, setUsers] = useState([]);
  const [areas, setAreas] = useState([]);
  const [kpiCategories, setKpiCategories] = useState([]);
  const [filteredUsers, setFilteredUsers] = useState([]);
  const [filteredKpiCategories, setFilteredKpiCategories] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState(null);
  
  // Datos de la tarea
  const [taskData, setTaskData] = useState({
    title: '',
    description: '',
    priority: 'Media',
    area_id: '',
    kpi_category_id: '',
    start_date: new Date().toISOString().split('T')[0],
    due_date: '',
    message: ''
  });

  useEffect(() => {
    if (isOpen) {
      loadData();
      resetForm();
    }
  }, [isOpen]);

  useEffect(() => {
    if (searchTerm) {
      const filtered = users.filter(user => 
        user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (user.area_name && user.area_name.toLowerCase().includes(searchTerm.toLowerCase()))
      );
      setFilteredUsers(filtered);
    } else {
      setFilteredUsers(users);
    }
  }, [searchTerm, users]);

  // Filtrar categorías KPI cuando cambia el usuario seleccionado (soportar múltiples áreas)
  useEffect(() => {
    if (selectedUser) {
      // Usar area_ids si existen, sino fallback a area_id
      const userAreaIds = (selectedUser.area_ids || []).map(id => parseInt(id, 10));
      const singleAreaId = selectedUser.area_id ? parseInt(selectedUser.area_id, 10) : null;
      const allAreaIds = userAreaIds.length > 0 ? userAreaIds : (singleAreaId ? [singleAreaId] : []);

      if (allAreaIds.length > 0) {
        const categoriesForAreas = kpiCategories.filter(cat => {
          const catAreaId = parseInt(cat.area_id, 10);
          return allAreaIds.includes(catAreaId);
        });
        setFilteredKpiCategories(categoriesForAreas);
      } else {
        setFilteredKpiCategories([]);
      }
    } else {
      setFilteredKpiCategories([]);
    }
  }, [selectedUser, kpiCategories]);

  function resetForm() {
    setStep(1);
    setSelectedUser(null);
    setSearchTerm('');
    setSuccess(false);
    setError(null);
    setFilteredKpiCategories([]);
    setTaskData({
      title: '',
      description: '',
      priority: 'Media',
      area_id: '',
      kpi_category_id: '',
      start_date: new Date().toISOString().split('T')[0],
      due_date: '',
      message: ''
    });
  }

  async function loadData() {
    setLoading(true);
    try {
      const [usersData, areasData, kpiCategoriesData] = await Promise.all([
        apiRequest('/users/assignable'),
        apiRequest('/areas'),
        apiRequest('/kpi-categories?all=true')
      ]);
      setUsers(usersData.data || []);
      setFilteredUsers(usersData.data || []);
      setAreas(areasData.data || []);
      // Usar 'flat' para obtener la lista plana de categorías
      const categories = kpiCategoriesData.flat || [];
      setKpiCategories(categories);
    } catch (e) {
      console.error('Error loading data:', e);
    } finally {
      setLoading(false);
    }
  }

  function handleSelectUser(user) {
    setSelectedUser(user);
    // Si el usuario tiene área, preseleccionarla y bloquearla
    if (user.area_id) {
      setTaskData(prev => ({ 
        ...prev, 
        area_id: user.area_id,
        kpi_category_id: '' // Resetear categoría KPI al cambiar de usuario
      }));
    }
    setStep(2);
  }

  // Manejar cambio de categoría KPI
  function handleKpiCategoryChange(categoryId) {
    const selectedCategory = kpiCategories.find(cat => cat.id == categoryId);
    setTaskData(prev => ({
      ...prev,
      kpi_category_id: categoryId || '',
      // Si la categoría tiene área, forzarla (aunque debería ser la misma del usuario)
      area_id: selectedCategory ? selectedCategory.area_id : prev.area_id
    }));
  }

  // Normalizar fechas: convertir vacías a null
  function normalizeDates(data) {
    const normalized = { ...data };
    if (!normalized.start_date || normalized.start_date === '') {
      normalized.start_date = null;
    }
    if (!normalized.due_date || normalized.due_date === '') {
      normalized.due_date = null;
    }
    return normalized;
  }

  async function handleSubmit(e) {
    e.preventDefault();
    if (!selectedUser || !taskData.title) return;

    // Validar que area_id esté presente y sea válido
    if (!taskData.area_id || taskData.area_id === '') {
      setError('Debes seleccionar un área para la tarea');
      return;
    }

    // Validar que las fechas no sean pasadas
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];
    
    if (taskData.start_date) {
      if (taskData.start_date < todayStr) {
        setError('La fecha de inicio no puede ser una fecha pasada');
        return;
      }
    }
    
    if (taskData.due_date) {
      if (taskData.due_date < todayStr) {
        setError('La fecha de vencimiento no puede ser una fecha pasada');
        return;
      }
      
      if (taskData.start_date) {
        if (taskData.due_date < taskData.start_date) {
          setError('La fecha de vencimiento debe ser igual o posterior a la fecha de inicio');
          return;
        }
      }
    }

    setSubmitting(true);
    setError(null);
    try {
      const areaId = parseInt(taskData.area_id, 10);
      const responsibleId = parseInt(selectedUser.id, 10);
      
      if (isNaN(areaId) || areaId <= 0) {
        setError('El área seleccionada no es válida');
        setSubmitting(false);
        return;
      }
      
      if (isNaN(responsibleId) || responsibleId <= 0) {
        setError('El usuario seleccionado no es válido');
        setSubmitting(false);
        return;
      }
      
      const taskPayload = normalizeDates({
        ...taskData,
        area_id: areaId,
        responsible_id: responsibleId,
        kpi_category_id: taskData.kpi_category_id ? parseInt(taskData.kpi_category_id, 10) : null,
        status: 'No iniciada',
        progress_percent: 0
      });

      // 1. Crear la tarea asignada al usuario seleccionado
      const newTask = await apiRequest('/tasks', {
        method: 'POST',
        body: JSON.stringify(taskPayload)
      });

      // 2. Crear la asignación/notificación
      await apiRequest('/assignments', {
        method: 'POST',
        body: JSON.stringify({
          task_id: newTask.data.id,
          assigned_to: selectedUser.id,
          message: taskData.message || null
        })
      });

      setSuccess(true);
      setTimeout(() => {
        onSuccess?.();
        onClose();
      }, 1500);
    } catch (e) {
      if (e.error) {
        if (e.error.errors) {
          const errorMessages = Object.values(e.error.errors).join(', ');
          setError('Error de validación: ' + errorMessages);
        } else if (e.error.message) {
          setError('Error: ' + e.error.message + (e.error.details ? ' (' + e.error.details + ')' : ''));
        } else {
          setError('Error al crear y asignar tarea: ' + (e.message || 'Error desconocido'));
        }
      } else {
        setError('Error al crear y asignar tarea: ' + (e.message || 'Error desconocido'));
      }
    } finally {
      setSubmitting(false);
    }
  }

  if (!isOpen) return null;

  // Obtener nombre del área del usuario seleccionado
  const selectedUserAreaName = selectedUser?.area_name || 
    areas.find(a => a.id == selectedUser?.area_id)?.name || 
    'Sin área';

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-xl w-full max-w-lg shadow-xl overflow-hidden max-h-[90vh] flex flex-col">
        {/* Header */}
        <div className="bg-gradient-to-r from-indigo-600 to-indigo-700 px-6 py-4 flex-shrink-0">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              {step === 2 && (
                <button
                  onClick={() => setStep(1)}
                  className="p-1.5 text-white/80 hover:text-white hover:bg-white/10 rounded-lg transition-colors"
                >
                  <ChevronLeft className="w-5 h-5" />
                </button>
              )}
              <div>
                <h2 className="text-lg font-semibold text-white">
                  {step === 1 ? 'Asignar Nueva Tarea' : 'Crear Tarea'}
                </h2>
                <p className="text-indigo-200 text-sm">
                  {step === 1 
                    ? 'Paso 1: Selecciona a quién asignar' 
                    : `Paso 2: Crear tarea para ${selectedUser?.name}`}
                </p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="p-2 text-white/80 hover:text-white hover:bg-white/10 rounded-lg transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {success ? (
          <div className="p-8 text-center">
            <div className="w-16 h-16 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <CheckCircle2 className="w-8 h-8 text-emerald-600" />
            </div>
            <h3 className="text-lg font-semibold text-slate-900 mb-2">Tarea Creada y Asignada</h3>
            <p className="text-slate-600">
              La tarea ha sido creada y asignada a {selectedUser?.name}
            </p>
          </div>
        ) : step === 1 ? (
          /* PASO 1: Seleccionar Usuario */
          <div className="p-6 overflow-y-auto flex-1">
            {error && (
              <div className="mb-4">
                <Alert
                  type="error"
                  dismissible
                  onDismiss={() => setError(null)}
                >
                  {error}
                </Alert>
              </div>
            )}
            
            {/* Buscador */}
            <div className="mb-4">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={e => setSearchTerm(e.target.value)}
                  placeholder="Buscar por nombre, email o área..."
                  className="w-full pl-10 pr-4 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                />
              </div>
            </div>

            {/* Lista de usuarios */}
            <div className="border border-slate-200 rounded-lg overflow-hidden">
              {loading ? (
                <div className="flex items-center justify-center py-12">
                  <Loader2 className="w-6 h-6 text-indigo-600 animate-spin" />
                </div>
              ) : filteredUsers.length > 0 ? (
                <div className="divide-y divide-slate-100 max-h-80 overflow-y-auto">
                  {filteredUsers.map(user => (
                    <button
                      key={user.id}
                      type="button"
                      onClick={() => handleSelectUser(user)}
                      className="w-full px-4 py-3 flex items-center gap-3 hover:bg-indigo-50 transition-colors text-left"
                    >
                      <div className="w-10 h-10 bg-slate-700 rounded-full flex items-center justify-center text-white font-medium flex-shrink-0">
                        {user.name?.charAt(0).toUpperCase()}
                      </div>
                      <div className="flex-1 min-w-0">
                        <span className="text-sm font-medium text-slate-900">
                          {user.name}
                        </span>
                        <div className="flex items-center gap-2 text-xs text-slate-500 mt-0.5">
                          <span className="truncate">{user.email}</span>
                          {user.area_name && (
                            <>
                              <span>•</span>
                              <span className="flex items-center gap-1">
                                <Building2 className="w-3 h-3" />
                                {user.area_name}
                              </span>
                            </>
                          )}
                        </div>
                      </div>
                      <Send className="w-4 h-4 text-slate-400" />
                    </button>
                  ))}
                </div>
              ) : (
                <div className="py-12 text-center">
                  <User className="w-10 h-10 text-slate-300 mx-auto mb-3" />
                  <p className="text-sm font-medium text-slate-900 mb-1">No se encontraron usuarios</p>
                  <p className="text-xs text-slate-500">Intenta con otro término de búsqueda</p>
                </div>
              )}
            </div>
          </div>
        ) : (
          /* PASO 2: Crear Tarea */
          <form onSubmit={handleSubmit} className="p-6 overflow-y-auto flex-1">
            {error && (
              <div className="mb-4">
                <Alert
                  type="error"
                  dismissible
                  onDismiss={() => setError(null)}
                >
                  {error}
                </Alert>
              </div>
            )}

            {/* Usuario seleccionado con información del área */}
            <div className="bg-indigo-50 rounded-lg p-3 mb-5">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-indigo-600 rounded-full flex items-center justify-center text-white font-medium">
                  {selectedUser?.name?.charAt(0).toUpperCase()}
                </div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-slate-900">{selectedUser?.name}</p>
                  <p className="text-xs text-slate-600">{selectedUser?.email}</p>
                </div>
                <div className="text-right">
                  <div className="flex items-center gap-1 text-xs text-indigo-700 bg-indigo-100 px-2 py-1 rounded-lg">
                    <Building2 className="w-3 h-3" />
                    {selectedUserAreaName}
                  </div>
                </div>
              </div>
              <p className="mt-2 text-xs text-indigo-600">
                💡 Los KPIs disponibles corresponden al área: <strong>{selectedUserAreaName}</strong>
              </p>
              {currentUser?.role === 'lider_area' && selectedUser?.role_name === 'lider_area' && (() => {
                const myAreaIds = currentUser.area_ids || (currentUser.area_id ? [currentUser.area_id] : []);
                const isOtherAreaLeader = selectedUser.area_id && !myAreaIds.includes(selectedUser.area_id);
                return isOtherAreaLeader ? (
                  <p className="mt-2 text-xs text-amber-700 bg-amber-50 border border-amber-200 rounded px-2 py-1.5">
                    Esta tarea será gestionada por el líder del área destino, quien la reasignará a su equipo.
                  </p>
                ) : null;
              })()}
            </div>

            {/* Categoría KPI (filtrada por área del usuario) */}
            <div className="mb-4">
              <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                <span className="flex items-center gap-1">
                  <BarChart3 className="w-3.5 h-3.5" />
                  Categoría KPI
                  <span className="font-normal normal-case text-slate-400">(indicador a medir)</span>
                </span>
              </label>
              <select
                value={taskData.kpi_category_id || ''}
                onChange={e => handleKpiCategoryChange(e.target.value)}
                className="w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 bg-white"
              >
                <option value="">Sin KPI (tarea no medible)</option>
                {filteredKpiCategories.length > 0 ? (
                  filteredKpiCategories.map(cat => (
                    <option key={`kpi-${cat.id}`} value={cat.id}>
                      {cat.name}
                    </option>
                  ))
                ) : (
                  <option disabled>No hay KPIs para esta área</option>
                )}
              </select>
              {filteredKpiCategories.length === 0 && selectedUser?.area_id && (
                <p className="mt-1 text-xs text-amber-600">
                  ⚠️ No hay categorías KPI configuradas para el área {selectedUserAreaName}
                </p>
              )}
              {taskData.kpi_category_id && (
                <p className="mt-1 text-xs text-emerald-600">
                  ✓ Esta tarea contribuirá al KPI seleccionado
                </p>
              )}
            </div>

            {/* Título */}
            <div className="mb-4">
              <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                Título de la tarea <span className="text-rose-500">*</span>
              </label>
              <input
                type="text"
                value={taskData.title}
                onChange={e => setTaskData({ ...taskData, title: e.target.value })}
                required
                placeholder="¿Qué debe hacer?"
                className="w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              />
            </div>

            {/* Descripción */}
            <div className="mb-4">
              <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                Descripción
              </label>
              <textarea
                value={taskData.description}
                onChange={e => setTaskData({ ...taskData, description: e.target.value })}
                placeholder="Detalles adicionales de la tarea..."
                rows={2}
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 resize-none"
              />
            </div>

            {/* Prioridad */}
            <div className="mb-4">
              <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                Prioridad
              </label>
              <select
                value={taskData.priority}
                onChange={e => setTaskData({ ...taskData, priority: e.target.value })}
                className="w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 bg-white"
              >
                <option value="Alta">Alta</option>
                <option value="Media">Media</option>
                <option value="Baja">Baja</option>
              </select>
            </div>

            {/* Área (bloqueada, heredada del usuario) */}
            <div className="mb-4">
              <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                Área <span className="text-rose-500">*</span>
              </label>
              <div className="relative">
                <select
                  value={taskData.area_id}
                  onChange={e => setTaskData({ ...taskData, area_id: e.target.value, kpi_category_id: '' })}
                  disabled={!!selectedUser?.area_id}
                  className={`w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 ${
                    selectedUser?.area_id ? 'bg-slate-100 cursor-not-allowed text-slate-500' : 'bg-white'
                  }`}
                >
                  <option value="">Seleccionar área</option>
                  {areas.map(area => (
                    <option key={area.id} value={area.id}>{area.name}</option>
                  ))}
                </select>
              </div>
              {selectedUser?.area_id && (
                <p className="mt-1 text-xs text-slate-500">
                  🔒 Área definida por el usuario asignado
                </p>
              )}
            </div>

            {/* Fechas */}
            <div className="grid grid-cols-2 gap-4 mb-4">
              <div>
                <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                  Fecha inicio
                </label>
                <input
                  type="date"
                  value={taskData.start_date}
                  onChange={e => setTaskData({ ...taskData, start_date: e.target.value })}
                  className="w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                  Fecha límite
                </label>
                <input
                  type="date"
                  value={taskData.due_date}
                  onChange={e => setTaskData({ ...taskData, due_date: e.target.value })}
                  className="w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500"
                />
              </div>
            </div>

            {/* Mensaje para el usuario */}
            <div className="mb-6">
              <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                Mensaje para {selectedUser?.name?.split(' ')[0]} (opcional)
              </label>
              <textarea
                value={taskData.message}
                onChange={e => setTaskData({ ...taskData, message: e.target.value })}
                placeholder="Añade instrucciones o comentarios personales..."
                rows={2}
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 resize-none"
              />
            </div>

            {/* Botones */}
            <div className="flex justify-end gap-3">
              <button
                type="button"
                onClick={onClose}
                className="px-4 py-2.5 text-sm font-medium text-slate-700 bg-slate-100 rounded-lg hover:bg-slate-200 transition-colors"
              >
                Cancelar
              </button>
              <button
                type="submit"
                disabled={!taskData.title || submitting}
                className="inline-flex items-center gap-2 px-5 py-2.5 text-sm font-medium text-white bg-indigo-600 rounded-lg hover:bg-indigo-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {submitting ? (
                  <Loader2 className="w-4 h-4 animate-spin" />
                ) : (
                  <Send className="w-4 h-4" />
                )}
                {submitting ? 'Creando...' : 'Crear y Asignar'}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}
