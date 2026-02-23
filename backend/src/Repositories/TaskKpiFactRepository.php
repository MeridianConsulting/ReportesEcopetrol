<?php

namespace App\Repositories;

use App\Core\Database;

/**
 * Repositorio para la tabla task_kpi_facts
 * Maneja las mediciones por tarea para los KPIs
 */
class TaskKpiFactRepository
{
    /** Estados que cuentan como "tarea terminada" */
    private const DONE_STATUSES = ['Completada', 'Cerrada', 'Finalizada'];

    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Upsert de un fact (crear o actualizar)
     */
    public function upsertFact(array $data): int
    {
        $sql = "
            INSERT INTO task_kpi_facts 
                (task_id, kpi_id, area_id, period_key, numerator, denominator, 
                 sample_value, is_applicable, na_reason, meta_json, computed_at)
            VALUES 
                (:task_id, :kpi_id, :area_id, :period_key, :numerator, :denominator,
                 :sample_value, :is_applicable, :na_reason, :meta_json, NOW())
            ON DUPLICATE KEY UPDATE
                numerator = VALUES(numerator),
                denominator = VALUES(denominator),
                sample_value = VALUES(sample_value),
                is_applicable = VALUES(is_applicable),
                na_reason = VALUES(na_reason),
                meta_json = VALUES(meta_json),
                computed_at = NOW(),
                updated_at = NOW()
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            ':task_id' => $data['task_id'],
            ':kpi_id' => $data['kpi_id'],
            ':area_id' => $data['area_id'],
            ':period_key' => $data['period_key'],
            ':numerator' => $data['numerator'] ?? 0,
            ':denominator' => $data['denominator'] ?? 0,
            ':sample_value' => $data['sample_value'] ?? null,
            ':is_applicable' => $data['is_applicable'] ?? 1,
            ':na_reason' => $data['na_reason'] ?? null,
            ':meta_json' => isset($data['meta']) ? json_encode($data['meta']) : null,
        ]);

        return (int)$this->db->lastInsertId();
    }

    /**
     * Obtener fact por tarea y KPI
     */
    public function findByTaskAndKpi(int $taskId, int $kpiId): ?array
    {
        $sql = "SELECT * FROM task_kpi_facts WHERE task_id = :task_id AND kpi_id = :kpi_id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':task_id' => $taskId, ':kpi_id' => $kpiId]);
        $fact = $stmt->fetch(\PDO::FETCH_ASSOC);
        return $fact ?: null;
    }

    /**
     * Obtener facts por tarea
     */
    public function findByTask(int $taskId): array
    {
        $sql = "
            SELECT f.*, k.code as kpi_code, k.name as kpi_name, k.calc_kind, k.unit
            FROM task_kpi_facts f
            INNER JOIN kpis k ON f.kpi_id = k.id
            WHERE f.task_id = :task_id
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':task_id' => $taskId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Eliminar facts de una tarea
     */
    public function deleteByTask(int $taskId): bool
    {
        $sql = "DELETE FROM task_kpi_facts WHERE task_id = :task_id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':task_id' => $taskId]);
    }

    /**
     * Marcar facts como no aplicables
     */
    public function markNotApplicable(int $taskId, string $reason = null): bool
    {
        $sql = "UPDATE task_kpi_facts SET is_applicable = 0, na_reason = :reason WHERE task_id = :task_id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':task_id' => $taskId, ':reason' => $reason]);
    }

    /**
     * Sumar facts por KPI para un área.
     * periodKey (YYYY-MM): filtra por mes. dateFrom/dateTo: filtran por fecha efectiva de la tarea.
     * Si ambos son null: sin filtro de periodo/fecha (todo el historial).
     */
    public function sumFactsByKpi(int $areaId, ?string $periodKey = null, ?string $dateFrom = null, ?string $dateTo = null): array
    {
        $sql = "
            SELECT 
                f.kpi_id,
                k.code as kpi_code,
                k.name as kpi_name,
                k.unit,
                k.is_inverted,
                SUM(f.numerator) as total_numerator,
                SUM(f.denominator) as total_denominator,
                COUNT(DISTINCT t.id) as task_count,
                SUM(
                    CASE
                        WHEN t.closed_date IS NOT NULL
                             OR TRIM(LOWER(COALESCE(t.status,''))) IN ('completada','cerrada','finalizada')
                        THEN 1 ELSE 0
                    END
                ) as done_count,
                SUM(CASE WHEN f.is_applicable = 1 THEN 1 ELSE 0 END) as applicable_count
            FROM task_kpi_facts f
            INNER JOIN kpis k ON f.kpi_id = k.id
            INNER JOIN tasks t ON f.task_id = t.id
            INNER JOIN kpi_categories kc ON k.id = kc.kpi_id AND kc.area_id = f.area_id AND kc.is_active = 1
            WHERE f.area_id = :area_id 
              AND k.calc_kind = 'RATIO_SUM'
              AND t.deleted_at IS NULL
        ";
        $params = [':area_id' => $areaId];
        if ($periodKey !== null && $periodKey !== '') {
            $sql .= " AND f.period_key = :period_key";
            $params[':period_key'] = $periodKey;
        }
        $effectiveDate = 'COALESCE(t.closed_date, t.due_date, t.start_date, t.created_at)';
        if ($dateFrom !== null && $dateFrom !== '') {
            $sql .= " AND {$effectiveDate} >= :date_from";
            $params[':date_from'] = $dateFrom;
        }
        if ($dateTo !== null && $dateTo !== '') {
            $sql .= " AND {$effectiveDate} <= :date_to";
            $params[':date_to'] = $dateTo;
        }
        $sql .= " GROUP BY f.kpi_id, k.code, k.name, k.unit, k.is_inverted";
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Contar tareas y completadas por KPI para un área (mismo criterio de fechas que countTasksByAreaAndPeriod).
     * Usa area_id (área que realiza la tarea), no area_destinataria_id.
     * Devuelve [ kpi_id => ['task_count' => int, 'done_count' => int] ].
     */
    public function countTasksAndDoneByAreaAndPeriod(int $areaId, ?string $periodKey = null, ?string $dateFrom = null, ?string $dateTo = null): array
    {
        $effectiveDate = "COALESCE(t.closed_date, t.due_date, t.start_date, t.created_at)";
        $sql = "
            SELECT 
                kc.kpi_id,
                COUNT(t.id) as task_count,
                SUM(
                    CASE
                        WHEN t.closed_date IS NOT NULL
                             OR TRIM(LOWER(COALESCE(t.status,''))) IN ('completada','cerrada','finalizada')
                        THEN 1 ELSE 0
                    END
                ) as done_count
            FROM tasks t
            INNER JOIN kpi_categories kc ON t.kpi_category_id = kc.id AND kc.area_id = t.area_id
            WHERE t.area_id = :area_id
              AND t.deleted_at IS NULL
              AND t.kpi_category_id IS NOT NULL
        ";
        $params = [':area_id' => $areaId];
        if ($periodKey !== null && $periodKey !== '') {
            $sql .= " AND DATE_FORMAT({$effectiveDate}, '%Y-%m') = :period_key";
            $params[':period_key'] = $periodKey;
        }
        if ($dateFrom !== null && $dateFrom !== '') {
            $sql .= " AND {$effectiveDate} >= :date_from";
            $params[':date_from'] = $dateFrom;
        }
        if ($dateTo !== null && $dateTo !== '') {
            $sql .= " AND {$effectiveDate} <= :date_to";
            $params[':date_to'] = $dateTo;
        }
        $sql .= " GROUP BY kc.kpi_id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        $map = [];
        foreach ($rows as $row) {
            $map[(int)$row['kpi_id']] = [
                'task_count' => (int)$row['task_count'],
                'done_count' => (int)$row['done_count'],
            ];
        }
        return $map;
    }

    /**
     * Promediar facts por KPI para un área (periodKey o dateFrom/dateTo; si ambos null, todo).
     */
    public function avgFactsByKpi(int $areaId, ?string $periodKey = null, ?string $dateFrom = null, ?string $dateTo = null): array
    {
        $sql = "
            SELECT 
                f.kpi_id,
                k.code as kpi_code,
                k.name as kpi_name,
                k.unit,
                k.is_inverted,
                AVG(f.sample_value) as avg_value,
                COUNT(*) as task_count,
                SUM(
                    CASE
                        WHEN t.closed_date IS NOT NULL
                             OR TRIM(LOWER(COALESCE(t.status,''))) IN ('completada','cerrada','finalizada')
                        THEN 1 ELSE 0
                    END
                ) as done_count,
                SUM(CASE WHEN f.is_applicable = 1 THEN 1 ELSE 0 END) as applicable_count
            FROM task_kpi_facts f
            INNER JOIN kpis k ON f.kpi_id = k.id
            INNER JOIN tasks t ON f.task_id = t.id
            INNER JOIN kpi_categories kc ON k.id = kc.kpi_id AND kc.area_id = f.area_id AND kc.is_active = 1
            WHERE f.area_id = :area_id 
              AND k.calc_kind = 'AVG'
              AND f.is_applicable = 1
              AND f.sample_value IS NOT NULL
              AND t.deleted_at IS NULL
        ";
        $params = [':area_id' => $areaId];
        if ($periodKey !== null && $periodKey !== '') {
            $sql .= " AND f.period_key = :period_key";
            $params[':period_key'] = $periodKey;
        }
        $effectiveDate = 'COALESCE(t.closed_date, t.due_date, t.start_date, t.created_at)';
        if ($dateFrom !== null && $dateFrom !== '') {
            $sql .= " AND {$effectiveDate} >= :date_from";
            $params[':date_from'] = $dateFrom;
        }
        if ($dateTo !== null && $dateTo !== '') {
            $sql .= " AND {$effectiveDate} <= :date_to";
            $params[':date_to'] = $dateTo;
        }
        $sql .= " GROUP BY f.kpi_id, k.code, k.name, k.unit, k.is_inverted";
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Obtener detalle de tareas que aportan a un KPI (para auditoría)
     */
    public function getTasksForKpi(int $kpiId, int $areaId, string $periodKey): array
    {
        $sql = "
            SELECT 
                t.id as task_id,
                t.title,
                t.status,
                t.due_date,
                t.closed_date,
                f.numerator,
                f.denominator,
                f.sample_value,
                f.is_applicable,
                f.na_reason,
                f.meta_json,
                f.computed_at
            FROM task_kpi_facts f
            INNER JOIN tasks t ON f.task_id = t.id
            WHERE f.kpi_id = :kpi_id 
              AND f.area_id = :area_id 
              AND f.period_key = :period_key
              AND t.deleted_at IS NULL
            ORDER BY t.due_date DESC
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            ':kpi_id' => $kpiId,
            ':area_id' => $areaId,
            ':period_key' => $periodKey
        ]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Obtener periodos disponibles para un área
     */
    public function getAvailablePeriods(int $areaId): array
    {
        $sql = "
            SELECT DISTINCT period_key 
            FROM task_kpi_facts 
            WHERE area_id = :area_id 
            ORDER BY period_key DESC
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':area_id' => $areaId]);
        return $stmt->fetchAll(\PDO::FETCH_COLUMN);
    }

    /**
     * Contar tareas por KPI (periodKey YYYY-MM, o dateFrom/dateTo; si ambos null, todo).
     * Usa area_id (área que realiza la tarea), no area_destinataria_id.
     * Devuelve [ kpi_id => task_count ].
     */
    public function countTasksByAreaAndPeriod(int $areaId, ?string $periodKey = null, ?string $dateFrom = null, ?string $dateTo = null): array
    {
        $effectiveDate = "COALESCE(t.closed_date, t.due_date, t.start_date, t.created_at)";
        $sql = "
            SELECT kc.kpi_id, COUNT(t.id) as task_count
            FROM tasks t
            INNER JOIN kpi_categories kc ON t.kpi_category_id = kc.id AND kc.area_id = t.area_id
            WHERE t.area_id = :area_id
              AND t.deleted_at IS NULL
              AND t.kpi_category_id IS NOT NULL
        ";
        $params = [':area_id' => $areaId];
        if ($periodKey !== null && $periodKey !== '') {
            $sql .= " AND DATE_FORMAT({$effectiveDate}, '%Y-%m') = :period_key";
            $params[':period_key'] = $periodKey;
        }
        if ($dateFrom !== null && $dateFrom !== '') {
            $sql .= " AND {$effectiveDate} >= :date_from";
            $params[':date_from'] = $dateFrom;
        }
        if ($dateTo !== null && $dateTo !== '') {
            $sql .= " AND {$effectiveDate} <= :date_to";
            $params[':date_to'] = $dateTo;
        }
        $sql .= " GROUP BY kc.kpi_id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        $map = [];
        foreach ($rows as $row) {
            $map[(int)$row['kpi_id']] = (int)$row['task_count'];
        }
        return $map;
    }
}
