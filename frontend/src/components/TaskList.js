// components/TaskList.js
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import TaskModal from './TaskModal';
import ConfirmDialog from './ConfirmDialog';
import { apiRequest } from '../lib/api';
import { 
  Key, 
  Settings, 
  TrendingUp, 
  FileText, 
  File,
  AlertCircle,
  Pencil,
  Trash2,
  Calendar
} from 'lucide-react';

export default function TaskList({ tasks, onRefresh }) {
  const router = useRouter();
  const [selectedTask, setSelectedTask] = useState(null);
  const [showEditModal, setShowEditModal] = useState(false);
  const [taskToDelete, setTaskToDelete] = useState(null);
  const [deleting, setDeleting] = useState(false);

  const getPriorityConfig = (priority) => {
    const config = {
      'Alta': { bg: 'bg-rose-50', text: 'text-rose-700', border: 'border-rose-200' },
      'Media': { bg: 'bg-amber-50', text: 'text-amber-700', border: 'border-amber-200' },
      'Baja': { bg: 'bg-emerald-50', text: 'text-emerald-700', border: 'border-emerald-200' },
    };
    return config[priority] || { bg: 'bg-slate-50', text: 'text-slate-700', border: 'border-slate-200' };
  };

  const getStatusConfig = (status) => {
    const config = {
      'Completada': { bg: 'bg-emerald-50', text: 'text-emerald-700', border: 'border-emerald-200' },
      'En progreso': { bg: 'bg-teal-50', text: 'text-teal-700', border: 'border-teal-200' },
      'En revisión': { bg: 'bg-teal-50', text: 'text-teal-700', border: 'border-teal-200' },
      'En riesgo': { bg: 'bg-rose-50', text: 'text-rose-700', border: 'border-rose-200' },
      'No iniciada': { bg: 'bg-slate-50', text: 'text-slate-600', border: 'border-slate-200' },
    };
    return config[status] || { bg: 'bg-slate-50', text: 'text-slate-600', border: 'border-slate-200' };
  };

  const getTypeConfig = (type) => {
    const config = {
      'Clave': { icon: Key, color: 'text-amber-600', bg: 'bg-amber-50' },
      'Operativa': { icon: Settings, color: 'text-teal-600', bg: 'bg-teal-50' },
      'Mejora': { icon: TrendingUp, color: 'text-emerald-600', bg: 'bg-emerald-50' },
      'Obligatoria': { icon: FileText, color: 'text-rose-600', bg: 'bg-rose-50' },
    };
    return config[type] || { icon: File, color: 'text-slate-600', bg: 'bg-slate-50' };
  };

  function handleEditTask(task, e) {
    e?.stopPropagation();
    setSelectedTask(task);
    setShowEditModal(true);
  }

  function handleTaskSaved() {
    setShowEditModal(false);
    setSelectedTask(null);
    if (onRefresh) onRefresh();
  }

  async function handleConfirmDelete() {
    if (!taskToDelete) return;
    setDeleting(true);
    try {
      await apiRequest(`/tasks/${taskToDelete.id}`, { method: 'DELETE' });
      setTaskToDelete(null);
      if (onRefresh) onRefresh();
    } catch (err) {
      // Error al eliminar
    } finally {
      setDeleting(false);
    }
  }

  if (!tasks || tasks.length === 0) {
    return (
      <div className="bg-white rounded-xl border border-slate-200 p-12 text-center">
        <div className="w-14 h-14 bg-slate-100 rounded-xl flex items-center justify-center mx-auto mb-4">
          <FileText className="w-7 h-7 text-slate-400" strokeWidth={1.5} />
        </div>
        <h3 className="text-base font-semibold text-slate-900 mb-1">No hay tareas</h3>
        <p className="text-sm text-slate-500">Crea tu primera tarea para comenzar a gestionar tu trabajo</p>
      </div>
    );
  }

  return (
    <>
      <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
        {/* Vista de tabla para escritorio */}
        <div className="hidden lg:block overflow-x-auto">
          <table className="w-full" style={{ tableLayout: 'fixed', minWidth: '800px' }}>
            <thead>
              <tr className="border-b border-slate-200 bg-slate-50/80">
                <th className="w-[26%] px-4 py-3.5 text-center text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Tarea
                </th>
                <th className="w-[14%] px-4 py-3.5 text-center text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Responsable
                </th>
                <th className="w-[10%] px-4 py-3.5 text-center text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Prioridad
                </th>
                <th className="w-[12%] px-4 py-3.5 text-center text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Estado
                </th>
                <th className="w-[11%] px-4 py-3.5 text-center text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Progreso
                </th>
                <th className="w-[11%] px-4 py-3.5 text-center text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Vencimiento
                </th>
                <th className="w-[16%] px-4 py-3.5 text-center text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Acciones
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {tasks.map(t => {
                const priorityConfig = getPriorityConfig(t.priority);
                const statusConfig = getStatusConfig(t.status);
                const typeConfig = getTypeConfig(t.type);
                const TypeIcon = typeConfig.icon;
                const isOverdue = t.due_date && new Date(t.due_date) < new Date() && t.status !== 'Completada';
                
                return (
                  <tr 
                    key={t.id} 
                    className="hover:bg-slate-50/80 cursor-pointer transition-colors duration-150 group"
                    onClick={() => handleEditTask(t)}
                  >
                    <td className="px-4 py-3 align-middle text-center">
                      <div className="flex items-center justify-center gap-3 min-w-0">
                        <div className={`w-8 h-8 ${typeConfig.bg} rounded-lg flex items-center justify-center flex-shrink-0`} title={t.type}>
                          <TypeIcon className={`w-4 h-4 ${typeConfig.color}`} strokeWidth={1.75} />
                        </div>
                        <div className="min-w-0 flex-1 text-left">
                          <p className="font-medium text-slate-900 group-hover:text-green-600 transition-colors truncate text-sm">
                            {t.title}
                          </p>
                          <p className="text-xs text-slate-500 truncate">{t.area_name || 'Sin area'}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-4 py-3 align-middle text-center">
                      <div className="flex items-center justify-center gap-2 min-w-0">
                        <div className="w-7 h-7 bg-slate-700 rounded-full flex items-center justify-center text-white text-xs font-medium flex-shrink-0">
                          {t.responsible_name?.charAt(0).toUpperCase() || '?'}
                        </div>
                        <span className="text-sm text-slate-700 truncate">{t.responsible_name || 'Sin asignar'}</span>
                      </div>
                    </td>
                    <td className="px-4 py-3 align-middle text-center">
                      <span className={`inline-flex items-center justify-center px-2 py-0.5 rounded text-xs font-medium border ${priorityConfig.bg} ${priorityConfig.text} ${priorityConfig.border}`}>
                        {t.priority}
                      </span>
                    </td>
                    <td className="px-4 py-3 align-middle text-center">
                      <span className={`inline-flex items-center justify-center px-2 py-0.5 rounded text-xs font-medium border whitespace-nowrap ${statusConfig.bg} ${statusConfig.text} ${statusConfig.border}`}>
                        <span className="truncate">{t.status}</span>
                      </span>
                    </td>
                    <td className="px-4 py-3 align-middle text-center">
                      <div className="flex items-center justify-center gap-2">
                        <div className="flex-1 min-w-0 max-w-[4rem] h-1.5 bg-slate-200 rounded-full overflow-hidden">
                          <div
                            className={`h-full rounded-full transition-all duration-300 ${
                              t.progress_percent >= 100 ? 'bg-emerald-500' :
                              t.progress_percent >= 50 ? 'bg-teal-500' : 'bg-amber-500'
                            }`}
                            style={{ width: `${t.progress_percent || 0}%` }}
                          ></div>
                        </div>
                        <span className="text-xs font-medium text-slate-600 tabular-nums flex-shrink-0">{t.progress_percent || 0}%</span>
                      </div>
                    </td>
                    <td className="px-4 py-3 align-middle text-center">
                      {t.due_date ? (
                        <div className={`flex items-center justify-center gap-1 text-xs ${isOverdue ? 'text-rose-600 font-medium' : 'text-slate-600'}`}>
                          {isOverdue && <AlertCircle className="w-3.5 h-3.5 flex-shrink-0" strokeWidth={2} />}
                          <Calendar className={`w-3 h-3 flex-shrink-0 ${isOverdue ? 'text-rose-500' : 'text-slate-400'}`} strokeWidth={1.75} />
                          <span className="whitespace-nowrap">{new Date(t.due_date).toLocaleDateString('es-ES', { day: 'numeric', month: 'short' })}</span>
                        </div>
                      ) : (
                        <span className="text-xs text-slate-400">Sin fecha</span>
                      )}
                    </td>
                    <td className="px-4 py-3 align-middle text-center">
                      <div className="flex items-center justify-center gap-1.5 flex-nowrap min-w-0">
                        <button
                          onClick={(e) => handleEditTask(t, e)}
                          className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium text-slate-600 hover:text-green-600 hover:bg-green-50 rounded-md transition-colors flex-shrink-0 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-1"
                        >
                          <Pencil className="w-3.5 h-3.5" strokeWidth={1.75} />
                          Editar
                        </button>
                        <button
                          onClick={(e) => { e.stopPropagation(); setTaskToDelete(t); }}
                          className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium text-slate-600 hover:text-green-600 hover:bg-green-50 rounded-md transition-colors flex-shrink-0 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-1"
                        >
                          <Trash2 className="w-3.5 h-3.5" strokeWidth={1.75} />
                          Eliminar
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {/* Vista de tarjetas para tablet y movil */}
        <div className="lg:hidden divide-y divide-slate-100">
          {tasks.map(t => {
            const priorityConfig = getPriorityConfig(t.priority);
            const statusConfig = getStatusConfig(t.status);
            const typeConfig = getTypeConfig(t.type);
            const TypeIcon = typeConfig.icon;
            const isOverdue = t.due_date && new Date(t.due_date) < new Date() && t.status !== 'Completada';
            
            return (
              <div 
                key={t.id}
                className="p-4 hover:bg-slate-50 active:bg-slate-100 transition-colors cursor-pointer"
                onClick={() => handleEditTask(t)}
              >
                <div className="flex items-start justify-between gap-3 mb-3">
                  <div className="flex items-start gap-3 min-w-0 flex-1">
                    <div className={`w-9 h-9 ${typeConfig.bg} rounded-lg flex items-center justify-center flex-shrink-0`}>
                      <TypeIcon className={`w-4.5 h-4.5 ${typeConfig.color}`} strokeWidth={1.75} />
                    </div>
                    <div className="min-w-0 flex-1">
                      <p className="font-medium text-slate-900 truncate">{t.title}</p>
                      <p className="text-sm text-slate-500 truncate">{t.area_name}</p>
                    </div>
                  </div>
                  <span className={`px-2 py-1 rounded-md text-xs font-medium border flex-shrink-0 ${priorityConfig.bg} ${priorityConfig.text} ${priorityConfig.border}`}>
                    {t.priority}
                  </span>
                </div>
                
                <div className="flex items-center justify-between text-sm mb-3">
                  <div className="flex items-center gap-2 min-w-0 flex-1">
                    <div className="w-6 h-6 bg-slate-700 rounded-full flex items-center justify-center text-white text-xs font-medium flex-shrink-0">
                      {t.responsible_name?.charAt(0).toUpperCase()}
                    </div>
                    <span className="text-slate-600 truncate">{t.responsible_name}</span>
                  </div>
                  <span className={`inline-flex items-center px-2 py-1 rounded-md text-xs font-medium border flex-shrink-0 ${statusConfig.bg} ${statusConfig.text} ${statusConfig.border}`}>
                    {t.status}
                  </span>
                </div>
                
                <div className="flex items-center gap-4">
                  <div className="flex-1">
                    <div className="h-1.5 bg-slate-200 rounded-full overflow-hidden">
                      <div
                        className={`h-full rounded-full ${
                          t.progress_percent >= 100 ? 'bg-emerald-500' :
                          t.progress_percent >= 50 ? 'bg-teal-500' : 'bg-amber-500'
                        }`}
                        style={{ width: `${t.progress_percent || 0}%` }}
                      ></div>
                    </div>
                  </div>
                  <span className="text-xs font-medium text-slate-500 tabular-nums">{t.progress_percent || 0}%</span>
                  {t.due_date && (
                    <div className={`flex items-center gap-1 text-xs flex-shrink-0 ${isOverdue ? 'text-rose-600 font-medium' : 'text-slate-500'}`}>
                      {isOverdue && <AlertCircle className="w-3.5 h-3.5" strokeWidth={2} />}
                      {new Date(t.due_date).toLocaleDateString('es-ES', { day: 'numeric', month: 'short' })}
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Modal de edicion */}
      <TaskModal
        isOpen={showEditModal}
        onClose={() => {
          setShowEditModal(false);
          setSelectedTask(null);
        }}
        task={selectedTask}
        onSave={handleTaskSaved}
      />

      {/* Confirmar eliminar */}
      <ConfirmDialog
        isOpen={!!taskToDelete}
        title="Eliminar tarea"
        message={taskToDelete ? `¿Eliminar la tarea "${taskToDelete.title}"? Esta acción no se puede deshacer.` : ''}
        confirmText="Eliminar"
        cancelText="Cancelar"
        type="error"
        loading={deleting}
        onConfirm={handleConfirmDelete}
        onCancel={() => !deleting && setTaskToDelete(null)}
      />
    </>
  );
}
