<?php

namespace App\Services;

use App\Repositories\KpiRepository;
use App\Repositories\KpiCategoryRepository;
use App\Repositories\TaskKpiFactRepository;
use App\Core\Database;

/**
 * Servicio para generar resúmenes de KPIs
 * Usado para el dashboard y reportes
 */
class KpiSummaryService
{
    private KpiRepository $kpiRepository;
    private KpiCategoryRepository $categoryRepository;
    private TaskKpiFactRepository $factRepository;
    private $db;

    public function __construct()
    {
        $this->kpiRepository = new KpiRepository();
        $this->categoryRepository = new KpiCategoryRepository();
        $this->factRepository = new TaskKpiFactRepository();
        $this->db = Database::getInstance()->getConnection();
    }

    /** Limita un valor porcentual al rango 0–100 (para que el color se evalúe correctamente). */
    private static function capPercent(float $value): float
    {
        return min(100.0, max(0.0, $value));
    }

    /**
     * Obtener resumen de KPIs para un área.
     * - periodKey (YYYY-MM): filtra por mes (legacy).
     * - dateFrom/dateTo: filtran por rango de fechas de la tarea (due_date/closed_date/start_date).
     * - Si periodKey es null y dateFrom/dateTo son null: sin filtro (todo el historial).
     */
    public function getSummary(int $areaId, ?string $periodKey = null, ?string $dateFrom = null, ?string $dateTo = null): array
    {
        $summary = [];

        // Obtener KPIs de tipo RATIO_SUM
        $ratioFacts = $this->factRepository->sumFactsByKpi($areaId, $periodKey, $dateFrom, $dateTo);
        foreach ($ratioFacts as $fact) {
            $value = null;
            $isNA = true;
            $taskCount = (int)($fact['task_count'] ?? 0);
            $doneCount = (int)($fact['done_count'] ?? 0);

            if ((float)$fact['total_denominator'] > 0) {
                $value = ((float)$fact['total_numerator'] / (float)$fact['total_denominator']) * 100;
                $isNA = false;
            } elseif ($taskCount > 0) {
                // Sin medición en facts pero hay tareas: usar tasa de cumplimiento (completadas/total)
                $value = round(($doneCount / $taskCount) * 100, 1);
                $isNA = false;
            }

            // No mostrar 0% cuando hay tareas cerradas: usar cumplimiento (done/total) como mínimo
            if (!$isNA && $taskCount > 0 && $doneCount > 0 && (float)$value === 0.0) {
                $value = round(($doneCount / $taskCount) * 100, 1);
            }

            // Porcentaje solo entre 0 y 100 (respeta umbrales/colores)
            if (!$isNA) {
                $value = self::capPercent((float)$value);
            }

            // Evaluar color del semáforo
            $threshold = $this->kpiRepository->evaluateThreshold($fact['kpi_id'], $isNA ? null : $value);

            $summary[] = [
                'kpi_id' => $fact['kpi_id'],
                'kpi_code' => $fact['kpi_code'],
                'kpi_name' => $fact['kpi_name'],
                'calc_kind' => 'RATIO_SUM',
                'unit' => $fact['unit'],
                'value' => $isNA ? null : round($value, 2),
                'numerator' => (float)$fact['total_numerator'],
                'denominator' => (float)$fact['total_denominator'],
                'task_count' => $taskCount,
                'applicable_count' => (int)$fact['applicable_count'],
                'color' => strtolower($threshold['color']),
                'color_label' => $threshold['label'],
                'is_na' => $isNA,
                'is_inverted' => (bool)$fact['is_inverted']
            ];
        }

        // Obtener KPIs de tipo AVG
        $avgFacts = $this->factRepository->avgFactsByKpi($areaId, $periodKey, $dateFrom, $dateTo);
        foreach ($avgFacts as $fact) {
            $taskCount = (int)($fact['task_count'] ?? 0);
            $doneCount = (int)($fact['done_count'] ?? 0);

            $value = $fact['avg_value'] !== null ? (float)$fact['avg_value'] : null;
            $isNA = $value === null;

            // Fallback: si no hay medición pero sí hay tareas, mostrar cumplimiento (done/total)
            if ($isNA && $taskCount > 0) {
                $value = round(($doneCount / $taskCount) * 100, 1);
                $isNA = false;
            }

            // Si la unidad es porcentaje, limitar a 0–100 (respeta umbrales/colores)
            $unit = strtoupper($fact['unit'] ?? '');
            if (!$isNA && ($unit === 'PERCENT' || $unit === '%')) {
                $value = self::capPercent((float)$value);
            }

            // Evaluar color del semáforo
            $threshold = $this->kpiRepository->evaluateThreshold($fact['kpi_id'], $value);

            $summary[] = [
                'kpi_id' => $fact['kpi_id'],
                'kpi_code' => $fact['kpi_code'],
                'kpi_name' => $fact['kpi_name'],
                'calc_kind' => 'AVG',
                'unit' => $fact['unit'],
                'value' => $isNA ? null : round($value, 2),
                'numerator' => null,
                'denominator' => null,
                'task_count' => $taskCount,
                'done_count' => $doneCount,
                'applicable_count' => (int)$fact['applicable_count'],
                'color' => strtolower($threshold['color']),
                'color_label' => $threshold['label'],
                'is_na' => $isNA,
                'is_inverted' => (bool)$fact['is_inverted']
            ];
        }

        // Completar con KPIs que no tienen facts pero sí tareas asignadas (conteo real desde tasks)
        $allKpis = $this->kpiRepository->getKpisByArea($areaId);
        $existingKpiIds = array_column($summary, 'kpi_id');
        $taskAndDoneByKpi = $this->factRepository->countTasksAndDoneByAreaAndPeriod($areaId, $periodKey, $dateFrom, $dateTo);

        foreach ($allKpis as $kpi) {
            if (!in_array($kpi['id'], $existingKpiIds)) {
                $info = $taskAndDoneByKpi[$kpi['id']] ?? ['task_count' => 0, 'done_count' => 0];
                $taskCount = (int)$info['task_count'];
                $doneCount = (int)$info['done_count'];
                $value = null;
                $isNA = true;

                // RATIO_SUM o AVG: si hay tareas, mostrar al menos tasa de cumplimiento (completadas/total)
                if ($taskCount > 0 && in_array($kpi['calc_kind'], ['RATIO_SUM', 'AVG'], true)) {
                    $value = self::capPercent(round(($doneCount / $taskCount) * 100, 1));
                    $isNA = false;
                }

                $threshold = $this->kpiRepository->evaluateThreshold($kpi['id'], $isNA ? null : $value);
                $summary[] = [
                    'kpi_id' => $kpi['id'],
                    'kpi_code' => $kpi['code'],
                    'kpi_name' => $kpi['name'],
                    'calc_kind' => $kpi['calc_kind'],
                    'unit' => $kpi['unit'],
                    'value' => $value,
                    'numerator' => 0,
                    'denominator' => 0,
                    'task_count' => $taskCount,
                    'applicable_count' => 0,
                    'color' => strtolower($threshold['color']),
                    'color_label' => $threshold['label'],
                    'is_na' => $isNA,
                    'is_inverted' => (bool)$kpi['is_inverted']
                ];
            }
        }

        // Ordenar por código de KPI
        usort($summary, function($a, $b) {
            return strcmp($a['kpi_code'], $b['kpi_code']);
        });

        return $summary;
    }

    /**
     * Obtener detalle de un KPI específico (tareas que lo componen)
     */
    public function getKpiDetails(int $kpiId, int $areaId, string $periodKey): array
    {
        $kpi = $this->kpiRepository->findById($kpiId);
        if (!$kpi) {
            throw new \Exception("KPI not found: $kpiId");
        }

        $tasks = $this->factRepository->getTasksForKpi($kpiId, $areaId, $periodKey);

        // Calcular totales
        $totalNumerator = 0;
        $totalDenominator = 0;
        $sampleValues = [];
        $applicableCount = 0;

        foreach ($tasks as $task) {
            if ($task['is_applicable']) {
                $applicableCount++;
                $totalNumerator += (float)$task['numerator'];
                $totalDenominator += (float)$task['denominator'];
                if ($task['sample_value'] !== null) {
                    $sampleValues[] = (float)$task['sample_value'];
                }
            }
        }

        // Calcular valor según tipo
        $value = null;
        if ($kpi['calc_kind'] === 'RATIO_SUM' && $totalDenominator > 0) {
            $value = ($totalNumerator / $totalDenominator) * 100;
        } elseif ($kpi['calc_kind'] === 'AVG' && count($sampleValues) > 0) {
            $value = array_sum($sampleValues) / count($sampleValues);
        }

        $threshold = $this->kpiRepository->evaluateThreshold($kpiId, $value);

        return [
            'kpi' => $kpi,
            'period_key' => $periodKey,
            'area_id' => $areaId,
            'summary' => [
                'value' => $value !== null ? round($value, 2) : null,
                'numerator' => $totalNumerator,
                'denominator' => $totalDenominator,
                'avg_sample' => count($sampleValues) > 0 ? round(array_sum($sampleValues) / count($sampleValues), 2) : null,
                'task_count' => count($tasks),
                'applicable_count' => $applicableCount,
                'color' => $threshold['color'],
                'color_label' => $threshold['label']
            ],
            'tasks' => $tasks
        ];
    }

    /**
     * Obtener periodos disponibles para un área
     */
    public function getAvailablePeriods(int $areaId): array
    {
        return $this->factRepository->getAvailablePeriods($areaId);
    }

    /**
     * Obtener resumen para múltiples áreas (para dashboard admin)
     */
    public function getSummaryMultiArea(array $areaIds, string $periodKey): array
    {
        $result = [];
        foreach ($areaIds as $areaId) {
            $result[$areaId] = $this->getSummary($areaId, $periodKey);
        }
        return $result;
    }

    /**
     * Obtener tendencia de un KPI (últimos N periodos)
     */
    public function getKpiTrend(int $kpiId, int $areaId, int $periods = 6): array
    {
        // Generar lista de periodos hacia atrás
        $periodKeys = [];
        $date = new \DateTime();
        for ($i = 0; $i < $periods; $i++) {
            $periodKeys[] = $date->format('Y-m');
            $date->modify('-1 month');
        }
        $periodKeys = array_reverse($periodKeys);

        $trend = [];
        foreach ($periodKeys as $periodKey) {
            $sql = "
                SELECT 
                    SUM(numerator) as total_numerator,
                    SUM(denominator) as total_denominator,
                    AVG(CASE WHEN sample_value IS NOT NULL AND is_applicable = 1 THEN sample_value END) as avg_sample
                FROM task_kpi_facts f
                INNER JOIN tasks t ON f.task_id = t.id
                WHERE f.kpi_id = :kpi_id 
                  AND f.area_id = :area_id 
                  AND f.period_key = :period_key
                  AND t.deleted_at IS NULL
            ";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([
                ':kpi_id' => $kpiId,
                ':area_id' => $areaId,
                ':period_key' => $periodKey
            ]);
            $row = $stmt->fetch(\PDO::FETCH_ASSOC);

            $kpi = $this->kpiRepository->findById($kpiId);
            $value = null;

            if ($kpi['calc_kind'] === 'RATIO_SUM' && (float)$row['total_denominator'] > 0) {
                $value = ((float)$row['total_numerator'] / (float)$row['total_denominator']) * 100;
            } elseif ($kpi['calc_kind'] === 'AVG' && $row['avg_sample'] !== null) {
                $value = (float)$row['avg_sample'];
            }

            $trend[] = [
                'period' => $periodKey,
                'value' => $value !== null ? round($value, 2) : null
            ];
        }

        return $trend;
    }

    /**
     * Obtener issues pendientes (KPIs con thresholds marcados como pendientes)
     */
    public function getPendingIssues(): array
    {
        $sql = "
            SELECT k.code, k.name, kt.color, kt.note
            FROM kpi_thresholds kt
            INNER JOIN kpis k ON kt.kpi_id = k.id
            WHERE kt.is_pending = 1
            ORDER BY k.code
        ";
        $stmt = $this->db->query($sql);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Obtener tendencia histórica global de rendimiento KPI (últimos N meses)
     */
    public function getGlobalTrend(int $months = 6): array
    {
        $trend = [];
        $date = new \DateTime();
        
        for ($i = 0; $i < $months; $i++) {
            $periodKey = $date->format('Y-m');
            
            // Obtener estadísticas para este periodo
            $sql = "
                SELECT 
                    COUNT(DISTINCT f.id) as total_facts,
                    SUM(CASE 
                        WHEN k.calc_kind = 'RATIO_SUM' AND f.denominator > 0 
                        THEN f.numerator 
                        ELSE 0 
                    END) as total_numerator,
                    SUM(CASE 
                        WHEN k.calc_kind = 'RATIO_SUM' AND f.denominator > 0 
                        THEN f.denominator 
                        ELSE 0 
                    END) as total_denominator,
                    COUNT(DISTINCT t.id) as task_count,
                    SUM(CASE WHEN f.is_applicable = 1 THEN 1 ELSE 0 END) as applicable_count
                FROM task_kpi_facts f
                INNER JOIN kpis k ON f.kpi_id = k.id
                INNER JOIN tasks t ON f.task_id = t.id
                WHERE f.period_key = :period_key
                  AND t.deleted_at IS NULL
            ";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([':period_key' => $periodKey]);
            $row = $stmt->fetch(\PDO::FETCH_ASSOC);
            
            $value = null;
            if ((float)$row['total_denominator'] > 0) {
                $value = ((float)$row['total_numerator'] / (float)$row['total_denominator']) * 100;
            }
            
            $trend[] = [
                'period' => $periodKey,
                'period_label' => $date->format('M Y'),
                'value' => $value !== null ? round($value, 1) : null,
                'task_count' => (int)$row['task_count'],
                'applicable_count' => (int)$row['applicable_count']
            ];
            
            $date->modify('-1 month');
        }
        
        return array_reverse($trend);
    }

    /**
     * Obtener rendimiento por área para un periodo (para gráfico comparativo)
     */
    public function getAreaComparison(string $periodKey): array
    {
        $sql = "
            SELECT 
                a.id as area_id,
                a.name as area_name,
                COUNT(DISTINCT f.id) as total_kpis,
                SUM(CASE WHEN f.is_applicable = 1 THEN 1 ELSE 0 END) as applicable_count,
                SUM(CASE 
                    WHEN k.calc_kind = 'RATIO_SUM' AND f.denominator > 0 
                    THEN f.numerator 
                    ELSE 0 
                END) as total_numerator,
                SUM(CASE 
                    WHEN k.calc_kind = 'RATIO_SUM' AND f.denominator > 0 
                    THEN f.denominator 
                    ELSE 0 
                END) as total_denominator
            FROM task_kpi_facts f
            INNER JOIN kpis k ON f.kpi_id = k.id
            INNER JOIN tasks t ON f.task_id = t.id
            INNER JOIN areas a ON f.area_id = a.id
            WHERE f.period_key = :period_key
              AND t.deleted_at IS NULL
            GROUP BY a.id, a.name
            ORDER BY a.name
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':period_key' => $periodKey]);
        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        
        $result = [];
        foreach ($rows as $row) {
            $value = null;
            if ((float)$row['total_denominator'] > 0) {
                $value = ((float)$row['total_numerator'] / (float)$row['total_denominator']) * 100;
            }
            
            $result[] = [
                'area_id' => (int)$row['area_id'],
                'area_name' => $row['area_name'],
                'total_kpis' => (int)$row['total_kpis'],
                'applicable_count' => (int)$row['applicable_count'],
                'value' => $value !== null ? round($value, 1) : null
            ];
        }
        
        return $result;
    }
}
