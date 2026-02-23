-- Rollback: quitar area_destinataria_id de tasks.
-- Ejecutar solo si se desea revertir la migración 010.

ALTER TABLE `tasks`
  DROP FOREIGN KEY `fk_tasks_area_destinataria`;

ALTER TABLE `tasks`
  DROP COLUMN `area_destinataria_id`;
