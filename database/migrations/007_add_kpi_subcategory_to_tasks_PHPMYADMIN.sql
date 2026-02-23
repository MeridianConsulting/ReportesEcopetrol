-- =====================================================
-- Script para copiar y pegar en phpMyAdmin
-- Agregar campo kpi_subcategory a tabla tasks
-- =====================================================
-- INSTRUCCIONES:
-- 1. Abre phpMyAdmin
-- 2. Selecciona tu base de datos (tareas)
-- 3. Ve a la pestaña "SQL"
-- 4. Copia y pega TODO este contenido
-- 5. Haz clic en "Continuar" o "Ejecutar"
-- =====================================================

ALTER TABLE `tasks` 
ADD COLUMN `kpi_subcategory` VARCHAR(200) NULL COMMENT 'Subcategoría del KPI (solo para área IT)' 
AFTER `kpi_category_id`;

ALTER TABLE `tasks`
ADD INDEX `idx_tasks_kpi_subcategory` (`kpi_subcategory`);
