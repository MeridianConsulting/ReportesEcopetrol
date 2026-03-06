<?php

namespace App\Repositories;

use App\Core\Database;

class OdsActivityRepository
{
  private $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  public function findAll(array $filters = []): array
  {
    $sql = $this->baseQuery();
    $params = [];
    $sql .= $this->buildWhereClause($filters, $params);
    $sql .= " GROUP BY a.id ORDER BY a.updated_at DESC, a.id DESC";

    $stmt = $this->db->prepare($sql);
    $stmt->execute($params);

    return $this->mapCollection($stmt->fetchAll(\PDO::FETCH_ASSOC));
  }

  public function findById(int $id): ?array
  {
    $sql = $this->baseQuery() . " WHERE a.deleted_at IS NULL AND a.id = ? GROUP BY a.id LIMIT 1";
    $stmt = $this->db->prepare($sql);
    $stmt->execute([$id]);
    $row = $stmt->fetch(\PDO::FETCH_ASSOC);

    return $row ? $this->mapRow($row) : null;
  }

  public function create(array $data): int
  {
    $stmt = $this->db->prepare("
      INSERT INTO ods_activities (
        service_order_id,
        title,
        item_general,
        item_activity,
        description,
        support_text,
        delivery_medium_id,
        contracted_days,
        planned_start_date,
        planned_end_date,
        status,
        notes,
        created_by,
        updated_by
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");

    $stmt->execute([
      (int)$data['service_order_id'],
      $data['title'],
      $data['item_general'] ?? null,
      $data['item_activity'] ?? null,
      $data['description'],
      $data['support_text'] ?? null,
      $data['delivery_medium_id'] ?? null,
      $data['contracted_days'] ?? null,
      $data['planned_start_date'] ?? null,
      $data['planned_end_date'] ?? null,
      $data['status'],
      $data['notes'] ?? null,
      (int)$data['created_by'],
      $data['updated_by'] ?? null,
    ]);

    return (int)$this->db->lastInsertId();
  }

  public function update(int $id, array $data): bool
  {
    $fields = [];
    $params = [];

    $allowedFields = [
      'service_order_id',
      'title',
      'item_general',
      'item_activity',
      'description',
      'support_text',
      'delivery_medium_id',
      'contracted_days',
      'planned_start_date',
      'planned_end_date',
      'status',
      'notes',
      'updated_by',
    ];

    foreach ($allowedFields as $field) {
      if (!array_key_exists($field, $data)) {
        continue;
      }

      $fields[] = "`{$field}` = ?";
      $params[] = $data[$field];
    }

    if (empty($fields)) {
      return true;
    }

    $params[] = $id;
    $sql = "UPDATE ods_activities SET " . implode(', ', $fields) . " WHERE id = ? AND deleted_at IS NULL";
    $stmt = $this->db->prepare($sql);

    return $stmt->execute($params);
  }

  public function softDelete(int $id, int $userId): bool
  {
    $stmt = $this->db->prepare("
      UPDATE ods_activities
      SET deleted_at = NOW(), updated_by = ?
      WHERE id = ? AND deleted_at IS NULL
    ");
    $stmt->execute([$userId, $id]);

    return $stmt->rowCount() > 0;
  }

  public function getAssignedUserIds(int $activityId): array
  {
    $stmt = $this->db->prepare("
      SELECT user_id
      FROM ods_activity_assignments
      WHERE activity_id = ? AND is_active = 1
    ");
    $stmt->execute([$activityId]);

    return array_map('intval', $stmt->fetchAll(\PDO::FETCH_COLUMN));
  }

  public function syncAssignments(int $activityId, array $userIds, int $assignedBy): void
  {
    $currentIds = $this->getAssignedUserIds($activityId);
    $currentSet = array_flip($currentIds);
    $newIds = array_values(array_unique(array_map('intval', $userIds)));
    $newSet = array_flip($newIds);

    $toDeactivate = array_values(array_diff($currentIds, $newIds));
    $toActivate = array_values(array_diff($newIds, $currentIds));

    if (!empty($toDeactivate)) {
      $placeholders = implode(',', array_fill(0, count($toDeactivate), '?'));
      $params = array_merge([$activityId], $toDeactivate);
      $stmt = $this->db->prepare("
        UPDATE ods_activity_assignments
        SET is_active = 0
        WHERE activity_id = ? AND user_id IN ($placeholders) AND is_active = 1
      ");
      $stmt->execute($params);
    }

    if (!empty($toActivate)) {
      foreach ($toActivate as $userId) {
        $reactivate = $this->db->prepare("
          UPDATE ods_activity_assignments
          SET is_active = 1, assigned_by = ?, assigned_at = CURRENT_TIMESTAMP
          WHERE activity_id = ? AND user_id = ? AND is_active = 0
          LIMIT 1
        ");
        $reactivate->execute([$assignedBy, $activityId, $userId]);

        if ($reactivate->rowCount() > 0) {
          continue;
        }

        $insert = $this->db->prepare("
          INSERT INTO ods_activity_assignments (activity_id, user_id, assigned_by, is_active)
          VALUES (?, ?, ?, 1)
        ");
        $insert->execute([$activityId, $userId, $assignedBy]);
      }
    }
  }

  public function deactivateAssignments(int $activityId): void
  {
    $stmt = $this->db->prepare("
      UPDATE ods_activity_assignments
      SET is_active = 0
      WHERE activity_id = ? AND is_active = 1
    ");
    $stmt->execute([$activityId]);
  }

  public function serviceOrderExists(int $serviceOrderId): bool
  {
    $stmt = $this->db->prepare("SELECT id FROM service_orders WHERE id = ? LIMIT 1");
    $stmt->execute([$serviceOrderId]);
    return (bool)$stmt->fetch(\PDO::FETCH_ASSOC);
  }

  public function deliveryMediumExists(int $deliveryMediumId): bool
  {
    $stmt = $this->db->prepare("SELECT id FROM delivery_media WHERE id = ? AND is_active = 1 LIMIT 1");
    $stmt->execute([$deliveryMediumId]);
    return (bool)$stmt->fetch(\PDO::FETCH_ASSOC);
  }

  public function getProfessionalIdsForServiceOrder(int $serviceOrderId): array
  {
    $stmt = $this->db->prepare("
      SELECT soe.user_id
      FROM service_order_employees soe
      WHERE soe.service_order_id = ? AND soe.is_active = 1
    ");
    $stmt->execute([$serviceOrderId]);

    return array_map('intval', $stmt->fetchAll(\PDO::FETCH_COLUMN));
  }

  private function baseQuery(): string
  {
    return "
      SELECT
        a.*,
        so.ods_code,
        so.project_name,
        dm.name AS delivery_medium_name,
        COALESCE(epc.full_name, cu.email) AS created_by_name,
        COALESCE(epu.full_name, uu.email) AS updated_by_name,
        COUNT(DISTINCT aa.user_id) AS assigned_users_count,
        GROUP_CONCAT(
          DISTINCT CONCAT(
            u.id,
            '::',
            REPLACE(COALESCE(ep.full_name, u.email), '::', ' '),
            '::',
            REPLACE(COALESCE(u.email, ''), '::', ' ')
          )
          ORDER BY COALESCE(ep.full_name, u.email)
          SEPARATOR '||'
        ) AS assigned_users_blob
      FROM ods_activities a
      INNER JOIN service_orders so ON so.id = a.service_order_id
      LEFT JOIN delivery_media dm ON dm.id = a.delivery_medium_id
      LEFT JOIN users cu ON cu.id = a.created_by
      LEFT JOIN employee_profiles epc ON epc.user_id = cu.id
      LEFT JOIN users uu ON uu.id = a.updated_by
      LEFT JOIN employee_profiles epu ON epu.user_id = uu.id
      LEFT JOIN ods_activity_assignments aa ON aa.activity_id = a.id AND aa.is_active = 1
      LEFT JOIN users u ON u.id = aa.user_id
      LEFT JOIN employee_profiles ep ON ep.user_id = u.id
    ";
  }

  private function buildWhereClause(array $filters, array &$params): string
  {
    $conditions = ["a.deleted_at IS NULL"];

    if (!empty($filters['service_order_id'])) {
      $conditions[] = "a.service_order_id = ?";
      $params[] = (int)$filters['service_order_id'];
    }

    if (!empty($filters['assigned_user_id'])) {
      $conditions[] = "EXISTS (
        SELECT 1
        FROM ods_activity_assignments aa_filter
        WHERE aa_filter.activity_id = a.id
          AND aa_filter.user_id = ?
          AND aa_filter.is_active = 1
      )";
      $params[] = (int)$filters['assigned_user_id'];
    }

    if (!empty($filters['status'])) {
      $conditions[] = "a.status = ?";
      $params[] = $filters['status'];
    }

    if (!empty($filters['search'])) {
      $search = '%' . trim($filters['search']) . '%';
      $conditions[] = "(
        a.title LIKE ?
        OR a.description LIKE ?
        OR COALESCE(a.item_general, '') LIKE ?
        OR COALESCE(a.item_activity, '') LIKE ?
        OR COALESCE(a.support_text, '') LIKE ?
        OR COALESCE(a.notes, '') LIKE ?
        OR so.ods_code LIKE ?
        OR COALESCE(so.project_name, '') LIKE ?
      )";

      for ($i = 0; $i < 8; $i++) {
        $params[] = $search;
      }
    }

    return ' WHERE ' . implode(' AND ', $conditions);
  }

  private function mapCollection(array $rows): array
  {
    return array_map([$this, 'mapRow'], $rows);
  }

  private function mapRow(array $row): array
  {
    $row['assigned_users'] = [];
    $row['assigned_user_ids'] = [];

    if (!empty($row['assigned_users_blob'])) {
      $entries = explode('||', $row['assigned_users_blob']);

      foreach ($entries as $entry) {
        $parts = explode('::', $entry);
        if (count($parts) < 3) {
          continue;
        }

        $row['assigned_users'][] = [
          'id' => (int)$parts[0],
          'name' => $parts[1],
          'email' => $parts[2],
        ];
        $row['assigned_user_ids'][] = (int)$parts[0];
      }
    }

    unset($row['assigned_users_blob']);

    return $row;
  }
}
