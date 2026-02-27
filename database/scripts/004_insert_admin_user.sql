-- Insertar usuario administrador (base reportes_ods).
-- Contraseña: password
-- Ejecutar: mysql -u root reportes_ods < database/scripts/004_insert_admin_user.sql

INSERT INTO users (email, password_hash) VALUES
('admin@reportes.local', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

INSERT INTO user_roles (user_id, role_id) VALUES
(LAST_INSERT_ID(), 5);


-- Crea un usuario con email: admin@reportes.local
-- Contraseña: password

