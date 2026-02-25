-- Añadir columna observaciones a report_lines para el formulario de reportes ODS
-- Ejecutar una sola vez; si la columna ya existe, ignorar el error.
ALTER TABLE report_lines ADD COLUMN observations TEXT NULL AFTER accumulated_progress;
