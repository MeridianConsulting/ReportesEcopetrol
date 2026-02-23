-- =====================================================
-- Migración 004: Agregar KPIs Administrativos al área IT
-- Fecha: 2026-01-19
-- Descripción: IT también usa los mismos KPIs de Gestión Administrativa
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- Categorías KPI Administrativas para IT (area_id = 1)
-- Reutiliza los mismos KPIs ADM_01 a ADM_05
-- =====================================================

INSERT INTO `kpi_categories` (`area_id`, `kpi_id`, `name`, `slug`, `sort_order`) VALUES
(1, (SELECT id FROM kpis WHERE code='ADM_01'), 'Cumplimiento SLA IT', 'IT_CUMPLIMIENTO_SLA', 1),
(1, (SELECT id FROM kpis WHERE code='ADM_02'), 'Lead Time de atención IT', 'IT_LEAD_TIME', 2),
(1, (SELECT id FROM kpis WHERE code='ADM_03'), 'Calidad documental IT', 'IT_CALIDAD_DOCUMENTAL', 3),
(1, (SELECT id FROM kpis WHERE code='ADM_04'), 'Exactitud de inventario IT', 'IT_EXACTITUD_INVENTARIO', 4),
(1, (SELECT id FROM kpis WHERE code='ADM_05'), 'Satisfacción cliente interno IT', 'IT_CSAT', 5);

COMMIT;
