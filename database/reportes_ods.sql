-- =========================================================
-- Base de datos: reportes_ods
-- =========================================================

CREATE DATABASE IF NOT EXISTS reportes_ods
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE reportes_ods;

-- =========================================================
-- Tablas de apoyo (requeridas por FK; la app puede usar las de otra BD)
-- =========================================================

CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS areas (
  id INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 0) Catálogos
-- =========================================================

CREATE TABLE IF NOT EXISTS employee_levels (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_employee_levels_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS service_classifications (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_service_classifications_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS delivery_media (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL, -- Digital, Físico, Link, etc.
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_delivery_media_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Soporte: texto libre o catálogo. Recomiendo catálogo + "otros".
CREATE TABLE IF NOT EXISTS support_types (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL, -- Informe, Código, Modelo, Presentación, Base de datos, etc.
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_support_types_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================================================
-- 1) Extensión de usuarios -> perfil de empleado (Excel database.xlsx)
-- =========================================================

CREATE TABLE IF NOT EXISTS employee_profiles (
  user_id INT NOT NULL,
  external_employee_id VARCHAR(50) DEFAULT NULL, -- el "Id" del excel si no coincide con users.id
  full_name VARCHAR(200) NOT NULL,
  corporate_email VARCHAR(150) DEFAULT NULL,
  phone VARCHAR(50) DEFAULT NULL,
  profession VARCHAR(120) DEFAULT NULL,
  job_title VARCHAR(120) DEFAULT NULL,       -- Cargo
  contract_type VARCHAR(120) DEFAULT NULL,   -- Contrato (texto del excel)
  hire_date DATE DEFAULT NULL,               -- Fecha_contrato
  contract_end_date DATE DEFAULT NULL,       -- Terminacion_contrato
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY uq_employee_profiles_email (corporate_email),
  KEY idx_employee_profiles_name (full_name),
  CONSTRAINT fk_employee_profiles_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================================================
-- 2) ODS / Orden de servicio
-- =========================================================

CREATE TABLE IF NOT EXISTS service_orders (
  id BIGINT NOT NULL AUTO_INCREMENT,
  ods_code VARCHAR(50) NOT NULL,           -- Ej: 90598918
  project_name VARCHAR(200) DEFAULT NULL,  -- Proyecto (del excel)
  area_id INT DEFAULT NULL,                -- si lo quieres amarrar a areas
  object_text TEXT DEFAULT NULL,           -- Objeto_ods
  term_text VARCHAR(200) DEFAULT NULL,     -- Plazo_ods (si viene como texto)
  start_date DATE DEFAULT NULL,
  end_date DATE DEFAULT NULL,
  status ENUM('Activa','Suspendida','Cerrada') NOT NULL DEFAULT 'Activa',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_service_orders_ods (ods_code),
  KEY idx_service_orders_area (area_id),
  KEY idx_service_orders_status (status),
  CONSTRAINT fk_service_orders_area
    FOREIGN KEY (area_id) REFERENCES areas(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS service_order_employees (
  id BIGINT NOT NULL AUTO_INCREMENT,
  service_order_id BIGINT NOT NULL,
  user_id INT NOT NULL,
  level_id INT DEFAULT NULL,                 -- Junior/Senior
  assignment_start DATE DEFAULT NULL,
  assignment_end DATE DEFAULT NULL,
  contracted_days INT DEFAULT NULL,          -- "Días contratados Acta de Inicio" (si aplica por persona)
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_ods_user_active (service_order_id, user_id, is_active),
  KEY idx_soe_user (user_id),
  KEY idx_soe_level (level_id),
  CONSTRAINT fk_soe_service_order
    FOREIGN KEY (service_order_id) REFERENCES service_orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_soe_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_soe_level
    FOREIGN KEY (level_id) REFERENCES employee_levels(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================================================
-- 3) Periodos y reportes
-- =========================================================

CREATE TABLE IF NOT EXISTS report_periods (
  id INT NOT NULL AUTO_INCREMENT,
  year SMALLINT NOT NULL,
  month TINYINT UNSIGNED NOT NULL, -- 1..12
  label VARCHAR(20) NOT NULL,      -- "2026-01"
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_report_periods_year_month (year, month),
  UNIQUE KEY uq_report_periods_label (label)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS reports (
  id BIGINT NOT NULL AUTO_INCREMENT,
  service_order_id BIGINT NOT NULL,
  period_id INT NOT NULL,
  reported_by INT NOT NULL, -- user que reporta (Nombre del profesional - Reporta)
  report_date DATE NOT NULL,
  service_classification_id INT DEFAULT NULL,
  status ENUM('Borrador','Enviado','En revision','Aprobado','Rechazado','Anulado')
    NOT NULL DEFAULT 'Borrador',
  month_contracted_days INT DEFAULT NULL, -- si hay un "días contratados" a nivel reporte (no por línea)
  notes TEXT DEFAULT NULL,
  deleted_at DATETIME DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_reports_unique (service_order_id, period_id, reported_by, deleted_at),
  KEY idx_reports_service_order (service_order_id),
  KEY idx_reports_period (period_id),
  KEY idx_reports_reported_by (reported_by),
  KEY idx_reports_status (status),
  KEY idx_reports_deleted (deleted_at),
  CONSTRAINT fk_reports_service_order
    FOREIGN KEY (service_order_id) REFERENCES service_orders(id),
  CONSTRAINT fk_reports_period
    FOREIGN KEY (period_id) REFERENCES report_periods(id),
  CONSTRAINT fk_reports_reported_by
    FOREIGN KEY (reported_by) REFERENCES users(id),
  CONSTRAINT fk_reports_classification
    FOREIGN KEY (service_classification_id) REFERENCES service_classifications(id)
      ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================================================
-- 4) Catálogo de ítems (recomendado)
-- =========================================================

CREATE TABLE IF NOT EXISTS report_item_catalog (
  id BIGINT NOT NULL AUTO_INCREMENT,
  item_general VARCHAR(20) NOT NULL,    -- "1", "2", "8"
  item_activity VARCHAR(20) NOT NULL,   -- "1.1", "1.15", etc.
  title VARCHAR(255) DEFAULT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_item_codes (item_general, item_activity),
  KEY idx_item_activity (item_activity)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================================================
-- 5) Líneas del reporte (actividades)
-- =========================================================

CREATE TABLE IF NOT EXISTS report_lines (
  id BIGINT NOT NULL AUTO_INCREMENT,
  report_id BIGINT NOT NULL,
  item_catalog_id BIGINT DEFAULT NULL,      -- si usas catálogo
  item_general VARCHAR(20) DEFAULT NULL,    -- respaldo si no hay catálogo / import legacy
  item_activity VARCHAR(20) DEFAULT NULL,
  activity_description TEXT NOT NULL,       -- Descripción de la actividad
  support_text TEXT DEFAULT NULL,           -- texto libre del excel (por si viene multilinea)
  support_type_id INT DEFAULT NULL,
  delivery_medium_id INT DEFAULT NULL,
  contracted_days INT DEFAULT NULL,         -- Días contratados (si aplica por línea)
  days_month DECIMAL(10,2) NOT NULL DEFAULT 0,     -- "Días" del mes
  progress_percent DECIMAL(6,4) NOT NULL DEFAULT 0, -- 0..1 o 0..100 (define y estandariza)
  accumulated_days DECIMAL(10,2) NOT NULL DEFAULT 0,
  accumulated_progress DECIMAL(6,4) NOT NULL DEFAULT 0,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_report_lines_report (report_id),
  KEY idx_report_lines_item (item_general, item_activity),
  KEY idx_report_lines_support_type (support_type_id),
  KEY idx_report_lines_delivery (delivery_medium_id),
  CONSTRAINT fk_report_lines_report
    FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE,
  CONSTRAINT fk_report_lines_item_catalog
    FOREIGN KEY (item_catalog_id) REFERENCES report_item_catalog(id) ON DELETE SET NULL,
  CONSTRAINT fk_report_lines_support_type
    FOREIGN KEY (support_type_id) REFERENCES support_types(id) ON DELETE SET NULL,
  CONSTRAINT fk_report_lines_delivery_medium
    FOREIGN KEY (delivery_medium_id) REFERENCES delivery_media(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================================================
-- 6) Adjuntos / evidencias
-- =========================================================

CREATE TABLE IF NOT EXISTS report_attachments (
  id BIGINT NOT NULL AUTO_INCREMENT,
  report_id BIGINT NOT NULL,
  report_line_id BIGINT DEFAULT NULL,
  uploaded_by INT NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  storage_path TEXT NOT NULL,           -- ruta/URL en tu storage
  mime_type VARCHAR(120) DEFAULT NULL,
  file_size BIGINT DEFAULT NULL,
  sha256 CHAR(64) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_report_attachments_report (report_id),
  KEY idx_report_attachments_line (report_line_id),
  KEY idx_report_attachments_uploaded_by (uploaded_by),
  CONSTRAINT fk_report_attachments_report
    FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE,
  CONSTRAINT fk_report_attachments_line
    FOREIGN KEY (report_line_id) REFERENCES report_lines(id) ON DELETE SET NULL,
  CONSTRAINT fk_report_attachments_uploaded_by
    FOREIGN KEY (uploaded_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================================================
-- 7) Comentarios / workflow / auditoría
-- =========================================================

CREATE TABLE IF NOT EXISTS report_comments (
  id BIGINT NOT NULL AUTO_INCREMENT,
  report_id BIGINT NOT NULL,
  report_line_id BIGINT DEFAULT NULL,
  user_id INT NOT NULL,
  comment TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_report_comments_report (report_id),
  KEY idx_report_comments_line (report_line_id),
  KEY idx_report_comments_user (user_id),
  CONSTRAINT fk_report_comments_report
    FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE,
  CONSTRAINT fk_report_comments_line
    FOREIGN KEY (report_line_id) REFERENCES report_lines(id) ON DELETE SET NULL,
  CONSTRAINT fk_report_comments_user
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS report_approvals (
  id BIGINT NOT NULL AUTO_INCREMENT,
  report_id BIGINT NOT NULL,
  approver_id INT NOT NULL,
  decision ENUM('Pendiente','Aprobado','Rechazado') NOT NULL DEFAULT 'Pendiente',
  decision_message TEXT DEFAULT NULL,
  decided_at DATETIME DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_report_approver (report_id, approver_id),
  KEY idx_report_approvals_decision (decision),
  CONSTRAINT fk_report_approvals_report
    FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE,
  CONSTRAINT fk_report_approvals_approver
    FOREIGN KEY (approver_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS report_events (
  id BIGINT NOT NULL AUTO_INCREMENT,
  report_id BIGINT NOT NULL,
  user_id INT DEFAULT NULL,
  event_type ENUM('CREATED','UPDATED','SUBMITTED','APPROVED','REJECTED','STATUS_CHANGED','IMPORTED','DELETED')
    NOT NULL,
  payload JSON DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_report_events_report (report_id),
  KEY idx_report_events_type (event_type),
  KEY idx_report_events_created_at (created_at),
  CONSTRAINT fk_report_events_report
    FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE,
  CONSTRAINT fk_report_events_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================================================
-- 8) Importación desde Excel (opcional pero MUY útil)
-- =========================================================

CREATE TABLE IF NOT EXISTS import_batches (
  id BIGINT NOT NULL AUTO_INCREMENT,
  source_name VARCHAR(255) NOT NULL, -- nombre del archivo
  imported_by INT NOT NULL,
  imported_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('Procesando','Exitoso','Con errores') NOT NULL DEFAULT 'Procesando',
  summary JSON DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_import_batches_imported_by (imported_by),
  CONSTRAINT fk_import_batches_user
    FOREIGN KEY (imported_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS import_errors (
  id BIGINT NOT NULL AUTO_INCREMENT,
  batch_id BIGINT NOT NULL,
  row_ref VARCHAR(50) DEFAULT NULL,
  message TEXT NOT NULL,
  raw_payload JSON DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_import_errors_batch (batch_id),
  CONSTRAINT fk_import_errors_batch
    FOREIGN KEY (batch_id) REFERENCES import_batches(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;