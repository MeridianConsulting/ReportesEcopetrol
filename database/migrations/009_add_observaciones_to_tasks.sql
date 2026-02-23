-- Añadir columna observaciones a tasks (para mostrar en my-tasks).
-- Si la columna ya existe, omitir este script o comentar el ALTER.

ALTER TABLE `tasks`
  ADD COLUMN `observaciones` TEXT DEFAULT NULL COMMENT 'Observaciones de la tarea'
  AFTER `progress_percent`;
