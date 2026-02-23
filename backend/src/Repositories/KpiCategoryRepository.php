<?php

namespace App\Repositories;

use App\Core\Database;

/**
 * Repositorio para la tabla kpi_categories
 * Maneja las categorías KPI que el usuario selecciona
 */
class KpiCategoryRepository
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Obtener todas las categorías activas
     */
    public function findAll(array $filters = []): array
    {
        $sql = "
            SELECT kc.*, k.code as kpi_code, k.name as kpi_name, k.calc_kind, k.unit,
                   a.name as area_name, a.code as area_code
            FROM kpi_categories kc
            INNER JOIN kpis k ON kc.kpi_id = k.id
            INNER JOIN areas a ON kc.area_id = a.id
            WHERE kc.is_active = 1 AND k.is_active = 1
        ";
        $params = [];

        if (!empty($filters['area_id'])) {
            $sql .= " AND kc.area_id = :area_id";
            $params[':area_id'] = $filters['area_id'];
        } elseif (!empty($filters['area_ids']) && is_array($filters['area_ids'])) {
            $areaPlaceholders = [];
            foreach ($filters['area_ids'] as $i => $aid) {
                $key = ':area_id_' . $i;
                $areaPlaceholders[] = $key;
                $params[$key] = (int)$aid;
            }
            $sql .= " AND kc.area_id IN (" . implode(',', $areaPlaceholders) . ")";
        }

        if (!empty($filters['kpi_id'])) {
            $sql .= " AND kc.kpi_id = :kpi_id";
            $params[':kpi_id'] = $filters['kpi_id'];
        }

        $sql .= " ORDER BY a.name, kc.sort_order";

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Obtener categoría por ID
     */
    public function findById(int $id): ?array
    {
        $sql = "
            SELECT kc.*, k.code as kpi_code, k.name as kpi_name, k.calc_kind, k.unit,
                   k.period_anchor, k.na_rule, k.formula_text, k.is_inverted,
                   a.name as area_name, a.code as area_code
            FROM kpi_categories kc
            INNER JOIN kpis k ON kc.kpi_id = k.id
            INNER JOIN areas a ON kc.area_id = a.id
            WHERE kc.id = :id
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $id]);
        $category = $stmt->fetch(\PDO::FETCH_ASSOC);
        return $category ?: null;
    }

    /**
     * Obtener categoría por slug
     */
    public function findBySlug(string $slug): ?array
    {
        $sql = "
            SELECT kc.*, k.code as kpi_code, k.name as kpi_name, k.calc_kind, k.unit,
                   k.period_anchor, k.na_rule, a.name as area_name
            FROM kpi_categories kc
            INNER JOIN kpis k ON kc.kpi_id = k.id
            INNER JOIN areas a ON kc.area_id = a.id
            WHERE kc.slug = :slug
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':slug' => $slug]);
        $category = $stmt->fetch(\PDO::FETCH_ASSOC);
        return $category ?: null;
    }

    /**
     * Obtener categorías por área (para dropdown en formularios)
     */
    public function findByAreaId(int $areaId): array
    {
        $sql = "
            SELECT kc.id, kc.name, kc.slug, kc.kpi_id,
                   k.code as kpi_code, k.calc_kind, k.unit
            FROM kpi_categories kc
            INNER JOIN kpis k ON kc.kpi_id = k.id
            WHERE kc.area_id = :area_id AND kc.is_active = 1 AND k.is_active = 1
            ORDER BY kc.sort_order
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':area_id' => $areaId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Obtener categorías por múltiples áreas (para usuarios con varias áreas)
     */
    public function findByAreaIds(array $areaIds): array
    {
        if (empty($areaIds)) {
            return [];
        }

        $placeholders = implode(',', array_fill(0, count($areaIds), '?'));
        $sql = "
            SELECT kc.id, kc.name, kc.slug, kc.kpi_id, kc.area_id,
                   k.code as kpi_code, k.calc_kind, k.unit,
                   a.name as area_name
            FROM kpi_categories kc
            INNER JOIN kpis k ON kc.kpi_id = k.id
            INNER JOIN areas a ON kc.area_id = a.id
            WHERE kc.area_id IN ($placeholders) AND kc.is_active = 1 AND k.is_active = 1
            ORDER BY a.name, kc.sort_order
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute($areaIds);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * Verificar si una categoría pertenece a un área específica
     */
    public function belongsToArea(int $categoryId, int $areaId): bool
    {
        $sql = "SELECT 1 FROM kpi_categories WHERE id = :id AND area_id = :area_id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $categoryId, ':area_id' => $areaId]);
        return $stmt->fetch() !== false;
    }

    /**
     * Verificar si una categoría pertenece a alguna de las áreas dadas
     */
    public function belongsToAnyArea(int $categoryId, array $areaIds): bool
    {
        if (empty($areaIds)) {
            return false;
        }

        $placeholders = implode(',', array_fill(0, count($areaIds), '?'));
        $sql = "SELECT 1 FROM kpi_categories WHERE id = ? AND area_id IN ($placeholders)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(array_merge([$categoryId], $areaIds));
        return $stmt->fetch() !== false;
    }

    /**
     * Obtener los inputs requeridos para una categoría KPI
     */
    public function getRequiredInputs(int $categoryId): array
    {
        $sql = "
            SELECT kri.*
            FROM kpi_required_inputs kri
            INNER JOIN kpi_categories kc ON kri.kpi_id = kc.kpi_id
            WHERE kc.id = :category_id
            ORDER BY kri.sort_order
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':category_id' => $categoryId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }
}
