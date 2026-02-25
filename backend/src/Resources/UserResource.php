<?php

namespace App\Resources;

class UserResource
{
  public static function toArray(array $user): array
  {
    $result = [
      'id' => (int)$user['id'],
      'name' => $user['name'] ?? $user['email'] ?? '',
      'email' => $user['email'],
      'role' => $user['role_name'] ?? null,
      'role_id' => (int)($user['role_id'] ?? 0),
      'area_id' => $user['area_id'] ? (int)$user['area_id'] : null,
      'area_name' => $user['area_name'] ?? null,
      'area_ids' => $user['area_ids'] ?? ($user['area_id'] ? [(int)$user['area_id']] : []),
      'area_names' => $user['area_names'] ?? ($user['area_name'] ? [$user['area_name']] : []),
      'is_active' => (bool)($user['is_active'] ?? true),
      'created_at' => $user['created_at'] ?? null,
    ];

    return $result;
  }

  public static function collection(array $users): array
  {
    return array_map([self::class, 'toArray'], $users);
  }
}

