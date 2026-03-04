// app/reports/download/page.js
'use client';

import { useEffect, useState, useCallback, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import Layout from '../../../components/Layout';
import DateRangeFilter from '../../../components/DateRangeFilter';
import { apiRequest } from '../../../lib/api';
import { FileDown, Loader2, FileText, Search, Download, User, Layers } from 'lucide-react';

const DOWNLOAD_MODE_INDIVIDUAL = 'individual';
const DOWNLOAD_MODE_ODS = 'ods';

export default function ReportsDownload() {
  const router = useRouter();
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [generatingForId, setGeneratingForId] = useState(null);
  const [generatingOdsId, setGeneratingOdsId] = useState(null);
  const [users, setUsers] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [serviceOrders, setServiceOrders] = useState([]);
  const [selectedOdsId, setSelectedOdsId] = useState('');
  const [downloadMode, setDownloadMode] = useState(DOWNLOAD_MODE_INDIVIDUAL);
  const today = new Date().toISOString().split('T')[0];
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);
  const [currentPeriod, setCurrentPeriod] = useState('today');
  const [exportAlert, setExportAlert] = useState(null);

  const professionals = useMemo(() => {
    let list;
    if (user?.role === 'admin') {
      list = (users || []).filter(u => (u.role || '') !== 'lider_area');
    } else {
      list = user ? [user] : [];
    }
    if (selectedOdsId) {
      const sid = Number(selectedOdsId);
      list = list.filter(u => (u.service_order_ids || []).some(id => Number(id) === sid));
    }
    return list;
  }, [user, users, selectedOdsId]);

  const filteredProfessionals = useMemo(() => {
    const q = (searchQuery || '').trim().toLowerCase();
    if (!q) return professionals;
    return professionals.filter(p => {
      const name = (p.name || '').toLowerCase();
      const email = (p.email || '').toLowerCase();
      return name.includes(q) || email.includes(q);
    });
  }, [professionals, searchQuery]);

  /** Profesionales asignados a cada ODS (para modo descarga por ODS) */
  const professionalsByOdsId = useMemo(() => {
    const map = new Map();
    const baseList = user?.role === 'admin' ? (users || []).filter(u => (u.role || '') !== 'lider_area') : user ? [user] : [];
    for (const so of serviceOrders) {
      const sid = Number(so.id);
      const list = baseList.filter(u => (u.service_order_ids || []).some(id => Number(id) === sid));
      map.set(sid, list);
    }
    return map;
  }, [user, users, serviceOrders]);


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
      const [usersRes, odsRes] = await Promise.all([
        user.role === 'admin' ? apiRequest('/users') : Promise.resolve({ data: user ? [user] : [] }),
        apiRequest('/reports/service-orders')
      ]);
      setUsers(usersRes.data || []);
      setServiceOrders(odsRes.data || []);
    } catch (e) {
      if (user?.role === 'lider_area') setUsers(user ? [user] : []);
    } finally {
      setLoading(false);
    }
  }, [user]);

  useEffect(() => {
    if (user) loadData();
  }, [user, loadData]);

  const handleDateChange = (from, to, period) => {
    setDateFrom(from || '');
    setDateTo(to || '');
    setCurrentPeriod(period);
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

  async function fetchLinesForExport({ userId, dateFrom, dateTo, serviceOrderId, odsCode }) {
    const params = new URLSearchParams();
    if (userId) params.append('user_id', userId);
    if (dateFrom) params.append('date_from', dateFrom);
    if (dateTo) params.append('date_to', dateTo);
    if (serviceOrderId) params.append('service_order_id', serviceOrderId);
    try {
      const res = await apiRequest(`/reports/lines?${params.toString()}`);
      return normalizeReportLines(res.data || []);
    } catch {
      const res = await apiRequest('/reports/my-lines');
      let rows = normalizeReportLines(res.data || []);
      const fromD = toDateOnly(dateFrom);
      const toD = toDateOnly(dateTo);
      rows = rows.filter(r => {
        const rd = toDateOnly(r.report_date);
        if (!rd) return false;
        if (fromD && rd < fromD) return false;
        if (toD && rd > toD) return false;
        return true;
      });
      if (odsCode) {
        rows = rows.filter(r => (r.ods_code || '').trim() === odsCode);
      }
      return rows;
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

  async function generateExcelGPF23(selectedUser) {
    const ExcelJS = (await import('exceljs')).default;
    const { saveAs } = await import('file-saver');

    if (!selectedUser) {
      setExportAlert({ type: 'warning', message: 'Seleccione un profesional para generar el GP-F-23.' });
      return;
    }

    const odsId = selectedOdsId && selectedOdsId !== '' ? selectedOdsId : null;
    const selectedOds = odsId ? serviceOrders.find(o => String(o.id) === String(odsId)) : null;
    const odsCode = selectedOds?.ods_code || null;
    const lines = await fetchLinesForExport({ userId: selectedUser.id, dateFrom, dateTo, serviceOrderId: odsId, odsCode });
    if (!lines.length) {
      setExportAlert({ type: 'warning', message: 'No hay líneas de reporte en el rango seleccionado.' });
      return;
    }

    const tplRes = await fetch('/templates/GP-F-23_Base_Individual.xlsx');
    if (!tplRes.ok) {
      setExportAlert({ type: 'error', message: 'No se encontró el template GP-F-23_Base_Individual.xlsx en /public/templates.' });
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
          message: `El mes ${sheetName} tiene ${monthLines.length} líneas. El template solo soporta ${MAX_ROWS}; se exportaron las primeras ${MAX_ROWS}.`
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


  const generateExcelForProfessional = async (professional) => {
    if (!professional) return;
    setGeneratingForId(professional.id);
    setExportAlert(null);
    try {
      await generateExcelGPF23(professional);
    } catch (error) {
      alert('Error al generar el Excel. Por favor intente de nuevo.');
    } finally {
      setGeneratingForId(null);
    }
  };

  /** Genera reporte consolidado por ODS (todas las líneas del ODS en el periodo) */
  async function generateExcelForOds(ods) {
    if (!ods) return;
    const pros = professionalsByOdsId.get(Number(ods.id)) || [];
    if (!pros.length) {
      setExportAlert({ type: 'warning', message: 'No hay profesionales asignados a este ODS.' });
      return;
    }

    setGeneratingOdsId(ods.id);
    setExportAlert(null);
    try {
      const allLines = [];
      for (const p of pros) {
        const lines = await fetchLinesForExport({
          userId: p.id,
          dateFrom,
          dateTo,
          serviceOrderId: String(ods.id),
          odsCode: ods.ods_code || null
        });
        allLines.push(...lines.map(l => ({ ...l, _reporter_id: p.id, _reporter_name: p.name || p.email || '' })));
      }
      if (!allLines.length) {
        setExportAlert({ type: 'warning', message: 'No hay líneas de reporte en el periodo seleccionado para este ODS.' });
        setGeneratingOdsId(null);
        return;
      }

      const byMonth = groupLinesByMonth(allLines);
      const ExcelJS = (await import('exceljs')).default;
      const { saveAs } = await import('file-saver');

      let deliveryMap = new Map();
      try {
        const mediaRes = await apiRequest('/reports/delivery-media');
        (mediaRes.data || []).forEach(m => deliveryMap.set(String(m.id), m.name));
      } catch {}

      const templatePath = '/templates/Consolidado GP-F-23_ODS_XXXXX_MES.xlsx';
      const tplRes = await fetch(templatePath);
      const workbook = new ExcelJS.Workbook();
      if (tplRes.ok) {
        const tplBuffer = await tplRes.arrayBuffer();
        await workbook.xlsx.load(tplBuffer);
      }

      const MONTH_SHEETS = [
        'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
        'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'
      ];
      const odsLabel = (ods.ods_code || `ODS-${ods.id}`).replace(/[^a-zA-Z0-9-_]+/g, '_').slice(0, 60);

      for (const [sheetName, monthLines] of byMonth.entries()) {
        let ws = workbook.getWorksheet(sheetName);
        if (!ws && !tplRes.ok) {
          ws = workbook.addWorksheet(sheetName);
          ws.getRow(1).getCell(1).value = 'ODS';
          ws.getRow(1).getCell(2).value = odsLabel;
          ws.getRow(2).getCell(1).value = 'Mes';
          ws.getRow(2).getCell(2).value = sheetName;
          ws.getRow(3).getCell(1).value = 'Profesional';
          ws.getRow(3).getCell(2).value = 'Item general';
          ws.getRow(3).getCell(3).value = 'Item actividad';
          ws.getRow(3).getCell(4).value = 'Descripción';
          ws.getRow(3).getCell(5).value = 'Soporte';
          ws.getRow(3).getCell(6).value = 'Medio entrega';
          ws.getRow(3).getCell(7).value = 'Días mes';
          ws.getRow(3).getCell(8).value = 'Días acum.';
          startRow = 5;
        }
        if (!ws) continue;

        if (tplRes.ok) {
          ws.getCell('D5').value = odsLabel;
          ws.getCell('D9').value = sheetName;
          ws.getCell('D11').value = toDateOnly(dateTo) || new Date();
        }

        const rowStart = tplRes.ok ? 15 : 5;
        monthLines.forEach((line, idx) => {
          const r = rowStart + idx;
          const deliveryName = (line.delivery_medium_name || '').trim() || deliveryMap.get(String(line.delivery_medium_id)) || 'Digital';
          const daysMonth = line.days_month === '' || line.days_month === null ? null : Number(line.days_month);
          const accDays = line.accumulated_days === '' || line.accumulated_days === null ? null : Number(line.accumulated_days);
          if (tplRes.ok) {
            ws.getRow(r).getCell(2).value = line.item_general || '';
            ws.getRow(r).getCell(3).value = line.item_activity || '';
            ws.getRow(r).getCell(4).value = line.activity_description || '';
            ws.getRow(r).getCell(5).value = line.support_text || '';
            ws.getRow(r).getCell(6).value = deliveryName;
            ws.getRow(r).getCell(8).value = Number.isFinite(daysMonth) ? daysMonth : null;
            ws.getRow(r).getCell(10).value = Number.isFinite(accDays) ? accDays : null;
            if (line._reporter_name) ws.getRow(r).getCell(1).value = line._reporter_name;
          } else {
            ws.getRow(r).getCell(1).value = line._reporter_name || '';
            ws.getRow(r).getCell(2).value = line.item_general || '';
            ws.getRow(r).getCell(3).value = line.item_activity || '';
            ws.getRow(r).getCell(4).value = line.activity_description || '';
            ws.getRow(r).getCell(5).value = line.support_text || '';
            ws.getRow(r).getCell(6).value = deliveryName;
            ws.getRow(r).getCell(7).value = Number.isFinite(daysMonth) ? daysMonth : null;
            ws.getRow(r).getCell(8).value = Number.isFinite(accDays) ? accDays : null;
          }
        });
      }

      const buffer = await workbook.xlsx.writeBuffer();
      const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
      const fileName = `GP-F-23_Consolidado_ODS_${safeFilePart(ods.ods_code || ods.id)}_${dateFrom || 'NA'}_${dateTo || 'NA'}.xlsx`;
      saveAs(blob, fileName);
      setExportAlert({ type: 'success', message: 'Reporte consolidado por ODS generado correctamente.' });
    } catch (error) {
      setExportAlert({ type: 'error', message: error?.message || 'Error al generar el reporte por ODS.' });
    } finally {
      setGeneratingOdsId(null);
    }
  }

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
          <p className="text-slate-500 mt-0.5 text-sm">
            Genera reportes en Excel: por profesional (individual) o consolidado por ODS.
          </p>
        </div>

        {/* Selector de tipo de descarga */}
        <div className="flex gap-2 p-1 bg-slate-100 rounded-xl w-full max-w-md mb-6">
          <button
            type="button"
            onClick={() => setDownloadMode(DOWNLOAD_MODE_INDIVIDUAL)}
            className={`flex-1 flex items-center justify-center gap-2 py-3 px-4 rounded-lg text-sm font-medium transition-all ${
              downloadMode === DOWNLOAD_MODE_INDIVIDUAL
                ? 'bg-white text-slate-900 shadow-sm'
                : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            <User className="w-5 h-5" />
            Reporte individual
          </button>
          <button
            type="button"
            onClick={() => setDownloadMode(DOWNLOAD_MODE_ODS)}
            className={`flex-1 flex items-center justify-center gap-2 py-3 px-4 rounded-lg text-sm font-medium transition-all ${
              downloadMode === DOWNLOAD_MODE_ODS
                ? 'bg-white text-slate-900 shadow-sm'
                : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            <Layers className="w-5 h-5" />
            Reporte por ODS
          </button>
        </div>

        {/* Panel de configuración */}
        <div className="bg-white rounded-xl border border-slate-200 p-6 mb-6">
          <h2 className="text-base font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <FileText className="w-5 h-5 text-slate-600" />
            Configuración
          </h2>
          
          <div className={`grid gap-4 mb-4 ${downloadMode === DOWNLOAD_MODE_ODS ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1 md:grid-cols-3'}`}>
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
            {downloadMode === DOWNLOAD_MODE_INDIVIDUAL && (
              <>
                <div>
                  <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                    Filtrar por ODS
                  </label>
                  <select
                    value={selectedOdsId}
                    onChange={(e) => setSelectedOdsId(e.target.value)}
                    className="w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500 bg-white"
                  >
                    <option value="">Todos los ODS</option>
                    {serviceOrders.map((so) => (
                      <option key={so.id} value={so.id}>{so.ods_code || `ODS ${so.id}`}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-medium text-slate-600 mb-1.5 uppercase tracking-wide">
                    Buscar profesional
                  </label>
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                    <input
                      type="text"
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      placeholder="Nombre o correo..."
                      className="w-full pl-9 pr-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                    />
                  </div>
                </div>
              </>
            )}
            {downloadMode === DOWNLOAD_MODE_ODS && (
              <p className="text-sm text-slate-500 flex items-center gap-1.5 md:col-span-1">
                El periodo aplica a todos los reportes por ODS que descargue a continuación.
              </p>
            )}
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

        {/* Contenido según modo: Individual o Por ODS */}
        {downloadMode === DOWNLOAD_MODE_INDIVIDUAL && (
          <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
            <div className="px-5 py-4 border-b border-slate-200 bg-slate-50">
              <h2 className="text-base font-semibold text-slate-900">Profesionales</h2>
              <p className="text-sm text-slate-500 mt-0.5">
                Descargue el GP-F-23 (Base Individual) de cada profesional. Opcionalmente filtre por ODS y use la búsqueda.
              </p>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-slate-100 border-b border-slate-200">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wide">Nombre</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wide">Correo</th>
                    <th className="px-4 py-3 text-right text-xs font-semibold text-slate-600 uppercase tracking-wide w-40">Acciones</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {loading ? (
                    <tr>
                      <td colSpan={3} className="px-4 py-12 text-center text-slate-500">
                        <Loader2 className="w-8 h-8 text-green-600 animate-spin mx-auto mb-2" />
                        Cargando profesionales...
                      </td>
                    </tr>
                  ) : filteredProfessionals.length === 0 ? (
                    <tr>
                      <td colSpan={3} className="px-4 py-12 text-center text-slate-500">
                        {professionals.length === 0 ? 'No hay profesionales disponibles.' : 'Ningún resultado coincide con la búsqueda.'}
                      </td>
                    </tr>
                  ) : (
                    filteredProfessionals.map((pro) => (
                      <tr key={pro.id} className="hover:bg-slate-50/80">
                        <td className="px-4 py-3 font-medium text-slate-900">{pro.name || pro.email || '-'}</td>
                        <td className="px-4 py-3 text-slate-600">{pro.email || '-'}</td>
                        <td className="px-4 py-3 text-right">
                          <button
                            type="button"
                            onClick={() => generateExcelForProfessional(pro)}
                            disabled={!!generatingForId}
                            className="inline-flex items-center justify-center gap-2 px-3 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                          >
                            {generatingForId === pro.id ? (
                              <Loader2 className="w-4 h-4 animate-spin" />
                            ) : (
                              <Download className="w-4 h-4" />
                            )}
                            {generatingForId === pro.id ? 'Generando...' : 'Descargar'}
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {downloadMode === DOWNLOAD_MODE_ODS && (
          <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
            <div className="px-5 py-4 border-b border-slate-200 bg-slate-50">
              <h2 className="text-base font-semibold text-slate-900">Reporte consolidado por ODS</h2>
              <p className="text-sm text-slate-500 mt-0.5">
                Descargue un único Excel por ODS con todas las líneas de reporte de los profesionales de ese ODS en el periodo seleccionado.
              </p>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-slate-100 border-b border-slate-200">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wide">Código ODS</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 uppercase tracking-wide">Profesionales</th>
                    <th className="px-4 py-3 text-right text-xs font-semibold text-slate-600 uppercase tracking-wide w-40">Acciones</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {loading ? (
                    <tr>
                      <td colSpan={3} className="px-4 py-12 text-center text-slate-500">
                        <Loader2 className="w-8 h-8 text-green-600 animate-spin mx-auto mb-2" />
                        Cargando ODS...
                      </td>
                    </tr>
                  ) : serviceOrders.length === 0 ? (
                    <tr>
                      <td colSpan={3} className="px-4 py-12 text-center text-slate-500">
                        No hay ODS disponibles.
                      </td>
                    </tr>
                  ) : (
                    serviceOrders.map((so) => {
                      const count = (professionalsByOdsId.get(Number(so.id)) || []).length;
                      return (
                        <tr key={so.id} className="hover:bg-slate-50/80">
                          <td className="px-4 py-3 font-medium text-slate-900">{so.ods_code || `ODS ${so.id}`}</td>
                          <td className="px-4 py-3 text-slate-600">{count} profesional{count !== 1 ? 'es' : ''}</td>
                          <td className="px-4 py-3 text-right">
                            <button
                              type="button"
                              onClick={() => generateExcelForOds(so)}
                              disabled={!!generatingOdsId || count === 0}
                              className="inline-flex items-center justify-center gap-2 px-3 py-2 bg-emerald-600 text-white text-sm font-medium rounded-lg hover:bg-emerald-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                            >
                              {generatingOdsId === so.id ? (
                                <Loader2 className="w-4 h-4 animate-spin" />
                              ) : (
                                <Download className="w-4 h-4" />
                              )}
                              {generatingOdsId === so.id ? 'Generando...' : 'Descargar'}
                            </button>
                          </td>
                        </tr>
                      );
                    })
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </Layout>
  );
}
