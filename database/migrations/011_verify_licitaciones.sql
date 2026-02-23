-- =====================================================
-- Verificación post-migración: Área LICITACIONES
-- Ejecutar después de 011_add_area_licitaciones_kpis.sql
-- =====================================================

-- 1. Verificar que el área LICITACIONES existe
SELECT '=== ÁREA LICITACIONES ===' AS verificacion;
SELECT id, name, code, type, is_active FROM areas WHERE code = 'LICITACIONES';

-- 2. Verificar los 6 KPIs (LIC_01 a LIC_06)
SELECT '=== KPIs LICITACIONES (esperados: 6) ===' AS verificacion;
SELECT id, code, name, calc_kind, unit, na_rule, formula_text
FROM kpis WHERE code LIKE 'LIC_%' ORDER BY code;

-- 3. Verificar thresholds (semáforos) — esperados: 22 registros
-- LIC_01: 4, LIC_02: 3, LIC_03: 4, LIC_04: 4, LIC_05: 4, LIC_06: 4 = 23 total
SELECT '=== THRESHOLDS LICITACIONES (esperados: 23) ===' AS verificacion;
SELECT k.code, t.color, t.op, t.a, t.b, t.priority, t.note
FROM kpi_thresholds t
JOIN kpis k ON k.id = t.kpi_id
WHERE k.code LIKE 'LIC_%'
ORDER BY k.code, t.priority DESC;

-- 4. Verificar categorías KPI (esperadas: 6)
SELECT '=== CATEGORÍAS KPI LICITACIONES (esperadas: 6) ===' AS verificacion;
SELECT kc.id, kc.name, kc.slug, kc.sort_order, k.code AS kpi_code, a.name AS area_name
FROM kpi_categories kc
JOIN kpis k ON k.id = kc.kpi_id
JOIN areas a ON a.id = kc.area_id
WHERE a.code = 'LICITACIONES'
ORDER BY kc.sort_order;

-- 5. Verificar inputs requeridos (esperados: 9)
SELECT '=== INPUTS REQUERIDOS LICITACIONES (esperados: 9) ===' AS verificacion;
SELECT k.code, ri.field_key, ri.field_label, ri.field_type, ri.is_required
FROM kpi_required_inputs ri
JOIN kpis k ON k.id = ri.kpi_id
WHERE k.code LIKE 'LIC_%'
ORDER BY k.code, ri.sort_order;

-- 6. Verificar que Licitaciones aparecerá en los dropdowns
-- (las áreas activas son las que aparecen)
SELECT '=== TODAS LAS ÁREAS ACTIVAS (Licitaciones debe estar incluida) ===' AS verificacion;
SELECT id, name, code, type, is_active FROM areas WHERE is_active = 1 ORDER BY name;

-- 7. Conteo resumen
SELECT '=== RESUMEN ===' AS verificacion;
SELECT 
  (SELECT COUNT(*) FROM areas WHERE code = 'LICITACIONES') AS area_existe,
  (SELECT COUNT(*) FROM kpis WHERE code LIKE 'LIC_%') AS total_kpis,
  (SELECT COUNT(*) FROM kpi_thresholds t JOIN kpis k ON k.id = t.kpi_id WHERE k.code LIKE 'LIC_%') AS total_thresholds,
  (SELECT COUNT(*) FROM kpi_categories kc JOIN areas a ON a.id = kc.area_id WHERE a.code = 'LICITACIONES') AS total_categorias,
  (SELECT COUNT(*) FROM kpi_required_inputs ri JOIN kpis k ON k.id = ri.kpi_id WHERE k.code LIKE 'LIC_%') AS total_inputs;
