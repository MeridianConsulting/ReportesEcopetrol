// components/TaskFiltersBar.js
'use client';

import { useState, useRef, useEffect } from 'react';
import { 
  Filter, 
  Calendar, 
  ChevronDown,
  ArrowUpDown,
  RotateCcw,
  User,
  Check,
  Minus
} from 'lucide-react';

// Opciones para multiselección (sin "Todos"/"Todas" en la lista; se maneja aparte)
const ESTADOS_OPTIONS = ['No iniciada', 'En progreso', 'En revisión', 'Completada', 'En riesgo'];
const PRIORIDADES_OPTIONS = ['Alta', 'Media', 'Baja'];
const SORT_OPTIONS = [
  { value: 'desc', label: 'Más recientes primero' },
  { value: 'asc', label: 'Más antiguas primero' }
];

const DATE_PRESETS = [
  { value: 'today', label: 'Hoy' },
  { value: 'week', label: 'Semana' },
  { value: 'month', label: 'Mes' },
  { value: 'all', label: 'Todas' },
];

function fmtDate(d) {
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function computeDateRange(preset) {
  if (preset === 'today') {
    const t = fmtDate(new Date());
    return { from: t, to: t };
  }
  if (preset === 'week') {
    const now = new Date();
    const day = now.getDay();
    const mon = new Date(now);
    mon.setDate(now.getDate() - (day === 0 ? 6 : day - 1));
    const sun = new Date(mon);
    sun.setDate(mon.getDate() + 6);
    return { from: fmtDate(mon), to: fmtDate(sun) };
  }
  if (preset === 'month') {
    const now = new Date();
    return {
      from: fmtDate(new Date(now.getFullYear(), now.getMonth(), 1)),
      to: fmtDate(new Date(now.getFullYear(), now.getMonth() + 1, 0))
    };
  }
  return { from: null, to: null };
}

// Normaliza valor de filtro: puede venir null, string (legacy) o array
function normalizeFilterValue(val) {
  if (val == null) return null;
  if (Array.isArray(val)) return val.length ? val : null;
  return [val];
}

// Resumen para etiqueta del botón: "Todos", un nombre, o "N seleccionados" / "A, B +1"
function getMultiSelectSummary(value, options, allLabel = 'Todos') {
  const selected = normalizeFilterValue(value);
  if (!selected || selected.length === 0) return allLabel;
  if (selected.length >= options.length) return allLabel;
  if (selected.length === 1) return selected[0];
  if (selected.length <= 2) return selected.join(', ');
  return `${selected[0]}, ${selected[1]} +${selected.length - 2}`;
}

// Componente reutilizable: dropdown con checkboxes y opción "Todos"
function MultiSelectFilter({
  options,
  value,
  onChange,
  allLabel,
  open,
  onOpenChange,
  containerRef,
  minWidth = '160px',
  maxHeight = '320px',
  getOptionLabel = (v) => v,
  getSummaryLabel,
}) {
  const selected = normalizeFilterValue(value);
  const isAll = !selected || selected.length >= options.length;
  const isIndeterminate = selected && selected.length > 0 && selected.length < options.length;
  const allCheckboxRef = useRef(null);
  useEffect(() => {
    const el = allCheckboxRef.current;
    if (el) el.indeterminate = isIndeterminate;
  }, [isIndeterminate]);

  const handleToggleAll = () => {
    onChange(null); // null = ver todo
  };

  const handleToggleOption = (optionValue) => {
    const next = selected ? [...selected] : [...options];
    const idx = next.indexOf(optionValue);
    if (idx === -1) next.push(optionValue);
    else next.splice(idx, 1);
    if (next.length === 0) onChange(null);
    else if (next.length >= options.length) onChange(null);
    else onChange(next);
  };

  const handleSelectAll = () => onChange(null);
  const handleClear = () => onChange(null);

  const optionChecked = (opt) => isAll || (selected && selected.includes(opt));

  return (
    <div className="relative" ref={containerRef}>
      <button
        type="button"
        onClick={() => onOpenChange(!open)}
        className="flex items-center gap-1.5 sm:gap-2 px-2.5 sm:px-3 py-2 bg-white border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors text-xs sm:text-sm min-w-[100px] sm:min-w-0"
      >
        <span className="text-slate-700 truncate">
          {getSummaryLabel ? getSummaryLabel(value) : getMultiSelectSummary(value, options, allLabel)}
        </span>
        <ChevronDown className={`w-3 h-3 text-slate-400 transition-transform flex-shrink-0 ${open ? 'rotate-180' : ''}`} />
      </button>
      {open && (
        <div
          className="absolute top-full left-0 mt-2 bg-white rounded-xl border border-slate-200 shadow-lg z-50 overflow-hidden min-w-[200px]"
          style={{ minWidth, maxHeight }}
        >
          <div className="max-h-[300px] overflow-y-auto">
            {/* Opción "Todos" */}
            <label className="flex items-center gap-3 px-4 py-2.5 text-sm cursor-pointer hover:bg-slate-50 border-b border-slate-100">
              <span className="flex items-center justify-center w-4 h-4 flex-shrink-0 border border-slate-300 rounded text-indigo-600">
                {isAll ? <Check className="w-2.5 h-2.5" /> : isIndeterminate ? <Minus className="w-2.5 h-2.5" /> : null}
              </span>
              <span className={isAll ? 'font-medium text-indigo-700' : 'text-slate-700'}>{allLabel}</span>
              <input
                type="checkbox"
                className="sr-only"
                checked={isAll}
                ref={allCheckboxRef}
                onChange={handleToggleAll}
              />
            </label>
            {options.map((opt) => (
              <label
                key={opt}
                className="flex items-center gap-3 px-4 py-2.5 text-sm cursor-pointer hover:bg-slate-50 text-slate-700"
              >
                <span className="flex items-center justify-center w-4 h-4 flex-shrink-0 border border-slate-300 rounded text-indigo-600">
                  {optionChecked(opt) ? <Check className="w-2.5 h-2.5" /> : null}
                </span>
                <span>{getOptionLabel(opt)}</span>
                <input
                  type="checkbox"
                  className="sr-only"
                  checked={optionChecked(opt)}
                  onChange={() => handleToggleOption(opt)}
                />
              </label>
            ))}
          </div>
          <div className="flex justify-between gap-2 px-3 py-2 border-t border-slate-100 bg-slate-50">
            <button type="button" onClick={handleSelectAll} className="text-xs text-indigo-600 hover:text-indigo-800 font-medium">
              Seleccionar todo
            </button>
            <button type="button" onClick={handleClear} className="text-xs text-slate-600 hover:text-slate-800">
              Limpiar
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

// KPI: opciones son { id, name }; value = null | number[] | number
function KpiMultiSelectFilter({ kpiCategories, value, onChange, open, onOpenChange, containerRef }) {
  const options = kpiCategories.map((c) => c.id);
  const selected = normalizeFilterValue(value);
  const isAll = !selected || selected.length >= options.length;
  const isIndeterminate = selected && selected.length > 0 && selected.length < options.length;
  const allCheckboxRef = useRef(null);
  useEffect(() => {
    const el = allCheckboxRef.current;
    if (el) el.indeterminate = isIndeterminate;
  }, [isIndeterminate]);

  const getLabel = (id) => kpiCategories.find((c) => c.id === id)?.name ?? String(id);

  const handleToggleAll = () => onChange(null);
  const handleSelectAll = () => onChange(null);
  const handleClear = () => onChange(null);
  const handleToggleOption = (id) => {
    const next = selected ? [...selected] : options.slice();
    const idx = next.indexOf(id);
    if (idx === -1) next.push(id);
    else next.splice(idx, 1);
    if (next.length === 0) onChange(null);
    else if (next.length >= options.length) onChange(null);
    else onChange(next);
  };

  const optionChecked = (id) => isAll || (selected && selected.includes(id));

  const getSummaryLabel = (val) => {
    const s = normalizeFilterValue(val);
    if (!s || s.length === 0) return 'Todos';
    if (s.length >= options.length) return 'Todos';
    if (s.length === 1) return getLabel(s[0]);
    return `${s.length} seleccionados`;
  };

  return (
    <div className="relative" ref={containerRef}>
      <button
        type="button"
        onClick={() => onOpenChange(!open)}
        className="flex items-center gap-1.5 sm:gap-2 px-2.5 sm:px-3 py-2 bg-white border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors text-xs sm:text-sm min-w-[100px] sm:min-w-[150px]"
      >
        <span className="text-slate-700 truncate">{getSummaryLabel(value)}</span>
        <ChevronDown className={`w-3 h-3 text-slate-400 transition-transform flex-shrink-0 ${open ? 'rotate-180' : ''}`} />
      </button>
      {open && (
        <div className="absolute top-full left-0 mt-2 bg-white rounded-xl border border-slate-200 shadow-lg z-50 overflow-hidden min-w-[250px] max-h-[320px]">
          <div className="max-h-[260px] overflow-y-auto">
            <label className="flex items-center gap-3 px-4 py-2.5 text-sm cursor-pointer hover:bg-slate-50 border-b border-slate-100">
              <span className="flex items-center justify-center w-4 h-4 flex-shrink-0 border border-slate-300 rounded text-indigo-600">
                {isAll ? <Check className="w-2.5 h-2.5" /> : isIndeterminate ? <Minus className="w-2.5 h-2.5" /> : null}
              </span>
              <span className={isAll ? 'font-medium text-indigo-700' : 'text-slate-700'}>Todos</span>
              <input type="checkbox" className="sr-only" checked={isAll} ref={allCheckboxRef} onChange={handleToggleAll} />
            </label>
            {kpiCategories.map((cat) => (
              <label key={cat.id} className="flex items-center gap-3 px-4 py-2.5 text-sm cursor-pointer hover:bg-slate-50 text-slate-700">
                <span className="flex items-center justify-center w-4 h-4 flex-shrink-0 border border-slate-300 rounded text-indigo-600">
                  {optionChecked(cat.id) ? <Check className="w-2.5 h-2.5" /> : null}
                </span>
                <span className="truncate">{cat.name}</span>
                <input type="checkbox" className="sr-only" checked={optionChecked(cat.id)} onChange={() => handleToggleOption(cat.id)} />
              </label>
            ))}
          </div>
          <div className="flex justify-between gap-2 px-3 py-2 border-t border-slate-100 bg-slate-50">
            <button type="button" onClick={handleSelectAll} className="text-xs text-indigo-600 hover:text-indigo-800 font-medium">Seleccionar todo</button>
            <button type="button" onClick={handleClear} className="text-xs text-slate-600 hover:text-slate-800">Limpiar</button>
          </div>
        </div>
      )}
    </div>
  );
}

export default function TaskFiltersBar({ 
  filters, 
  onFiltersChange, 
  kpiCategories = [],
  users = [],
  onClearFilters 
}) {
  const [isStatusOpen, setIsStatusOpen] = useState(false);
  const [isPriorityOpen, setIsPriorityOpen] = useState(false);
  const [isKpiOpen, setIsKpiOpen] = useState(false);
  const [isPersonOpen, setIsPersonOpen] = useState(false);
  const [isSortOpen, setIsSortOpen] = useState(false);
  const [isCustomDateOpen, setIsCustomDateOpen] = useState(false);
  const statusRef = useRef(null);
  const priorityRef = useRef(null);
  const kpiRef = useRef(null);
  const personRef = useRef(null);
  const sortRef = useRef(null);
  const customDateRef = useRef(null);

  useEffect(() => {
    function handleClickOutside(event) {
      if (statusRef.current && !statusRef.current.contains(event.target)) setIsStatusOpen(false);
      if (priorityRef.current && !priorityRef.current.contains(event.target)) setIsPriorityOpen(false);
      if (kpiRef.current && !kpiRef.current.contains(event.target)) setIsKpiOpen(false);
      if (personRef.current && !personRef.current.contains(event.target)) setIsPersonOpen(false);
      if (sortRef.current && !sortRef.current.contains(event.target)) setIsSortOpen(false);
      if (customDateRef.current && !customDateRef.current.contains(event.target)) setIsCustomDateOpen(false);
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handlePresetChange = (preset) => {
    const range = computeDateRange(preset);
    onFiltersChange({ ...filters, datePreset: preset, date_from: range.from, date_to: range.to });
    setIsCustomDateOpen(false);
  };

  const handleCustomDateChange = (field, value) => {
    onFiltersChange({ ...filters, datePreset: 'custom', [field]: value || null });
  };

  const handleStatusChange = (value) => {
    onFiltersChange({ ...filters, status: value ?? null });
    if (value == null) setIsStatusOpen(false);
  };

  const handlePriorityChange = (value) => {
    onFiltersChange({ ...filters, priority: value ?? null });
    if (value == null) setIsPriorityOpen(false);
  };

  const handleKpiChange = (value) => {
    onFiltersChange({ ...filters, kpi_category_id: value ?? null });
    if (value == null) setIsKpiOpen(false);
  };

  const handlePersonChange = (userId) => {
    onFiltersChange({ ...filters, responsible_id: userId === '' || userId === 'Todos' ? null : parseInt(userId) });
    setIsPersonOpen(false);
  };

  const handleSortChange = (sortOrder) => {
    onFiltersChange({ ...filters, sortOrder });
    setIsSortOpen(false);
  };

  const activePreset = filters.datePreset || 'today';
  const hasStatusFilter = (v) => Array.isArray(v) ? v.length > 0 : v != null && v !== '';
  const hasActiveFilters =
    hasStatusFilter(filters.status) || hasStatusFilter(filters.priority) || hasStatusFilter(filters.kpi_category_id) ||
    filters.responsible_id || activePreset !== 'today' || filters.sortOrder !== 'desc';

  const getPersonLabel = () => {
    if (!filters.responsible_id) return 'Todos';
    const person = users.find(u => u.id === filters.responsible_id);
    return person ? person.name : 'Todos';
  };

  return (
    <div className="bg-white border-b border-slate-200 px-3 sm:px-4 py-3 flex-shrink-0">
      <div className="flex flex-wrap items-center gap-2 sm:gap-3">
        {/* Icono y título */}
        <div className="flex items-center gap-2 text-sm font-medium text-slate-700">
          <Filter className="w-4 h-4 text-slate-500" />
          <span className="hidden sm:inline">Filtros:</span>
        </div>

        {/* Presets de fecha */}
        <div className="flex items-center gap-0.5 bg-slate-100 rounded-lg p-0.5">
          {DATE_PRESETS.map(p => (
            <button
              key={p.value}
              onClick={() => handlePresetChange(p.value)}
              className={`px-2.5 py-1.5 text-xs font-medium rounded-md transition-all ${
                activePreset === p.value
                  ? 'bg-white text-indigo-700 shadow-sm ring-1 ring-slate-200'
                  : 'text-slate-600 hover:text-slate-800 hover:bg-slate-50'
              }`}
            >
              {p.label}
            </button>
          ))}
        </div>

        {/* Rango personalizado */}
        <div className="relative" ref={customDateRef}>
          <button
            onClick={() => setIsCustomDateOpen(!isCustomDateOpen)}
            className={`flex items-center gap-1.5 px-2.5 py-2 border rounded-lg hover:bg-slate-50 transition-colors text-xs sm:text-sm ${
              activePreset === 'custom'
                ? 'border-indigo-300 bg-indigo-50 text-indigo-700'
                : 'border-slate-200 bg-white text-slate-700'
            }`}
          >
            <Calendar className="w-3.5 h-3.5" />
            <span className="hidden sm:inline">
              {activePreset === 'custom' && filters.date_from
                ? `${new Date(filters.date_from + 'T12:00:00').toLocaleDateString('es-ES', { day: '2-digit', month: 'short' })}${filters.date_to ? ' – ' + new Date(filters.date_to + 'T12:00:00').toLocaleDateString('es-ES', { day: '2-digit', month: 'short' }) : ''}`
                : 'Rango'}
            </span>
            <span className="sm:hidden">
              {activePreset === 'custom' ? '📅' : 'Rango'}
            </span>
            <ChevronDown className={`w-3 h-3 text-slate-400 transition-transform ${isCustomDateOpen ? 'rotate-180' : ''}`} />
          </button>
          {isCustomDateOpen && (
            <div className="absolute top-full left-0 mt-2 bg-white rounded-xl border border-slate-200 shadow-lg z-50 p-3 w-64 sm:w-80">
              <label className="block text-xs font-medium text-slate-600 mb-2">Fecha desde (start_date)</label>
              <input
                type="date"
                value={filters.date_from || ''}
                onChange={(e) => handleCustomDateChange('date_from', e.target.value)}
                className="w-full px-3 py-2 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
              <label className="block text-xs font-medium text-slate-600 mb-2 mt-3">Fecha hasta</label>
              <input
                type="date"
                value={filters.date_to || ''}
                onChange={(e) => handleCustomDateChange('date_to', e.target.value)}
                min={filters.date_from || ''}
                className="w-full px-3 py-2 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
              <div className="mt-3 flex justify-end">
                <button
                  onClick={() => handlePresetChange('today')}
                  className="text-xs text-slate-600 hover:text-slate-800"
                >
                  Volver a Hoy
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Filtro de Estado (multiselección) */}
        <MultiSelectFilter
          options={ESTADOS_OPTIONS}
          value={filters.status}
          onChange={handleStatusChange}
          allLabel="Todos"
          open={isStatusOpen}
          onOpenChange={setIsStatusOpen}
          containerRef={statusRef}
          minWidth="180px"
        />

        {/* Filtro de Prioridad (multiselección) */}
        <MultiSelectFilter
          options={PRIORIDADES_OPTIONS}
          value={filters.priority}
          onChange={handlePriorityChange}
          allLabel="Todas"
          open={isPriorityOpen}
          onOpenChange={setIsPriorityOpen}
          containerRef={priorityRef}
          minWidth="140px"
        />

        {/* Filtro de KPI (multiselección) */}
        <KpiMultiSelectFilter
          kpiCategories={kpiCategories}
          value={filters.kpi_category_id}
          onChange={handleKpiChange}
          open={isKpiOpen}
          onOpenChange={setIsKpiOpen}
          containerRef={kpiRef}
        />

        {/* Filtro de Persona */}
        {users.length > 0 && (
          <div className="relative" ref={personRef}>
            <button
              onClick={() => setIsPersonOpen(!isPersonOpen)}
              className="flex items-center gap-1.5 sm:gap-2 px-2.5 sm:px-3 py-2 bg-white border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors text-xs sm:text-sm min-w-[100px] sm:min-w-[150px]"
            >
              <User className="w-3.5 h-3.5 text-slate-500 flex-shrink-0" />
              <span className="text-slate-700 truncate">{getPersonLabel()}</span>
              <ChevronDown className={`w-3 h-3 text-slate-400 transition-transform flex-shrink-0 ${isPersonOpen ? 'rotate-180' : ''}`} />
            </button>
            {isPersonOpen && (
              <div className="absolute top-full left-0 mt-2 bg-white rounded-xl border border-slate-200 shadow-lg z-50 overflow-hidden max-h-[300px] overflow-y-auto min-w-[200px]">
                <button
                  onClick={() => handlePersonChange('Todos')}
                  className={`w-full px-4 py-2.5 text-left text-sm transition-colors flex items-center justify-between ${
                    !filters.responsible_id
                      ? 'bg-indigo-50 text-indigo-700 font-medium' 
                      : 'text-slate-700 hover:bg-slate-50'
                  }`}
                >
                  Todos
                  {!filters.responsible_id && (
                    <div className="w-1.5 h-1.5 bg-indigo-600 rounded-full"></div>
                  )}
                </button>
                {users.map(user => (
                  <button
                    key={user.id}
                    onClick={() => handlePersonChange(user.id)}
                    className={`w-full px-4 py-2.5 text-left text-sm transition-colors flex items-center justify-between ${
                      filters.responsible_id === user.id
                        ? 'bg-indigo-50 text-indigo-700 font-medium' 
                        : 'text-slate-700 hover:bg-slate-50'
                    }`}
                  >
                    <span className="truncate">{user.name}</span>
                    {filters.responsible_id === user.id && (
                      <div className="w-1.5 h-1.5 bg-indigo-600 rounded-full flex-shrink-0 ml-2"></div>
                    )}
                  </button>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Ordenamiento */}
        <div className="relative" ref={sortRef}>
          <button
            onClick={() => setIsSortOpen(!isSortOpen)}
            className="flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors text-sm"
          >
            <ArrowUpDown className="w-4 h-4 text-slate-500" />
            <span className="text-slate-700 hidden sm:inline">
              {SORT_OPTIONS.find(o => o.value === (filters.sortOrder || 'desc'))?.label || 'Más recientes primero'}
            </span>
            <ChevronDown className={`w-3 h-3 text-slate-400 transition-transform ${isSortOpen ? 'rotate-180' : ''}`} />
          </button>
          {isSortOpen && (
            <div className="absolute top-full right-0 mt-2 bg-white rounded-xl border border-slate-200 shadow-lg z-50 overflow-hidden min-w-[200px]">
              {SORT_OPTIONS.map(option => (
                <button
                  key={option.value}
                  onClick={() => handleSortChange(option.value)}
                  className={`w-full px-4 py-2.5 text-left text-sm transition-colors flex items-center justify-between ${
                    (filters.sortOrder || 'desc') === option.value
                      ? 'bg-indigo-50 text-indigo-700 font-medium' 
                      : 'text-slate-700 hover:bg-slate-50'
                  }`}
                >
                  {option.label}
                  {(filters.sortOrder || 'desc') === option.value && (
                    <div className="w-1.5 h-1.5 bg-indigo-600 rounded-full"></div>
                  )}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Botón limpiar filtros */}
        {hasActiveFilters && (
          <button
            onClick={onClearFilters}
            className="flex items-center gap-1.5 px-2.5 sm:px-3 py-2 text-xs sm:text-sm text-slate-600 hover:text-slate-800 hover:bg-slate-50 rounded-lg transition-colors border border-slate-200"
          >
            <RotateCcw className="w-3.5 h-3.5 sm:w-4 sm:h-4" />
            <span>Limpiar</span>
          </button>
        )}
      </div>
    </div>
  );
}
