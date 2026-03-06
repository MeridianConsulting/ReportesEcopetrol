<?php

namespace App\Services;

use App\Core\Database;
use App\Repositories\OdsActivityRepository;

class OdsActivityService
{
  private $repository;
  private $db;

  public function __construct()
  {
    $this->repository = new OdsActivityRepository();
    $this->db = Database::getInstance()->getConnection();
  }

  public function list(array $filters = []): array
  {
    return $this->repository->findAll($filters);
  }

  public function getById(int $id): ?array
  {
    return $this->repository->findById($id);
  }

  public function create(array $data, array $userContext): array
  {
    $userId = (int)($userContext['id'] ?? 0);
    if ($userId <= 0) {
      throw new \InvalidArgumentException('Usuario no autorizado.');
    }

    $normalized = $this->normalizePayload($data, false, $userId);
    $this->assertPayloadConsistency($normalized);

    $this->db->beginTransaction();

    try {
      $activityId = $this->repository->create($normalized);
      $this->repository->syncAssignments($activityId, $normalized['assigned_user_ids'], $userId);
      $this->db->commit();
    } catch (\Throwable $e) {
      $this->db->rollBack();
      throw $e;
    }

    $activity = $this->repository->findById($activityId);
    if (!$activity) {
      throw new \RuntimeException('La actividad fue creada pero no pudo recuperarse.');
    }

    return $activity;
  }

  public function update(int $id, array $data, array $userContext): ?array
  {
    $userId = (int)($userContext['id'] ?? 0);
    if ($userId <= 0) {
      throw new \InvalidArgumentException('Usuario no autorizado.');
    }

    $current = $this->repository->findById($id);
    if (!$current) {
      return null;
    }

    $normalized = $this->normalizePayload($data, true, $userId, $current);
    $candidate = array_merge($current, $normalized);
    $candidate['assigned_user_ids'] = $normalized['assigned_user_ids'] ?? $current['assigned_user_ids'] ?? [];
    $this->assertPayloadConsistency($candidate);

    $this->db->beginTransaction();

    try {
      $this->repository->update($id, $normalized);

      if (array_key_exists('assigned_user_ids', $normalized)) {
        $this->repository->syncAssignments($id, $normalized['assigned_user_ids'], $userId);
      }

      $this->db->commit();
    } catch (\Throwable $e) {
      $this->db->rollBack();
      throw $e;
    }

    return $this->repository->findById($id);
  }

  public function delete(int $id, array $userContext): bool
  {
    $userId = (int)($userContext['id'] ?? 0);
    if ($userId <= 0) {
      throw new \InvalidArgumentException('Usuario no autorizado.');
    }

    $current = $this->repository->findById($id);
    if (!$current) {
      return false;
    }

    $this->db->beginTransaction();

    try {
      $deleted = $this->repository->softDelete($id, $userId);
      if ($deleted) {
        $this->repository->deactivateAssignments($id);
      }
      $this->db->commit();
      return $deleted;
    } catch (\Throwable $e) {
      $this->db->rollBack();
      throw $e;
    }
  }

  private function normalizePayload(array $data, bool $isUpdate, int $userId, ?array $current = null): array
  {
    $normalized = [];
    $stringFields = ['title', 'item_general', 'item_activity', 'description', 'support_text', 'status', 'notes'];

    foreach ($stringFields as $field) {
      if (!$isUpdate || array_key_exists($field, $data)) {
        $normalized[$field] = array_key_exists($field, $data)
          ? $this->normalizeNullableString($data[$field], in_array($field, ['title', 'description', 'status'], true))
          : null;
      }
    }

    $nullableIntFields = ['service_order_id', 'delivery_medium_id'];
    foreach ($nullableIntFields as $field) {
      if (!$isUpdate || array_key_exists($field, $data)) {
        $normalized[$field] = $this->normalizeNullableInt($data[$field] ?? null);
      }
    }

    if (!$isUpdate || array_key_exists('contracted_days', $data)) {
      $normalized['contracted_days'] = $this->normalizeNullableDecimal($data['contracted_days'] ?? null);
    }

    $dateFields = ['planned_start_date', 'planned_end_date'];
    foreach ($dateFields as $field) {
      if (!$isUpdate || array_key_exists($field, $data)) {
        $normalized[$field] = $this->normalizeNullableDate($data[$field] ?? null);
      }
    }

    if (!$isUpdate || array_key_exists('assigned_user_ids', $data)) {
      $assignedUserIds = $data['assigned_user_ids'] ?? [];
      if (!is_array($assignedUserIds)) {
        throw new \InvalidArgumentException('Los profesionales asignados deben enviarse como una lista.');
      }

      $normalized['assigned_user_ids'] = array_values(array_unique(array_map('intval', array_filter($assignedUserIds, function ($value) {
        return $value !== null && $value !== '' && (int)$value > 0;
      }))));
    }

    $normalized['updated_by'] = $userId;

    if (!$isUpdate) {
      $normalized['created_by'] = $userId;
    }

    return $normalized;
  }

  private function assertPayloadConsistency(array $data): void
  {
    $serviceOrderId = (int)($data['service_order_id'] ?? 0);
    if ($serviceOrderId <= 0 || !$this->repository->serviceOrderExists($serviceOrderId)) {
      throw new \InvalidArgumentException('La ODS seleccionada no existe.');
    }

    $deliveryMediumId = $data['delivery_medium_id'] ?? null;
    if ($deliveryMediumId !== null && !$this->repository->deliveryMediumExists((int)$deliveryMediumId)) {
      throw new \InvalidArgumentException('El medio de entrega seleccionado no es válido.');
    }

    $assignedUserIds = array_values(array_unique(array_map('intval', $data['assigned_user_ids'] ?? [])));
    if (empty($assignedUserIds)) {
      throw new \InvalidArgumentException('Debes asignar al menos un profesional a la actividad.');
    }

    $validUserIds = $this->repository->getProfessionalIdsForServiceOrder($serviceOrderId);
    $validSet = array_flip($validUserIds);

    foreach ($assignedUserIds as $assignedUserId) {
      if (!isset($validSet[$assignedUserId])) {
        throw new \InvalidArgumentException('Solo puedes asignar profesionales vinculados a la ODS seleccionada.');
      }
    }
  }

  private function normalizeNullableString($value, bool $required = false): ?string
  {
    if ($value === null) {
      return $required ? '' : null;
    }

    $value = trim((string)$value);
    if ($value === '') {
      return $required ? '' : null;
    }

    return $value;
  }

  private function normalizeNullableInt($value): ?int
  {
    if ($value === null || $value === '') {
      return null;
    }

    return (int)$value;
  }

  private function normalizeNullableDecimal($value): ?float
  {
    if ($value === null || $value === '') {
      return null;
    }

    return (float)str_replace(',', '.', (string)$value);
  }

  private function normalizeNullableDate($value): ?string
  {
    if ($value === null || $value === '') {
      return null;
    }

    return (string)$value;
  }
}
