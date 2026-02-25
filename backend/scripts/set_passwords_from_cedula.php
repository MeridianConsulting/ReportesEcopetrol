<?php

/**
 * Establece la contraseña de cada usuario = su cédula (external_employee_id).
 * Ejecutar una vez después de añadir la columna password_hash a users:
 *   cd backend && php scripts/set_passwords_from_cedula.php
 *
 * Requiere: ALTER TABLE users ADD COLUMN password_hash VARCHAR(255);
 */

$autoload = null;
if (is_file(__DIR__ . '/../vendor/autoload.php')) {
  $autoload = __DIR__ . '/../vendor/autoload.php';
} elseif (is_file(__DIR__ . '/../../vendor/autoload.php')) {
  $autoload = __DIR__ . '/../../vendor/autoload.php';
}
if (!$autoload) {
  fwrite(STDERR, "Error: No se encontró vendor/autoload.php.\n");
  fwrite(STDERR, "  Desde backend ejecuta: composer install\n");
  fwrite(STDERR, "  Luego: php scripts/set_passwords_from_cedula.php\n");
  exit(1);
}
require_once $autoload;

$db = null;
if (class_exists('App\Core\Database')) {
  try {
    require_once __DIR__ . '/../src/Config/config.php';
    $db = \App\Core\Database::getInstance()->getConnection();
  } catch (Throwable $e) {
    // config puede fallar si vendor está en otra ruta
  }
}
if (!$db) {
  $baseDir = is_file(__DIR__ . '/../vendor/autoload.php') ? __DIR__ . '/..' : __DIR__ . '/../..';
  if (class_exists('Dotenv\Dotenv')) {
    try {
      $dotenv = Dotenv\Dotenv::createImmutable($baseDir);
      $dotenv->load();
    } catch (Throwable $e) {
      // ignorar si no hay .env
    }
  }
  $host = $_ENV['DB_HOST'] ?? 'localhost';
  $name = $_ENV['DB_NAME'] ?? 'reportes_ods';
  $user = $_ENV['DB_USER'] ?? 'root';
  $pass = $_ENV['DB_PASS'] ?? '';
  $dsn = "mysql:host=$host;dbname=$name;charset=utf8mb4";
  $db = new PDO($dsn, $user, $pass, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  ]);
}

$stmt = $db->query("
  SELECT u.id, ep.external_employee_id AS cedula
  FROM users u
  INNER JOIN employee_profiles ep ON ep.user_id = u.id
  WHERE ep.external_employee_id IS NOT NULL AND ep.external_employee_id != ''
");
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

$updateStmt = $db->prepare("UPDATE users SET password_hash = :hash WHERE id = :id");

$ok = 0;
$skip = 0;
foreach ($rows as $row) {
  $cedula = trim($row['cedula']);
  if ($cedula === '') {
    $skip++;
    continue;
  }
  $hash = password_hash($cedula, PASSWORD_DEFAULT);
  $updateStmt->execute([':hash' => $hash, ':id' => $row['id']]);
  $ok++;
}

echo "Actualizados: $ok usuarios (contraseña = cédula). Omitidos: $skip.\n";
