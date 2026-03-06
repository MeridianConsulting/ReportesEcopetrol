<?php

namespace App\Resources;

class OdsActivityResource
{
  public static function toArray(array $activity): array
  {
    return [
      'id' => (int)($activity['id'] ?? 0),
      'service_order_id' => isset($activity['service_order_id']) ? (int)$activity['service_order_id'] : null,
      'ods_code' => $activity['ods_code'] ?? null,
      'project_name' => $activity['project_name'] ?? null,
      'title' => $activity['title'] ?? '',
      'item_general' => $activity['item_general'] ?? null,
      'item_activity' => $activity['item_activity'] ?? null,
      'description' => $activity['description'] ?? '',
      'support_text' => $activity['support_text'] ?? null,
      'delivery_medium_id' => isset($activity['delivery_medium_id']) && $activity['delivery_medium_id'] !== null
        ? (int)$activity['delivery_medium_id']
        : null,
      'delivery_medium_name' => $activity['delivery_medium_name'] ?? null,
      'contracted_days' => isset($activity['contracted_days']) && $activity['contracted_days'] !== null
        ? (float)$activity['contracted_days']
        : null,
      'planned_start_date' => $activity['planned_start_date'] ?? null,
      'planned_end_date' => $activity['planned_end_date'] ?? null,
      'status' => $activity['status'] ?? 'Borrador',
      'notes' => $activity['notes'] ?? null,
      'assigned_user_ids' => array_map('intval', $activity['assigned_user_ids'] ?? []),
      'assigned_users' => array_map(function ($user) {
        return [
          'id' => (int)($user['id'] ?? 0),
          'name' => $user['name'] ?? '',
          'email' => $user['email'] ?? null,
        ];
      }, $activity['assigned_users'] ?? []),
      'assigned_users_count' => isset($activity['assigned_users_count']) ? (int)$activity['assigned_users_count'] : 0,
      'created_by' => isset($activity['created_by']) ? (int)$activity['created_by'] : null,
      'created_by_name' => $activity['created_by_name'] ?? null,
      'updated_by' => isset($activity['updated_by']) && $activity['updated_by'] !== null ? (int)$activity['updated_by'] : null,
      'updated_by_name' => $activity['updated_by_name'] ?? null,
      'created_at' => $activity['created_at'] ?? null,
      'updated_at' => $activity['updated_at'] ?? null,
    ];
  }

  public static function collection(array $activities): array
  {
    return array_map([self::class, 'toArray'], $activities);
  }
}
