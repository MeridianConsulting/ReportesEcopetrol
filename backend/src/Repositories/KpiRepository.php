<?php

namespace App\Repositories;

use App\Core\Database;

/**
 * Repositorio para la tabla kpis
 * Maneja el catálogo de KPIs y sus thresholds
 */
class KpiRepository
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Obtener todos los KPIs activos
     */
    public function findAll(bool $includeThresholds = false): array
    {
        $sql = "SELECT * FROM kpis WHERE is_active = 1 ORDER BY code";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        $kpis = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        if ($includeThresholds) {
            foreach ($kpis as &$kpi) {
                $kpi['thresholds'] = $this->getThresholds($kpi['id']);
            }
        }

        return $kpis;
    }

    /**
     * Obtener KPI por ID
     */
    public function findById(int $id): ?array
    {
        $sql = "SELECT * FROM kpis WHERE id = :id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $id]);
        $kpi = $stmt->fetch(\PDO::FETCH_ASSOC);

        if ($kpi) {
            $kpi['thresholds'] = $this->getThresholds($id);
            $kpi['required_inputs'] = $this->getRequiredInputs($id);
        }

        return $kpi ?: null;
    }

    /**
     * Obtener KPI por código
     */
    public function findByCode(string $code): ?array
    {
        $sql = "SELECT * FROM kpis WHERE code = :code";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':code' => $code]);
        $kpi = $stmt->fetch(\PDO::FETCH_ASSOC);

        if ($kpi) {
            $kpi['thresholds'] = $this->getThresholds($kpi['id']);
            $kpi['required_inputs'] = $this->getRequiredInputs($kpi['id']);
        }

        return $kpi ?: null;
    }

    /**
     * Obtener thresholds de un KPI ordenados por prioridad
     */
    public function getThresholds(int $kpiId): array
    {
        $sql = "SELECT * FROM kpi_thresholds WHERE kpi_id = :kpi_id ORDER BY priority DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':kpi_id' => $kpiId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Obtener inputs requeridos para un KPI
     */
    public function getRequiredInputs(int $kpiId): array
    {
        $sql = "SELECT * FROM kpi_required_inputs WHERE kpi_id = :kpi_id ORDER BY sort_order";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':kpi_id' => $kpiId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Evaluar color del semáforo dado un valor
     */
    public function evaluateThreshold(int $kpiId, ?float $value): array
    {
        if ($value === null) {
            return ['color' => 'WHITE', 'label' => 'N/A'];
        }

        $thresholds = $this->getThresholds($kpiId);

        foreach ($thresholds as $threshold) {
            $matches = false;
            $a = $threshold['a'] !== null ? (float)$threshold['a'] : null;
            $b = $threshold['b'] !== null ? (float)$threshold['b'] : null;

            switch ($threshold['op']) {
                case 'GE':
                    $matches = $a !== null && $value >= $a;
                    break;
                case 'GT':
                    $matches = $a !== null && $value > $a;
                    break;
                case 'LE':
                    $matches = $a !== null && $value <= $a;
                    break;
                case 'LT':
                    $matches = $a !== null && $value < $a;
                    break;
                case 'BETWEEN':
                    $matches = $a !== null && $b !== null && $value >= $a && $value <= $b;
                    break;
                case 'EQ':
                    // EQ con NULL = N/A (ya manejado arriba)
                    if ($a === null) {
                        continue 2;
                    }
                    $matches = $value == $a;
                    break;
            }

            if ($matches) {
                return [
                    'color' => $threshold['color'],
                    'label' => $this->getColorLabel($threshold['color']),
                    'note' => $threshold['note']
                ];
            }
        }

        // Default: blanco si no hay match
        return ['color' => 'WHITE', 'label' => 'Sin clasificar'];
    }

    /**
     * Obtener etiqueta legible para el color
     */
    private function getColorLabel(string $color): string
    {
        $labels = [
            'GREEN' => 'Cumple',
            'YELLOW' => 'Precaución',
            'RED' => 'Crítico',
            'WHITE' => 'N/A'
        ];
        return $labels[$color] ?? $color;
    }

    /**
     * Obtener KPIs agrupados por área (para dashboard)
     */
    public function getKpisByArea(int $areaId): array
    {
        $sql = "
            SELECT k.*, kc.id as category_id, kc.name as category_name, kc.slug
            FROM kpis k
            INNER JOIN kpi_categories kc ON k.id = kc.kpi_id
            WHERE kc.area_id = :area_id AND k.is_active = 1 AND kc.is_active = 1
            ORDER BY kc.sort_order
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':area_id' => $areaId]);
        $kpis = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        foreach ($kpis as &$kpi) {
            $kpi['thresholds'] = $this->getThresholds($kpi['id']);
        }

        return $kpis;
    }
}
