-- =====================================================
-- Migración 011: Área LICITACIONES + 6 KPIs + Categorías
-- Fecha: 2026-02-12
-- Descripción: Crea el área "LICITACIONES", sus 6 KPIs
--              (LIC_01 a LIC_06), thresholds (semáforos),
--              inputs requeridos y categorías KPI.
-- Fuente: Indicadores Area de Licitaciones.pdf
-- IDEMPOTENTE: Usa INSERT IGNORE y verificaciones previas.
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- PASO 1: Crear el Área LICITACIONES (si no existe)
-- =====================================================
INSERT INTO `areas` (`name`, `code`, `type`, `parent_id`, `is_active`)
SELECT 'LICITACIONES', 'LICITACIONES', 'AREA', NULL, 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `areas` WHERE `code` = 'LICITACIONES');

-- Guardar el ID del área para uso posterior
SET @area_lic_id = (SELECT `id` FROM `areas` WHERE `code` = 'LICITACIONES' LIMIT 1);

-- =====================================================
-- PASO 2: Crear los 6 KPIs de Licitaciones (LIC_01 a LIC_06)
-- =====================================================

-- LIC_01: Índice de efectividad de Oportunidades
INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`)
SELECT 'LIC_01',
       'Índice de efectividad de Oportunidades',
       'Evalúa la calidad del filtro estratégico; mide la calidad de la decisión. Variables: Ofertas de interés, Ofertas adjudicadas.',
       'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO',
       'Ofertas adjudicadas / Ofertas de interés × 100', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpis` WHERE `code` = 'LIC_01');

-- LIC_02: Índice de Cobertura de Búsqueda de Oportunidades
INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`)
SELECT 'LIC_02',
       'Índice de Cobertura de Búsqueda de Oportunidades',
       'Evalúa la disciplina y alcance de la prospección. Variables: Ofertas identificadas, Ofertas planeadas a participar.',
       'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO',
       'Ofertas identificadas / Ofertas planeadas × 100', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpis` WHERE `code` = 'LIC_02');

-- LIC_03: Índice de Ejecución de la Planeación de Ofertas
INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`)
SELECT 'LIC_03',
       'Índice de Ejecución de la Planeación de Ofertas',
       'Evalúa la ejecución efectiva de lo planeado; mide la calidad de la ejecución. Variables: Ofertas planeadas de interés, Ofertas presentadas. No aplica si hay ausencia de ofertas de interés.',
       'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO',
       'Ofertas presentadas / Ofertas planeadas a participar × 100', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpis` WHERE `code` = 'LIC_03');

-- LIC_04: Tiempo Promedio de Preparación de Ofertas
INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`)
SELECT 'LIC_04',
       'Tiempo Promedio de Preparación de Ofertas',
       'Mide la agilidad organizacional para preparar ofertas. Variables: Días de preparación, Ofertas presentadas. Requiere mínimo 5 ofertas para aplicar semáforo.',
       'AVG', 'DAYS', 'CLOSED_DATE', 'NA_IF_NO_DATA',
       'Σ días de preparación / Ofertas presentadas', 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpis` WHERE `code` = 'LIC_04');

-- LIC_05: Índice de Documentación Vigente, Completa y Crítica
INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`)
SELECT 'LIC_05',
       'Índice de Documentación Vigente, Completa y Crítica',
       'Controla el riesgo documental evitable. Variables: Ofertas presentadas, Ofertas con documentación completa y vigente.',
       'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO',
       'Ofertas con documentación completa y vigente / Ofertas presentadas × 100', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpis` WHERE `code` = 'LIC_05');

-- LIC_06: Indicador complementario — Gravedad relativa de fallas documentales
INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`)
SELECT 'LIC_06',
       'Indicador complementario: gravedad relativa de fallas documentales',
       'Evalúa la gravedad relativa de las fallas documentales, diferenciando fallas críticas de fallas totales. Variables: Fallas documentales críticas, Fallas documentales no críticas. Si no se presentan ofertas por falta de interés, no existen fallas y el indicador no se calcula.',
       'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO',
       'Fallas documentales críticas / (Fallas documentales críticas + Fallas documentales no críticas) × 100', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpis` WHERE `code` = 'LIC_06');

-- =====================================================
-- PASO 3: Thresholds (Semáforos) para cada KPI
-- =====================================================

-- ----- LIC_01: Índice de efectividad de Oportunidades -----
-- ≥25% → Verde → "Alta Efectividad"
-- 15%–24% → Amarillo → "Efectividad media"
-- <15% → Rojo → "Bajo retorno del análisis"
-- N/A → Blanco → "No existieron ofertas de interés planeadas"
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'GREEN', 'GE', 25, NULL, 3, 'Alta Efectividad'
FROM `kpis` WHERE `code` = 'LIC_01'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_01') AND `color` = 'GREEN');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'YELLOW', 'BETWEEN', 15, 24.99, 2, 'Efectividad media'
FROM `kpis` WHERE `code` = 'LIC_01'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_01') AND `color` = 'YELLOW');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'RED', 'LT', 15, NULL, 1, 'Bajo retorno del análisis'
FROM `kpis` WHERE `code` = 'LIC_01'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_01') AND `color` = 'RED');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'WHITE', 'EQ', NULL, NULL, 0, 'No existieron ofertas de interés planeadas'
FROM `kpis` WHERE `code` = 'LIC_01'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_01') AND `color` = 'WHITE');

-- ----- LIC_02: Índice de Cobertura de Búsqueda de Oportunidades -----
-- ≥120% → Verde → "Búsqueda activa y bien cubierta"
-- 90%–119% → Amarillo → "Búsqueda suficiente pero limitada"
-- <90% → Rojo → "Déficit de prospección de oportunidades"
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'GREEN', 'GE', 120, NULL, 3, 'Búsqueda activa y bien cubierta'
FROM `kpis` WHERE `code` = 'LIC_02'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_02') AND `color` = 'GREEN');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'YELLOW', 'BETWEEN', 90, 119.99, 2, 'Búsqueda suficiente pero limitada'
FROM `kpis` WHERE `code` = 'LIC_02'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_02') AND `color` = 'YELLOW');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'RED', 'LT', 90, NULL, 1, 'Déficit de prospección de oportunidades'
FROM `kpis` WHERE `code` = 'LIC_02'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_02') AND `color` = 'RED');

-- ----- LIC_03: Índice de Ejecución de la Planeación de Ofertas -----
-- 90%–110% → Verde → "El área ejecuta de forma disciplinada lo que decide hacer."
-- 70%–89% → Amarillo → "Hubo ajustes razonables entre planeación e interés real."
-- <70% → Rojo → "Problema interno de priorización, control o capacidad."
-- N/A → Blanco → "Neutro, no se identificaron oportunidades alineadas al criterio de interés."
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'GREEN', 'BETWEEN', 90, 110, 3, 'El área ejecuta de forma disciplinada lo que decide hacer'
FROM `kpis` WHERE `code` = 'LIC_03'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_03') AND `color` = 'GREEN');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'YELLOW', 'BETWEEN', 70, 89.99, 2, 'Hubo ajustes razonables entre planeación e interés real. Requiere revisión de criterios'
FROM `kpis` WHERE `code` = 'LIC_03'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_03') AND `color` = 'YELLOW');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'RED', 'LT', 70, NULL, 1, 'Problema interno de priorización, control o capacidad. Requiere acción correctiva'
FROM `kpis` WHERE `code` = 'LIC_03'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_03') AND `color` = 'RED');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'WHITE', 'EQ', NULL, NULL, 0, 'Neutro, no se identificaron oportunidades alineadas al criterio de interés'
FROM `kpis` WHERE `code` = 'LIC_03'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_03') AND `color` = 'WHITE');

-- ----- LIC_04: Tiempo Promedio de Preparación de Ofertas -----
-- ≥5 ofertas y ≤10 días → Verde → "Proceso ágil"
-- ≥5 ofertas y 11–20 días → Amarillo → "Preparación moderada"
-- ≥5 ofertas y >20 días → Rojo → "Ineficiencia estructural"
-- <5 ofertas o sin interés → Blanco → "N/A, No medible"
-- NOTA: La validación del mínimo de 5 ofertas se maneja a nivel de na_rule / lógica de cálculo.
--       Los thresholds definen los rangos de días.
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'GREEN', 'LE', 10, NULL, 3, 'Proceso ágil (requiere ≥5 ofertas presentadas)'
FROM `kpis` WHERE `code` = 'LIC_04'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_04') AND `color` = 'GREEN');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'YELLOW', 'BETWEEN', 10.01, 20, 2, 'Preparación moderada (requiere ≥5 ofertas presentadas)'
FROM `kpis` WHERE `code` = 'LIC_04'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_04') AND `color` = 'YELLOW');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'RED', 'GT', 20, NULL, 1, 'Ineficiencia estructural (requiere ≥5 ofertas presentadas)'
FROM `kpis` WHERE `code` = 'LIC_04'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_04') AND `color` = 'RED');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'WHITE', 'EQ', NULL, NULL, 0, 'N/A, No medible — menos de 5 ofertas presentadas o sin interés'
FROM `kpis` WHERE `code` = 'LIC_04'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_04') AND `color` = 'WHITE');

-- ----- LIC_05: Índice de Documentación Vigente, Completa y Crítica -----
-- ≥95% → Verde → "Control documental sólido"
-- 85%–94% → Amarillo → "Riesgo documental medio"
-- <85% → Rojo → "Riesgo documental alto"
-- 0 ofertas presentadas → Blanco → "N/A, no hubo procesos que documentar"
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'GREEN', 'GE', 95, NULL, 3, 'Control documental sólido'
FROM `kpis` WHERE `code` = 'LIC_05'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_05') AND `color` = 'GREEN');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'YELLOW', 'BETWEEN', 85, 94.99, 2, 'Riesgo documental medio'
FROM `kpis` WHERE `code` = 'LIC_05'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_05') AND `color` = 'YELLOW');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'RED', 'LT', 85, NULL, 1, 'Riesgo documental alto'
FROM `kpis` WHERE `code` = 'LIC_05'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_05') AND `color` = 'RED');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'WHITE', 'EQ', NULL, NULL, 0, 'N/A, no hubo procesos que documentar'
FROM `kpis` WHERE `code` = 'LIC_05'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_05') AND `color` = 'WHITE');

-- ----- LIC_06: Gravedad relativa de fallas documentales -----
-- 0%–20% → Verde → "Predominan errores menores"
-- 21%–50% → Amarillo → "Riesgo documental moderado"
-- >50% → Rojo → "Riesgo documental alto"
-- 0 ofertas presentadas → Blanco → "N/A, no hubo procesos que documentar"
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'GREEN', 'LE', 20, NULL, 3, 'Predominan errores menores'
FROM `kpis` WHERE `code` = 'LIC_06'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_06') AND `color` = 'GREEN');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'YELLOW', 'BETWEEN', 20.01, 50, 2, 'Riesgo documental moderado'
FROM `kpis` WHERE `code` = 'LIC_06'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_06') AND `color` = 'YELLOW');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'RED', 'GT', 50, NULL, 1, 'Riesgo documental alto'
FROM `kpis` WHERE `code` = 'LIC_06'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_06') AND `color` = 'RED');

INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`)
SELECT id, 'WHITE', 'EQ', NULL, NULL, 0, 'N/A, no hubo procesos que documentar'
FROM `kpis` WHERE `code` = 'LIC_06'
AND NOT EXISTS (SELECT 1 FROM `kpi_thresholds` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_06') AND `color` = 'WHITE');

-- =====================================================
-- PASO 4: Inputs requeridos para KPIs de Licitaciones
-- =====================================================

-- LIC_01: Ofertas adjudicadas / Ofertas de interés
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_01'), 'ofertas_adjudicadas', 'Ofertas adjudicadas', 'NUMBER', 1, 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_01') AND `field_key` = 'ofertas_adjudicadas');

INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_01'), 'ofertas_interes', 'Ofertas de interés', 'NUMBER', 1, 2
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_01') AND `field_key` = 'ofertas_interes');

-- LIC_02: Ofertas identificadas / Ofertas planeadas
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_02'), 'ofertas_identificadas', 'Ofertas identificadas', 'NUMBER', 1, 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_02') AND `field_key` = 'ofertas_identificadas');

INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_02'), 'ofertas_planeadas', 'Ofertas planeadas a participar', 'NUMBER', 1, 2
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_02') AND `field_key` = 'ofertas_planeadas');

-- LIC_03: Ofertas presentadas / Ofertas planeadas a participar
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_03'), 'ofertas_presentadas', 'Ofertas presentadas', 'NUMBER', 1, 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_03') AND `field_key` = 'ofertas_presentadas');

INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_03'), 'ofertas_planeadas_participar', 'Ofertas planeadas a participar', 'NUMBER', 1, 2
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_03') AND `field_key` = 'ofertas_planeadas_participar');

-- LIC_04: Días de preparación / Ofertas presentadas (AVG)
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_04'), 'dias_preparacion', 'Días de preparación de la oferta', 'NUMBER', 1, 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_04') AND `field_key` = 'dias_preparacion');

-- LIC_05: Ofertas con documentación completa / Ofertas presentadas
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_05'), 'doc_completa_vigente', '¿Documentación completa y vigente?', 'BOOL', 1, 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_05') AND `field_key` = 'doc_completa_vigente');

-- LIC_06: Fallas críticas / (Fallas críticas + Fallas no críticas)
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_06'), 'fallas_criticas', 'Cantidad de fallas documentales críticas', 'NUMBER', 1, 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_06') AND `field_key` = 'fallas_criticas');

INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`)
SELECT (SELECT id FROM kpis WHERE code='LIC_06'), 'fallas_no_criticas', 'Cantidad de fallas documentales no críticas', 'NUMBER', 1, 2
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_required_inputs` WHERE `kpi_id` = (SELECT id FROM `kpis` WHERE `code` = 'LIC_06') AND `field_key` = 'fallas_no_criticas');

-- =====================================================
-- PASO 5: Categorías KPI para Licitaciones
-- (lo que el usuario selecciona en el dropdown de tareas)
-- =====================================================

INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`)
SELECT @area_lic_id, (SELECT id FROM kpis WHERE code='LIC_01'),
       'Índice de efectividad de Oportunidades',
       'LIC_EFECTIVIDAD_OPORTUNIDADES', 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_categories` WHERE `slug` = 'LIC_EFECTIVIDAD_OPORTUNIDADES');

INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`)
SELECT @area_lic_id, (SELECT id FROM kpis WHERE code='LIC_02'),
       'Índice de Cobertura de Búsqueda de Oportunidades',
       'LIC_COBERTURA_BUSQUEDA', 2
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_categories` WHERE `slug` = 'LIC_COBERTURA_BUSQUEDA');

INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`)
SELECT @area_lic_id, (SELECT id FROM kpis WHERE code='LIC_03'),
       'Índice de Ejecución de la Planeación de Ofertas',
       'LIC_EJECUCION_PLANEACION', 3
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_categories` WHERE `slug` = 'LIC_EJECUCION_PLANEACION');

INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`)
SELECT @area_lic_id, (SELECT id FROM kpis WHERE code='LIC_04'),
       'Tiempo Promedio de Preparación de Ofertas',
       'LIC_TIEMPO_PREPARACION', 4
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_categories` WHERE `slug` = 'LIC_TIEMPO_PREPARACION');

INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`)
SELECT @area_lic_id, (SELECT id FROM kpis WHERE code='LIC_05'),
       'Índice de Documentación Vigente, Completa y Crítica',
       'LIC_DOCUMENTACION_VIGENTE', 5
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_categories` WHERE `slug` = 'LIC_DOCUMENTACION_VIGENTE');

INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`)
SELECT @area_lic_id, (SELECT id FROM kpis WHERE code='LIC_06'),
       'Gravedad relativa de fallas documentales',
       'LIC_GRAVEDAD_FALLAS', 6
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `kpi_categories` WHERE `slug` = 'LIC_GRAVEDAD_FALLAS');

COMMIT;

-- =====================================================
-- VERIFICACIONES POST-MIGRACIÓN
-- Ejecutar manualmente para confirmar que todo está OK
-- =====================================================

-- 1. Verificar que el área LICITACIONES existe
-- SELECT * FROM areas WHERE code = 'LICITACIONES';

-- 2. Verificar los 6 KPIs
-- SELECT id, code, name, calc_kind, unit, formula_text FROM kpis WHERE code LIKE 'LIC_%' ORDER BY code;

-- 3. Verificar los thresholds de cada KPI
-- SELECT k.code, t.color, t.op, t.a, t.b, t.note
-- FROM kpi_thresholds t
-- JOIN kpis k ON k.id = t.kpi_id
-- WHERE k.code LIKE 'LIC_%'
-- ORDER BY k.code, t.priority DESC;

-- 4. Verificar las categorías KPI de Licitaciones
-- SELECT kc.id, kc.name, kc.slug, k.code AS kpi_code, a.name AS area_name
-- FROM kpi_categories kc
-- JOIN kpis k ON k.id = kc.kpi_id
-- JOIN areas a ON a.id = kc.area_id
-- WHERE a.code = 'LICITACIONES'
-- ORDER BY kc.sort_order;

-- 5. Verificar inputs requeridos
-- SELECT k.code, ri.field_key, ri.field_label, ri.field_type
-- FROM kpi_required_inputs ri
-- JOIN kpis k ON k.id = ri.kpi_id
-- WHERE k.code LIKE 'LIC_%'
-- ORDER BY k.code, ri.sort_order;
