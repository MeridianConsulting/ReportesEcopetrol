<?php

namespace App\Repositories;

use App\Core\Database;

class UserRepository
{
  private $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  public function findByEmail(string $email): ?array
  {
    $stmt = $this->db->prepare("
      SELECT u.*, r.name as role_name, a.name as area_name
      FROM users u
      LEFT JOIN roles r ON u.role_id = r.id
      LEFT JOIN areas a ON u.area_id = a.id
      WHERE u.email = :email
    ");
    $stmt->execute([':email' => $email]);
    $user = $stmt->fetch(\PDO::FETCH_ASSOC);

    return $user ?: null;
  }

  public function findById(int $id): ?array
  {
    try {
      $stmt = $this->db->prepare("
        SELECT u.*, r.name as role_name, a.name as area_name
        FROM users u
        LEFT JOIN roles r ON u.role_id = r.id
        LEFT JOIN areas a ON u.area_id = a.id
        WHERE u.id = :id
      ");
      $stmt->execute([':id' => $id]);
      $user = $stmt->fetch(\PDO::FETCH_ASSOC);

      return $user ?: null;
    } catch (\PDOException $e) {
      error_log('UserRepository::findById error: ' . $e->getMessage());
      error_log('SQL: SELECT u.*, r.name as role_name, a.name as area_name FROM users u LEFT JOIN roles r ON u.role_id = r.id LEFT JOIN areas a ON u.area_id = a.id WHERE u.id = ' . $id);
      throw new \Exception('Database error: ' . $e->getMessage());
    }
  }

  public function findAll(array $filters = []): array
  {
    $sql = "
      SELECT u.*, r.name as role_name, a.name as area_name
      FROM users u
      LEFT JOIN roles r ON u.role_id = r.id
      LEFT JOIN areas a ON u.area_id = a.id
      WHERE 1=1
    ";

    $params = [];

    if (isset($filters['is_active'])) {
      $sql .= " AND u.is_active = :is_active";
      $params[':is_active'] = $filters['is_active'];
    }

    $sql .= " ORDER BY u.created_at DESC";

    $stmt = $this->db->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll(\PDO::FETCH_ASSOC);
  }

  public function create(array $data): int
  {
    $sql = "
      INSERT INTO users (name, email, password_hash, role_id, area_id, is_active)
      VALUES (:name, :email, :password_hash, :role_id, :area_id, :is_active)
    ";

    $stmt = $this->db->prepare($sql);
    $stmt->execute([
      ':name' => $data['name'],
      ':email' => $data['email'],
      ':password_hash' => $data['password_hash'],
      ':role_id' => $data['role_id'],
      ':area_id' => $data['area_id'] ?? null,
      ':is_active' => $data['is_active'] ?? 1,
    ]);

    return (int) $this->db->lastInsertId();
  }

  public function update(int $id, array $data): bool
  {
    $allowedFields = ['name', 'email', 'password_hash', 'role_id', 'area_id', 'is_active'];
    $updates = [];

    foreach ($allowedFields as $field) {
      if (isset($data[$field])) {
        $updates[] = "$field = :$field";
      }
    }

    if (empty($updates)) {
      return false;
    }

    $sql = "UPDATE users SET " . implode(', ', $updates) . " WHERE id = :id";
    $stmt = $this->db->prepare($sql);

    $params = [':id' => $id];
    foreach ($allowedFields as $field) {
      if (isset($data[$field])) {
        $params[":$field"] = $data[$field];
      }
    }

    return $stmt->execute($params);
  }

  public function delete(int $id): bool
  {
    $stmt = $this->db->prepare("DELETE FROM users WHERE id = :id");
    return $stmt->execute([':id' => $id]);
  }

  public function hasTasks(int $id): bool
  {
    $stmt = $this->db->prepare("SELECT COUNT(*) FROM tasks WHERE responsible_id = :id OR created_by = :id2");
    $stmt->execute([':id' => $id, ':id2' => $id]);
    return (int)$stmt->fetchColumn() > 0;
  }

  public function updatePasswordHash(int $id, string $passwordHash): bool
  {
    $stmt = $this->db->prepare("UPDATE users SET password_hash = :password_hash WHERE id = :id");
    return $stmt->execute([
      ':id' => $id,
      ':password_hash' => $passwordHash,
    ]);
  }

  // =========================================================
  // Soporte multi-área (tabla user_areas)
  // =========================================================

  /**
   * Obtener todas las áreas de un usuario desde user_areas
   */
  public function getUserAreas(int $userId): array
  {
    $stmt = $this->db->prepare("
      SELECT ua.area_id, ua.is_primary, a.name as area_name, a.code as area_code
      FROM user_areas ua
      INNER JOIN areas a ON ua.area_id = a.id
      WHERE ua.user_id = :user_id
      ORDER BY ua.is_primary DESC, a.name ASC
    ");
    $stmt->execute([':user_id' => $userId]);
    return $stmt->fetchAll(\PDO::FETCH_ASSOC);
  }

  /**
   * Obtener solo los IDs de áreas de un usuario
   */
  public function getUserAreaIds(int $userId): array
  {
    $stmt = $this->db->prepare("SELECT area_id FROM user_areas WHERE user_id = :user_id");
    $stmt->execute([':user_id' => $userId]);
    return array_column($stmt->fetchAll(\PDO::FETCH_ASSOC), 'area_id');
  }

  /**
   * Establecer las áreas de un usuario (reemplaza todas las existentes)
   */
  public function setUserAreas(int $userId, array $areaIds, ?int $primaryAreaId = null): void
  {
    // Eliminar áreas actuales
    $stmt = $this->db->prepare("DELETE FROM user_areas WHERE user_id = :user_id");
    $stmt->execute([':user_id' => $userId]);

    if (empty($areaIds)) {
      return;
    }

    // Si no se especifica primary, usar la primera
    if ($primaryAreaId === null || !in_array($primaryAreaId, $areaIds)) {
      $primaryAreaId = $areaIds[0];
    }

    // Insertar nuevas áreas
    $insertStmt = $this->db->prepare("
      INSERT INTO user_areas (user_id, area_id, is_primary) VALUES (:user_id, :area_id, :is_primary)
    ");

    foreach ($areaIds as $areaId) {
      $insertStmt->execute([
        ':user_id' => $userId,
        ':area_id' => (int)$areaId,
        ':is_primary' => ($areaId == $primaryAreaId) ? 1 : 0,
      ]);
    }
  }

  /**
   * Enriquecer datos de usuario con sus áreas múltiples
   */
  public function enrichWithAreas(?array $user): ?array
  {
    if (!$user || !isset($user['id'])) {
      return $user;
    }

    $areas = $this->getUserAreas((int)$user['id']);
    $user['area_ids'] = array_map(fn($a) => (int)$a['area_id'], $areas);
    $user['area_names'] = array_map(fn($a) => $a['area_name'], $areas);

    // Si user_areas tiene datos, sincronizar area_id con el primary
    if (!empty($areas)) {
      $primary = array_filter($areas, fn($a) => $a['is_primary']);
      if (!empty($primary)) {
        $primaryArea = array_values($primary)[0];
        // Solo actualizar si el area_id actual difiere del primary en user_areas
        if ((int)($user['area_id'] ?? 0) !== (int)$primaryArea['area_id']) {
          $user['area_id'] = (int)$primaryArea['area_id'];
          $user['area_name'] = $primaryArea['area_name'];
        }
      }
    } else {
      // Si no hay user_areas pero hay area_id en users, usar ese
      if (!empty($user['area_id'])) {
        $user['area_ids'] = [(int)$user['area_id']];
        $user['area_names'] = [$user['area_name'] ?? ''];
      }
    }

    return $user;
  }
}

