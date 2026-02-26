// app/reports/download/page.js
'use client';

import { useEffect, useState, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import Layout from '../../../components/Layout';
import DateRangeFilter from '../../../components/DateRangeFilter';
import { apiRequest } from '../../../lib/api';
import { FileDown, Loader2, FileText, FileSpreadsheet } from 'lucide-react';

export default function ReportsDownload() {
  const router = useRouter();
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [generatingExcel, setGeneratingExcel] = useState(false);
  const [users, setUsers] = useState([]);
  const today = new Date().toISOString().split('T')[0];
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);
  const [currentPeriod, setCurrentPeriod] = useState('today');
  const [selectedProfessionalId, setSelectedProfessionalId] = useState('');
  const [exportAlert, setExportAlert] = useState(null);


  useEffect(() => {
    async function loadUser() {
      try {
        const data = await apiRequest('/auth/me');
        if (!['admin', 'lider_area'].includes(data.data.role)) {
          router.push('/my-tasks/');
          return;
        }
        setUser(data.data);
      } catch (e) {
        router.push('/login/');
      }
    }
    loadUser();
  }, [router]);

  const loadData = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    try {
      if (user.role === 'admin') {
        const usersData = await apiRequest('/users');
        setUsers(usersData.data || []);
      } else {
        setUsers(user ? [user] : []);
      }
    } catch (e) {
      if (user?.role === 'lider_area') setUsers(user ? [user] : []);
    } finally {
      setLoading(false);
    }
  }, [user]);

  useEffect(() => {
    if (user) loadData();
  }, [user, loadData]);

  useEffect(() => {
    if (user?.role === 'lider_area' && user?.id && !selectedProfessionalId) {
      setSelectedProfessionalId(String(user.id));
    }
  }, [user?.id, user?.role, selectedProfessionalId]);

  const handleDateChange = (from, to, period) => {
    setDateFrom(from || '');
    setDateTo(to || '');
    setCurrentPeriod(period);
    setShowPreview(false);
  };

  // --- Helpers y generador GP-F-23 (template corporativo) ---
  const MONTH_SHEETS = [
    'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
    'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'
  ];

  function safeFilePart(s) {
    return String(s || '')
      .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
      .replace(/[^a-zA-Z0-9-_]+/g, '_')
      .replace(/_+/g, '_')
      .slice(0, 80);
  }

  function toDateOnly(dateStr) {
    if (!dateStr) return null;
    const d = new Date(`${dateStr}T00:00:00`);
    return isNaN(d.getTime()) ? null : d;
  }

  function monthSheetFromDate(dateStr) {
    const d = toDateOnly(dateStr);
    if (!d) return null;
    return MONTH_SHEETS[d.getMonth()];
  }

  function normalizeReportLines(rows) {
    return (rows || []).map(r => ({
      report_line_id: r.report_line_id,
      report_date: r.report_date || '',
      ods_code: r.ods_code || '',
      reporter_name: r.reporter_name || '',
      item_general: r.item_general || '',
      item_activity: r.item_activity || '',
      activity_description: r.activity_description || '',
      support_text: r.support_text || '',
      delivery_medium_id: r.delivery_medium_id || '',
      delivery_medium_name: r.delivery_medium_name || '',
      contracted_days: r.contracted_days ?? '',
      days_month: r.days_month ?? '',
      progress_percent: r.progress_percent ?? '',
      accumulated_days: r.accumulated_days ?? '',
      accumulated_progress: r.accumulated_progress ?? '',
      observations: r.observations || '',
    }));
  }

  async function fetchLinesForExport({ userId, dateFrom, dateTo }) {
    const params = new URLSearchParams();
    if (userId) params.append('user_id', userId);
    if (dateFrom) params.append('date_from', dateFrom);
    if (dateTo) params.append('date_to', dateTo);
    try {
      const res = await apiRequest(`/reports/lines?${params.toString()}`);
      return normalizeReportLines(res.data || []);
    } catch {
      const res = await apiRequest('/reports/my-lines');
      const rows = normalizeReportLines(res.data || []);
      const fromD = toDateOnly(dateFrom);
      const toD = toDateOnly(dateTo);
      return rows.filter(r => {
        const rd = toDateOnly(r.report_date);
        if (!rd) return false;
        if (fromD && rd < fromD) return false;
        if (toD && rd > toD) return false;
        return true;
      });
    }
  }

  function groupLinesByMonth(lines) {
    const map = new Map();
    for (const line of lines) {
      const sheet = monthSheetFromDate(line.report_date);
      if (!sheet) continue;
      if (!map.has(sheet)) map.set(sheet, []);
      map.get(sheet).push(line);
    }
    for (const [k, arr] of map.entries()) {
      arr.sort((a, b) => (a.report_date || '').localeCompare(b.report_date || ''));
      map.set(k, arr);
    }
    return map;
  }

  async function generateExcelGPF23() {
    const ExcelJS = (await import('exceljs')).default;
    const { saveAs } = await import('file-saver');

    const selectedUser = users.find(u => String(u.id) === String(selectedProfessionalId));
    if (!selectedUser) {
      setExportAlert({ type: 'warning', message: 'Seleccione un profesional para generar el GP-F-23.' });
      return;
    }

    const lines = await fetchLinesForExport({ userId: selectedUser.id, dateFrom, dateTo });
    if (!lines.length) {
      setExportAlert({ type: 'warning', message: 'No hay lÃƒÆ’Ã‚Â­neas de reporte en el rango seleccionado.' });
      return;
    }

    const tplRes = await fetch('/templates/GP-F-23_Base_Individual.xlsx');
    if (!tplRes.ok) {
      setExportAlert({ type: 'error', message: 'No se encontrÃƒÆ’Ã‚Â³ el template GP-F-23_Base_Individual.xlsx en /public/templates.' });
      return;
    }
    const tplBuffer = await tplRes.arrayBuffer();

    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(tplBuffer);

    let deliveryMap = new Map();
    try {
      const mediaRes = await apiRequest('/reports/delivery-media');
      (mediaRes.data || []).forEach(m => deliveryMap.set(String(m.id), m.name));
    } catch {}

    const byMonth = groupLinesByMonth(lines);
    const MAX_ROWS = 19;

    const odsUnique = Array.from(new Set(lines.map(l => (l.ods_code || '').trim()).filter(Boolean)));
    const odsValue = odsUnique.length ? odsUnique.join(' / ').slice(0, 80) : '';

    for (const [sheetName, monthLines] of byMonth.entries()) {
      const ws = workbook.getWorksheet(sheetName);
      if (!ws) continue;

      ws.getCell('D5').value = odsValue;
      ws.getCell('D7').value = selectedUser.name || selectedUser.email || '';
      ws.getCell('D9').value = sheetName;
      const reportDateCell = toDateOnly(dateTo) || new Date();
      ws.getCell('D11').value = reportDateCell;

      for (let i = 0; i < MAX_ROWS; i++) {
        const r = 15 + i;
        const line = monthLines[i];

        if (!line) {
          ws.getRow(r).getCell(2).value = null;
          ws.getRow(r).getCell(3).value = null;
          ws.getRow(r).getCell(4).value = null;
          ws.getRow(r).getCell(5).value = null;
          ws.getRow(r).getCell(6).value = null;
          ws.getRow(r).getCell(7).value = null;
          ws.getRow(r).getCell(8).value = null;
          ws.getRow(r).getCell(10).value = null;
          continue;
        }

        const deliveryName =
          (line.delivery_medium_name || '').trim() ||
          deliveryMap.get(String(line.delivery_medium_id)) ||
          'Digital';

        const contracted = line.contracted_days === '' || line.contracted_days === null ? null : Number(line.contracted_days);
        const daysMonth = line.days_month === '' || line.days_month === null ? null : Number(line.days_month);
        const accDays = line.accumulated_days === '' || line.accumulated_days === null ? null : Number(line.accumulated_days);

        ws.getRow(r).getCell(2).value = line.item_general || '';
        ws.getRow(r).getCell(3).value = line.item_activity || '';
        ws.getRow(r).getCell(4).value = line.activity_description || '';
        ws.getRow(r).getCell(5).value = line.support_text || '';
        ws.getRow(r).getCell(6).value = deliveryName;
        ws.getRow(r).getCell(7).value = Number.isFinite(contracted) ? contracted : null;
        ws.getRow(r).getCell(8).value = Number.isFinite(daysMonth) ? daysMonth : null;
        ws.getRow(r).getCell(10).value = Number.isFinite(accDays) ? accDays : null;
      }

      if (monthLines.length > MAX_ROWS) {
        setExportAlert({
          type: 'warning',
          message: `El mes ${sheetName} tiene ${monthLines.length} lÃƒÆ’Ã‚Â­neas. El template solo soporta ${MAX_ROWS}; se exportaron las primeras ${MAX_ROWS}.`
        });
      }
    }

    const buffer = await workbook.xlsx.writeBuffer();
    const blob = new Blob([buffer], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    });

    const fileName = `GP-F-23_${safeFilePart(selectedUser.name || selectedUser.email)}_${dateFrom || 'NA'}_${dateTo || 'NA'}.xlsx`;
    saveAs(blob, fileName);

    setExportAlert({ type: 'success', message: 'GP-F-23 generado correctamente.' });
  }


  // Generar Excel usando ExcelJS
  const generateExcel = async () => {
    setGeneratingExcel(true);
    setExportAlert(null);
    try {
      await generateExcelGPF23();
    } catch (error) {
      alert('Error al generar el Excel. Por favor intente de nuevo.');
    } finally {
      setGeneratingExcel(false);
    }
  };

  if (loading && !user) {
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
      <div className="p-4 sm:p-6 lg:p-8 w-full max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-6">
          <h1 className="text-2xl font-semibold text-slate-900 flex items-center gap-3">
            <FileDown className="w-7 h-7 text-green-600" strokeWidth={1.75} />
            Descarga GP-F-23
          </h1>
          <p className="text-slate-500 mt-0.5 text-sm">Genera el reporte Base Individual (Avances) en Excel a partir del template corporativo</p>
        </div>

        {/* Panel de configuraciÃƒÆ’Ã‚Â³n */}
        <div className="bg-white rounded-xl border border-slate-200 p-6 mb-6">
          <h2 className="text-base font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <FileText className="w-5 h-5 text-slate-600" />
            ConfiguraciÃ³n
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {/* Profesional */}
            <div>
              <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                Profesional
              </label>
              <select
                value={selectedProfessionalId}
                onChange={(e) => {
                  setSelectedProfessionalId(e.target.value);
                  setExportAlert(null);
                }}
                className="w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500 bg-white"
              >
                <option value="">Seleccione un profesional...</option>
                {(user?.role === 'admin'
                  ? users.filter(u => !['admin', 'lider_area'].includes(u.role || ''))
                  : user ? [user] : []
                ).map(u => (
                  <option key={u.id} value={u.id}>{u.name || u.email}</option>
                ))}
              </select>
            </div>

            {/* Periodo */}
            <div>
              <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                Periodo
              </label>
              <DateRangeFilter 
                onChange={handleDateChange}
                defaultPeriod={currentPeriod}
                valueFrom={dateFrom}
                valueTo={dateTo}
              />
            </div>

            {/* Boton Excel */}
            <div className="flex items-end">
              <button
                onClick={generateExcel}
                disabled={generatingExcel || loading || !selectedProfessionalId}
                className="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {generatingExcel ? (
                  <Loader2 className="w-4 h-4 animate-spin" />
                ) : (
                  <FileSpreadsheet className="w-4 h-4" />
                )}
                {generatingExcel ? 'Generando...' : 'Descargar Excel'}
              </button>
            </div>
          </div>
          {exportAlert && (
            <div
              className={`mt-4 px-4 py-2.5 rounded-lg text-sm flex items-center justify-between ${
                exportAlert.type === 'success' ? 'bg-green-50 text-green-800 border border-green-200' :
                exportAlert.type === 'warning' ? 'bg-amber-50 text-amber-800 border border-amber-200' :
                'bg-red-50 text-red-800 border border-red-200'
              }`}
            >
              <span>{exportAlert.message}</span>
              <button type="button" onClick={() => setExportAlert(null)} className="ml-2 text-slate-500 hover:text-slate-700">Cerrar</button>
            </div>
          )}
        </div>

        <div className="bg-slate-50 rounded-xl border border-slate-200 p-12 text-center">
          <FileSpreadsheet className="w-16 h-16 text-slate-300 mx-auto mb-4" strokeWidth={1.5} />
          <h3 className="text-lg font-semibold text-slate-700 mb-2">GP-F-23 Base Individual</h3>
          <p className="text-slate-500 max-w-md mx-auto">
            Seleccione el profesional, el periodo y pulse &quot;Descargar Excel&quot; para generar el archivo a partir del template corporativo.
          </p>
        </div>
      </div>
    </Layout>
  );
}
