// components/TasksSpreadsheet.js
'use client';

import { useState, useEffect, useRef } from 'react';
import { apiRequest } from '../lib/api';
import { 
  Plus, 
  Save, 
  Trash2, 
  Loader2,
  Check,
  X,
  AlertCircle,
  RotateCcw,
  Inbox
} from 'lucide-react';
import Alert from './Alert';
import ConfirmDialog from './ConfirmDialog';
import TaskFiltersBar from './TaskFiltersBar';

// Utilidades de fecha
function fmtDate(d) {
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}
function getToday() { return fmtDate(new Date()); }

export default function TasksSpreadsheet({ userId, onTasksChange }) {
  const [tasks, setTasks] = useState([]);
  const [areas, setAreas] = useState([]);
  const [users, setUsers] = useState([]);
  const [currentUser, setCurrentUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editingCell, setEditingCell] = useState(null);
  const [pendingChanges, setPendingChanges] = useState({});
  const [newRows, setNewRows] = useState([]);
  const inputRef = useRef(null);
  const [showPastePrompt, setShowPastePrompt] = useState(false);
  const [pastedLines, setPastedLines] = useState([]);
  const isNavigatingRef = useRef(false);
  const [alert, setAlert] = useState(null);
  const [deleteConfirm, setDeleteConfirm] = useState(null);
  const [deleting, setDeleting] = useState(false);
  const [selectedTasks, setSelectedTasks] = useState(new Set());
  const savingRowRef = useRef(new Set());
  const tableContainerRef = useRef(null);

  // Paginación
  const [hasMore, setHasMore] = useState(false);
  const [nextCursor, setNextCursor] = useState(null);
  const [isLoadingMore, setIsLoadingMore] = useState(false);
  const [totalCount, setTotalCount] = useState(0);
  const [fetchingTasks, setFetchingTasks] = useState(false);
  const isInitialMount = useRef(true);

  // Estado de filtros (por defecto: tareas de hoy por start_date)
  const [filters, setFilters] = useState(() => {
    const today = getToday();
    return {
      datePreset: 'today',
      date_from: today,
      date_to: today,
      status: null,
      priority: null,
      sortOrder: 'desc'
    };
  });

  const prioridades = ['Alta', 'Media', 'Baja'];
  const estados = ['No iniciada', 'En progreso', 'En revisión', 'Completada', 'En riesgo'];

  useEffect(() => {
    loadInitialData();
  }, []);

  useEffect(() => {
    if (editingCell) {
      requestAnimationFrame(() => {
        const inputId = `cell-${editingCell.id}-${editingCell.field}`;
        const input = document.getElementById(inputId);
        if (input) {
          input.focus();
          if (input.select) input.select();
        } else if (inputRef.current) {
          inputRef.current.focus();
          if (inputRef.current.select) inputRef.current.select();
        }
      });
    }
  }, [editingCell]);

  // Recargar tareas cuando cambien filtros (no en el mount inicial)
  useEffect(() => {
    if (isInitialMount.current) {
      isInitialMount.current = false;
      return;
    }
    loadTasks(filters, null, false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filters.datePreset, filters.date_from, filters.date_to, filters.status, filters.priority, filters.sortOrder]);

  async function loadInitialData() {
    try {
      const meData = await apiRequest('/auth/me');
      const user = meData.data;
      setCurrentUser(user);

      const [areasData, usersData] = await Promise.all([
        apiRequest('/areas'),
        apiRequest('/users'),
      ]);

      setAreas(areasData.data || []);
      setUsers(usersData.data || []);

      // Cargar primera página de tareas
      await loadTasks(undefined, null, false);
    } catch (e) {
      console.error('Error loading initial data:', e);
    } finally {
      setLoading(false);
    }
  }

  async function loadTasks(overrideFilters, cursor, append) {
    const f = overrideFilters || filters;

    if (append) {
      setIsLoadingMore(true);
    } else {
      setFetchingTasks(true);
    }

    try {
      const params = new URLSearchParams();
      params.set('responsible_id', userId);
      const isAllDates = f.datePreset === 'all' || (!f.date_from && !f.date_to);
      if (isAllDates) {
        params.set('all_dates', '1');
      } else {
        if (f.date_from) params.set('start_date_from', f.date_from);
        if (f.date_to) params.set('start_date_to', f.date_to);
      }
      // Filtros multivalor: solo enviar si hay selección real (null/undefined/[] = "Todas" = no enviar)
      const toStatusParam = (v) => {
        if (v == null) return '';
        if (Array.isArray(v)) return v.filter(Boolean).join(',');
        return String(v).trim();
      };
      const statusParam = toStatusParam(f.status);
      if (statusParam) params.set('status', statusParam);
      const priorityParam = toStatusParam(f.priority);
      if (priorityParam) params.set('priority', priorityParam);
      params.set('limit', '100');
      params.set('sort', 'updated_at');
      params.set('order', f.sortOrder || 'desc');
      if (cursor) params.set('cursor', cursor);

      const result = await apiRequest(`/tasks/paginated?${params.toString()}`);
      const newItems = result.data || [];

      if (append) {
        setTasks(prev => dedupById([...prev, ...newItems]));
      } else {
        setTasks(dedupById(newItems));
        setNewRows(prev => normalizeRows(prev));
      }

      setHasMore(result.has_more || false);
      setNextCursor(result.next_cursor || null);
      setTotalCount(result.total || 0);
    } catch (e) {
      console.error('Error loading tasks:', e);
    } finally {
      setFetchingTasks(false);
      setIsLoadingMore(false);
    }
  }

  async function loadMore() {
    if (!hasMore || isLoadingMore || !nextCursor) return;
    await loadTasks(filters, nextCursor, true);
  }

  // Normalizar filas: solo una fila vacía/draft al inicio
  function normalizeRows(rows) {
    const isDraft = (r) => !r.id && (r.title ?? '').trim() === '';
    const drafts = rows.filter(isDraft);
    const nonDrafts = rows.filter(r => !isDraft(r));
    return drafts.length ? [drafts[0], ...nonDrafts] : nonDrafts;
  }

  // Deduplicar por ID
  function dedupById(rows) {
    const seen = new Set();
    const out = [];
    for (const r of rows) {
      const id = r.id ?? r._tempId;
      if (id && seen.has(id)) continue;
      if (id) seen.add(id);
      out.push(r);
    }
    return out;
  }

  // Manejar cambios en filtros (dispara recarga vía useEffect)
  function handleFiltersChange(newFilters) {
    setFilters(newFilters);
  }

  // Limpiar filtros → volver a "Hoy"
  function handleClearFilters() {
    const today = getToday();
    setFilters({
      datePreset: 'today',
      date_from: today,
      date_to: today,
      status: null,
      priority: null,
      sortOrder: 'desc'
    });
  }

  function addNewRow() {
    setNewRows(prev => {
      // Verificar que no exista ya una fila vacía (usando estado actual)
      const hasEmptyRow = prev.some(r => !r.id && (r.title ?? '').trim() === '');
      if (hasEmptyRow) return prev; // Ya hay una fila vacía, no agregar otra
      
      const defaultAreaId = currentUser?.area_id || areas[0]?.id || '';
      const newRow = {
        _tempId: Date.now(),
        _isNew: true,
        title: '',
        description: '',
        priority: 'Media',
        status: 'No iniciada',
        progress_percent: 0,
        observaciones: '',
        area_id: defaultAreaId,
        area_destinataria_id: defaultAreaId,
        responsible_id: currentUser?.id || '',
        start_date: new Date().toISOString().split('T')[0],
        due_date: '',
      };
      return normalizeRows([...prev, newRow]);
    });
  }

  function updateCell(taskId, field, value, isNew = false) {
    if (isNew) {
      setNewRows(prev =>
        prev.map(row => row._tempId === taskId ? { ...row, [field]: value } : row)
      );
    } else {
      setPendingChanges(prev => ({
        ...prev,
        [taskId]: {
          ...prev[taskId],
          [field]: value
        }
      }));
      // Actualizar en tasks
      setTasks(prev => prev.map(t => 
        t.id === taskId ? { ...t, [field]: value } : t
      ));
    }
  }

  // === Sincronización bidireccional Estado <-> Progreso ===

  function getTaskForSync(taskId, isNew) {
    if (isNew) {
      return newRows.find(r => r._tempId === taskId);
    }
    return tasks.find(t => t.id === taskId);
  }

  function getEffectiveValue(task, taskId, field, isNew) {
    if (isNew) return task[field];
    return pendingChanges[taskId]?.[field] !== undefined
      ? pendingChanges[taskId][field]
      : task[field];
  }

  function handleStatusChange(taskId, newStatus, isNew) {
    const task = getTaskForSync(taskId, isNew);
    if (!task) return;

    const currentProgress = parseInt(getEffectiveValue(task, taskId, 'progress_percent', isNew)) || 0;

    // Actualizar estado
    updateCell(taskId, 'status', newStatus, isNew);

    // Calcular progreso según el nuevo estado
    let newProgress;
    switch (newStatus) {
      case 'No iniciada':
        newProgress = 0;
        break;
      case 'En progreso':
        // Mantener si está en rango válido (1-79), sino asignar 50
        newProgress = (currentProgress >= 1 && currentProgress <= 79) ? currentProgress : 50;
        break;
      case 'En revisión':
        // Mantener si está en rango válido (80-99), sino asignar 90
        newProgress = (currentProgress >= 80 && currentProgress <= 99) ? currentProgress : 90;
        break;
      case 'Completada':
        newProgress = 100;
        break;
      case 'En riesgo':
        // Mantener el progreso actual, si está vacío o 0 asignar 50
        newProgress = (currentProgress > 0) ? currentProgress : 50;
        break;
      default:
        newProgress = currentProgress;
    }

    // Actualizar progreso
    updateCell(taskId, 'progress_percent', newProgress, isNew);
  }

  function handleProgressChange(taskId, rawValue, isNew) {
    // Normalizar valor
    let newProgress = parseInt(rawValue);
    if (isNaN(newProgress) || newProgress < 0) newProgress = 0;
    if (newProgress > 100) newProgress = 100;

    const task = getTaskForSync(taskId, isNew);
    if (!task) return;

    const currentStatus = getEffectiveValue(task, taskId, 'status', isNew) || 'No iniciada';

    // Actualizar progreso
    updateCell(taskId, 'progress_percent', newProgress, isNew);

    // Caso especial: "En riesgo" - solo cambiar estado en 0% o 100%
    if (currentStatus === 'En riesgo') {
      if (newProgress === 0) {
        updateCell(taskId, 'status', 'No iniciada', isNew);
      } else if (newProgress === 100) {
        updateCell(taskId, 'status', 'Completada', isNew);
      }
      // En cualquier otro valor, mantener "En riesgo"
      return;
    }

    // Calcular estado según progreso
    let newStatus;
    if (newProgress === 0) {
      newStatus = 'No iniciada';
    } else if (newProgress >= 1 && newProgress <= 79) {
      newStatus = 'En progreso';
    } else if (newProgress >= 80 && newProgress <= 99) {
      newStatus = 'En revisión';
    } else if (newProgress >= 100) {
      newStatus = 'Completada';
    }

    if (newStatus && newStatus !== currentStatus) {
      updateCell(taskId, 'status', newStatus, isNew);
    }
  }

  // === Fin sincronización ===

  function removeNewRow(tempId) {
    setNewRows(prev => prev.filter(row => row._tempId !== tempId));
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

  async function saveNewRow(row) {
    const key = row._tempId || row.id;
    
    // Lock: evitar doble guardado
    if (savingRowRef.current.has(key)) {
      return false;
    }
    
    if (!row.title?.trim()) {
      setAlert({ type: 'warning', message: 'El título es obligatorio', dismissible: true });
      return false;
    }
    if (!row.area_id) {
      setAlert({ type: 'warning', message: 'El área es obligatoria', dismissible: true });
      return false;
    }

    savingRowRef.current.add(key);
    setSaving(true);
    
    try {
      const { _tempId, _isNew, ...taskData } = row;
      // Asegurar que el responsable sea el usuario actual
      taskData.responsible_id = currentUser?.id;
      
      await apiRequest('/tasks', {
        method: 'POST',
        body: JSON.stringify(normalizeDates(taskData)),
      });
      
      // Remover la fila de newRows antes de recargar
      setNewRows(prev => prev.filter(r => r._tempId !== row._tempId));
      
      // Recargar tareas
      await loadTasks(filters, null, false);
      if (onTasksChange) onTasksChange();
      setAlert({ type: 'success', message: 'Tarea guardada exitosamente', dismissible: true });
      
      return true;
    } catch (e) {
      // Mostrar mensajes de validación específicos si están disponibles
      let errorMessage = e.message;
      if (e.validationErrors && Object.keys(e.validationErrors).length > 0) {
        const errorMessages = Object.values(e.validationErrors);
        errorMessage = errorMessages.join('. ');
      }
      setAlert({ type: 'error', message: errorMessage, dismissible: true });
      return false;
    } finally {
      savingRowRef.current.delete(key);
      setSaving(false);
    }
  }

  function normalizeTaskPayloadForSave(payload) {
    const out = normalizeDates({ ...payload });
    if ((out.area_destinataria_id === null || out.area_destinataria_id === '') && out.area_id) {
      out.area_destinataria_id = out.area_id;
    }
    return out;
  }

  async function saveChanges(taskId) {
    if (!pendingChanges[taskId]) return;
    
    setSaving(true);
    try {
      const task = tasks.find(t => t.id === taskId);
      await apiRequest(`/tasks/${taskId}`, {
        method: 'PUT',
        body: JSON.stringify(normalizeTaskPayloadForSave({
          ...task,
          ...pendingChanges[taskId]
        })),
      });
      setPendingChanges(prev => {
        const { [taskId]: _, ...rest } = prev;
        return rest;
      });
      if (onTasksChange) onTasksChange();
      setAlert({ type: 'success', message: 'Cambios guardados exitosamente', dismissible: true });
    } catch (e) {
      // Mostrar mensajes de validación específicos si están disponibles
      let errorMessage = e.message;
      if (e.validationErrors && Object.keys(e.validationErrors).length > 0) {
        const errorMessages = Object.values(e.validationErrors);
        errorMessage = errorMessages.join('. ');
      }
      setAlert({ type: 'error', message: errorMessage, dismissible: true });
    } finally {
      setSaving(false);
    }
  }

  function handleDeleteClick(taskId) {
    setDeleteConfirm(taskId);
  }

  async function confirmDelete() {
    if (!deleteConfirm) return;
    
    setDeleting(true);
    try {
      await apiRequest(`/tasks/${deleteConfirm}`, { method: 'DELETE' });
      setTasks(prev => prev.filter(t => t.id !== deleteConfirm));
      setTotalCount(prev => Math.max(0, prev - 1));
      setSelectedTasks(prev => {
        const newSet = new Set(prev);
        newSet.delete(deleteConfirm.toString());
        return newSet;
      });
      if (onTasksChange) onTasksChange();
      setAlert({ type: 'success', message: 'Tarea eliminada exitosamente', dismissible: true });
      setDeleteConfirm(null);
    } catch (e) {
      setAlert({ type: 'error', message: 'Error al eliminar: ' + e.message, dismissible: true });
    } finally {
      setDeleting(false);
    }
  }

  function toggleTaskSelection(taskId) {
    setSelectedTasks(prev => {
      const newSet = new Set(prev);
      if (newSet.has(taskId.toString())) {
        newSet.delete(taskId.toString());
      } else {
        newSet.add(taskId.toString());
      }
      return newSet;
    });
  }

  function toggleSelectAll() {
    if (selectedTasks.size === tasks.length) {
      setSelectedTasks(new Set());
    } else {
      setSelectedTasks(new Set(tasks.map(t => t.id.toString())));
    }
  }

  async function deleteSelectedTasks() {
    if (selectedTasks.size === 0) {
      setAlert({ type: 'warning', message: 'No hay tareas seleccionadas', dismissible: true });
      return;
    }

    setDeleteConfirm('multiple');
  }

  async function confirmDeleteMultiple() {
    if (selectedTasks.size === 0) return;
    
    setDeleting(true);
    try {
      const taskIds = Array.from(selectedTasks).map(id => parseInt(id));
      await Promise.all(
        taskIds.map(id => apiRequest(`/tasks/${id}`, { method: 'DELETE' }))
      );
      setTasks(tasks.filter(t => !taskIds.includes(t.id)));
      setSelectedTasks(new Set());
      if (onTasksChange) onTasksChange();
      setAlert({ type: 'success', message: `${taskIds.length} tarea(s) eliminada(s) exitosamente`, dismissible: true });
      setDeleteConfirm(null);
    } catch (e) {
      setAlert({ type: 'error', message: 'Error al eliminar: ' + e.message, dismissible: true });
    } finally {
      setDeleting(false);
    }
  }

  async function saveSelectedTasks() {
    const selectedTaskIds = Array.from(selectedTasks).map(id => parseInt(id));
    const tasksToSave = selectedTaskIds.filter(id => pendingChanges[id] && Object.keys(pendingChanges[id]).length > 0);
    
    if (tasksToSave.length === 0) {
      setAlert({ type: 'warning', message: 'No hay cambios pendientes en las tareas seleccionadas', dismissible: true });
      return;
    }

    setSaving(true);
    try {
      await Promise.all(
        tasksToSave.map(taskId => {
          const task = tasks.find(t => t.id === taskId);
          return apiRequest(`/tasks/${taskId}`, {
            method: 'PUT',
            body: JSON.stringify(normalizeTaskPayloadForSave({
              ...task,
              ...pendingChanges[taskId]
            })),
          });
        })
      );
      
      // Limpiar cambios guardados
      setPendingChanges(prev => {
        const newChanges = { ...prev };
        tasksToSave.forEach(id => {
          delete newChanges[id];
        });
        return newChanges;
      });
      
      await loadTasks(filters, null, false);
      if (onTasksChange) onTasksChange();
      setAlert({ type: 'success', message: `${tasksToSave.length} tarea(s) guardada(s) exitosamente`, dismissible: true });
    } catch (e) {
      let errorMessage = e.message;
      if (e.validationErrors && Object.keys(e.validationErrors).length > 0) {
        const errorMessages = Object.values(e.validationErrors);
        errorMessage = errorMessages.join('. ');
      }
      setAlert({ type: 'error', message: errorMessage, dismissible: true });
    } finally {
      setSaving(false);
    }
  }

  async function saveAllChanges() {
    // Obtener tareas con cambios pendientes
    const tasksToSave = Object.keys(pendingChanges).map(id => parseInt(id)).filter(id => pendingChanges[id] && Object.keys(pendingChanges[id]).length > 0);
    
    if (tasksToSave.length === 0) {
      setAlert({ type: 'warning', message: 'No hay cambios pendientes para guardar', dismissible: true });
      return;
    }

    setSaving(true);
    try {
      await Promise.all(
        tasksToSave.map(taskId => {
          const task = tasks.find(t => t.id === taskId);
          if (!task) return Promise.resolve(); // tarea no visible, omitir
          return apiRequest(`/tasks/${taskId}`, {
            method: 'PUT',
            body: JSON.stringify(normalizeTaskPayloadForSave({
              ...task,
              ...pendingChanges[taskId]
            })),
          });
        })
      );
      
      setPendingChanges(prev => {
        const newChanges = { ...prev };
        tasksToSave.forEach(id => {
          delete newChanges[id];
        });
        return newChanges;
      });
      
      await loadTasks(filters, null, false);
      if (onTasksChange) onTasksChange();
      setAlert({ type: 'success', message: `${tasksToSave.length} tarea(s) guardada(s) exitosamente`, dismissible: true });
    } catch (e) {
      let errorMessage = e.message;
      if (e.validationErrors && Object.keys(e.validationErrors).length > 0) {
        const errorMessages = Object.values(e.validationErrors);
        errorMessage = errorMessages.join('. ');
      }
      setAlert({ type: 'error', message: errorMessage, dismissible: true });
    } finally {
      setSaving(false);
    }
  }

  function handleKeyDown(e, taskId, field, isNew) {
    // Tab: mover a la siguiente celda
    if (e.key === 'Tab') {
      e.preventDefault();
      isNavigatingRef.current = true;
      
      // Encontrar la siguiente celda editable
      const allRows = [...newRows, ...tasks];
      const currentRowIndex = allRows.findIndex(r => (isNew ? r._tempId : r.id) === taskId);
      // Construir lista de campos según si se muestra la columna de subcategoría
      const fields = ['title', 'priority', 'status', 'area_id', 'area_destinataria_id', 'progress_percent', 'start_date', 'due_date', 'observaciones'];
      const currentFieldIndex = fields.indexOf(field);
      
      let nextCell = null;
      
      if (e.shiftKey) {
        // Shift+Tab: mover a la celda anterior
        if (currentFieldIndex > 0) {
          // Campo anterior en la misma fila
          nextCell = { id: taskId, field: fields[currentFieldIndex - 1], isNew };
        } else if (currentRowIndex > 0) {
          // Última celda de la fila anterior
          const prevRow = allRows[currentRowIndex - 1];
          const prevRowId = prevRow._tempId || prevRow.id;
          const prevRowIsNew = !!prevRow._tempId;
          nextCell = { id: prevRowId, field: fields[fields.length - 1], isNew: prevRowIsNew };
        }
      } else {
        // Tab normal: mover a la siguiente celda
        if (currentFieldIndex < fields.length - 1) {
          // Siguiente campo en la misma fila
          nextCell = { id: taskId, field: fields[currentFieldIndex + 1], isNew };
        } else if (currentRowIndex < allRows.length - 1) {
          // Primera celda de la siguiente fila
          const nextRow = allRows[currentRowIndex + 1];
          const nextRowId = nextRow._tempId || nextRow.id;
          const nextRowIsNew = !!nextRow._tempId;
          nextCell = { id: nextRowId, field: 'title', isNew: nextRowIsNew };
        }
      }
      
      // Actualizar directamente a la siguiente celda sin cerrar primero
      if (nextCell) {
        setEditingCell({ id: nextCell.id, field: nextCell.field });
        // Resetear el flag después de un breve delay
        setTimeout(() => {
          isNavigatingRef.current = false;
        }, 100);
      } else {
        setEditingCell(null);
        isNavigatingRef.current = false;
      }
      return;
    }
    
    // Enter: confirmar y mover a la siguiente fila (solo en título)
    if (e.key === 'Enter' && field === 'title') {
      e.preventDefault();
      e.stopPropagation(); // Evitar que se propague a otros handlers
      
      if (isNew) {
        const row = newRows.find(r => r._tempId === taskId);

        if (!row || !row.title?.trim()) {
          setEditingCell(null);
          return;
        }

        setEditingCell(null);

        (async () => {
          const ok = await saveNewRow(row);
          if (!ok) return;

          setNewRows(prev => {
            const hasEmpty = prev.some(r => !r.id && (r.title ?? '').trim() === '');
            if (hasEmpty) return prev;

            const defaultAreaId = currentUser?.area_id || areas[0]?.id || '';
            const draft = {
              _tempId: Date.now(),
              _isNew: true,
              title: '',
              description: '',
              priority: 'Media',
              status: 'No iniciada',
              progress_percent: 0,
              observaciones: '',
              area_id: defaultAreaId,
              area_destinataria_id: defaultAreaId,
              responsible_id: currentUser?.id || '',
              start_date: new Date().toISOString().split('T')[0],
              due_date: '',
            };

            const normalized = normalizeRows([...prev, draft]);
            
            // Enfocar en la nueva fila después de un breve delay
            setTimeout(() => {
              const emptyRow = normalized.find(r => !r.id && (r.title ?? '').trim() === '');
              if (emptyRow) {
                setEditingCell({ id: emptyRow._tempId, field: 'title' });
              }
            }, 150);

            return normalized;
          });
        })();

        return;
      } else if (pendingChanges[taskId]) {
        setEditingCell(null);
        saveChanges(taskId);
      } else {
        setEditingCell(null);
      }
      return;
    }
    
    // Enter normal: confirmar edición
    if (e.key === 'Enter') {
      e.preventDefault();
      setEditingCell(null);
      if (isNew) {
        // Mover al siguiente campo
        const fields = ['title', 'priority', 'status', 'area_id', 'area_destinataria_id', 'progress_percent', 'start_date', 'due_date', 'observaciones'];
        const currentFieldIndex = fields.indexOf(field);
        if (currentFieldIndex < fields.length - 1) {
          setEditingCell({ id: taskId, field: fields[currentFieldIndex + 1] });
        }
      } else if (pendingChanges[taskId]) {
        saveChanges(taskId);
      }
    } else if (e.key === 'Escape') {
      setEditingCell(null);
    }
  }

  function handlePaste(e, taskId, field, isNew) {
    // Solo procesar pegado múltiple en el campo de título
    if (field !== 'title') return;
    
    const pastedText = e.clipboardData.getData('text');
    const lines = pastedText.split(/\r?\n/).filter(line => line.trim().length > 0);
    
    // Si hay más de una línea, crear múltiples tareas
    if (lines.length > 1) {
      e.preventDefault();
      setPastedLines(lines);
      setShowPastePrompt(true);
      
      // Actualizar la primera fila con el primer título
      if (isNew) {
        updateCell(taskId, 'title', lines[0].trim(), true);
      } else {
        // Si no es nueva, actualizar el título actual y crear filas nuevas para el resto
        updateCell(taskId, 'title', lines[0].trim(), false);
        // Crear filas nuevas para las líneas restantes
        const remainingLines = lines.slice(1);
        const defaultAreaId = currentUser?.area_id || areas[0]?.id || '';
        const newRowsToAdd = remainingLines.map(title => ({
          _tempId: Date.now() + Math.random(),
          _isNew: true,
          title: title.trim(),
          description: '',
          priority: 'Media',
          status: 'No iniciada',
          progress_percent: 0,
          observaciones: '',
          area_id: defaultAreaId,
          area_destinataria_id: defaultAreaId,
          responsible_id: currentUser?.id || '',
          start_date: new Date().toISOString().split('T')[0],
          due_date: '',
        }));
        setNewRows(prev => normalizeRows([...prev, ...newRowsToAdd]));
      }
    }
  }

  async function createMultipleTasksFromPaste() {
    if (pastedLines.length === 0) return;
    
    setSaving(true);
    try {
      // Si hay una celda editándose, guardar su cambio primero
      if (editingCell) {
        const editingTask = tasks.find(t => t.id === editingCell.id);
        if (editingTask && pendingChanges[editingCell.id]) {
          await saveChanges(editingCell.id);
        }
      }

      const defaultAreaId = currentUser?.area_id || areas[0]?.id || '';
      const tasksToCreate = pastedLines.map(title => ({
        title: title.trim(),
        description: '',
        priority: 'Media',
        status: 'No iniciada',
        progress_percent: 0,
        observaciones: '',
        area_id: defaultAreaId,
        area_destinataria_id: defaultAreaId,
        responsible_id: currentUser?.id || '',
        start_date: new Date().toISOString().split('T')[0],
        due_date: '',
      }));

      // Crear todas las tareas en paralelo
      await Promise.all(
        tasksToCreate.map(taskData => 
          apiRequest('/tasks', {
            method: 'POST',
            body: JSON.stringify(taskData),
          })
        )
      );
      
      // Limpiar filas nuevas temporales que se crearon
      setNewRows([]);
      setShowPastePrompt(false);
      setPastedLines([]);
      setEditingCell(null);
      await loadTasks(filters, null, false);
      if (onTasksChange) onTasksChange();
      setAlert({ type: 'success', message: `${pastedLines.length} tareas creadas exitosamente`, dismissible: true });
    } catch (e) {
      setAlert({ type: 'error', message: 'Error al crear tareas: ' + e.message, dismissible: true });
    } finally {
      setSaving(false);
    }
  }

  function renderCell(task, field, isNew = false) {
    const taskId = isNew ? task._tempId : task.id;
    const isEditing = editingCell?.id === taskId && editingCell?.field === field;
    const rawValue = !isNew && pendingChanges[taskId]?.[field] !== undefined ? pendingChanges[taskId][field] : task[field];
    const value = field === 'area_destinataria_id' ? (rawValue ?? task.area_id ?? '') : rawValue;
    const hasChanges = !isNew && pendingChanges[taskId]?.[field] !== undefined;

    const cellClass = `px-2 py-2 border-r border-slate-200 text-sm overflow-hidden whitespace-nowrap ${
      hasChanges ? 'bg-amber-50' : isNew ? 'bg-emerald-50/30' : 'bg-white'
    } ${isEditing ? 'ring-2 ring-inset ring-indigo-500' : ''} hover:bg-slate-50`;

    // Campos de seleccion
    if (['priority', 'status', 'area_id', 'area_destinataria_id'].includes(field)) {
      let options = [];
      let isDisabled = false;

      if (field === 'priority') options = prioridades.map(p => ({ value: p, label: p }));
      else if (field === 'status') options = estados.map(s => ({ value: s, label: s }));
      else if (field === 'area_id') {
        options = areas.map(a => ({ value: a.id, label: a.name }));
      }
      else if (field === 'area_destinataria_id') {
        options = areas.map(a => ({ value: a.id, label: a.name }));
      }

      return (
        <td className={`${cellClass} ${isDisabled ? 'bg-slate-100' : ''}`}>
          <select
            value={value || ''}
            onChange={(e) => {
              const newVal = e.target.value;
              if (field === 'status') {
                handleStatusChange(taskId, newVal, isNew);
              } else {
                updateCell(taskId, field, newVal, isNew);
              }
              if (field === 'area_id' && isNew) {
                updateCell(taskId, 'area_destinataria_id', newVal, isNew);
              }
            }}
            disabled={isDisabled}
            className={`w-full bg-transparent border-0 text-xs focus:outline-none focus:ring-0 p-0 cursor-pointer truncate ${isDisabled ? 'text-slate-500 cursor-not-allowed' : ''}`}
          >
            {(field === 'area_id' || field === 'area_destinataria_id') && <option key={`select-${field}`} value="">Seleccionar</option>}
            {options.map(opt => (
              <option key={`${field}-${opt.value}`} value={opt.value}>{opt.label}</option>
            ))}
          </select>
        </td>
      );
    }

    // Campo de progreso
    if (field === 'progress_percent') {
      const pct = parseInt(value) || 0;
      return (
        <td className={cellClass}>
          <div className="flex items-center gap-2">
            <input
              type="range"
              min="0"
              max="100"
              step="5"
              value={pct}
              onChange={(e) => handleProgressChange(taskId, e.target.value, isNew)}
              className="flex-1 min-w-0 h-1.5 accent-indigo-600 cursor-pointer"
            />
            <span className="text-xs font-semibold text-slate-700 shrink-0 tabular-nums">{pct}%</span>
          </div>
        </td>
      );
    }

    // Campos de fecha
    if (['start_date', 'due_date'].includes(field)) {
      return (
        <td className={cellClass}>
          <input
            type="date"
            value={value || ''}
            onChange={(e) => updateCell(taskId, field, e.target.value, isNew)}
            className="w-full min-w-0 bg-transparent border-0 text-xs focus:outline-none focus:ring-0 p-0"
          />
        </td>
      );
    }

    // Campos de texto (titulo, descripcion)
    if (isEditing) {
      const inputId = `cell-${taskId}-${field}`;
      return (
        <td className={cellClass}>
          <input
            id={inputId}
            ref={inputRef}
            type="text"
            value={value || ''}
            onChange={(e) => updateCell(taskId, field, e.target.value, isNew)}
            onBlur={() => {
              // No cerrar si estamos navegando con Tab
              // No cerrar si estamos guardando (evitar conflictos con Enter)
              if (!isNavigatingRef.current && !savingRowRef.current.has(taskId)) {
                setEditingCell(null);
              }
            }}
            onKeyDown={(e) => handleKeyDown(e, taskId, field, isNew)}
            onPaste={(e) => handlePaste(e, taskId, field, isNew)}
            className="w-full min-w-0 bg-transparent border-0 text-sm focus:outline-none focus:ring-0 p-0"
          />
        </td>
      );
    }

    return (
      <td 
        className={`${cellClass} cursor-text max-w-0`}
        onClick={() => setEditingCell({ id: taskId, field })}
        title={value && value.length > 20 ? value : undefined}
      >
        <span className={`block truncate ${!value ? 'text-slate-400 italic text-xs' : 'text-slate-900'}`}>
          {value || (field === 'title' ? 'Clic para escribir...' : '-')}
        </span>
      </td>
    );
  }

  function renderRow(task, isNew = false) {
    const taskId = isNew ? task._tempId : task.id;
    const hasChanges = !isNew && Object.keys(pendingChanges[taskId] || {}).length > 0;
    const isSelected = !isNew && selectedTasks.has(taskId.toString());

    return (
      <tr key={taskId} className={`group border-b border-slate-100 last:border-b-0 ${isSelected ? 'bg-indigo-50/50' : ''}`}>
        {/* Casilla de selección */}
        {!isNew && (
          <td className="px-1 py-2 text-center bg-slate-50/50 border-r border-slate-200">
            <div className="flex items-center justify-center">
              <label className="relative inline-flex items-center cursor-pointer group">
                <input
                  type="checkbox"
                  checked={isSelected}
                  onChange={() => toggleTaskSelection(taskId)}
                  className="sr-only peer"
                />
                <div className={`relative w-4 h-4 rounded border-2 transition-all duration-200 ${
                  isSelected 
                    ? 'bg-indigo-600 border-indigo-600 shadow-sm shadow-indigo-200' 
                    : 'bg-white border-slate-300 group-hover:border-indigo-400 group-hover:bg-indigo-50'
                }`}>
                  {isSelected && (
                    <svg 
                      className="absolute inset-0 w-full h-full text-white p-0.5" 
                      fill="none" 
                      stroke="currentColor" 
                      viewBox="0 0 24 24"
                    >
                      <path 
                        strokeLinecap="round" 
                        strokeLinejoin="round" 
                        strokeWidth={3} 
                        d="M5 13l4 4L19 7" 
                      />
                    </svg>
                  )}
                </div>
              </label>
            </div>
          </td>
        )}
        {isNew && <td className="px-1 py-2 bg-slate-50/50 border-r border-slate-200"></td>}
        {renderCell(task, 'title', isNew)}
        {renderCell(task, 'priority', isNew)}
        {renderCell(task, 'status', isNew)}
        {renderCell(task, 'area_id', isNew)}
        {renderCell(task, 'area_destinataria_id', isNew)}
        {renderCell(task, 'progress_percent', isNew)}
        {renderCell(task, 'start_date', isNew)}
        {renderCell(task, 'due_date', isNew)}
        {renderCell(task, 'observaciones', isNew)}
        <td className="px-1 py-2 text-center bg-slate-50/50">
          <div className="flex items-center justify-center gap-0.5">
            {isNew ? (
              <>
                <button
                  onClick={() => saveNewRow(task)}
                  disabled={saving || !task.title}
                  className="p-1 text-emerald-600 hover:bg-emerald-100 rounded-md disabled:opacity-50 transition-colors"
                  title="Guardar"
                >
                  <Check className="w-3.5 h-3.5" strokeWidth={2.5} />
                </button>
                <button
                  onClick={() => removeNewRow(task._tempId)}
                  className="p-1 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-md transition-colors"
                  title="Cancelar"
                >
                  <X className="w-3.5 h-3.5" strokeWidth={2} />
                </button>
              </>
            ) : (
              <>
                {hasChanges && (
                  <button
                    onClick={() => saveChanges(taskId)}
                    disabled={saving}
                    className="p-1 text-emerald-600 hover:bg-emerald-100 rounded-md disabled:opacity-50 transition-colors"
                    title="Guardar cambios"
                  >
                    <Save className="w-3.5 h-3.5" strokeWidth={2} />
                  </button>
                )}
                <button
                  onClick={() => handleDeleteClick(taskId)}
                  className="p-1 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-md opacity-0 group-hover:opacity-100 transition-all"
                  title="Eliminar"
                >
                  <Trash2 className="w-3.5 h-3.5" strokeWidth={2} />
                </button>
              </>
            )}
          </div>
        </td>
      </tr>
    );
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-48 bg-white rounded-xl border border-slate-200">
        <Loader2 className="h-8 w-8 text-indigo-600 animate-spin" strokeWidth={1.75} />
      </div>
    );
  }

  const hasPendingChanges = Object.keys(pendingChanges).length > 0;

  const filteredTasksCount = tasks.length;
  const hasFilteredResults = filteredTasksCount > 0 || newRows.length > 0;

  return (
    <div className="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm flex flex-col h-full">
      {/* Barra de filtros */}
      <TaskFiltersBar
        filters={filters}
        onFiltersChange={handleFiltersChange}
        onClearFilters={handleClearFilters}
      />

      {/* Toolbar compacto */}
      <div className="flex items-center justify-between px-4 py-2.5 border-b border-slate-200 bg-gradient-to-r from-slate-50 to-slate-100 flex-shrink-0">
        <div className="flex items-center gap-3">
          <span className="text-sm font-medium text-slate-600">
            {filteredTasksCount} {filteredTasksCount === 1 ? 'tarea' : 'tareas'}
            {totalCount > filteredTasksCount && (
              <span className="text-slate-400 ml-1">de {totalCount}</span>
            )}
            {fetchingTasks && <span className="text-indigo-500 ml-2 animate-pulse">cargando…</span>}
          </span>
          {selectedTasks.size > 0 && (
            <span className="text-sm font-medium text-indigo-600">
              {selectedTasks.size} seleccionada(s)
            </span>
          )}
          {hasPendingChanges && (
            <>
              <span className="flex items-center gap-1 text-xs text-amber-700 bg-amber-100 px-2 py-0.5 rounded-full">
                <AlertCircle className="w-3 h-3" />
                Sin guardar
              </span>
              <button
                onClick={saveAllChanges}
                disabled={saving}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-white bg-emerald-600 rounded-lg hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors shadow-sm"
              >
                <Save className="w-4 h-4" strokeWidth={2} />
                {saving ? 'Guardando...' : 'Guardar todos los cambios'}
              </button>
            </>
          )}
          {selectedTasks.size > 0 && (
            <div className="flex items-center gap-2">
              <button
                onClick={saveSelectedTasks}
                disabled={saving || !Array.from(selectedTasks).some(id => pendingChanges[parseInt(id)] && Object.keys(pendingChanges[parseInt(id)]).length > 0)}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-white bg-emerald-600 rounded-lg hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors shadow-sm"
              >
                <Save className="w-4 h-4" strokeWidth={2} />
                Guardar seleccionadas
              </button>
              <button
                onClick={deleteSelectedTasks}
                disabled={deleting}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-white bg-rose-600 rounded-lg hover:bg-rose-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors shadow-sm"
              >
                <Trash2 className="w-4 h-4" strokeWidth={2} />
                Eliminar seleccionadas
              </button>
            </div>
          )}
          {showPastePrompt && (
            <div className="flex items-center gap-2 px-3 py-1 bg-indigo-50 border border-indigo-200 rounded-lg">
              <span className="text-xs font-medium text-indigo-700">
                {pastedLines.length} tareas detectadas
              </span>
              <button
                onClick={createMultipleTasksFromPaste}
                disabled={saving}
                className="px-2 py-0.5 text-xs font-medium text-white bg-indigo-600 rounded hover:bg-indigo-700 disabled:opacity-50 transition-colors"
              >
                {saving ? 'Creando...' : 'Crear todas'}
              </button>
              <button
                onClick={() => {
                  setShowPastePrompt(false);
                  setPastedLines([]);
                }}
                className="px-2 py-0.5 text-xs font-medium text-slate-600 hover:text-slate-800 transition-colors"
              >
                Cancelar
              </button>
            </div>
          )}
        </div>
        <button
          onClick={addNewRow}
          className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-white bg-indigo-600 rounded-lg hover:bg-indigo-700 transition-colors shadow-sm"
        >
          <Plus className="w-4 h-4" strokeWidth={2.5} />
          Nueva tarea
        </button>
      </div>

      {/* Tabla tipo Excel con scroll mejorado y responsive */}
      <div 
        ref={tableContainerRef}
        className="overflow-auto flex-1 min-h-0"
        style={{ 
          scrollBehavior: 'smooth',
          WebkitOverflowScrolling: 'touch'
        }}
      >
        <table className="w-full border-collapse table-fixed" style={{ minWidth: '1510px' }}>
          <thead className="sticky top-0 z-10 shadow-sm">
            <tr className="bg-slate-700 text-white">
              <th className="px-2 py-2.5 text-center text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '40px' }}>
                <div className="flex items-center justify-center">
                  <label className="relative inline-flex items-center cursor-pointer group">
                    <input
                      type="checkbox"
                      checked={tasks.length > 0 && selectedTasks.size === tasks.length}
                      onChange={toggleSelectAll}
                      className="sr-only peer"
                      title="Seleccionar todas"
                    />
                    <div className={`relative w-4 h-4 rounded border-2 transition-all duration-200 ${
                      tasks.length > 0 && selectedTasks.size === tasks.length
                        ? 'bg-indigo-600 border-indigo-600 shadow-sm shadow-indigo-200' 
                        : 'bg-white/20 border-slate-400 group-hover:border-indigo-300 group-hover:bg-white/30'
                    }`}>
                      {tasks.length > 0 && selectedTasks.size === tasks.length && (
                        <svg 
                          className="absolute inset-0 w-full h-full text-white p-0.5" 
                          fill="none" 
                          stroke="currentColor" 
                          viewBox="0 0 24 24"
                        >
                          <path 
                            strokeLinecap="round" 
                            strokeLinejoin="round" 
                            strokeWidth={3} 
                            d="M5 13l4 4L19 7" 
                          />
                        </svg>
                      )}
                    </div>
                  </label>
                </div>
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '370px' }}>
                Titulo
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '85px' }}>
                Prioridad
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '110px' }}>
                Estado
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '115px' }}>
                <span className="block truncate">Área resp.</span>
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '115px' }}>
                <span className="block truncate">Área dest.</span>
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '180px' }}>
                Progreso
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '100px' }}>
                Inicio
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '100px' }}>
                Vence
              </th>
              <th className="px-2 py-2.5 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600" style={{ width: '130px' }}>
                Observaciones
              </th>
              <th className="px-2 py-2.5 text-center text-xs font-semibold uppercase tracking-wider" style={{ width: '50px' }}>
                
              </th>
            </tr>
          </thead>
          <tbody>
            {/* Filas nuevas primero */}
            {newRows.map(row => renderRow(row, true))}
            
            {/* Tareas existentes */}
            {tasks.map(task => renderRow(task, false))}
            
            {/* Estado vacío */}
            {!hasFilteredResults && (
              <tr>
                <td colSpan={13} className="px-4 py-12 text-center bg-slate-50">
                  <div className="flex flex-col items-center gap-3">
                    <div className="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center">
                      <Inbox className="w-8 h-8 text-slate-400" />
                    </div>
                    <div>
                      <p className="text-sm font-medium text-slate-700 mb-1">
                        {totalCount > 0 ? 'No se encontraron tareas con estos filtros' : 'No tienes tareas para este período'}
                      </p>
                      <p className="text-xs text-slate-500 mb-3">
                        {totalCount > 0 ? 'Intenta ajustar los filtros o el rango de fecha' : 'Prueba con otro rango de fecha o crea una nueva tarea'}
                      </p>
                      <div className="flex items-center justify-center gap-2">
                        <button
                          onClick={handleClearFilters}
                          className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm text-indigo-600 hover:text-indigo-700 hover:bg-indigo-50 rounded-lg transition-colors"
                        >
                          <RotateCcw className="w-4 h-4" />
                          Volver a Hoy
                        </button>
                        <button
                          onClick={addNewRow}
                          className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm text-white bg-indigo-600 hover:bg-indigo-700 rounded-lg transition-colors"
                        >
                          <Plus className="w-4 h-4" />
                          Nueva tarea
                        </button>
                      </div>
                    </div>
                  </div>
                </td>
              </tr>
            )}

            {/* Botón Cargar más */}
            {hasMore && hasFilteredResults && (
              <tr>
                <td colSpan={13} className="px-4 py-3 text-center bg-slate-50/50 border-t border-slate-100">
                  <button
                    onClick={loadMore}
                    disabled={isLoadingMore}
                    className="inline-flex items-center gap-2 px-5 py-2 text-sm font-medium text-indigo-700 bg-indigo-50 hover:bg-indigo-100 rounded-lg transition-colors disabled:opacity-60"
                  >
                    {isLoadingMore ? (
                      <>
                        <Loader2 className="w-4 h-4 animate-spin" />
                        Cargando más…
                      </>
                    ) : (
                      <>
                        Cargar más tareas
                        <span className="text-xs text-indigo-500">({tasks.length} de {totalCount})</span>
                      </>
                    )}
                  </button>
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Footer minimalista */}
      <div className="px-4 py-2 border-t border-slate-100 bg-slate-50/50 text-xs text-slate-500">
        Clic en celda para editar · <kbd className="px-1 py-0.5 bg-white border border-slate-300 rounded text-xs font-mono">Tab</kbd> siguiente celda · <kbd className="px-1 py-0.5 bg-white border border-slate-300 rounded text-xs font-mono">Enter</kbd> confirmar · <kbd className="px-1 py-0.5 bg-white border border-slate-300 rounded text-xs font-mono">Esc</kbd> cancelar · Pega múltiples líneas en título para crear varias tareas
      </div>

      {/* Alertas */}
      {alert && (
        <div className="fixed top-4 right-4 z-50 max-w-md animate-in slide-in-from-right">
          <Alert
            type={alert.type}
            dismissible
            onDismiss={() => setAlert(null)}
          >
            {alert.message}
          </Alert>
        </div>
      )}

      {/* Diálogo de confirmación de eliminación */}
      <ConfirmDialog
        isOpen={!!deleteConfirm}
        title={deleteConfirm === 'multiple' ? 'Eliminar Tareas Seleccionadas' : 'Eliminar Tarea'}
        message={deleteConfirm === 'multiple' 
          ? `¿Estás seguro de que deseas eliminar ${selectedTasks.size} tarea(s) seleccionada(s)? Esta acción no se puede deshacer.`
          : '¿Estás seguro de que deseas eliminar esta tarea? Esta acción no se puede deshacer.'}
        type="warning"
        confirmText="Eliminar"
        cancelText="Cancelar"
        loading={deleting}
        onConfirm={deleteConfirm === 'multiple' ? confirmDeleteMultiple : confirmDelete}
        onCancel={() => setDeleteConfirm(null)}
      />
    </div>
  );
}
