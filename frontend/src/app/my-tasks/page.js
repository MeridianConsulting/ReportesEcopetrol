// app/my-tasks/page.js
'use client';

import { useMemo, useState } from 'react';
import Layout, { useLayoutContext } from '../../components/Layout';
import ReportDistributionBoard from '../../components/ReportDistributionBoard';
import {
  CalendarDays,
  ClipboardList,
  Clock3,
  Search,
  UserCircle2,
  BarChart3,
} from 'lucide-react';

const STATUS_OPTIONS = [
  { value: 'all', label: 'Todos' },
  { value: 'draft', label: 'Sin distribuir' },
  { value: 'ready', label: 'Distribuido' },
  { value: 'alert', label: 'Con alerta' },
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

  const monthLabel = useMemo(
    () => formatMonthLabel(filters.reportDate),
    [filters.reportDate]
  );

  const reportDateLabel = useMemo(
    () => formatLongDate(filters.reportDate),
    [filters.reportDate]
  );

  return (
    <div className="min-h-full bg-slate-100/60">
      <div className="mx-auto max-w-7xl p-4 sm:p-6 lg:p-8 space-y-6">
        <section className="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm">
          <div className="bg-gradient-to-r from-slate-900 via-slate-800 to-slate-900 px-6 py-6 text-white sm:px-8">
            <div className="flex flex-col gap-6 lg:flex-row lg:items-end lg:justify-between">
              <div className="space-y-3">
                <div className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs font-medium text-slate-100 backdrop-blur">
                  <ClipboardList className="h-4 w-4" />
                  Reporte mensual de actividades
                </div>

                <div>
                  <h1 className="text-2xl font-semibold tracking-tight sm:text-3xl">
                    Mis reportes
                  </h1>
                  <p className="mt-2 max-w-3xl text-sm text-slate-300 sm:text-base">
                    El sistema carga automáticamente las actividades asignadas
                    desde la base de datos. El usuario solo distribuye los días
                    ejecutados del período y registra observaciones.
                  </p>
                </div>
              </div>

              <div className="grid gap-3 sm:grid-cols-2">
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

        <section className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm sm:p-5">
          <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3 flex-1">
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
                  className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
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
                  className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
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
                    className="w-full rounded-xl border border-slate-300 bg-white py-2.5 pl-9 pr-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
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
