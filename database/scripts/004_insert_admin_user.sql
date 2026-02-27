    -- Insertar usuario administrador (base reportes_ods).
    -- Contraseña: password
    -- Ejecutar: mysql -u root reportes_ods < database/scripts/004_insert_admin_user.sql

    INSERT INTO users (email, password_hash) VALUES
    ('admin@reportes.local', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

    INSERT INTO user_roles (user_id, role_id) VALUES
    (LAST_INSERT_ID(), 5);

    -- Asociar admin con ODS 90045724 (PETROSERVICIOS, id=1)
    INSERT INTO service_order_employees (service_order_id, user_id, level_id, assignment_start, assignment_end, contracted_days, is_active, created_at)
    SELECT 1, u.id, NULL, NULL, NULL, NULL, 1, NOW()
    FROM users u WHERE u.email = 'admin@reportes.local' LIMIT 1;

