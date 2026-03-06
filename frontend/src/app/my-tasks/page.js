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

function normalizeReportLines(rows) {
  return (rows || []).map((row) => ({
    report_line_id: row.report_line_id,
    report_date: row.report_date || '',
    ods_code: row.ods_code || '',
    reporter_name: row.reporter_name || '',
    item_general: row.item_general || '',
    item_activity: row.item_activity || '',
    activity_description: row.activity_description || '',
    support_text: row.support_text || '',
    delivery_medium_id: row.delivery_medium_id || '',
    delivery_medium_name: row.delivery_medium_name || '',
    contracted_days: row.contracted_days ?? '',
    days_month: row.days_month ?? '',
    progress_percent: row.progress_percent ?? '',
    accumulated_days: row.accumulated_days ?? '',
    observations: row.observations || '',
  }));
}

function groupLinesByMonth(lines) {
  const map = new Map();
  for (const line of lines) {
    const sheetName = monthSheetFromDate(line.report_date);
    if (!sheetName) continue;
    if (!map.has(sheetName)) {
      map.set(sheetName, []);
    }
    map.get(sheetName).push(line);
  }
  return map;
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
      const params = new URLSearchParams({
        date_from: dateFrom,
        date_to: dateTo,
      });

      let rows;
      try {
        const response = await apiRequest(`/reports/lines?${params.toString()}`);
        rows = normalizeReportLines(response.data || []);
      } catch {
        const response = await apiRequest('/reports/my-lines');
        rows = normalizeReportLines(response.data || []).filter((row) => {
          const reportDate = row.report_date || '';
          return reportDate >= dateFrom && reportDate <= dateTo;
        });
      }

      if (!rows.length) {
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

      let deliveryMap = new Map();
      try {
        const mediaResponse = await apiRequest('/reports/delivery-media');
        (mediaResponse.data || []).forEach((item) => {
          deliveryMap.set(String(item.id), item.name);
        });
      } catch {
        deliveryMap = new Map();
      }

      const byMonth = groupLinesByMonth(rows);
      const MAX_ROWS = 19;
      const odsUnique = Array.from(
        new Set(rows.map((line) => (line.ods_code || '').trim()).filter(Boolean))
      );
      const odsValue = odsUnique.length ? odsUnique.join(' / ').slice(0, 80) : '';

      for (const [sheetName, monthLines] of byMonth.entries()) {
        const worksheet = workbook.getWorksheet(sheetName);
        if (!worksheet) continue;

        worksheet.getCell('D5').value = odsValue;
        worksheet.getCell('D7').value = currentUser.name || currentUser.email || '';
        worksheet.getCell('D9').value = sheetName;
        worksheet.getCell('D11').value = toDateOnly(filters.reportDate) || new Date();

        for (let index = 0; index < MAX_ROWS; index += 1) {
          const rowNumber = 15 + index;
          const line = monthLines[index];

          if (!line) {
            worksheet.getRow(rowNumber).getCell(2).value = null;
            worksheet.getRow(rowNumber).getCell(3).value = null;
            worksheet.getRow(rowNumber).getCell(4).value = null;
            worksheet.getRow(rowNumber).getCell(5).value = null;
            worksheet.getRow(rowNumber).getCell(6).value = null;
            worksheet.getRow(rowNumber).getCell(7).value = null;
            worksheet.getRow(rowNumber).getCell(8).value = null;
            worksheet.getRow(rowNumber).getCell(10).value = null;
            continue;
          }

          const deliveryName =
            (line.delivery_medium_name || '').trim() ||
            deliveryMap.get(String(line.delivery_medium_id)) ||
            'Digital';
          const contracted = line.contracted_days === '' || line.contracted_days === null
            ? null
            : Number(line.contracted_days);
          const daysMonth = line.days_month === '' || line.days_month === null
            ? null
            : Number(line.days_month);
          const accumulatedDays = line.accumulated_days === '' || line.accumulated_days === null
            ? null
            : Number(line.accumulated_days);

          worksheet.getRow(rowNumber).getCell(2).value = line.item_general || '';
          worksheet.getRow(rowNumber).getCell(3).value = line.item_activity || '';
          worksheet.getRow(rowNumber).getCell(4).value = line.activity_description || '';
          worksheet.getRow(rowNumber).getCell(5).value = line.support_text || '';
          worksheet.getRow(rowNumber).getCell(6).value = deliveryName;
          worksheet.getRow(rowNumber).getCell(7).value = Number.isFinite(contracted) ? contracted : null;
          worksheet.getRow(rowNumber).getCell(8).value = Number.isFinite(daysMonth) ? daysMonth : null;
          worksheet.getRow(rowNumber).getCell(10).value = Number.isFinite(accumulatedDays)
            ? accumulatedDays
            : null;
        }

        if (monthLines.length > MAX_ROWS) {
          setExportAlert({
            type: 'warning',
            message: `El template soporta ${MAX_ROWS} líneas por hoja. Se exportaron las primeras ${MAX_ROWS} del mes seleccionado.`,
          });
        }
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
    <div className="min-h-full bg-slate-100/60">
      <div className="mx-auto max-w-7xl space-y-6 p-4 sm:p-6 lg:p-8">
        <section className="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm">
          <div className="bg-gradient-to-r from-slate-900 via-slate-800 to-slate-900 px-5 py-6 text-white sm:px-8 sm:py-7">
            <div className="grid gap-5 xl:grid-cols-[minmax(0,1.6fr)_minmax(320px,0.9fr)] xl:items-end">
              <div className="space-y-4">
                <div className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs font-medium text-slate-100 backdrop-blur">
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
                  <div className="rounded-2xl border border-white/10 bg-white/10 px-4 py-3 backdrop-blur">
                    <div className="flex items-center gap-2 text-xs uppercase tracking-wide text-slate-300">
                      <CalendarDays className="h-4 w-4" />
                      Mes a reportar
                    </div>
                    <div className="mt-1 text-sm font-semibold text-white">
                      {monthLabel}
                    </div>
                  </div>

                  <div className="rounded-2xl border border-white/10 bg-white/10 px-4 py-3 backdrop-blur">
                    <div className="flex items-center gap-2 text-xs uppercase tracking-wide text-slate-300">
                      <UserCircle2 className="h-4 w-4" />
                      Profesional
                    </div>
                    <div className="mt-1 text-sm font-semibold text-white">
                      {currentUser?.name || 'Cargando...'}
                    </div>
                  </div>
                </div>

                <div className="rounded-2xl border border-emerald-400/20 bg-emerald-500/15 p-3.5 shadow-lg shadow-emerald-950/10 backdrop-blur">
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
                      className="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-emerald-500 px-4 py-3 text-sm font-semibold text-white shadow-lg shadow-emerald-950/20 transition hover:bg-emerald-400 disabled:cursor-not-allowed disabled:opacity-60 sm:w-auto xl:w-full"
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

          <div className="grid gap-4 border-t border-slate-200 p-4 sm:grid-cols-2 xl:grid-cols-4 sm:p-6">
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

        <section className="rounded-3xl border border-slate-200 bg-white p-4 shadow-sm sm:p-5">
          <div className="flex flex-col gap-5 xl:flex-row xl:items-end xl:justify-between">
            <div className="space-y-1">
              <h2 className="text-base font-semibold text-slate-900">
                Filtros del reporte
              </h2>
              <p className="text-sm text-slate-500">
                Ajusta la fecha, estado o búsqueda para trabajar más cómodo sobre tus actividades.
              </p>
            </div>

            <div className="grid flex-1 gap-4 sm:grid-cols-2 xl:max-w-4xl xl:grid-cols-[minmax(180px,0.9fr)_minmax(180px,0.9fr)_minmax(260px,1.2fr)]">
              <label className="space-y-2">
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
                  className="w-full rounded-2xl border border-slate-300 bg-slate-50 px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:bg-white focus:ring-2 focus:ring-slate-200"
                />
              </label>

              <label className="space-y-2">
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
                  className="w-full rounded-2xl border border-slate-300 bg-slate-50 px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:bg-white focus:ring-2 focus:ring-slate-200"
                >
                  {STATUS_OPTIONS.map((option) => (
                    <option key={option.value} value={option.value}>
                      {option.label}
                    </option>
                  ))}
                </select>
              </label>

              <label className="space-y-2">
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
                    className="w-full rounded-2xl border border-slate-300 bg-slate-50 py-2.5 pl-9 pr-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:bg-white focus:ring-2 focus:ring-slate-200"
                  />
                </div>
              </label>
            </div>
          </div>
        </section>

        <section className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
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
    <div className="rounded-2xl border border-slate-200 bg-slate-50/70 p-4">
      <div className="flex items-center gap-3">
        <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-white text-slate-700 shadow-sm ring-1 ring-slate-200">
          {icon}
        </div>
        <div className="min-w-0">
          <p className="text-xs font-medium uppercase tracking-wide text-slate-500">
            {label}
          </p>
          <p className="mt-1 text-2xl font-semibold tracking-tight text-slate-900">
            {value}
          </p>
          <p className="mt-1 text-xs text-slate-500">{helper}</p>
        </div>
      </div>
    </div>
  );
}
