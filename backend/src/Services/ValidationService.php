<?php

namespace App\Services;

class ValidationService
{
  /**
   * Validar email
   */
  public static function validateEmail(string $email): bool
  {
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
  }

  /**
   * Validar que un string no esté vacío
   */
  public static function validateRequired($value): bool
  {
    if (is_string($value)) {
      return trim($value) !== '';
    }
    return $value !== null && $value !== '';
  }

  /**
   * Validar longitud de string
   */
  public static function validateLength(string $value, int $min = null, int $max = null): bool
  {
    $length = mb_strlen($value);
    if ($min !== null && $length < $min) {
      return false;
    }
    if ($max !== null && $length > $max) {
      return false;
    }
    return true;
  }

  /**
   * Validar que sea un entero positivo
   */
  public static function validatePositiveInteger($value): bool
  {
    return is_numeric($value) && (int)$value > 0;
  }

  /**
   * Validar que sea un entero no negativo
   */
  public static function validateNonNegativeInteger($value): bool
  {
    return is_numeric($value) && (int)$value >= 0;
  }

  /**
   * Validar rango numérico
   */
  public static function validateRange($value, $min = null, $max = null): bool
  {
    if (!is_numeric($value)) {
      return false;
    }
    $num = (float)$value;
    if ($min !== null && $num < $min) {
      return false;
    }
    if ($max !== null && $num > $max) {
      return false;
    }
    return true;
  }

  /**
   * Validar fecha en formato YYYY-MM-DD
   */
  public static function validateDate(string $date): bool
  {
    $d = \DateTime::createFromFormat('Y-m-d', $date);
    return $d && $d->format('Y-m-d') === $date;
  }

  /**
   * Validar que una fecha no sea pasada (puede ser hoy o futura)
   */
  public static function validateDateNotPast(string $date): bool
  {
    $dateObj = \DateTime::createFromFormat('Y-m-d', $date);
    if (!$dateObj) {
      return false;
    }
    
    $today = new \DateTime();
    $today->setTime(0, 0, 0);
    $dateObj->setTime(0, 0, 0);
    
    return $dateObj >= $today;
  }

  /**
   * Validar que una fecha sea posterior o igual a otra
   */
  public static function validateDateAfter(string $date, string $afterDate): bool
  {
    $date1 = \DateTime::createFromFormat('Y-m-d', $date);
    $date2 = \DateTime::createFromFormat('Y-m-d', $afterDate);
    
    if (!$date1 || !$date2) {
      return false;
    }
    
    return $date1 >= $date2;
  }

  /**
   * Validar que un valor esté en una lista de valores permitidos
   */
  public static function validateIn($value, array $allowed): bool
  {
    return in_array($value, $allowed, true);
  }

  /**
   * Sanitizar string (remover tags HTML y espacios)
   */
  public static function sanitizeString(string $value): string
  {
    $value = trim($value);
    $value = strip_tags($value);
    return $value;
  }

  /**
   * Validar y sanitizar email
   */
  public static function sanitizeEmail(string $email): ?string
  {
    $email = trim(strtolower($email));
    if (!self::validateEmail($email)) {
      return null;
    }
    return $email;
  }

  /**
   * Validar estructura de datos de tarea
   * @param array $data Datos de la tarea
   * @param bool $isUpdate Si es una actualización (permite fechas pasadas si la tarea está completada)
   * @param string|null $currentStatus Estado actual de la tarea (para validaciones condicionales)
   */
  public static function validateTaskData(array $data, bool $isUpdate = false, ?string $currentStatus = null): array
  {
    $errors = [];

    // Título (requerido, 1-255 caracteres)
    if (!isset($data['title']) || !self::validateRequired($data['title'])) {
      $errors['title'] = 'El título es requerido';
    } elseif (!self::validateLength($data['title'], 1, 255)) {
      $errors['title'] = 'El título debe tener entre 1 y 255 caracteres';
    }

    // Tipo (opcional, si se envía debe ser válido - la BD tiene DEFAULT 'Operativa')
    $allowedTypes = ['Clave', 'Operativa', 'Mejora', 'Obligatoria'];
    if (isset($data['type']) && $data['type'] !== '' && !self::validateIn($data['type'], $allowedTypes)) {
      $errors['type'] = 'El tipo debe ser uno de: ' . implode(', ', $allowedTypes);
    }

    // Prioridad (requerido, valores permitidos)
    $allowedPriorities = ['Alta', 'Media', 'Baja'];
    if (!isset($data['priority']) || !self::validateIn($data['priority'], $allowedPriorities)) {
      $errors['priority'] = 'La prioridad debe ser una de: ' . implode(', ', $allowedPriorities);
    }

    // Estado (requerido, valores permitidos)
    $allowedStatuses = ['No iniciada', 'En progreso', 'En revisión', 'Completada', 'En riesgo'];
    if (!isset($data['status']) || !self::validateIn($data['status'], $allowedStatuses)) {
      $errors['status'] = 'El estado debe ser uno de: ' . implode(', ', $allowedStatuses);
    }

    // Progreso (0-100)
    if (isset($data['progress_percent'])) {
      if (!self::validateRange($data['progress_percent'], 0, 100)) {
        $errors['progress_percent'] = 'El progreso debe estar entre 0 y 100';
      }
    }

    // Área responsable (requerido, entero positivo)
    if (!isset($data['area_id']) || !self::validatePositiveInteger($data['area_id'])) {
      $errors['area_id'] = 'El área responsable es requerida y debe ser un ID válido';
    }

    // Área destinataria (opcional; si se envía debe ser entero positivo válido)
    if (isset($data['area_destinataria_id']) && $data['area_destinataria_id'] !== '' && $data['area_destinataria_id'] !== null) {
      if (!self::validatePositiveInteger($data['area_destinataria_id'])) {
        $errors['area_destinataria_id'] = 'El área destinataria debe ser un ID de área válido';
      }
    }

    // Responsable (opcional, pero si está presente debe ser entero positivo)
    if (isset($data['responsible_id']) && $data['responsible_id'] !== '' && !self::validatePositiveInteger($data['responsible_id'])) {
      $errors['responsible_id'] = 'El responsable debe ser un ID válido';
    }

    // Determinar si la tarea está completada (permite fechas pasadas y correcciones históricas)
    $isCompleted = ($data['status'] ?? $currentStatus) === 'Completada';
    // En actualizaciones, permitir fechas pasadas (correcciones históricas)
    // Si está completada, también permitir que due_date sea anterior a start_date
    $allowPastDates = $isUpdate;
    $allowDateInconsistency = $isUpdate && $isCompleted;

    // Fechas (opcionales, pero si están deben ser válidas)
    if (isset($data['start_date']) && $data['start_date'] !== '' && $data['start_date'] !== null) {
      if (!self::validateDate($data['start_date'])) {
        $errors['start_date'] = 'La fecha de inicio debe estar en formato YYYY-MM-DD';
      } elseif (!self::validateDateNotPast($data['start_date']) && !$allowPastDates) {
        $errors['start_date'] = 'La fecha de inicio no puede ser una fecha pasada';
      }
    }

    if (isset($data['due_date']) && $data['due_date'] !== '' && $data['due_date'] !== null) {
      if (!self::validateDate($data['due_date'])) {
        $errors['due_date'] = 'La fecha de vencimiento debe estar en formato YYYY-MM-DD';
      } elseif (!self::validateDateNotPast($data['due_date']) && !$allowPastDates) {
        $errors['due_date'] = 'La fecha de vencimiento no puede ser una fecha pasada';
      }
    }

    // Validar que due_date sea posterior o igual a start_date si ambas están presentes
    // Si la tarea está completada y es una actualización, permitir correcciones históricas
    if (isset($data['start_date']) && isset($data['due_date']) && 
        $data['start_date'] !== '' && $data['due_date'] !== '' &&
        self::validateDate($data['start_date']) && self::validateDate($data['due_date'])) {
      if (!self::validateDateAfter($data['due_date'], $data['start_date'])) {
        if ($allowDateInconsistency) {
          // Si está completada y es actualización, solo mostrar advertencia pero permitir guardar
          // No agregar error, solo registrar en logs
          error_log("Advertencia: Tarea completada con fecha de vencimiento anterior a fecha de inicio (Task ID: " . ($data['id'] ?? 'N/A') . ")");
        } else {
          $errors['due_date'] = 'La fecha de vencimiento debe ser igual o posterior a la fecha de inicio';
        }
      }
    }

    return $errors;
  }

  /**
   * Validar datos de usuario
   */
  public static function validateUserData(array $data, bool $isUpdate = false): array
  {
    $errors = [];

    // Nombre (requerido, 1-100 caracteres)
    if (!$isUpdate || isset($data['name'])) {
      if (!isset($data['name']) || !self::validateRequired($data['name'])) {
        $errors['name'] = 'El nombre es requerido';
      } elseif (!self::validateLength($data['name'], 1, 100)) {
        $errors['name'] = 'El nombre debe tener entre 1 y 100 caracteres';
      }
    }

    // Email (requerido, formato válido)
    if (!$isUpdate || isset($data['email'])) {
      if (!isset($data['email']) || !self::validateRequired($data['email'])) {
        $errors['email'] = 'El email es requerido';
      } elseif (!self::validateEmail($data['email'])) {
        $errors['email'] = 'El email no tiene un formato válido';
      }
    }

    // Password (requerido solo en creación, mínimo 6 caracteres)
    if (!$isUpdate) {
      if (!isset($data['password']) || !self::validateRequired($data['password'])) {
        $errors['password'] = 'La contraseña es requerida';
      } elseif (!self::validateLength($data['password'], 6)) {
        $errors['password'] = 'La contraseña debe tener al menos 6 caracteres';
      }
    } elseif (isset($data['password']) && $data['password'] !== '') {
      // Si se actualiza y se proporciona password, validar
      if (!self::validateLength($data['password'], 6)) {
        $errors['password'] = 'La contraseña debe tener al menos 6 caracteres';
      }
    }

    // Role ID (requerido, entero positivo)
    if (!$isUpdate || isset($data['role_id'])) {
      if (!isset($data['role_id']) || !self::validatePositiveInteger($data['role_id'])) {
        $errors['role_id'] = 'El rol es requerido y debe ser un ID válido';
      }
    }

    // Area ID (opcional, pero si está presente debe ser entero positivo)
    if (isset($data['area_id']) && $data['area_id'] !== '' && !self::validatePositiveInteger($data['area_id'])) {
      $errors['area_id'] = 'El área debe ser un ID válido';
    }

    return $errors;
  }

  /**
   * Validar datos de área
   */
  public static function validateAreaData(array $data): array
  {
    $errors = [];

    // Nombre (requerido, 1-100 caracteres)
    if (!isset($data['name']) || !self::validateRequired($data['name'])) {
      $errors['name'] = 'El nombre es requerido';
    } elseif (!self::validateLength($data['name'], 1, 100)) {
      $errors['name'] = 'El nombre debe tener entre 1 y 100 caracteres';
    }

    // Código (requerido, 1-50 caracteres)
    if (!isset($data['code']) || !self::validateRequired($data['code'])) {
      $errors['code'] = 'El código es requerido';
    } elseif (!self::validateLength($data['code'], 1, 50)) {
      $errors['code'] = 'El código debe tener entre 1 y 50 caracteres';
    }

    // Tipo (requerido, valores permitidos)
    $allowedTypes = ['AREA', 'PROYECTO'];
    if (!isset($data['type']) || !self::validateIn($data['type'], $allowedTypes)) {
      $errors['type'] = 'El tipo debe ser AREA o PROYECTO';
    }

    // Parent ID (opcional, pero si está presente debe ser entero positivo)
    if (isset($data['parent_id']) && $data['parent_id'] !== '' && !self::validatePositiveInteger($data['parent_id'])) {
      $errors['parent_id'] = 'El área padre debe ser un ID válido';
    }

    return $errors;
  }

  /**
   * Validar datos de actividad ODS para CRUD administrativo.
   */
  public static function validateOdsActivityData(array $data, bool $isUpdate = false): array
  {
    $errors = [];
    $allowedStatuses = ['Borrador', 'Activa', 'En pausa', 'Finalizada', 'Cancelada'];

    if (!$isUpdate || array_key_exists('service_order_id', $data)) {
      if (!isset($data['service_order_id']) || !self::validatePositiveInteger($data['service_order_id'])) {
        $errors['service_order_id'] = 'La ODS es obligatoria y debe ser válida';
      }
    }

    if (!$isUpdate || array_key_exists('title', $data)) {
      if (!isset($data['title']) || !self::validateRequired($data['title'])) {
        $errors['title'] = 'El título es obligatorio';
      } elseif (!self::validateLength(trim((string)$data['title']), 3, 180)) {
        $errors['title'] = 'El título debe tener entre 3 y 180 caracteres';
      }
    }

    if (!$isUpdate || array_key_exists('description', $data)) {
      if (!isset($data['description']) || !self::validateRequired($data['description'])) {
        $errors['description'] = 'La descripción es obligatoria';
      } elseif (!self::validateLength(trim((string)$data['description']), 10, 5000)) {
        $errors['description'] = 'La descripción debe tener entre 10 y 5000 caracteres';
      }
    }

    if (!$isUpdate || array_key_exists('status', $data)) {
      if (!isset($data['status']) || !self::validateIn($data['status'], $allowedStatuses)) {
        $errors['status'] = 'El estado debe ser uno de: ' . implode(', ', $allowedStatuses);
      }
    }

    if (isset($data['item_general']) && $data['item_general'] !== null && $data['item_general'] !== '') {
      if (!self::validateLength(trim((string)$data['item_general']), 1, 20)) {
        $errors['item_general'] = 'El ítem general no puede exceder 20 caracteres';
      }
    }

    if (isset($data['item_activity']) && $data['item_activity'] !== null && $data['item_activity'] !== '') {
      if (!self::validateLength(trim((string)$data['item_activity']), 1, 20)) {
        $errors['item_activity'] = 'El ítem de actividad no puede exceder 20 caracteres';
      }
    }

    if (isset($data['support_text']) && $data['support_text'] !== null && $data['support_text'] !== '') {
      if (!self::validateLength(trim((string)$data['support_text']), 1, 5000)) {
        $errors['support_text'] = 'El soporte no puede exceder 5000 caracteres';
      }
    }

    if (isset($data['notes']) && $data['notes'] !== null && $data['notes'] !== '') {
      if (!self::validateLength(trim((string)$data['notes']), 1, 5000)) {
        $errors['notes'] = 'Las notas no pueden exceder 5000 caracteres';
      }
    }

    if (isset($data['delivery_medium_id']) && $data['delivery_medium_id'] !== null && $data['delivery_medium_id'] !== '') {
      if (!self::validatePositiveInteger($data['delivery_medium_id'])) {
        $errors['delivery_medium_id'] = 'El medio de entrega debe ser válido';
      }
    }

    if (isset($data['contracted_days']) && $data['contracted_days'] !== null && $data['contracted_days'] !== '') {
      if (!self::validateRange($data['contracted_days'], 0, 999999.99)) {
        $errors['contracted_days'] = 'Los días contratados deben estar entre 0 y 999999.99';
      }
    }

    if (isset($data['planned_start_date']) && $data['planned_start_date'] !== null && $data['planned_start_date'] !== '') {
      if (!self::validateDate($data['planned_start_date'])) {
        $errors['planned_start_date'] = 'La fecha inicial debe estar en formato YYYY-MM-DD';
      }
    }

    if (isset($data['planned_end_date']) && $data['planned_end_date'] !== null && $data['planned_end_date'] !== '') {
      if (!self::validateDate($data['planned_end_date'])) {
        $errors['planned_end_date'] = 'La fecha final debe estar en formato YYYY-MM-DD';
      }
    }

    if (
      !isset($errors['planned_start_date']) &&
      !isset($errors['planned_end_date']) &&
      !empty($data['planned_start_date']) &&
      !empty($data['planned_end_date']) &&
      !self::validateDateAfter($data['planned_end_date'], $data['planned_start_date'])
    ) {
      $errors['planned_end_date'] = 'La fecha final debe ser igual o posterior a la fecha inicial';
    }

    if (!$isUpdate || array_key_exists('assigned_user_ids', $data)) {
      if (!isset($data['assigned_user_ids']) || !is_array($data['assigned_user_ids']) || empty($data['assigned_user_ids'])) {
        $errors['assigned_user_ids'] = 'Debes asignar al menos un profesional';
      } else {
        foreach ($data['assigned_user_ids'] as $userId) {
          if (!self::validatePositiveInteger($userId)) {
            $errors['assigned_user_ids'] = 'Todos los profesionales asignados deben ser válidos';
            break;
          }
        }
      }
    }

    return $errors;
  }
}

