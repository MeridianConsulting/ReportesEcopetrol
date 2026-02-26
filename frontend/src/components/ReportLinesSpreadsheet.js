// components/ReportLinesSpreadsheet.js
'use client';

import { useState, useEffect, useRef, useMemo } from 'react';
import { apiRequest } from '../lib/api';
import { Plus, Save, Trash2, Loader2, Check, X, AlertCircle, Inbox } from 'lucide-react';
import Alert from './Alert';
import ConfirmDialog from './ConfirmDialog';

const FULL_COLUMNS = [
  { key: 'report_date', label: 'Fecha reporte', width: '115px', type: 'date' },
  { key: 'reporter_name', label: 'Nombre del profesional', width: '180px', type: 'text', readOnly: true },
  { key: 'item_general', label: 'Ítem general', width: '120px', type: 'text' },
  { key: 'item_activity', label: 'Ítem actividad', width: '120px', type: 'text' },
  { key: 'activity_description', label: 'Descripción de la actividad', width: '200px', type: 'text' },
  { key: 'support_text', label: 'Soporte', width: '140px', type: 'text' },
  { key: 'delivery_medium_id', label: 'Medio de entrega', width: '140px', type: 'select-delivery' },
  { key: 'contracted_days', label: 'Días contratados', width: '100px', type: 'number' },
  { key: 'days_month', label: 'Días reportados del mes', width: '120px', type: 'number' },
  { key: 'progress_percent', label: '% avance del mes', width: '130px', type: 'progress' },
  { key: 'accumulated_days', label: 'Días acumulados del servicio', width: '150px', type: 'number' },
  { key: 'accumulated_progress', label: '% avance acumulado del servicio', width: '180px', type: 'progress' },
  { key: 'observations', label: 'Observaciones', width: '160px', type: 'text' },
];

const COMPACT_COLUMNS = [
  { key: 'report_date', label: 'Fecha', width: '115px', type: 'date' },
  { key: 'item_general', label: 'Ítem general', width: '180px', type: 'text' },
  { key: 'item_activity', label: 'Ítem actividad', width: '180px', type: 'text' },
  { key: 'days_month', label: 'Días', width: '90px', type: 'number' },
  { key: 'progress_percent', label: '% Avance', width: '130px', type: 'progress' },
  { key: '__status', label: 'Estado', width: '130px', type: 'status' },
];

function fmtDate(d) {
  if (!d) return '';
  const x = new Date(d);
  return isNaN(x.getTime())
    ? ''
    : x.getFullYear() +
        '-' +
        String(x.getMonth() + 1).padStart(2, '0') +
        '-' +
        String(x.getDate()).padStart(2, '0');
}

function parseDecimal(v) {
  if (v === null || v === undefined || v === '') return null;
  const n = parseFloat(String(v).replace(',', '.'));
  return Number.isFinite(n) ? n : null;
}

/**
 * Estado derivado (para Wireframe 1)
 * - draft: faltan campos base (ítem general/actividad o descripción)
 * - alert: inconsistencias numéricas o fuera de rango
 * - ready: completo y sin alertas
 */
function deriveRowStatus(row) {
  const itemGen = (row.item_general ?? '').trim();
  const itemAct = (row.item_activity ?? '').trim();
  const desc = (row.activity_description ?? '').trim();

  const days = parseDecimal(row.days_month);
  const prog = parseDecimal(row.progress_percent);

  const hasRequired = !!itemGen && !!itemAct; // descripción la puedes exigir si quieres
  const hasDesc = !!desc;

  const hasBadDays = days !== null && days < 0;
  const hasBadProg = prog !== null && (prog < 0 || prog > 100);

  const isAlert = hasBadDays || hasBadProg;
  if (isAlert) return 'alert';

  // Si quieres exigir descripción para estar "Listo", descomenta esta línea:
  // if (!hasRequired || !hasDesc) return 'draft';

  if (!hasRequired) return 'draft';
  return 'ready';
}

function StatusChip({ status }) {
  const cfg =
    status === 'ready'
      ? { label: 'Listo', cls: 'bg-emerald-100 text-emerald-800 border-emerald-200' }
      : status === 'alert'
      ? { label: 'Alerta', cls: 'bg-rose-100 text-rose-800 border-rose-200' }
      : { label: 'Borrador', cls: 'bg-slate-100 text-slate-700 border-slate-200' };

  return (
    <span className={`inline-flex items-center justify-center px-2 py-0.5 text-xs rounded-full border ${cfg.cls}`}>
      {cfg.label}
    </span>
  );
}

export default function ReportLinesSpreadsheet({
  userId,
  reporterName,
  onDataChange,

  // 🔌 Wireframe 1 props
  filters = { reportDate: '', status: 'all', search: '' },
  createRequestId,
  viewMode = 'full', // 'full' | 'compact'
  hideInternalToolbar = false, // para que NO se duplique con la toolbar del page
}) {
  const [lines, setLines] = useState([]);
  const [newRows, setNewRows] = useState([]);
  const [deliveryMedia, setDeliveryMedia] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editingCell, setEditingCell] = useState(null);
  const [pendingChanges, setPendingChanges] = useState({});
  const [alert, setAlert] = useState(null);
  const [deleteConfirm, setDeleteConfirm] = useState(null);
  const [deleting, setDeleting] = useState(false);
  const inputRef = useRef(null);
  const savingRowRef = useRef(new Set());

  // ✅ Columnas según modo
  const COLUMNS = useMemo(() => {
    return viewMode === 'compact' ? COMPACT_COLUMNS : FULL_COLUMNS;
  }, [viewMode]);

  useEffect(() => {
    loadCatalogsAndLines();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [userId]);

  useEffect(() => {
    if (editingCell && inputRef.current) {
      requestAnimationFrame(() => {
        const el = document.getElementById(`cell-${editingCell.id}-${editingCell.key}`);
        if (el) {
          el.focus();
          if (el.select) el.select();
        }
      });
    }
  }, [editingCell]);

  // ✅ Wireframe 1: botón externo "Nueva línea"
  useEffect(() => {
    if (createRequestId === undefined) return;
    addNewRowFromExternal();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [createRequestId]);

  async function loadCatalogsAndLines() {
    setLoading(true);
    try {
      const [mediaRes, linesRes] = await Promise.all([
        apiRequest('/reports/delivery-media').catch(() => ({ data: [] })),
        apiRequest('/reports/my-lines').catch(() => ({ data: [] })),
      ]);
      setDeliveryMedia(mediaRes.data || []);
      setLines(normalizeApiRows(linesRes.data || []));
    } catch (e) {
      console.error('Error loading data:', e);
      setAlert({ type: 'error', message: 'Error al cargar datos: ' + (e.message || 'desconocido'), dismissible: true });
    } finally {
      setLoading(false);
    }
  }

  function normalizeApiRows(rows) {
    return rows.map((r) => ({
      report_line_id: r.report_line_id,
      report_id: r.report_id,
      ods_code: r.ods_code ?? '',
      period_label: r.period_label ?? '',
      report_date: r.report_date ?? '',
      reporter_name: r.reporter_name ?? reporterName ?? '',
      item_general: r.item_general ?? '',
      item_activity: r.item_activity ?? '',
      activity_description: r.activity_description ?? '',
      support_text: r.support_text ?? '',
      delivery_medium_id: r.delivery_medium_id ?? '',
      delivery_medium_name: r.delivery_medium_name ?? '',
      contracted_days: r.contracted_days ?? '',
      days_month: r.days_month ?? '',
      progress_percent: r.progress_percent ?? '',
      accumulated_days: r.accumulated_days ?? '',
      accumulated_progress: r.accumulated_progress ?? '',
      observations: r.observations ?? '',
    }));
  }

  function getEmptyNewRow(forcedDate) {
    const today = new Date().toISOString().split('T')[0];
    const date = forcedDate || today;

    return {
      _tempId: Date.now(),
      _isNew: true,
      report_date: date,
      reporter_name: reporterName ?? '',
      item_general: '',
      item_activity: '',
      activity_description: '',
      support_text: '',
      delivery_medium_id: '',
      contracted_days: '',
      days_month: '',
      progress_percent: '',
      accumulated_days: '',
      accumulated_progress: '',
      observations: '',
    };
  }

  function addNewRow() {
    const hasEmpty = newRows.some((r) => !r.report_line_id && !(r.item_general ?? '').trim() && !(r.item_activity ?? '').trim());
    if (hasEmpty) return;
    setNewRows((prev) => [...prev, getEmptyNewRow()]);
  }

  function addNewRowFromExternal() {
    // si hay filtro de fecha en el toolbar, úsalo para precargar la fecha
    const forcedDate = (filters?.reportDate || '').trim();
    const hasEmpty = newRows.some((r) => !r.report_line_id && !(r.item_general ?? '').trim() && !(r.item_activity ?? '').trim());
    if (hasEmpty) return;
    setNewRows((prev) => [...prev, getEmptyNewRow(forcedDate || undefined)]);
  }

  function updateCell(rowId, key, value, isNew) {
    if (isNew) {
      setNewRows((prev) => prev.map((row) => (row._tempId === rowId ? { ...row, [key]: value } : row)));
    } else {
      setPendingChanges((prev) => ({
        ...prev,
        [rowId]: { ...prev[rowId], [key]: value },
      }));
      setLines((prev) => prev.map((r) => (r.report_line_id === rowId ? { ...r, [key]: value } : r)));
    }
  }

  function getValue(row, key, isNew) {
    const id = isNew ? row._tempId : row.report_line_id;
    if (!isNew && pendingChanges[id] && pendingChanges[id][key] !== undefined) {
      return pendingChanges[id][key];
    }
    if (key === 'delivery_medium_id' && row.delivery_medium_name && row.delivery_medium_id === undefined) {
      return '';
    }
    return row[key];
  }

  async function saveNewRow(row) {
    const key = row._tempId;
    if (savingRowRef.current.has(key)) return false;

    const reportDate = row.report_date || new Date().toISOString().split('T')[0];
    if (!reportDate.trim()) {
      setAlert({ type: 'warning', message: 'Fecha de reporte es obligatoria', dismissible: true });
      return false;
    }

    savingRowRef.current.add(key);
    setSaving(true);
    try {
      const mesAReportar = reportDate.slice(0, 7);
      const body = {
        fecha_reporte: reportDate,
        mes_a_reportar: mesAReportar,
        item_general: row.item_general ?? '',
        item_activity: row.item_activity ?? '',
        activity_description: row.activity_description ?? '',
        support_text: row.support_text ?? '',
        delivery_medium_id: row.delivery_medium_id || undefined,
        contracted_days: row.contracted_days === '' ? null : parseInt(row.contracted_days, 10),
        days_month: row.days_month === '' ? 0 : parseFloat(String(row.days_month).replace(',', '.')),
        progress_percent: row.progress_percent === '' ? 0 : parseFloat(String(row.progress_percent).replace(',', '.')),
        accumulated_days: row.accumulated_days === '' ? 0 : parseFloat(String(row.accumulated_days).replace(',', '.')),
        accumulated_progress: row.accumulated_progress === '' ? 0 : parseFloat(String(row.accumulated_progress).replace(',', '.')),
        observations: row.observations ?? '',
      };
      await apiRequest('/reports/lines', { method: 'POST', body: JSON.stringify(body) });
      setNewRows((prev) => prev.filter((r) => r._tempId !== row._tempId));
      await loadCatalogsAndLines();
      if (onDataChange) onDataChange();
      setAlert({ type: 'success', message: 'Línea guardada correctamente', dismissible: true });
      return true;
    } catch (e) {
      setAlert({ type: 'error', message: e.message || 'Error al guardar la línea', dismissible: true });
      return false;
    } finally {
      savingRowRef.current.delete(key);
      setSaving(false);
    }
  }

  async function saveChanges(lineId) {
    if (!pendingChanges[lineId]) return;
    setSaving(true);
    try {
      const row = lines.find((r) => r.report_line_id === lineId);
      const payload = { ...row, ...pendingChanges[lineId] };
      const body = {
        item_general: payload.item_general ?? '',
        item_activity: payload.item_activity ?? '',
        activity_description: payload.activity_description ?? '',
        support_text: payload.support_text ?? '',
        delivery_medium_id: payload.delivery_medium_id || null,
        contracted_days: payload.contracted_days === '' ? null : parseInt(payload.contracted_days, 10),
        days_month: payload.days_month === '' ? 0 : parseFloat(String(payload.days_month).replace(',', '.')),
        progress_percent: payload.progress_percent === '' ? 0 : parseFloat(String(payload.progress_percent).replace(',', '.')),
        accumulated_days: payload.accumulated_days === '' ? 0 : parseFloat(String(payload.accumulated_days).replace(',', '.')),
        accumulated_progress: payload.accumulated_progress === '' ? 0 : parseFloat(String(payload.accumulated_progress).replace(',', '.')),
        observations: payload.observations ?? '',
      };
      await apiRequest(`/reports/lines/${lineId}`, { method: 'PUT', body: JSON.stringify(body) });
      setPendingChanges((prev) => {
        const next = { ...prev };
        delete next[lineId];
        return next;
      });
      await loadCatalogsAndLines();
      if (onDataChange) onDataChange();
      setAlert({ type: 'success', message: 'Cambios guardados', dismissible: true });
    } catch (e) {
      setAlert({ type: 'error', message: e.message || 'Error al guardar', dismissible: true });
    } finally {
      setSaving(false);
    }
  }

  function removeNewRow(tempId) {
    setNewRows((prev) => prev.filter((r) => r._tempId !== tempId));
  }

  function handleDeleteClick(lineId) {
    setDeleteConfirm(lineId);
  }

  async function confirmDelete() {
    if (!deleteConfirm) return;
    setDeleting(true);
    try {
      await apiRequest(`/reports/lines/${deleteConfirm}`, { method: 'DELETE' });
      setLines((prev) => prev.filter((r) => r.report_line_id !== deleteConfirm));
      setPendingChanges((prev) => {
        const next = { ...prev };
        delete next[deleteConfirm];
        return next;
      });
      if (onDataChange) onDataChange();
      setAlert({ type: 'success', message: 'Línea eliminada', dismissible: true });
      setDeleteConfirm(null);
    } catch (e) {
      setAlert({ type: 'error', message: e.message || 'Error al eliminar', dismissible: true });
    } finally {
      setDeleting(false);
    }
  }

  // ✅ Filtros del Wireframe 1 aplicados al listado (solo líneas existentes; newRows siempre visibles arriba).
  // Las filas con cambios pendientes siempre se muestran para no "perder" lo que el usuario está editando.
  const filteredLines = useMemo(() => {
    const dateFilter = (filters?.reportDate || '').trim(); // YYYY-MM-DD
    const statusFilter = (filters?.status || 'all').trim(); // all|draft|ready|alert
    const q = (filters?.search || '').trim().toLowerCase();

    const filtered = lines.filter((row) => {
      const merged = { ...row, ...(pendingChanges[row.report_line_id] || {}) };
      // Fecha: match exacto
      if (dateFilter) {
        const rowDate = fmtDate(merged.report_date) || merged.report_date || '';
        if (rowDate !== dateFilter) return false;
      }

      // Estado: derivado con datos actuales (incl. pendientes)
      if (statusFilter && statusFilter !== 'all') {
        const s = deriveRowStatus(merged);
        if (s !== statusFilter) return false;
      }

      // Búsqueda: ítem/actividad/descripción/obs/soporte
      if (q) {
        const haystack = [
          merged.item_general,
          merged.item_activity,
          merged.activity_description,
          merged.observations,
          merged.support_text,
          merged.delivery_medium_name,
        ]
          .filter(Boolean)
          .join(' ')
          .toLowerCase();

        if (!haystack.includes(q)) return false;
      }

      return true;
    });

    const hasPendingIds = new Set(Object.keys(pendingChanges));
    const filteredIds = new Set(filtered.map((r) => r.report_line_id));
    const missingWithPending = lines.filter(
      (r) => hasPendingIds.has(String(r.report_line_id)) && !filteredIds.has(r.report_line_id)
    );
    return missingWithPending.length > 0 ? [...filtered, ...missingWithPending] : filtered;
  }, [lines, filters, pendingChanges]);

  function renderCell(row, col, isNew) {
    const rowId = isNew ? row._tempId : row.report_line_id;
    const key = col.key;

    if (key === '__status') {
      const displayRow = isNew ? row : { ...row, ...(pendingChanges[rowId] || {}) };
      const status = deriveRowStatus(displayRow);
      const cellClass =
        'px-2 py-1.5 border-r border-slate-200 text-sm overflow-hidden whitespace-nowrap bg-white hover:bg-slate-50';
      return (
        <td key={key} className={cellClass} style={{ width: col.width }}>
          <StatusChip status={status} />
        </td>
      );
    }

    const value = getValue(row, key, isNew);
    const isEditing = editingCell?.id === rowId && editingCell?.key === key;
    const hasChanges = !isNew && pendingChanges[rowId]?.[key] !== undefined;
    const readOnly = col.readOnly === true;

    const cellClass = `px-2 py-1.5 border-r border-slate-200 text-sm overflow-hidden whitespace-nowrap ${
      hasChanges ? 'bg-amber-50' : isNew ? 'bg-emerald-50/30' : 'bg-white'
    } ${isEditing ? 'ring-2 ring-inset ring-green-500' : ''} hover:bg-slate-50`;

    if (col.type === 'select-delivery') {
      return (
        <td key={key} className={cellClass} style={{ width: col.width }}>
          <select
            value={value || ''}
            onChange={(e) => updateCell(rowId, key, e.target.value, isNew)}
            className="w-full bg-transparent border-0 text-xs focus:outline-none focus:ring-0 p-0 cursor-pointer truncate"
          >
            <option value="">Seleccionar</option>
            {deliveryMedia.map((m) => (
              <option key={m.id} value={m.id}>
                {m.name}
              </option>
            ))}
          </select>
        </td>
      );
    }

    if (col.type === 'date') {
      return (
        <td key={key} className={cellClass} style={{ width: col.width }}>
          <input
            type="date"
            value={fmtDate(value) || value || ''}
            onChange={(e) => updateCell(rowId, key, e.target.value, isNew)}
            className="w-full min-w-0 bg-transparent border-0 text-xs focus:outline-none focus:ring-0 p-0"
          />
        </td>
      );
    }

    if (col.type === 'progress') {
      const num = parseDecimal(value);
      const pct = num !== null && Number.isFinite(num) ? Math.min(100, Math.max(0, num)) : 0;
      const displayVal = value ?? '';
      const handleProgressChange = (newVal) => {
        const v = parseFloat(String(newVal).replace(',', '.'));
        if (Number.isFinite(v)) updateCell(rowId, key, Math.min(100, Math.max(0, v)), isNew);
        else updateCell(rowId, key, newVal, isNew);
      };
      return (
        <td key={key} className={cellClass} style={{ width: col.width }}>
          <div className="flex items-center gap-2 w-full min-w-0">
            <div className="relative flex-1 min-w-0 h-3 flex items-center">
              <div className="absolute inset-0 h-3 bg-slate-200 rounded-full overflow-hidden shadow-inner" />
              <div
                className="absolute left-0 top-0 h-3 bg-gradient-to-r from-green-500 to-green-600 rounded-full transition-[width] duration-200 ease-out shadow-sm"
                style={{ width: `${pct}%` }}
              />
              <input
                type="range"
                min={0}
                max={100}
                step={0.5}
                value={pct}
                onChange={(e) => handleProgressChange(e.target.value)}
                className="absolute inset-0 w-full h-3 opacity-0 cursor-pointer"
              />
            </div>
            <input
              type="text"
              inputMode="decimal"
              value={displayVal}
              onChange={(e) => updateCell(rowId, key, e.target.value, isNew)}
              onBlur={(e) => {
                const v = parseDecimal(e.target.value);
                if (v !== null && Number.isFinite(v)) handleProgressChange(v);
              }}
              placeholder="0"
              className="w-10 shrink-0 px-1.5 py-0.5 text-xs font-medium text-slate-700 text-right border border-slate-300 rounded-md bg-white focus:outline-none focus:ring-2 focus:ring-green-500/50 focus:border-green-500"
            />
            <span className="text-xs font-medium text-slate-500 shrink-0 w-5">%</span>
          </div>
        </td>
      );
    }

    if (col.type === 'number') {
      return (
        <td key={key} className={cellClass} style={{ width: col.width }}>
          <input
            type="text"
            inputMode="decimal"
            value={value ?? ''}
            onChange={(e) => updateCell(rowId, key, e.target.value, isNew)}
            onFocus={() => setEditingCell({ id: rowId, key })}
            className="w-full min-w-0 bg-transparent border-0 text-xs focus:outline-none focus:ring-0 p-0 text-right"
          />
        </td>
      );
    }

    if (readOnly) {
      const displayValue = key === 'reporter_name' ? value || reporterName || '-' : value || '-';
      return (
        <td key={key} className={cellClass} style={{ width: col.width }}>
          <span className="block truncate text-slate-600">{displayValue}</span>
        </td>
      );
    }

    if (isEditing) {
      return (
        <td key={key} className={cellClass} style={{ width: col.width }}>
          <input
            id={`cell-${rowId}-${key}`}
            ref={inputRef}
            type="text"
            value={value ?? ''}
            onChange={(e) => updateCell(rowId, key, e.target.value, isNew)}
            onBlur={() => setEditingCell(null)}
            onKeyDown={(e) => {
              if (e.key === 'Enter') setEditingCell(null);
              if (e.key === 'Escape') setEditingCell(null);
            }}
            className="w-full min-w-0 bg-transparent border-0 text-sm focus:outline-none focus:ring-0 p-0"
          />
        </td>
      );
    }

    return (
      <td
        key={key}
        className={`${cellClass} cursor-text max-w-0`}
        style={{ width: col.width }}
        onClick={() => setEditingCell({ id: rowId, key })}
      >
        <span className={`block truncate ${!value ? 'text-slate-400 italic text-xs' : 'text-slate-900'}`}>
          {value || (key === 'activity_description' ? 'Clic para escribir...' : '-')}
        </span>
      </td>
    );
  }

  function renderRow(row, isNew) {
    const rowId = isNew ? row._tempId : row.report_line_id;
    const hasChanges = !isNew && Object.keys(pendingChanges[rowId] || {}).length > 0;

    return (
      <tr key={isNew ? row._tempId : row.report_line_id} className="group border-b border-slate-100 last:border-b-0">
        {COLUMNS.map((col) => renderCell(row, col, isNew))}
        <td className="px-1 py-1.5 text-center bg-slate-50/50 border-r border-slate-200 w-20">
          {isNew ? (
            <>
              <button
                onClick={() => saveNewRow(row)}
                disabled={saving || !(row.report_date ?? '').trim()}
                className="p-1 text-emerald-600 hover:bg-emerald-100 rounded-md disabled:opacity-50"
                title="Guardar"
              >
                <Check className="w-3.5 h-3.5" strokeWidth={2.5} />
              </button>
              <button
                onClick={() => removeNewRow(row._tempId)}
                className="p-1 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-md"
                title="Quitar"
              >
                <X className="w-3.5 h-3.5" strokeWidth={2} />
              </button>
            </>
          ) : (
            <>
              {hasChanges && (
                <button
                  onClick={() => saveChanges(rowId)}
                  disabled={saving}
                  className="p-1 text-emerald-600 hover:bg-emerald-100 rounded-md disabled:opacity-50"
                  title="Guardar"
                >
                  <Save className="w-3.5 h-3.5" strokeWidth={2} />
                </button>
              )}
              <button
                onClick={() => handleDeleteClick(rowId)}
                className="p-1 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-md opacity-0 group-hover:opacity-100"
                title="Eliminar"
              >
                <Trash2 className="w-3.5 h-3.5" strokeWidth={2} />
              </button>
            </>
          )}
        </td>
      </tr>
    );
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-48 bg-white rounded-xl border border-slate-200">
        <Loader2 className="h-8 w-8 text-green-600 animate-spin" strokeWidth={1.75} />
      </div>
    );
  }

  // newRows arriba siempre visibles; líneas filtradas debajo
  const hasResults = filteredLines.length > 0 || newRows.length > 0;
  const minTableWidth = COLUMNS.reduce((acc, c) => acc + (parseInt(c.width, 10) || 100), 0) + 80;

  return (
    <div className="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm flex flex-col h-full">
      {/* Toolbar interna opcional (desactívala para Wireframe 1) */}
      {!hideInternalToolbar && (
        <div className="flex items-center justify-between px-4 py-2.5 border-b border-slate-200 bg-slate-50 flex-shrink-0">
          <div className="flex items-center gap-3">
            <span className="text-sm font-medium text-slate-600">
              {filteredLines.length} línea(s) de reporte
              {Object.keys(pendingChanges).length > 0 && (
                <span className="flex items-center gap-1 text-xs text-amber-700 bg-amber-100 px-2 py-0.5 rounded-full ml-2">
                  <AlertCircle className="w-3 h-3" />
                  Sin guardar
                </span>
              )}
            </span>
          </div>
          <button
            onClick={addNewRow}
            className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700"
          >
            <Plus className="w-4 h-4" strokeWidth={2.5} />
            Nueva línea
          </button>
        </div>
      )}

      <div className="overflow-auto flex-1 min-h-0">
        <table className="w-full border-collapse table-fixed" style={{ minWidth: minTableWidth }}>
          <thead className="sticky top-0 z-10 shadow-sm bg-slate-700 text-white">
            <tr>
              {COLUMNS.map((col) => (
                <th
                  key={col.key}
                  className="px-2 py-2 text-left text-xs font-semibold uppercase tracking-wider border-r border-slate-600 truncate"
                  style={{ width: col.width }}
                >
                  {col.label}
                </th>
              ))}
              <th className="px-2 py-2 text-center text-xs font-semibold w-20 border-r border-slate-600" />
            </tr>
          </thead>
          <tbody>
            {newRows.map((row) => renderRow(row, true))}
            {filteredLines.map((row) => renderRow(row, false))}

            {!hasResults && (
              <tr>
                <td colSpan={COLUMNS.length + 1} className="px-4 py-12 text-center bg-slate-50">
                  <div className="flex flex-col items-center gap-3">
                    <Inbox className="w-10 h-10 text-slate-400" />
                    <p className="text-sm text-slate-600">No hay líneas de reporte para los filtros seleccionados.</p>
                    <button
                      onClick={addNewRowFromExternal}
                      className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm text-white bg-green-600 hover:bg-green-700 rounded-lg"
                    >
                      <Plus className="w-4 h-4" />
                      Nueva línea
                    </button>
                  </div>
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      <div className="px-4 py-2 border-t border-slate-100 bg-slate-50/50 text-xs text-slate-500">
        Clic en celda para editar · Guarde cada fila con el botón de check (nueva) o disco (edición)
      </div>

      {alert && (
        <div className="fixed top-4 right-4 z-50 max-w-md">
          <Alert type={alert.type} dismissible onDismiss={() => setAlert(null)}>
            {alert.message}
          </Alert>
        </div>
      )}

      <ConfirmDialog
        isOpen={!!deleteConfirm}
        title="Eliminar línea"
        message="¿Eliminar esta línea de reporte? Esta acción no se puede deshacer."
        type="warning"
        confirmText="Eliminar"
        cancelText="Cancelar"
        loading={deleting}
        onConfirm={confirmDelete}
        onCancel={() => setDeleteConfirm(null)}
      />
    </div>
  );
}
