-- =====================================================
-- Migración 005b: Limpieza de categorías duplicadas de IT
-- Fecha: 2026-01-20
-- Descripción: Elimina categorías KPI antiguas de IT y deja solo las nuevas
-- EJECUTAR DESPUÉS DE 005_it_specific_kpis.sql
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Primero, veamos qué tenemos actualmente para IT (area_id = 1)
-- SELECT * FROM kpi_categories WHERE area_id = 1;

-- =====================================================
-- PASO 1: Eliminar TODAS las categorías de IT que NO sean de los nuevos KPIs
-- Los nuevos KPIs son IT_01 a IT_05
-- =====================================================

-- Eliminar categorías de IT que apuntan a KPIs que NO empiezan con 'IT_'
DELETE kc FROM kpi_categories kc
INNER JOIN kpis k ON kc.kpi_id = k.id
WHERE kc.area_id = 1 
  AND k.code NOT LIKE 'IT_%';

-- =====================================================
-- PASO 2: Verificar que solo quedaron las categorías correctas
-- Debería mostrar solo 5 categorías con códigos IT_01 a IT_05
-- =====================================================
-- SELECT kc.id, kc.name, kc.slug, k.code as kpi_code 
-- FROM kpi_categories kc
-- INNER JOIN kpis k ON kc.kpi_id = k.id
-- WHERE kc.area_id = 1;

COMMIT;
