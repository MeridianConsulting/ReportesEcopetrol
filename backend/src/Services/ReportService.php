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

  /**
   * Líneas de reporte del usuario actual (reportes ODS).
   * Incluye observations si existe la columna en report_lines.
   */
  public function getMyReportLines(int $userId): array
  {
    try {
      $sql = "
        SELECT
          so.ods_code,
          rp.label AS period_label,
          r.report_date,
          ep.full_name AS reporter_name,
          rl.item_general,
          rl.item_activity,
          rl.activity_description,
          rl.support_text,
          dm.name AS delivery_medium_name,
          rl.delivery_medium_id,
          rl.contracted_days,
          rl.days_month,
          rl.progress_percent,
          rl.accumulated_days,
          rl.accumulated_progress,
          r.id AS report_id,
          rl.id AS report_line_id
        FROM reports r
        INNER JOIN report_lines rl ON rl.report_id = r.id
        INNER JOIN service_orders so ON so.id = r.service_order_id
        INNER JOIN report_periods rp ON rp.id = r.period_id
        LEFT JOIN employee_profiles ep ON ep.user_id = r.reported_by
        LEFT JOIN delivery_media dm ON dm.id = rl.delivery_medium_id
        WHERE r.reported_by = :user_id
          AND (r.deleted_at IS NULL AND r.is_active = 1)
        ORDER BY r.report_date DESC, r.id DESC, rl.sort_order ASC, rl.id ASC
      ";
      $stmt = $this->db->prepare($sql);
      $stmt->execute([':user_id' => $userId]);
      $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
      // Añadir observations si la columna existe (evitar error si no se ejecutó la migración)
      try {
        $stmt2 = $this->db->query("SELECT observations FROM report_lines LIMIT 0");
        $hasObservations = true;
      } catch (\PDOException $e) {
        $hasObservations = false;
      }
      if ($hasObservations && !empty($rows)) {
        $ids = array_column($rows, 'report_line_id');
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmtObs = $this->db->prepare("SELECT id, observations FROM report_lines WHERE id IN ($placeholders)");
        $stmtObs->execute(array_values($ids));
        $obsMap = [];
        while ($r = $stmtObs->fetch(\PDO::FETCH_ASSOC)) {
          $obsMap[$r['id']] = $r['observations'] ?? '';
        }
        foreach ($rows as &$row) {
          $row['observations'] = $obsMap[$row['report_line_id']] ?? '';
        }
      } else {
        foreach ($rows as &$row) {
          $row['observations'] = '';
        }
      }
      return $rows;
    } catch (\PDOException $e) {
      return [];
    }
  }

  /**
   * Líneas de reporte para exportación (GP-F-23, etc.).
   * - Admin puede solicitar por user_id; si no, se usa el usuario autenticado.
   * - Filtro opcional por date_from, date_to (r.report_date) y service_order_id (ODS).
   */
  public function getReportLinesForExport(int $requestingUserId, ?int $filterUserId, ?string $dateFrom, ?string $dateTo, ?int $serviceOrderId = null): array
  {
    $userId = $filterUserId !== null && $filterUserId > 0 ? $filterUserId : $requestingUserId;

    $conditions = ["r.reported_by = :user_id", "(r.deleted_at IS NULL AND r.is_active = 1)"];
    $params = [':user_id' => $userId];

    if ($dateFrom !== null && $dateFrom !== '') {
      $conditions[] = "r.report_date >= :date_from";
      $params[':date_from'] = $dateFrom;
    }
    if ($dateTo !== null && $dateTo !== '') {
      $conditions[] = "r.report_date <= :date_to";
      $params[':date_to'] = $dateTo;
    }
    if ($serviceOrderId !== null && $serviceOrderId > 0) {
      $conditions[] = "r.service_order_id = :service_order_id";
      $params[':service_order_id'] = $serviceOrderId;
    }

    $where = implode(' AND ', $conditions);
    $sql = "
      SELECT
        so.ods_code,
        rp.label AS period_label,
        r.report_date,
        ep.full_name AS reporter_name,
        rl.item_general,
        rl.item_activity,
        rl.activity_description,
        rl.support_text,
        dm.name AS delivery_medium_name,
        rl.delivery_medium_id,
        rl.contracted_days,
        rl.days_month,
        rl.progress_percent,
        rl.accumulated_days,
        rl.accumulated_progress,
        r.id AS report_id,
        rl.id AS report_line_id
      FROM reports r
      INNER JOIN report_lines rl ON rl.report_id = r.id
      INNER JOIN service_orders so ON so.id = r.service_order_id
      INNER JOIN report_periods rp ON rp.id = r.period_id
      LEFT JOIN employee_profiles ep ON ep.user_id = r.reported_by
      LEFT JOIN delivery_media dm ON dm.id = rl.delivery_medium_id
      WHERE {$where}
      ORDER BY r.report_date ASC, r.id ASC, rl.sort_order ASC, rl.id ASC
    ";
    try {
      $stmt = $this->db->prepare($sql);
      $stmt->execute($params);
      $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
      try {
        $this->db->query("SELECT observations FROM report_lines LIMIT 0");
        $hasObservations = true;
      } catch (\PDOException $e) {
        $hasObservations = false;
      }
      if ($hasObservations && !empty($rows)) {
        $ids = array_column($rows, 'report_line_id');
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmtObs = $this->db->prepare("SELECT id, observations FROM report_lines WHERE id IN ($placeholders)");
        $stmtObs->execute(array_values($ids));
        $obsMap = [];
        while ($r = $stmtObs->fetch(\PDO::FETCH_ASSOC)) {
          $obsMap[$r['id']] = $r['observations'] ?? '';
        }
        foreach ($rows as &$row) {
          $row['observations'] = $obsMap[$row['report_line_id']] ?? '';
        }
      } else {
        foreach ($rows as &$row) {
          $row['observations'] = '';
        }
      }
      return $rows;
    } catch (\PDOException $e) {
      return [];
    }
  }

  /** Lista de órdenes de servicio (código ODS) para selector */
  public function getServiceOrdersList(): array
  {
    try {
      $stmt = $this->db->query("SELECT id, ods_code FROM service_orders ORDER BY ods_code");
      return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    } catch (\PDOException $e) {
      return [];
    }
  }

  /**
   * ODS asociado al usuario por perfil (service_order_employees).
   * Se usa para asignar automáticamente la orden de servicio al crear reportes.
   */
  public function getDefaultServiceOrderForUser(int $userId): ?array
  {
    try {
      $stmt = $this->db->prepare("
        SELECT so.id, so.ods_code
        FROM service_order_employees soe
        INNER JOIN service_orders so ON so.id = soe.service_order_id
        WHERE soe.user_id = ? AND soe.is_active = 1
        ORDER BY soe.id
        LIMIT 1
      ");
      $stmt->execute([$userId]);
      $row = $stmt->fetch(\PDO::FETCH_ASSOC);
      return $row ? ['id' => (int) $row['id'], 'ods_code' => $row['ods_code']] : null;
    } catch (\PDOException $e) {
      return null;
    }
  }

  /**
   * Obtener period_id a partir de una fecha (YYYY-MM-DD). Deriva el mes (YYYY-MM) y busca en report_periods.
   */
  public function getPeriodIdFromReportDate(string $reportDate): ?int
  {
    try {
      $ts = strtotime($reportDate);
      if ($ts === false) {
        return null;
      }
      $label = date('Y-m', $ts);
      $stmt = $this->db->prepare("SELECT id FROM report_periods WHERE label = ? LIMIT 1");
      $stmt->execute([$label]);
      $row = $stmt->fetch(\PDO::FETCH_ASSOC);
      return $row ? (int) $row['id'] : null;
    } catch (\PDOException $e) {
      return null;
    }
  }

  /**
   * Obtener o crear el período para la fecha de reporte.
   * Si no existe un período con label YYYY-MM, lo crea (start_date = día 1, end_date = último día del mes).
   */
  public function getOrCreatePeriodFromReportDate(string $reportDate): int
  {
    $ts = strtotime($reportDate);
    if ($ts === false) {
      throw new \InvalidArgumentException('Fecha de reporte no válida.');
    }
    $year = (int) date('Y', $ts);
    $month = (int) date('n', $ts);
    $label = date('Y-m', $ts);
    $startDate = date('Y-m-01', $ts);
    $endDate = date('Y-m-t', $ts);

    $stmt = $this->db->prepare("SELECT id FROM report_periods WHERE label = ? LIMIT 1");
    $stmt->execute([$label]);
    $row = $stmt->fetch(\PDO::FETCH_ASSOC);
    if ($row) {
      return (int) $row['id'];
    }

    $this->db->prepare("
      INSERT INTO report_periods (year, month, label, start_date, end_date)
      VALUES (?, ?, ?, ?, ?)
    ")->execute([$year, $month, $label, $startDate, $endDate]);
    return (int) $this->db->lastInsertId();
  }

  /** Lista de períodos (mes a reportar) para selector */
  public function getReportPeriodsList(): array
  {
    try {
      $stmt = $this->db->query("SELECT id, label, year, month FROM report_periods ORDER BY year DESC, month DESC LIMIT 60");
      return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    } catch (\PDOException $e) {
      return [];
    }
  }

  /** Lista de medios de entrega para selector */
  public function getDeliveryMediaList(): array
  {
    try {
      $stmt = $this->db->query("SELECT id, name FROM delivery_media WHERE is_active = 1 ORDER BY name");
      return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    } catch (\PDOException $e) {
      return [];
    }
  }

  /**
   * Obtener o crear reporte (reports) para service_order + period + user.
   * Devuelve report id.
   */
  public function getOrCreateReport(int $userId, int $serviceOrderId, int $periodId, string $reportDate): int
  {
    $stmt = $this->db->prepare("
      SELECT id FROM reports
      WHERE service_order_id = ? AND period_id = ? AND reported_by = ? AND (deleted_at IS NULL AND is_active = 1)
      LIMIT 1
    ");
    $stmt->execute([$serviceOrderId, $periodId, $userId]);
    $row = $stmt->fetch(\PDO::FETCH_ASSOC);
    if ($row) {
      return (int) $row['id'];
    }
    $this->db->prepare("
      INSERT INTO reports (service_order_id, period_id, reported_by, report_date, status, is_active)
      VALUES (?, ?, ?, ?, 'Borrador', 1)
    ")->execute([$serviceOrderId, $periodId, $userId, $reportDate]);
    return (int) $this->db->lastInsertId();
  }

  /**
   * Crear una línea de reporte. Payload: codigo_orden_servicio (o service_order_id), mes (period_id o label),
   * fecha_reporte, item_general, item_activity, activity_description, support_text, delivery_medium_id (o medio_entrega nombre),
   * contracted_days, days_month, progress_percent, accumulated_days, accumulated_progress, observations.
   */
  public function storeReportLine(int $userId, array $payload): array
  {
    $serviceOrderId = null;
    if (!empty($payload['service_order_id'])) {
      $serviceOrderId = (int) $payload['service_order_id'];
    } elseif (!empty($payload['codigo_orden_servicio'])) {
      $stmt = $this->db->prepare("SELECT id FROM service_orders WHERE ods_code = ? LIMIT 1");
      $stmt->execute([trim($payload['codigo_orden_servicio'])]);
      $r = $stmt->fetch(\PDO::FETCH_ASSOC);
      $serviceOrderId = $r ? (int) $r['id'] : null;
    }
    if (!$serviceOrderId) {
      $default = $this->getDefaultServiceOrderForUser($userId);
      $serviceOrderId = $default ? (int) $default['id'] : null;
    }
    if (!$serviceOrderId) {
      throw new \InvalidArgumentException('No tiene una orden de servicio (ODS) asociada en su perfil. Contacte al administrador.');
    }

    $reportDate = !empty($payload['fecha_reporte']) ? $payload['fecha_reporte'] : date('Y-m-d');

    $periodId = null;
    if (!empty($payload['period_id'])) {
      $periodId = (int) $payload['period_id'];
    } elseif (!empty($payload['mes_a_reportar'])) {
      $stmt = $this->db->prepare("SELECT id FROM report_periods WHERE label = ? LIMIT 1");
      $stmt->execute([trim($payload['mes_a_reportar'])]);
      $r = $stmt->fetch(\PDO::FETCH_ASSOC);
      $periodId = $r ? (int) $r['id'] : null;
    }
    if (!$periodId) {
      $periodId = $this->getPeriodIdFromReportDate($reportDate);
    }
    if (!$periodId) {
      $periodId = $this->getOrCreatePeriodFromReportDate($reportDate);
    }
    $reportId = $this->getOrCreateReport($userId, $serviceOrderId, $periodId, $reportDate);

    $deliveryMediumId = null;
    if (!empty($payload['delivery_medium_id'])) {
      $deliveryMediumId = (int) $payload['delivery_medium_id'];
    } elseif (!empty($payload['medio_entrega'])) {
      $stmt = $this->db->prepare("SELECT id FROM delivery_media WHERE name = ? AND is_active = 1 LIMIT 1");
      $stmt->execute([trim($payload['medio_entrega'])]);
      $r = $stmt->fetch(\PDO::FETCH_ASSOC);
      $deliveryMediumId = $r ? (int) $r['id'] : null;
    }

    $contractedDays = isset($payload['contracted_days']) ? (int) $payload['contracted_days'] : null;
    $daysMonth = isset($payload['days_month']) ? (float) str_replace(',', '.', $payload['days_month']) : 0;
    $progressPercent = isset($payload['progress_percent']) ? (float) str_replace(',', '.', $payload['progress_percent']) : 0;
    $accumulatedDays = isset($payload['accumulated_days']) ? (float) str_replace(',', '.', $payload['accumulated_days']) : 0;
    $accumulatedProgress = isset($payload['accumulated_progress']) ? (float) str_replace(',', '.', $payload['accumulated_progress']) : 0;
    $observations = isset($payload['observations']) ? (string) $payload['observations'] : null;

    $sql = "INSERT INTO report_lines (
      report_id, item_general, item_activity, activity_description, support_text,
      delivery_medium_id, contracted_days, days_month, progress_percent, accumulated_days, accumulated_progress, sort_order
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";
    $params = [
      $reportId,
      $payload['item_general'] ?? '',
      $payload['item_activity'] ?? '',
      $payload['activity_description'] ?? '',
      $payload['support_text'] ?? null,
      $deliveryMediumId,
      $contractedDays,
      $daysMonth,
      $progressPercent,
      $accumulatedDays,
      $accumulatedProgress,
    ];
    $this->db->prepare($sql)->execute($params);
    $lineId = (int) $this->db->lastInsertId();

    if ($observations !== null) {
      try {
        $this->db->prepare("UPDATE report_lines SET observations = ? WHERE id = ?")->execute([$observations, $lineId]);
      } catch (\PDOException $e) {
        // Columna observations puede no existir
      }
    }

    return ['report_line_id' => $lineId, 'report_id' => $reportId];
  }

  /**
   * Actualizar una línea de reporte. El usuario solo puede editar líneas propias (vía report.reported_by).
   */
  public function updateReportLine(int $userId, int $lineId, array $payload): void
  {
    $stmt = $this->db->prepare("
      SELECT rl.id FROM report_lines rl
      INNER JOIN reports r ON r.id = rl.report_id
      WHERE rl.id = ? AND r.reported_by = ? AND r.deleted_at IS NULL AND r.is_active = 1
    ");
    $stmt->execute([$lineId, $userId]);
    if (!$stmt->fetch()) {
      throw new \RuntimeException('Línea no encontrada o sin permiso.');
    }

    $updates = [];
    $params = [];
    $fields = [
      'item_general' => 'string', 'item_activity' => 'string', 'activity_description' => 'string',
      'support_text' => 'string', 'delivery_medium_id' => 'int', 'contracted_days' => 'int',
      'days_month' => 'float', 'progress_percent' => 'float', 'accumulated_days' => 'float', 'accumulated_progress' => 'float', 'observations' => 'string'
    ];
    foreach ($fields as $key => $type) {
      if (!array_key_exists($key, $payload)) continue;
      if ($type === 'int') {
        $updates[] = "`$key` = ?";
        $params[] = $payload[$key] === '' || $payload[$key] === null ? null : (int) $payload[$key];
      } elseif ($type === 'float') {
        $updates[] = "`$key` = ?";
        $params[] = (float) str_replace(',', '.', $payload[$key]);
      } else {
        $updates[] = "`$key` = ?";
        $params[] = $payload[$key] === null ? null : (string) $payload[$key];
      }
    }
    if (empty($updates)) {
      return;
    }
    $params[] = $lineId;
    $sql = "UPDATE report_lines SET " . implode(', ', $updates) . " WHERE id = ?";
    $this->db->prepare($sql)->execute($params);
  }

  /** Eliminar línea de reporte (solo si el reporte es del usuario). */
  public function deleteReportLine(int $userId, int $lineId): void
  {
    $stmt = $this->db->prepare("
      SELECT rl.id FROM report_lines rl
      INNER JOIN reports r ON r.id = rl.report_id
      WHERE rl.id = ? AND r.reported_by = ? AND r.deleted_at IS NULL AND r.is_active = 1
    ");
    $stmt->execute([$lineId, $userId]);
    if (!$stmt->fetch()) {
      throw new \RuntimeException('Línea no encontrada o sin permiso.');
    }
    $this->db->prepare("DELETE FROM report_lines WHERE id = ?")->execute([$lineId]);
  }
}
