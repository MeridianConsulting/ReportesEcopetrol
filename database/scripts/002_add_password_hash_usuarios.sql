-- Añadir campo de contraseña a users (reportes_ods)
-- La contraseña de cada usuario será su cédula (external_employee_id en employee_profiles).
--
-- Pasos:
-- 1. Ejecutar este SQL (añade la columna):
--    mysql -u root reportes_ods < database/scripts/002_add_password_hash_usuarios.sql
--
-- 2. Ejecutar el script PHP para guardar la contraseña = cédula (hasheada):
--    cd backend && php scripts/set_passwords_from_cedula.php
--
-- Después, en el login: email = correo del usuario, contraseña = cédula del empleado.

USE reportes_ods;

ALTER TABLE `users`
  ADD COLUMN `password_hash` VARCHAR(255) DEFAULT NULL AFTER `email`;
