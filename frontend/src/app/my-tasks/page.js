// app/my-tasks/page.js
'use client';

import { useEffect, useState } from 'react';
import Layout from '../../components/Layout';
import ReportLinesSpreadsheet from '../../components/ReportLinesSpreadsheet';
import { apiRequest } from '../../lib/api';
import { Table2 } from 'lucide-react';

export default function MyTasksPage() {
  const [currentUser, setCurrentUser] = useState(null);

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

        <div className="flex-1 min-h-0">
          {currentUser?.id ? (
            <ReportLinesSpreadsheet
              userId={currentUser.id}
              reporterName={currentUser.name}
              onDataChange={() => {}}
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
