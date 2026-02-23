-- Migración: Actualizar los 2 primeros KPIs de Administración según documento
-- "INDICADORES - ÁREA DE GESTIÓN ADMINISTRATIVA" (auditables, seguimiento mensual)
-- Sin dañar lógica existente: se mantienen códigos ADM_01 y ADM_02.

-- =====================================================
-- 1. KPI ADM_01 → Índice de Cumplimiento del Plan de Gestión Administrativa
-- Qué evalúa: Nivel de disciplina y ejecución del área frente al plan de gestión.
-- Fórmula: Actividades ejecutadas / Actividades planificadas
-- Umbrales: ≥95% Verde, 95%-85% Amarillo, <85% Rojo, N/A Blanco
-- =====================================================

UPDATE `kpis` SET
  `name` = 'Índice de Cumplimiento del Plan de Gestión Administrativa',
  `description` = 'Nivel de disciplina y ejecución del área administrativa frente al plan de gestión definido para el periodo.',
  `formula_text` = 'Actividades ejecutadas / Actividades planificadas',
  `updated_at` = CURRENT_TIMESTAMP
WHERE `code` = 'ADM_01';

-- =====================================================
-- 2. KPI ADM_02 → Índice de Cumplimiento de Procedimientos
-- Qué evalúa: Grado de adherencia a los procedimientos administrativos establecidos.
-- Fórmula: Procesos conformes a procedimiento / Procesos ejecutados
-- Tipo: RATIO_SUM (porcentaje). Requiere input "conforme_procedimiento" por tarea.
-- Umbrales: ≥95% Verde, 95%-85% Amarillo, <85% Rojo, N/A Blanco
-- =====================================================

UPDATE `kpis` SET
  `name` = 'Índice de Cumplimiento de Procedimientos',
  `description` = 'Grado de adherencia del área a los procedimientos administrativos establecidos.',
  `calc_kind` = 'RATIO_SUM',
  `unit` = 'PERCENT',
  `period_anchor` = 'CLOSED_DATE',
  `na_rule` = 'NA_IF_DENOMINATOR_ZERO',
  `formula_text` = 'Procesos conformes a procedimiento / Procesos ejecutados',
  `target_value` = 95.00,
  `is_inverted` = 0,
  `updated_at` = CURRENT_TIMESTAMP
WHERE `code` = 'ADM_02';

-- Umbrales ADM_02: reemplazar los de Lead Time por porcentaje (igual que ADM_01)
SET @adm02_id = (SELECT id FROM kpis WHERE code = 'ADM_02' LIMIT 1);
DELETE FROM `kpi_thresholds` WHERE `kpi_id` = @adm02_id;

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`, `is_pending`) VALUES
(@adm02_id, 'GREEN', 'GE', 95.00, NULL, 3, 'Procedimientos cumplidos correctamente', 0),
(@adm02_id, 'YELLOW', 'BETWEEN', 85.00, 94.99, 2, 'Incumplimientos puntuales; requiere control', 0),
(@adm02_id, 'RED', 'LT', 85.00, NULL, 1, 'Riesgo operativo por incumplimiento de procedimientos', 0),
(@adm02_id, 'WHITE', 'EQ', NULL, NULL, 0, 'N/A - No se ejecutaron procesos en el periodo', 0);

-- Input requerido para ADM_02: ¿Ejecutado conforme a procedimiento?
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `default_value`, `sort_order`, `created_at`)
SELECT @adm02_id, 'conforme_procedimiento', '¿Ejecutado conforme a procedimiento?', 'BOOL', 1, NULL, 1, CURRENT_TIMESTAMP
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM kpi_required_inputs ri WHERE ri.kpi_id = @adm02_id AND ri.field_key = 'conforme_procedimiento');

-- =====================================================
-- 3. Nombres de categorías (área Administración, lo que ve el usuario)
-- =====================================================

SET @adm01_id = (SELECT id FROM kpis WHERE code = 'ADM_01' LIMIT 1);

UPDATE `kpi_categories` SET
  `name` = 'Índice de Cumplimiento del Plan de Gestión Administrativa',
  `slug` = 'ADM_PLAN_GESTION',
  `updated_at` = CURRENT_TIMESTAMP
WHERE `area_id` = 2 AND `kpi_id` = @adm01_id;

UPDATE `kpi_categories` SET
  `name` = 'Índice de Cumplimiento de Procedimientos',
  `slug` = 'ADM_CUMPLIMIENTO_PROCEDIMIENTOS',
  `updated_at` = CURRENT_TIMESTAMP
WHERE `area_id` = 2 AND `kpi_id` = @adm02_id;

-- Área IT (si reutiliza ADM_01/ADM_02): alinear nombres de categoría
UPDATE `kpi_categories` SET
  `name` = 'Índice de Cumplimiento del Plan de Gestión Administrativa',
  `slug` = 'ADM_PLAN_GESTION',
  `updated_at` = CURRENT_TIMESTAMP
WHERE `area_id` = 1 AND `kpi_id` = @adm01_id;

UPDATE `kpi_categories` SET
  `name` = 'Índice de Cumplimiento de Procedimientos',
  `slug` = 'ADM_CUMPLIMIENTO_PROCEDIMIENTOS',
  `updated_at` = CURRENT_TIMESTAMP
WHERE `area_id` = 1 AND `kpi_id` = @adm02_id;
