-- =====================================================
-- Migración 007: Agregar campo kpi_subcategory a tabla tasks
-- Fecha: 2026-01-26
-- Descripción: Agrega el campo kpi_subcategory para almacenar subcategorías de KPIs de IT
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- AGREGAR CAMPO kpi_subcategory A TABLA tasks
-- =====================================================

ALTER TABLE `tasks` 
ADD COLUMN `kpi_subcategory` VARCHAR(200) NULL COMMENT 'Subcategoría del KPI (solo para área IT)' 
AFTER `kpi_category_id`;

-- =====================================================
-- AGREGAR ÍNDICE PARA OPTIMIZAR CONSULTAS
-- =====================================================

ALTER TABLE `tasks`
ADD INDEX `idx_tasks_kpi_subcategory` (`kpi_subcategory`);

COMMIT;
