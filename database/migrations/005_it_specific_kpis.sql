-- =====================================================
-- Migración 005: KPIs Específicos para Área de Soporte IT
-- Fecha: 2026-01-20
-- Descripción: Reemplaza los KPIs administrativos de IT por 
--              indicadores específicos de funcionamiento interno
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- PASO 1: Eliminar categorías KPI antiguas de IT (area_id = 1)
-- =====================================================
DELETE FROM `kpi_categories` WHERE `area_id` = 1;

-- =====================================================
-- PASO 2: Insertar los 5 KPIs específicos de IT
-- Fuente: INDICADORES – AREA SOPORTE IT (FUNCIONAMIENTO INTERNO)
-- =====================================================

INSERT INTO `kpis` (`code`, `name`, `description`, `calc_kind`, `unit`, `period_anchor`, `na_rule`, `formula_text`, `is_inverted`) VALUES
('IT_01', 'Continuidad Operativa de Servicios Críticos (Disponibilidad)', 
 'Evalúa la continuidad operativa y correcto funcionamiento de los servicios tecnológicos críticos de la organización. Variables: SIIGO, cámaras de seguridad, repositorio documental, documentación de apoyo, backups.', 
 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 
 'Servicios críticos operativos / Servicios críticos planificados × 100', 0),

('IT_02', 'Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)', 
 'Evalúa la ejecución oportuna del mantenimiento preventivo de los activos tecnológicos. Variables: Portátiles, impresoras, plotter y servidores.', 
 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 
 'Mantenimientos ejecutados / Mantenimientos programados × 100', 0),

('IT_03', 'Entrega de Desarrollo y Automatización (Software)', 
 'Evalúa el avance y cumplimiento de los desarrollos tecnológicos definidos por la organización. Variables: Página web, sistemas de información, automatizaciones y mejoras de software.', 
 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 
 'Desarrollos finalizados / Desarrollos planificados × 100', 0),

('IT_04', 'Actualización de Documentación y Control de Activos IT', 
 'Evalúa el nivel de organización, trazabilidad y actualización de la información técnica del área IT. Variables: Inventario de equipos, fichas técnicas, instructivos de uso, documentación de soporte.', 
 'RATIO_SUM', 'PERCENT', 'DUE_DATE', 'NA_IF_DENOMINATOR_ZERO', 
 'Documentos actualizados / Documentos requeridos × 100', 0),

('IT_05', 'Eficiencia en Atención y Cierre de Soporte IT', 
 'Evalúa la capacidad de respuesta y efectividad en la atención de requerimientos e incidentes tecnológicos.', 
 'RATIO_SUM', 'PERCENT', 'CLOSED_DATE', 'NA_IF_DENOMINATOR_ZERO', 
 'Incidentes cerrados / Incidentes reportados × 100', 0);

-- =====================================================
-- PASO 3: Thresholds para IT_01 - Disponibilidad Servidores
-- ≥95% Verde | 85%-94.99% Amarillo | <85% Rojo | N/A Blanco
-- =====================================================
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
((SELECT id FROM kpis WHERE code='IT_01'), 'GREEN', 'GE', 95, NULL, 3, 'Servicios estables y operación tecnológica continua'),
((SELECT id FROM kpis WHERE code='IT_01'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, 'Fallas menores, requiere seguimiento preventivo'),
((SELECT id FROM kpis WHERE code='IT_01'), 'RED', 'LT', 85, NULL, 1, 'Riesgo operativo y pérdida de información'),
((SELECT id FROM kpis WHERE code='IT_01'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A - No hubo servicios críticos planificados en el periodo');

-- =====================================================
-- PASO 4: Thresholds para IT_02 - Mantenimiento Infraestructura
-- ≥90% Verde | 80%-89.99% Amarillo | <80% Rojo
-- =====================================================
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
((SELECT id FROM kpis WHERE code='IT_02'), 'GREEN', 'GE', 90, NULL, 3, 'Infraestructura en condiciones óptimas'),
((SELECT id FROM kpis WHERE code='IT_02'), 'YELLOW', 'BETWEEN', 80, 89.99, 2, 'Retrasos controlados en mantenimiento'),
((SELECT id FROM kpis WHERE code='IT_02'), 'RED', 'LT', 80, NULL, 1, 'Alto riesgo de fallas técnicas');

-- =====================================================
-- PASO 5: Thresholds para IT_03 - Desarrollo y Automatización
-- ≥90% Verde | 80%-89.99% Amarillo | <80% Rojo
-- =====================================================
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
((SELECT id FROM kpis WHERE code='IT_03'), 'GREEN', 'GE', 90, NULL, 3, 'Cumplimiento efectivo del plan de desarrollo'),
((SELECT id FROM kpis WHERE code='IT_03'), 'YELLOW', 'BETWEEN', 80, 89.99, 2, 'Avance parcial, requiere ajustes'),
((SELECT id FROM kpis WHERE code='IT_03'), 'RED', 'LT', 80, NULL, 1, 'Retrasos significativos en desarrollo');

-- =====================================================
-- PASO 6: Thresholds para IT_04 - Documentación Técnica
-- ≥95% Verde | 85%-94.99% Amarillo | <85% Rojo | N/A Blanco
-- =====================================================
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
((SELECT id FROM kpis WHERE code='IT_04'), 'GREEN', 'GE', 95, NULL, 3, 'Documentación completa y actualizada'),
((SELECT id FROM kpis WHERE code='IT_04'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, 'Actualizaciones pendientes menores'),
((SELECT id FROM kpis WHERE code='IT_04'), 'RED', 'LT', 85, NULL, 1, 'Falta de control documental técnico'),
((SELECT id FROM kpis WHERE code='IT_04'), 'WHITE', 'EQ', NULL, NULL, 0, 'N/A - No hubo documentación requerida');

-- =====================================================
-- PASO 7: Thresholds para IT_05 - Cierre de Incidentes
-- ≥95% Verde | 85%-94.99% Amarillo | <85% Rojo
-- =====================================================
INSERT INTO `kpi_thresholds` (`kpi_id`, `color`, `op`, `a`, `b`, `priority`, `note`) VALUES
((SELECT id FROM kpis WHERE code='IT_05'), 'GREEN', 'GE', 95, NULL, 3, 'Soporte oportuno y eficiente'),
((SELECT id FROM kpis WHERE code='IT_05'), 'YELLOW', 'BETWEEN', 85, 94.99, 2, 'Atención aceptable, requiere mejora'),
((SELECT id FROM kpis WHERE code='IT_05'), 'RED', 'LT', 85, NULL, 1, 'Saturación del soporte y riesgo operativo');

-- =====================================================
-- PASO 8: Crear categorías KPI para IT (area_id = 1)
-- =====================================================
INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(1, (SELECT id FROM kpis WHERE code='IT_01'), 'Continuidad Operativa de Servicios Críticos (Disponibilidad)', 'IT_DISPONIBILIDAD_SERVIDORES', 1),
(1, (SELECT id FROM kpis WHERE code='IT_02'), 'Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)', 'IT_MANTENIMIENTO_INFRAESTRUCTURA', 2),
(1, (SELECT id FROM kpis WHERE code='IT_03'), 'Entrega de Desarrollo y Automatización (Software)', 'IT_DESARROLLO_AUTOMATIZACION', 3),
(1, (SELECT id FROM kpis WHERE code='IT_04'), 'Actualización de Documentación y Control de Activos IT', 'IT_DOCUMENTACION_TECNICA', 4),
(1, (SELECT id FROM kpis WHERE code='IT_05'), 'Eficiencia en Atención y Cierre de Soporte IT', 'IT_CIERRE_INCIDENTES', 5);

-- =====================================================
-- NOTA GENERAL: Los indicadores en estado Blanco (N/A) 
-- no afectan la evaluación del área cuando no existen 
-- actividades planificadas y/o asociadas.
-- =====================================================

COMMIT;
