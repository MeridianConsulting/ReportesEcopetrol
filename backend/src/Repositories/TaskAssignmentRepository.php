<?php

namespace App\Repositories;

use App\Core\Database;

/**
 * Adaptado a reportes_ods: tabla task_assignments puede no existir.
 * Si falla la consulta, se retorna valor seguro para no romper la API.
 */
class TaskAssignmentRepository
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    private function safeQuery(callable $fn, $default)
    {
        try {
            return $fn();
        } catch (\PDOException $e) {
            return $default;
        }
    }

    public function findAll(array $filters = []): array
    {
        return $this->safeQuery(function () use ($filters) {
            $sql = "SELECT ta.*, t.id as task_id FROM task_assignments ta INNER JOIN tasks t ON ta.task_id = t.id WHERE 1=1";
            $params = [];
            if (isset($filters['assigned_to'])) {
                $sql .= " AND ta.assigned_to = :assigned_to";
                $params[':assigned_to'] = $filters['assigned_to'];
            }
            if (isset($filters['assigned_by'])) {
                $sql .= " AND ta.assigned_by = :assigned_by";
                $params[':assigned_by'] = $filters['assigned_by'];
            }
            if (isset($filters['is_read'])) {
                $sql .= " AND ta.is_read = :is_read";
                $params[':is_read'] = $filters['is_read'];
            }
            $sql .= " ORDER BY ta.created_at DESC";
            if (isset($filters['limit'])) {
                $sql .= " LIMIT " . (int)$filters['limit'];
            }
            $stmt = $this->db->prepare($sql);
            $stmt->execute($params);
            return $stmt->fetchAll(\PDO::FETCH_ASSOC);
        }, []);
    }

    public function findById(int $id): ?array
    {
        return $this->safeQuery(function () use ($id) {
            $stmt = $this->db->prepare("SELECT * FROM task_assignments WHERE id = :id");
            $stmt->execute([':id' => $id]);
            $r = $stmt->fetch(\PDO::FETCH_ASSOC);
            return $r ?: null;
        }, null);
    }

    public function create(array $data): int
    {
        return $this->safeQuery(function () use ($data) {
            $stmt = $this->db->prepare("
                INSERT INTO task_assignments (task_id, assigned_by, assigned_to, message, is_read)
                VALUES (:task_id, :assigned_by, :assigned_to, :message, 0)
            ");
            $stmt->execute([
                ':task_id' => $data['task_id'],
                ':assigned_by' => $data['assigned_by'],
                ':assigned_to' => $data['assigned_to'],
                ':message' => $data['message'] ?? null,
            ]);
            return (int) $this->db->lastInsertId();
        }, 0);
    }

    public function markAsRead(int $id): bool
    {
        return $this->safeQuery(function () use ($id) {
            $stmt = $this->db->prepare("UPDATE task_assignments SET is_read = 1 WHERE id = :id");
            return $stmt->execute([':id' => $id]);
        }, false);
    }

    public function markAllAsRead(int $userId): bool
    {
        return $this->safeQuery(function () use ($userId) {
            $stmt = $this->db->prepare("UPDATE task_assignments SET is_read = 1 WHERE assigned_to = :user_id AND is_read = 0");
            return $stmt->execute([':user_id' => $userId]);
        }, false);
    }

    public function countUnread(int $userId): int
    {
        return $this->safeQuery(function () use ($userId) {
            $stmt = $this->db->prepare("SELECT COUNT(*) FROM task_assignments WHERE assigned_to = :user_id AND is_read = 0");
            $stmt->execute([':user_id' => $userId]);
            return (int) $stmt->fetchColumn();
        }, 0);
    }

    public function updateStatus(int $id, string $status, ?string $responseMessage = null): bool
    {
        return $this->safeQuery(function () use ($id, $status, $responseMessage) {
            $stmt = $this->db->prepare("UPDATE task_assignments SET status = :status, response_message = :response_message, responded_at = NOW(), response_read = 0 WHERE id = :id");
            return $stmt->execute([
                ':id' => $id,
                ':status' => $status,
                ':response_message' => $responseMessage,
            ]);
        }, false);
    }

    public function countUnreadResponses(int $userId): int
    {
        return $this->safeQuery(function () use ($userId) {
            $stmt = $this->db->prepare("SELECT COUNT(*) FROM task_assignments WHERE assigned_by = :user_id AND status IN ('accepted', 'rejected') AND response_read = 0");
            $stmt->execute([':user_id' => $userId]);
            return (int) $stmt->fetchColumn();
        }, 0);
    }

    public function markResponseAsRead(int $id): bool
    {
        return $this->safeQuery(function () use ($id) {
            $stmt = $this->db->prepare("UPDATE task_assignments SET response_read = 1 WHERE id = :id");
            return $stmt->execute([':id' => $id]);
        }, false);
    }

    public function markAllResponsesAsRead(int $userId): bool
    {
        return $this->safeQuery(function () use ($userId) {
            $stmt = $this->db->prepare("UPDATE task_assignments SET response_read = 1 WHERE assigned_by = :user_id AND response_read = 0");
            return $stmt->execute([':user_id' => $userId]);
        }, false);
    }

    public function findResponses(int $userId, int $limit = 20): array
    {
        return $this->safeQuery(function () use ($userId, $limit) {
            $stmt = $this->db->prepare("SELECT * FROM task_assignments WHERE assigned_by = :user_id AND status IN ('accepted', 'rejected') ORDER BY responded_at DESC LIMIT " . (int)$limit);
            $stmt->execute([':user_id' => $userId]);
            return $stmt->fetchAll(\PDO::FETCH_ASSOC);
        }, []);
    }

    public function delete(int $id): bool
    {
        return $this->safeQuery(function () use ($id) {
            $stmt = $this->db->prepare("DELETE FROM task_assignments WHERE id = :id");
            return $stmt->execute([':id' => $id]);
        }, false);
    }
}
