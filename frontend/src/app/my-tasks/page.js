// app/my-tasks/page.js
'use client';

import { useEffect, useState, useCallback } from 'react';
import Layout from '../../components/Layout';
import ReportLinesSpreadsheet from '../../components/ReportLinesSpreadsheet';
import { apiRequest } from '../../lib/api';
import { Table2, Plus, Search } from 'lucide-react';

const STATUS_OPTIONS = [
  { value: 'all', label: 'Todos' },
  { value: 'draft', label: 'Borrador' },
  { value: 'ready', label: 'Listo' },
  { value: 'alert', label: 'Alerta' },
];

export default function MyTasksPage() {
  const [currentUser, setCurrentUser] = useState(null);
  const [filters, setFilters] = useState({
    reportDate: '',
    status: 'all',
    search: '',
  });
  const [createRequestId, setCreateRequestId] = useState(0);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const meData = await apiRequest('/auth/me');
        if (!cancelled) setCurrentUser(meData.data);
      } catch (e) {
        console.error('Error loading user:', e);
      }
    })();
    return () => { cancelled = true; };
  }, []);

  const handleNewLine = useCallback(() => {
    setCreateRequestId((prev) => prev + 1);
  }, []);

  return (
    <Layout>
      <div className="p-4 sm:p-6 w-full overflow-hidden max-w-full flex flex-col h-full">
        <div className="flex items-center gap-3 mb-5">
          <div className="w-10 h-10 bg-green-600 rounded-xl flex items-center justify-center shadow-sm">
            <Table2 className="w-5 h-5 text-white" strokeWidth={2} />
          </div>
          <div>
            <h1 className="text-xl font-semibold text-slate-900">Mis reportes</h1>
            <p className="text-slate-500 text-xs">Diligencie las líneas de reporte (fecha, actividades, avances). El ODS y el mes se asignan automáticamente según su perfil y la fecha de reporte.</p>
          </div>
        </div>

        {/* Barra de filtros + botón Nueva línea (Wireframe 1) */}
        <div className="flex flex-wrap items-center gap-3 mb-4 p-3 bg-slate-50 rounded-xl border border-slate-200">
          <label className="flex items-center gap-2 text-sm text-slate-600">
            <span>Fecha:</span>
            <input
              type="date"
              value={filters.reportDate}
              onChange={(e) => setFilters((f) => ({ ...f, reportDate: e.target.value }))}
              className="px-2 py-1.5 border border-slate-300 rounded-lg text-sm bg-white"
            />
          </label>
          <label className="flex items-center gap-2 text-sm text-slate-600">
            <span>Estado:</span>
            <select
              value={filters.status}
              onChange={(e) => setFilters((f) => ({ ...f, status: e.target.value }))}
              className="px-2 py-1.5 border border-slate-300 rounded-lg text-sm bg-white"
            >
              {STATUS_OPTIONS.map((opt) => (
                <option key={opt.value} value={opt.value}>
                  {opt.label}
                </option>
              ))}
            </select>
          </label>
          <label className="flex items-center gap-2 text-sm text-slate-600 flex-1 min-w-[180px]">
            <Search className="w-4 h-4 text-slate-400" />
            <input
              type="text"
              placeholder="Buscar (ítem, actividad, descripción…)"
              value={filters.search}
              onChange={(e) => setFilters((f) => ({ ...f, search: e.target.value }))}
              className="flex-1 px-2 py-1.5 border border-slate-300 rounded-lg text-sm bg-white placeholder:text-slate-400"
            />
          </label>
          <button
            onClick={handleNewLine}
            className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700"
          >
            <Plus className="w-4 h-4" strokeWidth={2.5} />
            Nueva línea
          </button>
        </div>

        <div className="flex-1 min-h-0">
          {currentUser?.id ? (
            <ReportLinesSpreadsheet
              userId={currentUser.id}
              reporterName={currentUser.name}
              onDataChange={() => {}}
              filters={filters}
              createRequestId={createRequestId}
              viewMode="compact"
              hideInternalToolbar
            />
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
