<?php

namespace App\Controllers;

use App\Core\Request;
use App\Core\Response;
use App\Services\UserService;
use App\Services\AssignmentPolicyService;
use App\Repositories\RoleRepository;
use App\Resources\UserResource;

class UserController
{
  private $userService;
  private $roleRepository;
  private $assignmentPolicyService;

  public function __construct()
  {
    $this->userService = new UserService();
    $this->roleRepository = new RoleRepository();
    $this->assignmentPolicyService = new AssignmentPolicyService();
  }

  public function index(Request $request)
  {
    $filters = [];
    if ($request->getQuery('is_active') !== null) {
      $filters['is_active'] = (int)$request->getQuery('is_active');
    }
    $serviceOrderId = $request->getQuery('service_order_id');
    if ($serviceOrderId !== null && $serviceOrderId !== '') {
      $filters['service_order_id'] = (int) $serviceOrderId;
    }

    $users = $this->userService->list($filters);

    return Response::json([
      'data' => UserResource::collection($users)
    ]);
  }

  public function store(Request $request)
  {
    $body = $request->getBody();

    // Validar datos
    $errors = \App\Services\ValidationService::validateUserData($body, false);
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
      $user = $this->userService->create($body);
      return Response::json([
        'data' => UserResource::toArray($user)
      ], 201);
    } catch (\Exception $e) {
      return Response::json([
        'error' => [
          'code' => 'CREATE_ERROR',
          'message' => $e->getMessage()
        ]
      ], 400);
    }
  }

  public function update(Request $request, string $id)
  {
    $body = $request->getBody();
    
    // Validar datos (solo los campos presentes)
    $errors = \App\Services\ValidationService::validateUserData($body, true);
    if (!empty($errors)) {
      return Response::json([
        'error' => [
          'code' => 'VALIDATION_ERROR',
          'message' => 'Validation failed',
          'errors' => $errors
        ]
      ], 400);
    }
    
    $user = $this->userService->update((int)$id, $body);

    if (!$user) {
      return Response::json([
        'error' => [
          'code' => 'NOT_FOUND',
          'message' => 'User not found'
        ]
      ], 404);
    }

    return Response::json([
      'data' => UserResource::toArray($user)
    ]);
  }

  public function roles(Request $request)
  {
    $roles = $this->roleRepository->findAll();
    return Response::json([
      'data' => $roles
    ]);
  }

  public function destroy(Request $request, string $id)
  {
    try {
      $this->userService->delete((int)$id);
      return Response::json([
        'message' => 'Usuario eliminado correctamente'
      ]);
    } catch (\Exception $e) {
      return Response::json([
        'error' => [
          'code' => 'DELETE_ERROR',
          'message' => $e->getMessage()
        ]
      ], 400);
    }
  }

  // Lista de usuarios para asignaciones (accesible por todos)
  public function listAll(Request $request)
  {
    $users = $this->userService->list(['is_active' => 1]);
    
    // Retornar solo datos básicos para asignaciones
    $simplified = array_map(function($user) {
      return [
        'id' => $user['id'],
        'name' => $user['name'],
        'email' => $user['email'],
        'role_name' => $user['role_name'] ?? null,
        'area_id' => $user['area_id'] ?? null,
        'area_name' => $user['area_name'] ?? null,
        'area_ids' => $user['area_ids'] ?? ($user['area_id'] ? [(int)$user['area_id']] : []),
        'area_names' => $user['area_names'] ?? ($user['area_name'] ? [$user['area_name']] : []),
      ];
    }, $users);

    return Response::json([
      'data' => $simplified
    ]);
  }

  /**
   * Usuarios a los que el usuario actual puede asignar tareas (según rol y área).
   */
  public function assignable(Request $request)
  {
    $userContext = $request->getAttribute('userContext');
    if (!$userContext) {
      return Response::json([
        'error' => ['code' => 'UNAUTHORIZED', 'message' => 'User context not found']
      ], 401);
    }

    $allowedIds = $this->assignmentPolicyService->listAssignableUserIds($userContext);
    $users = $this->userService->list(['is_active' => 1]);
    $allowedSet = array_flip($allowedIds);
    $filtered = array_filter($users, fn($u) => isset($allowedSet[(int)$u['id']]));

    $simplified = array_map(function($user) {
      return [
        'id' => $user['id'],
        'name' => $user['name'],
        'email' => $user['email'],
        'role_name' => $user['role_name'] ?? null,
        'area_id' => $user['area_id'] ?? null,
        'area_name' => $user['area_name'] ?? null,
        'area_ids' => $user['area_ids'] ?? ($user['area_id'] ? [(int)$user['area_id']] : []),
        'area_names' => $user['area_names'] ?? ($user['area_name'] ? [$user['area_name']] : []),
      ];
    }, array_values($filtered));

    return Response::json([
      'data' => $simplified
    ]);
  }
}

