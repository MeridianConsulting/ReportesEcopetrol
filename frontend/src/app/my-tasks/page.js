// app/my-tasks/page.js
'use client';

import { useCallback, useMemo, useState } from 'react';
import Layout, { useLayoutContext } from '../../components/Layout';
import Alert from '../../components/Alert';
import ReportDistributionBoard from '../../components/ReportDistributionBoard';
import { apiRequest } from '../../lib/api';
import {
  CalendarDays,
  ClipboardList,
  Clock3,
  Search,
  UserCircle2,
  BarChart3,
  Download,
  Loader2,
} from 'lucide-react';

const STATUS_OPTIONS = [
  { value: 'all', label: 'Todos' },
  { value: 'draft', label: 'Sin distribuir' },
  { value: 'ready', label: 'Distribuido' },
  { value: 'alert', label: 'Con alerta' },
];

const MONTH_SHEETS = [
  'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
  'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE',
];

function getToday() {
  return new Date().toISOString().slice(0, 10);
}

function formatMonthLabel(dateString) {
  if (!dateString) return '—';
  const date = new Date(`${dateString}T00:00:00`);
  return new Intl.DateTimeFormat('es-CO', {
    month: 'long',
    year: 'numeric',
  }).format(date);
}

function formatLongDate(dateString) {
  if (!dateString) return '—';
  const date = new Date(`${dateString}T00:00:00`);
  return new Intl.DateTimeFormat('es-CO', {
    dateStyle: 'long',
  }).format(date);
}

function safeFilePart(value) {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-zA-Z0-9-_]+/g, '_')
    .replace(/_+/g, '_')
    .slice(0, 80);
}

function toDateOnly(dateStr) {
  if (!dateStr) return null;
  const date = new Date(`${dateStr}T00:00:00`);
  return Number.isNaN(date.getTime()) ? null : date;
}

function monthSheetFromDate(dateStr) {
  const date = toDateOnly(dateStr);
  if (!date) return null;
  return MONTH_SHEETS[date.getMonth()];
}

function clearWorksheetDataRow(worksheet, rowNumber) {
  worksheet.getRow(rowNumber).getCell(2).value = null;
  worksheet.getRow(rowNumber).getCell(3).value = null;
  worksheet.getRow(rowNumber).getCell(4).value = null;
  worksheet.getRow(rowNumber).getCell(5).value = null;
  worksheet.getRow(rowNumber).getCell(6).value = null;
  worksheet.getRow(rowNumber).getCell(7).value = null;
  worksheet.getRow(rowNumber).getCell(8).value = null;
  worksheet.getRow(rowNumber).getCell(10).value = null;
}

function fillIssueBlock(worksheet, config, issue) {
  const note = String(issue?.note || '').trim();
  const hasIssue = Boolean(issue?.hasIssue);

  worksheet.getCell(config.yesCell).value = hasIssue ? 'X' : '';
  worksheet.getCell(config.noCell).value = hasIssue ? '' : 'X';
  worksheet.getCell(config.noteCell).value = note;
}

function getMonthRange(dateString) {
  const date = toDateOnly(dateString) || new Date();
  const year = date.getFullYear();
  const month = date.getMonth();
  const start = new Date(year, month, 1);
  const end = new Date(year, month + 1, 0);

  const format = (value) =>
    `${value.getFullYear()}-${String(value.getMonth() + 1).padStart(2, '0')}-${String(
      value.getDate()
    ).padStart(2, '0')}`;

  return {
    dateFrom: format(start),
    dateTo: format(end),
  };
}

export default function MyTasksPage() {
  return (
    <Layout>
      <MyTasksContent />
    </Layout>
  );
}

function MyTasksContent() {
  const { user: currentUser, isBootstrapping } = useLayoutContext();
  const [filters, setFilters] = useState({
    reportDate: getToday(),
    status: 'all',
    search: '',
  });

  const [summary, setSummary] = useState({
    totalTasks: 0,
    contractedDays: 0,
    distributedDays: 0,
    accumulatedDays: 0,
    progress: 0,
  });
  const [exportingMonth, setExportingMonth] = useState(false);
  const [exportAlert, setExportAlert] = useState(null);

  const monthLabel = useMemo(
    () => formatMonthLabel(filters.reportDate),
    [filters.reportDate]
  );

  const reportDateLabel = useMemo(
    () => formatLongDate(filters.reportDate),
    [filters.reportDate]
  );

  const handleDownloadMonthlyReport = useCallback(async () => {
    if (!currentUser?.id) return;

    try {
      setExportingMonth(true);
      setExportAlert(null);

      const { dateFrom, dateTo } = getMonthRange(filters.reportDate);
      const response = await apiRequest(
        `/reports/my-task-distribution?userId=${currentUser.id}&reportDate=${filters.reportDate}`
      );
      const payload = response?.data || {};
      const tasks = Array.isArray(payload.tasks) ? payload.tasks : [];

      if (!tasks.length) {
        setExportAlert({
          type: 'warning',
          message: 'No hay líneas de reporte registradas para el mes seleccionado.',
        });
        return;
      }

      const ExcelJS = (await import('exceljs')).default;
      const { saveAs } = await import('file-saver');

      const templateResponse = await fetch('/templates/GP-F-23_Base_Individual.xlsx');
      if (!templateResponse.ok) {
        setExportAlert({
          type: 'error',
          message: 'No se encontró la plantilla GP-F-23_Base_Individual.xlsx en /public/templates.',
        });
        return;
      }

      const workbook = new ExcelJS.Workbook();
      await workbook.xlsx.load(await templateResponse.arrayBuffer());
      const MAX_ROWS = 19;
      const sheetName = monthSheetFromDate(filters.reportDate);
      const worksheet = sheetName ? workbook.getWorksheet(sheetName) : null;

      if (!worksheet) {
        setExportAlert({
          type: 'error',
          message: 'No fue posible ubicar la hoja del mes seleccionado en la plantilla.',
        });
        return;
      }

      worksheet.getCell('D5').value = String(payload.serviceOrderCode || '').slice(0, 80);
      worksheet.getCell('D7').value = currentUser.name || currentUser.email || '';
      worksheet.getCell('D9').value = sheetName;
      worksheet.getCell('D11').value = toDateOnly(filters.reportDate) || new Date();
      worksheet.getCell('D37').value = String(payload.observations || '').trim();

      fillIssueBlock(worksheet, {
        yesCell: 'C41',
        noCell: 'C42',
        noteCell: 'D41',
      }, payload.professionalIssue);
      fillIssueBlock(worksheet, {
        yesCell: 'C46',
        noCell: 'C47',
        noteCell: 'D46',
      }, payload.leaderIssue);

      for (let index = 0; index < MAX_ROWS; index += 1) {
        const rowNumber = 15 + index;
        const task = tasks[index];

        if (!task) {
          clearWorksheetDataRow(worksheet, rowNumber);
          continue;
        }

        const contracted = task.contractedDays === '' || task.contractedDays === null
          ? null
          : Number(task.contractedDays);
        const daysMonth = task.reportDays === '' || task.reportDays === null
          ? null
          : Number(task.reportDays);
        const previousAccumulatedDays =
          task.previousAccumulatedDays === '' || task.previousAccumulatedDays === null
            ? 0
            : Number(task.previousAccumulatedDays);
        const accumulatedDaysValue = previousAccumulatedDays + (Number.isFinite(daysMonth) ? daysMonth : 0);

        worksheet.getRow(rowNumber).getCell(2).value = task.generalItem || '';
        worksheet.getRow(rowNumber).getCell(3).value = task.activityItem || '';
        worksheet.getRow(rowNumber).getCell(4).value = task.description || '';
        worksheet.getRow(rowNumber).getCell(5).value = task.support || '';
        worksheet.getRow(rowNumber).getCell(6).value = task.deliveryMethod || 'Digital';
        worksheet.getRow(rowNumber).getCell(7).value = Number.isFinite(contracted) ? contracted : null;
        worksheet.getRow(rowNumber).getCell(8).value = Number.isFinite(daysMonth) ? daysMonth : null;
        worksheet.getRow(rowNumber).getCell(10).value = Number.isFinite(accumulatedDaysValue)
          ? accumulatedDaysValue
          : null;
      }

      if (tasks.length > MAX_ROWS) {
        setExportAlert({
          type: 'warning',
          message: `El template soporta ${MAX_ROWS} líneas por hoja. Se exportaron las primeras ${MAX_ROWS} del mes seleccionado.`,
        });
      }

      const buffer = await workbook.xlsx.writeBuffer();
      const blob = new Blob([buffer], {
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      });
      const fileName = `GP-F-23_${safeFilePart(
        currentUser.name || currentUser.email
      )}_${dateFrom}_${dateTo}.xlsx`;

      saveAs(blob, fileName);

      setExportAlert((prev) =>
        prev?.type === 'warning'
          ? prev
          : {
              type: 'success',
              message: 'El consolidado del mes se descargó correctamente.',
            }
      );
    } catch (error) {
      setExportAlert({
        type: 'error',
        message: error?.message || 'No fue posible generar el consolidado del mes.',
      });
    } finally {
      setExportingMonth(false);
    }
  }, [currentUser, filters.reportDate]);

  return (
    <div className="min-h-full bg-[radial-gradient(circle_at_top,_rgba(16,185,129,0.08),_transparent_28%),linear-gradient(to_bottom,_#f8fafc,_#eef2f7)]">
      <div className="mx-auto max-w-7xl space-y-6 p-4 sm:p-6 lg:p-8">
        <section className="overflow-hidden rounded-[28px] border border-slate-200/80 bg-white/95 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.35)] backdrop-blur">
          <div className="bg-gradient-to-r from-slate-900 via-slate-800 to-slate-900 px-5 py-6 text-white sm:px-8 sm:py-7">
            <div className="grid gap-5 xl:grid-cols-[minmax(0,1.6fr)_minmax(320px,0.9fr)] xl:items-end">
              <div className="space-y-4">
                <div className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs font-medium text-slate-100 shadow-lg shadow-slate-950/10 backdrop-blur">
                  <ClipboardList className="h-4 w-4" />
                  Reporte mensual de actividades
                </div>

                <div>
                  <h1 className="text-2xl font-semibold tracking-tight sm:text-3xl lg:text-[2rem]">
                    Mis reportes
                  </h1>
                  <p className="mt-2 max-w-3xl text-sm leading-6 text-slate-300 sm:text-base">
                    El sistema carga automáticamente las actividades asignadas
                    desde la base de datos. El usuario solo distribuye los días
                    ejecutados del período y registra observaciones.
                  </p>
                </div>
              </div>

              <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-1">
                <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-1">
                  <div className="rounded-2xl border border-white/10 bg-white/10 px-4 py-3 shadow-lg shadow-slate-950/10 backdrop-blur">
                    <div className="flex items-center gap-2 text-xs uppercase tracking-wide text-slate-300">
                      <CalendarDays className="h-4 w-4" />
                      Mes a reportar
                    </div>
                    <div className="mt-1 text-sm font-semibold text-white">
                      {monthLabel}
                    </div>
                  </div>

                  <div className="rounded-2xl border border-white/10 bg-white/10 px-4 py-3 shadow-lg shadow-slate-950/10 backdrop-blur">
                    <div className="flex items-center gap-2 text-xs uppercase tracking-wide text-slate-300">
                      <UserCircle2 className="h-4 w-4" />
                      Profesional
                    </div>
                    <div className="mt-1 text-sm font-semibold text-white">
                      {currentUser?.name || 'Cargando...'}
                    </div>
                  </div>
                </div>

                <div className="rounded-2xl border border-emerald-400/20 bg-gradient-to-br from-emerald-400/20 to-emerald-500/10 p-3.5 shadow-lg shadow-emerald-950/10 backdrop-blur">
                  <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between xl:flex-col xl:items-stretch">
                    <div className="space-y-1">
                      <p className="text-xs font-semibold uppercase tracking-[0.16em] text-emerald-100/90">
                        Consolidado del mes
                      </p>
                      <p className="text-sm text-emerald-50/90">
                        Descarga tu consolidado individual del mes seleccionado.
                      </p>
                    </div>

                    <button
                      type="button"
                      onClick={handleDownloadMonthlyReport}
                      disabled={isBootstrapping || !currentUser?.id || exportingMonth}
                      className="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-emerald-500 px-4 py-3 text-sm font-semibold text-white shadow-lg shadow-emerald-950/20 transition hover:bg-emerald-400 hover:shadow-xl disabled:cursor-not-allowed disabled:opacity-60 sm:w-auto xl:w-full"
                    >
                      {exportingMonth ? (
                        <Loader2 className="h-4 w-4 animate-spin" />
                      ) : (
                        <Download className="h-4 w-4" />
                      )}
                      {exportingMonth ? 'Generando consolidado...' : 'Descargar consolidado'}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="grid gap-4 border-t border-slate-200/80 bg-gradient-to-b from-white to-slate-50/60 p-4 sm:grid-cols-2 xl:grid-cols-4 sm:p-6">
            <StatCard
              icon={<ClipboardList className="h-5 w-5" />}
              label="Actividades asignadas"
              value={summary.totalTasks}
              helper="Cargadas automáticamente"
            />
            <StatCard
              icon={<Clock3 className="h-5 w-5" />}
              label="Días contratados"
              value={summary.contractedDays}
              helper="Total del período"
            />
            <StatCard
              icon={<BarChart3 className="h-5 w-5" />}
              label="Días distribuidos"
              value={summary.distributedDays}
              helper={`Fecha de reporte: ${reportDateLabel}`}
            />
            <StatCard
              icon={<BarChart3 className="h-5 w-5" />}
              label="Avance acumulado"
              value={`${summary.progress.toFixed(1)}%`}
              helper={`${summary.accumulatedDays} días acumulados`}
            />
          </div>
        </section>

        {exportAlert ? (
          <Alert
            type={exportAlert.type}
            dismissible
            onDismiss={() => setExportAlert(null)}
          >
            {exportAlert.message}
          </Alert>
        ) : null}

        <section className="rounded-[28px] border border-slate-200/80 bg-white/95 p-4 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.28)] backdrop-blur sm:p-5">
          <div className="flex flex-col gap-5 xl:flex-row xl:items-end xl:justify-between">
            <div className="space-y-1">
              <div className="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-xs font-semibold uppercase tracking-wide text-slate-500">
                <Search className="h-3.5 w-3.5" />
                Filtros
              </div>
              <h2 className="pt-1 text-base font-semibold text-slate-900">
                Filtros del reporte
              </h2>
              <p className="text-sm text-slate-500">
                Ajusta la fecha, estado o búsqueda para trabajar más cómodo sobre tus actividades.
              </p>
            </div>

            <div className="grid flex-1 gap-4 sm:grid-cols-2 xl:max-w-4xl xl:grid-cols-[minmax(180px,0.9fr)_minmax(180px,0.9fr)_minmax(260px,1.2fr)]">
              <label className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                <span className="text-sm font-medium text-slate-700">
                  Fecha de reporte
                </span>
                <input
                  type="date"
                  value={filters.reportDate}
                  onChange={(e) =>
                    setFilters((prev) => ({
                      ...prev,
                      reportDate: e.target.value,
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                />
              </label>

              <label className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                <span className="text-sm font-medium text-slate-700">
                  Estado
                </span>
                <select
                  value={filters.status}
                  onChange={(e) =>
                    setFilters((prev) => ({
                      ...prev,
                      status: e.target.value,
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                >
                  {STATUS_OPTIONS.map((option) => (
                    <option key={option.value} value={option.value}>
                      {option.label}
                    </option>
                  ))}
                </select>
              </label>

              <label className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/70 p-3">
                <span className="text-sm font-medium text-slate-700">
                  Buscar actividad
                </span>
                <div className="relative">
                  <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                  <input
                    type="text"
                    placeholder="Ítem, descripción, soporte..."
                    value={filters.search}
                    onChange={(e) =>
                      setFilters((prev) => ({
                        ...prev,
                        search: e.target.value,
                      }))
                    }
                    className="w-full rounded-2xl border border-slate-300 bg-white py-2.5 pl-9 pr-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                  />
                </div>
              </label>
            </div>
          </div>
        </section>

        <section className="overflow-hidden rounded-[28px] border border-slate-200/80 bg-white/95 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.28)] backdrop-blur">
          {isBootstrapping ? (
            <div className="flex items-center justify-center py-20">
              <div className="text-sm text-slate-500">Cargando usuario...</div>
            </div>
          ) : currentUser?.id ? (
            <ReportDistributionBoard
              userId={currentUser.id}
              reporterName={currentUser.name}
              reportDate={filters.reportDate}
              filters={{
                status: filters.status,
                search: filters.search,
              }}
              onSummaryChange={setSummary}
            />
          ) : (
            <div className="flex items-center justify-center py-20">
              <div className="text-sm text-rose-600">
                No fue posible cargar el usuario actual.
              </div>
            </div>
          )}
        </section>
      </div>
    </div>
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
          <p className="text-xs font-medium uppercase tracking-wide text-slate-500">
            {label}
          </p>
          <p className="mt-1 text-2xl font-semibold tracking-tight text-slate-900 tabular-nums">
            {value}
          </p>
          <p className="mt-1 text-xs text-slate-500">{helper}</p>
        </div>
      </div>
    </div>
  );
}
