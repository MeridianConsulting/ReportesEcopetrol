/**
 * Lógica centralizada de colores y normalización de KPIs.
 * Única fuente de verdad: valor en escala 0–100 y semáforo 60/80.
 */

/**
 * Normaliza el valor del KPI a escala 0–100 para comparación y color.
 * @param {string|number|null|undefined} rawValue - Valor tal como viene del backend o UI
 * @param {string} [unitOrType] - Unidad: 'PERCENT', '%', 'RATING_1_5', etc.
 * @returns {{ value: number|null, status: 'ok'|'no-data' }}
 */
export function normalizeTo0_100(rawValue, unitOrType = '') {
  if (rawValue === null || rawValue === undefined) {
    return { value: null, status: 'no-data' };
  }
  const rawStr = String(rawValue).trim();
  if (rawStr === '') {
    return { value: null, status: 'no-data' };
  }

  const hasPercentInRaw = rawStr.includes('%');
  let str = rawStr.replace(/,/g, '.').replace(/%/g, '').replace(/[^\d.-]/g, '').trim();
  if (str === '' || str === '-') {
    return { value: null, status: 'no-data' };
  }

  let num = parseFloat(str);
  if (Number.isNaN(num)) {
    return { value: null, status: 'no-data' };
  }

  const unit = String(unitOrType || '').toUpperCase();
  const isPercent = unit === 'PERCENT' || unit === '%' || hasPercentInRaw;

  // Valor en (0, 1] y es porcentaje y NO venía con % en el string → escala 0–1, multiplicar por 100
  if (isPercent && !hasPercentInRaw && num > 0 && num <= 1) {
    num = num * 100;
  }

  num = Math.max(0, Math.min(100, num));
  return { value: num, status: 'ok' };
}

/**
 * Asigna color del semáforo según valor en escala 0–100.
 * Regla: Rojo < 60, Amarillo 60–<80, Verde >= 80. Null → gris.
 * @param {number|null|undefined} value - Valor ya normalizado (0–100) o null
 * @returns {'red'|'yellow'|'green'|'gray'}
 */
export function getKpiColor(value) {
  if (value === null || value === undefined || Number.isNaN(value)) {
    return 'gray';
  }
  const v = Number(value);
  if (v < 60) return 'red';
  if (v < 80) return 'yellow';
  return 'green';
}

/**
 * Tema de estilos Tailwind por color de KPI (fondo, texto, punto).
 * La UI debe usar solo este map para tarjetas KPI.
 */
export const KPI_THEME = {
  red: {
    bg: 'bg-rose-50',
    text: 'text-rose-600',
    dot: 'bg-rose-500',
  },
  yellow: {
    bg: 'bg-amber-50',
    text: 'text-amber-600',
    dot: 'bg-amber-500',
  },
  green: {
    bg: 'bg-emerald-50',
    text: 'text-emerald-600',
    dot: 'bg-emerald-500',
  },
  gray: {
    bg: 'bg-slate-100',
    text: 'text-slate-500',
    dot: 'bg-slate-400',
  },
};

/**
 * Dado un objeto KPI (con value y unit), devuelve el color a usar y las clases.
 * Usar en tarjetas para no duplicar lógica.
 * @param {{ value?: string|number|null, unit?: string, is_na?: boolean }} kpi
 * @returns {{ color: string, theme: typeof KPI_THEME.red }}
 */
export function getKpiColorAndTheme(kpi) {
  if (kpi?.is_na === true) {
    return { color: 'gray', theme: KPI_THEME.gray };
  }
  const { value, status } = normalizeTo0_100(kpi?.value, kpi?.unit);
  if (status === 'no-data') {
    return { color: 'gray', theme: KPI_THEME.gray };
  }
  const color = getKpiColor(value);
  return { color, theme: KPI_THEME[color] };
}
