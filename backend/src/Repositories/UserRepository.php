<?php

namespace App\Repositories;

use App\Core\Database;

/**
 * Adaptado a reportes_ods: users (id, email), user_roles, employee_profiles.
 * No existe role_id/area_id en users; no existe user_areas.
 */
class UserRepository
{
  private $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  /**
   * Login: busca usuario por email.
   * Tablas: users (email, password_hash), employee_profiles (full_name), user_roles + roles (rol).
   * Contraseña por defecto = cédula (external_employee_id), guardada hasheada en users.password_hash.
   */
  public function findByEmail(string $email): ?array
  {
    $stmt = $this->db->prepare("
      SELECT u.id, u.email, u.password_hash,
        ep.full_name AS name,
        (SELECT r.name FROM user_roles ur2 INNER JOIN roles r ON r.id = ur2.role_id WHERE ur2.user_id = u.id LIMIT 1) AS role_name,
        (SELECT ur2.role_id FROM user_roles ur2 WHERE ur2.user_id = u.id LIMIT 1) AS role_id
      FROM users u
      LEFT JOIN employee_profiles ep ON ep.user_id = u.id
      WHERE u.email = :email
    ");
    $stmt->execute([':email' => $email]);
    $user = $stmt->fetch(\PDO::FETCH_ASSOC);
    if (!$user) {
      return null;
    }
    $user['area_id'] = null;
    $user['area_name'] = null;
    $user['is_active'] = true;
    if (!array_key_exists('password_hash', $user)) {
      $user['password_hash'] = null;
    }
    return $user;
  }

  public function findById(int $id): ?array
  {
    try {
      $stmt = $this->db->prepare("
        SELECT u.id, u.email, u.password_hash,
          ep.full_name AS name,
          (SELECT r.name FROM user_roles ur2 INNER JOIN roles r ON r.id = ur2.role_id WHERE ur2.user_id = u.id LIMIT 1) AS role_name,
          (SELECT ur2.role_id FROM user_roles ur2 WHERE ur2.user_id = u.id LIMIT 1) AS role_id
        FROM users u
        LEFT JOIN employee_profiles ep ON ep.user_id = u.id
        WHERE u.id = :id
      ");
      $stmt->execute([':id' => $id]);
      $user = $stmt->fetch(\PDO::FETCH_ASSOC);
      if (!$user) {
        return null;
      }
      $user['area_id'] = null;
      $user['area_name'] = null;
      $user['is_active'] = true;
      return $user;
    } catch (\PDOException $e) {
      error_log('UserRepository::findById error: ' . $e->getMessage());
      throw new \Exception('Database error: ' . $e->getMessage());
    }
  }

  public function findAll(array $filters = []): array
  {
    $sql = "
      SELECT u.id, u.email,
        ep.full_name AS name,
        (SELECT r.name FROM user_roles ur2 INNER JOIN roles r ON r.id = ur2.role_id WHERE ur2.user_id = u.id LIMIT 1) AS role_name,
        (SELECT ur2.role_id FROM user_roles ur2 WHERE ur2.user_id = u.id LIMIT 1) AS role_id
      FROM users u
      LEFT JOIN employee_profiles ep ON ep.user_id = u.id
      WHERE 1=1
    ";
    $params = [];
    $sql .= " ORDER BY COALESCE(ep.full_name, u.email) ASC";
    $stmt = $this->db->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
    foreach ($rows as &$u) {
      $u['area_id'] = null;
      $u['area_name'] = null;
      $u['is_active'] = true;
    }
    return $rows;
  }

  public function create(array $data): int
  {
    $this->db->beginTransaction();
    try {
      $stmt = $this->db->prepare("INSERT INTO users (email) VALUES (:email)");
      $stmt->execute([':email' => $data['email']]);
      $userId = (int) $this->db->lastInsertId();

      $stmt = $this->db->prepare("
        INSERT INTO employee_profiles (user_id, full_name, corporate_email)
        VALUES (:user_id, :full_name, :corporate_email)
      ");
      $stmt->execute([
        ':user_id' => $userId,
        ':full_name' => $data['name'] ?? $data['email'],
        ':corporate_email' => $data['email'],
      ]);

      $roleId = isset($data['role_id']) ? (int)$data['role_id'] : 1;
      $stmt = $this->db->prepare("INSERT INTO user_roles (user_id, role_id) VALUES (:user_id, :role_id)");
      $stmt->execute([':user_id' => $userId, ':role_id' => $roleId]);

      $this->db->commit();
      return $userId;
    } catch (\Exception $e) {
      $this->db->rollBack();
      throw $e;
    }
  }

  public function update(int $id, array $data): bool
  {
    $updates = [];
    $params = [':id' => $id];

    if (array_key_exists('email', $data)) {
      $updates[] = "u.email = :email";
      $params[':email'] = $data['email'];
    }

    if (!empty($updates)) {
      $sql = "UPDATE users u SET " . implode(', ', $updates) . " WHERE u.id = :id";
      $this->db->prepare($sql)->execute($params);
    }

    $profileUpdates = [];
    if (array_key_exists('name', $data)) {
      $profileUpdates['full_name'] = $data['name'];
    }
    if (array_key_exists('email', $data)) {
      $profileUpdates['corporate_email'] = $data['email'];
    }
    if (!empty($profileUpdates)) {
      $set = [];
      $params = [':user_id' => $id];
      foreach ($profileUpdates as $k => $v) {
        $set[] = "`$k` = :$k";
        $params[":$k"] = $v;
      }
      $this->db->prepare("UPDATE employee_profiles SET " . implode(', ', $set) . " WHERE user_id = :user_id")->execute($params);
    }

    if (isset($data['role_id'])) {
      $this->db->prepare("DELETE FROM user_roles WHERE user_id = :id")->execute([':id' => $id]);
      $this->db->prepare("INSERT INTO user_roles (user_id, role_id) VALUES (:user_id, :role_id)")->execute([
        ':user_id' => $id,
        ':role_id' => (int)$data['role_id'],
      ]);
    }

    return true;
  }

  public function delete(int $id): bool
  {
    $this->db->beginTransaction();
    try {
      $this->db->prepare("DELETE FROM user_roles WHERE user_id = :id")->execute([':id' => $id]);
      $this->db->prepare("DELETE FROM employee_profiles WHERE user_id = :id")->execute([':id' => $id]);
      $this->db->prepare("DELETE FROM users WHERE id = :id")->execute([':id' => $id]);
      $this->db->commit();
      return true;
    } catch (\Exception $e) {
      $this->db->rollBack();
      throw $e;
    }
  }

  public function hasTasks(int $id): bool
  {
    try {
      $stmt = $this->db->prepare("SELECT COUNT(*) FROM task_report_links WHERE linked_by = :id");
      $stmt->execute([':id' => $id]);
      return (int)$stmt->fetchColumn() > 0;
    } catch (\PDOException $e) {
      return false;
    }
  }

  public function updatePasswordHash(int $id, string $passwordHash): bool
  {
    try {
      $stmt = $this->db->prepare("UPDATE users SET password_hash = :password_hash WHERE id = :id");
      return $stmt->execute([':id' => $id, ':password_hash' => $passwordHash]);
    } catch (\PDOException $e) {
      return false;
    }
  }

  public function getUserAreas(int $userId): array
  {
    return [];
  }

  public function getUserAreaIds(int $userId): array
  {
    return [];
  }

  public function setUserAreas(int $userId, array $areaIds, ?int $primaryAreaId = null): void
  {
    // No existe user_areas en reportes_ods
  }

  public function enrichWithAreas(?array $user): ?array
  {
    if (!$user || !isset($user['id'])) {
      return $user;
    }
    $user['area_ids'] = [];
    $user['area_names'] = [];
    $user['area_id'] = null;
    $user['area_name'] = null;
    return $user;
  }
}
