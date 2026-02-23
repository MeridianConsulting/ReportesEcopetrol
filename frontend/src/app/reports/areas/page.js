// app/reports/areas/page.js
'use client';

import { useEffect, useState, useCallback, useRef } from 'react';
import { useRouter } from 'next/navigation';
import dynamic from 'next/dynamic';
import Layout from '../../../components/Layout';
import DateRangeFilter from '../../../components/DateRangeFilter';
import TaskFiltersBar from '../../../components/TaskFiltersBar';
import { apiRequest } from '../../../lib/api';
import { 
  Building2,
  CheckCircle2, 
  AlertTriangle, 
  Clock,
  Loader2,
  Target,
  Activity,
  TrendingUp,
  ChevronDown,
  RefreshCw,
  ClipboardList,
  X,
  Calendar
} from 'lucide-react';

// Importar Pie chart dinámicamente
const ResponsivePie = dynamic(() => import('@nivo/pie').then(m => m.ResponsivePie), { 
  ssr: false,
  loading: () => <div className="flex items-center justify-center h-full"><Loader2 className="w-5 h-5 animate-spin text-slate-400" /></div>
});

// Importar Bar chart dinámicamente
const ResponsiveBar = dynamic(() => import('@nivo/bar').then(m => m.ResponsiveBar), { 
  ssr: false,
  loading: () => <div className="flex items-center justify-center h-full"><Loader2 className="w-5 h-5 animate-spin text-slate-400" /></div>
});

export default function AreasDashboard() {
  const router = useRouter();
  const [areas, setAreas] = useState([]);
  const [allTasks, setAllTasks] = useState([]);
  const [users, setUsers] = useState([]);
  const [kpiCategories, setKpiCategories] = useState({}); // { areaId: [categories] }
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [user, setUser] = useState(null);
  const [selectedAreaFilter, setSelectedAreaFilter] = useState(null); // null = todas las áreas
  const [expandedAreas, setExpandedAreas] = useState({});
  // Filtros por área: { areaId: { status, priority, kpi_category_id, responsible_id, date_from, date_to, sortOrder } }
  const [areaFilters, setAreaFilters] = useState({});
  // Controlar si el gráfico de subcategorías está expandido por área
  const [expandedSubcategoryChart, setExpandedSubcategoryChart] = useState({});
  const [expandedDestinatariosChart, setExpandedDestinatariosChart] = useState({});
  const [visibleTasksCount, setVisibleTasksCount] = useState({}); // { areaId: number }
  const [areaDrillDown, setAreaDrillDown] = useState({}); // { areaId: '' | 'No iniciada' | 'En progreso' | 'Completada' | 'En riesgo' | 'overdue' }
  const listSectionRefs = useRef({});
  const TASKS_PER_PAGE = 10;
  // Fechas propias de la gráfica de subcategorías (filtro por fecha)
  const today = new Date().toISOString().split('T')[0];
  const [subcategoryDateFrom, setSubcategoryDateFrom] = useState(today);
  const [subcategoryDateTo, setSubcategoryDateTo] = useState(today);
  // Fechas propias de la gráfica de área destinataria (filtro por fecha)
  const [destinatariosDateFrom, setDestinatariosDateFrom] = useState(today);
  const [destinatariosDateTo, setDestinatariosDateTo] = useState(today);
  // Inicializar con la fecha de hoy
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);
  const [currentPeriod, setCurrentPeriod] = useState('today');

  useEffect(() => {
    async function loadUser() {
      try {
        const data = await apiRequest('/auth/me');
        if (!['admin', 'lider_area', 'colaborador'].includes(data.data.role)) {
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

  const [lastUpdated, setLastUpdated] = useState(null);
  const [autoRefreshing, setAutoRefreshing] = useState(false);
  const AUTO_REFRESH_INTERVAL = 30000; // 30 segundos

  const loadData = useCallback(async (from, to, isRefresh = false, isSilent = false) => {
    if (!user) return;
    
    if (isSilent) {
      setAutoRefreshing(true);
    } else if (isRefresh) {
      setRefreshing(true);
    } else {
      setLoading(true);
    }
    
    try {
      const taskParams = new URLSearchParams();
      if (from) taskParams.append('date_from', from);
      if (to) taskParams.append('date_to', to);
      
      const tasksUrl = `/tasks${taskParams.toString() ? '?' + taskParams.toString() : ''}`;
      
      // En refresh silencioso solo recargar tareas (lo que cambia frecuentemente)
      if (isSilent && areas.length > 0) {
        const tasksData = await apiRequest(tasksUrl);
        setAllTasks(tasksData.data || []);
      } else {
        const [areasData, tasksData, usersData] = await Promise.all([
          apiRequest('/areas'),
          apiRequest(tasksUrl),
          apiRequest('/users')
        ]);
        
        // Filtrar áreas según el rol del usuario
        let filteredAreas = areasData.data || [];
        if (user.role === 'colaborador' || user.role === 'lider_area') {
          filteredAreas = filteredAreas.filter(area => area.id === user.area_id);
        }
        
        // Cargar categorías KPI para cada área
        const categoriesByArea = {};
        for (const area of filteredAreas) {
          try {
            const categoriesData = await apiRequest(`/kpi-categories/by-area/${area.id}`);
            categoriesByArea[area.id] = categoriesData.data || [];
          } catch (e) {
            categoriesByArea[area.id] = [];
          }
        }
        
        setAreas(filteredAreas);
        setAllTasks(tasksData.data || []);
        setUsers(usersData.data || []);
        setKpiCategories(categoriesByArea);
      }
      setLastUpdated(new Date());
    } catch (e) {
      // Error loading data
    } finally {
      setLoading(false);
      setRefreshing(false);
      setAutoRefreshing(false);
    }
  }, [user, areas.length]);

  // Carga inicial y cuando cambian filtros de fecha
  useEffect(() => {
    if (user) {
      loadData(dateFrom, dateTo);
    }
  }, [user, dateFrom, dateTo, loadData]);

  // Auto-refresh silencioso cada 30 segundos
  useEffect(() => {
    if (!user) return;
    const interval = setInterval(() => {
      loadData(dateFrom, dateTo, false, true);
    }, AUTO_REFRESH_INTERVAL);
    return () => clearInterval(interval);
  }, [user, dateFrom, dateTo, loadData]);

  const handleDateChange = (from, to, period) => {
    setDateFrom(from || '');
    setDateTo(to || '');
    setCurrentPeriod(period);
  };

  const handleRefresh = () => {
    loadData(dateFrom, dateTo, true);
  };

  // Obtener nombre del KPI para una tarea
  function getTaskKpiName(task, areaId) {
    if (!task.kpi_category_id) return 'Sin KPI asignado';
    const areaKpiCategories = kpiCategories[areaId] || [];
    const category = areaKpiCategories.find(cat => cat.id === task.kpi_category_id);
    return category ? (category.name || category.kpi_name || 'Sin categoría') : 'Sin KPI asignado';
  }

  /**
   * Fecha efectiva para el Dashboard: FECHA_INICIO_ACTIVIDAD (start_date).
   * Si está vacía o inválida, usa FECHA_CREACION_BD (created_at) como respaldo y marca isEstimated.
   */
  function getTaskEffectiveDate(task) {
    const start = task.start_date;
    if (start) {
      const d = new Date(start);
      if (!isNaN(d.getTime())) {
        const ymd = d.toISOString().split('T')[0];
        if (/^\d{4}-\d{2}-\d{2}$/.test(ymd)) return { date: ymd, isEstimated: false };
      }
    }
    const created = task.created_at;
    if (created) {
      const ymd = new Date(created).toISOString().split('T')[0];
      return { date: ymd, isEstimated: true };
    }
    return { date: null, isEstimated: true };
  }

  /**
   * Determina si una tarea debe incluirse en el reporte del rango [from, to].
   * Regla A: La fecha efectiva (inicio o creación) está dentro del rango.
   * Regla B (tarea arrastrada): La tarea está activa (En progreso/En riesgo/En revisión),
   *   inició en o antes del fin del rango, y no está cerrada antes del inicio del rango.
   */
  function isTaskInDateRange(task, from, to) {
    const { date: effectiveDate } = getTaskEffectiveDate(task);

    // Regla A: fecha efectiva dentro del rango
    if (effectiveDate) {
      if (from && to && effectiveDate >= from && effectiveDate <= to) return true;
      if (from && !to && effectiveDate >= from) return true;
      if (!from && to && effectiveDate <= to) return true;
      if (!from && !to) return true;
    }

    // Regla B: tarea arrastrada (activa y en ejecución durante el rango)
    const activeStatuses = ['En progreso', 'En riesgo', 'En revisión'];
    if (!activeStatuses.includes(task.status)) return false;

    const rangeEnd = to || from;
    if (!effectiveDate || !rangeEnd || effectiveDate > rangeEnd) return false;

    const rangeStart = from || to;
    if (task.closed_date && task.closed_date < rangeStart) return false;

    return true;
  }

  // Obtener tareas del día para un área específica (con filtros aplicados).
  // Regla: las tareas se muestran en el dashboard del área que las realiza (area_id), no del área destinataria (area_destinataria_id).
  // Filtros y agrupaciones usan fecha de inicio de actividad (con respaldo en created_at)
  // Incluye tareas "arrastradas" (activas que iniciaron antes pero siguen en ejecución)
  function getAreaDayTasks(areaId) {
    const areaTasks = allTasks.filter(t => t.area_id == areaId);
    
    // Filtrar por rango de fechas global (incluye tareas arrastradas)
    let filteredTasks = areaTasks;
    if (dateFrom || dateTo) {
      filteredTasks = areaTasks.filter(t => isTaskInDateRange(t, dateFrom, dateTo));
    }
    
    // Aplicar filtros específicos del área
    const filters = areaFilters[areaId] || {};
    
    // Filtro por estado
    if (filters.status) {
      filteredTasks = filteredTasks.filter(t => t.status === filters.status);
    }
    
    // Filtro por prioridad
    if (filters.priority) {
      filteredTasks = filteredTasks.filter(t => t.priority === filters.priority);
    }
    
    // Filtro por KPI
    if (filters.kpi_category_id) {
      filteredTasks = filteredTasks.filter(t => t.kpi_category_id == filters.kpi_category_id);
    }
    
    // Filtro por persona responsable
    if (filters.responsible_id) {
      filteredTasks = filteredTasks.filter(t => t.responsible_id == filters.responsible_id);
    }
    
    // Filtro por fecha del área (incluye tareas arrastradas)
    if (filters.date_from || filters.date_to) {
      filteredTasks = filteredTasks.filter(t => isTaskInDateRange(t, filters.date_from, filters.date_to));
    }
    
    // Ordenamiento por fecha efectiva (inicio actividad)
    const sortOrder = filters.sortOrder || 'desc';
    filteredTasks.sort((a, b) => {
      const { date: dateA } = getTaskEffectiveDate(a);
      const dateB = getTaskEffectiveDate(b).date;
      const tsA = dateA ? new Date(dateA).getTime() : 0;
      const tsB = dateB ? new Date(dateB).getTime() : 0;
      if (sortOrder === 'desc') {
        return tsB - tsA;
      } else {
        return tsA - tsB;
      }
    });
    
    // Si no hay ordenamiento personalizado, separar Altas primero e intercalar por responsable
    if (!filters.sortOrder) {
      const highPriority = filteredTasks.filter(t => t.priority === 'Alta');
      const rest = filteredTasks.filter(t => t.priority !== 'Alta');

      // Intercalar tareas Alta por responsable (round-robin)
      if (highPriority.length > 1) {
        const byPerson = {};
        highPriority.forEach(t => {
          const key = t.responsible_id || t.responsible_name || 'sin_asignar';
          if (!byPerson[key]) byPerson[key] = [];
          byPerson[key].push(t);
        });

        const queues = Object.values(byPerson);
        const interleaved = [];
        let maxLen = Math.max(...queues.map(q => q.length));
        for (let i = 0; i < maxLen; i++) {
          for (const queue of queues) {
            if (i < queue.length) interleaved.push(queue[i]);
          }
        }
        filteredTasks = [...interleaved, ...rest];
      } else {
        filteredTasks = [...highPriority, ...rest];
      }
    }
    
    return filteredTasks;
  }

  // Obtener datos de un área específica (tareas donde area_id = área que realiza la tarea, no area_destinataria_id)
  function getAreaData(areaId) {
    const areaTasks = allTasks.filter(t => t.area_id == areaId);
    const areaUsers = users.filter(u => u.area_id == areaId);
    
    const total = areaTasks.length;
    const completed = areaTasks.filter(t => t.status === 'Completada').length;
    const inProgress = areaTasks.filter(t => t.status === 'En progreso').length;
    const atRisk = areaTasks.filter(t => t.status === 'En riesgo').length;
    const notStarted = areaTasks.filter(t => t.status === 'No iniciada').length;
    // Vencidas: tienen fecha límite y está ya pasada (antes de hoy en fecha local), y no están completadas
    const now = new Date();
    const todayLocal = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
    const overdue = areaTasks.filter(t => t.due_date && t.due_date < todayLocal && t.status !== 'Completada').length;
    
    const avgProgress = total > 0 
      ? Math.round(areaTasks.reduce((sum, t) => sum + (t.progress_percent || 0), 0) / total)
      : 0;
    
    const completionRate = total > 0 ? Math.round((completed / total) * 100) : 0;

    // Datos para gráfico por KPI
    const kpiCount = {};
    let tasksWithoutKpi = 0;
    
    areaTasks.forEach(t => {
      if (t.kpi_category_id) {
        kpiCount[t.kpi_category_id] = (kpiCount[t.kpi_category_id] || 0) + 1;
      } else {
        tasksWithoutKpi++;
      }
    });
    
    // Obtener nombres de categorías KPI
    const areaKpiCategories = kpiCategories[areaId] || [];
    const categoryMap = {};
    areaKpiCategories.forEach(cat => {
      categoryMap[cat.id] = cat.name || cat.kpi_name || 'Sin categoría';
    });
    
    // Colores para KPIs (generar colores dinámicamente)
    const kpiColors = [
      '#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', 
      '#06b6d4', '#f97316', '#ec4899', '#14b8a6', '#6366f1'
    ];
    let colorIndex = 0;
    
    const kpiData = Object.entries(kpiCount).map(([categoryId, count]) => {
      const categoryName = categoryMap[categoryId] || `KPI ${categoryId}`;
      const color = kpiColors[colorIndex % kpiColors.length];
      colorIndex++;
      return {
        id: categoryId,
        label: categoryName,
        value: count,
        color: color
      };
    });
    
    // Agregar tareas sin KPI si las hay
    if (tasksWithoutKpi > 0) {
      kpiData.push({
        id: 'sin_kpi',
        label: 'Sin KPI asignado',
        value: tasksWithoutKpi,
        color: '#94a3b8'
      });
    }
    
    // Ordenar por valor descendente
    kpiData.sort((a, b) => b.value - a.value);

    // Datos para gráfico de estados
    const statusColors = {
      'Completada': '#10b981',
      'En progreso': '#3b82f6',
      'En revisión': '#8b5cf6',
      'No iniciada': '#94a3b8',
      'En riesgo': '#ef4444'
    };
    const statusData = [
      { id: 'Completada', label: 'Completada', value: completed, color: statusColors['Completada'] },
      { id: 'En progreso', label: 'En progreso', value: inProgress, color: statusColors['En progreso'] },
      { id: 'No iniciada', label: 'No iniciada', value: notStarted, color: statusColors['No iniciada'] },
      { id: 'En riesgo', label: 'En riesgo', value: atRisk, color: statusColors['En riesgo'] },
    ].filter(s => s.value > 0);

    return {
      total,
      completed,
      inProgress,
      atRisk,
      notStarted,
      overdue,
      avgProgress,
      completionRate,
      kpiData,
      statusData,
      users: areaUsers,
      tasks: areaTasks
    };
  }

  function toggleArea(areaId) {
    setExpandedAreas(prev => ({
      ...prev,
      [areaId]: !prev[areaId]
    }));
  }

  // Fecha de hoy en local (YYYY-MM-DD) para comparar vencimientos
  const now = new Date();
  const todayStr = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
  const isOverdueTask = (t) => t.due_date && t.due_date < todayStr && t.status !== 'Completada';

  function handleAreaCounterClick(areaId, statusValue) {
    setAreaDrillDown(prev => ({ ...prev, [areaId]: statusValue }));
    setTimeout(() => {
      const el = listSectionRefs.current[areaId];
      if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 100);
  }

  function getAreaDisplayTasks(areaId, dayTasks) {
    const drill = areaDrillDown[areaId];
    if (!drill) return dayTasks;
    if (drill === 'overdue') return dayTasks.filter(isOverdueTask);
    if (drill === 'sin_completar') return dayTasks.filter(t => t.status !== 'Completada');
    return dayTasks.filter(t => t.status === drill);
  }

  const DRILL_LABELS = {
    '': 'Todas',
    'sin_completar': 'Sin completar',
    'No iniciada': 'Sin iniciar',
    'En progreso': 'En progreso',
    'Completada': 'Completadas',
    'En riesgo': 'Riesgo',
    'overdue': 'Vencidas'
  };

  // Mapa de KPIs IT con sus nombres completos
  const IT_KPI_MAP = {
    'IT_01': 'Continuidad Operativa de Servicios Críticos (Disponibilidad)',
    'IT_02': 'Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)',
    'IT_03': 'Entrega de Desarrollo y Automatización (Software)',
    'IT_04': 'Actualización de Documentación y Control de Activos IT',
    'IT_05': 'Eficiencia en Atención y Cierre de Soporte IT'
  };

  // Paleta de colores fija por KPI
  const KPI_COLORS = {
    'IT_01': '#3b82f6', // Azul
    'IT_02': '#10b981', // Verde
    'IT_03': '#8b5cf6', // Violeta
    'IT_04': '#f59e0b', // Ámbar
    'IT_05': '#ef4444'  // Rojo
  };

  // Función para determinar el código KPI según la subcategoría
  function getKpiCodeFromSubcategory(subcategoryName) {
    // IT_01: Continuidad Operativa de Servicios Críticos (Disponibilidad)
    const it01Subcategories = [
      'Incidentes (urgente / caída)',
      'Servidor / servicio crítico (caída o degradación)',
      'Red / Internet / Wi-Fi (lento o intermitente)',
      'Acceso remoto: VPN / dominio (no permite ingresar)',
      'Backups y restauración (verificación / restauración / pruebas de recuperación)'
    ];
    
    // IT_02: Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)
    const it02Subcategories = [
      'Soporte usuario final (PC y periféricos)',
      'Impresión y digitalización (impresora / escáner)',
      'Configuración e instalación (software externo y básicos)',
      'Mantenimiento preventivo (mantenimientos periódicos, parches, optimización)',
      'Cotización y compras (equipos/software)'
    ];
    
    // IT_03: Entrega de Desarrollo y Automatización (Software)
    const it03Subcategories = [
      'Desarrollo de software (nuevas funcionalidades / módulos)',
      'Mantenimiento correctivo de software (bugs / fallas en aplicativo propio)',
      'Mantenimiento evolutivo de software (mejoras y optimizaciones)',
      'Integraciones (APIs / conectores / interoperabilidad)',
      'Automatización de procesos (scripts / flujos / RPA)',
      'Bases de datos (modelado / consultas / optimización)',
      'Despliegues y versionamiento (publicación / control de versiones)',
      'Soporte a aplicativo propio (incidentes del sistema interno)'
    ];
    
    // IT_04: Actualización de Documentación y Control de Activos IT
    const it04Subcategories = [
      'Documentación y reportes (informes mensuales / guías / procedimientos / runbook)',
      'Actualización de hojas de vida de equipos (inventario del activo)',
      'Actualización del cronograma de mantenimiento de equipos',
      'Informes de backups'
    ];
    
    // IT_05: Eficiencia en Atención y Cierre de Soporte IT
    const it05Subcategories = [
      'Usuarios y contraseñas (crear/bloquear/desactivar / reset / desbloqueos)',
      'Permisos y accesos (carpetas / grupos / roles / cambios por cargo)',
      'Correo y licencias (O365 / Google) (licencias, buzones/alias, configuración, envío/recepción)',
      'Ciberseguridad (MFA / phishing / cuentas sospechosas / revisión básica de accesos)',
      'Otros (no clasificado)'
    ];
    
    if (it01Subcategories.includes(subcategoryName)) return 'IT_01';
    if (it02Subcategories.includes(subcategoryName)) return 'IT_02';
    if (it03Subcategories.includes(subcategoryName)) return 'IT_03';
    if (it04Subcategories.includes(subcategoryName)) return 'IT_04';
    if (it05Subcategories.includes(subcategoryName)) return 'IT_05';
    
    return null; // Si no coincide con ninguna
  }

  // Paleta de colores para la gráfica de subcategorías (una barra por color)
  const SUBCATEGORY_COLORS = [
    '#6366f1', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6',
    '#06b6d4', '#ec4899', '#14b8a6', '#f97316', '#84cc16',
    '#a855f7', '#0ea5e9', '#eab308', '#22c55e', '#f43f5e'
  ];

  // Obtener datos de subcategorías para gráfica de barras (solo IT), filtrado por fecha de inicio de actividad
  function getSubcategoryBarData(areaId) {
    if (areaId !== 1) return []; // Solo para área IT (id = 1)
    
    let areaTasks = allTasks.filter(t => t.area_id == areaId);
    // Filtrar por rango de fechas de la gráfica (incluye tareas arrastradas)
    if (subcategoryDateFrom || subcategoryDateTo) {
      areaTasks = areaTasks.filter(t => isTaskInDateRange(t, subcategoryDateFrom, subcategoryDateTo));
    }
    
    // Agrupar por subcategoría
    const subcategoryCount = {};
    areaTasks.forEach(t => {
      if (t.kpi_subcategory) {
        subcategoryCount[t.kpi_subcategory] = (subcategoryCount[t.kpi_subcategory] || 0) + 1;
      }
    });
    
    // Convertir a formato para gráfica de barras; cada barra con su color de la paleta
    const data = Object.entries(subcategoryCount)
      .map(([subcategory, count], i) => {
        const kpiCode = getKpiCodeFromSubcategory(subcategory);
        return {
          subcategoria: subcategory,
          cantidad: count,
          fullName: subcategory,
          kpiCode: kpiCode,
          kpiColor: kpiCode ? KPI_COLORS[kpiCode] : '#94a3b8',
          kpiName: kpiCode ? IT_KPI_MAP[kpiCode] : 'Sin clasificar',
          barColor: SUBCATEGORY_COLORS[i % SUBCATEGORY_COLORS.length]
        };
      })
      .sort((a, b) => b.cantidad - a.cantidad);
    
    return data;
  }

  // Paleta de colores para la gráfica de área destinataria (una barra por color)
  const DESTINATARIOS_COLORS = [
    '#6366f1', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6',
    '#06b6d4', '#ec4899', '#14b8a6', '#f97316', '#84cc16'
  ];

  // Obtener datos de área destinataria para gráfica (todas las áreas): distribución de destinatarios, filtrado por fecha de inicio de actividad
  function getDestinatariosBarData(areaId) {
    let areaTasks = allTasks.filter(t => t.area_id == areaId);
    // Filtrar por rango de fechas de la gráfica (incluye tareas arrastradas)
    if (destinatariosDateFrom || destinatariosDateTo) {
      areaTasks = areaTasks.filter(t => isTaskInDateRange(t, destinatariosDateFrom, destinatariosDateTo));
    }
    const byDestinatario = {};
    areaTasks.forEach(t => {
      const destId = t.area_destinataria_id ?? t.area_id;
      const name = t.area_destinataria_name || t.area_name || areas.find(a => a.id == destId)?.name || `Área ${destId}`;
      if (!byDestinatario[name]) byDestinatario[name] = { name, count: 0 };
      byDestinatario[name].count += 1;
    });
    return Object.values(byDestinatario)
      .map(({ name, count }, i) => ({
        areaDestinataria: name,
        cantidad: count,
        barColor: DESTINATARIOS_COLORS[i % DESTINATARIOS_COLORS.length]
      }))
      .sort((a, b) => b.cantidad - a.cantidad);
  }

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
      'all': '',
      'custom': 'del rango seleccionado'
    };
    return labels[currentPeriod] || '';
  };

  return (
    <Layout>
      <div className="p-4 sm:p-6 lg:p-8 w-full max-w-7xl mx-auto overflow-hidden">
        <div className="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <h1 className="text-2xl font-semibold text-slate-900">
              {user?.role === 'colaborador' || user?.role === 'lider_area' 
                ? 'Dashboard de mi Area' 
                : 'Dashboard por Area'}
            </h1>
            <p className="text-slate-500 mt-0.5 text-sm">
              {user?.role === 'colaborador' || user?.role === 'lider_area'
                ? `KPIs y gráficos ${getPeriodLabel()} de tu área`
                : `KPIs y graficos ${getPeriodLabel()} para cada area`}
            </p>
          </div>
          
          {/* Filtros de fecha + indicador en tiempo real */}
          <div className="flex items-center gap-3">
            {lastUpdated && (
              <div className="hidden sm:flex items-center gap-2 text-xs text-slate-400">
                {autoRefreshing && (
                  <span className="flex items-center gap-1 text-indigo-500">
                    <Loader2 className="w-3 h-3 animate-spin" />
                  </span>
                )}
                <span className="flex items-center gap-1">
                  <span className={`w-1.5 h-1.5 rounded-full ${autoRefreshing ? 'bg-indigo-500 animate-pulse' : 'bg-emerald-500'}`}></span>
                  {lastUpdated.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit', second: '2-digit' })}
                </span>
              </div>
            )}
            <DateRangeFilter 
              onChange={handleDateChange}
              defaultPeriod="today"
            />
            <button
              onClick={handleRefresh}
              disabled={refreshing || autoRefreshing}
              className="p-2 text-slate-500 hover:text-slate-700 hover:bg-slate-100 rounded-lg transition-colors disabled:opacity-50"
              title="Actualizar datos"
            >
              <RefreshCw className={`w-4 h-4 ${refreshing || autoRefreshing ? 'animate-spin' : ''}`} />
            </button>
          </div>
        </div>

        {/* Filtros de áreas (solo para admins) */}
        {user?.role === 'admin' && areas.length > 1 && (
          <div className="mb-6 bg-white rounded-xl border border-slate-200 p-4">
            <div className="flex items-center gap-2 mb-3">
              <Building2 className="w-4 h-4 text-slate-500" strokeWidth={2} />
              <span className="text-sm font-medium text-slate-700">Filtrar por área</span>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <button
                onClick={() => setSelectedAreaFilter(null)}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                  selectedAreaFilter === null
                    ? 'bg-indigo-600 text-white shadow-sm'
                    : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
                }`}
              >
                Todas las áreas
              </button>
              {areas
                .filter(area => {
                  // Solo mostrar áreas que tienen tareas
                  const areaTasks = allTasks.filter(t => t.area_id == area.id);
                  return areaTasks.length > 0;
                })
                .map(area => {
                  const areaTasks = allTasks.filter(t => t.area_id == area.id);
                  
                  return (
                    <button
                      key={area.id}
                      onClick={() => setSelectedAreaFilter(selectedAreaFilter === area.id ? null : area.id)}
                      className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors flex items-center gap-2 ${
                        selectedAreaFilter === area.id
                          ? 'bg-indigo-600 text-white shadow-sm'
                          : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
                      }`}
                    >
                      {area.name}
                      <span className={`text-xs px-1.5 py-0.5 rounded-full ${
                        selectedAreaFilter === area.id
                          ? 'bg-white/20 text-white'
                          : 'bg-slate-200 text-slate-600'
                      }`}>
                        {areaTasks.length}
                      </span>
                      {selectedAreaFilter === area.id && (
                        <X className="w-3.5 h-3.5" />
                      )}
                    </button>
                  );
                })}
            </div>
          </div>
        )}

        {/* Grid de áreas */}
        <div className="space-y-4">
          {areas
            .filter(area => {
              // Si hay un filtro de área seleccionado, solo mostrar esa área
              if (selectedAreaFilter !== null) {
                return area.id === selectedAreaFilter;
              }
              return true;
            })
            .map(area => {
            const data = getAreaData(area.id);
            const isExpanded = expandedAreas[area.id];
            
            if (data.total === 0) return null; // Ocultar áreas sin tareas

            return (
              <div key={area.id} className="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm">
                {/* Header del área - Siempre visible */}
                <button
                  onClick={() => toggleArea(area.id)}
                  className="w-full px-5 py-4 flex items-center justify-between hover:bg-slate-50 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 bg-indigo-100 rounded-xl flex items-center justify-center">
                      <Building2 className="w-6 h-6 text-indigo-600" strokeWidth={1.75} />
                    </div>
                    <div className="text-left">
                      <h2 className="text-lg font-semibold text-slate-900">{area.name}</h2>
                      <p className="text-sm text-slate-500">{data.total} tareas · {data.users.length} miembros</p>
                    </div>
                  </div>
                  
                  {/* KPIs resumidos: mismo sistema que en el interior (semáforo + total) */}
                  <div className="flex items-center gap-6">
                    <div className="hidden sm:flex items-center gap-4">
                      <div className="text-center">
                        <p className="text-xl font-bold tabular-nums text-emerald-600">
                          {data.total > 0 ? Math.round((data.completed / data.total) * 100) : 0}%
                        </p>
                        <p className="text-xs text-slate-500">Completadas</p>
                      </div>
                      <div className="text-center">
                        <p className="text-xl font-bold tabular-nums text-amber-600">
                          {data.total > 0 ? Math.round((data.inProgress / data.total) * 100) : 0}%
                        </p>
                        <p className="text-xs text-slate-500">En progreso</p>
                      </div>
                      <div className="text-center">
                        <p className="text-xl font-bold tabular-nums text-red-600">
                          {data.total > 0 ? Math.round((data.notStarted / data.total) * 100) : 0}%
                        </p>
                        <p className="text-xs text-slate-500">Sin iniciar</p>
                      </div>
                      <div className="text-center">
                        <p className="text-xl font-bold tabular-nums text-blue-600">{data.total}</p>
                        <p className="text-xs text-slate-500">Total tareas</p>
                      </div>
                    </div>
                    <ChevronDown className={`w-5 h-5 text-slate-400 transition-transform ${isExpanded ? 'rotate-180' : ''}`} />
                  </div>
                </button>

                {/* Contenido expandido */}
                {isExpanded && (
                  <div className="border-t border-slate-200">
                    {/* KPIs del área: % Completadas, % En progreso, % Sin iniciar, Total tareas */}
                    {(() => {
                      const pctCompleted = data.total > 0 ? Math.round((data.completed / data.total) * 100) : 0;
                      const pctInProgress = data.total > 0 ? Math.round((data.inProgress / data.total) * 100) : 0;
                      const pctNotStarted = data.total > 0 ? Math.round((data.notStarted / data.total) * 100) : 0;
                      return (
                        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 p-5 bg-slate-50">
                          <button
                            type="button"
                            onClick={() => handleAreaCounterClick(area.id, 'Completada')}
                            className={`bg-white rounded-lg p-4 border text-left transition-colors hover:border-indigo-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-1 ${areaDrillDown[area.id] === 'Completada' ? 'border-indigo-400 ring-2 ring-indigo-200' : 'border-slate-200'}`}
                          >
                            <div className="flex items-center gap-3">
                              <div className="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center">
                                <Target className="w-5 h-5 text-emerald-600" strokeWidth={1.75} />
                              </div>
                              <div>
                                <p className="text-2xl font-bold text-slate-900 tabular-nums">{pctCompleted}%</p>
                                <p className="text-xs text-slate-500">Completadas</p>
                              </div>
                            </div>
                          </button>
                          <button
                            type="button"
                            onClick={() => handleAreaCounterClick(area.id, 'En progreso')}
                            className={`bg-white rounded-lg p-4 border text-left transition-colors hover:border-indigo-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-1 ${areaDrillDown[area.id] === 'En progreso' ? 'border-indigo-400 ring-2 ring-indigo-200' : 'border-slate-200'}`}
                          >
                            <div className="flex items-center gap-3">
                              <div className="w-10 h-10 bg-amber-100 rounded-lg flex items-center justify-center">
                                <Activity className="w-5 h-5 text-amber-600" strokeWidth={1.75} />
                              </div>
                              <div>
                                <p className="text-2xl font-bold text-slate-900 tabular-nums">{pctInProgress}%</p>
                                <p className="text-xs text-slate-500">En progreso</p>
                              </div>
                            </div>
                          </button>
                          <button
                            type="button"
                            onClick={() => handleAreaCounterClick(area.id, 'No iniciada')}
                            className={`bg-white rounded-lg p-4 border text-left transition-colors hover:border-indigo-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-1 ${areaDrillDown[area.id] === 'No iniciada' ? 'border-indigo-400 ring-2 ring-indigo-200' : 'border-slate-200'}`}
                          >
                            <div className="flex items-center gap-3">
                              <div className="w-10 h-10 bg-red-100 rounded-lg flex items-center justify-center">
                                <Clock className="w-5 h-5 text-red-600" strokeWidth={1.75} />
                              </div>
                              <div>
                                <p className="text-2xl font-bold text-slate-900 tabular-nums">{pctNotStarted}%</p>
                                <p className="text-xs text-slate-500">Sin iniciar</p>
                              </div>
                            </div>
                          </button>
                          <button
                            type="button"
                            onClick={() => handleAreaCounterClick(area.id, '')}
                            className={`bg-white rounded-lg p-4 border text-left transition-colors hover:border-indigo-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-1 ${areaDrillDown[area.id] === '' ? 'border-indigo-400 ring-2 ring-indigo-200' : 'border-slate-200'}`}
                          >
                            <div className="flex items-center gap-3">
                              <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                                <ClipboardList className="w-5 h-5 text-blue-600" strokeWidth={1.75} />
                              </div>
                              <div>
                                <p className="text-2xl font-bold text-slate-900 tabular-nums">{data.total}</p>
                                <p className="text-xs text-slate-500">Total tareas</p>
                              </div>
                            </div>
                          </button>
                        </div>
                      );
                    })()}

                    {/* Gráficos */}
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-0 lg:gap-0">
                      {/* Gráfico por KPI */}
                      <div className="p-5 border-r border-b lg:border-b-0 border-slate-200 relative">
                        <h3 className="text-sm font-semibold text-slate-700 mb-3">Por KPI</h3>
                        <div style={{ height: '200px' }}>
                          {data.kpiData.length > 0 ? (
                            <>
                              <ResponsivePie
                                data={data.kpiData}
                                margin={{ top: 10, right: 140, bottom: 10, left: 10 }}
                                innerRadius={0.5}
                                padAngle={2}
                                cornerRadius={3}
                                activeOuterRadiusOffset={5}
                                colors={{ datum: 'data.color' }}
                                borderWidth={1}
                                borderColor={{ from: 'color', modifiers: [['darker', 0.2]] }}
                                enableArcLinkLabels={false}
                                arcLabelsSkipAngle={10}
                                arcLabelsTextColor="#ffffff"
                                legends={[
                                  {
                                    anchor: 'right',
                                    direction: 'column',
                                    translateX: 100,
                                    translateY: 0,
                                    itemsSpacing: 4,
                                    itemWidth: 120,
                                    itemHeight: 18,
                                    itemTextColor: '#64748b',
                                    itemDirection: 'left-to-right',
                                    symbolSize: 10,
                                    symbolShape: 'circle'
                                  }
                                ]}
                              />
                              {/* Total de tareas en la parte inferior izquierda */}
                              <div className="absolute bottom-2 left-2 bg-white/90 backdrop-blur-sm rounded-lg px-2 py-1 border border-slate-200 shadow-sm">
                                <p className="text-xs text-slate-500">Total</p>
                                <p className="text-lg font-bold text-slate-900 tabular-nums">{data.total}</p>
                              </div>
                            </>
                          ) : (
                            <div className="flex items-center justify-center h-full text-slate-400 text-sm">
                              Sin datos
                            </div>
                          )}
                        </div>
                      </div>

                      {/* Gráfico por Estado */}
                      <div className="p-5 border-b lg:border-b-0 border-slate-200 relative">
                        <h3 className="text-sm font-semibold text-slate-700 mb-3">Por Estado</h3>
                        <div style={{ height: '200px' }}>
                          {data.statusData.length > 0 ? (
                            <>
                              <ResponsivePie
                                data={data.statusData}
                                margin={{ top: 10, right: 100, bottom: 10, left: 10 }}
                                innerRadius={0.5}
                                padAngle={2}
                                cornerRadius={3}
                                activeOuterRadiusOffset={5}
                                colors={{ datum: 'data.color' }}
                                borderWidth={1}
                                borderColor={{ from: 'color', modifiers: [['darker', 0.2]] }}
                                enableArcLinkLabels={false}
                                arcLabelsSkipAngle={10}
                                arcLabelsTextColor="#ffffff"
                                legends={[
                                  {
                                    anchor: 'right',
                                    direction: 'column',
                                    translateX: 90,
                                    translateY: 0,
                                    itemsSpacing: 4,
                                    itemWidth: 80,
                                    itemHeight: 18,
                                    itemTextColor: '#64748b',
                                    itemDirection: 'left-to-right',
                                    symbolSize: 10,
                                    symbolShape: 'circle'
                                  }
                                ]}
                              />
                              {/* Total de tareas en la parte inferior izquierda */}
                              <div className="absolute bottom-2 left-2 bg-white/90 backdrop-blur-sm rounded-lg px-2 py-1 border border-slate-200 shadow-sm">
                                <p className="text-xs text-slate-500">Total</p>
                                <p className="text-lg font-bold text-slate-900 tabular-nums">{data.total}</p>
                              </div>
                            </>
                          ) : (
                            <div className="flex items-center justify-center h-full text-slate-400 text-sm">
                              Sin datos
                            </div>
                          )}
                        </div>
                      </div>
                    </div>

                    {/* Gráfica de barras por subcategorías solo para IT - Desplegable */}
                    {area.id === 1 && (
                      <div className="border-t border-slate-200">
                        <button
                          onClick={() => setExpandedSubcategoryChart(prev => ({
                            ...prev,
                            [area.id]: !prev[area.id]
                          }))}
                          className="w-full px-5 py-3 flex items-center justify-between hover:bg-slate-50 transition-colors"
                        >
                          <h3 className="text-sm font-semibold text-slate-700">Por Subcategoría</h3>
                          <ChevronDown className={`w-4 h-4 text-slate-400 transition-transform ${expandedSubcategoryChart[area.id] ? 'rotate-180' : ''}`} />
                        </button>
                        {expandedSubcategoryChart[area.id] && (
                          <div className="px-5 pb-5 border-t border-slate-100">
                            <div className="flex flex-wrap items-center gap-3 py-3 border-b border-slate-100 mb-3">
                              <span className="text-sm text-slate-600 font-medium">Período:</span>
                              <DateRangeFilter
                                onChange={(from, to) => {
                                  setSubcategoryDateFrom(from || '');
                                  setSubcategoryDateTo(to || '');
                                }}
                                defaultPeriod="today"
                              />
                            </div>
                            {(() => {
                              const subcategoryData = getSubcategoryBarData(area.id);
                              if (subcategoryData.length === 0) {
                                return (
                                  <div className="flex items-center justify-center h-64 text-slate-400 text-sm">
                                    Sin datos de subcategorías
                                  </div>
                                );
                              }
                              
                              // Margen izquierdo generoso para que el texto no se corte (9px por carácter)
                              const maxLabelLen = Math.max(...subcategoryData.map(d => d.subcategoria.length), 8);
                              const leftMargin = Math.min(560, Math.max(260, maxLabelLen * 9));
                              
                              // Altura: 32px por fila, min 320px, max 520px
                              const rowHeight = 32;
                              const baseHeight = 80;
                              const calculatedHeight = subcategoryData.length * rowHeight + baseHeight;
                              const chartHeight = Math.max(320, Math.min(calculatedHeight, 520));
                              
                              // Obtener KPIs únicos para la leyenda
                              const uniqueKpis = Array.from(new Set(subcategoryData.map(d => d.kpiCode).filter(Boolean)))
                                .map(code => ({
                                  code,
                                  name: IT_KPI_MAP[code] || code,
                                  color: KPI_COLORS[code] || '#94a3b8'
                                }));
                              
                              return (
                                <>
                                  <div style={{ maxHeight: '520px', overflowY: 'auto' }}>
                                    <div style={{ height: `${chartHeight}px`, width: '100%' }}>
                                      <ResponsiveBar
                                        data={subcategoryData}
                                        keys={['cantidad']}
                                        indexBy="subcategoria"
                                        layout="horizontal"
                                        margin={{ top: 20, right: 80, bottom: 70, left: leftMargin }}
                                        padding={0.55}
                                        valueScale={{ type: 'linear' }}
                                        indexScale={{ type: 'band', round: true }}
                                        colors={(bar) => bar.data.barColor || bar.data.kpiColor || '#94a3b8'}
                                        borderWidth={1}
                                        borderColor={{ from: 'color', modifiers: [['darker', 0.25]] }}
                                        borderRadius={4}
                                        axisTop={null}
                                        axisRight={null}
                                        axisBottom={{
                                          tickSize: 3,
                                          tickPadding: 5,
                                          tickRotation: 0,
                                          legend: 'Cantidad',
                                          legendPosition: 'middle',
                                          legendOffset: 40,
                                          format: (value) => Math.round(value),
                                          tickValues: 'every 1'
                                        }}
                                        axisLeft={{
                                          tickSize: 0,
                                          tickPadding: 12,
                                          tickRotation: 0,
                                          legend: '',
                                          legendPosition: 'middle',
                                          legendOffset: -leftMargin,
                                          format: (value) => {
                                            const item = subcategoryData.find(d => d.subcategoria === value);
                                            return item?.fullName ?? value;
                                          }
                                        }}
                                        enableGridY={false}
                                        enableGridX={true}
                                        gridXValues={5}
                                        enableLabel={true}
                                        label={(d) => d.value}
                                        labelSkipWidth={0}
                                        labelTextColor="#1e293b"
                                        theme={{
                                          axis: {
                                            ticks: {
                                              text: {
                                                fill: '#334155',
                                                fontSize: 13,
                                                fontFamily: 'system-ui, -apple-system, sans-serif',
                                                fontWeight: 500
                                              }
                                            },
                                            legend: {
                                              text: {
                                                fill: '#475569',
                                                fontSize: 12,
                                                fontFamily: 'system-ui, -apple-system, sans-serif'
                                              }
                                            }
                                          },
                                          grid: {
                                            line: {
                                              stroke: '#e2e8f0',
                                              strokeWidth: 1
                                            }
                                          }
                                        }}
                                        animate={true}
                                        motionConfig="gentle"
                                        barAriaLabel={e => `${e.id}: ${e.formattedValue} tareas`}
                                        tooltip={({ indexValue, value }) => {
                                          const item = subcategoryData.find(d => d.subcategoria === indexValue);
                                          return (
                                            <div style={{
                                              padding: '10px 14px',
                                              background: 'white',
                                              border: '1px solid #e2e8f0',
                                              borderRadius: '6px',
                                              boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
                                              minWidth: '200px'
                                            }}>
                                              <div style={{ marginBottom: '6px' }}>
                                                <strong style={{ color: '#1e293b', fontSize: '13px' }}>
                                                  {item?.fullName || indexValue}
                                                </strong>
                                              </div>
                                              <div style={{ color: '#64748b', fontSize: '12px', marginBottom: '4px' }}>
                                                {value} tarea{value !== 1 ? 's' : ''}
                                              </div>
                                              {item?.kpiCode && (
                                                <div style={{ 
                                                  color: '#475569', 
                                                  fontSize: '11px',
                                                  marginTop: '6px',
                                                  paddingTop: '6px',
                                                  borderTop: '1px solid #e2e8f0'
                                                }}>
                                                  <span style={{ 
                                                    display: 'inline-block',
                                                    width: '10px',
                                                    height: '10px',
                                                    borderRadius: '50%',
                                                    backgroundColor: item.kpiColor,
                                                    marginRight: '6px',
                                                    verticalAlign: 'middle'
                                                  }}></span>
                                                  {item.kpiCode}: {item.kpiName}
                                                </div>
                                              )}
                                            </div>
                                          );
                                        }}
                                      />
                                    </div>
                                  </div>
                                  
                                  {/* Leyenda de KPIs */}
                                  {uniqueKpis.length > 0 && (
                                    <div className="mt-4 pt-4 border-t border-slate-200">
                                      <div className="text-xs font-semibold text-slate-600 mb-2">Leyenda de KPIs:</div>
                                      <div className="flex flex-wrap gap-3">
                                        {uniqueKpis.map(kpi => (
                                          <div 
                                            key={kpi.code}
                                            className="flex items-center gap-2 px-3 py-1.5 bg-slate-50 rounded-lg border border-slate-200"
                                          >
                                            <div 
                                              style={{
                                                width: '12px',
                                                height: '12px',
                                                borderRadius: '50%',
                                                backgroundColor: kpi.color,
                                                flexShrink: 0
                                              }}
                                            ></div>
                                            <span className="text-xs text-slate-700 font-medium">
                                              {kpi.code}
                                            </span>
                                            <span className="text-xs text-slate-600">
                                              {kpi.name}
                                            </span>
                                          </div>
                                        ))}
                                      </div>
                                    </div>
                                  )}
                                </>
                              );
                            })()}
                          </div>
                        )}
                      </div>
                    )}

                    {/* Gráfica de barras por área destinataria (todas las áreas, desplegable) */}
                    <div className="border-t border-slate-200">
                      <button
                        onClick={() => setExpandedDestinatariosChart(prev => ({
                          ...prev,
                          [area.id]: !prev[area.id]
                        }))}
                        className="w-full px-5 py-3 flex items-center justify-between hover:bg-slate-50 transition-colors"
                      >
                        <h3 className="text-sm font-semibold text-slate-700">Distribución por Área Destinataria</h3>
                        <ChevronDown className={`w-4 h-4 text-slate-400 transition-transform ${expandedDestinatariosChart[area.id] ? 'rotate-180' : ''}`} />
                      </button>
                      {expandedDestinatariosChart[area.id] && (
                        <div className="px-5 pb-5 border-t border-slate-100">
                            <div className="flex flex-wrap items-center gap-3 py-3 border-b border-slate-100 mb-3">
                              <span className="text-sm text-slate-600 font-medium">Período:</span>
                              <DateRangeFilter
                                onChange={(from, to) => {
                                  setDestinatariosDateFrom(from || '');
                                  setDestinatariosDateTo(to || '');
                                }}
                                defaultPeriod="today"
                              />
                            </div>
                            {(() => {
                              const destinatariosData = getDestinatariosBarData(area.id);
                              if (destinatariosData.length === 0) {
                                return (
                                  <div className="flex items-center justify-center h-48 text-slate-400 text-sm">
                                    Sin datos de área destinataria
                                  </div>
                                );
                              }
                              const maxLabelLen = Math.max(...destinatariosData.map(d => d.areaDestinataria.length), 8);
                              const leftMargin = Math.min(380, Math.max(200, maxLabelLen * 9));
                              const chartHeight = Math.max(240, Math.min(destinatariosData.length * 36 + 80, 400));
                              return (
                                <div style={{ height: `${chartHeight}px`, width: '100%' }}>
                                  <ResponsiveBar
                                    data={destinatariosData}
                                    keys={['cantidad']}
                                    indexBy="areaDestinataria"
                                    layout="horizontal"
                                    margin={{ top: 20, right: 80, bottom: 60, left: leftMargin }}
                                    padding={0.45}
                                    valueScale={{ type: 'linear' }}
                                    indexScale={{ type: 'band', round: true }}
                                    colors={(bar) => bar.data.barColor || '#6366f1'}
                                    borderWidth={1}
                                    borderColor={{ from: 'color', modifiers: [['darker', 0.25]] }}
                                    borderRadius={4}
                                    axisTop={null}
                                    axisRight={null}
                                    axisBottom={{
                                      tickSize: 3,
                                      tickPadding: 5,
                                      tickRotation: 0,
                                      legend: 'Cantidad',
                                      legendPosition: 'middle',
                                      legendOffset: 40,
                                      format: (v) => Math.round(v),
                                      tickValues: 'every 1'
                                    }}
                                    axisLeft={{
                                      tickSize: 0,
                                      tickPadding: 12,
                                      tickRotation: 0,
                                      legend: '',
                                      legendPosition: 'middle',
                                      legendOffset: -leftMargin,
                                      format: (value) => value
                                    }}
                                    enableGridY={false}
                                    enableGridX={true}
                                    gridXValues={5}
                                    enableLabel={true}
                                    label={(d) => d.value}
                                    labelSkipWidth={0}
                                    labelTextColor="#1e293b"
                                    theme={{
                                      axis: {
                                        ticks: {
                                          text: {
                                            fill: '#334155',
                                            fontSize: 13,
                                            fontFamily: 'system-ui, -apple-system, sans-serif',
                                            fontWeight: 500
                                          }
                                        },
                                        legend: { text: { fill: '#475569', fontSize: 12 } }
                                      },
                                      grid: { line: { stroke: '#e2e8f0', strokeWidth: 1 } }
                                    }}
                                    animate={true}
                                    motionConfig="gentle"
                                    barAriaLabel={e => `${e.id}: ${e.formattedValue} tareas`}
                                    tooltip={({ indexValue, value }) => (
                                      <div style={{
                                        padding: '10px 14px',
                                        background: 'white',
                                        border: '1px solid #e2e8f0',
                                        borderRadius: '6px',
                                        boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
                                        minWidth: '160px'
                                      }}>
                                        <div style={{ marginBottom: '4px', fontWeight: 600, color: '#1e293b' }}>{indexValue}</div>
                                        <div style={{ color: '#64748b', fontSize: '12px' }}>{value} tarea{value !== 1 ? 's' : ''}</div>
                                      </div>
                                    )}
                                  />
                                </div>
                              );
                            })()}
                        </div>
                      )}
                    </div>

                    {/* Lista de tareas del día */}
                    <div className="border-t border-slate-200">
                      <div className="px-5 py-4 border-b border-slate-200 bg-slate-50/50">
                        <h3 className="text-sm font-semibold text-slate-900 flex items-center gap-2">
                          <ClipboardList className="w-4 h-4" />
                          Tareas {getPeriodLabel() ? ` ${getPeriodLabel()}` : ' del período seleccionado'}
                        </h3>
                      </div>
                      
                      {/* Filtros de tareas para esta área */}
                      <TaskFiltersBar
                        filters={areaFilters[area.id] || {
                          status: null,
                          priority: null,
                          kpi_category_id: null,
                          responsible_id: null,
                          date_from: null,
                          date_to: null,
                          sortOrder: 'desc'
                        }}
                        onFiltersChange={(newFilters) => {
                          setAreaFilters(prev => ({
                            ...prev,
                            [area.id]: newFilters
                          }));
                        }}
                        onClearFilters={() => {
                          setAreaFilters(prev => {
                            const newFilters = { ...prev };
                            delete newFilters[area.id];
                            return newFilters;
                          });
                        }}
                        kpiCategories={kpiCategories[area.id] || []}
                        users={data.users || []}
                      />
                      
                      <div
                        ref={(el) => { listSectionRefs.current[area.id] = el; }}
                        className="overflow-x-auto"
                      >
                        {(() => {
                          const dayTasks = getAreaDayTasks(area.id);
                          const displayTasks = getAreaDisplayTasks(area.id, dayTasks);
                          const drill = areaDrillDown[area.id];
                          
                          // Obtener todas las tareas sin filtros del área para el contador (solo filtro de fecha global, incluye arrastradas)
                          const areaTasksWithoutFilters = allTasks.filter(t => {
                            if (t.area_id != area.id) return false;
                            if (dateFrom || dateTo) {
                              return isTaskInDateRange(t, dateFrom, dateTo);
                            }
                            return true;
                          });
                          
                          const hasFilters = areaFilters[area.id] && (
                            areaFilters[area.id].status || 
                            areaFilters[area.id].priority || 
                            areaFilters[area.id].kpi_category_id || 
                            areaFilters[area.id].responsible_id ||
                            areaFilters[area.id].date_from || 
                            areaFilters[area.id].date_to ||
                            areaFilters[area.id].sortOrder !== 'desc'
                          );
                          
                          const limit = visibleTasksCount[area.id] || TASKS_PER_PAGE;
                          const visibleTasks = displayTasks.slice(0, limit);
                          const hasMoreTasks = displayTasks.length > limit;
                          
                          return dayTasks.length > 0 ? (
                            <>
                              <div className="px-5 py-2 bg-slate-50 border-b border-slate-200 flex items-center justify-between gap-2 flex-wrap">
                                <span className="text-xs text-slate-500">
                                  {drill !== undefined && drill !== '' ? (
                                    <>Mostrando: <strong>{DRILL_LABELS[drill]}</strong> ({displayTasks.length} tareas)</>
                                  ) : (
                                    <>Mostrando {visibleTasks.length} de {dayTasks.length} tareas</>
                                  )}
                                  {hasFilters && ` (${areaTasksWithoutFilters.length} total sin filtros)`}
                                </span>
                                {drill !== undefined && drill !== '' && (
                                  <button
                                    type="button"
                                    onClick={() => setAreaDrillDown(prev => ({ ...prev, [area.id]: '' }))}
                                    className="text-xs font-medium text-indigo-600 hover:text-indigo-800"
                                  >
                                    Ver todas
                                  </button>
                                )}
                              </div>
                              <table className="min-w-full">
                                <thead>
                                  <tr className="border-b border-slate-200 bg-slate-50/80">
                                    <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Título</th>
                                    <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">KPI</th>
                                    <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Prioridad</th>
                                    <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Estado</th>
                                    <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Progreso</th>
                                    <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Responsable</th>
                                    <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Fecha inicio</th>
                                    <th className="px-5 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">Fecha cierre</th>
                                  </tr>
                                </thead>
                                <tbody className="divide-y divide-slate-100">
                                  {visibleTasks.map(task => (
                                    <tr key={task.id} className="hover:bg-slate-50 transition-colors">
                                      <td className="px-5 py-3.5 text-sm font-medium text-slate-900">{task.title}</td>
                                      <td className="px-5 py-3.5 text-sm text-slate-600">{getTaskKpiName(task, area.id)}</td>
                                      <td className="px-5 py-3.5">
                                        <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${
                                          task.priority === 'Alta' ? 'bg-rose-50 text-rose-700' :
                                          task.priority === 'Media' ? 'bg-amber-50 text-amber-700' :
                                          'bg-emerald-50 text-emerald-700'
                                        }`}>
                                          {task.priority}
                                        </span>
                                      </td>
                                      <td className="px-5 py-3.5">
                                        <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${
                                          task.status === 'Completada' ? 'bg-emerald-50 text-emerald-700' :
                                          task.status === 'En progreso' ? 'bg-blue-50 text-blue-700' :
                                          task.status === 'En riesgo' ? 'bg-rose-50 text-rose-700' :
                                          task.status === 'En revisión' ? 'bg-violet-50 text-violet-700' :
                                          'bg-slate-100 text-slate-600'
                                        }`}>
                                          {task.status}
                                        </span>
                                      </td>
                                      <td className="px-5 py-3.5">
                                        <div className="flex items-center gap-2">
                                          <div className="w-16 h-1.5 bg-slate-200 rounded-full overflow-hidden">
                                            <div
                                              className={`h-full rounded-full ${
                                                task.progress_percent >= 100 ? 'bg-emerald-500' :
                                                task.progress_percent >= 50 ? 'bg-indigo-500' : 'bg-amber-500'
                                              }`}
                                              style={{ width: `${task.progress_percent || 0}%` }}
                                            ></div>
                                          </div>
                                          <span className="text-xs font-medium text-slate-500 tabular-nums">{task.progress_percent || 0}%</span>
                                        </div>
                                      </td>
                                      <td className="px-5 py-3.5 text-sm text-slate-600">{task.responsible_name || 'Sin asignar'}</td>
                                      <td className="px-5 py-3.5 text-sm text-slate-500">
                                        {(() => {
                                          const { date, isEstimated } = getTaskEffectiveDate(task);
                                          if (!date) return '—';
                                          const formatted = new Date(date + 'T12:00:00').toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' });
                                          return (
                                            <span title={isEstimated ? 'Fecha por defecto (sin fecha de inicio de actividad)' : 'Fecha de inicio de la actividad'}>
                                              {formatted}
                                              {isEstimated && <span className="ml-1 text-amber-600 text-xs" title="Fecha estimada/por defecto">(est.)</span>}
                                            </span>
                                          );
                                        })()}
                                      </td>
                                      <td className="px-5 py-3.5 text-sm text-slate-500">
                                        {(task.due_date || task.closed_date)
                                          ? new Date((task.due_date || task.closed_date) + 'T12:00:00').toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' })
                                          : <span className="text-slate-300">—</span>
                                        }
                                      </td>
                                    </tr>
                                  ))}
                                </tbody>
                              </table>
                              {/* Botón mostrar más / mostrar menos */}
                              {displayTasks.length > TASKS_PER_PAGE && (
                                <div className="px-5 py-3 border-t border-slate-200 bg-slate-50/50 flex items-center justify-center gap-3">
                                  {hasMoreTasks ? (
                                    <button
                                      onClick={() => setVisibleTasksCount(prev => ({ ...prev, [area.id]: limit + TASKS_PER_PAGE }))}
                                      className="text-sm font-medium text-indigo-600 hover:text-indigo-800 transition-colors"
                                    >
                                      Mostrar más ({displayTasks.length - limit} restantes)
                                    </button>
                                  ) : (
                                    <button
                                      onClick={() => setVisibleTasksCount(prev => ({ ...prev, [area.id]: TASKS_PER_PAGE }))}
                                      className="text-sm font-medium text-slate-500 hover:text-slate-700 transition-colors"
                                    >
                                      Mostrar menos
                                    </button>
                                  )}
                                </div>
                              )}
                            </>
                          ) : (
                            <div className="px-5 py-12 text-center">
                              <div className="flex flex-col items-center">
                                <ClipboardList className="w-10 h-10 text-slate-300 mb-3" strokeWidth={1.5} />
                                <p className="text-sm font-medium text-slate-900 mb-1">No hay tareas para este período</p>
                                <p className="text-sm text-slate-500">Selecciona otro rango de fechas para ver las actividades</p>
                              </div>
                            </div>
                          );
                        })()}
                      </div>
                    </div>

                    {/* Estadísticas detalladas (contadores clicables) */}
                    <div className="p-5 border-t border-slate-200 bg-slate-50">
                      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4 text-center">
                        {[
                          { key: '', label: 'Total tareas', value: data.total, className: 'text-slate-900' },
                          { key: 'No iniciada', label: 'Sin iniciar', value: data.notStarted, className: 'text-slate-500' },
                          { key: 'En progreso', label: 'En progreso', value: data.inProgress, className: 'text-blue-600' },
                          { key: 'Completada', label: 'Completadas', value: data.completed, className: 'text-emerald-600' },
                          { key: 'overdue', label: 'Vencidas', value: data.overdue, className: 'text-red-600' }
                        ].map(({ key, label, value, className }) => (
                          <button
                            key={key}
                            type="button"
                            onClick={() => handleAreaCounterClick(area.id, key)}
                            className={`rounded-lg p-3 border transition-colors hover:border-indigo-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-1 ${areaDrillDown[area.id] === key ? 'bg-indigo-50 border-indigo-400 ring-2 ring-indigo-200' : 'bg-white border-slate-200'}`}
                          >
                            <p className={`text-2xl font-bold tabular-nums ${className}`}>{value}</p>
                            <p className="text-xs text-slate-500">{label}</p>
                          </button>
                        ))}
                      </div>
                    </div>

                  </div>
                )}
              </div>
            );
          })}

          {/* Mensaje si no hay áreas con tareas */}
          {areas.filter(a => getAreaData(a.id).total > 0).length === 0 && (
            <div className="bg-white rounded-xl border border-slate-200 p-12 text-center">
              <Building2 className="w-12 h-12 text-slate-300 mx-auto mb-4" strokeWidth={1.5} />
              <h3 className="text-lg font-semibold text-slate-900 mb-2">Sin datos por area</h3>
              <p className="text-slate-500">No hay tareas asignadas a ninguna area</p>
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}

