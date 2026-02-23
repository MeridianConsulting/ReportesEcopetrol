<?php

namespace App\Services;

use App\Repositories\UserRepository;

/**
 * Política de asignación de tareas por rol y área (cadena de delegación).
 * - Colaborador: solo misma área.
 * - Líder de área: misma área, o asignar a otro líder (cualquier área), o a administradores.
 * - Admin / Gerencia: sin restricciones.
 */
class AssignmentPolicyService
{
    private $userRepository;

    public function __construct()
    {
        $this->userRepository = new UserRepository();
    }

    /**
     * Indica si el usuario actual puede asignar tareas al usuario destino.
     *
     * @param array $userContext ['id', 'role', 'area_id', 'area_ids']
     * @param int   $assigneeUserId ID del usuario al que se quiere asignar
     * @return bool
     */
    public function canAssignTo(array $userContext, int $assigneeUserId): bool
    {
        $role = $userContext['role'] ?? null;
        $currentUserId = (int)($userContext['id'] ?? 0);
        $areaIds = $userContext['area_ids'] ?? [];
        if (empty($areaIds) && !empty($userContext['area_id'])) {
            $areaIds = [(int)$userContext['area_id']];
        }

        // Admin y gerencia pueden asignar a cualquiera
        if (in_array($role, ['admin', 'gerencia'], true)) {
            return true;
        }

        $assignee = $this->userRepository->findById($assigneeUserId);
        if (!$assignee) {
            return false;
        }
        $assignee = $this->userRepository->enrichWithAreas($assignee);
        $assigneeRole = $assignee['role_name'] ?? null;
        $assigneeAreaId = isset($assignee['area_id']) ? (int)$assignee['area_id'] : null;
        $assigneeAreaIds = $assignee['area_ids'] ?? ($assigneeAreaId !== null ? [$assigneeAreaId] : []);

        $assigneeInSameArea = $this->userInAreas($assigneeAreaId, $assigneeAreaIds, $areaIds);

        // Colaborador: solo misma área
        if ($role === 'colaborador') {
            return $assigneeInSameArea;
        }

        // Líder: misma área O asignar a otro líder (cualquier área) O a administradores
        if ($role === 'lider_area') {
            if ($assigneeInSameArea) {
                return true;
            }
            return in_array($assigneeRole, ['lider_area', 'admin', 'gerencia'], true);
        }

        return false;
    }

    /**
     * Indica si el usuario actual (receptor de una asignación) puede reasignar la tarea al usuario destino.
     * Líder: solo a usuarios de su misma área.
     * Admin/Gerencia: si tiene área asignada, solo a usuarios de su misma área (redistribución en su área);
     *                 si no tiene área, puede reasignar a cualquiera.
     *
     * @param array $userContext
     * @param int   $newAssigneeUserId
     * @return bool
     */
    public function canReassignTo(array $userContext, int $newAssigneeUserId): bool
    {
        $role = $userContext['role'] ?? null;
        $areaIds = $userContext['area_ids'] ?? [];
        if (empty($areaIds) && !empty($userContext['area_id'])) {
            $areaIds = [(int)$userContext['area_id']];
        }

        $assignee = $this->userRepository->findById($newAssigneeUserId);
        if (!$assignee) {
            return false;
        }
        $assignee = $this->userRepository->enrichWithAreas($assignee);
        $assigneeAreaId = isset($assignee['area_id']) ? (int)$assignee['area_id'] : null;
        $assigneeAreaIds = $assignee['area_ids'] ?? ($assigneeAreaId !== null ? [$assigneeAreaId] : []);

        if (in_array($role, ['admin', 'gerencia'], true)) {
            if (empty($areaIds)) {
                return true;
            }
            return $this->userInAreas($assigneeAreaId, $assigneeAreaIds, $areaIds);
        }

        if ($role !== 'lider_area') {
            return false;
        }

        return $this->userInAreas($assigneeAreaId, $assigneeAreaIds, $areaIds);
    }

    /**
     * Devuelve los IDs de usuarios a los que el usuario actual puede asignar tareas.
     *
     * @param array $userContext
     * @return int[]
     */
    public function listAssignableUserIds(array $userContext): array
    {
        $role = $userContext['role'] ?? null;
        $areaIds = $userContext['area_ids'] ?? [];
        if (empty($areaIds) && !empty($userContext['area_id'])) {
            $areaIds = [(int)$userContext['area_id']];
        }

        if (in_array($role, ['admin', 'gerencia'], true)) {
            $users = $this->userRepository->findAll(['is_active' => 1]);
            return array_map(fn($u) => (int)$u['id'], $users);
        }

        $allUsers = $this->userRepository->findAll(['is_active' => 1]);
        $allowed = [];
        foreach ($allUsers as $u) {
            $u = $this->userRepository->enrichWithAreas($u);
            if ($this->canAssignTo($userContext, (int)$u['id'])) {
                $allowed[] = (int)$u['id'];
            }
        }
        return $allowed;
    }

    private function userInAreas(?int $userAreaId, array $userAreaIds, array $allowedAreaIds): bool
    {
        if (empty($allowedAreaIds)) {
            return false;
        }
        if ($userAreaId !== null && in_array($userAreaId, $allowedAreaIds, true)) {
            return true;
        }
        foreach ($userAreaIds as $aid) {
            if (in_array((int)$aid, $allowedAreaIds, true)) {
                return true;
            }
        }
        return false;
    }
}
