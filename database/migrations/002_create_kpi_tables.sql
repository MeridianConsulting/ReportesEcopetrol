-- =====================================================
-- Migración: Sistema de KPIs para Gestión de Tareas
-- Fecha: 2026-01-19
-- Descripción: Crea las tablas necesarias para el sistema de KPIs
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- 1. TABLA: kpis (Catálogo de KPIs)
-- Define el KPI "conceptual": nombre, fórmula, tipo de cálculo
-- =====================================================
CREATE TABLE IF NOT EXISTS `kpis` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Código único (ej: CONT_01, PROY_05)',
  `name` VARCHAR(150) NOT NULL COMMENT 'Nombre del KPI',
  `description` TEXT NULL COMMENT 'Qué evalúa este KPI',
  `calc_kind` ENUM('RATIO_SUM', 'AVG') NOT NULL DEFAULT 'RATIO_SUM' COMMENT 'Tipo de cálculo: RATIO_SUM (numerador/denominador) o AVG (promedio)',
  `unit` ENUM('PERCENT', 'HOURS', 'DAYS', 'RATING_1_5', 'COUNT') NOT NULL DEFAULT 'PERCENT' COMMENT 'Unidad de medida',
  `period_anchor` ENUM('CREATED_AT', 'DUE_DATE', 'CLOSED_DATE') NOT NULL DEFAULT 'DUE_DATE' COMMENT 'Campo para determinar el periodo',
  `na_rule` ENUM('NA_IF_DENOMINATOR_ZERO', 'NA_IF_NO_DATA', 'ALWAYS_SHOW') NOT NULL DEFAULT 'NA_IF_DENOMINATOR_ZERO' COMMENT 'Regla para N/A (Blanco)',
  `formula_text` VARCHAR(500) NULL COMMENT 'Fórmula legible (para mostrar al usuario)',
  `target_value` DECIMAL(10,2) NULL COMMENT 'Valor objetivo/meta configurable',
  `is_inverted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 si menor es mejor (ej: Rotación, Ausentismo)',
  `requires_period_input` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 si requiere inputs externos por periodo',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_kpis_code` (`code`),
  INDEX `idx_kpis_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- 2. TABLA: kpi_thresholds (Semáforo por KPI)
-- Define los rangos de colores para cada KPI
-- =====================================================
CREATE TABLE IF NOT EXISTS `kpi_thresholds` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `kpi_id` INT NOT NULL,
  `color` ENUM('GREEN', 'YELLOW', 'RED', 'WHITE') NOT NULL COMMENT 'Color del semáforo',
  `op` ENUM('GE', 'GT', 'LE', 'LT', 'BETWEEN', 'EQ') NOT NULL COMMENT 'Operador: GE(>=), GT(>), LE(<=), LT(<), BETWEEN, EQ(=)',
  `a` DECIMAL(10,2) NULL COMMENT 'Valor A (límite inferior o único)',
  `b` DECIMAL(10,2) NULL COMMENT 'Valor B (límite superior, solo para BETWEEN)',
  `priority` INT NOT NULL DEFAULT 0 COMMENT 'Orden de evaluación (mayor = más prioritario)',
  `note` VARCHAR(255) NULL COMMENT 'Nota o texto original del documento (para inconsistencias)',
  `is_pending` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 si requiere corrección',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`kpi_id`) REFERENCES `kpis`(`id`) ON DELETE CASCADE,
  INDEX `idx_thresholds_kpi` (`kpi_id`),
  INDEX `idx_thresholds_priority` (`kpi_id`, `priority` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- 3. TABLA: kpi_categories (Categoría KPI - lo que el usuario selecciona)
-- Liga área + KPI y es lo que aparece en el dropdown
-- =====================================================
CREATE TABLE IF NOT EXISTS `kpi_categories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `area_id` INT NOT NULL COMMENT 'Área asociada',
  `kpi_id` INT NOT NULL COMMENT 'KPI que mide',
  `name` VARCHAR(150) NOT NULL COMMENT 'Nombre visible al usuario',
  `slug` VARCHAR(100) NOT NULL UNIQUE COMMENT 'Identificador único para seeds',
  `description` TEXT NULL COMMENT 'Descripción extendida',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `sort_order` INT NOT NULL DEFAULT 0 COMMENT 'Orden de visualización',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`area_id`) REFERENCES `areas`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`kpi_id`) REFERENCES `kpis`(`id`) ON DELETE CASCADE,
  INDEX `idx_categories_area` (`area_id`),
  INDEX `idx_categories_kpi` (`kpi_id`),
  INDEX `idx_categories_active` (`is_active`),
  INDEX `idx_categories_area_active` (`area_id`, `is_active`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- 4. TABLA: task_kpi_facts (Medición por tarea)
-- Almacena el cálculo de cada tarea para el KPI
-- =====================================================
CREATE TABLE IF NOT EXISTS `task_kpi_facts` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `task_id` INT NOT NULL,
  `kpi_id` INT NOT NULL,
  `area_id` INT NOT NULL COMMENT 'Redundante para consultas rápidas',
  `period_key` CHAR(7) NOT NULL COMMENT 'YYYY-MM del periodo',
  `numerator` DECIMAL(12,4) NOT NULL DEFAULT 0 COMMENT 'Numerador para RATIO_SUM',
  `denominator` DECIMAL(12,4) NOT NULL DEFAULT 0 COMMENT 'Denominador para RATIO_SUM',
  `sample_value` DECIMAL(12,4) NULL COMMENT 'Valor para AVG',
  `is_applicable` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0 si la tarea no aplica para el KPI',
  `na_reason` VARCHAR(100) NULL COMMENT 'Razón si no es aplicable',
  `meta_json` LONGTEXT NULL COMMENT 'Auditoría: inputs usados en el cálculo',
  `computed_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`kpi_id`) REFERENCES `kpis`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`area_id`) REFERENCES `areas`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uk_task_kpi_period` (`task_id`, `kpi_id`, `period_key`),
  INDEX `idx_facts_area_period_kpi` (`area_id`, `period_key`, `kpi_id`),
  INDEX `idx_facts_kpi_period` (`kpi_id`, `period_key`),
  INDEX `idx_facts_applicable` (`is_applicable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- 5. TABLA: task_kpi_inputs (Inputs adicionales por tarea)
-- Para campos que no salen de fechas/estado
-- =====================================================
CREATE TABLE IF NOT EXISTS `task_kpi_inputs` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `task_id` INT NOT NULL,
  `field_key` VARCHAR(50) NOT NULL COMMENT 'Clave del campo (ej: primer_envio_ok, csat_rating)',
  `value_bool` TINYINT(1) NULL COMMENT 'Valor booleano',
  `value_number` DECIMAL(12,4) NULL COMMENT 'Valor numérico',
  `value_text` VARCHAR(500) NULL COMMENT 'Valor texto',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uk_task_field` (`task_id`, `field_key`),
  INDEX `idx_inputs_field` (`field_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- 6. TABLA: kpi_period_inputs (Inputs por periodo)
-- Para denominadores externos (GH: headcount, horas programadas)
-- =====================================================
CREATE TABLE IF NOT EXISTS `kpi_period_inputs` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `area_id` INT NOT NULL,
  `kpi_id` INT NOT NULL,
  `period_key` CHAR(7) NOT NULL COMMENT 'YYYY-MM',
  `field_key` VARCHAR(50) NOT NULL COMMENT 'Clave del campo (ej: avg_headcount, planned_work_hours)',
  `value_number` DECIMAL(12,4) NOT NULL COMMENT 'Valor numérico',
  `note` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`area_id`) REFERENCES `areas`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`kpi_id`) REFERENCES `kpis`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uk_area_kpi_period_field` (`area_id`, `kpi_id`, `period_key`, `field_key`),
  INDEX `idx_period_inputs_lookup` (`area_id`, `period_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- 7. TABLA: kpi_required_inputs (Campos requeridos por categoría KPI)
-- Define qué inputs necesita cada categoría
-- =====================================================
CREATE TABLE IF NOT EXISTS `kpi_required_inputs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `kpi_id` INT NOT NULL,
  `field_key` VARCHAR(50) NOT NULL,
  `field_label` VARCHAR(100) NOT NULL COMMENT 'Etiqueta para mostrar en UI',
  `field_type` ENUM('BOOL', 'NUMBER', 'RATING_1_5', 'TEXT') NOT NULL DEFAULT 'BOOL',
  `is_required` TINYINT(1) NOT NULL DEFAULT 1,
  `default_value` VARCHAR(50) NULL,
  `sort_order` INT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`kpi_id`) REFERENCES `kpis`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uk_kpi_field` (`kpi_id`, `field_key`),
  INDEX `idx_required_inputs_kpi` (`kpi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- 8. MODIFICAR TABLA tasks: Agregar kpi_category_id
-- =====================================================
ALTER TABLE `tasks` 
ADD COLUMN `kpi_category_id` INT NULL COMMENT 'Categoría KPI seleccionada' AFTER `due_date`,
ADD INDEX `idx_tasks_kpi_category` (`kpi_category_id`),
ADD CONSTRAINT `fk_tasks_kpi_category` 
  FOREIGN KEY (`kpi_category_id`) REFERENCES `kpi_categories`(`id`) ON DELETE SET NULL;

-- =====================================================
-- 9. ACTUALIZAR jerarquía de áreas para Proyectos
-- Crear área padre "PROYECTOS" y actualizar subáreas
-- =====================================================

-- Primero crear el área padre PROYECTOS
INSERT INTO `areas` (`id`, `name`, `code`, `type`, `parent_id`, `is_active`, `created_at`) VALUES
(10, 'PROYECTOS', 'PROYECTOS', 'AREA', NULL, 1, NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Actualizar áreas hijas con parent_id = PROYECTOS
UPDATE `areas` SET `parent_id` = 10 WHERE `code` IN ('FRONTERA', 'PETROSERVICIOS', 'CW');

COMMIT;
