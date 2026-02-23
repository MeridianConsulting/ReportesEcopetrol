-- Consulta para vaciar todas las tareas de todas las personas
-- Las tablas relacionadas (task_assignments, task_comments, task_events, 
-- task_evidences, task_kpi_facts, task_kpi_inputs) se eliminarán automáticamente
-- debido a las restricciones FOREIGN KEY con ON DELETE CASCADE

DELETE FROM tasks;

-- Si quieres también resetear el AUTO_INCREMENT:
-- ALTER TABLE tasks AUTO_INCREMENT = 1;
