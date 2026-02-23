-- =====================================================
-- Seed: Catálogo de 25 KPIs por Área
-- Fecha: 2026-01-19
-- Descripción: Inserta los KPIs definidos en los documentos
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- ÁREA CONTABLE (5 KPIs) - CONT_01 a CONT_05
-- Fuente: Indicadores Area contable 2026.pdf
-- =====================================================

INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`) VALUES
('CONT_01', 'Registro oportuno de documentos', 'Evalúa el porcentaje de documentos registrados dentro del tiempo establecido', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Registrados a tiempo / Recibidos × 100', 0),
('CONT_02', 'Cumplimiento de conciliaciones', 'Evalúa el porcentaje de conciliaciones bancarias realizadas a tiempo', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Conciliaciones a tiempo / Conciliaciones programadas × 100', 0),
('CONT_03', 'Gestión de cuentas por pagar', 'Evalúa el cumplimiento en la gestión de pagos a proveedores', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Pagos realizados a tiempo / Pagos programados × 100', 0),
('CONT_04', 'Calidad de información contable', 'Evalúa la calidad de los reportes contables sin ajustes', 'RATIO_SUM', 'PERCENT', 'CLOSED_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Reportes sin ajustes / Reportes emitidos × 100', 0),
('CONT_05', 'Cumplimiento obligaciones tributarias', 'Evalúa el cumplimiento de obligaciones tributarias en tiempo', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Obligaciones cumplidas a tiempo / Obligaciones del periodo × 100', 0);

-- Thresholds Contable
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
-- CONT_01: >=95 verde; 85-94 amarillo; <85 rojo
((SELECT id FROM kpis WHERE code='CONT_01'), 'GREEN', 'GE', 95, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='CONT_01'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, NULL),
((SELECT id FROM kpis WHERE code='CONT_01'), 'RED', 'LT', 85, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='CONT_01'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si no hay actividad'),

-- CONT_02: >=95 verde; 85-94 amarillo; <85 rojo
((SELECT id FROM kpis WHERE code='CONT_02'), 'GREEN', 'GE', 95, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='CONT_02'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, NULL),
((SELECT id FROM kpis WHERE code='CONT_02'), 'RED', 'LT', 85, NULL, 1, NULL),

-- CONT_03: >=90 verde; 80-89 amarillo; <80 rojo
((SELECT id FROM kpis WHERE code='CONT_03'), 'GREEN', 'GE', 90, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='CONT_03'), 'YELLOW', 'BETWEEN', 80, 89.99, 2, NULL),
((SELECT id FROM kpis WHERE code='CONT_03'), 'RED', 'LT', 80, NULL, 1, NULL),

-- CONT_04: >=95 verde; 85-94 amarillo; <85 rojo
((SELECT id FROM kpis WHERE code='CONT_04'), 'GREEN', 'GE', 95, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='CONT_04'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, NULL),
((SELECT id FROM kpis WHERE code='CONT_04'), 'RED', 'LT', 85, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='CONT_04'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si no hay actividad'),

-- CONT_05: Inconsistencia en rangos - marcado como pendiente
((SELECT id FROM kpis WHERE code='CONT_05'), 'GREEN', 'GE', 95, NULL, 3, 'Rangos pendientes de corrección - documento muestra inconsistencia'),
((SELECT id FROM kpis WHERE code='CONT_05'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, 'PENDIENTE: documento muestra Amarillo 100-90 y Rojo >90 (solapados)'),
((SELECT id FROM kpis WHERE code='CONT_05'), 'RED', 'LT', 85, NULL, 1, NULL);

UPDATE `kpi_thresholds` SET `is_pending` = 1 WHERE `kpi_id` = (SELECT id FROM kpis WHERE code='CONT_05');

-- Inputs requeridos Contable
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`) VALUES
((SELECT id FROM kpis WHERE code='CONT_04'), 'sin_ajustes', '¿Reporte sin ajustes?', 'BOOL', 1, 1);

-- =====================================================
-- ÁREA PROYECTOS (5 KPIs) - PROY_01 a PROY_05
-- Aplicados a 3 subáreas: Petroservicios, Frontera, CW
-- Fuente: Indicadores de Proyectos 2026.pdf
-- =====================================================

INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`) VALUES
('PROY_01', 'Cumplimiento de facturación', 'Evalúa el cumplimiento de facturación vs servicios ejecutados', 'RATIO_SUM', 'PERCENT', 'CLOSED_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Facturación realizada / Servicios ejecutados × 100', 0),
('PROY_02', 'Entrega de informes operativos', 'Evalúa la entrega oportuna de informes de operación', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Informes entregados a tiempo / Informes programados × 100', 0),
('PROY_03', 'Requisitos contables y financieros', 'Evalúa la entrega oportuna de requisitos contables/financieros', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Requisitos entregados a tiempo / Requisitos programados × 100', 0),
('PROY_04', 'Cumplimiento de contratación', 'Evalúa la gestión de contratación de personal', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Personal contratado a tiempo / Requerimientos de personal × 100', 0),
('PROY_05', 'Pago a proveedores', 'Evalúa el cumplimiento de pagos a proveedores en tiempo', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Pagos a tiempo / Pagos programados × 100', 0);

-- Thresholds Proyectos
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
-- PROY_01: >=85 verde; 70-84 amarillo; <70 rojo
((SELECT id FROM kpis WHERE code='PROY_01'), 'GREEN', 'GE', 85, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='PROY_01'), 'YELLOW', 'BETWEEN', 70, 84.99, 2, NULL),
((SELECT id FROM kpis WHERE code='PROY_01'), 'RED', 'LT', 70, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='PROY_01'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si no hay actividad'),

-- PROY_02: >=90 verde; 80-89 amarillo; <80 rojo
((SELECT id FROM kpis WHERE code='PROY_02'), 'GREEN', 'GE', 90, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='PROY_02'), 'YELLOW', 'BETWEEN', 80, 89.99, 2, NULL),
((SELECT id FROM kpis WHERE code='PROY_02'), 'RED', 'LT', 80, NULL, 1, NULL),

-- PROY_03: >=90 verde; 80-89 amarillo; <80 rojo
((SELECT id FROM kpis WHERE code='PROY_03'), 'GREEN', 'GE', 90, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='PROY_03'), 'YELLOW', 'BETWEEN', 80, 89.99, 2, NULL),
((SELECT id FROM kpis WHERE code='PROY_03'), 'RED', 'LT', 80, NULL, 1, NULL),

-- PROY_04: >=95 verde; 85-94 amarillo; <85 rojo
((SELECT id FROM kpis WHERE code='PROY_04'), 'GREEN', 'GE', 95, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='PROY_04'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, NULL),
((SELECT id FROM kpis WHERE code='PROY_04'), 'RED', 'LT', 85, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='PROY_04'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si no hay actividad'),

-- PROY_05: Inconsistencia en rangos - marcado como pendiente
((SELECT id FROM kpis WHERE code='PROY_05'), 'GREEN', 'GE', 90, NULL, 3, 'Rangos pendientes de corrección'),
((SELECT id FROM kpis WHERE code='PROY_05'), 'YELLOW', 'BETWEEN', 80, 89.99, 2, 'PENDIENTE: documento muestra Amarillo 90-80 y Rojo >80 (solapados)'),
((SELECT id FROM kpis WHERE code='PROY_05'), 'RED', 'LT', 80, NULL, 1, NULL);

UPDATE `kpi_thresholds` SET `is_pending` = 1 WHERE `kpi_id` = (SELECT id FROM kpis WHERE code='PROY_05');

-- Inputs requeridos Proyectos
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`) VALUES
((SELECT id FROM kpis WHERE code='PROY_01'), 'facturacion_realizada', 'Valor facturado', 'NUMBER', 0, 1),
((SELECT id FROM kpis WHERE code='PROY_01'), 'servicios_ejecutados', 'Servicios ejecutados', 'NUMBER', 0, 2);

-- =====================================================
-- ÁREA GESTIÓN ADMINISTRATIVA (5 KPIs) - ADM_01 a ADM_05
-- Fuente: Indicadores_Gestion_Admin_formato_ref.pdf
-- =====================================================

INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `target_value`, `is_inverted`) VALUES
('ADM_01', 'Cumplimiento SLA', 'Evalúa el cumplimiento de solicitudes dentro del SLA', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Solicitudes atendidas en SLA / Total solicitudes × 100', NULL, 0),
('ADM_02', 'Lead Time de atención', 'Evalúa el tiempo promedio de atención de solicitudes', 'AVG', 'HOURS', 'CLOSED_DATE', 'NA_IF_NO_DATA', 'Promedio(Tiempo de respuesta en horas)', 24, 1),
('ADM_03', 'Calidad documental', 'Evalúa la calidad de documentos al primer envío', 'RATIO_SUM', 'PERCENT', 'CLOSED_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Documentos OK al primer envío / Documentos emitidos × 100', NULL, 0),
('ADM_04', 'Exactitud de inventario', 'Evalúa la precisión del control de inventario', 'RATIO_SUM', 'PERCENT', 'CLOSED_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Ítems sin diferencia / Ítems verificados × 100', NULL, 0),
('ADM_05', 'Satisfacción del cliente interno', 'Evalúa la satisfacción del cliente interno (CSAT)', 'AVG', 'RATING_1_5', 'CLOSED_DATE', 'NA_IF_NO_DATA', 'Promedio(Calificación 1-5)', NULL, 0);

-- Thresholds Administrativa
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
-- ADM_01: >=95 verde; 85-94 amarillo; <85 rojo
((SELECT id FROM kpis WHERE code='ADM_01'), 'GREEN', 'GE', 95, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='ADM_01'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, NULL),
((SELECT id FROM kpis WHERE code='ADM_01'), 'RED', 'LT', 85, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='ADM_01'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si no hay actividad'),

-- ADM_02: Lead time basado en objetivo configurable (default 24h)
-- <=Objetivo verde; Objetivo-1.2*Objetivo amarillo; >1.2*Objetivo rojo
((SELECT id FROM kpis WHERE code='ADM_02'), 'GREEN', 'LE', 24, NULL, 3, 'Basado en objetivo configurable'),
((SELECT id FROM kpis WHERE code='ADM_02'), 'YELLOW', 'BETWEEN', 24.01, 28.8, 2, '1.2x del objetivo'),
((SELECT id FROM kpis WHERE code='ADM_02'), 'RED', 'GT', 28.8, NULL, 1, NULL),

-- ADM_03: >=98 verde; 90-97 amarillo; <90 rojo
((SELECT id FROM kpis WHERE code='ADM_03'), 'GREEN', 'GE', 98, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='ADM_03'), 'YELLOW', 'BETWEEN', 90, 97.99, 2, NULL),
((SELECT id FROM kpis WHERE code='ADM_03'), 'RED', 'LT', 90, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='ADM_03'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si no hay actividad'),

-- ADM_04: >=98 verde; 95-97 amarillo; <95 rojo
((SELECT id FROM kpis WHERE code='ADM_04'), 'GREEN', 'GE', 98, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='ADM_04'), 'YELLOW', 'BETWEEN', 95, 97.99, 2, NULL),
((SELECT id FROM kpis WHERE code='ADM_04'), 'RED', 'LT', 95, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='ADM_04'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si no hay actividad'),

-- ADM_05: >=4.5 verde; 4.0-4.4 amarillo; <4.0 rojo
((SELECT id FROM kpis WHERE code='ADM_05'), 'GREEN', 'GE', 4.5, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='ADM_05'), 'YELLOW', 'BETWEEN', 4.0, 4.49, 2, NULL),
((SELECT id FROM kpis WHERE code='ADM_05'), 'RED', 'LT', 4.0, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='ADM_05'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si no hay actividad');

-- Inputs requeridos Administrativa
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`) VALUES
((SELECT id FROM kpis WHERE code='ADM_03'), 'primer_envio_ok', '¿Primer envío OK?', 'BOOL', 1, 1),
((SELECT id FROM kpis WHERE code='ADM_05'), 'csat_rating', 'Calificación (1-5)', 'RATING_1_5', 1, 1);

-- =====================================================
-- ÁREA HSEQ (5 KPIs) - HSEQ_01 a HSEQ_05
-- Fuente: INDICADORES_HSEQ.docx
-- NOTA: Solo se definen metas, no intervalos amarillo/rojo
-- =====================================================

INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `target_value`, `is_inverted`) VALUES
('HSEQ_01', 'Cumplimiento del programa HSEQ', 'Evalúa el cumplimiento de actividades programadas HSEQ', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Actividades ejecutadas / Actividades programadas × 100', 95, 0),
('HSEQ_02', 'Cierre de acciones correctivas', 'Evalúa el cierre oportuno de acciones correctivas', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Acciones cerradas en plazo / Acciones generadas × 100', 90, 0),
('HSEQ_03', 'Investigación de incidentes', 'Evalúa la investigación oportuna de incidentes', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Incidentes investigados a tiempo / Incidentes reportados × 100', 100, 0),
('HSEQ_04', 'Entrega de informes HSEQ', 'Evalúa la entrega de informes a tiempo y aprobados', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Informes a tiempo y aprobados / Informes programados × 100', 95, 0),
('HSEQ_05', 'Cumplimiento de capacitaciones', 'Evalúa el cumplimiento del plan de capacitaciones HSEQ', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Capacitaciones ejecutadas / Capacitaciones programadas × 100', 90, 0);

-- Thresholds HSEQ - Solo meta (verde si cumple, sin amarillo/rojo definidos en documento)
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
-- HSEQ_01: Meta 95%
((SELECT id FROM kpis WHERE code='HSEQ_01'), 'GREEN', 'GE', 95, NULL, 3, 'Meta definida en documento'),
((SELECT id FROM kpis WHERE code='HSEQ_01'), 'YELLOW', 'BETWEEN', 80, 94.99, 2, 'Amarillo no definido en documento - provisional'),
((SELECT id FROM kpis WHERE code='HSEQ_01'), 'RED', 'LT', 80, NULL, 1, 'Rojo no definido en documento - provisional'),

-- HSEQ_02: Meta 90%
((SELECT id FROM kpis WHERE code='HSEQ_02'), 'GREEN', 'GE', 90, NULL, 3, 'Meta definida en documento'),
((SELECT id FROM kpis WHERE code='HSEQ_02'), 'YELLOW', 'BETWEEN', 75, 89.99, 2, 'Amarillo no definido en documento - provisional'),
((SELECT id FROM kpis WHERE code='HSEQ_02'), 'RED', 'LT', 75, NULL, 1, 'Rojo no definido en documento - provisional'),

-- HSEQ_03: Meta 100%
((SELECT id FROM kpis WHERE code='HSEQ_03'), 'GREEN', 'GE', 100, NULL, 3, 'Meta definida en documento'),
((SELECT id FROM kpis WHERE code='HSEQ_03'), 'YELLOW', 'BETWEEN', 90, 99.99, 2, 'Amarillo no definido en documento - provisional'),
((SELECT id FROM kpis WHERE code='HSEQ_03'), 'RED', 'LT', 90, NULL, 1, 'Rojo no definido en documento - provisional'),

-- HSEQ_04: Meta 95%
((SELECT id FROM kpis WHERE code='HSEQ_04'), 'GREEN', 'GE', 95, NULL, 3, 'Meta definida en documento'),
((SELECT id FROM kpis WHERE code='HSEQ_04'), 'YELLOW', 'BETWEEN', 80, 94.99, 2, 'Amarillo no definido en documento - provisional'),
((SELECT id FROM kpis WHERE code='HSEQ_04'), 'RED', 'LT', 80, NULL, 1, 'Rojo no definido en documento - provisional'),

-- HSEQ_05: Meta 90%
((SELECT id FROM kpis WHERE code='HSEQ_05'), 'GREEN', 'GE', 90, NULL, 3, 'Meta definida en documento'),
((SELECT id FROM kpis WHERE code='HSEQ_05'), 'YELLOW', 'BETWEEN', 75, 89.99, 2, 'Amarillo no definido en documento - provisional'),
((SELECT id FROM kpis WHERE code='HSEQ_05'), 'RED', 'LT', 75, NULL, 1, 'Rojo no definido en documento - provisional');

-- Inputs requeridos HSEQ
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`) VALUES
((SELECT id FROM kpis WHERE code='HSEQ_04'), 'aprobado', '¿Informe aprobado?', 'BOOL', 1, 1);

-- =====================================================
-- ÁREA GESTIÓN HUMANA (5 KPIs) - GH_01 a GH_05
-- Fuente: KPIS GENERALES – ÁREA DE GESTIÓN HUMANA.docx
-- =====================================================

INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`, `requires_period_input`) VALUES
('GH_01', 'Cumplimiento del plan de GH', 'Evalúa el cumplimiento de actividades programadas de GH', 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Actividades ejecutadas / Actividades programadas × 100', 0, 0),
('GH_02', 'Exactitud de nómina', 'Evalúa la exactitud en la liquidación de nómina', 'RATIO_SUM', 'PERCENT', 'CLOSED_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Nóminas sin reproceso / Nóminas liquidadas × 100', 0, 0),
('GH_03', 'Índice de rotación', 'Evalúa la rotación de personal', 'RATIO_SUM', 'PERCENT', 'CLOSED_DATE', 'NA_IF_DENOMINATOR_ZERO', 'Salidas del periodo / Promedio colaboradores × 100', 1, 1),
('GH_04', 'Índice de ausentismo', 'Evalúa el ausentismo laboral', 'RATIO_SUM', 'PERCENT', 'CREATED_AT', 'NA_IF_DENOMINATOR_ZERO', 'Tiempo ausencia / Tiempo programado × 100', 1, 1),
('GH_05', 'Tiempo de respuesta a requerimientos', 'Evalúa el tiempo promedio de respuesta a solicitudes', 'AVG', 'DAYS', 'CLOSED_DATE', 'NA_IF_NO_DATA', 'Σ Tiempo respuesta / Total requerimientos', 1, 0);

-- Thresholds Gestión Humana
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
-- GH_01: >=95 verde; 85-94 amarillo; <85 rojo
((SELECT id FROM kpis WHERE code='GH_01'), 'GREEN', 'GE', 95, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='GH_01'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, NULL),
((SELECT id FROM kpis WHERE code='GH_01'), 'RED', 'LT', 85, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='GH_01'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si 0 programadas'),

-- GH_02: >=98 verde; 95-97 amarillo; <95 rojo
((SELECT id FROM kpis WHERE code='GH_02'), 'GREEN', 'GE', 98, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='GH_02'), 'YELLOW', 'BETWEEN', 95, 97.99, 2, NULL),
((SELECT id FROM kpis WHERE code='GH_02'), 'RED', 'LT', 95, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='GH_02'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si 0 liquidadas'),

-- GH_03: <=2.5 verde; 2.6-4.0 amarillo; >4.0 rojo (invertido)
((SELECT id FROM kpis WHERE code='GH_03'), 'GREEN', 'LE', 2.5, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='GH_03'), 'YELLOW', 'BETWEEN', 2.51, 4.0, 2, NULL),
((SELECT id FROM kpis WHERE code='GH_03'), 'RED', 'GT', 4.0, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='GH_03'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si 0 promedio colaboradores'),

-- GH_04: <=3.0 verde; 3.1-5.0 amarillo; >5.0 rojo (invertido)
((SELECT id FROM kpis WHERE code='GH_04'), 'GREEN', 'LE', 3.0, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='GH_04'), 'YELLOW', 'BETWEEN', 3.01, 5.0, 2, NULL),
((SELECT id FROM kpis WHERE code='GH_04'), 'RED', 'GT', 5.0, NULL, 1, NULL),
((SELECT id FROM kpis WHERE code='GH_04'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A si 0 tiempo programado'),

-- GH_05: <=3 días verde; 3.1-5 días amarillo; >5 días rojo (invertido)
((SELECT id FROM kpis WHERE code='GH_05'), 'GREEN', 'LE', 3, NULL, 3, NULL),
((SELECT id FROM kpis WHERE code='GH_05'), 'YELLOW', 'BETWEEN', 3.01, 5.0, 2, NULL),
((SELECT id FROM kpis WHERE code='GH_05'), 'RED', 'GT', 5.0, NULL, 1, NULL);

-- Inputs requeridos Gestión Humana
INSERT INTO `kpi_required_inputs` (`kpi_id`, `field_key`, `field_label`, `field_type`, `is_required`, `sort_order`) VALUES
((SELECT id FROM kpis WHERE code='GH_02'), 'sin_reproceso', '¿Sin reproceso?', 'BOOL', 1, 1);

-- =====================================================
-- CATEGORÍAS KPI (lo que el usuario selecciona)
-- Cada área tiene sus 5 categorías
-- Proyectos tiene 3 subáreas × 5 KPIs = 15 categorías
-- =====================================================

-- Categorías Contable (area_id = 7)
INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(7, (SELECT id FROM kpis WHERE code='CONT_01'), 'Registro oportuno de documentos', 'CONT_REGISTRO_OPORTUNO', 1),
(7, (SELECT id FROM kpis WHERE code='CONT_02'), 'Cumplimiento de conciliaciones', 'CONT_CONCILIACIONES', 2),
(7, (SELECT id FROM kpis WHERE code='CONT_03'), 'Gestión de cuentas por pagar', 'CONT_CUENTAS_PAGAR', 3),
(7, (SELECT id FROM kpis WHERE code='CONT_04'), 'Calidad de información contable', 'CONT_CALIDAD_INFO', 4),
(7, (SELECT id FROM kpis WHERE code='CONT_05'), 'Obligaciones tributarias', 'CONT_OBLIGACIONES_TRIB', 5);

-- Categorías Gestión Administrativa (area_id = 2)
INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(2, (SELECT id FROM kpis WHERE code='ADM_01'), 'Cumplimiento SLA', 'ADM_CUMPLIMIENTO_SLA', 1),
(2, (SELECT id FROM kpis WHERE code='ADM_02'), 'Lead Time de atención', 'ADM_LEAD_TIME', 2),
(2, (SELECT id FROM kpis WHERE code='ADM_03'), 'Calidad documental', 'ADM_CALIDAD_DOCUMENTAL', 3),
(2, (SELECT id FROM kpis WHERE code='ADM_04'), 'Exactitud de inventario', 'ADM_EXACTITUD_INVENTARIO', 4),
(2, (SELECT id FROM kpis WHERE code='ADM_05'), 'Satisfacción cliente interno', 'ADM_CSAT', 5);

-- Categorías HSEQ (area_id = 3)
INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(3, (SELECT id FROM kpis WHERE code='HSEQ_01'), 'Cumplimiento programa HSEQ', 'HSEQ_CUMPLIMIENTO_PROGRAMA', 1),
(3, (SELECT id FROM kpis WHERE code='HSEQ_02'), 'Cierre acciones correctivas', 'HSEQ_ACCIONES_CORRECTIVAS', 2),
(3, (SELECT id FROM kpis WHERE code='HSEQ_03'), 'Investigación de incidentes', 'HSEQ_INVESTIGACION', 3),
(3, (SELECT id FROM kpis WHERE code='HSEQ_04'), 'Entrega de informes HSEQ', 'HSEQ_INFORMES', 4),
(3, (SELECT id FROM kpis WHERE code='HSEQ_05'), 'Cumplimiento capacitaciones', 'HSEQ_CAPACITACIONES', 5);

-- Categorías Gestión Humana (area_id = 8)
INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(8, (SELECT id FROM kpis WHERE code='GH_01'), 'Cumplimiento plan GH', 'GH_CUMPLIMIENTO_PLAN', 1),
(8, (SELECT id FROM kpis WHERE code='GH_02'), 'Exactitud de nómina', 'GH_EXACTITUD_NOMINA', 2),
(8, (SELECT id FROM kpis WHERE code='GH_03'), 'Índice de rotación', 'GH_ROTACION', 3),
(8, (SELECT id FROM kpis WHERE code='GH_04'), 'Índice de ausentismo', 'GH_AUSENTISMO', 4),
(8, (SELECT id FROM kpis WHERE code='GH_05'), 'Tiempo respuesta requerimientos', 'GH_TIEMPO_RESPUESTA', 5);

-- Categorías Proyectos - PETROSERVICIOS (area_id = 6)
INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(6, (SELECT id FROM kpis WHERE code='PROY_01'), 'Facturación Petroservicios', 'PROY_PETRO_FACTURACION', 1),
(6, (SELECT id FROM kpis WHERE code='PROY_02'), 'Informes operativos Petroservicios', 'PROY_PETRO_INFORMES', 2),
(6, (SELECT id FROM kpis WHERE code='PROY_03'), 'Requisitos contables Petroservicios', 'PROY_PETRO_REQUISITOS', 3),
(6, (SELECT id FROM kpis WHERE code='PROY_04'), 'Contratación Petroservicios', 'PROY_PETRO_CONTRATACION', 4),
(6, (SELECT id FROM kpis WHERE code='PROY_05'), 'Pago proveedores Petroservicios', 'PROY_PETRO_PAGOS', 5);

-- Categorías Proyectos - FRONTERA (area_id = 4)
INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(4, (SELECT id FROM kpis WHERE code='PROY_01'), 'Facturación Frontera', 'PROY_FRONT_FACTURACION', 1),
(4, (SELECT id FROM kpis WHERE code='PROY_02'), 'Informes operativos Frontera', 'PROY_FRONT_INFORMES', 2),
(4, (SELECT id FROM kpis WHERE code='PROY_03'), 'Requisitos contables Frontera', 'PROY_FRONT_REQUISITOS', 3),
(4, (SELECT id FROM kpis WHERE code='PROY_04'), 'Contratación Frontera', 'PROY_FRONT_CONTRATACION', 4),
(4, (SELECT id FROM kpis WHERE code='PROY_05'), 'Pago proveedores Frontera', 'PROY_FRONT_PAGOS', 5);

-- Categorías Proyectos - CW (area_id = 5)
INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(5, (SELECT id FROM kpis WHERE code='PROY_01'), 'Facturación CW', 'PROY_CW_FACTURACION', 1),
(5, (SELECT id FROM kpis WHERE code='PROY_02'), 'Informes operativos CW', 'PROY_CW_INFORMES', 2),
(5, (SELECT id FROM kpis WHERE code='PROY_03'), 'Requisitos contables CW', 'PROY_CW_REQUISITOS', 3),
(5, (SELECT id FROM kpis WHERE code='PROY_04'), 'Contratación CW', 'PROY_CW_CONTRATACION', 4),
(5, (SELECT id FROM kpis WHERE code='PROY_05'), 'Pago proveedores CW', 'PROY_CW_PAGOS', 5);

COMMIT;
