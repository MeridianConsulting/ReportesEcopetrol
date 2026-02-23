<?php

namespace App\Services;

use App\Repositories\KpiRepository;
use App\Repositories\KpiCategoryRepository;
use App\Repositories\TaskKpiFactRepository;
use App\Repositories\TaskKpiInputRepository;
use App\Repositories\TaskRepository;

/**
 * Motor de cálculo de KPIs
 * Responsable de calcular y almacenar las mediciones por tarea
 */
class KpiEngineService
{
    private KpiRepository $kpiRepository;
    private KpiCategoryRepository $categoryRepository;
    private TaskKpiFactRepository $factRepository;
    private TaskKpiInputRepository $inputRepository;
    private TaskRepository $taskRepository;

    public function __construct()
    {
        $this->kpiRepository = new KpiRepository();
        $this->categoryRepository = new KpiCategoryRepository();
        $this->factRepository = new TaskKpiFactRepository();
        $this->inputRepository = new TaskKpiInputRepository();
        $this->taskRepository = new TaskRepository();
    }

    /**
     * Recalcular KPI para una tarea
     * Este es el método principal que se llama desde TaskService
     */
    public function recomputeForTask(int $taskId, array $userContext = null): void
    {
        // 1. Obtener la tarea
        $task = $this->taskRepository->findById($taskId, $userContext ?? ['role' => 'admin']);
        if (!$task) {
            error_log("KpiEngineService: Tarea $taskId no encontrada");
            return;
        }

        // 2. Si no tiene kpi_category_id, marcar facts previos como no aplicables
        if (empty($task['kpi_category_id'])) {
            $this->factRepository->markNotApplicable($taskId, 'No KPI category assigned');
            return;
        }

        // 3. Cargar la categoría KPI
        $category = $this->categoryRepository->findById($task['kpi_category_id']);
        if (!$category) {
            error_log("KpiEngineService: Categoría KPI {$task['kpi_category_id']} no encontrada");
            return;
        }

        // 4. Cargar el KPI
        $kpi = $this->kpiRepository->findById($category['kpi_id']);
        if (!$kpi) {
            error_log("KpiEngineService: KPI {$category['kpi_id']} no encontrado");
            return;
        }

        // 5. Determinar el period_key según el ancla
        $periodKey = $this->determinePeriodKey($task, $kpi['period_anchor']);
        if (!$periodKey) {
            $this->factRepository->upsertFact([
                'task_id' => $taskId,
                'kpi_id' => $kpi['id'],
                'area_id' => $category['area_id'],
                'period_key' => date('Y-m'), // Usar mes actual como fallback
                'is_applicable' => 0,
                'na_reason' => 'Missing date for period anchor: ' . $kpi['period_anchor'],
                'meta' => [
                    'kpi_code' => $kpi['code'],
                    'task_status' => $task['status'],
                    'rule_version' => '1.0'
                ]
            ]);
            return;
        }

        // 6. Obtener inputs de la tarea
        $inputs = $this->inputRepository->findByTask($taskId);

        // 7. Calcular el fact según el tipo de KPI
        $fact = $this->calculateFact($task, $kpi, $inputs);
        $fact['task_id'] = $taskId;
        $fact['kpi_id'] = $kpi['id'];
        $fact['area_id'] = $category['area_id'];
        $fact['period_key'] = $periodKey;
        $fact['meta'] = [
            'kpi_code' => $kpi['code'],
            'task_status' => $task['status'],
            'due_date' => $task['due_date'],
            'closed_date' => $task['closed_date'],
            'inputs_used' => $inputs,
            'rule_version' => '1.0',
            'calculated_at' => date('c')
        ];

        // 8. Guardar el fact
        $this->factRepository->upsertFact($fact);

        error_log("KpiEngineService: Recalculado KPI {$kpi['code']} para tarea $taskId, periodo $periodKey");
    }

    /**
     * Determinar el period_key basado en el ancla del KPI.
     * Si la fecha ancla está vacía, usa start_date y luego created_at para que la tarea aporte a un periodo.
     */
    private function determinePeriodKey(array $task, string $anchor): ?string
    {
        $date = null;

        switch ($anchor) {
            case 'CREATED_AT':
                $date = $task['created_at'] ?? null;
                break;
            case 'DUE_DATE':
                $date = $task['due_date'] ?? null;
                break;
            case 'CLOSED_DATE':
                $date = $task['closed_date'] ?? null;
                break;
        }

        // Fallback: fecha inicio actividad o creación para que la tarea contribuya al dashboard
        if (!$date) {
            $date = !empty($task['start_date']) ? $task['start_date'] : ($task['created_at'] ?? null);
        }

        if (!$date) {
            return null;
        }

        try {
            $dt = new \DateTime($date);
            return $dt->format('Y-m');
        } catch (\Exception $e) {
            return null;
        }
    }

    /**
     * Calcular el fact según el tipo de KPI
     */
    private function calculateFact(array $task, array $kpi, array $inputs): array
    {
        $calcKind = $kpi['calc_kind'];
        $kpiCode = $kpi['code'];

        // Dispatcher por código de KPI para lógica específica
        switch ($calcKind) {
            case 'RATIO_SUM':
                return $this->calculateRatioFact($task, $kpi, $inputs);
            case 'AVG':
                return $this->calculateAvgFact($task, $kpi, $inputs);
            default:
                return [
                    'numerator' => 0,
                    'denominator' => 1,
                    'is_applicable' => 0,
                    'na_reason' => "Unknown calc_kind: $calcKind"
                ];
        }
    }

    /**
     * Calcular fact para KPIs tipo RATIO_SUM
     */
    private function calculateRatioFact(array $task, array $kpi, array $inputs): array
    {
        $kpiCode = $kpi['code'];

        // Denominator = 1 por tarea que aplica
        $denominator = 1;
        $numerator = 0;
        $isApplicable = 1;
        $naReason = null;

        // Verificar si la tarea está completada
        $isCompleted = $task['status'] === 'Completada';

        // Verificar si fue a tiempo (closed_date <= due_date)
        $isOnTime = false;
        if ($isCompleted && !empty($task['closed_date']) && !empty($task['due_date'])) {
            $closedDate = new \DateTime($task['closed_date']);
            $dueDate = new \DateTime($task['due_date']);
            $isOnTime = $closedDate <= $dueDate;
        }

        // Lógica específica por tipo de KPI
        switch ($kpiCode) {
            // === CONTABLE ===
            case 'CONT_01': // Registro oportuno
            case 'CONT_02': // Conciliaciones
            case 'CONT_03': // CxP
            case 'CONT_05': // Obligaciones tributarias
                // Numerador = 1 si completada a tiempo
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
                break;

            case 'CONT_04': // Calidad info (sin ajustes)
                // Requiere input 'sin_ajustes'
                if ($isCompleted) {
                    $sinAjustes = $inputs['sin_ajustes'] ?? false;
                    $numerator = $sinAjustes ? 1 : 0;
                }
                break;

            // === PROYECTOS ===
            case 'PROY_01': // Facturación
                // Si tiene inputs numéricos, usarlos; si no, usar completado
                if (isset($inputs['facturacion_realizada']) && isset($inputs['servicios_ejecutados'])) {
                    $numerator = (float)$inputs['facturacion_realizada'];
                    $denominator = (float)$inputs['servicios_ejecutados'];
                    if ($denominator == 0) {
                        $isApplicable = 0;
                        $naReason = 'Servicios ejecutados = 0';
                    }
                } else {
                    $numerator = $isCompleted ? 1 : 0;
                }
                break;

            case 'PROY_02': // Informes operativos
            case 'PROY_03': // Requisitos contables
            case 'PROY_05': // Pago proveedores
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
                break;

            case 'PROY_04': // Contratación
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
                break;

            // === ADMINISTRATIVA ===
            case 'ADM_01': // Índice de Cumplimiento del Plan de Gestión Administrativa (actividades ejecutadas/planificadas)
            case 'ADM_04': // Exactitud inventario
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
                break;

            case 'ADM_02': // Índice de Cumplimiento de Procedimientos (procesos conformes/ejecutados)
                if ($isCompleted) {
                    $conforme = $inputs['conforme_procedimiento'] ?? false;
                    $numerator = $conforme ? 1 : 0;
                } else {
                    $denominator = 0; // Solo las tareas completadas cuentan como procesos ejecutados
                    $isApplicable = 0;
                    $naReason = 'Proceso no ejecutado (tarea no completada)';
                }
                break;

            case 'ADM_03': // Calidad documental (primer envío OK)
                if ($isCompleted) {
                    $primerEnvioOk = $inputs['primer_envio_ok'] ?? false;
                    $numerator = $primerEnvioOk ? 1 : 0;
                }
                break;

            // === HSEQ ===
            case 'HSEQ_01': // Programa HSEQ
            case 'HSEQ_02': // Acciones correctivas
            case 'HSEQ_03': // Incidentes
            case 'HSEQ_05': // Capacitaciones
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
                break;

            case 'HSEQ_04': // Informes (a tiempo Y aprobados)
                if ($isCompleted && $isOnTime) {
                    $aprobado = $inputs['aprobado'] ?? false;
                    $numerator = $aprobado ? 1 : 0;
                }
                break;

            // === GESTIÓN HUMANA ===
            case 'GH_01': // Plan GH
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
                break;

            case 'GH_02': // Exactitud nómina
                if ($isCompleted) {
                    $sinReproceso = $inputs['sin_reproceso'] ?? false;
                    $numerator = $sinReproceso ? 1 : 0;
                }
                break;

            case 'GH_03': // Rotación (requiere input externo - se maneja diferente)
            case 'GH_04': // Ausentismo (requiere input externo)
                // Estos KPIs requieren datos de periodo, no de tarea individual
                // La tarea aporta al numerador (salidas/ausencias)
                $numerator = $isCompleted ? 1 : 0;
                $denominator = 1; // El denominador real viene de kpi_period_inputs
                break;

            // === SOPORTE IT ===
            case 'IT_01': // Continuidad Operativa de Servicios Críticos (Disponibilidad)
                // Servicio crítico operativo si la tarea está completada a tiempo
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
                break;

            case 'IT_02': // Cumplimiento del Plan de Mantenimiento Tecnológico (Infraestructura)
                // Mantenimiento ejecutado si la tarea está completada
                $numerator = $isCompleted ? 1 : 0;
                break;

            case 'IT_03': // Entrega de Desarrollo y Automatización (Software)
                // Desarrollo finalizado si la tarea está completada
                $numerator = $isCompleted ? 1 : 0;
                break;

            case 'IT_04': // Actualización de Documentación y Control de Activos IT
                // Documento actualizado si la tarea está completada a tiempo
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
                break;

            case 'IT_05': // Eficiencia en Atención y Cierre de Soporte IT
                // Incidente cerrado si la tarea está completada
                $numerator = $isCompleted ? 1 : 0;
                break;

            default:
                // Por defecto: completada a tiempo
                $numerator = ($isCompleted && $isOnTime) ? 1 : 0;
        }

        return [
            'numerator' => $numerator,
            'denominator' => $denominator,
            'sample_value' => null,
            'is_applicable' => $isApplicable,
            'na_reason' => $naReason
        ];
    }

    /**
     * Calcular fact para KPIs tipo AVG
     */
    private function calculateAvgFact(array $task, array $kpi, array $inputs): array
    {
        $kpiCode = $kpi['code'];
        $sampleValue = null;
        $isApplicable = 1;
        $naReason = null;

        // Solo calcular si la tarea está completada
        $isCompleted = $task['status'] === 'Completada';

        if (!$isCompleted) {
            return [
                'numerator' => 0,
                'denominator' => 0,
                'sample_value' => null,
                'is_applicable' => 0,
                'na_reason' => 'Task not completed'
            ];
        }

        switch ($kpiCode) {
            case 'ADM_05': // CSAT (rating 1-5)
                if (isset($inputs['csat_rating'])) {
                    $sampleValue = (float)$inputs['csat_rating'];
                    // Validar rango
                    if ($sampleValue < 1 || $sampleValue > 5) {
                        $isApplicable = 0;
                        $naReason = 'CSAT rating out of range (1-5)';
                    }
                } else {
                    $isApplicable = 0;
                    $naReason = 'Missing CSAT rating';
                }
                break;

            case 'GH_05': // Tiempo respuesta (días)
                // Calcular diferencia entre created_at y closed_date en días
                if (!empty($task['closed_date']) && !empty($task['created_at'])) {
                    $created = new \DateTime($task['created_at']);
                    $closed = new \DateTime($task['closed_date']);
                    $diff = $created->diff($closed);
                    $sampleValue = $diff->days + ($diff->h / 24);
                } else {
                    $isApplicable = 0;
                    $naReason = 'Missing dates for response time calculation';
                }
                break;

            default:
                $isApplicable = 0;
                $naReason = "Unknown AVG KPI: $kpiCode";
        }

        return [
            'numerator' => 0,
            'denominator' => $isApplicable ? 1 : 0,
            'sample_value' => $sampleValue,
            'is_applicable' => $isApplicable,
            'na_reason' => $naReason
        ];
    }

    /**
     * Guardar inputs KPI para una tarea
     */
    public function saveTaskInputs(int $taskId, array $inputs): bool
    {
        return $this->inputRepository->saveInputs($taskId, $inputs);
    }

    /**
     * Obtener inputs KPI de una tarea
     */
    public function getTaskInputs(int $taskId): array
    {
        return $this->inputRepository->findByTask($taskId);
    }

    /**
     * Recalcular todos los facts de tareas existentes (para backfill)
     */
    public function backfillAllTasks(): array
    {
        $sql = "SELECT id FROM tasks WHERE kpi_category_id IS NOT NULL AND deleted_at IS NULL";
        $db = \App\Core\Database::getInstance()->getConnection();
        $stmt = $db->query($sql);
        $taskIds = $stmt->fetchAll(\PDO::FETCH_COLUMN);

        $results = ['processed' => 0, 'errors' => []];

        foreach ($taskIds as $taskId) {
            try {
                $this->recomputeForTask($taskId);
                $results['processed']++;
            } catch (\Exception $e) {
                $results['errors'][] = [
                    'task_id' => $taskId,
                    'error' => $e->getMessage()
                ];
            }
        }

        return $results;
    }
}
