-- Permitir texto libre de medio de entrega en report_lines (cuando el usuario escribe en lugar de elegir del catálogo)
ALTER TABLE report_lines
  ADD COLUMN delivery_medium_custom_text VARCHAR(255) NULL AFTER delivery_medium_id;
