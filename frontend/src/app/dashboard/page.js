// app/dashboard/page.js
'use client';

import { Suspense, useEffect, useState, useCallback, useRef } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Layout from '../../components/Layout';
import TaskList from '../../components/TaskList';
import DateRangeFilter from '../../components/DateRangeFilter';
import { apiRequest } from '../../lib/api';
import { 
  ClipboardList, 
  PlayCircle, 
  CheckCircle2, 
  AlertTriangle,
  Filter,
  Loader2,
  RefreshCw,
  ChevronDown,
  X,
  Clock,
  Calendar
} from 'lucide-react';

const today = new Date().toISOString().split('T')[0];

function DashboardContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [user, setUser] = useState(null);
  const [filters, setFilters] = useState({
    status: '',
    priority: '',
  });
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);
  const [currentPeriod, setCurrentPeriod] = useState('today');
  const [openFilter, setOpenFilter] = useState(null);
  const statusDropdownRef = useRef(null);
  const priorityDropdownRef = useRef(null);
  const listSectionRef = useRef(null);
  const initialUrlSynced = useRef(false);

  const STATUS_OPTIONS = [
    { value: '', label: 'Todos los estados' },
    { value: 'No iniciada', label: 'No iniciada' },
    { value: 'En progreso', label: 'En progreso' },
    { value: 'En revisión', label: 'En revisión' },
    { value: 'Completada', label: 'Completada' },
    { value: 'En riesgo', label: 'En riesgo' },
    { value: 'overdue', label: 'Vencidas' },
  ];
  const PRIORITY_OPTIONS = [
    { value: '', label: 'Todas las prioridades' },
    { value: 'Alta', label: 'Alta' },
    { value: 'Media', label: 'Media' },
    { value: 'Baja', label: 'Baja' },
  ];

  // Cerrar dropdowns al hacer click fuera
  useEffect(() => {
    function handleClickOutside(event) {
      if (statusDropdownRef.current && !statusDropdownRef.current.contains(event.target) &&
          priorityDropdownRef.current && !priorityDropdownRef.current.contains(event.target)) {
        setOpenFilter(null);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Sincronizar filtros con la URL al cargar (conservar filtro al navegar)
  useEffect(() => {
    if (initialUrlSynced.current) return;
    const status = searchParams.get('status');
    const from = searchParams.get('date_from');
    const to = searchParams.get('date_to');
    if (status != null && status !== '') {
      setFilters(f => ({ ...f, status }));
    }
    if (from) setDateFrom(from);
    if (to) setDateTo(to);
    initialUrlSynced.current = true;
  }, [searchParams]);

  // Verificar rol del usuario al cargar
  useEffect(() => {
    async function checkUser() {
      try {
        const userData = await apiRequest('/auth/me');
        setUser(userData.data);
        
        if (userData.data.role === 'colaborador') {
          router.push('/my-tasks/');
          return;
        }
      } catch (e) {
        router.push('/login/');
      }
    }
    checkUser();
  }, [router]);

  const loadTasks = useCallback(async (isRefresh = false) => {
    if (isRefresh) setRefreshing(true);
    else setLoading(true);
    try {
      const queryParams = new URLSearchParams();
      if (filters.priority) queryParams.append('priority', filters.priority);
      if (dateFrom) queryParams.append('date_from', dateFrom);
      if (dateTo) queryParams.append('date_to', dateTo);
      const queryString = queryParams.toString();
      const url = `/tasks${queryString ? `?${queryString}` : ''}`;
      const data = await apiRequest(url);
      setTasks(data.data || []);
    } catch (e) {
      // Error loading tasks
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [filters.priority, dateFrom, dateTo]);

  useEffect(() => {
    if (user && user.role !== 'colaborador') {
      loadTasks();
    }
  }, [filters.priority, dateFrom, dateTo, loadTasks, user]);

  const handleDateChange = (from, to, period) => {
    setDateFrom(from || '');
    setDateTo(to || '');
    setCurrentPeriod(period);
  };

  const handleRefresh = () => {
    loadTasks(true);
  };

  const handleCounterClick = useCallback((statusValue) => {
    setFilters(f => ({ ...f, status: statusValue }));
    setOpenFilter(null);
    setTimeout(() => {
      listSectionRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 100);
    const params = new URLSearchParams(searchParams.toString());
    if (statusValue) params.set('status', statusValue); else params.delete('status');
    if (dateFrom) params.set('date_from', dateFrom); else params.delete('date_from');
    if (dateTo) params.set('date_to', dateTo); else params.delete('date_to');
    router.replace(`/dashboard${params.toString() ? '?' + params.toString() : ''}`, { scroll: false });
  }, [dateFrom, dateTo, router, searchParams]);

  const getPeriodLabel = () => {
    const labels = {
      'today': 'de hoy',
      'week': 'de esta semana',
      'month': 'de este mes',
      'quarter': 'de este trimestre',
      'semester': 'de este semestre',
      'year': 'de este año',
      'all': '',
      'custom': 'del rango seleccionado'
    };
    return labels[currentPeriod] || '';
  };

  const todayStr = new Date().toISOString().split('T')[0];
  const isOverdue = (t) => t.due_date && t.due_date < todayStr && t.status !== 'Completada';

  const stats = {
    total: tasks.length,
    notStarted: tasks.filter(t => t.status === 'No iniciada').length,
    inProgress: tasks.filter(t => t.status === 'En progreso').length,
    completed: tasks.filter(t => t.status === 'Completada').length,
    atRisk: tasks.filter(t => t.status === 'En riesgo').length,
    overdue: tasks.filter(isOverdue).length,
  };

  const displayTasks = !filters.status
    ? tasks
    : filters.status === 'overdue'
      ? tasks.filter(isOverdue)
      : tasks.filter(t => t.status === filters.status);

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
      <div className="p-4 sm:p-6 lg:p-8 w-full max-w-7xl mx-auto overflow-hidden">
        {/* Header */}
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
          <div>
            <h1 className="text-2xl font-semibold text-slate-900">Todas las Tareas</h1>
            <p className="text-slate-500 mt-0.5 text-sm">
              Vista general de las tareas {getPeriodLabel()}
            </p>
          </div>
          <div className="flex items-center gap-3">
            <DateRangeFilter 
              onChange={handleDateChange}
              defaultPeriod="today"
            />
            <button
              onClick={handleRefresh}
              disabled={refreshing}
              className="p-2 text-slate-500 hover:text-slate-700 hover:bg-slate-100 rounded-lg transition-colors disabled:opacity-50"
              title="Actualizar datos"
            >
              <RefreshCw className={`w-4 h-4 ${refreshing ? 'animate-spin' : ''}`} />
            </button>
          </div>
        </div>

        {/* Contadores clicables (drill-down) */}
        <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4 mb-8">
          <button
            type="button"
            onClick={() => handleCounterClick('')}
            className={`bg-white rounded-xl p-5 border text-left transition-colors hover:border-green-300 hover:shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-1 ${!filters.status ? 'border-green-400 ring-2 ring-green-200' : 'border-slate-200'}`}
          >
            <div className="flex items-center gap-4">
              <div className="w-11 h-11 bg-slate-100 rounded-xl flex items-center justify-center">
                <ClipboardList className="w-5 h-5 text-slate-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{stats.total}</p>
                <p className="text-sm text-slate-500">Total</p>
              </div>
            </div>
          </button>

          <button
            type="button"
            onClick={() => handleCounterClick('No iniciada')}
            className={`bg-white rounded-xl p-5 border text-left transition-colors hover:border-green-300 hover:shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-1 ${filters.status === 'No iniciada' ? 'border-green-400 ring-2 ring-green-200' : 'border-slate-200'}`}
          >
            <div className="flex items-center gap-4">
              <div className="w-11 h-11 bg-slate-100 rounded-xl flex items-center justify-center">
                <Clock className="w-5 h-5 text-slate-500" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{stats.notStarted}</p>
                <p className="text-sm text-slate-500">Sin iniciar</p>
              </div>
            </div>
          </button>

          <button
            type="button"
            onClick={() => handleCounterClick('En progreso')}
            className={`bg-white rounded-xl p-5 border text-left transition-colors hover:border-green-300 hover:shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-1 ${filters.status === 'En progreso' ? 'border-green-400 ring-2 ring-green-200' : 'border-slate-200'}`}
          >
            <div className="flex items-center gap-4">
              <div className="w-11 h-11 bg-teal-50 rounded-xl flex items-center justify-center">
                <PlayCircle className="w-5 h-5 text-teal-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{stats.inProgress}</p>
                <p className="text-sm text-slate-500">En progreso</p>
              </div>
            </div>
          </button>

          <button
            type="button"
            onClick={() => handleCounterClick('Completada')}
            className={`bg-white rounded-xl p-5 border text-left transition-colors hover:border-green-300 hover:shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-1 ${filters.status === 'Completada' ? 'border-green-400 ring-2 ring-green-200' : 'border-slate-200'}`}
          >
            <div className="flex items-center gap-4">
              <div className="w-11 h-11 bg-emerald-50 rounded-xl flex items-center justify-center">
                <CheckCircle2 className="w-5 h-5 text-emerald-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{stats.completed}</p>
                <p className="text-sm text-slate-500">Completadas</p>
              </div>
            </div>
          </button>

          <button
            type="button"
            onClick={() => handleCounterClick('En riesgo')}
            className={`bg-white rounded-xl p-5 border text-left transition-colors hover:border-green-300 hover:shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-1 ${filters.status === 'En riesgo' ? 'border-green-400 ring-2 ring-green-200' : 'border-slate-200'}`}
          >
            <div className="flex items-center gap-4">
              <div className="w-11 h-11 bg-rose-50 rounded-xl flex items-center justify-center">
                <AlertTriangle className="w-5 h-5 text-rose-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{stats.atRisk}</p>
                <p className="text-sm text-slate-500">En riesgo</p>
              </div>
            </div>
          </button>

          <button
            type="button"
            onClick={() => handleCounterClick('overdue')}
            className={`bg-white rounded-xl p-5 border text-left transition-colors hover:border-green-300 hover:shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-1 ${filters.status === 'overdue' ? 'border-green-400 ring-2 ring-green-200' : 'border-slate-200'}`}
          >
            <div className="flex items-center gap-4">
              <div className="w-11 h-11 bg-amber-50 rounded-xl flex items-center justify-center">
                <Calendar className="w-5 h-5 text-amber-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{stats.overdue}</p>
                <p className="text-sm text-slate-500">Vencidas</p>
              </div>
            </div>
          </button>
        </div>

        {/* Filtros */}
        <div className="bg-white rounded-xl border border-slate-200 p-5 mb-6">
          <div className="flex items-center gap-2 mb-4">
            <Filter className="w-4 h-4 text-slate-500" strokeWidth={2} />
            <span className="text-sm font-medium text-slate-700">Filtros</span>
          </div>
          <div className="flex flex-wrap items-center gap-3">
            {/* Filtro Estado */}
            <div className="relative" ref={statusDropdownRef}>
              <div className="flex items-center gap-2">
                <button
                  type="button"
                  onClick={() => setOpenFilter(openFilter === 'status' ? null : 'status')}
                  className="flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors text-sm"
                >
                  <span className="text-slate-700 font-medium">
                    {filters.status ? STATUS_OPTIONS.find(o => o.value === filters.status)?.label : 'Todos los estados'}
                  </span>
                  <ChevronDown className={`w-4 h-4 text-slate-400 transition-transform ${openFilter === 'status' ? 'rotate-180' : ''}`} />
                </button>
                {filters.status && (
                  <button
                    type="button"
                    onClick={(e) => { e.stopPropagation(); setFilters(f => ({ ...f, status: '' })); setOpenFilter(null); }}
                    className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
                    title="Limpiar estado"
                  >
                    <X className="w-4 h-4" />
                  </button>
                )}
              </div>
              {openFilter === 'status' && (
                <div className="absolute top-full left-0 mt-2 w-56 bg-white rounded-xl border border-slate-200 shadow-lg z-50 overflow-hidden">
                  <div className="py-1">
                    {STATUS_OPTIONS.map(option => (
                      <button
                        key={option.value || 'all'}
                        type="button"
                        onClick={() => {
                          setFilters(f => ({ ...f, status: option.value }));
                          setOpenFilter(null);
                        }}
                        className={`w-full px-4 py-2.5 text-left text-sm transition-colors ${
                          filters.status === option.value
                            ? 'bg-green-50 text-green-700 font-medium'
                            : 'text-slate-700 hover:bg-slate-50'
                        }`}
                      >
                        {option.label}
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* Filtro Prioridad */}
            <div className="relative" ref={priorityDropdownRef}>
              <div className="flex items-center gap-2">
                <button
                  type="button"
                  onClick={() => setOpenFilter(openFilter === 'priority' ? null : 'priority')}
                  className="flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors text-sm"
                >
                  <span className="text-slate-700 font-medium">
                    {filters.priority ? PRIORITY_OPTIONS.find(o => o.value === filters.priority)?.label : 'Todas las prioridades'}
                  </span>
                  <ChevronDown className={`w-4 h-4 text-slate-400 transition-transform ${openFilter === 'priority' ? 'rotate-180' : ''}`} />
                </button>
                {filters.priority && (
                  <button
                    type="button"
                    onClick={(e) => { e.stopPropagation(); setFilters(f => ({ ...f, priority: '' })); setOpenFilter(null); }}
                    className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
                    title="Limpiar prioridad"
                  >
                    <X className="w-4 h-4" />
                  </button>
                )}
              </div>
              {openFilter === 'priority' && (
                <div className="absolute top-full left-0 mt-2 w-56 bg-white rounded-xl border border-slate-200 shadow-lg z-50 overflow-hidden">
                  <div className="py-1">
                    {PRIORITY_OPTIONS.map(option => (
                      <button
                        key={option.value || 'all'}
                        type="button"
                        onClick={() => {
                          setFilters(f => ({ ...f, priority: option.value }));
                          setOpenFilter(null);
                        }}
                        className={`w-full px-4 py-2.5 text-left text-sm transition-colors ${
                          filters.priority === option.value
                            ? 'bg-green-50 text-green-700 font-medium'
                            : 'text-slate-700 hover:bg-slate-50'
                        }`}
                      >
                        {option.label}
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Lista de tareas (drill-down) */}
        <div ref={listSectionRef} className="scroll-mt-4">
          {filters.status && (
            <div className="flex items-center justify-between gap-2 mb-3 px-1">
              <p className="text-sm text-slate-600">
                Mostrando: <span className="font-medium text-slate-900">
                  {filters.status === 'overdue' ? 'Vencidas' : STATUS_OPTIONS.find(o => o.value === filters.status)?.label || filters.status}
                </span>
                {' '}({displayTasks.length} tarea{displayTasks.length !== 1 ? 's' : ''})
              </p>
              <button
                type="button"
                onClick={() => handleCounterClick('')}
                className="text-sm font-medium text-green-600 hover:text-green-800"
              >
                Ver todas
              </button>
            </div>
          )}
          <TaskList tasks={displayTasks} onRefresh={loadTasks} />
        </div>
      </div>
    </Layout>
  );
}

export default function Dashboard() {
  return (
    <Suspense fallback={
      <Layout>
        <div className="flex items-center justify-center py-24">
          <Loader2 className="w-8 h-8 animate-spin text-green-600" />
        </div>
      </Layout>
    }>
      <DashboardContent />
    </Suspense>
  );
}
