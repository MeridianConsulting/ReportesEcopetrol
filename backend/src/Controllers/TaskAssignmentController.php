<?php

namespace App\Controllers;

use App\Core\Request;
use App\Core\Response;
use App\Services\TaskAssignmentService;

class TaskAssignmentController
{
    private $assignmentService;

    public function __construct()
    {
        $this->assignmentService = new TaskAssignmentService();
    }

    // Obtener asignaciones recibidas (para mí)
    public function myAssignments(Request $request)
    {
        $userId = $request->getUserId();
        $filters = [];
        
        if ($request->getQuery('is_read') !== null) {
            $filters['is_read'] = (int)$request->getQuery('is_read');
        }
        
        if ($request->getQuery('limit')) {
            $filters['limit'] = (int)$request->getQuery('limit');
        }

        $assignments = $this->assignmentService->getMyAssignments($userId, $filters);

        return Response::json([
            'data' => $assignments
        ]);
    }

    // Obtener asignaciones enviadas por mí
    public function sentByMe(Request $request)
    {
        $userId = $request->getUserId();
        $filters = [];
        
        if ($request->getQuery('limit')) {
            $filters['limit'] = (int)$request->getQuery('limit');
        }

        $assignments = $this->assignmentService->getAssignmentsSentByMe($userId, $filters);

        return Response::json([
            'data' => $assignments
        ]);
    }

    // Contar no leídas
    public function unreadCount(Request $request)
    {
        $userId = $request->getUserId();
        $count = $this->assignmentService->countUnread($userId);

        return Response::json([
            'data' => ['count' => $count]
        ]);
    }

    // Crear nueva asignación
    public function store(Request $request)
    {
        $body = $request->getBody();
        $userId = $request->getUserId();
        $userContext = $request->getAttribute('userContext') ?? [];

        $required = ['task_id', 'assigned_to'];
        foreach ($required as $field) {
            if (empty($body[$field])) {
                return Response::json([
                    'error' => [
                        'code' => 'VALIDATION_ERROR',
                        'message' => "El campo '$field' es requerido"
                    ]
                ], 400);
            }
        }

        try {
            $assignment = $this->assignmentService->create($body, $userId, $userContext);
            return Response::json([
                'data' => $assignment
            ], 201);
        } catch (\Exception $e) {
            $forbidden = ($e->getMessage() === 'No tienes permisos para asignar tareas a ese usuario');
            return Response::json([
                'error' => [
                    'code' => $forbidden ? 'FORBIDDEN' : 'CREATE_ERROR',
                    'message' => $e->getMessage()
                ]
            ], $forbidden ? 403 : 400);
        }
    }

    // Marcar como leída
    public function markAsRead(Request $request, string $id)
    {
        $userId = $request->getUserId();

        try {
            $this->assignmentService->markAsRead((int)$id, $userId);
            return Response::json([
                'message' => 'Asignación marcada como leída'
            ]);
        } catch (\Exception $e) {
            return Response::json([
                'error' => [
                    'code' => 'UPDATE_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 400);
        }
    }

    // Marcar todas como leídas
    public function markAllAsRead(Request $request)
    {
        $userId = $request->getUserId();
        $this->assignmentService->markAllAsRead($userId);

        return Response::json([
            'message' => 'Todas las asignaciones marcadas como leídas'
        ]);
    }

    // Aceptar asignación
    public function accept(Request $request, string $id)
    {
        $userId = $request->getUserId();

        try {
            $assignment = $this->assignmentService->accept((int)$id, $userId);
            return Response::json([
                'data' => $assignment,
                'message' => 'Asignación aceptada'
            ]);
        } catch (\Exception $e) {
            return Response::json([
                'error' => [
                    'code' => 'UPDATE_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 400);
        }
    }

    // Rechazar asignación (motivo obligatorio, mínimo 100 caracteres; lo ve quien asignó)
    public function reject(Request $request, string $id)
    {
        $userId = $request->getUserId();
        $body = $request->getBody();

        $responseMessage = isset($body['response_message']) ? trim((string) $body['response_message']) : '';
        if (strlen($responseMessage) < 100) {
            return Response::json([
                'error' => [
                    'code' => 'VALIDATION_ERROR',
                    'message' => 'El motivo del rechazo es obligatorio y debe tener al menos 100 caracteres. Este mensaje se envía a quien asignó la tarea.'
                ]
            ], 400);
        }

        try {
            $assignment = $this->assignmentService->reject((int)$id, $userId, $responseMessage);
            return Response::json([
                'data' => $assignment,
                'message' => 'Asignación rechazada'
            ]);
        } catch (\Exception $e) {
            return Response::json([
                'error' => [
                    'code' => 'UPDATE_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 400);
        }
    }

    // Contar respuestas no leídas (feedback para asignador)
    public function unreadResponseCount(Request $request)
    {
        $userId = $request->getUserId();
        $count = $this->assignmentService->countUnreadResponses($userId);

        return Response::json([
            'data' => ['count' => $count]
        ]);
    }

    // Obtener respuestas (feedback)
    public function responses(Request $request)
    {
        $userId = $request->getUserId();
        $limit = (int)($request->getQuery('limit') ?: 20);
        $responses = $this->assignmentService->getResponses($userId, $limit);

        return Response::json([
            'data' => $responses
        ]);
    }

    // Marcar respuesta como leída
    public function markResponseAsRead(Request $request, string $id)
    {
        $userId = $request->getUserId();

        try {
            $this->assignmentService->markResponseAsRead((int)$id, $userId);
            return Response::json([
                'message' => 'Respuesta marcada como leída'
            ]);
        } catch (\Exception $e) {
            return Response::json([
                'error' => [
                    'code' => 'UPDATE_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 400);
        }
    }

    // Marcar todas las respuestas como leídas
    public function markAllResponsesAsRead(Request $request)
    {
        $userId = $request->getUserId();
        $this->assignmentService->markAllResponsesAsRead($userId);

        return Response::json([
            'message' => 'Todas las respuestas marcadas como leídas'
        ]);
    }

    // Reasignar (líder que recibió la tarea la reasigna a alguien de su área)
    public function reassign(Request $request, string $id)
    {
        $userId = $request->getUserId();
        $userContext = $request->getAttribute('userContext') ?? [];
        $body = $request->getBody();

        if (empty($body['assigned_to'])) {
            return Response::json([
                'error' => [
                    'code' => 'VALIDATION_ERROR',
                    'message' => 'El campo assigned_to es requerido'
                ]
            ], 400);
        }

        try {
            $assignment = $this->assignmentService->reassign(
                (int)$id,
                (int)$body['assigned_to'],
                $userId,
                $userContext
            );
            return Response::json([
                'data' => $assignment,
                'message' => 'Tarea reasignada correctamente'
            ]);
        } catch (\Exception $e) {
            $forbidden = (strpos($e->getMessage(), 'permisos') !== false || strpos($e->getMessage(), 'reasignar a ese usuario') !== false);
            return Response::json([
                'error' => [
                    'code' => $forbidden ? 'FORBIDDEN' : 'UPDATE_ERROR',
                    'message' => $e->getMessage()
                ]
            ], $forbidden ? 403 : 400);
        }
    }

    // Eliminar asignación
    public function destroy(Request $request, string $id)
    {
        $userId = $request->getUserId();

        try {
            $this->assignmentService->delete((int)$id, $userId);
            return Response::json([
                'message' => 'Asignación eliminada'
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
}

