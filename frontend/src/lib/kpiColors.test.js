/**
 * Tests para normalización y color de KPIs.
 * Ejecutar con: npx vitest run src/lib/kpiColors.test.js
 */

import { describe, it, expect } from 'vitest';
import { normalizeTo0_100, getKpiColor } from './kpiColors.js';

describe('normalizeTo0_100', () => {
  it('"81.3%" → 81.3', () => {
    expect(normalizeTo0_100('81.3%').value).toBe(81.3);
  });

  it('"81,3%" → 81.3', () => {
    expect(normalizeTo0_100('81,3%').value).toBe(81.3);
  });

  it('0.813 con unit PERCENT → 81.3', () => {
    expect(normalizeTo0_100(0.813, 'PERCENT').value).toBe(81.3);
  });

  it('"0.813%" → 0.813 (no multiplicar otra vez)', () => {
    expect(normalizeTo0_100('0.813%').value).toBe(0.813);
  });

  it('" 74.6 " → 74.6', () => {
    expect(normalizeTo0_100(' 74.6 ').value).toBe(74.6);
  });

  it('null → null, status no-data', () => {
    const r = normalizeTo0_100(null);
    expect(r.value).toBeNull();
    expect(r.status).toBe('no-data');
  });

  it('undefined → null, status no-data', () => {
    const r = normalizeTo0_100(undefined);
    expect(r.value).toBeNull();
    expect(r.status).toBe('no-data');
  });

  it('"" → null, status no-data', () => {
    const r = normalizeTo0_100('');
    expect(r.value).toBeNull();
    expect(r.status).toBe('no-data');
  });

  it('clamp: valor > 100 queda 100', () => {
    expect(normalizeTo0_100(150).value).toBe(100);
  });

  it('clamp: valor < 0 queda 0', () => {
    expect(normalizeTo0_100(-10).value).toBe(0);
  });
});

describe('getKpiColor', () => {
  it('59.9 → red', () => {
    expect(getKpiColor(59.9)).toBe('red');
  });

  it('60 → yellow', () => {
    expect(getKpiColor(60)).toBe('yellow');
  });

  it('79.9 → yellow', () => {
    expect(getKpiColor(79.9)).toBe('yellow');
  });

  it('80 → green', () => {
    expect(getKpiColor(80)).toBe('green');
  });

  it('100 → green', () => {
    expect(getKpiColor(100)).toBe('green');
  });

  it('81.3 → green (nunca rojo)', () => {
    expect(getKpiColor(81.3)).toBe('green');
  });

  it('null → gray', () => {
    expect(getKpiColor(null)).toBe('gray');
  });
});
