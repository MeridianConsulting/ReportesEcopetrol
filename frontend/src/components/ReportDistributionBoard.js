'use client';

import { useEffect, useMemo, useState } from 'react';
import {
  AlertTriangle,
  CheckCircle2,
  Loader2,
  Save,
  FileText,
} from 'lucide-react';
import { apiRequest } from '../lib/api';

function formatMonthLabel(dateString) {
  if (!dateString) return '—';
  const date = new Date(`${dateString}T00:00:00`);
  return new Intl.DateTimeFormat('es-CO', {
    month: 'long',
    year: 'numeric',
  }).format(date);
}

function normalizeNumber(value) {
  const parsed = Math.floor(Number(value));
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
}

function getStatus(row) {
  if (row.accumulatedDays > row.contractedDays) return 'alert';
  if (row.reportDays > 0) return 'ready';
  return 'draft';
}

function getStatusBadge(status) {
  switch (status) {
    case 'ready':
      return 'bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200';
    case 'alert':
      return 'bg-amber-50 text-amber-700 ring-1 ring-amber-200';
    default:
      return 'bg-slate-100 text-slate-700 ring-1 ring-slate-200';
  }
}

export default function ReportDistributionBoard({
  userId,
  reporterName,
  reportDate,
  filters,
  onSummaryChange,
}) {
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const [meta, setMeta] = useState({
    serviceOrderCode: '',
    version: '01',
    formCode: 'GP-F-23',
    reportMonth: '',
  });

  const [rows, setRows] = useState([]);
  const [observations, setObservations] = useState('');
  const [professionalIssue, setProfessionalIssue] = useState({
    hasIssue: false,
    note: '',
  });
  const [leaderIssue, setLeaderIssue] = useState({
    hasIssue: false,
    note: '',
  });

  useEffect(() => {
    if (!userId || !reportDate) return;

    let cancelled = false;

    async function loadReportTemplate() {
      try {
        setLoading(true);
        setError('');

        const response = await apiRequest(
          `/reports/my-task-distribution?userId=${userId}&reportDate=${reportDate}`
        );

        const payload = response?.data || {};

        const tasks = Array.isArray(payload.tasks) ? payload.tasks : [];

        const mappedRows = tasks.map((task) => {
          const previousAccumulatedDays = Number(task.previousAccumulatedDays || 0);
          const reportDays = Number(task.reportDays || 0);
          const contractedDays = Number(task.contractedDays || 0);
          const accumulatedDays = previousAccumulatedDays + reportDays;

          return {
            taskId: task.id,
            generalItem: task.generalItem || '',
            activityItem: task.activityItem || '',
            description: task.description || '',
            support: task.support || '',
            deliveryMethod: task.deliveryMethod || 'Digital',
            contractedDays,
            previousAccumulatedDays,
            reportDays,
            accumulatedDays,
            status: getStatus({
              contractedDays,
              reportDays,
              accumulatedDays,
            }),
          };
        });

        if (!cancelled) {
          setMeta({
            serviceOrderCode: payload.serviceOrderCode || '',
            version: payload.version || '01',
            formCode: payload.formCode || 'GP-F-23',
            reportMonth: payload.reportMonth || formatMonthLabel(reportDate),
          });

          setRows(mappedRows);
          setObservations(payload.observations || '');
          setProfessionalIssue({
            hasIssue: Boolean(payload.professionalIssue?.hasIssue),
            note: payload.professionalIssue?.note || '',
          });
          setLeaderIssue({
            hasIssue: Boolean(payload.leaderIssue?.hasIssue),
            note: payload.leaderIssue?.note || '',
          });
        }
      } catch (err) {
        console.error(err);
        if (!cancelled) {
          setError('No fue posible cargar las actividades del reporte.');
          setRows([]);
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    loadReportTemplate();

    return () => {
      cancelled = true;
    };
  }, [userId, reportDate]);

  const filteredRows = useMemo(() => {
    const query = (filters?.search || '').trim().toLowerCase();
    const statusFilter = filters?.status || 'all';

    return rows.filter((row) => {
      const matchesSearch =
        !query ||
        row.generalItem.toLowerCase().includes(query) ||
        row.activityItem.toLowerCase().includes(query) ||
        row.description.toLowerCase().includes(query) ||
        row.support.toLowerCase().includes(query) ||
        row.deliveryMethod.toLowerCase().includes(query);

      const matchesStatus =
        statusFilter === 'all' ? true : row.status === statusFilter;

      return matchesSearch && matchesStatus;
    });
  }, [rows, filters]);

  const summary = useMemo(() => {
    const totalTasks = rows.length;
    const contractedDays = rows.reduce(
      (acc, row) => acc + Number(row.contractedDays || 0),
      0
    );
    const distributedDays = rows.reduce(
      (acc, row) => acc + Number(row.reportDays || 0),
      0
    );
    const accumulatedDays = rows.reduce(
      (acc, row) => acc + Number(row.accumulatedDays || 0),
      0
    );
    const progress =
      contractedDays > 0 ? (accumulatedDays / contractedDays) * 100 : 0;

    return {
      totalTasks,
      contractedDays,
      distributedDays,
      accumulatedDays,
      progress,
    };
  }, [rows]);

  useEffect(() => {
    onSummaryChange?.(summary);
  }, [summary, onSummaryChange]);

  function handleReportDaysChange(taskId, rawValue) {
    setRows((currentRows) =>
      currentRows.map((row) => {
        if (row.taskId !== taskId) return row;

        const requestedDays = normalizeNumber(rawValue);
        const maxAssignable = Math.max(
          row.contractedDays - row.previousAccumulatedDays,
          0
        );
        const reportDays = Math.min(requestedDays, maxAssignable);
        const accumulatedDays = row.previousAccumulatedDays + reportDays;

        return {
          ...row,
          reportDays,
          accumulatedDays,
          status: getStatus({
            ...row,
            reportDays,
            accumulatedDays,
          }),
        };
      })
    );
  }

  async function handleSave() {
    try {
      setSaving(true);
      setError('');

      const payload = {
        userId,
        reportDate,
        observations,
        professionalIssue,
        leaderIssue,
        lines: rows.map((row) => ({
          taskId: row.taskId,
          reportDays: row.reportDays,
        })),
      };

      await apiRequest('/reports/my-task-distribution/save', {
        method: 'POST',
        body: JSON.stringify(payload),
      });
    } catch (err) {
      console.error(err);
      setError('No fue posible guardar la distribución del reporte.');
    } finally {
      setSaving(false);
    }
  }

  if (loading) {
    return (
      <div className="flex min-h-[520px] items-center justify-center bg-[radial-gradient(circle_at_top,_rgba(16,185,129,0.08),_transparent_35%)] p-6">
        <div className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-5 py-4 text-sm text-slate-600 shadow-sm">
          <Loader2 className="h-4 w-4 animate-spin text-emerald-600" />
          Cargando actividades del reporte...
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6 p-4 sm:p-6">
      <section className="grid gap-4 rounded-[28px] border border-slate-200 bg-gradient-to-br from-slate-50 to-white p-4 shadow-sm md:grid-cols-2 xl:grid-cols-4">
        <InfoBox label="Código orden de servicio" value={meta.serviceOrderCode || '—'} />
        <InfoBox label="Nombre del profesional" value={reporterName || '—'} />
        <InfoBox label="Mes a reportar" value={meta.reportMonth || '—'} />
        <InfoBox label="Fecha de reporte" value={reportDate || '—'} />
      </section>

      {error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-700 shadow-sm">
          {error}
        </div>
      ) : null}

      <section className="overflow-hidden rounded-[28px] border border-slate-200 bg-white shadow-[0_18px_50px_-30px_rgba(15,23,42,0.3)]">
        <div className="flex flex-col gap-4 border-b border-slate-200 bg-gradient-to-r from-white to-slate-50 px-4 py-5 sm:px-5 lg:flex-row lg:items-center lg:justify-between">
          <div className="max-w-2xl">
            <div className="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-semibold uppercase tracking-wide text-slate-500 shadow-sm">
              <FileText className="h-3.5 w-3.5" />
              Distribución
            </div>
            <h2 className="text-base font-semibold text-slate-900">
              Distribución mensual por actividad
            </h2>
            <p className="mt-1 text-sm text-slate-500">
              Las actividades provienen de la base de datos. Solo se puede editar
              la columna de días del mes.
            </p>
          </div>

          <button
            type="button"
            onClick={handleSave}
            disabled={saving}
            className="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-emerald-600 px-4 py-3 text-sm font-semibold text-white shadow-lg shadow-emerald-950/15 transition hover:bg-emerald-500 disabled:cursor-not-allowed disabled:opacity-60 sm:w-auto"
          >
            {saving ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <Save className="h-4 w-4" />
            )}
            Guardar distribución
          </button>
        </div>

        <div className="border-t border-slate-200 bg-slate-50/80 px-4 py-3 text-xs font-medium text-slate-500 sm:px-5">
          Desliza horizontalmente si necesitas ver todas las columnas.
        </div>

        <div className="overflow-x-auto bg-white">
          <table className="min-w-[1360px] w-full table-fixed text-sm">
            <thead className="bg-slate-100 text-slate-700">
              <tr>
                <th className="w-[140px] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Ítem general
                </th>
                <th className="w-[140px] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Ítem actividad
                </th>
                <th className="w-[310px] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Descripción
                </th>
                <th className="w-[250px] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Soporte
                </th>
                <th className="w-[150px] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Medio entrega
                </th>
                <th className="w-[120px] px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Días contratados
                </th>
                <th className="w-[130px] px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Acumulado previo
                </th>
                <th className="w-[140px] px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Días del mes
                </th>
                <th className="w-[120px] px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Acumulado
                </th>
                <th className="w-[150px] px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-600">
                  % avance
                </th>
                <th className="w-[120px] px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-600">
                  Estado
                </th>
              </tr>
            </thead>

            <tbody className="bg-white">
              {filteredRows.length === 0 ? (
                <tr>
                  <td
                    colSpan={11}
                    className="px-4 py-10 text-center text-sm text-slate-500"
                  >
                    No hay actividades para mostrar con los filtros actuales.
                  </td>
                </tr>
              ) : (
                filteredRows.map((row) => {
                  const progress =
                    row.contractedDays > 0
                      ? (row.accumulatedDays / row.contractedDays) * 100
                      : 0;

                  const remainingDays = Math.max(
                    row.contractedDays - row.previousAccumulatedDays,
                    0
                  );

                  return (
                    <tr
                      key={row.taskId}
                      className="border-t border-slate-200 align-top odd:bg-white even:bg-slate-50/40 hover:bg-emerald-50/40"
                    >
                      <td className="px-4 py-4 align-top">
                        <div className="inline-flex rounded-xl border border-slate-200 bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-700">
                          {row.generalItem || '—'}
                        </div>
                      </td>
                      <td className="px-4 py-4 align-top">
                        <div className="inline-flex rounded-xl border border-slate-200 bg-white px-3 py-1.5 text-xs font-semibold text-slate-700 shadow-sm">
                          {row.activityItem || '—'}
                        </div>
                      </td>
                      <td className="px-4 py-4 align-top text-slate-900">
                        <div className="max-w-[310px] whitespace-normal break-words leading-6">
                          {row.description || '—'}
                        </div>
                      </td>
                      <td className="px-4 py-4 align-top text-slate-700">
                        <div className="max-w-[250px] whitespace-normal break-words leading-6">
                          {row.support || '—'}
                        </div>
                      </td>
                      <td className="px-4 py-4 align-top">
                        <span className="inline-flex rounded-full border border-emerald-200 bg-emerald-50 px-3 py-1 text-xs font-medium text-emerald-700">
                          {row.deliveryMethod || 'Digital'}
                        </span>
                      </td>
                      <td className="px-4 py-4 text-center font-semibold tabular-nums text-slate-900">
                        {row.contractedDays}
                      </td>
                      <td className="px-4 py-4 text-center font-medium tabular-nums text-slate-700">
                        {row.previousAccumulatedDays}
                      </td>
                      <td className="px-4 py-4 text-center">
                        <div className="mx-auto max-w-[124px]">
                          <input
                            type="number"
                            min="0"
                            max={remainingDays}
                            step="1"
                            value={row.reportDays}
                            onChange={(e) =>
                              handleReportDaysChange(row.taskId, e.target.value)
                            }
                            className="w-full rounded-2xl border border-slate-300 bg-slate-50 px-3 py-2.5 text-center font-semibold tabular-nums text-slate-900 outline-none transition focus:border-emerald-500 focus:bg-white focus:ring-2 focus:ring-emerald-100"
                          />
                          <div className="mt-1 text-[11px] font-medium text-slate-500">
                            Máx. {remainingDays}
                          </div>
                        </div>
                      </td>
                      <td className="px-4 py-4 text-center font-semibold tabular-nums text-slate-900">
                        {row.accumulatedDays}
                      </td>
                      <td className="px-4 py-4 text-center">
                        <div className="mx-auto max-w-[110px]">
                          <div className="h-2 overflow-hidden rounded-full bg-slate-200">
                            <div
                              className={`h-full rounded-full ${
                                row.status === 'alert'
                                  ? 'bg-amber-500'
                                  : row.status === 'ready'
                                  ? 'bg-emerald-500'
                                  : 'bg-slate-400'
                              }`}
                              style={{ width: `${Math.min(progress, 100)}%` }}
                            />
                          </div>
                          <div className="mt-2 font-semibold tabular-nums text-slate-900">
                            {progress.toFixed(1)}%
                          </div>
                        </div>
                      </td>
                      <td className="px-4 py-4 text-center">
                        <span
                          className={`inline-flex rounded-full px-2.5 py-1 text-xs font-medium ${getStatusBadge(
                            row.status
                          )}`}
                        >
                          {row.status === 'ready'
                            ? 'Distribuido'
                            : row.status === 'alert'
                            ? 'Alerta'
                            : 'Pendiente'}
                        </span>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>

            <tfoot className="bg-slate-100 font-semibold text-slate-900">
              <tr className="border-t border-slate-200">
                <td colSpan={5} className="px-4 py-4 text-right text-sm uppercase tracking-wide text-slate-600">
                  Totales
                </td>
                <td className="px-4 py-4 text-center tabular-nums">{summary.contractedDays}</td>
                <td className="px-4 py-4 text-center tabular-nums">
                  {rows.reduce(
                    (acc, row) => acc + Number(row.previousAccumulatedDays || 0),
                    0
                  )}
                </td>
                <td className="px-4 py-4 text-center tabular-nums">{summary.distributedDays}</td>
                <td className="px-4 py-4 text-center tabular-nums">{summary.accumulatedDays}</td>
                <td className="px-4 py-4 text-center tabular-nums">
                  {summary.progress.toFixed(1)}%
                </td>
                <td className="px-4 py-4 text-center">—</td>
              </tr>
            </tfoot>
          </table>
        </div>
      </section>

      <section className="grid gap-6 xl:grid-cols-2">
        <div className="rounded-[28px] border border-slate-200 bg-white p-5 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.22)]">
          <div className="mb-4 flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-2xl bg-emerald-50 text-emerald-700 ring-1 ring-emerald-100">
              <FileText className="h-5 w-5" />
            </div>
            <div>
              <h3 className="text-base font-semibold text-slate-900">Observaciones</h3>
              <p className="text-sm text-slate-500">
                Registra aquí comentarios generales del reporte del período.
              </p>
            </div>
          </div>

          <textarea
            value={observations}
            onChange={(e) => setObservations(e.target.value)}
            rows={8}
            placeholder="Registre aquí observaciones generales del reporte..."
            className="w-full rounded-3xl border border-slate-300 bg-slate-50 px-4 py-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:bg-white focus:ring-2 focus:ring-emerald-100"
          />
        </div>

        <div className="space-y-4">
          <IssueBlock
            title="Novedades reportadas por el profesional"
            state={professionalIssue}
            setState={setProfessionalIssue}
          />

          <IssueBlock
            title="Novedades reportadas por interventor o líder"
            state={leaderIssue}
            setState={setLeaderIssue}
          />
        </div>
      </section>
    </div>
  );
}

function InfoBox({ label, value }) {
  return (
    <div className="rounded-3xl border border-slate-200 bg-white px-4 py-3 shadow-sm shadow-slate-200/60 transition-transform duration-200 hover:-translate-y-0.5">
      <p className="text-xs font-medium uppercase tracking-wide text-slate-500">
        {label}
      </p>
      <p className="mt-1 text-sm font-semibold leading-6 text-slate-900">{value}</p>
    </div>
  );
}

function IssueBlock({ title, state, setState }) {
  return (
    <div className="rounded-[28px] border border-slate-200 bg-white p-5 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.22)]">
      <div className="mb-4 flex items-start gap-3">
        <div className="mt-0.5">
          {state.hasIssue ? (
            <AlertTriangle className="h-5 w-5 text-amber-500" />
          ) : (
            <CheckCircle2 className="h-5 w-5 text-emerald-500" />
          )}
        </div>
        <div>
          <h3 className="text-base font-semibold text-slate-900">{title}</h3>
          <p className="mt-1 text-sm text-slate-500">
            Indique si se presentó alguna situación que afecte la ejecución o la
            calidad de los entregables.
          </p>
        </div>
      </div>

      <div className="mb-4 inline-flex rounded-2xl border border-slate-200 bg-slate-50 p-1">
        <button
          type="button"
          onClick={() => setState((prev) => ({ ...prev, hasIssue: true }))}
          className={`rounded-xl px-4 py-2 text-sm font-medium transition ${
            state.hasIssue
              ? 'bg-amber-100 text-amber-800 ring-1 ring-amber-300 shadow-sm'
              : 'text-slate-700 hover:bg-slate-200'
          }`}
        >
          Sí
        </button>

        <button
          type="button"
          onClick={() =>
            setState((prev) => ({
              ...prev,
              hasIssue: false,
              note: prev.note,
            }))
          }
          className={`rounded-xl px-4 py-2 text-sm font-medium transition ${
            !state.hasIssue
              ? 'bg-emerald-100 text-emerald-800 ring-1 ring-emerald-300 shadow-sm'
              : 'text-slate-700 hover:bg-slate-200'
          }`}
        >
          No
        </button>
      </div>

      <textarea
        value={state.note}
        onChange={(e) =>
          setState((prev) => ({
            ...prev,
            note: e.target.value,
          }))
        }
        rows={4}
        placeholder="Describa aquí la observación o novedad..."
        className="w-full rounded-3xl border border-slate-300 bg-slate-50 px-4 py-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:bg-white focus:ring-2 focus:ring-emerald-100"
      />
    </div>
  );
}
