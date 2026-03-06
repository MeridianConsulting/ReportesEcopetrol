<?php

namespace App\Controllers;

use App\Core\Request;
use App\Core\Response;
use App\Resources\OdsActivityResource;
use App\Services\OdsActivityService;
use App\Services\ValidationService;

class OdsActivityController
{
  private $service;

  public function __construct()
  {
    $this->service = new OdsActivityService();
  }

  public function index(Request $request)
  {
    try {
      $filters = [
        'service_order_id' => $request->getQuery('service_order_id') ? (int)$request->getQuery('service_order_id') : null,
        'assigned_user_id' => $request->getQuery('assigned_user_id') ? (int)$request->getQuery('assigned_user_id') : null,
        'status' => $request->getQuery('status'),
        'search' => $request->getQuery('search'),
      ];

      $filters = array_filter($filters, function ($value) {
        return $value !== null && $value !== '';
      });

      $activities = $this->service->list($filters);

      return Response::json([
        'data' => OdsActivityResource::collection($activities),
      ]);
    } catch (\Throwable $e) {
      return Response::json([
        'error' => [
          'code' => 'INTERNAL_ERROR',
          'message' => APP_DEBUG ? $e->getMessage() : 'Internal server error',
        ],
      ], 500);
    }
  }

  public function show(Request $request, string $id)
  {
    $activity = $this->service->getById((int)$id);
    if (!$activity) {
      return Response::json([
        'error' => [
          'code' => 'NOT_FOUND',
          'message' => 'Actividad no encontrada',
        ],
      ], 404);
    }

    return Response::json([
      'data' => OdsActivityResource::toArray($activity),
    ]);
  }

  public function store(Request $request)
  {
    $body = $request->getBody() ?? [];
    $errors = ValidationService::validateOdsActivityData($body, false);

    if (!empty($errors)) {
      return Response::json([
        'error' => [
          'code' => 'VALIDATION_ERROR',
          'message' => 'Validation failed',
          'errors' => $errors,
        ],
      ], 400);
    }

    try {
      $activity = $this->service->create($body, $request->getAttribute('userContext') ?? []);

      return Response::json([
        'data' => OdsActivityResource::toArray($activity),
      ], 201);
    } catch (\InvalidArgumentException $e) {
      return Response::json([
        'error' => [
          'code' => 'VALIDATION_ERROR',
          'message' => $e->getMessage(),
        ],
      ], 400);
    } catch (\Throwable $e) {
      return Response::json([
        'error' => [
          'code' => 'CREATE_ERROR',
          'message' => APP_DEBUG ? $e->getMessage() : 'No fue posible crear la actividad',
        ],
      ], 400);
    }
  }

  public function update(Request $request, string $id)
  {
    $body = $request->getBody() ?? [];
    $errors = ValidationService::validateOdsActivityData($body, true);

    if (!empty($errors)) {
      return Response::json([
        'error' => [
          'code' => 'VALIDATION_ERROR',
          'message' => 'Validation failed',
          'errors' => $errors,
        ],
      ], 400);
    }

    try {
      $activity = $this->service->update((int)$id, $body, $request->getAttribute('userContext') ?? []);

      if (!$activity) {
        return Response::json([
          'error' => [
            'code' => 'NOT_FOUND',
            'message' => 'Actividad no encontrada',
          ],
        ], 404);
      }

      return Response::json([
        'data' => OdsActivityResource::toArray($activity),
      ]);
    } catch (\InvalidArgumentException $e) {
      return Response::json([
        'error' => [
          'code' => 'VALIDATION_ERROR',
          'message' => $e->getMessage(),
        ],
      ], 400);
    } catch (\Throwable $e) {
      return Response::json([
        'error' => [
          'code' => 'UPDATE_ERROR',
          'message' => APP_DEBUG ? $e->getMessage() : 'No fue posible actualizar la actividad',
        ],
      ], 400);
    }
  }

  public function destroy(Request $request, string $id)
  {
    try {
      $deleted = $this->service->delete((int)$id, $request->getAttribute('userContext') ?? []);

      if (!$deleted) {
        return Response::json([
          'error' => [
            'code' => 'NOT_FOUND',
            'message' => 'Actividad no encontrada',
          ],
        ], 404);
      }

      return Response::json([
        'data' => [
          'message' => 'Actividad eliminada correctamente',
        ],
      ]);
    } catch (\InvalidArgumentException $e) {
      return Response::json([
        'error' => [
          'code' => 'VALIDATION_ERROR',
          'message' => $e->getMessage(),
        ],
      ], 400);
    } catch (\Throwable $e) {
      return Response::json([
        'error' => [
          'code' => 'DELETE_ERROR',
          'message' => APP_DEBUG ? $e->getMessage() : 'No fue posible eliminar la actividad',
        ],
      ], 400);
    }
  }
}
