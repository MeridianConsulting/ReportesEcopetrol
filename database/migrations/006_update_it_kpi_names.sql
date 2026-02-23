-- =====================================================
-- Migración 006: Actualizar nombres de KPIs de IT
-- Fecha: 2026-01-26
-- Descripción: Actualiza los nombres de los KPIs de IT según nueva nomenclatura
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- ACTUALIZAR NOMBRES EN TABLA kpis
-- =====================================================

-- IT_01: Continuidad Operativa de Servicios Críticos (Disponibilidad)
UPDATE `kpis` 
SET `name` = 'Continuidad Operativa de Servicios Críticos (Disponibilidad)',
    `updated_at` = NOW()
WHERE `code` = 'IT_01' 
  AND `name` != 'Continuidad Operativa de Servicios Críticos (Disponibilidad)';

-- IT_02: Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)
UPDATE `kpis` 
SET `name` = 'Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)',
    `updated_at` = NOW()
WHERE `code` = 'IT_02' 
  AND `name` != 'Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)';

-- IT_03: Entrega de Desarrollo y Automatización (Software)
UPDATE `kpis` 
SET `name` = 'Entrega de Desarrollo y Automatización (Software)',
    `updated_at` = NOW()
WHERE `code` = 'IT_03' 
  AND `name` != 'Entrega de Desarrollo y Automatización (Software)';

-- IT_04: Actualización de Documentación y Control de Activos IT
UPDATE `kpis` 
SET `name` = 'Actualización de Documentación y Control de Activos IT',
    `updated_at` = NOW()
WHERE `code` = 'IT_04' 
  AND `name` != 'Actualización de Documentación y Control de Activos IT';

-- IT_05: Eficiencia en Atención y Cierre de Soporte IT
UPDATE `kpis` 
SET `name` = 'Eficiencia en Atención y Cierre de Soporte IT',
    `updated_at` = NOW()
WHERE `code` = 'IT_05' 
  AND `name` != 'Eficiencia en Atención y Cierre de Soporte IT';

-- =====================================================
-- ACTUALIZAR NOMBRES EN TABLA kpi_categories
-- Usando JOIN para evitar problemas con subconsultas
-- =====================================================

-- IT_01: Continuidad Operativa de Servicios Críticos (Disponibilidad)
UPDATE `kpi_categories` kc
INNER JOIN `kpis` k ON kc.kpi_id = k.id
SET kc.`name` = 'Continuidad Operativa de Servicios Críticos (Disponibilidad)',
    kc.`updated_at` = NOW()
WHERE k.`code` = 'IT_01' 
  AND kc.`area_id` = 1
  AND kc.`name` != 'Continuidad Operativa de Servicios Críticos (Disponibilidad)';

-- IT_02: Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)
UPDATE `kpi_categories` kc
INNER JOIN `kpis` k ON kc.kpi_id = k.id
SET kc.`name` = 'Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)',
    kc.`updated_at` = NOW()
WHERE k.`code` = 'IT_02' 
  AND kc.`area_id` = 1
  AND kc.`name` != 'Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)';

-- IT_03: Entrega de Desarrollo y Automatización (Software)
UPDATE `kpi_categories` kc
INNER JOIN `kpis` k ON kc.kpi_id = k.id
SET kc.`name` = 'Entrega de Desarrollo y Automatización (Software)',
    kc.`updated_at` = NOW()
WHERE k.`code` = 'IT_03' 
  AND kc.`area_id` = 1
  AND kc.`name` != 'Entrega de Desarrollo y Automatización (Software)';

-- IT_04: Actualización de Documentación y Control de Activos IT
UPDATE `kpi_categories` kc
INNER JOIN `kpis` k ON kc.kpi_id = k.id
SET kc.`name` = 'Actualización de Documentación y Control de Activos IT',
    kc.`updated_at` = NOW()
WHERE k.`code` = 'IT_04' 
  AND kc.`area_id` = 1
  AND kc.`name` != 'Actualización de Documentación y Control de Activos IT';

-- IT_05: Eficiencia en Atención y Cierre de Soporte IT
UPDATE `kpi_categories` kc
INNER JOIN `kpis` k ON kc.kpi_id = k.id
SET kc.`name` = 'Eficiencia en Atención y Cierre de Soporte IT',
    kc.`updated_at` = NOW()
WHERE k.`code` = 'IT_05' 
  AND kc.`area_id` = 1
  AND kc.`name` != 'Eficiencia en Atención y Cierre de Soporte IT'
  AND (kc.`name` = 'Atención y Cierre de Incidentes' 
       OR kc.`name` = 'Atención y Cierre de Incidentes de Soporte'
       OR kc.`name` LIKE '%Atención y Cierre%');

COMMIT;
