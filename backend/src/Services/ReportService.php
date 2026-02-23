<?php

namespace App\Services;

use App\Core\Database;

class ReportService
{
  private $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  public function getDailyReport(?string $date = null, ?int $areaId = null, array $userContext = []): array
  {
    $date = $date ?: date('Y-m-d');
    $role = $userContext['role'] ?? null;
    $userAreaId = $userContext['area_id'] ?? null;
    $userAreaIds = $userContext['area_ids'] ?? ($userAreaId ? [$userAreaId] : []);

    // Restricción por área si es lider_area
    $areaFilter = '';
    $params = [':date' => $date];

    if ($role === 'lider_area' && !empty($userAreaIds)) {
      $areaPlaceholders = [];
      foreach ($userAreaIds as $i => $aid) {
        $key = ':user_area_' . $i;
        $areaPlaceholders[] = $key;
        $params[$key] = (int)$aid;
      }
      $areaFilter = " AND t.area_id IN (" . implode(',', $areaPlaceholders) . ")";
    } elseif ($areaId) {
      $areaFilter = " AND t.area_id = :area_id";
      $params[':area_id'] = $areaId;
    }

    // Estadísticas
    $statsSql = "
      SELECT
        COUNT(*) as total,
        SUM(CASE WHEN status = 'Completada' THEN 1 ELSE 0 END) as completed,
        SUM(CASE WHEN status = 'En riesgo' THEN 1 ELSE 0 END) as at_risk,
        AVG(progress_percent) as avg_progress
      FROM tasks t
      WHERE DATE(updated_at) = :date
      $areaFilter
    ";

    $stmt = $this->db->prepare($statsSql);
    $stmt->execute($params);
    $stats = $stmt->fetch();

    // Tareas del día
    $tasksSql = "
      SELECT t.*, a.name as area_name, u.name as responsible_name
      FROM tasks t
      LEFT JOIN areas a ON t.area_id = a.id
      LEFT JOIN users u ON t.responsible_id = u.id
      WHERE DATE(t.updated_at) = :date
      $areaFilter
      ORDER BY t.updated_at DESC
    ";

    $stmt = $this->db->prepare($tasksSql);
    $stmt->execute($params);
    $tasks = $stmt->fetchAll();

    return [
      'stats' => [
        'total' => (int)($stats['total'] ?? 0),
        'completed' => (int)($stats['completed'] ?? 0),
        'at_risk' => (int)($stats['at_risk'] ?? 0),
        'avg_progress' => round((float)($stats['avg_progress'] ?? 0), 2),
      ],
      'tasks' => $tasks,
    ];
  }

  public function getManagementReport(?string $dateFrom = null, ?string $dateTo = null): array
  {
    // Mismo criterio de fechas que TaskRepository: fecha efectiva = COALESCE(start_date, created_at)
    // e incluye tareas "arrastradas" (activas que siguen en ejecución en el rango).
    $dateWhere = '';
    $params = [];

    if ($dateFrom !== null && $dateFrom !== '' && $dateTo !== null && $dateTo !== '') {
      $dateWhere = " AND (
        (COALESCE(DATE(start_date), DATE(created_at)) >= :date_from AND COALESCE(DATE(start_date), DATE(created_at)) <= :date_to)
        OR (status NOT IN ('Completada', 'No iniciada')
          AND COALESCE(DATE(start_date), DATE(created_at)) <= :date_to_drag
          AND (closed_date IS NULL OR DATE(closed_date) >= :date_from_drag))
      )";
      $params[':date_from'] = $dateFrom;
      $params[':date_to'] = $dateTo;
      $params[':date_to_drag'] = $dateTo;
      $params[':date_from_drag'] = $dateFrom;
    } elseif ($dateFrom !== null && $dateFrom !== '') {
      $dateWhere = " AND (
        COALESCE(DATE(start_date), DATE(created_at)) >= :date_from
        OR (status NOT IN ('Completada', 'No iniciada')
          AND COALESCE(DATE(start_date), DATE(created_at)) <= :date_from_drag
          AND (closed_date IS NULL OR DATE(closed_date) >= :date_from_drag2))
      )";
      $params[':date_from'] = $dateFrom;
      $params[':date_from_drag'] = $dateFrom;
      $params[':date_from_drag2'] = $dateFrom;
    } elseif ($dateTo !== null && $dateTo !== '') {
      $dateWhere = " AND COALESCE(DATE(start_date), DATE(created_at)) <= :date_to";
      $params[':date_to'] = $dateTo;
    }

    $baseWhere = " WHERE (deleted_at IS NULL)" . $dateWhere;

    // Vencidas: tienen fecha límite, ya pasada (antes de hoy), y no están completadas
    $overdueCond = "due_date IS NOT NULL AND due_date < CURDATE() AND status != 'Completada'";

    // Estadísticas generales (incluye in_progress y avg_progress para consistencia con el frontend)
    $generalSql = "
      SELECT
        COUNT(*) as total_tasks,
        SUM(CASE WHEN status = 'Completada' THEN 1 ELSE 0 END) as completed,
        SUM(CASE WHEN status = 'En progreso' THEN 1 ELSE 0 END) as in_progress,
        SUM(CASE WHEN status = 'En riesgo' THEN 1 ELSE 0 END) as at_risk,
        SUM(CASE WHEN $overdueCond THEN 1 ELSE 0 END) as overdue,
        AVG(progress_percent) as avg_progress
      FROM tasks
      $baseWhere
    ";

    $stmt = $this->db->prepare($generalSql);
    $stmt->execute($params);
    $general = $stmt->fetch();

    // Por área: mismo filtro de fecha en el JOIN
    $areaJoinCond = "a.id = t.area_id AND (t.deleted_at IS NULL)" . str_replace(
      ['start_date', 'created_at', 'closed_date', 'status', 'deleted_at'],
      ['t.start_date', 't.created_at', 't.closed_date', 't.status', 't.deleted_at'],
      $dateWhere
    );
    $byAreaSql = "
      SELECT
        a.id,
        a.name as area_name,
        COUNT(t.id) as total_tasks,
        SUM(CASE WHEN t.status = 'Completada' THEN 1 ELSE 0 END) as completed,
        SUM(CASE WHEN t.status = 'En progreso' THEN 1 ELSE 0 END) as in_progress,
        SUM(CASE WHEN t.status = 'En riesgo' THEN 1 ELSE 0 END) as at_risk,
        SUM(CASE WHEN t.due_date IS NOT NULL AND t.due_date < CURDATE() AND t.status != 'Completada' THEN 1 ELSE 0 END) as overdue,
        AVG(t.progress_percent) as avg_progress
      FROM areas a
      LEFT JOIN tasks t ON $areaJoinCond
      GROUP BY a.id, a.name
      ORDER BY a.name
    ";

    $stmt = $this->db->prepare($byAreaSql);
    $stmt->execute($params);
    $byArea = $stmt->fetchAll();

    // Por tipo con el mismo filtro de fecha
    $byTypeSql = "
      SELECT type, COUNT(*) as count
      FROM tasks
      $baseWhere
      GROUP BY type
      ORDER BY count DESC
    ";

    $stmt = $this->db->prepare($byTypeSql);
    $stmt->execute($params);
    $byType = $stmt->fetchAll();

    return [
      'general' => [
        'total_tasks' => (int)($general['total_tasks'] ?? 0),
        'completed' => (int)($general['completed'] ?? 0),
        'in_progress' => (int)($general['in_progress'] ?? 0),
        'at_risk' => (int)($general['at_risk'] ?? 0),
        'overdue' => (int)($general['overdue'] ?? 0),
        'avg_progress' => round((float)($general['avg_progress'] ?? 0), 2),
      ],
      'by_area' => array_map(function($area) {
        return [
          'id' => (int)$area['id'],
          'area_name' => $area['area_name'],
          'total_tasks' => (int)($area['total_tasks'] ?? 0),
          'completed' => (int)($area['completed'] ?? 0),
          'in_progress' => (int)($area['in_progress'] ?? 0),
          'at_risk' => (int)($area['at_risk'] ?? 0),
          'overdue' => (int)($area['overdue'] ?? 0),
          'avg_progress' => round((float)($area['avg_progress'] ?? 0), 2),
        ];
      }, $byArea),
      'by_type' => array_map(function($type) {
        return [
          'type' => $type['type'],
          'count' => (int)$type['count'],
        ];
      }, $byType),
      'date_range' => [
        'from' => $dateFrom,
        'to' => $dateTo
      ]
    ];
  }

  /**
   * Obtener evolución semanal de tareas (últimas 12 semanas)
   */
  public function getWeeklyEvolution(): array
  {
    $weeks = [];
    
    // Obtener datos de las últimas 12 semanas
    for ($i = 11; $i >= 0; $i--) {
      $weekStart = date('Y-m-d', strtotime("-{$i} weeks", strtotime('monday this week')));
      $weekEnd = date('Y-m-d', strtotime('+6 days', strtotime($weekStart)));
      
      $sql = "
        SELECT
          COUNT(*) as total_created,
          SUM(CASE WHEN status = 'Completada' THEN 1 ELSE 0 END) as completed,
          SUM(CASE WHEN due_date < :week_end AND status != 'Completada' AND due_date >= :week_start THEN 1 ELSE 0 END) as overdue_in_week
        FROM tasks
        WHERE DATE(created_at) BETWEEN :start AND :end
          AND (deleted_at IS NULL)
      ";
      
      $stmt = $this->db->prepare($sql);
      $stmt->execute([
        ':start' => $weekStart,
        ':end' => $weekEnd,
        ':week_start' => $weekStart,
        ':week_end' => $weekEnd
      ]);
      $data = $stmt->fetch();
      
      // También contar tareas que vencieron esa semana
      $sqlOverdue = "
        SELECT COUNT(*) as overdue
        FROM tasks
        WHERE DATE(due_date) BETWEEN :start AND :end
          AND status != 'Completada'
          AND (deleted_at IS NULL)
      ";
      $stmtOverdue = $this->db->prepare($sqlOverdue);
      $stmtOverdue->execute([':start' => $weekStart, ':end' => $weekEnd]);
      $overdueData = $stmtOverdue->fetch();
      
      $weeks[] = [
        'week' => date('d/m', strtotime($weekStart)),
        'week_start' => $weekStart,
        'week_end' => $weekEnd,
        'created' => (int)($data['total_created'] ?? 0),
        'completed' => (int)($data['completed'] ?? 0),
        'overdue' => (int)($overdueData['overdue'] ?? 0)
      ];
    }
    
    return $weeks;
  }

  /**
   * Obtener cumplimiento por trimestre del año actual
   */
  public function getQuarterlyCompliance(): array
  {
    $year = date('Y');
    $quarters = [];
    
    for ($q = 1; $q <= 4; $q++) {
      $startMonth = ($q - 1) * 3 + 1;
      $endMonth = $q * 3;
      $startDate = sprintf('%s-%02d-01', $year, $startMonth);
      $endDate = date('Y-m-t', strtotime(sprintf('%s-%02d-01', $year, $endMonth)));
      
      $sql = "
        SELECT
          COUNT(*) as total,
          SUM(CASE WHEN status = 'Completada' THEN 1 ELSE 0 END) as completed,
          SUM(CASE WHEN due_date IS NOT NULL AND due_date < CURDATE() AND status != 'Completada' THEN 1 ELSE 0 END) as overdue
        FROM tasks
        WHERE DATE(created_at) BETWEEN :start AND :end
          AND (deleted_at IS NULL)
      ";
      
      $stmt = $this->db->prepare($sql);
      $stmt->execute([':start' => $startDate, ':end' => $endDate]);
      $data = $stmt->fetch();
      
      $total = (int)($data['total'] ?? 0);
      $completed = (int)($data['completed'] ?? 0);
      
      $quarters[] = [
        'quarter' => "Q{$q}",
        'label' => "T{$q} {$year}",
        'start_date' => $startDate,
        'end_date' => $endDate,
        'total' => $total,
        'completed' => $completed,
        'overdue' => (int)($data['overdue'] ?? 0),
        'compliance_rate' => $total > 0 ? round(($completed / $total) * 100, 1) : 0
      ];
    }
    
    return $quarters;
  }

  /**
   * Obtener estadísticas avanzadas adicionales
   */
  public function getAdvancedStats(): array
  {
    // Tareas por prioridad (solo no eliminadas)
    $prioritySql = "
      SELECT priority, COUNT(*) as count
      FROM tasks
      WHERE (deleted_at IS NULL)
      GROUP BY priority
      ORDER BY FIELD(priority, 'Alta', 'Media', 'Baja')
    ";
    $stmt = $this->db->query($prioritySql);
    $byPriority = $stmt->fetchAll();
    
    // Tareas próximas a vencer (7 días)
    $upcomingSql = "
      SELECT COUNT(*) as count
      FROM tasks
      WHERE due_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
        AND status != 'Completada'
        AND (deleted_at IS NULL)
    ";
    $stmt = $this->db->query($upcomingSql);
    $upcoming = $stmt->fetch();
    
    // Productividad por usuario (top 10, solo tareas no eliminadas)
    $productivitySql = "
      SELECT 
        u.id,
        u.name,
        COUNT(t.id) as total_tasks,
        SUM(CASE WHEN t.status = 'Completada' THEN 1 ELSE 0 END) as completed,
        AVG(t.progress_percent) as avg_progress
      FROM users u
      LEFT JOIN tasks t ON u.id = t.responsible_id AND (t.deleted_at IS NULL)
      WHERE u.is_active = 1
      GROUP BY u.id, u.name
      HAVING total_tasks > 0
      ORDER BY completed DESC, avg_progress DESC
      LIMIT 10
    ";
    $stmt = $this->db->query($productivitySql);
    $topUsers = $stmt->fetchAll();
    
    return [
      'by_priority' => array_map(function($item) {
        return [
          'priority' => $item['priority'] ?? 'Sin prioridad',
          'count' => (int)$item['count']
        ];
      }, $byPriority),
      'upcoming_due' => (int)($upcoming['count'] ?? 0),
      'top_users' => array_map(function($user) {
        $total = (int)($user['total_tasks'] ?? 0);
        $completed = (int)($user['completed'] ?? 0);
        return [
          'id' => (int)$user['id'],
          'name' => $user['name'],
          'total_tasks' => $total,
          'completed' => $completed,
          'avg_progress' => round((float)($user['avg_progress'] ?? 0), 1),
          'completion_rate' => $total > 0 ? round(($completed / $total) * 100, 1) : 0
        ];
      }, $topUsers)
    ];
  }
}

