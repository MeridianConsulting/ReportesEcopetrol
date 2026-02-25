<?php

namespace App\Repositories;

use App\Core\Database;

/**
 * Adaptado a reportes_ods: tabla areas solo tiene id.
 */
class AreaRepository
{
  private $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  public function findAll(): array
  {
    try {
      $stmt = $this->db->query("SELECT id FROM areas ORDER BY id");
      return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    } catch (\PDOException $e) {
      return [];
    }
  }

  public function findById(int $id): ?array
  {
    $stmt = $this->db->prepare("SELECT id FROM areas WHERE id = :id");
    $stmt->execute([':id' => $id]);
    $area = $stmt->fetch(\PDO::FETCH_ASSOC);
    return $area ?: null;
  }

  public function create(array $data): int
  {
    $stmt = $this->db->prepare("INSERT INTO areas (id) VALUES (NULL)");
    $stmt->execute();
    return (int) $this->db->lastInsertId();
  }

  public function update(int $id, array $data): bool
  {
    return true;
  }

  public function delete(int $id): bool
  {
    $stmt = $this->db->prepare("DELETE FROM areas WHERE id = :id");
    return $stmt->execute([':id' => $id]);
  }

  public function hasUsers(int $id): bool
  {
    try {
      $stmt = $this->db->prepare("SELECT COUNT(*) FROM service_orders WHERE area_id = :id");
      $stmt->execute([':id' => $id]);
      return (int)$stmt->fetchColumn() > 0;
    } catch (\PDOException $e) {
      return false;
    }
  }

  public function hasTasks(int $id): bool
  {
    return false;
  }
}
