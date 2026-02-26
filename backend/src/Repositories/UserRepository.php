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
      $user['service_orders'] = $this->getServiceOrdersForUser((int)$user['id']);
      $user['service_order_ids'] = array_map(fn($so) => (int)$so['id'], $user['service_orders']);
      return $user;
    } catch (\PDOException $e) {
      error_log('UserRepository::findById error: ' . $e->getMessage());
      throw new \Exception('Database error: ' . $e->getMessage());
    }
  }

  /**
   * ODS asociados al usuario (service_order_employees + service_orders).
   */
  public function getServiceOrdersForUser(int $userId): array
  {
    try {
      $stmt = $this->db->prepare("
        SELECT so.id, so.ods_code
        FROM service_order_employees soe
        INNER JOIN service_orders so ON so.id = soe.service_order_id
        WHERE soe.user_id = ? AND soe.is_active = 1
        ORDER BY so.ods_code
      ");
      $stmt->execute([$userId]);
      return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    } catch (\PDOException $e) {
      return [];
    }
  }

  /**
   * Sincroniza los ODS del usuario en service_order_employees.
   */
  public function setUserServiceOrders(int $userId, array $serviceOrderIds): void
  {
    $this->db->prepare("DELETE FROM service_order_employees WHERE user_id = ?")->execute([$userId]);
    $serviceOrderIds = array_map('intval', array_filter($serviceOrderIds));
    if (empty($serviceOrderIds)) {
      return;
    }
    $stmt = $this->db->prepare("
      INSERT INTO service_order_employees (service_order_id, user_id, is_active)
      VALUES (?, ?, 1)
    ");
    foreach ($serviceOrderIds as $soId) {
      if ($soId > 0) {
        $stmt->execute([$soId, $userId]);
      }
    }
  }

  public function findAll(array $filters = []): array
  {
    $sql = "
      SELECT DISTINCT u.id, u.email,
        ep.full_name AS name,
        (SELECT r.name FROM user_roles ur2 INNER JOIN roles r ON r.id = ur2.role_id WHERE ur2.user_id = u.id LIMIT 1) AS role_name,
        (SELECT ur2.role_id FROM user_roles ur2 WHERE ur2.user_id = u.id LIMIT 1) AS role_id
      FROM users u
      LEFT JOIN employee_profiles ep ON ep.user_id = u.id
    ";
    $params = [];
    if (!empty($filters['service_order_id'])) {
      $sid = (int) $filters['service_order_id'];
      if ($sid > 0) {
        $sql .= " INNER JOIN service_order_employees soe ON soe.user_id = u.id AND soe.service_order_id = :service_order_id AND soe.is_active = 1 ";
        $params[':service_order_id'] = $sid;
      }
    }
    $sql .= " WHERE 1=1 ";
    $sql .= " ORDER BY COALESCE(ep.full_name, u.email) ASC";
    $stmt = $this->db->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
    $userIds = array_column($rows, 'id');
    $odsByUser = $this->getServiceOrdersByUserIds($userIds);
    foreach ($rows as &$u) {
      $u['area_id'] = null;
      $u['area_name'] = null;
      $u['is_active'] = true;
      $uid = (int)$u['id'];
      $u['service_orders'] = $odsByUser[$uid] ?? [];
      $u['service_order_ids'] = array_map(fn($so) => (int)$so['id'], $u['service_orders']);
    }
    return $rows;
  }

  /**
   * ODS por usuario (para listado).
   */
  public function getServiceOrdersByUserIds(array $userIds): array
  {
    if (empty($userIds)) {
      return [];
    }
    $placeholders = implode(',', array_fill(0, count($userIds), '?'));
    $stmt = $this->db->prepare("
      SELECT soe.user_id, so.id, so.ods_code
      FROM service_order_employees soe
      INNER JOIN service_orders so ON so.id = soe.service_order_id
      WHERE soe.user_id IN ($placeholders) AND soe.is_active = 1
      ORDER BY soe.user_id, so.ods_code
    ");
    $stmt->execute(array_values($userIds));
    $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
    $byUser = [];
    foreach ($rows as $r) {
      $uid = (int)$r['user_id'];
      if (!isset($byUser[$uid])) {
        $byUser[$uid] = [];
      }
      $byUser[$uid][] = ['id' => (int)$r['id'], 'ods_code' => $r['ods_code']];
    }
    return $byUser;
  }

  public function create(array $data): int
  {
    $this->db->beginTransaction();
    try {
      $passwordHash = $data['password_hash'] ?? null;
      $stmt = $this->db->prepare("INSERT INTO users (email, password_hash) VALUES (:email, :password_hash)");
      $stmt->execute([
        ':email' => $data['email'],
        ':password_hash' => $passwordHash,
      ]);
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

      if (!empty($data['service_order_ids']) && is_array($data['service_order_ids'])) {
        $this->setUserServiceOrders($userId, $data['service_order_ids']);
      }

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

    if (array_key_exists('service_order_ids', $data)) {
      $ids = is_array($data['service_order_ids']) ? $data['service_order_ids'] : [];
      $this->setUserServiceOrders($id, $ids);
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
