<?php

namespace App\Repositories;

use App\Core\Database;

class TaskRepository
{
  private $db;

  public function __construct()
  {
    $this->db = Database::getInstance()->getConnection();
  }

  public function findAll(array $filters = [], array $userContext = []): array
  {
    $sql = "
      SELECT t.*, a.name as area_name,
        COALESCE(ad.name, a.name) as area_destinataria_name,
        u.name as responsible_name, kc.name as kpi_category_name
      FROM tasks t
      LEFT JOIN areas a ON t.area_id = a.id
      LEFT JOIN areas ad ON t.area_destinataria_id = ad.id
      LEFT JOIN users u ON t.responsible_id = u.id
      LEFT JOIN kpi_categories kc ON t.kpi_category_id = kc.id
      WHERE (t.deleted_at IS NULL)
    ";

    $params = [];

    // Aplicar filtros de permisos según rol
    $role = $userContext['role'] ?? null;
    $userId = $userContext['id'] ?? null;
    $areaId = $userContext['area_id'] ?? null;
    $areaIds = $userContext['area_ids'] ?? ($areaId ? [$areaId] : []);

    if ($role === 'lider_area' && !empty($areaIds)) {
      $areaPlaceholders = [];
      foreach ($areaIds as $i => $aid) {
        $key = ':user_area_' . $i;
        $areaPlaceholders[] = $key;
        $params[$key] = (int)$aid;
      }
      $sql .= " AND t.area_id IN (" . implode(',', $areaPlaceholders) . ")";
    } elseif ($role === 'lider_area' && $areaId) {
      // Fallback: si no hay area_ids, usar area_id
      $sql .= " AND t.area_id = :user_area_id";
      $params[':user_area_id'] = $areaId;
    } elseif ($role === 'colaborador' && (!empty($areaIds) || $areaId)) {
      // Los colaboradores ven todas las tareas de su área (dashboard del área)
      if (!empty($areaIds)) {
        $areaPlaceholders = [];
        foreach ($areaIds as $i => $aid) {
          $key = ':colab_area_' . $i;
          $areaPlaceholders[] = $key;
          $params[$key] = (int)$aid;
        }
        $sql .= " AND t.area_id IN (" . implode(',', $areaPlaceholders) . ")";
      } else {
        $sql .= " AND t.area_id = :colab_area_id";
        $params[':colab_area_id'] = $areaId;
      }
    }
    // admin ven todo, no se agrega restricción

    // Filtros opcionales
    if (isset($filters['status'])) {
      if ($filters['status'] === 'overdue') {
        $sql .= " AND t.due_date IS NOT NULL AND DATE(t.due_date) < CURDATE() AND t.status != 'Completada'";
      } else {
        $sql .= " AND t.status = :status";
        $params[':status'] = $filters['status'];
      }
    }

    if (isset($filters['priority'])) {
      $sql .= " AND t.priority = :priority";
      $params[':priority'] = $filters['priority'];
    }

    if (isset($filters['type'])) {
      $sql .= " AND t.type = :type";
      $params[':type'] = $filters['type'];
    }

    // Filtro por área responsable (la que realiza la tarea). No usar area_destinataria_id para listados/dashboards.
    if (isset($filters['area_id'])) {
      $sql .= " AND t.area_id = :area_id";
      $params[':area_id'] = $filters['area_id'];
    }

    if (isset($filters['responsible_id'])) {
      $sql .= " AND t.responsible_id = :responsible_id";
      $params[':responsible_id'] = $filters['responsible_id'];
    }

    // Filtros de fecha: por fecha de inicio de actividad (start_date), con respaldo en created_at si está vacía.
    // Incluye "tareas arrastradas": tareas activas (En progreso/En riesgo/En revisión) que iniciaron
    // en o antes del fin del rango y no están cerradas antes del inicio del rango.
    // Regla A: fecha efectiva dentro del rango solicitado.
    // Regla B: tarea activa que sigue en ejecución durante el rango (arrastrada).
    if (isset($filters['date_from']) && isset($filters['date_to'])) {
      $sql .= " AND (
        (COALESCE(DATE(t.start_date), DATE(t.created_at)) >= :date_from
         AND COALESCE(DATE(t.start_date), DATE(t.created_at)) <= :date_to)
        OR
        (t.status NOT IN ('Completada', 'No iniciada')
         AND COALESCE(DATE(t.start_date), DATE(t.created_at)) <= :date_to_drag
         AND (t.closed_date IS NULL OR DATE(t.closed_date) >= :date_from_drag))
      )";
      $params[':date_from'] = $filters['date_from'];
      $params[':date_to'] = $filters['date_to'];
      $params[':date_to_drag'] = $filters['date_to'];
      $params[':date_from_drag'] = $filters['date_from'];
    } elseif (isset($filters['date_from'])) {
      $sql .= " AND (
        COALESCE(DATE(t.start_date), DATE(t.created_at)) >= :date_from
        OR
        (t.status NOT IN ('Completada', 'No iniciada')
         AND COALESCE(DATE(t.start_date), DATE(t.created_at)) <= :date_from_drag
         AND (t.closed_date IS NULL OR DATE(t.closed_date) >= :date_from_drag2))
      )";
      $params[':date_from'] = $filters['date_from'];
      $params[':date_from_drag'] = $filters['date_from'];
      $params[':date_from_drag2'] = $filters['date_from'];
    } elseif (isset($filters['date_to'])) {
      $sql .= " AND COALESCE(DATE(t.start_date), DATE(t.created_at)) <= :date_to";
      $params[':date_to'] = $filters['date_to'];
    }

    // Filtro por fecha de vencimiento
    if (isset($filters['due_from'])) {
      $sql .= " AND DATE(t.due_date) >= :due_from";
      $params[':due_from'] = $filters['due_from'];
    }

    if (isset($filters['due_to'])) {
      $sql .= " AND DATE(t.due_date) <= :due_to";
      $params[':due_to'] = $filters['due_to'];
    }

    $sql .= " ORDER BY t.updated_at DESC";

    try {
      $stmt = $this->db->prepare($sql);
      $stmt->execute($params);
      return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    } catch (\PDOException $e) {
      error_log('TaskRepository::findAll error: ' . $e->getMessage());
      error_log('SQL: ' . $sql);
      error_log('Params: ' . json_encode($params));
      throw new \Exception('Database error: ' . $e->getMessage());
    }
  }

  public function findById(int $id, array $userContext = []): ?array
  {
    $sql = "
      SELECT t.*, a.name as area_name,
        COALESCE(ad.name, a.name) as area_destinataria_name,
        u.name as responsible_name, kc.name as kpi_category_name
      FROM tasks t
      LEFT JOIN areas a ON t.area_id = a.id
      LEFT JOIN areas ad ON t.area_destinataria_id = ad.id
      LEFT JOIN users u ON t.responsible_id = u.id
      LEFT JOIN kpi_categories kc ON t.kpi_category_id = kc.id
      WHERE t.id = :id
    ";

    $params = [':id' => $id];

    // Aplicar filtros de permisos
    $role = $userContext['role'] ?? null;
    $userId = $userContext['id'] ?? null;
    $areaId = $userContext['area_id'] ?? null;
    $areaIds = $userContext['area_ids'] ?? ($areaId ? [$areaId] : []);

    if ($role === 'lider_area' && $userId) {
      $sql .= " AND (t.created_by = :user_id_creator";
      $params[':user_id_creator'] = $userId;
      if (!empty($areaIds)) {
        $areaPlaceholders = [];
        foreach ($areaIds as $i => $aid) {
          $key = ':user_area_' . $i;
          $areaPlaceholders[] = $key;
          $params[$key] = (int)$aid;
        }
        $sql .= " OR t.area_id IN (" . implode(',', $areaPlaceholders) . ")";
      } elseif ($areaId) {
        $sql .= " OR t.area_id = :user_area_id";
        $params[':user_area_id'] = $areaId;
      }
      $sql .= ")";
    } elseif ($role === 'colaborador' && (!empty($areaIds) || $areaId)) {
      // Los colaboradores ven todas las tareas de su área
      if (!empty($areaIds)) {
        $areaPlaceholders = [];
        foreach ($areaIds as $i => $aid) {
          $key = ':colab_area_' . $i;
          $areaPlaceholders[] = $key;
          $params[$key] = (int)$aid;
        }
        $sql .= " AND t.area_id IN (" . implode(',', $areaPlaceholders) . ")";
      } else {
        $sql .= " AND t.area_id = :colab_area_id";
        $params[':colab_area_id'] = $areaId;
      }
    }

    try {
      $stmt = $this->db->prepare($sql);
      $stmt->execute($params);
      $task = $stmt->fetch(\PDO::FETCH_ASSOC);

      return $task ?: null;
    } catch (\PDOException $e) {
      error_log('TaskRepository::findById error: ' . $e->getMessage());
      error_log('SQL: ' . $sql);
      error_log('Params: ' . json_encode($params));
      throw new \Exception('Database error: ' . $e->getMessage());
    }
  }

  public function create(array $data): int
  {
    $sql = "
      INSERT INTO tasks (
        area_id, area_destinataria_id, title, description, type, priority, status,
        progress_percent, observaciones, responsible_id, created_by,
        start_date, due_date, kpi_category_id, kpi_subcategory
      ) VALUES (
        :area_id, :area_destinataria_id, :title, :description, :type, :priority, :status,
        :progress_percent, :observaciones, :responsible_id, :created_by,
        :start_date, :due_date, :kpi_category_id, :kpi_subcategory
      )
    ";

    try {
      // Asegurar que los valores numéricos sean enteros o null
      $areaId = isset($data['area_id']) ? (int)$data['area_id'] : null;
      // Por defecto: si no se envía área destinataria, usar la misma que área responsable
      $areaDestinatariaId = isset($data['area_destinataria_id']) && $data['area_destinataria_id'] !== '' && $data['area_destinataria_id'] !== null
        ? (int)$data['area_destinataria_id']
        : $areaId;
      $responsibleId = isset($data['responsible_id']) && $data['responsible_id'] !== '' && $data['responsible_id'] !== null 
        ? (int)$data['responsible_id'] 
        : null;
      $createdBy = isset($data['created_by']) ? (int)$data['created_by'] : null;
      $progressPercent = isset($data['progress_percent']) ? (int)$data['progress_percent'] : 0;
      $kpiCategoryId = isset($data['kpi_category_id']) && $data['kpi_category_id'] !== '' && $data['kpi_category_id'] !== null
        ? (int)$data['kpi_category_id']
        : null;
      $kpiSubcategory = isset($data['kpi_subcategory']) && $data['kpi_subcategory'] !== '' && $data['kpi_subcategory'] !== null
        ? trim($data['kpi_subcategory'])
        : null;
      
      if (!$areaId) {
        throw new \Exception('El área es requerida');
      }
      
      if (!$createdBy) {
        throw new \Exception('El creador es requerido');
      }
      
      $stmt = $this->db->prepare($sql);
      $stmt->execute([
        ':area_id' => $areaId,
        ':area_destinataria_id' => $areaDestinatariaId,
        ':title' => $data['title'] ?? '',
        ':description' => !empty($data['description']) ? $data['description'] : null,
        ':type' => $data['type'] ?? 'Operativa',
        ':priority' => $data['priority'] ?? 'Media',
        ':status' => $data['status'] ?? 'No iniciada',
        ':progress_percent' => $progressPercent,
        ':observaciones' => !empty($data['observaciones']) ? $data['observaciones'] : null,
        ':responsible_id' => $responsibleId,
        ':created_by' => $createdBy,
        ':start_date' => !empty($data['start_date']) ? $data['start_date'] : null,
        ':due_date' => !empty($data['due_date']) ? $data['due_date'] : null,
        ':kpi_category_id' => $kpiCategoryId,
        ':kpi_subcategory' => $kpiSubcategory,
      ]);

      return (int) $this->db->lastInsertId();
    } catch (\PDOException $e) {
      error_log('TaskRepository::create error: ' . $e->getMessage());
      error_log('SQL: ' . $sql);
      error_log('Data: ' . json_encode($data));
      throw new \Exception('Database error: ' . $e->getMessage());
    }
  }

  public function update(int $id, array $data): bool
  {
    $allowedFields = [
      'title', 'description', 'type', 'priority', 'status',
      'progress_percent', 'observaciones', 'responsible_id', 'area_id', 'area_destinataria_id',
      'start_date', 'due_date', 'closed_date', 'kpi_category_id', 'kpi_subcategory'
    ];

    $updates = [];
    foreach ($allowedFields as $field) {
      if (isset($data[$field])) {
        $updates[] = "$field = :$field";
      }
    }

    if (empty($updates)) {
      return false;
    }

    $sql = "UPDATE tasks SET " . implode(', ', $updates) . " WHERE id = :id";
    $stmt = $this->db->prepare($sql);

    $params = [':id' => $id];
    foreach ($allowedFields as $field) {
      if (isset($data[$field])) {
        $val = $data[$field];
        // Compatibilidad: si area_destinataria_id viene null/vacío, usar area_id
        if ($field === 'area_destinataria_id' && ($val === '' || $val === null)) {
          $val = $data['area_id'] ?? null;
        }
        $params[":$field"] = $val;
      }
    }

    return $stmt->execute($params);
  }

  public function delete(int $id): bool
  {
    $stmt = $this->db->prepare("DELETE FROM tasks WHERE id = :id");
    return $stmt->execute([':id' => $id]);
  }

  /**
   * Consulta paginada por cursor con filtros server-side
   */
  public function findPaginated(array $filters = [], array $userContext = [], int $limit = 100, ?string $cursor = null, string $sort = 'updated_at', string $order = 'desc'): array
  {
    $fromClause = "
      FROM tasks t
      LEFT JOIN areas a ON t.area_id = a.id
      LEFT JOIN areas ad ON t.area_destinataria_id = ad.id
      LEFT JOIN users u ON t.responsible_id = u.id
      LEFT JOIN kpi_categories kc ON t.kpi_category_id = kc.id
    ";

    $baseWhere = " WHERE t.deleted_at IS NULL";
    $params = [];

    // Permisos según rol
    $role = $userContext['role'] ?? null;
    $uid = $userContext['id'] ?? null;
    $uAreaId = $userContext['area_id'] ?? null;
    $uAreaIds = $userContext['area_ids'] ?? ($uAreaId ? [$uAreaId] : []);

    if ($role === 'lider_area' && !empty($uAreaIds)) {
      $areaPlaceholders = [];
      foreach ($uAreaIds as $i => $aid) {
        $key = ':user_area_' . $i;
        $areaPlaceholders[] = $key;
        $params[$key] = (int)$aid;
      }
      $baseWhere .= " AND t.area_id IN (" . implode(',', $areaPlaceholders) . ")";
    } elseif ($role === 'lider_area' && $uAreaId) {
      $baseWhere .= " AND t.area_id = :user_area_id";
      $params[':user_area_id'] = $uAreaId;
    } elseif ($role === 'colaborador' && (!empty($uAreaIds) || $uAreaId)) {
      $baseWhere .= " AND (";
      if (!empty($uAreaIds)) {
        $areaPlaceholders = [];
        foreach ($uAreaIds as $i => $aid) {
          $key = ':colab_area_' . $i;
          $areaPlaceholders[] = $key;
          $params[$key] = (int)$aid;
        }
        $baseWhere .= "t.area_id IN (" . implode(',', $areaPlaceholders) . ")";
      } else {
        $baseWhere .= "t.area_id = :colab_area_id";
        $params[':colab_area_id'] = $uAreaId;
      }
      $baseWhere .= ")";
    }

    if (isset($filters['responsible_id'])) {
      $baseWhere .= " AND t.responsible_id = :responsible_id";
      $params[':responsible_id'] = (int)$filters['responsible_id'];
    }

    // Filtro por start_date y due_date
    // all_dates=1: no aplicar ningún filtro de fecha (mostrar todas las tareas de la persona)
    // Si no: rango por fechas o solo tareas no vencidas
    $allDates = !empty($filters['all_dates']);
    $hasDateFilter = isset($filters['start_date_from']) || isset($filters['start_date_to']);
    $includeNull = isset($filters['include_null_start_date']) && filter_var($filters['include_null_start_date'], FILTER_VALIDATE_BOOLEAN);
    $today = date('Y-m-d');

    if ($allDates) {
      // Sin restricción de fecha: todas las actividades del responsable
    } elseif ($hasDateFilter) {
      $dateOr = [];
      
      // Condición 1: start_date está en el rango
      $startDateRangeAnd = [];
      if (isset($filters['start_date_from'])) {
        $startDateRangeAnd[] = "DATE(t.start_date) >= :sd_from";
        $params[':sd_from'] = $filters['start_date_from'];
      }
      if (isset($filters['start_date_to'])) {
        $startDateRangeAnd[] = "DATE(t.start_date) <= :sd_to";
        $params[':sd_to'] = $filters['start_date_to'];
      }
      if (!empty($startDateRangeAnd)) {
        $dateOr[] = '(' . implode(' AND ', $startDateRangeAnd) . ')';
      }
      
      // Condición 2: due_date está en el rango
      $dueDateRangeAnd = [];
      if (isset($filters['start_date_from'])) {
        $dueDateRangeAnd[] = "DATE(t.due_date) >= :dd_from";
        $params[':dd_from'] = $filters['start_date_from'];
      }
      if (isset($filters['start_date_to'])) {
        $dueDateRangeAnd[] = "DATE(t.due_date) <= :dd_to";
        $params[':dd_to'] = $filters['start_date_to'];
      }
      if (!empty($dueDateRangeAnd)) {
        $dateOr[] = '(' . implode(' AND ', $dueDateRangeAnd) . ')';
      }
    
      // Condición 3: Siempre incluir tareas que aún no se han vencido
      $dateOr[] = "(DATE(t.due_date) >= :today_not_expired OR t.due_date IS NULL)";
      $params[':today_not_expired'] = $today;
      
      if ($includeNull) {
        $dateOr[] = "t.start_date IS NULL";
      }
      
      if (!empty($dateOr)) {
        $baseWhere .= " AND (" . implode(' OR ', $dateOr) . ")";
      }
    } elseif ($includeNull) {
      // Si no hay filtro de fecha pero se incluyen nulls, también mostrar tareas no vencidas
      $baseWhere .= " AND (t.start_date IS NULL OR DATE(t.due_date) >= :today_not_expired_null OR t.due_date IS NULL)";
      $params[':today_not_expired_null'] = $today;
    } else {
      // Si no hay filtro de fecha ni all_dates, mostrar solo tareas no vencidas
      $baseWhere .= " AND (DATE(t.due_date) >= :today_default OR t.due_date IS NULL)";
      $params[':today_default'] = $today;
    }

    if (isset($filters['status'])) {
      if (is_array($filters['status'])) {
        $placeholders = [];
        foreach ($filters['status'] as $i => $v) {
          $key = ':f_status_' . $i;
          $placeholders[] = $key;
          $params[$key] = $v;
        }
        $baseWhere .= " AND t.status IN (" . implode(',', $placeholders) . ")";
      } else {
        $baseWhere .= " AND t.status = :f_status";
        $params[':f_status'] = $filters['status'];
      }
    }
    if (isset($filters['priority'])) {
      if (is_array($filters['priority'])) {
        $placeholders = [];
        foreach ($filters['priority'] as $i => $v) {
          $key = ':f_priority_' . $i;
          $placeholders[] = $key;
          $params[$key] = $v;
        }
        $baseWhere .= " AND t.priority IN (" . implode(',', $placeholders) . ")";
      } else {
        $baseWhere .= " AND t.priority = :f_priority";
        $params[':f_priority'] = $filters['priority'];
      }
    }
    if (isset($filters['kpi_category_id'])) {
      if (is_array($filters['kpi_category_id'])) {
        $placeholders = [];
        foreach ($filters['kpi_category_id'] as $i => $v) {
          $key = ':f_kpi_' . $i;
          $placeholders[] = $key;
          $params[$key] = (int)$v;
        }
        $baseWhere .= " AND t.kpi_category_id IN (" . implode(',', $placeholders) . ")";
      } else {
        $baseWhere .= " AND t.kpi_category_id = :f_kpi";
        $params[':f_kpi'] = (int)$filters['kpi_category_id'];
      }
    }
    if (isset($filters['area_id'])) {
      $baseWhere .= " AND t.area_id = :f_area";
      $params[':f_area'] = (int)$filters['area_id'];
    }

    // COUNT total (sin paginación)
    $total = 0;
    try {
      $countStmt = $this->db->prepare("SELECT COUNT(*) " . $fromClause . $baseWhere);
      foreach ($params as $k => $v) { $countStmt->bindValue($k, $v); }
      $countStmt->execute();
      $total = (int)$countStmt->fetchColumn();
    } catch (\PDOException $e) {
      error_log('TaskRepository::findPaginated count error: ' . $e->getMessage());
    }

    // Orden
    $allowed = ['updated_at', 'start_date', 'due_date', 'created_at'];
    $sortCol = in_array($sort, $allowed) ? $sort : 'updated_at';
    $dir = strtolower($order) === 'asc' ? 'ASC' : 'DESC';
    $comp = $dir === 'DESC' ? '<' : '>';

    // Cursor (solo para datos, no para count)
    $dataWhere = $baseWhere;
    $dataParams = $params;

    if ($cursor) {
      $decoded = base64_decode($cursor, true);
      if ($decoded !== false) {
        $sep = strrpos($decoded, '|');
        if ($sep !== false) {
          $cv = substr($decoded, 0, $sep);
          $ci = (int)substr($decoded, $sep + 1);
          $dataWhere .= " AND (t.{$sortCol} {$comp} :cur_v OR (t.{$sortCol} = :cur_v2 AND t.id {$comp} :cur_id))";
          $dataParams[':cur_v'] = $cv;
          $dataParams[':cur_v2'] = $cv;
          $dataParams[':cur_id'] = $ci;
        }
      }
    }

    $realLimit = min(max($limit, 1), 100);

    $dataSql = "
      SELECT t.*, a.name as area_name,
        COALESCE(ad.name, a.name) as area_destinataria_name,
        u.name as responsible_name, kc.name as kpi_category_name
    " . $fromClause . $dataWhere . "
      ORDER BY t.{$sortCol} {$dir}, t.id {$dir}
      LIMIT :pg_limit
    ";

    try {
      $stmt = $this->db->prepare($dataSql);
      foreach ($dataParams as $k => $v) { $stmt->bindValue($k, $v); }
      $stmt->bindValue(':pg_limit', $realLimit + 1, \PDO::PARAM_INT);
      $stmt->execute();
      $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);

      $hasMore = count($rows) > $realLimit;
      if ($hasMore) { array_pop($rows); }

      $nextCursor = null;
      if ($hasMore && !empty($rows)) {
        $last = end($rows);
        $nextCursor = base64_encode(($last[$sortCol] ?? '') . '|' . $last['id']);
      }

      return [
        'items' => $rows,
        'has_more' => $hasMore,
        'next_cursor' => $nextCursor,
        'total' => $total,
      ];
    } catch (\PDOException $e) {
      error_log('TaskRepository::findPaginated error: ' . $e->getMessage());
      error_log('SQL: ' . $dataSql);
      throw new \Exception('Database error: ' . $e->getMessage());
    }
  }

  /**
   * Estadísticas rápidas por estado para un responsable
   */
  public function getStats(int $responsibleId): array
  {
    $sql = "
      SELECT
        COUNT(*) as total,
        SUM(CASE WHEN status = 'Completada' THEN 1 ELSE 0 END) as completed,
        SUM(CASE WHEN status = 'En progreso' THEN 1 ELSE 0 END) as pending,
        SUM(CASE WHEN status = 'En riesgo' THEN 1 ELSE 0 END) as at_risk
      FROM tasks
      WHERE responsible_id = :responsible_id
        AND deleted_at IS NULL
    ";

    try {
      $stmt = $this->db->prepare($sql);
      $stmt->execute([':responsible_id' => $responsibleId]);
      $row = $stmt->fetch(\PDO::FETCH_ASSOC);
      return [
        'total' => (int)($row['total'] ?? 0),
        'completed' => (int)($row['completed'] ?? 0),
        'pending' => (int)($row['pending'] ?? 0),
        'at_risk' => (int)($row['at_risk'] ?? 0),
      ];
    } catch (\PDOException $e) {
      error_log('TaskRepository::getStats error: ' . $e->getMessage());
      throw new \Exception('Database error: ' . $e->getMessage());
    }
  }
}

