-- =====================================================
-- Migración 012: Asignar Laura Karina Gamez Gomez a
--               PETROSERVICIOS y LICITACIONES
-- Fecha: 2026-02-12
-- Descripción: Pobla la tabla user_areas para que Laura
--              pertenezca a ambas áreas y tenga acceso a
--              todos los KPIs de ambas (5 PROY + 6 LIC = 11 KPIs).
-- IDEMPOTENTE: Usa INSERT IGNORE y verificaciones previas.
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Obtener IDs necesarios
SET @laura_id = (SELECT id FROM users WHERE name LIKE '%LAURA KARINA GAMEZ GOMEZ%' LIMIT 1);
SET @petroservicios_id = (SELECT id FROM areas WHERE code = 'PETROSERVICIOS' LIMIT 1);
SET @licitaciones_id = (SELECT id FROM areas WHERE code = 'LICITACIONES' LIMIT 1);

-- Verificar que se encontraron los registros
-- Si no se encuentra alguno, los INSERTs simplemente no harán nada (por el NOT EXISTS)

-- =====================================================
-- PASO 1: Insertar relación Laura → PETROSERVICIOS (principal)
-- =====================================================
INSERT INTO `user_areas` (`user_id`, `area_id`, `is_primary`)
SELECT @laura_id, @petroservicios_id, 1
FROM DUAL
WHERE @laura_id IS NOT NULL 
  AND @petroservicios_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM `user_areas` 
    WHERE `user_id` = @laura_id AND `area_id` = @petroservicios_id
  );

-- =====================================================
-- PASO 2: Insertar relación Laura → LICITACIONES (secundaria)
-- =====================================================
INSERT INTO `user_areas` (`user_id`, `area_id`, `is_primary`)
SELECT @laura_id, @licitaciones_id, 0
FROM DUAL
WHERE @laura_id IS NOT NULL 
  AND @licitaciones_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM `user_areas` 
    WHERE `user_id` = @laura_id AND `area_id` = @licitaciones_id
  );

COMMIT;

-- =====================================================
-- VERIFICACIÓN POST-MIGRACIÓN
-- =====================================================

-- Verificar que Laura tiene ambas áreas
-- SELECT u.name, ua.area_id, ua.is_primary, a.name as area_name
-- FROM user_areas ua
-- JOIN users u ON u.id = ua.user_id
-- JOIN areas a ON a.id = ua.area_id
-- WHERE u.name LIKE '%LAURA KARINA GAMEZ GOMEZ%'
-- ORDER BY ua.is_primary DESC;

-- Verificar KPIs disponibles para Laura (combinando ambas áreas)
-- SELECT a.name AS area, k.code, kc.name AS kpi_category
-- FROM kpi_categories kc
-- JOIN kpis k ON k.id = kc.kpi_id
-- JOIN areas a ON a.id = kc.area_id
-- WHERE kc.area_id IN (
--   SELECT area_id FROM user_areas ua
--   JOIN users u ON u.id = ua.user_id
--   WHERE u.name LIKE '%LAURA KARINA GAMEZ GOMEZ%'
-- )
-- ORDER BY a.name, kc.sort_order;
