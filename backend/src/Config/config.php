<?php

require_once __DIR__ . '/../../vendor/autoload.php';

use Dotenv\Dotenv;

// Cargar variables de entorno (manejar si el archivo no existe)
try {
    $dotenv = Dotenv::createImmutable(__DIR__ . '/../..');
    $dotenv->load();
} catch (\Dotenv\Exception\InvalidPathException $e) {
    // Si el archivo .env no existe, usar valores por defecto
    // No hacer nada, las constantes usarán valores por defecto
}

// Detectar si estamos en localhost (desarrollo local)
$isLocalhost = ($_SERVER['SERVER_NAME'] ?? '') === 'localhost' ||
               ($_SERVER['HTTP_HOST'] ?? '') === 'localhost' ||
               (isset($_SERVER['HTTP_HOST']) && strpos($_SERVER['HTTP_HOST'], 'localhost') !== false) ||
               ($_SERVER['REMOTE_ADDR'] ?? '') === '127.0.0.1' ||
               ($_SERVER['REMOTE_ADDR'] ?? '') === '::1';

// Configuración de la aplicación
// En localhost, forzar modo local y debug activado
if ($isLocalhost) {
    define('APP_ENV', 'local');
    define('APP_DEBUG', true);
} else {
    define('APP_ENV', $_ENV['APP_ENV'] ?? 'local');
    define('APP_DEBUG', filter_var($_ENV['APP_DEBUG'] ?? true, FILTER_VALIDATE_BOOLEAN));
}

// Configuración de base de datos
// En localhost, usar credenciales por defecto de XAMPP
if ($isLocalhost) {
    define('DB_HOST', 'localhost');
    define('DB_NAME', 'tareas');
    define('DB_USER', 'root');
    define('DB_PASS', '');
} else {
    define('DB_HOST', $_ENV['DB_HOST'] ?? 'localhost');
    define('DB_NAME', $_ENV['DB_NAME'] ?? 'tareas');
    define('DB_USER', $_ENV['DB_USER'] ?? 'root');
    define('DB_PASS', $_ENV['DB_PASS'] ?? '');
}

// Configuración JWT
define('JWT_ALG', $_ENV['JWT_ALG'] ?? 'HS256');
define('JWT_SECRET', $_ENV['JWT_SECRET'] ?? 'super_secret_change_me_in_production');
define('JWT_ACCESS_TTL_MIN', (int)($_ENV['JWT_ACCESS_TTL_MIN'] ?? 15));
define('JWT_REFRESH_TTL_DAYS', (int)($_ENV['JWT_REFRESH_TTL_DAYS'] ?? 14));

// CORS - Detectar automáticamente si estamos en local
if ($isLocalhost) {
    $corsOrigin = 'http://localhost:3000';
} else {
    $corsOrigin = $_ENV['CORS_ORIGIN'] ?? 'http://localhost:3000';
}

define('CORS_ORIGIN', $corsOrigin);

// Timezone
date_default_timezone_set('America/Bogota');

// Rate Limiting
define('RATE_LIMIT_LOGIN_ATTEMPTS', (int)($_ENV['RATE_LIMIT_LOGIN_ATTEMPTS'] ?? 5));
define('RATE_LIMIT_LOGIN_WINDOW', (int)($_ENV['RATE_LIMIT_LOGIN_WINDOW'] ?? 15));

// Logging
define('LOG_LEVEL', $_ENV['LOG_LEVEL'] ?? 'INFO');
define('LOG_PATH', $_ENV['LOG_PATH'] ?? __DIR__ . '/../../storage/logs');

// Inicializar logger
\App\Services\Logger::init();

