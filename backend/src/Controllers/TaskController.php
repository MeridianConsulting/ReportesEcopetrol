<?php

namespace App\Controllers;

use App\Core\Request;
use App\Core\Response;
use App\Services\TaskService;
use App\Resources\TaskResource;

class TaskController
{
  private $taskService;

  public function __construct()
  {
    $this->taskService = new TaskService();
  }

  public function index(Request $request)
  {
    try {
      $userContext = $request->getAttribute('userContext');
      
      if (!$userContext) {
        return Response::json([
          'error' => [
            'code' => 'UNAUTHORIZED',
            'message' => 'User context not found'
          ]
        ], 401);
      }
      
      $filters = [
        'status' => $request->getQuery('status'),
        'priority' => $request->getQuery('priority'),
        'type' => $request->getQuery('type'),
        'area_id' => $request->getQuery('area_id') ? (int)$request->getQuery('area_id') : null,
        'responsible_id' => $request->getQuery('responsible_id') ? (int)$request->getQuery('responsible_id') : null,
        'date_from' => $request->getQuery('date_from'),
        'date_to' => $request->getQuery('date_to'),
        'due_from' => $request->getQuery('due_from'),
        'due_to' => $request->getQuery('due_to'),
      ];

      // Eliminar filtros vacíos
      $filters = array_filter($filters, function($value) {
        return $value !== null && $value !== '';
      });

      $tasks = $this->taskService->list($filters, $userContext);

      return Response::json([
        'data' => TaskResource::collection($tasks)
      ]);
    } catch (\Exception $e) {
      error_log('TaskController::index error: ' . $e->getMessage());
      error_log('Stack trace: ' . $e->getTraceAsString());
      
      return Response::json([
        'error' => [
          'code' => 'INTERNAL_ERROR',
          'message' => APP_DEBUG ? $e->getMessage() : 'Internal server error',
          'details' => APP_DEBUG ? [
            'file' => $e->getFile(),
            'line' => $e->getLine(),
          ] : null
        ]
      ], 500);
    }
  }

  public function show(Request $request, string $id)
  {
    $userContext = $request->getAttribute('userContext');
    $task = $this->taskService->getById((int)$id, $userContext);

    if (!$task) {
      return Response::json([
        'error' => [
          'code' => 'NOT_FOUND',
          'message' => 'Task not found'
        ]
      ], 404);
    }

    return Response::json([
      'data' => TaskResource::toArray($task)
    ]);
  }

  public function store(Request $request)
  {
    $userContext = $request->getAttribute('userContext');
    $body = $request->getBody();

    // Validar datos
    $errors = \App\Services\ValidationService::validateTaskData($body);
    if (!empty($errors)) {
      return Response::json([
        'error' => [
          'code' => 'VALIDATION_ERROR',
          'message' => 'Validation failed',
          'errors' => $errors
        ]
      ], 400);
    }

    try {
      $task = $this->taskService->create($body, $userContext);
      if (!$task) {
        error_log('TaskController::store - Tarea creada pero no se pudo recuperar. UserContext: ' . json_encode($userContext));
        return Response::json([
          'error' => [
            'code' => 'CREATE_ERROR',
            'message' => 'No se pudo crear la tarea o no tienes permisos para verla'
          ]
        ], 400);
      }
      return Response::json([
        'data' => TaskResource::toArray($task)
      ], 201);
    } catch (\PDOException $e) {
      error_log('TaskController::store PDO error: ' . $e->getMessage());
      error_log('Stack trace: ' . $e->getTraceAsString());
      error_log('Request body: ' . json_encode($body));
      return Response::json([
        'error' => [
          'code' => 'CREATE_ERROR',
          'message' => 'Error de base de datos al crear la tarea',
          'details' => APP_DEBUG ? $e->getMessage() : null
        ]
      ], 400);
    } catch (\Exception $e) {
      error_log('TaskController::store error: ' . $e->getMessage());
      error_log('Stack trace: ' . $e->getTraceAsString());
      error_log('Request body: ' . json_encode($body));
      $forbidden = ($e->getMessage() === 'No tienes permisos para asignar tareas a ese usuario');
      return Response::json([
        'error' => [
          'code' => $forbidden ? 'FORBIDDEN' : 'CREATE_ERROR',
          'message' => $e->getMessage() ?: ($forbidden ? 'No tienes permisos para asignar tareas a ese usuario' : 'Error al crear la tarea'),
          'details' => APP_DEBUG && !$forbidden ? [
            'file' => $e->getFile(),
            'line' => $e->getLine(),
          ] : null
        ]
      ], $forbidden ? 403 : 400);
    }
  }

  public function update(Request $request, string $id)
  {
    $userContext = $request->getAttribute('userContext');
    $body = $request->getBody();

    // Obtener tarea actual para validaciones condicionales
    $currentTask = $this->taskService->getById((int)$id, $userContext);
    if (!$currentTask) {
      return Response::json([
        'error' => [
          'code' => 'NOT_FOUND',
          'message' => 'Task not found or insufficient permissions'
        ]
      ], 404);
    }

    // Determinar el estado que se usará (el nuevo si viene, o el actual)
    $statusToUse = $body['status'] ?? $currentTask['status'] ?? null;

    // Validar datos (solo los campos presentes)
    // Pasar isUpdate=true y el estado actual para permitir fechas pasadas si está completada
    $errors = \App\Services\ValidationService::validateTaskData($body, true, $statusToUse);
    if (!empty($errors)) {
      return Response::json([
        'error' => [
          'code' => 'VALIDATION_ERROR',
          'message' => 'Validation failed',
          'errors' => $errors
        ]
      ], 400);
    }

    $task = $this->taskService->update((int)$id, $body, $userContext);

    if (!$task) {
      return Response::json([
        'error' => [
          'code' => 'NOT_FOUND',
          'message' => 'Task not found or insufficient permissions'
        ]
      ], 404);
    }

    return Response::json([
      'data' => TaskResource::toArray($task)
    ]);
  }

  public function paginated(Request $request)
  {
    try {
      $userContext = $request->getAttribute('userContext');

      if (!$userContext) {
        return Response::json([
          'error' => ['code' => 'UNAUTHORIZED', 'message' => 'User context not found']
        ], 401);
      }

      $filters = [];
      $filterKeys = ['responsible_id', 'area_id', 'start_date_from', 'start_date_to', 'include_null_start_date', 'all_dates'];
      foreach ($filterKeys as $key) {
        $val = $request->getQuery($key);
        if ($val !== null && $val !== '') {
          $filters[$key] = $key === 'all_dates' ? filter_var($val, FILTER_VALIDATE_BOOLEAN) : $val;
        }
      }
      // Filtros multivalor (status, priority, kpi_category_id): aceptan valor único o lista separada por coma
      foreach (['status', 'priority', 'kpi_category_id'] as $multiKey) {
        $val = $request->getQuery($multiKey);
        if ($val === null || $val === '') continue;
        $parts = array_map('trim', explode(',', $val));
        $parts = array_filter($parts);
        if (!empty($parts)) {
          $filters[$multiKey] = count($parts) === 1 ? $parts[0] : $parts;
        }
      }

      $limit = min(max((int)($request->getQuery('limit') ?: 100), 1), 100);
      $cursor = $request->getQuery('cursor');
      $sort = $request->getQuery('sort') ?: 'updated_at';
      $order = $request->getQuery('order') ?: 'desc';

      $result = $this->taskService->listPaginated($filters, $userContext, $limit, $cursor, $sort, $order);

      return Response::json([
        'data' => TaskResource::collection($result['items']),
        'has_more' => $result['has_more'],
        'next_cursor' => $result['next_cursor'],
        'total' => $result['total'],
      ]);
    } catch (\Exception $e) {
      error_log('TaskController::paginated error: ' . $e->getMessage());
      return Response::json([
        'error' => [
          'code' => 'INTERNAL_ERROR',
          'message' => APP_DEBUG ? $e->getMessage() : 'Internal server error',
        ]
      ], 500);
    }
  }

  public function stats(Request $request)
  {
    try {
      $userContext = $request->getAttribute('userContext');

      if (!$userContext) {
        return Response::json([
          'error' => ['code' => 'UNAUTHORIZED', 'message' => 'User context not found']
        ], 401);
      }

      $responsibleId = $request->getQuery('responsible_id');
      if (!$responsibleId) {
        $responsibleId = $userContext['id'];
      }

      $stats = $this->taskService->getStats((int)$responsibleId);

      return Response::json(['data' => $stats]);
    } catch (\Exception $e) {
      error_log('TaskController::stats error: ' . $e->getMessage());
      return Response::json([
        'error' => [
          'code' => 'INTERNAL_ERROR',
          'message' => APP_DEBUG ? $e->getMessage() : 'Internal server error',
        ]
      ], 500);
    }
  }

  public function destroy(Request $request, string $id)
  {
    $userContext = $request->getAttribute('userContext');
    $deleted = $this->taskService->delete((int)$id, $userContext);

    if (!$deleted) {
      return Response::json([
        'error' => [
          'code' => 'NOT_FOUND',
          'message' => 'Task not found or insufficient permissions'
        ]
      ], 404);
    }

    return Response::json([
      'data' => ['message' => 'Task deleted successfully']
    ]);
  }
}

