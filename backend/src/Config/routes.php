<?php

use App\Controllers\AuthController;
use App\Controllers\TaskController;
use App\Controllers\UserController;
use App\Controllers\AreaController;
use App\Controllers\ReportController;
use App\Controllers\TaskAssignmentController;
use App\Controllers\KpiController;
use App\Middleware\CorsMiddleware;
use App\Middleware\JwtAuthMiddleware;
use App\Middleware\RoleMiddleware;
use App\Middleware\RateLimitMiddleware;

return [
  // Global middleware
  'middleware' => [
    CorsMiddleware::class,
  ],

  // Rutas públicas
  'routes' => [
    // Health check (sin rate limiting)
    ['GET', '/api/v1/health', [AuthController::class, 'health']],
    // Login con rate limiting
    ['POST', '/api/v1/auth/login', [AuthController::class, 'login'], [RateLimitMiddleware::class]],
    ['POST', '/api/v1/auth/refresh', [AuthController::class, 'refresh']],
  ],

  // Rutas protegidas
  'protected' => [
    'middleware' => [
      JwtAuthMiddleware::class,
    ],
    'routes' => [
      ['GET', '/api/v1/auth/me', [AuthController::class, 'me']],
      ['POST', '/api/v1/auth/logout', [AuthController::class, 'logout']],

      // Tasks
      ['GET', '/api/v1/tasks', [TaskController::class, 'index']],
      ['GET', '/api/v1/tasks/paginated', [TaskController::class, 'paginated']],
      ['GET', '/api/v1/tasks/stats', [TaskController::class, 'stats']],
      ['POST', '/api/v1/tasks', [TaskController::class, 'store']],
      ['GET', '/api/v1/tasks/{id}', [TaskController::class, 'show']],
      ['PUT', '/api/v1/tasks/{id}', [TaskController::class, 'update']],
      ['DELETE', '/api/v1/tasks/{id}', [TaskController::class, 'destroy']],

      // Admin - Areas
      ['GET', '/api/v1/areas', [AreaController::class, 'index']],
      ['POST', '/api/v1/areas', [AreaController::class, 'store'], [RoleMiddleware::class => ['admin']]],
      ['PUT', '/api/v1/areas/{id}', [AreaController::class, 'update'], [RoleMiddleware::class => ['admin']]],
      ['DELETE', '/api/v1/areas/{id}', [AreaController::class, 'destroy'], [RoleMiddleware::class => ['admin']]],

      // Admin - Users
      ['GET', '/api/v1/users', [UserController::class, 'index'], [RoleMiddleware::class => ['admin']]],
      ['POST', '/api/v1/users', [UserController::class, 'store'], [RoleMiddleware::class => ['admin']]],
      ['PUT', '/api/v1/users/{id}', [UserController::class, 'update'], [RoleMiddleware::class => ['admin']]],
      ['DELETE', '/api/v1/users/{id}', [UserController::class, 'destroy'], [RoleMiddleware::class => ['admin']]],

      // Roles (para formularios)
      ['GET', '/api/v1/roles', [UserController::class, 'roles']],

      // Reports
      ['GET', '/api/v1/reports/daily', [ReportController::class, 'daily']],
      ['GET', '/api/v1/reports/management', [ReportController::class, 'management'], [RoleMiddleware::class => ['admin']]],
      ['GET', '/api/v1/reports/weekly-evolution', [ReportController::class, 'weeklyEvolution'], [RoleMiddleware::class => ['admin']]],
      ['GET', '/api/v1/reports/quarterly', [ReportController::class, 'quarterlyCompliance'], [RoleMiddleware::class => ['admin']]],
      ['GET', '/api/v1/reports/advanced-stats', [ReportController::class, 'advancedStats'], [RoleMiddleware::class => ['admin']]],

      // Task Assignments (cualquier usuario puede asignar)
      ['GET', '/api/v1/assignments/my', [TaskAssignmentController::class, 'myAssignments']],
      ['GET', '/api/v1/assignments/sent', [TaskAssignmentController::class, 'sentByMe']],
      ['GET', '/api/v1/assignments/unread-count', [TaskAssignmentController::class, 'unreadCount']],
      ['GET', '/api/v1/assignments/responses', [TaskAssignmentController::class, 'responses']],
      ['GET', '/api/v1/assignments/responses/unread-count', [TaskAssignmentController::class, 'unreadResponseCount']],
      ['PUT', '/api/v1/assignments/mark-all-read', [TaskAssignmentController::class, 'markAllAsRead']],
      ['PUT', '/api/v1/assignments/mark-all-responses-read', [TaskAssignmentController::class, 'markAllResponsesAsRead']],
      ['POST', '/api/v1/assignments', [TaskAssignmentController::class, 'store']],
      ['PUT', '/api/v1/assignments/{id}/read', [TaskAssignmentController::class, 'markAsRead']],
      ['PUT', '/api/v1/assignments/{id}/accept', [TaskAssignmentController::class, 'accept']],
      ['PUT', '/api/v1/assignments/{id}/reject', [TaskAssignmentController::class, 'reject']],
      ['PUT', '/api/v1/assignments/{id}/reassign', [TaskAssignmentController::class, 'reassign']],
      ['PUT', '/api/v1/assignments/{id}/response-read', [TaskAssignmentController::class, 'markResponseAsRead']],
      ['DELETE', '/api/v1/assignments/{id}', [TaskAssignmentController::class, 'destroy']],

      // Users list for assignments
      ['GET', '/api/v1/users/list', [UserController::class, 'listAll']],
      ['GET', '/api/v1/users/assignable', [UserController::class, 'assignable']],

      // KPIs - Categorías y Summary
      ['GET', '/api/v1/kpi-categories', [KpiController::class, 'categories']],
      ['GET', '/api/v1/kpi-categories/by-area/{areaId}', [KpiController::class, 'categoriesByArea']],
      ['GET', '/api/v1/kpis/summary/all', [KpiController::class, 'summaryAll'], [RoleMiddleware::class => ['admin']]],
      ['GET', '/api/v1/kpis/summary', [KpiController::class, 'summary']],
      ['GET', '/api/v1/kpis/periods', [KpiController::class, 'periods']],
      ['GET', '/api/v1/kpis/{kpiId}/details', [KpiController::class, 'details']],
      ['GET', '/api/v1/kpis/{kpiId}/trend', [KpiController::class, 'trend']],
      
      // KPIs - Task inputs
      ['GET', '/api/v1/tasks/{taskId}/kpi-inputs', [KpiController::class, 'getTaskInputs']],
      ['PUT', '/api/v1/tasks/{taskId}/kpi-inputs', [KpiController::class, 'saveTaskInputs']],
      
      // KPIs - Admin only
      ['GET', '/api/v1/kpis/issues', [KpiController::class, 'issues'], [RoleMiddleware::class => ['admin']]],
      ['GET', '/api/v1/kpis/global-trend', [KpiController::class, 'globalTrend'], [RoleMiddleware::class => ['admin']]],
      ['POST', '/api/v1/kpis/backfill', [KpiController::class, 'backfill'], [RoleMiddleware::class => ['admin']]],
    ],
  ],
];

