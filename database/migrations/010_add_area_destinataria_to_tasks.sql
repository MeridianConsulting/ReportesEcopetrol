-- Añadir columna area_destinataria_id a tasks (área destinataria de la tarea).
-- Por defecto se asume el mismo valor que area_id si es null (compatibilidad).
-- Ejecutar en la base de datos. Si la columna ya existe, omitir.

ALTER TABLE `tasks`
  ADD COLUMN `area_destinataria_id` INT(11) NULL DEFAULT NULL COMMENT 'Área destinataria (si null, se asume area_id)'
  AFTER `area_id`;

ALTER TABLE `tasks`
  ADD CONSTRAINT `fk_tasks_area_destinataria`
  FOREIGN KEY (`area_destinataria_id`) REFERENCES `areas` (`id`)
  ON DELETE SET NULL ON UPDATE CASCADE;
