// app/my-tasks/page.js
'use client';

import { useEffect, useState } from 'react';
import Layout from '../../components/Layout';
import TasksSpreadsheet from '../../components/TasksSpreadsheet';
import { apiRequest } from '../../lib/api';
import { 
  Table2,
  CheckCircle2,
  Clock,
  AlertTriangle,
  FileSpreadsheet,
  Loader2
} from 'lucide-react';

export default function MyTasksPage() {
  const [stats, setStats] = useState({ total: 0, completed: 0, pending: 0, atRisk: 0 });
  const [currentUser, setCurrentUser] = useState(null);
  const [generatingReport, setGeneratingReport] = useState(false);

  async function loadStats() {
    try {
      const meData = await apiRequest('/auth/me');
      const user = meData.data;
      setCurrentUser(user);

      const statsData = await apiRequest(`/tasks/stats?responsible_id=${user.id}`);
      const s = statsData.data || {};
      
      setStats({
        total: s.total || 0,
        completed: s.completed || 0,
        pending: s.pending || 0,
        atRisk: s.at_risk || 0,
      });
    } catch (e) {
      console.error('Error loading stats:', e);
    }
  }

  useEffect(() => {
    loadStats();
  }, []);

  async function generateExcelReport() {
    if (!currentUser?.id) return;
    
    setGeneratingReport(true);
    try {
      const ExcelJS = (await import('exceljs')).default;
      const { saveAs } = await import('file-saver');
      
      // Obtener todas las tareas del usuario
      const data = await apiRequest('/tasks');
      const allTasks = data.data || [];
      const myTasks = allTasks.filter(t => t.responsible_id == currentUser.id);
      
      // Ordenar por fecha de creación (más recientes primero)
      myTasks.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
      
      const workbook = new ExcelJS.Workbook();
      workbook.creator = currentUser?.name || 'Usuario';
      workbook.created = new Date();
      
      // Colores profesionales (grises y azules suaves)
      const headerColor = '4F46E5'; // Indigo
      const headerBg = 'F1F5F9'; // Gris claro
      const borderColor = 'E2E8F0'; // Gris borde
      const textColor = '1E293B'; // Gris oscuro
      const secondaryText = '64748B'; // Gris medio
      
      // Hoja principal: Tareas
      const tasksSheet = workbook.addWorksheet('Mis Tareas', {
        properties: { tabColor: { argb: headerColor } }
      });
      
      // Configurar anchos de columna
      tasksSheet.columns = [
        { width: 12 },  // ID
        { width: 50 },  // Título
        { width: 20 },  // Estado
        { width: 15 },  // Prioridad
        { width: 18 },  // Fecha Creación
        { width: 18 },  // Fecha Vencimiento
        { width: 12 },  // Progreso
        { width: 35 },  // Observaciones
        { width: 30 },  // Área responsable
        { width: 30 },  // Área destinataria
        { width: 30 },  // KPI
        { width: 30 },  // Subcategoría
        { width: 50 }   // Descripción
      ];
      
      // Título principal
      tasksSheet.mergeCells('A1:M1');
      const titleCell = tasksSheet.getCell('A1');
      titleCell.value = `Reporte de Tareas - ${currentUser?.name || 'Usuario'}`;
      titleCell.font = { size: 16, bold: true, color: { argb: 'FFFFFF' } };
      titleCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: headerColor } };
      titleCell.alignment = { horizontal: 'center', vertical: 'middle' };
      tasksSheet.getRow(1).height = 30;
      
      // Información del reporte
      tasksSheet.mergeCells('A2:M2');
      const infoCell = tasksSheet.getCell('A2');
      const fechaGeneracion = new Date().toLocaleString('es-ES', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
      infoCell.value = `Generado el ${fechaGeneracion}`;
      infoCell.font = { size: 10, color: { argb: secondaryText } };
      infoCell.alignment = { horizontal: 'center', vertical: 'middle' };
      tasksSheet.getRow(2).height = 20;
      
      // Resumen estadístico
      tasksSheet.mergeCells('A3:M3');
      const summaryCell = tasksSheet.getCell('A3');
      summaryCell.value = `Total: ${stats.total} | Completadas: ${stats.completed} | En Progreso: ${stats.pending}${stats.atRisk > 0 ? ` | En Riesgo: ${stats.atRisk}` : ''}`;
      summaryCell.font = { size: 11, bold: true, color: { argb: textColor } };
      summaryCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: headerBg } };
      summaryCell.alignment = { horizontal: 'center', vertical: 'middle' };
      tasksSheet.getRow(3).height = 25;
      
      // Encabezados de columna
      const headers = [
        'ID',
        'Título',
        'Estado',
        'Prioridad',
        'Fecha Creación',
        'Fecha Vencimiento',
        'Progreso %',
        'Observaciones',
        'Área responsable',
        'Área destinataria',
        'KPI',
        'Subcategoría',
        'Descripción'
      ];
      
      const headerRow = tasksSheet.getRow(4);
      headerRow.height = 25;
      headers.forEach((header, index) => {
        const cell = headerRow.getCell(index + 1);
        cell.value = header;
        cell.font = { size: 11, bold: true, color: { argb: textColor } };
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: headerBg } };
        cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
        cell.border = {
          top: { style: 'thin', color: { argb: borderColor } },
          bottom: { style: 'thin', color: { argb: borderColor } },
          left: { style: 'thin', color: { argb: borderColor } },
          right: { style: 'thin', color: { argb: borderColor } }
        };
      });
      
      // Datos de tareas
      myTasks.forEach((task, index) => {
        const row = tasksSheet.getRow(5 + index);
        row.height = 20;
        
        const cells = [
          task.id || '',
          task.title || '',
          task.status || '',
          task.priority || '',
          task.created_at ? new Date(task.created_at).toLocaleDateString('es-ES') : '',
          task.due_date ? new Date(task.due_date).toLocaleDateString('es-ES') : '',
          task.progress_percent ? `${task.progress_percent}%` : '0%',
          task.observaciones || '',
          task.area_name || '',
          task.area_destinataria_name || task.area_name || '',
          task.kpi_category_name || '',
          task.kpi_subcategory || '',
          task.description || ''
        ];
        
        cells.forEach((value, cellIndex) => {
          const cell = row.getCell(cellIndex + 1);
          cell.value = value;
          cell.font = { size: 10, color: { argb: textColor } };
          cell.alignment = { 
            horizontal: cellIndex === 0 || cellIndex === 6 ? 'center' : 'left',
            vertical: 'middle',
            wrapText: true
          };
          cell.border = {
            top: { style: 'thin', color: { argb: borderColor } },
            bottom: { style: 'thin', color: { argb: borderColor } },
            left: { style: 'thin', color: { argb: borderColor } },
            right: { style: 'thin', color: { argb: borderColor } }
          };
          
          // Alternar color de fondo para mejor legibilidad
          if (index % 2 === 0) {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFFF' } };
          } else {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FAFAFA' } };
          }
        });
      });
      
      // Congelar fila de encabezados
      tasksSheet.views = [
        { state: 'frozen', ySplit: 4 }
      ];
      
      // Generar archivo
      const buffer = await workbook.xlsx.writeBuffer();
      const blob = new Blob([buffer], { 
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' 
      });
      
      const fileName = `Reporte_Tareas_${currentUser?.name?.replace(/\s+/g, '_') || 'Usuario'}_${new Date().toISOString().split('T')[0]}.xlsx`;
      saveAs(blob, fileName);
      
    } catch (error) {
      console.error('Error generando reporte:', error);
      alert('Error al generar el reporte. Por favor, intente nuevamente.');
    } finally {
      setGeneratingReport(false);
    }
  }

  return (
    <Layout>
      <div className="p-4 sm:p-6 w-full overflow-hidden max-w-full flex flex-col h-full">
        {/* Header compacto con stats inline */}
        <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4 mb-5">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-indigo-600 rounded-xl flex items-center justify-center shadow-sm">
              <Table2 className="w-5 h-5 text-white" strokeWidth={2} />
            </div>
            <div>
              <h1 className="text-xl font-semibold text-slate-900">Mis Tareas</h1>
              <p className="text-slate-500 text-xs">Registro rapido tipo hoja de calculo</p>
            </div>
          </div>
          
          {/* Stats compactos en linea */}
          <div className="flex items-center gap-2">
            <div className="flex items-center gap-1.5 px-3 py-1.5 bg-slate-100 rounded-lg">
              <span className="text-lg font-semibold text-slate-700 tabular-nums">{stats.total}</span>
              <span className="text-xs text-slate-500">total</span>
            </div>
            <div className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-50 rounded-lg">
              <CheckCircle2 className="w-4 h-4 text-emerald-600" strokeWidth={2} />
              <span className="text-lg font-semibold text-emerald-700 tabular-nums">{stats.completed}</span>
            </div>
            <div className="flex items-center gap-1.5 px-3 py-1.5 bg-blue-50 rounded-lg">
              <Clock className="w-4 h-4 text-blue-600" strokeWidth={2} />
              <span className="text-lg font-semibold text-blue-700 tabular-nums">{stats.pending}</span>
            </div>
            {stats.atRisk > 0 && (
              <div className="flex items-center gap-1.5 px-3 py-1.5 bg-rose-50 rounded-lg">
                <AlertTriangle className="w-4 h-4 text-rose-600" strokeWidth={2} />
                <span className="text-lg font-semibold text-rose-700 tabular-nums">{stats.atRisk}</span>
              </div>
            )}
            <button
              onClick={generateExcelReport}
              disabled={generatingReport || !currentUser?.id}
              className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-slate-700 rounded-lg hover:bg-slate-800 disabled:opacity-50 disabled:cursor-not-allowed transition-colors shadow-sm"
            >
              {generatingReport ? (
                <>
                  <Loader2 className="w-4 h-4 animate-spin" />
                  <span>Generando...</span>
                </>
              ) : (
                <>
                  <FileSpreadsheet className="w-4 h-4" strokeWidth={2} />
                  <span>Exportar Excel</span>
                </>
              )}
            </button>
          </div>
        </div>

        {/* Spreadsheet component - solo renderizar cuando tengamos userId */}
        <div className="flex-1 min-h-0">
          {currentUser?.id ? (
            <TasksSpreadsheet userId={currentUser.id} onTasksChange={loadStats} />
          ) : (
            <div className="flex items-center justify-center py-12">
              <div className="text-sm text-slate-500">Cargando usuario...</div>
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}
