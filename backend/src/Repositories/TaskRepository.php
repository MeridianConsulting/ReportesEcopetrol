<?php

namespace App\Repositories;

use App\Core\Database;

/**
 * Adaptado a reportes_ods: tabla tasks solo tiene id.
 */
class TaskRepository
{
  private $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  public function findAll(array $filters = [], array $userContext = []): array
  {
    try {
      $stmt = $this->db->query("SELECT t.id FROM tasks t");
      $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
      foreach ($rows as &$r) {
        $r['id'] = (int)$r['id'];
        $r['area_name'] = null;
        $r['area_destinataria_name'] = null;
        $r['responsible_name'] = null;
        $r['title'] = null;
        $r['description'] = null;
        $r['type'] = null;
        $r['priority'] = null;
        $r['status'] = null;
        $r['progress_percent'] = 0;
        $r['responsible_id'] = null;
        $r['area_id'] = null;
        $r['area_destinataria_id'] = null;
        $r['start_date'] = null;
        $r['due_date'] = null;
        $r['closed_date'] = null;
        $r['deleted_at'] = null;
        $r['created_at'] = null;
        $r['updated_at'] = null;
      }
      return $rows;
    } catch (\PDOException $e) {
      return [];
    }
  }

  public function findById(int $id, array $userContext = []): ?array
  {
    try {
      $stmt = $this->db->prepare("SELECT t.id FROM tasks t WHERE t.id = :id");
      $stmt->execute([':id' => $id]);
      $r = $stmt->fetch(\PDO::FETCH_ASSOC);
      if (!$r) {
        return null;
      }
      $r['id'] = (int)$r['id'];
      $r['area_name'] = null;
      $r['area_destinataria_name'] = null;
      $r['responsible_name'] = null;
      $r['title'] = null;
      $r['description'] = null;
      $r['type'] = null;
      $r['priority'] = null;
      $r['status'] = null;
      $r['progress_percent'] = 0;
      $r['responsible_id'] = null;
      $r['area_id'] = null;
      $r['area_destinataria_id'] = null;
      $r['start_date'] = null;
      $r['due_date'] = null;
      $r['closed_date'] = null;
      $r['deleted_at'] = null;
      $r['created_at'] = null;
      $r['updated_at'] = null;
      return $r;
    } catch (\PDOException $e) {
      return null;
    }
  }

  public function create(array $data): int
  {
    $stmt = $this->db->prepare("INSERT INTO tasks (id) VALUES (NULL)");
    $stmt->execute();
    return (int) $this->db->lastInsertId();
  }

  public function update(int $id, array $data): bool
  {
    return true;
  }

  public function delete(int $id): bool
  {
    $stmt = $this->db->prepare("DELETE FROM tasks WHERE id = :id");
    return $stmt->execute([':id' => $id]);
  }

  public function findPaginated(array $filters = [], array $userContext = [], int $limit = 100, ?string $cursor = null, string $sort = 'id', string $order = 'desc'): array
  {
    try {
      $countStmt = $this->db->query("SELECT COUNT(*) FROM tasks");
      $total = (int) $countStmt->fetchColumn();

      $dir = strtolower($order) === 'asc' ? 'ASC' : 'DESC';
      $realLimit = min(max($limit, 1), 100);
      $stmt = $this->db->prepare("SELECT id FROM tasks ORDER BY id $dir LIMIT " . ($realLimit + 1));
      $stmt->execute();
      $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);

      $hasMore = count($rows) > $realLimit;
      if ($hasMore) {
        array_pop($rows);
      }
      $nextCursor = null;
      if ($hasMore && !empty($rows)) {
        $last = end($rows);
        $nextCursor = base64_encode($last['id'] . '|' . $last['id']);
      }

      $items = [];
      foreach ($rows as $r) {
        $items[] = [
          'id' => (int)$r['id'],
          'area_name' => null,
          'area_destinataria_name' => null,
          'responsible_name' => null,
          'title' => null,
          'description' => null,
          'type' => null,
          'priority' => null,
          'status' => null,
          'progress_percent' => 0,
          'responsible_id' => null,
          'area_id' => null,
          'area_destinataria_id' => null,
          'start_date' => null,
          'due_date' => null,
          'closed_date' => null,
          'deleted_at' => null,
          'created_at' => null,
          'updated_at' => null,
        ];
      }

      return [
        'items' => $items,
        'has_more' => $hasMore,
        'next_cursor' => $nextCursor,
        'total' => $total,
      ];
    } catch (\PDOException $e) {
      return ['items' => [], 'has_more' => false, 'next_cursor' => null, 'total' => 0];
    }
  }

  public function getStats(int $responsibleId): array
  {
    return [
      'total' => 0,
      'completed' => 0,
      'pending' => 0,
      'at_risk' => 0,
    ];
  }
}
