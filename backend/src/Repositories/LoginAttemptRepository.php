<?php

namespace App\Repositories;

use App\Core\Database;
use PDO;

/**
 * Adaptado a reportes_ods: tabla login_attempts puede no existir.
 * Si falla la consulta, se retorna valor seguro (sin romper login).
 */
class LoginAttemptRepository
{
  private PDO $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  public function countFailedAttempts(string $ip, int $windowMinutes): int
  {
    try {
      $stmt = $this->db->prepare("
        SELECT COUNT(*) 
        FROM login_attempts
        WHERE ip_address = ? 
          AND success = 0 
          AND attempted_at >= (NOW() - INTERVAL ? MINUTE)
      ");
      $stmt->execute([$ip, $windowMinutes]);
      return (int)$stmt->fetchColumn();
    } catch (\PDOException $e) {
      return 0;
    }
  }

  public function recordAttempt(string $ip, string $email, bool $success, ?string $userAgent = null): void
  {
    try {
      $stmt = $this->db->prepare("
        INSERT INTO login_attempts (ip_address, email, success, user_agent, attempted_at)
        VALUES (?, ?, ?, ?, NOW())
      ");
      $stmt->execute([$ip, $email, $success ? 1 : 0, $userAgent]);
    } catch (\PDOException $e) {
      // Tabla puede no existir
    }
  }

  public function cleanupOldAttempts(): void
  {
    try {
      $stmt = $this->db->prepare("
        DELETE FROM login_attempts
        WHERE attempted_at < (NOW() - INTERVAL 24 HOUR)
      ");
      $stmt->execute();
    } catch (\PDOException $e) {
      // Tabla puede no existir
    }
  }
}
