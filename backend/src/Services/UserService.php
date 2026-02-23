<?php

namespace App\Services;

use App\Repositories\UserRepository;

class UserService
{
  private $userRepository;

  public function __construct()
  {
    $this->userRepository = new UserRepository();
  }

  public function list(array $filters = []): array
  {
    $users = $this->userRepository->findAll($filters);
    // Enriquecer cada usuario con sus áreas múltiples
    return array_map(fn($u) => $this->userRepository->enrichWithAreas($u), $users);
  }

  public function getById(int $id): ?array
  {
    $user = $this->userRepository->findById($id);
    return $this->userRepository->enrichWithAreas($user);
  }

  public function create(array $data): array
  {
    if (isset($data['password'])) {
      $data['password_hash'] = password_hash($data['password'], PASSWORD_DEFAULT);
      unset($data['password']);
    }

    // Extraer area_ids antes de crear el usuario
    $areaIds = $data['area_ids'] ?? null;
    unset($data['area_ids']);

    $id = $this->userRepository->create($data);

    // Sincronizar user_areas si se proporcionaron area_ids
    if ($areaIds !== null && is_array($areaIds)) {
      $primaryAreaId = !empty($data['area_id']) ? (int)$data['area_id'] : null;
      $this->userRepository->setUserAreas($id, array_map('intval', $areaIds), $primaryAreaId);
    } elseif (!empty($data['area_id'])) {
      // Si solo se envió area_id, sincronizar con user_areas
      $this->userRepository->setUserAreas($id, [(int)$data['area_id']], (int)$data['area_id']);
    }

    return $this->userRepository->enrichWithAreas($this->userRepository->findById($id));
  }

  public function update(int $id, array $data): ?array
  {
    if (isset($data['password']) && !empty($data['password'])) {
      $data['password_hash'] = password_hash($data['password'], PASSWORD_DEFAULT);
      unset($data['password']);
    }

    // Extraer area_ids antes de actualizar
    $areaIds = $data['area_ids'] ?? null;
    unset($data['area_ids']);

    $this->userRepository->update($id, $data);

    // Sincronizar user_areas si se proporcionaron area_ids
    if ($areaIds !== null && is_array($areaIds)) {
      $primaryAreaId = !empty($data['area_id']) ? (int)$data['area_id'] : null;
      $this->userRepository->setUserAreas($id, array_map('intval', $areaIds), $primaryAreaId);
    } elseif (isset($data['area_id'])) {
      // Si solo se envió area_id (sin area_ids), sincronizar user_areas
      if (!empty($data['area_id'])) {
        // Obtener áreas actuales para no sobreescribir si solo cambia area_id
        $currentAreas = $this->userRepository->getUserAreaIds($id);
        if (empty($currentAreas)) {
          $this->userRepository->setUserAreas($id, [(int)$data['area_id']], (int)$data['area_id']);
        }
      }
    }

    return $this->userRepository->enrichWithAreas($this->userRepository->findById($id));
  }

  public function delete(int $id): bool
  {
    // Verificar que el usuario existe
    $user = $this->userRepository->findById($id);
    if (!$user) {
      throw new \Exception('Usuario no encontrado');
    }

    // Verificar si tiene tareas asociadas
    if ($this->userRepository->hasTasks($id)) {
      throw new \Exception('No se puede eliminar el usuario porque tiene tareas asociadas');
    }

    return $this->userRepository->delete($id);
  }
}

