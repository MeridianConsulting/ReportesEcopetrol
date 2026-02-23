<?php

namespace App\Services;

use App\Repositories\TaskRepository;
use App\Repositories\KpiCategoryRepository;
use App\Services\KpiEngineService;
use App\Services\AssignmentPolicyService;

class TaskService
{
  private $taskRepository;
  private $kpiCategoryRepository;
  private $kpiEngineService;
  private $assignmentPolicyService;

  public function __construct()
  {
    $this->taskRepository = new TaskRepository();
    $this->kpiCategoryRepository = new KpiCategoryRepository();
    $this->kpiEngineService = new KpiEngineService();
    $this->assignmentPolicyService = new AssignmentPolicyService();
  }

  public function list(array $filters, array $userContext): array
  {
    return $this->taskRepository->findAll($filters, $userContext);
  }

  public function getById(int $id, array $userContext): ?array
  {
    return $this->taskRepository->findById($id, $userContext);
  }

  /**
   * Normalizar fechas: convertir cadenas vacías, "0000-00-00" o valores inválidos a null
   */
  private function normalizeDate($date): ?string
  {
    if (empty($date) || $date === '' || $date === '0000-00-00' || $date === '0000-00-00 00:00:00') {
      return null;
    }
    
    // Validar que sea una fecha válida en formato YYYY-MM-DD
    $d = \DateTime::createFromFormat('Y-m-d', $date);
    if ($d && $d->format('Y-m-d') === $date) {
      return $date;
    }
    
    return null;
  }

  public function create(array $data, array $userContext): array
  {
    if (!isset($userContext['id'])) {
      throw new \Exception('User context no válido: falta el ID del usuario');
    }

    $responsibleId = isset($data['responsible_id']) ? (int)$data['responsible_id'] : 0;
    if ($responsibleId > 0 && !$this->assignmentPolicyService->canAssignTo($userContext, $responsibleId)) {
      throw new \Exception('No tienes permisos para asignar tareas a ese usuario');
    }

    $data['created_by'] = $userContext['id'];
    
    // === KPI: Si viene kpi_category_id, cargar la categoría y forzar area_id ===
    if (!empty($data['kpi_category_id'])) {
      $category = $this->kpiCategoryRepository->findById((int)$data['kpi_category_id']);
      if ($category) {
        // Forzar el area_id desde la categoría KPI
        $data['area_id'] = $category['area_id'];
      } else {
        // Categoría no encontrada, limpiar
        unset($data['kpi_category_id']);
      }
    }
    
    // Normalizar fechas vacías o inválidas
    if (isset($data['start_date'])) {
      $data['start_date'] = $this->normalizeDate($data['start_date']);
    }
    if (isset($data['due_date'])) {
      $data['due_date'] = $this->normalizeDate($data['due_date']);
    }
    
    try {
      $id = $this->taskRepository->create($data);
      if (!$id || $id <= 0) {
        throw new \Exception('No se pudo crear la tarea: el ID retornado no es válido');
      }
      
      $task = $this->taskRepository->findById($id, $userContext);
      if (!$task) {
        error_log('TaskService::create - Tarea creada con ID ' . $id . ' pero no se pudo recuperar con userContext: ' . json_encode($userContext));
        throw new \Exception('La tarea se creó pero no se pudo recuperar. Verifica los permisos.');
      }
      
      // === KPI: Guardar inputs KPI si vienen ===
      if (!empty($data['kpi_inputs']) && is_array($data['kpi_inputs'])) {
        $this->kpiEngineService->saveTaskInputs($id, $data['kpi_inputs']);
      }
      
      // === KPI: Recalcular KPI para la tarea ===
      if (!empty($task['kpi_category_id'])) {
        try {
          $this->kpiEngineService->recomputeForTask($id, $userContext);
        } catch (\Exception $e) {
          error_log('TaskService::create - Error recalculando KPI: ' . $e->getMessage());
          // No fallar la creación de tarea por error de KPI
        }
      }
      
      return $task;
    } catch (\PDOException $e) {
      error_log('TaskService::create PDO error: ' . $e->getMessage());
      error_log('Data: ' . json_encode($data));
      throw new \Exception('Error de base de datos: ' . $e->getMessage());
    }
  }

  public function update(int $id, array $data, array $userContext): ?array
  {
    // Verificar que existe y tiene permisos
    $task = $this->taskRepository->findById($id, $userContext);
    if (!$task) {
      return null;
    }

    // === KPI: Si viene kpi_category_id, cargar la categoría y forzar area_id ===
    if (isset($data['kpi_category_id'])) {
      if (!empty($data['kpi_category_id'])) {
        $category = $this->kpiCategoryRepository->findById((int)$data['kpi_category_id']);
        if ($category) {
          // Forzar el area_id desde la categoría KPI
          $data['area_id'] = $category['area_id'];
        } else {
          // Categoría no encontrada, limpiar
          $data['kpi_category_id'] = null;
        }
      } else {
        // Se está quitando la categoría KPI
        $data['kpi_category_id'] = null;
      }
    }

    // Normalizar fechas vacías o inválidas
    if (isset($data['start_date'])) {
      $data['start_date'] = $this->normalizeDate($data['start_date']);
    }
    if (isset($data['due_date'])) {
      $data['due_date'] = $this->normalizeDate($data['due_date']);
    }
    if (isset($data['closed_date'])) {
      $data['closed_date'] = $this->normalizeDate($data['closed_date']);
    }

    // === Sincronización bidireccional Estado <-> Progreso ===
    $statusChanged = isset($data['status']);
    $progressChanged = isset($data['progress_percent']);

    // Normalizar progreso si viene
    if ($progressChanged) {
      $data['progress_percent'] = max(0, min(100, (int)$data['progress_percent']));
    }

    // Si solo viene estado (sin progreso), sincronizar progreso
    if ($statusChanged && !$progressChanged) {
      $currentProgress = (int)($task['progress_percent'] ?? 0);
      switch ($data['status']) {
        case 'No iniciada':
          $data['progress_percent'] = 0;
          break;
        case 'En progreso':
          $data['progress_percent'] = ($currentProgress >= 1 && $currentProgress <= 79) ? $currentProgress : 50;
          break;
        case 'En revisión':
          $data['progress_percent'] = ($currentProgress >= 80 && $currentProgress <= 99) ? $currentProgress : 90;
          break;
        case 'Completada':
          $data['progress_percent'] = 100;
          break;
        case 'En riesgo':
          $data['progress_percent'] = ($currentProgress > 0) ? $currentProgress : 50;
          break;
      }
    }

    // Si solo viene progreso (sin estado), sincronizar estado
    if ($progressChanged && !$statusChanged) {
      $newProgress = (int)$data['progress_percent'];
      $currentStatus = $task['status'] ?? 'No iniciada';

      if ($currentStatus === 'En riesgo') {
        // Solo cambiar en 0% o 100%
        if ($newProgress === 0) {
          $data['status'] = 'No iniciada';
        } elseif ($newProgress === 100) {
          $data['status'] = 'Completada';
        }
      } else {
        if ($newProgress === 0) {
          $data['status'] = 'No iniciada';
        } elseif ($newProgress >= 1 && $newProgress <= 79) {
          $data['status'] = 'En progreso';
        } elseif ($newProgress >= 80 && $newProgress <= 99) {
          $data['status'] = 'En revisión';
        } elseif ($newProgress >= 100) {
          $data['status'] = 'Completada';
        }
      }
    }

    // Detectar si hay cambio de estado a Completada y setear closed_date
    if (isset($data['status']) && $data['status'] === 'Completada' && $task['status'] !== 'Completada') {
      if (empty($data['closed_date']) && empty($task['closed_date'])) {
        $data['closed_date'] = date('Y-m-d');
      }
    }

    $this->taskRepository->update($id, $data);
    
    // Obtener tarea actualizada
    $updatedTask = $this->taskRepository->findById($id, $userContext);
    
    // === KPI: Guardar inputs KPI si vienen ===
    if (!empty($data['kpi_inputs']) && is_array($data['kpi_inputs'])) {
      $this->kpiEngineService->saveTaskInputs($id, $data['kpi_inputs']);
    }
    
    // === KPI: Recalcular si hay cambios relevantes ===
    $kpiRelevantFields = ['status', 'due_date', 'closed_date', 'kpi_category_id'];
    $shouldRecalculate = false;
    
    foreach ($kpiRelevantFields as $field) {
      if (isset($data[$field])) {
        $shouldRecalculate = true;
        break;
      }
    }
    
    // También recalcular si hay inputs KPI
    if (!empty($data['kpi_inputs'])) {
      $shouldRecalculate = true;
    }
    
    if ($shouldRecalculate && !empty($updatedTask['kpi_category_id'])) {
      try {
        $this->kpiEngineService->recomputeForTask($id, $userContext);
      } catch (\Exception $e) {
        error_log('TaskService::update - Error recalculando KPI: ' . $e->getMessage());
        // No fallar la actualización por error de KPI
      }
    }
    
    return $updatedTask;
  }

  public function listPaginated(array $filters, array $userContext, int $limit = 100, ?string $cursor = null, string $sort = 'updated_at', string $order = 'desc'): array
  {
    return $this->taskRepository->findPaginated($filters, $userContext, $limit, $cursor, $sort, $order);
  }

  public function getStats(int $responsibleId): array
  {
    return $this->taskRepository->getStats($responsibleId);
  }

  public function delete(int $id, array $userContext): bool
  {
    // Verificar que existe y tiene permisos
    $task = $this->taskRepository->findById($id, $userContext);
    if (!$task) {
      return false;
    }

    return $this->taskRepository->delete($id);
  }
}

