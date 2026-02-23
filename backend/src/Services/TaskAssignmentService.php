<?php

namespace App\Services;

use App\Repositories\TaskAssignmentRepository;
use App\Repositories\TaskRepository;
use App\Repositories\UserRepository;

class TaskAssignmentService
{
    private $assignmentRepository;
    private $taskRepository;
    private $userRepository;
    private $assignmentPolicyService;

    public function __construct()
    {
        $this->assignmentRepository = new TaskAssignmentRepository();
        $this->taskRepository = new TaskRepository();
        $this->userRepository = new UserRepository();
        $this->assignmentPolicyService = new AssignmentPolicyService();
    }

    public function getMyAssignments(int $userId, array $filters = []): array
    {
        try {
            $filters['assigned_to'] = $userId;
            return $this->assignmentRepository->findAll($filters);
        } catch (\PDOException $e) {
            // Si la tabla no existe, retornar array vacío
            if (strpos($e->getMessage(), "doesn't exist") !== false) {
                return [];
            }
            throw $e;
        }
    }

    public function getAssignmentsSentByMe(int $userId, array $filters = []): array
    {
        $filters['assigned_by'] = $userId;
        return $this->assignmentRepository->findAll($filters);
    }

    public function getById(int $id): ?array
    {
        return $this->assignmentRepository->findById($id);
    }

    /**
     * @param array $data task_id, assigned_to, message
     * @param int   $assignedBy ID del usuario que asigna
     * @param array $userContext contexto del usuario (role, area_id, area_ids) para validar permisos
     */
    public function create(array $data, int $assignedBy, array $userContext = []): array
    {
        $task = $this->taskRepository->findById($data['task_id']);
        if (!$task) {
            throw new \Exception('La tarea no existe');
        }

        $assigneeId = (int)$data['assigned_to'];
        $user = $this->userRepository->findById($assigneeId);
        if (!$user) {
            throw new \Exception('El usuario destino no existe');
        }

        if (!empty($userContext)) {
            if (!$this->assignmentPolicyService->canAssignTo($userContext, $assigneeId)) {
                throw new \Exception('No tienes permisos para asignar tareas a ese usuario');
            }
            $taskResponsibleId = (int)($task['responsible_id'] ?? 0);
            if ($taskResponsibleId !== $assigneeId) {
                throw new \Exception('El destinatario de la asignación debe ser el responsable de la tarea');
            }
        }

        $assignmentData = [
            'task_id' => $data['task_id'],
            'assigned_by' => $assignedBy,
            'assigned_to' => $assigneeId,
            'message' => $data['message'] ?? null,
        ];

        $id = $this->assignmentRepository->create($assignmentData);
        return $this->assignmentRepository->findById($id);
    }

    public function markAsRead(int $id, int $userId): bool
    {
        $assignment = $this->assignmentRepository->findById($id);
        if (!$assignment) {
            throw new \Exception('Asignación no encontrada');
        }

        // Solo el destinatario puede marcar como leída
        if ($assignment['assigned_to'] != $userId) {
            throw new \Exception('No tienes permiso para marcar esta asignación');
        }

        return $this->assignmentRepository->markAsRead($id);
    }

    public function markAllAsRead(int $userId): bool
    {
        return $this->assignmentRepository->markAllAsRead($userId);
    }

    public function countUnread(int $userId): int
    {
        try {
            return $this->assignmentRepository->countUnread($userId);
        } catch (\PDOException $e) {
            // Si la tabla no existe, retornar 0 (no hay asignaciones sin leer)
            if (strpos($e->getMessage(), "doesn't exist") !== false) {
                return 0;
            }
            throw $e;
        }
    }

    /**
     * Aceptar una asignación
     */
    public function accept(int $id, int $userId): array
    {
        $assignment = $this->assignmentRepository->findById($id);
        if (!$assignment) {
            throw new \Exception('Asignación no encontrada');
        }

        if ($assignment['assigned_to'] != $userId) {
            throw new \Exception('No tienes permiso para aceptar esta asignación');
        }

        if ($assignment['status'] !== 'pending') {
            throw new \Exception('Esta asignación ya fue respondida');
        }

        $this->assignmentRepository->updateStatus($id, 'accepted');
        // Marcar como leída automáticamente al aceptar
        $this->assignmentRepository->markAsRead($id);

        return $this->assignmentRepository->findById($id);
    }

    /**
     * Rechazar una asignación
     */
    public function reject(int $id, int $userId, ?string $responseMessage = null): array
    {
        $assignment = $this->assignmentRepository->findById($id);
        if (!$assignment) {
            throw new \Exception('Asignación no encontrada');
        }

        if ($assignment['assigned_to'] != $userId) {
            throw new \Exception('No tienes permiso para rechazar esta asignación');
        }

        if ($assignment['status'] !== 'pending') {
            throw new \Exception('Esta asignación ya fue respondida');
        }

        $this->assignmentRepository->updateStatus($id, 'rejected', $responseMessage);
        // Marcar como leída automáticamente al rechazar
        $this->assignmentRepository->markAsRead($id);

        return $this->assignmentRepository->findById($id);
    }

    /**
     * Contar respuestas no leídas (feedback) para el asignador
     */
    public function countUnreadResponses(int $userId): int
    {
        try {
            return $this->assignmentRepository->countUnreadResponses($userId);
        } catch (\PDOException $e) {
            if (strpos($e->getMessage(), "doesn't exist") !== false) {
                return 0;
            }
            throw $e;
        }
    }

    /**
     * Obtener respuestas (feedback) para el asignador
     */
    public function getResponses(int $userId, int $limit = 20): array
    {
        return $this->assignmentRepository->findResponses($userId, $limit);
    }

    /**
     * Marcar respuesta como leída por el asignador
     */
    public function markResponseAsRead(int $id, int $userId): bool
    {
        $assignment = $this->assignmentRepository->findById($id);
        if (!$assignment) {
            throw new \Exception('Asignación no encontrada');
        }

        if ($assignment['assigned_by'] != $userId) {
            throw new \Exception('No tienes permiso para marcar esta respuesta');
        }

        return $this->assignmentRepository->markResponseAsRead($id);
    }

    /**
     * Marcar todas las respuestas como leídas
     */
    public function markAllResponsesAsRead(int $userId): bool
    {
        return $this->assignmentRepository->markAllResponsesAsRead($userId);
    }

    public function delete(int $id, int $userId): bool
    {
        $assignment = $this->assignmentRepository->findById($id);
        if (!$assignment) {
            throw new \Exception('Asignación no encontrada');
        }

        // Solo quien asignó o el destinatario puede eliminar
        if ($assignment['assigned_by'] != $userId && $assignment['assigned_to'] != $userId) {
            throw new \Exception('No tienes permiso para eliminar esta asignación');
        }

        return $this->assignmentRepository->delete($id);
    }

    /**
     * Reasignar una tarea recibida a otro usuario del área del receptor (líder reasigna a su equipo).
     *
     * @param int   $assignmentId ID de la asignación recibida
     * @param int   $newAssigneeUserId ID del nuevo responsable
     * @param int   $userId Usuario que reasigna (debe ser assigned_to de la asignación)
     * @param array $userContext contexto del usuario (role, area_ids)
     * @return array nueva asignación creada
     */
    public function reassign(int $assignmentId, int $newAssigneeUserId, int $userId, array $userContext = []): array
    {
        $assignment = $this->assignmentRepository->findById($assignmentId);
        if (!$assignment) {
            throw new \Exception('Asignación no encontrada');
        }

        if ((int)$assignment['assigned_to'] !== $userId) {
            throw new \Exception('Solo el destinatario de la asignación puede reasignarla');
        }

        if ($assignment['status'] !== 'pending' && $assignment['status'] !== 'accepted') {
            throw new \Exception('No se puede reasignar esta asignación');
        }

        if (empty($userContext) || !$this->assignmentPolicyService->canReassignTo($userContext, $newAssigneeUserId)) {
            throw new \Exception('No tienes permisos para reasignar a ese usuario. Solo puedes reasignar a miembros de tu área.');
        }

        $taskId = (int)$assignment['task_id'];
        $task = $this->taskRepository->findById($taskId);
        if (!$task) {
            throw new \Exception('La tarea no existe');
        }

        $newUser = $this->userRepository->findById($newAssigneeUserId);
        if (!$newUser) {
            throw new \Exception('El usuario destino no existe');
        }

        $this->taskRepository->update($taskId, ['responsible_id' => $newAssigneeUserId]);

        $newAssignmentData = [
            'task_id' => $taskId,
            'assigned_by' => $userId,
            'assigned_to' => $newAssigneeUserId,
            'message' => 'Reasignada por el líder del área',
        ];
        $newId = $this->assignmentRepository->create($newAssignmentData);

        if ($assignment['status'] === 'pending') {
            $this->assignmentRepository->updateStatus($assignmentId, 'accepted');
        }

        return $this->assignmentRepository->findById($newId);
    }
}

