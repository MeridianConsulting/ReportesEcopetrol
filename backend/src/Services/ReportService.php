<?php

namespace App\Services;

use App\Core\Database;

/**
 * Adaptado a reportes_ods: tabla tasks solo tiene id (sin status, progress_percent, area_id, etc.).
 * Los reportes usan solo COUNT de tasks y listas mínimas; el resto en ceros/vacío.
 */
class ReportService
{
  private $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  private function countTasks(): int
  {
    try {
      $stmt = $this->db->query("SELECT COUNT(*) FROM tasks");
      return (int) $stmt->fetchColumn();
    } catch (\PDOException $e) {
      return 0;
    }
  }

  public function getDailyReport(?string $date = null, ?int $areaId = null, array $userContext = []): array
  {
    $total = $this->countTasks();
    return [
      'stats' => [
        'total' => $total,
        'completed' => 0,
        'at_risk' => 0,
        'avg_progress' => 0.0,
      ],
      'tasks' => [],
    ];
  }

  public function getManagementReport(?string $dateFrom = null, ?string $dateTo = null): array
  {
    $total = $this->countTasks();
    $byArea = [];
    try {
      $stmt = $this->db->query("SELECT id FROM areas ORDER BY id");
      while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
        $byArea[] = [
          'id' => (int)$row['id'],
          'area_name' => null,
          'total_tasks' => 0,
          'completed' => 0,
          'in_progress' => 0,
          'at_risk' => 0,
          'overdue' => 0,
          'avg_progress' => 0.0,
        ];
      }
    } catch (\PDOException $e) {
      // areas puede tener solo id
    }

    return [
      'general' => [
        'total_tasks' => $total,
        'completed' => 0,
        'in_progress' => 0,
        'at_risk' => 0,
        'overdue' => 0,
        'avg_progress' => 0.0,
      ],
      'by_area' => $byArea,
      'by_type' => [],
      'date_range' => [
        'from' => $dateFrom,
        'to' => $dateTo,
      ],
    ];
  }

  public function getWeeklyEvolution(): array
  {
    $weeks = [];
    for ($i = 11; $i >= 0; $i--) {
      $weekStart = date('Y-m-d', strtotime("-{$i} weeks", strtotime('monday this week')));
      $weekEnd = date('Y-m-d', strtotime('+6 days', strtotime($weekStart)));
      $weeks[] = [
        'week' => date('d/m', strtotime($weekStart)),
        'week_start' => $weekStart,
        'week_end' => $weekEnd,
        'created' => 0,
        'completed' => 0,
        'overdue' => 0,
      ];
    }
    return $weeks;
  }

  public function getQuarterlyCompliance(): array
  {
    $year = date('Y');
    $quarters = [];
    for ($q = 1; $q <= 4; $q++) {
      $startMonth = ($q - 1) * 3 + 1;
      $endMonth = $q * 3;
      $startDate = sprintf('%s-%02d-01', $year, $startMonth);
      $endDate = date('Y-m-t', strtotime(sprintf('%s-%02d-01', $year, $endMonth)));
      $quarters[] = [
        'quarter' => "Q{$q}",
        'label' => "T{$q} {$year}",
        'start_date' => $startDate,
        'end_date' => $endDate,
        'total' => 0,
        'completed' => 0,
        'overdue' => 0,
        'compliance_rate' => 0,
      ];
    }
    return $quarters;
  }

  public function getAdvancedStats(): array
  {
    return [
      'by_priority' => [],
      'upcoming_due' => 0,
      'top_users' => [],
    ];
  }
}
