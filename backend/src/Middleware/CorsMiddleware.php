<?php

namespace App\Middleware;

use App\Core\Request;
use App\Core\Response;

class CorsMiddleware
{
  public function handle(Request $request, callable $next)
  {
    $requestOrigin = $request->getHeader('Origin');
    $allowedOrigins = defined('CORS_ALLOWED_ORIGINS') ? CORS_ALLOWED_ORIGINS : [CORS_ORIGIN];

    // Responder con el mismo origen si está en la lista blanca
    if ($requestOrigin && in_array($requestOrigin, $allowedOrigins)) {
      $origin = $requestOrigin;
    } elseif (defined('APP_ENV') && APP_ENV === 'local' && $requestOrigin && (
      strpos($requestOrigin, 'http://localhost') === 0 ||
      strpos($requestOrigin, 'http://127.0.0.1') === 0
    )) {
      // En desarrollo, permitir cualquier localhost
      $origin = $requestOrigin;
    } else {
      $origin = CORS_ORIGIN;
    }
    
    $method = $request->getMethod();

    // Handle preflight OPTIONS request
    if ($method === 'OPTIONS') {
      $response = Response::json([], 204);
      $response
        ->header('Access-Control-Allow-Origin', $origin)
        ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH')
        ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-CSRF-Token, Accept')
        ->header('Access-Control-Allow-Credentials', 'true')
        ->header('Access-Control-Max-Age', '86400');
      return $response;
    }

    // Handle actual request
    $response = $next($request);

    if ($response instanceof Response) {
      $response
        ->header('Access-Control-Allow-Origin', $origin)
        ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH')
        ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-CSRF-Token, Accept')
        ->header('Access-Control-Allow-Credentials', 'true')
        ->header('X-Developed-By', 'Jose Mateo Lopez Cifuentes');
    }

    return $response;
  }
}

