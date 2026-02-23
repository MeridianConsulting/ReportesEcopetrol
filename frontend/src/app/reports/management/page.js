// app/reports/management/page.js
'use client';

import { useEffect, useState, useCallback, useRef } from 'react';
import { useRouter } from 'next/navigation';
import dynamic from 'next/dynamic';
import Layout from '../../../components/Layout';
import DateRangeFilter from '../../../components/DateRangeFilter';
import { apiRequest } from '../../../lib/api';
import { getKpiColorAndTheme } from '../../../lib/kpiColors';
import { 
  ClipboardList, 
  CheckCircle2, 
  AlertTriangle, 
  Clock,
  Loader2,
  TrendingUp,
  Target,
  Activity,
  RefreshCw,
  BarChart3,
  LineChart,
  Trophy,
  Calendar,
  Flag,
  Gauge,
  Award,
  AlertCircle,
  Building2,
  ChevronDown,
  ChevronUp,
  FileDown
} from 'lucide-react';

// Importar gráficos dinámicamente para evitar SSR issues
const ResponsivePie = dynamic(() => import('@nivo/pie').then(m => m.ResponsivePie), { 
  ssr: false,
  loading: () => <div className="flex items-center justify-center h-full"><Loader2 className="w-6 h-6 animate-spin text-slate-400" /></div>
});

const ResponsiveLine = dynamic(() => import('@nivo/line').then(m => m.ResponsiveLine), { 
  ssr: false,
  loading: () => <div className="flex items-center justify-center h-full"><Loader2 className="w-6 h-6 animate-spin text-slate-400" /></div>
});

const ResponsiveBar = dynamic(() => import('@nivo/bar').then(m => m.ResponsiveBar), { 
  ssr: false,
  loading: () => <div className="flex items-center justify-center h-full"><Loader2 className="w-6 h-6 animate-spin text-slate-400" /></div>
});

// Componente de KPI compacto (color por valor normalizado 0–100, única fuente de verdad)
function KpiCardCompact({ kpi }) {
  const rawValue = kpi?.value;
  const parsedValue =
    typeof rawValue === 'string' && rawValue.trim() !== ''
      ? Number(rawValue)
      : rawValue;
  const hasNumericValue = typeof parsedValue === 'number' && !Number.isNaN(parsedValue);
  const hasStringValue = typeof parsedValue === 'string' && parsedValue.trim() !== '';
  const isNA = kpi?.is_na === true || (!hasNumericValue && !hasStringValue);
  const naLabel = (kpi?.task_count ?? 0) > 0 ? 'Sin medición' : 'N/A';

  const { theme: colors } = getKpiColorAndTheme(kpi);

  return (
    <div className={`${colors.bg} rounded-lg p-3 border border-slate-200/50`}>
      <div className="flex items-center justify-between mb-1">
        <span className="text-[10px] font-mono text-slate-500 uppercase">{kpi.kpi_code}</span>
        <div className={`w-2 h-2 rounded-full ${colors.dot}`} />
      </div>
      <div className={`text-lg font-bold ${colors.text} tabular-nums`}>
        {isNA ? naLabel : (
          <>
            {typeof parsedValue === 'number' ? parsedValue.toFixed(parsedValue % 1 === 0 ? 0 : 1) : parsedValue}
            {kpi.unit === 'PERCENT' || kpi.unit === '%' ? '%' : ''}
          </>
        )}
      </div>
      <p className="text-xs text-slate-500 truncate" title={kpi.kpi_name}>
        {kpi.kpi_name}
      </p>
      {(kpi.task_count != null && kpi.task_count > 0) && (
        <p className="text-[10px] text-slate-400 mt-1" title="Tareas con este KPI en el período">
          {kpi.task_count} tarea{kpi.task_count !== 1 ? 's' : ''}
        </p>
      )}
    </div>
  );
}

// Componente de área expandible con KPIs
function AreaKpiCard({ area, isExpanded, onToggle }) {
  const stats = area.stats;
  const totalActive = stats.green + stats.yellow + stats.red;
  const healthScore = totalActive > 0 
    ? Math.round(((stats.green * 100) + (stats.yellow * 50)) / totalActive) 
    : null;
  
  const getHealthColor = (score) => {
    if (score === null) return 'text-slate-400';
    if (score >= 80) return 'text-emerald-600';
    if (score >= 60) return 'text-amber-600';
    return 'text-rose-600';
  };
  
  const getHealthBg = (score) => {
    if (score === null) return 'bg-slate-100';
    if (score >= 80) return 'bg-emerald-50';
    if (score >= 60) return 'bg-amber-50';
    return 'bg-rose-50';
  };

  return (
    <div className="bg-white rounded-xl border border-slate-200 overflow-hidden transition-all hover:shadow-md">
      <button
        onClick={onToggle}
        className="w-full px-5 py-4 flex items-center justify-between hover:bg-slate-50 transition-colors"
      >
        <div className="flex items-center gap-4">
          <div className={`w-12 h-12 ${getHealthBg(healthScore)} rounded-xl flex items-center justify-center`}>
            <Building2 className={`w-6 h-6 ${getHealthColor(healthScore)}`} strokeWidth={1.5} />
          </div>
          <div className="text-left">
            <h3 className="font-semibold text-slate-900">{area.area_name}</h3>
            <p className="text-sm text-slate-500">{area.total_kpis} indicadores</p>
          </div>
        </div>
        
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-2">
            {stats.green > 0 && (
              <span className="flex items-center gap-1 px-2 py-1 bg-emerald-50 text-emerald-700 rounded-full text-xs font-medium">
                <div className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                {stats.green}
              </span>
            )}
            {stats.yellow > 0 && (
              <span className="flex items-center gap-1 px-2 py-1 bg-amber-50 text-amber-700 rounded-full text-xs font-medium">
                <div className="w-1.5 h-1.5 rounded-full bg-amber-500" />
                {stats.yellow}
              </span>
            )}
            {stats.red > 0 && (
              <span className="flex items-center gap-1 px-2 py-1 bg-rose-50 text-rose-700 rounded-full text-xs font-medium">
                <div className="w-1.5 h-1.5 rounded-full bg-rose-500" />
                {stats.red}
              </span>
            )}
            {stats.na > 0 && (
              <span className="flex items-center gap-1 px-2 py-1 bg-slate-100 text-slate-600 rounded-full text-xs font-medium">
                <div className="w-1.5 h-1.5 rounded-full bg-slate-400" />
                {stats.na}
              </span>
            )}
          </div>
          
          <div className={`text-right ${getHealthColor(healthScore)}`}>
            <p className="text-2xl font-bold tabular-nums">
              {healthScore !== null ? `${healthScore}%` : 'N/A'}
            </p>
            <p className="text-xs text-slate-500">Cumplimiento</p>
          </div>
          
          {isExpanded ? (
            <ChevronUp className="w-5 h-5 text-slate-400" />
          ) : (
            <ChevronDown className="w-5 h-5 text-slate-400" />
          )}
        </div>
      </button>
      
      {isExpanded && (
        <div className="px-5 pb-5 pt-2 border-t border-slate-100">
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3">
            {area.kpis.map((kpi, idx) => (
              <KpiCardCompact key={kpi.kpi_id || idx} kpi={kpi} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

export default function ManagementDashboard() {
  const router = useRouter();
  const [dashboard, setDashboard] = useState(null);
  const [allTasks, setAllTasks] = useState([]);
  const [weeklyData, setWeeklyData] = useState([]);
  const [quarterlyData, setQuarterlyData] = useState([]);
  const [advancedStats, setAdvancedStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [user, setUser] = useState(null);
  
  // Estados para KPIs
  const [allKpiData, setAllKpiData] = useState(null);
  const [loadingKpis, setLoadingKpis] = useState(false);
  const [expandedAreas, setExpandedAreas] = useState(new Set());
  const [kpiTrend, setKpiTrend] = useState([]);
  const loadAllKpisRef = useRef(null);
  
  // Inicializar con la fecha de hoy
  const today = new Date().toISOString().split('T')[0];
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);
  const [currentPeriod, setCurrentPeriod] = useState('today');

  useEffect(() => {
    async function loadUser() {
      try {
        const data = await apiRequest('/auth/me');
        if (data.data.role !== 'admin') {
          router.push('/dashboard/');
          return;
        }
        setUser(data.data);
      } catch (e) {
        router.push('/login/');
      }
    }
    loadUser();
  }, [router]);

  const loadDashboard = useCallback(async (from, to, isRefresh = false) => {
    if (!user) return;
    
    if (isRefresh) {
      setRefreshing(true);
    } else {
      setLoading(true);
    }
    
    try {
      // Construir query params: solo añadir fechas cuando hay rango; "Todo" = sin params = todos los datos
      const reportParams = new URLSearchParams();
      const taskParams = new URLSearchParams();
      const hasFrom = from != null && String(from).trim() !== '';
      const hasTo = to != null && String(to).trim() !== '';
      
      if (hasFrom) {
        reportParams.append('date_from', from);
        taskParams.append('date_from', from);
      }
      if (hasTo) {
        reportParams.append('date_to', to);
        taskParams.append('date_to', to);
      }

      const reportUrl = `/reports/management${reportParams.toString() ? '?' + reportParams.toString() : ''}`;
      const tasksUrl = `/tasks${taskParams.toString() ? '?' + taskParams.toString() : ''}`;
      
      // Cargar en paralelo; si una petición falla (ej. "Todo"), actualizar con las que sí respondan
      const results = await Promise.allSettled([
        apiRequest(reportUrl),
        apiRequest(tasksUrl),
        apiRequest('/reports/weekly-evolution'),
        apiRequest('/reports/quarterly'),
        apiRequest('/reports/advanced-stats')
      ]);
      
      if (results[0].status === 'fulfilled' && results[0].value?.data != null) {
        setDashboard(results[0].value.data);
      }
      if (results[1].status === 'fulfilled' && results[1].value?.data != null) {
        setAllTasks(results[1].value.data || []);
      }
      if (results[2].status === 'fulfilled' && results[2].value?.data != null) {
        setWeeklyData(results[2].value.data || []);
      }
      if (results[3].status === 'fulfilled' && results[3].value?.data != null) {
        setQuarterlyData(results[3].value.data || []);
      }
      if (results[4].status === 'fulfilled' && results[4].value?.data != null) {
        setAdvancedStats(results[4].value.data ?? null);
      }
      // Refrescar KPIs con las mismas fechas que el dashboard
      loadAllKpisRef.current?.(from, to, null);
    } catch (e) {
      // Error inesperado
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [user]);

  useEffect(() => {
    if (user) {
      loadDashboard(dateFrom ?? null, dateTo ?? null);
    }
  }, [user, dateFrom, dateTo, loadDashboard]);

  const handleDateChange = (from, to, period) => {
    // "Todo" (all): sin fechas = cargar todos los datos
    const isAll = period === 'all' || (from == null && to == null);
    setDateFrom(isAll ? null : (from || ''));
    setDateTo(isAll ? null : (to || ''));
    setCurrentPeriod(period || (isAll ? 'all' : 'custom'));
  };

  const handleRefresh = () => {
    loadDashboard(dateFrom ?? null, dateTo ?? null, true);
    loadAllKpis(dateFrom ?? null, dateTo ?? null, currentPeriod);
  };

  // Ejecutar backfill de KPIs (recalcular todos los facts)
  const [runningBackfill, setRunningBackfill] = useState(false);
  const handleBackfill = async () => {
    if (!confirm('¿Recalcular los indicadores KPI de todas las tareas? Esto puede tomar unos segundos.')) {
      return;
    }
    
    setRunningBackfill(true);
    try {
      const result = await apiRequest('/kpis/backfill', { method: 'POST' });
      alert(`✅ Backfill completado: ${result.data?.processed || 0} tareas procesadas`);
      // Recargar datos
      loadAllKpis();
    } catch (e) {
      alert('❌ Error al ejecutar backfill: ' + e.message);
    } finally {
      setRunningBackfill(false);
    }
  };

  // Cargar KPIs usando el mismo filtro de fechas que el dashboard (date_from/date_to; "Todo" = sin fechas)
  const loadAllKpis = useCallback(async (fromArg, toArg, periodArg) => {
    if (!user) return;

    const from = fromArg ?? dateFrom;
    const to = toArg ?? dateTo;
    const period = periodArg ?? currentPeriod;

    const params = new URLSearchParams();
    const hasFrom = from != null && String(from).trim() !== '';
    const hasTo = to != null && String(to).trim() !== '';

    // Si es "all" o no hay fechas, no mandar fechas (backend interpreta como todo)
    if (!(period === 'all' || (!hasFrom && !hasTo))) {
      if (hasFrom) params.append('date_from', from);
      if (hasTo) params.append('date_to', to);
    }

    setLoadingKpis(true);
    try {
      const [summaryData, trendData] = await Promise.all([
        apiRequest(`/kpis/summary/all${params.toString() ? `?${params.toString()}` : ''}`),
        apiRequest('/kpis/global-trend?months=6').catch(() => ({ data: [] }))
      ]);

      setAllKpiData(summaryData);
      setKpiTrend(trendData.data || []);

      if (summaryData.data && summaryData.data.length > 0) {
        setExpandedAreas(prev => (prev.size === 0 ? new Set([summaryData.data[0].area_id]) : prev));
      }
    } catch (e) {
      console.error('Error loading KPI summary:', e);
      setAllKpiData(null);
      setKpiTrend([]);
    } finally {
      setLoadingKpis(false);
    }
  }, [user, dateFrom, dateTo, currentPeriod]);

  // Ref para que loadDashboard pueda llamar a loadAllKpis sin dependencia circular
  loadAllKpisRef.current = loadAllKpis;

  useEffect(() => {
    if (user) {
      loadAllKpis();
    }
  }, [user, loadAllKpis]);

  const toggleAreaExpanded = (areaId) => {
    setExpandedAreas(prev => {
      const newSet = new Set(prev);
      if (newSet.has(areaId)) {
        newSet.delete(areaId);
      } else {
        newSet.add(areaId);
      }
      return newSet;
    });
  };

  const expandAllAreas = () => {
    if (allKpiData?.data) {
      setExpandedAreas(new Set(allKpiData.data.map(a => a.area_id)));
    }
  };

  const collapseAllAreas = () => {
    setExpandedAreas(new Set());
  };

  // Calcular datos para gráficos (misma fuente: allTasks = tareas del período mostradas en la página)
  const getStatusChartData = () => {
    const statusCount = {};
    allTasks.forEach(task => {
      statusCount[task.status] = (statusCount[task.status] || 0) + 1;
    });
    const colors = {
      'Completada': '#10b981',
      'En progreso': '#3b82f6',
      'En revisión': '#8b5cf6',
      'No iniciada': '#94a3b8',
      'En riesgo': '#ef4444'
    };
    return Object.entries(statusCount).map(([status, count]) => ({
      id: status,
      label: status,
      value: count,
      color: colors[status] || '#64748b'
    }));
  };

  // Preparar datos para gráfico de líneas (evolución semanal)
  const getLineChartData = () => {
    if (!weeklyData || weeklyData.length === 0) return [];
    
    return [
      {
        id: 'Creadas',
        color: '#3b82f6',
        data: weeklyData.map(w => ({ x: w.week, y: w.created }))
      },
      {
        id: 'Completadas',
        color: '#10b981',
        data: weeklyData.map(w => ({ x: w.week, y: w.completed }))
      },
      {
        id: 'Vencidas',
        color: '#ef4444',
        data: weeklyData.map(w => ({ x: w.week, y: w.overdue }))
      }
    ];
  };

  // Preparar datos para gráfico de barras (trimestral)
  const getBarChartData = () => {
    if (!quarterlyData || quarterlyData.length === 0) return [];
    
    return quarterlyData.map(q => ({
      quarter: q.label,
      'Completadas': q.completed,
      'Total': q.total - q.completed,
      'Cumplimiento': q.compliance_rate
    }));
  };

  // Preparar datos para gráfico de prioridades
  const getPriorityChartData = () => {
    if (!advancedStats?.by_priority) return [];
    const colors = {
      'Alta': '#ef4444',
      'Media': '#f59e0b',
      'Baja': '#10b981'
    };
    return advancedStats.by_priority.map(item => ({
      id: item.priority,
      label: item.priority,
      value: item.count,
      color: colors[item.priority] || '#64748b'
    }));
  };

  // Calcular KPIs de completitud: una sola fuente (dashboard.general) para que las estadísticas sean coherentes
  const calculateKPIs = () => {
    const total = dashboard?.general?.total_tasks ?? 0;
    const completed = dashboard?.general?.completed ?? 0;
    const inProgress = dashboard?.general?.in_progress ?? 0;
    const overdue = dashboard?.general?.overdue ?? 0;
    const avgProgress = dashboard?.general?.avg_progress ?? 0;

    return {
      completionRate: total > 0 ? Math.round((completed / total) * 100) : 0,
      inProgressRate: total > 0 ? Math.round((inProgress / total) * 100) : 0,
      avgProgress: Math.round(Number(avgProgress)),
      onTimeRate: total > 0 ? Math.round(((total - overdue) / total) * 100) : 0
    };
  };

  const kpis = calculateKPIs();

  if (loading) {
    return (
      <Layout>
        <div className="flex items-center justify-center h-64">
          <Loader2 className="h-10 w-10 text-indigo-600 animate-spin" strokeWidth={1.75} />
        </div>
      </Layout>
    );
  }

  const getPeriodLabel = () => {
    const labels = {
      'today': 'de hoy',
      'week': 'de esta semana',
      'month': 'de este mes',
      'quarter': 'de este trimestre',
      'semester': 'de este semestre',
      'year': 'de este año',
      'all': '(todas las fechas)',
      'custom': 'del rango seleccionado'
    };
    if (currentPeriod && labels[currentPeriod] !== undefined) return labels[currentPeriod];
    return (dateFrom && dateTo) ? 'del rango seleccionado' : '(todas las fechas)';
  };

  return (
    <Layout>
      <div className="print-content p-4 sm:p-6 lg:p-8 w-full max-w-7xl mx-auto overflow-x-hidden">
        <div className="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <h1 className="text-2xl font-semibold text-slate-900">Dashboard General</h1>
            <p className="text-slate-500 mt-0.5 text-sm">
              Vision consolidada del estado de las tareas {getPeriodLabel()}
            </p>
          </div>
          
          {/* Filtros de fecha y acciones */}
          <div className="flex items-center gap-3">
            <DateRangeFilter 
              onChange={handleDateChange}
              defaultPeriod={currentPeriod}
            />
            <button
              onClick={() => window.print()}
              className="flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg font-medium text-sm shadow-sm hover:shadow-md transition-all duration-200 border border-indigo-700 hover:border-indigo-800 no-print"
              title="Exportar página a PDF (abre el cuadro de impresión)"
            >
              <FileDown className="w-4 h-4 shrink-0" strokeWidth={2.25} />
              <span>Exportar PDF</span>
            </button>
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

        {/* KPIs de Completitud */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
          <div className="bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-xl p-5 text-white shadow-lg shadow-emerald-200">
            <div className="flex items-center justify-between mb-3">
              <Target className="w-8 h-8 opacity-80" strokeWidth={1.5} />
              <span className="text-3xl font-bold tabular-nums">{kpis.completionRate}%</span>
            </div>
            <p className="text-emerald-100 text-sm font-medium">Tasa de Completitud</p>
            <p className="text-emerald-200 text-xs mt-1">{dashboard?.general?.completed || 0} de {dashboard?.general?.total_tasks || 0} tareas</p>
          </div>

          <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-5 text-white shadow-lg shadow-blue-200">
            <div className="flex items-center justify-between mb-3">
              <Activity className="w-8 h-8 opacity-80" strokeWidth={1.5} />
              <span className="text-3xl font-bold tabular-nums">{kpis.avgProgress}%</span>
            </div>
            <p className="text-blue-100 text-sm font-medium">Progreso Promedio</p>
            <p className="text-blue-200 text-xs mt-1">Avance general de tareas</p>
          </div>

          <div className="bg-gradient-to-br from-violet-500 to-violet-600 rounded-xl p-5 text-white shadow-lg shadow-violet-200">
            <div className="flex items-center justify-between mb-3">
              <TrendingUp className="w-8 h-8 opacity-80" strokeWidth={1.5} />
              <span className="text-3xl font-bold tabular-nums">{kpis.inProgressRate}%</span>
            </div>
            <p className="text-violet-100 text-sm font-medium">En Ejecucion</p>
            <p className="text-violet-200 text-xs mt-1">Tareas activas actualmente</p>
          </div>

          <div className="bg-gradient-to-br from-amber-500 to-amber-600 rounded-xl p-5 text-white shadow-lg shadow-amber-200">
            <div className="flex items-center justify-between mb-3">
              <Clock className="w-8 h-8 opacity-80" strokeWidth={1.5} />
              <span className="text-3xl font-bold tabular-nums">{kpis.onTimeRate}%</span>
            </div>
            <p className="text-amber-100 text-sm font-medium">A Tiempo</p>
            <p className="text-amber-200 text-xs mt-1">Sin retrasos</p>
          </div>
        </div>

        {/* ============================================ */}
        {/* SECCIÓN DE KPIs POR ÁREA */}
        {/* ============================================ */}
        {allKpiData && allKpiData.data && allKpiData.data.length > 0 && (
          <div className="mb-8">
            {/* Resumen Global de KPIs */}
            <div className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm mb-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-indigo-100 rounded-lg flex items-center justify-center">
                    <Gauge className="w-5 h-5 text-indigo-600" strokeWidth={1.75} />
                  </div>
                  <div>
                    <h2 className="text-lg font-semibold text-slate-900">Indicadores KPI del Sistema</h2>
                    <p className="text-sm text-slate-500">
                      Consolidado de todas las áreas • {allKpiData?.meta?.date_from && allKpiData?.meta?.date_to
                        ? `${allKpiData.meta.date_from} – ${allKpiData.meta.date_to}`
                        : allKpiData?.meta?.date_from
                          ? `desde ${allKpiData.meta.date_from}`
                          : currentPeriod === 'all'
                            ? 'todas las fechas'
                            : (dateTo || dateFrom || '').toString().slice(0, 7) || 'período actual'}
                    </p>
                  </div>
                </div>
                
                <div className="flex items-center gap-3 flex-wrap">
                  <button
                    onClick={handleBackfill}
                    disabled={runningBackfill}
                    className="px-4 py-2 text-sm font-medium bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors disabled:opacity-50 flex items-center gap-2 shadow-sm"
                    title="Recalcular todos los indicadores KPI"
                  >
                    {runningBackfill ? (
                      <>
                        <Loader2 className="w-4 h-4 animate-spin" />
                        Calculando...
                      </>
                    ) : (
                      <>
                        <RefreshCw className="w-4 h-4" />
                        Recalcular KPIs
                      </>
                    )}
                  </button>
                </div>
              </div>
              
              {loadingKpis ? (
                <div className="flex items-center justify-center py-8">
                  <Loader2 className="h-8 w-8 text-indigo-600 animate-spin" strokeWidth={1.75} />
                </div>
              ) : (
                <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
                  <div className="bg-indigo-50 rounded-xl p-4 border border-indigo-100">
                    <div className="flex items-center gap-2 mb-2">
                      <TrendingUp className="w-4 h-4 text-indigo-600" />
                      <span className="text-xs text-indigo-600 uppercase tracking-wide font-medium">Promedio</span>
                    </div>
                    <p className="text-3xl font-bold text-indigo-700 tabular-nums">
                      {allKpiData.global_stats?.avg_performance || 0}%
                    </p>
                  </div>
                  
                  <div className="bg-slate-50 rounded-xl p-4 border border-slate-200">
                    <div className="flex items-center gap-2 mb-2">
                      <Target className="w-4 h-4 text-slate-600" />
                      <span className="text-xs text-slate-600 uppercase tracking-wide font-medium">Total KPIs</span>
                    </div>
                    <p className="text-3xl font-bold text-slate-800 tabular-nums">
                      {allKpiData.global_stats?.total_kpis || 0}
                    </p>
                  </div>
                  
                  <div className="bg-emerald-50 rounded-xl p-4 border border-emerald-200">
                    <div className="flex items-center gap-2 mb-2">
                      <Award className="w-4 h-4 text-emerald-600" />
                      <span className="text-xs text-emerald-600 uppercase tracking-wide font-medium">En meta</span>
                    </div>
                    <p className="text-3xl font-bold text-emerald-600 tabular-nums">
                      {allKpiData.global_stats?.green_count || 0}
                    </p>
                  </div>
                  
                  <div className="bg-amber-50 rounded-xl p-4 border border-amber-200">
                    <div className="flex items-center gap-2 mb-2">
                      <AlertTriangle className="w-4 h-4 text-amber-600" />
                      <span className="text-xs text-amber-600 uppercase tracking-wide font-medium">Precaución</span>
                    </div>
                    <p className="text-3xl font-bold text-amber-600 tabular-nums">
                      {allKpiData.global_stats?.yellow_count || 0}
                    </p>
                  </div>
                  
                  <div className="bg-rose-50 rounded-xl p-4 border border-rose-200">
                    <div className="flex items-center gap-2 mb-2">
                      <AlertCircle className="w-4 h-4 text-rose-600" />
                      <span className="text-xs text-rose-600 uppercase tracking-wide font-medium">Crítico</span>
                    </div>
                    <p className="text-3xl font-bold text-rose-600 tabular-nums">
                      {allKpiData.global_stats?.red_count || 0}
                    </p>
                  </div>
                  
                  <div className="bg-slate-100 rounded-xl p-4 border border-slate-200">
                    <div className="flex items-center gap-2 mb-2">
                      <Activity className="w-4 h-4 text-slate-500" />
                      <span className="text-xs text-slate-500 uppercase tracking-wide font-medium">Sin datos</span>
                    </div>
                    <p className="text-3xl font-bold text-slate-500 tabular-nums">
                      {allKpiData.global_stats?.na_count || 0}
                    </p>
                  </div>
                </div>
              )}
            </div>

            {/* KPIs por Área - Cards expandibles */}
            <div className="mb-6">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-3">
                  <BarChart3 className="w-5 h-5 text-slate-600" />
                  <h2 className="text-lg font-semibold text-slate-900">Detalle KPIs por Área</h2>
                  <span className="text-sm text-slate-500">
                    ({allKpiData.data.length} áreas)
                  </span>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    onClick={expandAllAreas}
                    className="px-3 py-1.5 text-xs font-medium text-slate-600 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors"
                  >
                    Expandir todo
                  </button>
                  <button
                    onClick={collapseAllAreas}
                    className="px-3 py-1.5 text-xs font-medium text-slate-600 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors"
                  >
                    Colapsar todo
                  </button>
                </div>
              </div>
              
              <div className="space-y-3">
                {allKpiData.data.map(area => (
                  <AreaKpiCard
                    key={area.area_id}
                    area={area}
                    isExpanded={expandedAreas.has(area.area_id)}
                    onToggle={() => toggleAreaExpanded(area.area_id)}
                  />
                ))}
              </div>
            </div>

            {/* ============================================ */}
            {/* GRÁFICAS ANALÍTICAS PARA GERENCIA */}
            {/* ============================================ */}
            <div className="mb-8">
              <div className="flex items-center gap-3 mb-6">
                <LineChart className="w-6 h-6 text-indigo-600" />
                <h2 className="text-xl font-bold text-slate-900">Análisis Visual de KPIs</h2>
                <span className="px-2 py-1 text-xs font-medium bg-indigo-100 text-indigo-700 rounded-full">
                  Dashboard Gerencial
                </span>
              </div>
              
              <div className="grid lg:grid-cols-2 gap-6">
                {/* Gráfico 1: Distribución de Estado de KPIs (Donut) - ancho completo */}
                <div className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm lg:col-span-2 min-w-0 overflow-visible">
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <h3 className="font-semibold text-slate-900">Distribución de KPIs</h3>
                      <p className="text-sm text-slate-500">Estado consolidado de todos los indicadores</p>
                    </div>
                    <div className="w-10 h-10 bg-indigo-100 rounded-lg flex items-center justify-center">
                      <Target className="w-5 h-5 text-indigo-600" />
                    </div>
                  </div>
                  <div className="h-72 overflow-visible">
                    <ResponsivePie
                      data={[
                        {
                          id: 'En Meta',
                          label: 'En Meta',
                          value: allKpiData.global_stats?.green_count || 0,
                          color: '#10b981'
                        },
                        {
                          id: 'Precaución',
                          label: 'Precaución',
                          value: allKpiData.global_stats?.yellow_count || 0,
                          color: '#f59e0b'
                        },
                        {
                          id: 'Crítico',
                          label: 'Crítico',
                          value: allKpiData.global_stats?.red_count || 0,
                          color: '#ef4444'
                        },
                        {
                          id: 'Sin Datos',
                          label: 'Sin Datos',
                          value: allKpiData.global_stats?.na_count || 0,
                          color: '#94a3b8'
                        }
                      ].filter(d => d.value > 0)}
                      margin={{ top: 40, right: 80, bottom: 40, left: 80 }}
                      innerRadius={0.6}
                      padAngle={2}
                      cornerRadius={4}
                      activeOuterRadiusOffset={8}
                      colors={{ datum: 'data.color' }}
                      borderWidth={2}
                      borderColor={{ from: 'color', modifiers: [['darker', 0.2]] }}
                      arcLinkLabelsSkipAngle={10}
                      arcLinkLabelsTextColor="#475569"
                      arcLinkLabelsThickness={2}
                      arcLinkLabelsColor={{ from: 'color' }}
                      arcLabelsSkipAngle={10}
                      arcLabelsTextColor="#ffffff"
                      enableArcLinkLabels={true}
                      motionConfig="gentle"
                      legends={[]}
                    />
                  </div>
                  <div className="flex flex-wrap justify-center gap-4 mt-4 pt-4 border-t border-slate-100">
                    <div className="flex items-center gap-2">
                      <div className="w-3 h-3 rounded-full bg-emerald-500" />
                      <span className="text-sm text-slate-600">En Meta ({allKpiData.global_stats?.green_count || 0})</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <div className="w-3 h-3 rounded-full bg-amber-500" />
                      <span className="text-sm text-slate-600">Precaución ({allKpiData.global_stats?.yellow_count || 0})</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <div className="w-3 h-3 rounded-full bg-rose-500" />
                      <span className="text-sm text-slate-600">Crítico ({allKpiData.global_stats?.red_count || 0})</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <div className="w-3 h-3 rounded-full bg-slate-400" />
                      <span className="text-sm text-slate-600">Sin Datos ({allKpiData.global_stats?.na_count || 0})</span>
                    </div>
                  </div>
                </div>

                {/* Gráfico 2: Rendimiento por Área (Barras Horizontales) - ancho completo para ver todas las áreas */}
                <div className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm lg:col-span-2 min-w-0 overflow-visible">
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <h3 className="font-semibold text-slate-900">Rendimiento por Área</h3>
                      <p className="text-sm text-slate-500">Índice de cumplimiento promedio de cada área</p>
                    </div>
                    <div className="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center">
                      <BarChart3 className="w-5 h-5 text-emerald-600" />
                    </div>
                  </div>
                  <div
                    className="w-full overflow-visible min-h-[320px]"
                    style={{
                      height: Math.min(520, Math.max(320, (allKpiData.data?.length || 0) * 40))
                    }}
                  >
                    <ResponsiveBar
                      data={allKpiData.data.map(area => {
                        const totalActive = area.stats.green + area.stats.yellow + area.stats.red;
                        const healthScore = totalActive > 0 
                          ? Math.round(((area.stats.green * 100) + (area.stats.yellow * 50)) / totalActive)
                          : 0;
                        return {
                          area: area.area_name,
                          fullName: area.area_name,
                          cumplimiento: healthScore,
                          cumplimientoColor: healthScore >= 80 ? '#10b981' : healthScore >= 60 ? '#f59e0b' : '#ef4444'
                        };
                      }).sort((a, b) => b.cumplimiento - a.cumplimiento)}
                      keys={['cumplimiento']}
                      indexBy="area"
                      margin={{ top: 20, right: 50, bottom: 55, left: 200 }}
                      padding={0.35}
                      layout="horizontal"
                      valueScale={{ type: 'linear', min: 0, max: 100 }}
                      indexScale={{ type: 'band', round: true }}
                      colors={({ data }) => data.cumplimientoColor}
                      borderRadius={4}
                      borderWidth={1}
                      borderColor={{ from: 'color', modifiers: [['darker', 0.3]] }}
                      axisTop={null}
                      axisRight={null}
                      axisBottom={{
                        tickSize: 5,
                        tickPadding: 5,
                        tickRotation: 0,
                        legend: 'Índice de Cumplimiento (%)',
                        legendPosition: 'middle',
                        legendOffset: 42,
                        tickValues: [0, 25, 50, 75, 100]
                      }}
                      axisLeft={{
                        tickSize: 0,
                        tickPadding: 10,
                        tickRotation: 0,
                        legend: '',
                        format: (v) => v
                      }}
                      enableLabel={true}
                      labelSkipWidth={24}
                      labelSkipHeight={14}
                      labelTextColor="#ffffff"
                      label={d => `${d.value}%`}
                      role="img"
                      ariaLabel="Gráfico de rendimiento por área"
                      motionConfig="gentle"
                      theme={{
                        axis: {
                          ticks: {
                            text: {
                              fontSize: 12,
                              fill: '#475569'
                            }
                          }
                        }
                      }}
                      tooltip={({ data, value }) => (
                        <div className="bg-slate-900 text-white px-3 py-2 rounded-lg shadow-lg text-sm">
                          <strong>{data.fullName}</strong>
                          <div className="text-slate-300">Cumplimiento: {value}%</div>
                        </div>
                      )}
                    />
                  </div>
                </div>

                {/* Gráfico 3: Comparativa de KPIs por Área (Stacked Bar) */}
                <div className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm lg:col-span-2 overflow-visible">
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <h3 className="font-semibold text-slate-900">Comparativa de Indicadores por Área</h3>
                      <p className="text-sm text-slate-500">Distribución de estado de KPIs en cada área</p>
                    </div>
                    <div className="w-10 h-10 bg-violet-100 rounded-lg flex items-center justify-center">
                      <Activity className="w-5 h-5 text-violet-600" />
                    </div>
                  </div>
                  <div className="h-80 overflow-visible">
                    <ResponsiveBar
                      data={allKpiData.data.map(area => ({
                        area: area.area_name.length > 12 
                          ? area.area_name.substring(0, 10) + '...' 
                          : area.area_name,
                        fullName: area.area_name,
                        'En Meta': area.stats.green,
                        'Precaución': area.stats.yellow,
                        'Crítico': area.stats.red,
                        'Sin Datos': area.stats.na
                      }))}
                      keys={['En Meta', 'Precaución', 'Crítico', 'Sin Datos']}
                      indexBy="area"
                      margin={{ top: 20, right: 130, bottom: 60, left: 60 }}
                      padding={0.3}
                      groupMode="stacked"
                      valueScale={{ type: 'linear' }}
                      indexScale={{ type: 'band', round: true }}
                      colors={['#10b981', '#f59e0b', '#ef4444', '#94a3b8']}
                      borderRadius={3}
                      borderWidth={1}
                      borderColor={{ from: 'color', modifiers: [['darker', 0.2]] }}
                      axisTop={null}
                      axisRight={null}
                      axisBottom={{
                        tickSize: 5,
                        tickPadding: 5,
                        tickRotation: -45,
                        legendPosition: 'middle',
                        legendOffset: 50
                      }}
                      axisLeft={{
                        tickSize: 5,
                        tickPadding: 5,
                        tickRotation: 0,
                        legend: 'Cantidad de KPIs',
                        legendPosition: 'middle',
                        legendOffset: -45
                      }}
                      enableLabel={true}
                      labelSkipWidth={12}
                      labelSkipHeight={12}
                      labelTextColor="#ffffff"
                      legends={[
                        {
                          dataFrom: 'keys',
                          anchor: 'bottom-right',
                          direction: 'column',
                          justify: false,
                          translateX: 120,
                          translateY: 0,
                          itemsSpacing: 2,
                          itemWidth: 100,
                          itemHeight: 20,
                          itemDirection: 'left-to-right',
                          itemOpacity: 0.85,
                          symbolSize: 12,
                          symbolShape: 'circle',
                          effects: [
                            {
                              on: 'hover',
                              style: {
                                itemOpacity: 1
                              }
                            }
                          ]
                        }
                      ]}
                      role="img"
                      ariaLabel="Comparativa de KPIs por área"
                      motionConfig="gentle"
                      tooltip={({ id, value, indexValue, data }) => (
                        <div className="bg-slate-900 text-white px-3 py-2 rounded-lg shadow-lg text-sm">
                          <strong>{data.fullName}</strong>
                          <div className="text-slate-300">{id}: {value} KPIs</div>
                        </div>
                      )}
                    />
                  </div>
                </div>

                {/* Gráfico 4: Top 5 Áreas con Mejor Desempeño */}
                <div className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm overflow-visible">
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <h3 className="font-semibold text-slate-900">Top Áreas por Desempeño</h3>
                      <p className="text-sm text-slate-500">Las áreas con mejor índice de cumplimiento</p>
                    </div>
                    <div className="w-10 h-10 bg-amber-100 rounded-lg flex items-center justify-center">
                      <Trophy className="w-5 h-5 text-amber-600" />
                    </div>
                  </div>
                  <div className="space-y-3">
                    {allKpiData.data
                      .map(area => {
                        const totalActive = area.stats.green + area.stats.yellow + area.stats.red;
                        const healthScore = totalActive > 0 
                          ? Math.round(((area.stats.green * 100) + (area.stats.yellow * 50)) / totalActive)
                          : 0;
                        return { ...area, healthScore, totalActive };
                      })
                      .filter(a => a.totalActive > 0)
                      .sort((a, b) => b.healthScore - a.healthScore)
                      .slice(0, 5)
                      .map((area, idx) => (
                        <div key={area.area_id} className="flex items-center gap-4 p-3 bg-slate-50 rounded-lg border border-slate-100">
                          <div className={`w-8 h-8 rounded-lg flex items-center justify-center font-bold text-sm ${
                            idx === 0 ? 'bg-amber-500 text-white' :
                            idx === 1 ? 'bg-slate-400 text-white' :
                            idx === 2 ? 'bg-amber-700 text-white' :
                            'bg-slate-200 text-slate-600'
                          }`}>
                            {idx + 1}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-sm font-medium text-slate-800 truncate">{area.area_name}</p>
                            <div className="mt-1 h-2 bg-slate-200 rounded-full overflow-hidden">
                              <div 
                                className={`h-full rounded-full transition-all ${
                                  area.healthScore >= 80 ? 'bg-emerald-500' :
                                  area.healthScore >= 60 ? 'bg-amber-500' : 'bg-rose-500'
                                }`}
                                style={{ width: `${area.healthScore}%` }}
                              />
                            </div>
                          </div>
                          <div className={`text-lg font-bold tabular-nums ${
                            area.healthScore >= 80 ? 'text-emerald-600' :
                            area.healthScore >= 60 ? 'text-amber-600' : 'text-rose-600'
                          }`}>
                            {area.healthScore}%
                          </div>
                        </div>
                      ))}
                    {allKpiData.data.filter(a => (a.stats.green + a.stats.yellow + a.stats.red) > 0).length === 0 && (
                      <p className="text-sm text-slate-500 text-center py-4">
                        No hay áreas con KPIs evaluados
                      </p>
                    )}
                  </div>
                </div>

                {/* Gráfico 5: Resumen de Alertas */}
                <div className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm overflow-visible">
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <h3 className="font-semibold text-slate-900">Resumen de Alertas</h3>
                      <p className="text-sm text-slate-500">KPIs que requieren atención inmediata</p>
                    </div>
                    <AlertTriangle className="w-8 h-8 text-rose-500" />
                  </div>
                  <div className="space-y-4">
                    {/* KPIs Críticos */}
                    <div className="p-4 bg-rose-50 border border-rose-200 rounded-xl">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm font-medium text-rose-800">KPIs en Estado Crítico</span>
                        <span className="text-2xl font-bold text-rose-600 tabular-nums">
                          {allKpiData.global_stats?.red_count || 0}
                        </span>
                      </div>
                      <p className="text-xs text-rose-600">
                        Requieren acción correctiva inmediata
                      </p>
                    </div>
                    
                    {/* KPIs en Precaución */}
                    <div className="p-4 bg-amber-50 border border-amber-200 rounded-xl">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm font-medium text-amber-800">KPIs en Precaución</span>
                        <span className="text-2xl font-bold text-amber-600 tabular-nums">
                          {allKpiData.global_stats?.yellow_count || 0}
                        </span>
                      </div>
                      <p className="text-xs text-amber-600">
                        Monitorear para evitar deterioro
                      </p>
                    </div>
                    
                    {/* Sin Datos */}
                    <div className="p-4 bg-slate-100 border border-slate-200 rounded-xl">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm font-medium text-slate-700">KPIs Sin Datos</span>
                        <span className="text-2xl font-bold text-slate-500 tabular-nums">
                          {allKpiData.global_stats?.na_count || 0}
                        </span>
                      </div>
                      <p className="text-xs text-slate-500">
                        Sin actividad registrada en el periodo
                      </p>
                    </div>

                    {/* Indicador de Cumplimiento General */}
                    <div className="p-4 bg-indigo-50 border-2 border-indigo-200 rounded-xl">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm font-medium text-indigo-800">Cumplimiento General del Sistema</span>
                        <Gauge className="w-6 h-6 text-indigo-600" />
                      </div>
                      <div className="flex items-end gap-2">
                        <span className="text-4xl font-bold tabular-nums text-indigo-700">
                          {allKpiData.global_stats?.avg_performance || 0}%
                        </span>
                        <span className="text-sm mb-1 text-indigo-500">
                          promedio
                        </span>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Gráfico 6: Tendencia Histórica de Rendimiento KPI */}
                {kpiTrend && kpiTrend.length > 0 && (
                  <div className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm lg:col-span-2 overflow-visible">
                    <div className="flex items-center justify-between mb-4">
                      <div>
                        <h3 className="font-semibold text-slate-900">Evolución del Rendimiento KPI</h3>
                        <p className="text-sm text-slate-500">Tendencia de cumplimiento de KPIs en los últimos 6 meses</p>
                      </div>
                      <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                        <TrendingUp className="w-5 h-5 text-blue-600" />
                      </div>
                    </div>
                    <div className="h-72 overflow-visible">
                      <ResponsiveLine
                        data={[
                          {
                            id: 'Rendimiento KPI',
                            color: '#6366f1',
                            data: kpiTrend.map(p => ({
                              x: p.period_label || p.period,
                              y: p.value ?? 0
                            }))
                          }
                        ]}
                        margin={{ top: 20, right: 30, bottom: 60, left: 60 }}
                        xScale={{ type: 'point' }}
                        yScale={{ type: 'linear', min: 0, max: 100, stacked: false }}
                        yFormat=" >-.1f"
                        curve="cardinal"
                        axisTop={null}
                        axisRight={null}
                        axisBottom={{
                          tickSize: 5,
                          tickPadding: 5,
                          tickRotation: -45,
                          legendPosition: 'middle',
                          legendOffset: 50
                        }}
                        axisLeft={{
                          tickSize: 5,
                          tickPadding: 5,
                          tickRotation: 0,
                          legend: 'Cumplimiento (%)',
                          legendPosition: 'middle',
                          legendOffset: -45
                        }}
                        colors={['#6366f1']}
                        lineWidth={3}
                        pointSize={10}
                        pointColor={{ theme: 'background' }}
                        pointBorderWidth={3}
                        pointBorderColor={{ from: 'serieColor' }}
                        pointLabelYOffset={-12}
                        enableArea={true}
                        areaOpacity={0.15}
                        useMesh={true}
                        enableGridX={false}
                        enableGridY={true}
                        motionConfig="gentle"
                        tooltip={({ point }) => (
                          <div className="bg-slate-900 text-white px-3 py-2 rounded-lg shadow-lg text-sm">
                            <strong>{point.data.x}</strong>
                            <div className="text-slate-300">Cumplimiento: {point.data.y}%</div>
                          </div>
                        )}
                      />
                    </div>
                    <div className="flex justify-center gap-6 mt-4 pt-4 border-t border-slate-100">
                      {kpiTrend.length > 1 && (
                        <>
                          <div className="text-center">
                            <p className="text-2xl font-bold text-indigo-600 tabular-nums">
                              {kpiTrend[0]?.value ?? 'N/A'}%
                            </p>
                            <p className="text-xs text-slate-500">Hace 6 meses</p>
                          </div>
                          <div className="text-center">
                            <p className="text-2xl font-bold text-emerald-600 tabular-nums">
                              {kpiTrend[kpiTrend.length - 1]?.value ?? 'N/A'}%
                            </p>
                            <p className="text-xs text-slate-500">Actual</p>
                          </div>
                          <div className="text-center">
                            <p className={`text-2xl font-bold tabular-nums ${
                              (kpiTrend[kpiTrend.length - 1]?.value ?? 0) >= (kpiTrend[0]?.value ?? 0)
                                ? 'text-emerald-600'
                                : 'text-rose-600'
                            }`}>
                              {kpiTrend[0]?.value 
                                ? ((((kpiTrend[kpiTrend.length - 1]?.value ?? 0) - (kpiTrend[0]?.value ?? 0)) / kpiTrend[0].value) * 100).toFixed(1)
                                : 0}%
                            </p>
                            <p className="text-xs text-slate-500">Cambio</p>
                          </div>
                        </>
                      )}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* Stats cards secundarios */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
          <div className="bg-white rounded-xl border border-slate-200 p-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-slate-100 rounded-lg flex items-center justify-center">
                <ClipboardList className="w-5 h-5 text-slate-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{dashboard?.general?.total_tasks || 0}</p>
                <p className="text-xs text-slate-500">Total tareas</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl border border-slate-200 p-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-emerald-50 rounded-lg flex items-center justify-center">
                <CheckCircle2 className="w-5 h-5 text-emerald-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{dashboard?.general?.completed || 0}</p>
                <p className="text-xs text-slate-500">Completadas</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl border border-slate-200 p-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-rose-50 rounded-lg flex items-center justify-center">
                <AlertTriangle className="w-5 h-5 text-rose-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{dashboard?.general?.at_risk || 0}</p>
                <p className="text-xs text-slate-500">En riesgo</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl border border-slate-200 p-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-amber-50 rounded-lg flex items-center justify-center">
                <Clock className="w-5 h-5 text-amber-600" strokeWidth={1.75} />
              </div>
              <div>
                <p className="text-2xl font-semibold text-slate-900 tabular-nums">{dashboard?.general?.overdue || 0}</p>
                <p className="text-xs text-slate-500">Vencidas</p>
              </div>
            </div>
          </div>
        </div>

        {/* ============================================ */}
        {/* SECCIÓN UNIFICADA DE GRÁFICAS */}
        {/* ============================================ */}
        <div className="bg-white rounded-xl border border-slate-200 overflow-visible mb-6">
          <div className="px-5 py-4 border-b border-slate-200">
            <div className="flex items-center gap-2">
              <BarChart3 className="w-5 h-5 text-indigo-600" />
              <div>
                <h2 className="text-base font-semibold text-slate-900">Analisis Grafico</h2>
                <p className="text-xs text-slate-500 mt-0.5">Visualizacion de metricas y tendencias</p>
              </div>
            </div>
          </div>
          
          <div className="p-5 space-y-6">
            {/* Gráfico de Evolución Semanal - Ancho completo */}
            <div>
              <div className="flex items-center gap-2 mb-3">
                <LineChart className="w-4 h-4 text-blue-600" />
                <h3 className="text-sm font-semibold text-slate-800">Evolucion Semanal</h3>
                <span className="text-xs text-slate-500">Ultimas 12 semanas</span>
              </div>
              <div className="bg-slate-50 rounded-lg p-4 overflow-visible" style={{ height: '280px' }}>
                {getLineChartData().length > 0 && getLineChartData()[0].data.length > 0 ? (
                  <ResponsiveLine
                    data={getLineChartData()}
                    margin={{ top: 20, right: 110, bottom: 40, left: 50 }}
                    xScale={{ type: 'point' }}
                    yScale={{ type: 'linear', min: 0, max: 'auto', stacked: false }}
                    axisTop={null}
                    axisRight={null}
                    axisBottom={{
                      tickSize: 5,
                      tickPadding: 5,
                      tickRotation: -45
                    }}
                    axisLeft={{
                      tickSize: 5,
                      tickPadding: 5
                    }}
                    colors={['#3b82f6', '#10b981', '#ef4444']}
                    pointSize={6}
                    pointColor={{ theme: 'background' }}
                    pointBorderWidth={2}
                    pointBorderColor={{ from: 'serieColor' }}
                    useMesh={true}
                    legends={[
                      {
                        anchor: 'right',
                        direction: 'column',
                        justify: false,
                        translateX: 100,
                        translateY: 0,
                        itemsSpacing: 6,
                        itemDirection: 'left-to-right',
                        itemWidth: 80,
                        itemHeight: 18,
                        symbolSize: 10,
                        symbolShape: 'circle'
                      }
                    ]}
                    enableArea={true}
                    areaOpacity={0.1}
                  />
                ) : (
                  <div className="flex items-center justify-center h-full text-slate-400">
                    Sin datos de evolucion disponibles
                  </div>
                )}
              </div>
            </div>

            {/* Grid de gráficas: Por Estado ocupa ancho completo, luego Prioridad y Trimestral */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              {/* Distribución por Estado (ancho completo, más grande) */}
              <div className="md:col-span-2 min-w-0">
                <h3 className="text-sm font-semibold text-slate-800 mb-3">Por Estado</h3>
                <div className="bg-slate-50 rounded-lg p-5 overflow-visible" style={{ minHeight: '340px', height: '340px' }}>
                  {getStatusChartData().length > 0 ? (
                    <ResponsivePie
                      data={getStatusChartData()}
                      margin={{ top: 24, right: 140, bottom: 24, left: 24 }}
                      innerRadius={0.55}
                      padAngle={2}
                      cornerRadius={4}
                      activeOuterRadiusOffset={8}
                      colors={{ datum: 'data.color' }}
                      borderWidth={1}
                      borderColor={{ from: 'color', modifiers: [['darker', 0.2]] }}
                      arcLinkLabelsSkipAngle={10}
                      arcLinkLabelsTextColor="#334155"
                      arcLinkLabelsThickness={2}
                      arcLinkLabelsColor={{ from: 'color' }}
                      arcLabelsSkipAngle={10}
                      arcLabelsTextColor="#ffffff"
                      enableArcLinkLabels={true}
                      legends={[
                        {
                          anchor: 'right',
                          direction: 'column',
                          translateX: 110,
                          translateY: 0,
                          itemsSpacing: 8,
                          itemWidth: 100,
                          itemHeight: 20,
                          itemTextColor: '#475569',
                          symbolSize: 14,
                          symbolShape: 'circle'
                        }
                      ]}
                    />
                  ) : (
                    <div className="flex items-center justify-center h-full text-slate-400 text-sm">
                      Sin datos de estado para el período seleccionado
                    </div>
                  )}
                </div>
              </div>

              {/* Distribución por Prioridad */}
              <div>
                <h3 className="text-sm font-semibold text-slate-800 mb-3">Por Prioridad</h3>
                <div className="bg-slate-50 rounded-lg p-3 overflow-visible" style={{ height: '220px' }}>
                  {getPriorityChartData().length > 0 ? (
                    <ResponsivePie
                      data={getPriorityChartData()}
                      margin={{ top: 15, right: 80, bottom: 15, left: 15 }}
                      innerRadius={0.5}
                      padAngle={2}
                      cornerRadius={3}
                      activeOuterRadiusOffset={6}
                      colors={{ datum: 'data.color' }}
                      borderWidth={1}
                      borderColor={{ from: 'color', modifiers: [['darker', 0.2]] }}
                      arcLinkLabelsSkipAngle={15}
                      arcLinkLabelsTextColor="#334155"
                      arcLinkLabelsThickness={1.5}
                      arcLinkLabelsColor={{ from: 'color' }}
                      arcLabelsSkipAngle={15}
                      arcLabelsTextColor="#ffffff"
                      legends={[
                        {
                          anchor: 'right',
                          direction: 'column',
                          translateX: 70,
                          translateY: 0,
                          itemsSpacing: 4,
                          itemWidth: 60,
                          itemHeight: 16,
                          itemTextColor: '#64748b',
                          symbolSize: 10,
                          symbolShape: 'circle'
                        }
                      ]}
                    />
                  ) : (
                    <div className="flex items-center justify-center h-full text-slate-400 text-sm">
                      Sin datos
                    </div>
                  )}
                </div>
              </div>

              {/* Cumplimiento Trimestral */}
              <div>
                <h3 className="text-sm font-semibold text-slate-800 mb-3">Cumplimiento Trimestral</h3>
                <div className="bg-slate-50 rounded-lg p-3 overflow-visible" style={{ height: '220px' }}>
                  {getBarChartData().length > 0 ? (
                    <ResponsiveBar
                      data={getBarChartData()}
                      keys={['Completadas', 'Total']}
                      indexBy="quarter"
                      margin={{ top: 15, right: 15, bottom: 35, left: 45 }}
                      padding={0.3}
                      groupMode="stacked"
                      colors={['#10b981', '#e2e8f0']}
                      borderRadius={3}
                      axisTop={null}
                      axisRight={null}
                      axisBottom={{
                        tickSize: 5,
                        tickPadding: 5
                      }}
                      axisLeft={{
                        tickSize: 5,
                        tickPadding: 5
                      }}
                      labelSkipWidth={12}
                      labelSkipHeight={12}
                      labelTextColor={{ from: 'color', modifiers: [['darker', 1.6]] }}
                    />
                  ) : (
                    <div className="flex items-center justify-center h-full text-slate-400 text-sm">
                      Sin datos
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* Indicadores complementarios */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3 pt-2">
              {quarterlyData.map(q => (
                <div key={q.quarter} className="text-center p-3 bg-slate-50 rounded-lg">
                  <p className="text-xs text-slate-500 mb-1">{q.label}</p>
                  <p className={`text-xl font-bold ${
                    q.compliance_rate >= 80 ? 'text-emerald-600' :
                    q.compliance_rate >= 50 ? 'text-blue-600' :
                    q.compliance_rate >= 25 ? 'text-amber-600' : 'text-rose-600'
                  }`}>
                    {q.compliance_rate}%
                  </p>
                  <p className="text-xs text-slate-400">{q.completed}/{q.total}</p>
                </div>
              ))}
            </div>

            {/* KPI de próximas a vencer */}
            <div className="flex items-center justify-between p-3 bg-amber-50 rounded-lg border border-amber-200">
              <div className="flex items-center gap-2">
                <Calendar className="w-5 h-5 text-amber-600" />
                <span className="text-sm text-amber-800">Tareas proximas a vencer (7 dias)</span>
              </div>
              <span className="text-xl font-bold text-amber-700">{advancedStats?.upcoming_due || 0}</span>
            </div>
          </div>
        </div>

        {/* Completitud por Area */}
        <div className="bg-white rounded-xl border border-slate-200 overflow-hidden mb-6">
          <div className="px-5 py-4 border-b border-slate-200">
            <h2 className="text-base font-semibold text-slate-900">Completitud por Area</h2>
            <p className="text-xs text-slate-500 mt-0.5">Porcentaje de tareas completadas en cada area</p>
          </div>
          <div className="p-5">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {dashboard?.by_area?.map(area => {
                const completionRate = area.total_tasks > 0 
                  ? Math.round((area.completed / area.total_tasks) * 100) 
                  : 0;
                const progressColor = completionRate >= 80 ? 'bg-emerald-500' : 
                                     completionRate >= 50 ? 'bg-blue-500' : 
                                     completionRate >= 25 ? 'bg-amber-500' : 'bg-rose-500';
                return (
                  <div key={area.id} className="bg-slate-50 rounded-lg p-4">
                    <div className="flex justify-between items-start mb-3">
                      <div>
                        <h3 className="font-medium text-slate-900 text-sm">{area.area_name}</h3>
                        <p className="text-xs text-slate-500">{area.total_tasks} tareas</p>
                      </div>
                      <span className={`text-lg font-bold tabular-nums ${
                        completionRate >= 80 ? 'text-emerald-600' : 
                        completionRate >= 50 ? 'text-blue-600' : 
                        completionRate >= 25 ? 'text-amber-600' : 'text-rose-600'
                      }`}>
                        {completionRate}%
                      </span>
                    </div>
                    <div className="h-2 bg-slate-200 rounded-full overflow-hidden mb-2">
                      <div
                        className={`h-full ${progressColor} rounded-full transition-all duration-500`}
                        style={{ width: `${completionRate}%` }}
                      ></div>
                    </div>
                    <div className="flex items-center justify-between text-xs text-slate-500">
                      <span className="flex items-center gap-1">
                        <CheckCircle2 className="w-3 h-3 text-emerald-500" />
                        {area.completed} completadas
                      </span>
                      <span className="flex items-center gap-1">
                        <AlertTriangle className="w-3 h-3 text-rose-500" />
                        {area.at_risk} en riesgo
                      </span>
                    </div>
                  </div>
                );
              }) || (
                <div className="col-span-full text-center py-8 text-slate-500">
                  No hay datos disponibles
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Tabla resumen por area */}
        <div className="bg-white rounded-xl border border-slate-200 overflow-hidden mb-6">
          <div className="px-5 py-4 border-b border-slate-200">
            <h2 className="text-base font-semibold text-slate-900">Detalle por Area</h2>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-slate-50 border-b border-slate-200">
                  <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Area</th>
                  <th className="px-5 py-3 text-center text-xs font-semibold text-slate-600 uppercase">Total</th>
                  <th className="px-5 py-3 text-center text-xs font-semibold text-slate-600 uppercase">Completadas</th>
                  <th className="px-5 py-3 text-center text-xs font-semibold text-slate-600 uppercase">En Riesgo</th>
                  <th className="px-5 py-3 text-center text-xs font-semibold text-slate-600 uppercase">Vencidas</th>
                  <th className="px-5 py-3 text-center text-xs font-semibold text-slate-600 uppercase">% Completitud</th>
                  <th className="px-5 py-3 text-center text-xs font-semibold text-slate-600 uppercase">Progreso Prom.</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {dashboard?.by_area?.map(area => {
                  const completionRate = area.total_tasks > 0 
                    ? Math.round((area.completed / area.total_tasks) * 100) 
                    : 0;
                  return (
                    <tr key={area.id} className="hover:bg-slate-50 transition-colors">
                      <td className="px-5 py-3 text-sm font-medium text-slate-900">{area.area_name}</td>
                      <td className="px-5 py-3 text-sm text-slate-600 text-center tabular-nums">{area.total_tasks}</td>
                      <td className="px-5 py-3 text-sm text-emerald-600 text-center tabular-nums font-medium">{area.completed}</td>
                      <td className="px-5 py-3 text-sm text-rose-600 text-center tabular-nums font-medium">{area.at_risk}</td>
                      <td className="px-5 py-3 text-sm text-amber-600 text-center tabular-nums font-medium">{area.overdue}</td>
                      <td className="px-5 py-3 text-center">
                        <span className={`inline-flex px-2 py-0.5 rounded text-xs font-semibold ${
                          completionRate >= 80 ? 'bg-emerald-100 text-emerald-700' : 
                          completionRate >= 50 ? 'bg-blue-100 text-blue-700' : 
                          completionRate >= 25 ? 'bg-amber-100 text-amber-700' : 'bg-rose-100 text-rose-700'
                        }`}>
                          {completionRate}%
                        </span>
                      </td>
                      <td className="px-5 py-3 text-center">
                        <div className="flex items-center justify-center gap-2">
                          <div className="w-16 h-1.5 bg-slate-200 rounded-full overflow-hidden">
                            <div
                              className="h-full bg-indigo-500 rounded-full"
                              style={{ width: `${area.avg_progress || 0}%` }}
                            ></div>
                          </div>
                          <span className="text-xs text-slate-600 tabular-nums w-8">{Math.round(area.avg_progress || 0)}%</span>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>

        {/* Top Usuarios por Productividad */}
        {advancedStats?.top_users && advancedStats.top_users.length > 0 && (
          <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
            <div className="px-5 py-4 border-b border-slate-200">
              <div className="flex items-center gap-2">
                <Trophy className="w-5 h-5 text-amber-500" />
                <div>
                  <h2 className="text-base font-semibold text-slate-900">Top Usuarios por Productividad</h2>
                  <p className="text-xs text-slate-500 mt-0.5">Ranking basado en tareas completadas</p>
                </div>
              </div>
            </div>
            <div className="p-5">
              <div className="space-y-3">
                {advancedStats.top_users.slice(0, 5).map((user, index) => (
                  <div key={user.id} className="flex items-center gap-4 p-3 bg-slate-50 rounded-lg">
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center text-white font-bold text-sm ${
                      index === 0 ? 'bg-amber-500' :
                      index === 1 ? 'bg-slate-400' :
                      index === 2 ? 'bg-amber-700' : 'bg-slate-300'
                    }`}>
                      {index + 1}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-slate-900 truncate">{user.name}</p>
                      <p className="text-xs text-slate-500">{user.completed} de {user.total_tasks} tareas completadas</p>
                    </div>
                    <div className="flex items-center gap-3">
                      <div className="text-right">
                        <p className="text-xs text-slate-500">Cumplimiento</p>
                        <p className={`text-lg font-bold ${
                          user.completion_rate >= 80 ? 'text-emerald-600' :
                          user.completion_rate >= 50 ? 'text-blue-600' : 'text-amber-600'
                        }`}>
                          {user.completion_rate}%
                        </p>
                      </div>
                      <div className="w-20">
                        <div className="h-2 bg-slate-200 rounded-full overflow-hidden">
                          <div 
                            className={`h-full rounded-full ${
                              user.completion_rate >= 80 ? 'bg-emerald-500' :
                              user.completion_rate >= 50 ? 'bg-blue-500' : 'bg-amber-500'
                            }`}
                            style={{ width: `${user.completion_rate}%` }}
                          ></div>
                        </div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>
    </Layout>
  );
}
