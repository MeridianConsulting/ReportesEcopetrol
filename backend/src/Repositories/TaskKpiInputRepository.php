<?php

namespace App\Repositories;

use App\Core\Database;

/**
 * Repositorio para la tabla task_kpi_inputs
 * Maneja los inputs adicionales por tarea para KPIs
 */
class TaskKpiInputRepository
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Upsert de un input
     */
    public function upsertInput(int $taskId, string $fieldKey, array $value): bool
    {
        $sql = "
            INSERT INTO task_kpi_inputs (task_id, field_key, value_bool, value_number, value_text)
            VALUES (:task_id, :field_key, :value_bool, :value_number, :value_text)
            ON DUPLICATE KEY UPDATE
                value_bool = VALUES(value_bool),
                value_number = VALUES(value_number),
                value_text = VALUES(value_text),
                updated_at = NOW()
        ";

        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':task_id' => $taskId,
            ':field_key' => $fieldKey,
            ':value_bool' => $value['bool'] ?? null,
            ':value_number' => $value['number'] ?? null,
            ':value_text' => $value['text'] ?? null,
        ]);
    }

    /**
     * Obtener todos los inputs de una tarea
     */
    public function findByTask(int $taskId): array
    {
        $sql = "SELECT * FROM task_kpi_inputs WHERE task_id = :task_id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':task_id' => $taskId]);
        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        // Convertir a array asociativo field_key => value
        $inputs = [];
        foreach ($rows as $row) {
            $inputs[$row['field_key']] = $this->extractValue($row);
        }
        return $inputs;
    }

    /**
     * Obtener un input específico
     */
    public function findInput(int $taskId, string $fieldKey): mixed
    {
        $sql = "SELECT * FROM task_kpi_inputs WHERE task_id = :task_id AND field_key = :field_key";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':task_id' => $taskId, ':field_key' => $fieldKey]);
        $row = $stmt->fetch(\PDO::FETCH_ASSOC);

        return $row ? $this->extractValue($row) : null;
    }

    /**
     * Eliminar un input
     */
    public function deleteInput(int $taskId, string $fieldKey): bool
    {
        $sql = "DELETE FROM task_kpi_inputs WHERE task_id = :task_id AND field_key = :field_key";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':task_id' => $taskId, ':field_key' => $fieldKey]);
    }

    /**
     * Eliminar todos los inputs de una tarea
     */
    public function deleteByTask(int $taskId): bool
    {
        $sql = "DELETE FROM task_kpi_inputs WHERE task_id = :task_id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':task_id' => $taskId]);
    }

    /**
     * Guardar múltiples inputs de una vez
     */
    public function saveInputs(int $taskId, array $inputs): bool
    {
        foreach ($inputs as $fieldKey => $value) {
            $this->upsertInput($taskId, $fieldKey, $this->normalizeValue($value));
        }
        return true;
    }

    /**
     * Extraer el valor apropiado de un row
     */
    private function extractValue(array $row): mixed
    {
        if ($row['value_bool'] !== null) {
            return (bool)$row['value_bool'];
        }
        if ($row['value_number'] !== null) {
            return (float)$row['value_number'];
        }
        return $row['value_text'];
    }

    /**
     * Normalizar un valor para guardarlo
     */
    private function normalizeValue(mixed $value): array
    {
        if (is_bool($value)) {
            return ['bool' => $value ? 1 : 0, 'number' => null, 'text' => null];
        }
        if (is_numeric($value)) {
            return ['bool' => null, 'number' => $value, 'text' => null];
        }
        return ['bool' => null, 'number' => null, 'text' => (string)$value];
    }
}
