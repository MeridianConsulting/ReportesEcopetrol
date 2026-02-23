-- Insertar una tarea de ejemplo por cada área (todas con área responsable IT).
-- Cada fila tiene área destinataria distinta (1 a 10) para probar la gráfica de destinatarios.
-- Ejecutar en la base de datos: mysql -u root -p tareas < insert_tarea_ejemplo_por_area.sql
-- Requiere la migración 010 (columna area_destinataria_id). Si no la tienes, quita esa columna del INSERT.

USE tareas;

INSERT INTO `tasks` (
  `area_id`,
  `area_destinataria_id`,
  `title`,
  `description`,
  `type`,
  `priority`,
  `status`,
  `progress_percent`,
  `responsible_id`,
  `created_by`,
  `start_date`,
  `due_date`,
  `kpi_category_id`,
  `kpi_subcategory`,
  `closed_date`,
  `deleted_at`
) VALUES
(1, 1, 'Tarea de ejemplo IT - destino IT', 'Tarea de ejemplo área responsable IT, destinataria IT.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 2, 'Tarea de ejemplo IT - destino Administración', 'Tarea de ejemplo área responsable IT, destinataria Administración.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 3, 'Tarea de ejemplo IT - destino HSEQ', 'Tarea de ejemplo área responsable IT, destinataria HSEQ.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 4, 'Tarea de ejemplo IT - destino Proyecto Frontera', 'Tarea de ejemplo área responsable IT, destinataria Proyecto Frontera.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 5, 'Tarea de ejemplo IT - destino CW', 'Tarea de ejemplo área responsable IT, destinataria CW.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 6, 'Tarea de ejemplo IT - destino Petroservicios', 'Tarea de ejemplo área responsable IT, destinataria Petroservicios.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 7, 'Tarea de ejemplo IT - destino Contabilidad', 'Tarea de ejemplo área responsable IT, destinataria Contabilidad.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 8, 'Tarea de ejemplo IT - destino Gestión Humana', 'Tarea de ejemplo área responsable IT, destinataria Gestión Humana.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 9, 'Tarea de ejemplo IT - destino Gerencia', 'Tarea de ejemplo área responsable IT, destinataria Gerencia.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL),
(1, 10, 'Tarea de ejemplo IT - destino Proyectos', 'Tarea de ejemplo área responsable IT, destinataria Proyectos.', 'Operativa', 'Media', 'No iniciada', 0, 32, 32, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, NULL, NULL, NULL);
