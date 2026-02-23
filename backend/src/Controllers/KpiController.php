<?php

namespace App\Controllers;

use App\Core\Request;
use App\Core\Response;
use App\Services\KpiSummaryService;
use App\Services\KpiEngineService;
use App\Repositories\KpiRepository;
use App\Repositories\KpiCategoryRepository;

/**
 * Controlador para endpoints de KPIs
 */
class KpiController
{
    private KpiSummaryService $summaryService;
    private KpiEngineService $engineService;
    private KpiRepository $kpiRepository;
    private KpiCategoryRepository $categoryRepository;

    public function __construct()
    {
        $this->summaryService = new KpiSummaryService();
        $this->engineService = new KpiEngineService();
        $this->kpiRepository = new KpiRepository();
        $this->categoryRepository = new KpiCategoryRepository();
    }

    /**
     * GET /api/v1/kpi-categories
     * Listar categorías KPI disponibles
     * Parámetros:
     * - area_id: filtrar por área específica
     * - all: si es "true", devuelve todas las categorías (para formularios de asignación)
     */
    public function categories(Request $request)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            $areaId = $request->getQuery('area_id');
            $all = $request->getQuery('all') === 'true';

            // Determinar áreas permitidas según rol
            $filters = [];
            
            // Si se solicita "all=true", traer TODAS las categorías sin filtrar
            // Útil para formularios de asignación donde se necesitan todas las categorías
            if ($all) {
                // No aplicar filtros de área - devolver todas las categorías activas
            } elseif ($areaId) {
                // Si se solicita un área específica, usarla
                $filters['area_id'] = (int)$areaId;
            } elseif ($userContext['role'] === 'admin') {
                // Admin ve todas si no hay filtro específico
            } elseif ($userContext['role'] === 'lider_area') {
                // Líder: si tiene múltiples áreas, obtener categorías de todas
                $areaIds = $userContext['area_ids'] ?? [];
                if (count($areaIds) > 1) {
                    $filters['area_ids'] = $areaIds;
                } else {
                    $filters['area_id'] = $userContext['area_id'];
                }
            } else {
                // Colaborador - sus áreas
                $areaIds = $userContext['area_ids'] ?? [];
                if (count($areaIds) > 1) {
                    $filters['area_ids'] = $areaIds;
                } else {
                    $filters['area_id'] = $userContext['area_id'];
                }
            }

            $categories = $this->categoryRepository->findAll($filters);

            // Agrupar por área para mejor visualización
            $grouped = [];
            foreach ($categories as $cat) {
                $areaName = $cat['area_name'];
                if (!isset($grouped[$areaName])) {
                    $grouped[$areaName] = [
                        'area_id' => $cat['area_id'],
                        'area_name' => $areaName,
                        'area_code' => $cat['area_code'],
                        'categories' => []
                    ];
                }
                $grouped[$areaName]['categories'][] = [
                    'id' => $cat['id'],
                    'name' => $cat['name'],
                    'slug' => $cat['slug'],
                    'kpi_id' => $cat['kpi_id'],
                    'kpi_code' => $cat['kpi_code'],
                    'kpi_name' => $cat['kpi_name'],
                    'calc_kind' => $cat['calc_kind'],
                    'unit' => $cat['unit']
                ];
            }

            return Response::json([
                'data' => array_values($grouped),
                'flat' => $categories
            ]);
        } catch (\Exception $e) {
            error_log('KpiController::categories error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/kpi-categories/by-area/{areaId}
     * Listar categorías KPI de un área específica
     */
    public function categoriesByArea(Request $request, string $areaId)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            $areaId = (int)$areaId;

            // Verificar permisos (soportar múltiples áreas)
            $userAreaIds = $userContext['area_ids'] ?? ($userContext['area_id'] ? [(int)$userContext['area_id']] : []);

            if ($userContext['role'] === 'lider_area' && !in_array($areaId, $userAreaIds)) {
                return Response::json([
                    'error' => [
                        'code' => 'FORBIDDEN',
                        'message' => 'No tienes permiso para ver categorías de esta área'
                    ]
                ], 403);
            }

            if ($userContext['role'] === 'colaborador' && !in_array($areaId, $userAreaIds)) {
                return Response::json([
                    'error' => [
                        'code' => 'FORBIDDEN',
                        'message' => 'No tienes permiso para ver categorías de esta área'
                    ]
                ], 403);
            }

            $categories = $this->categoryRepository->findByAreaId($areaId);

            // Agregar inputs requeridos a cada categoría
            foreach ($categories as &$cat) {
                $cat['required_inputs'] = $this->categoryRepository->getRequiredInputs($cat['id']);
            }

            return Response::json(['data' => $categories]);
        } catch (\Exception $e) {
            error_log('KpiController::categoriesByArea error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/kpis/summary
     * Obtener resumen de KPIs para el dashboard
     */
    public function summary(Request $request)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            $areaId = $request->getQuery('area_id');
            $period = $request->getQuery('period') ?? date('Y-m');

            // Determinar área según permisos
            if ($userContext['role'] === 'admin') {
                if (!$areaId) {
                    return Response::json([
                        'error' => [
                            'code' => 'VALIDATION_ERROR',
                            'message' => 'area_id es requerido'
                        ]
                    ], 400);
                }
                $areaId = (int)$areaId;
            } else {
                // Líder y colaborador: solo su área
                $areaId = (int)$userContext['area_id'];
            }

            $summary = $this->summaryService->getSummary($areaId, $period);

            return Response::json([
                'data' => $summary,
                'meta' => [
                    'area_id' => $areaId,
                    'period' => $period,
                    'kpi_count' => count($summary)
                ]
            ]);
        } catch (\Exception $e) {
            error_log('KpiController::summary error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/kpis/summary/all
     * Obtener resumen de KPIs de TODAS las áreas (solo admin)
     * Para el dashboard general consolidado
     */
    public function summaryAll(Request $request)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            $dateFrom = $request->getQuery('date_from') ?: null;
            $dateTo = $request->getQuery('date_to') ?: null;
            // Legacy: si solo viene period=YYYY-MM, usarlo como rango (primer y último día del mes)
            $period = $request->getQuery('period');
            if ($period && !$dateFrom && !$dateTo && preg_match('/^\d{4}-\d{2}$/', $period)) {
                $dateFrom = $period . '-01';
                $dateTo = date('Y-m-t', strtotime($period . '-01'));
            } elseif (!$dateFrom && !$dateTo) {
                $dateFrom = null;
                $dateTo = null;
            }

            // Solo admin puede ver todas las áreas
            if ($userContext['role'] !== 'admin') {
                return Response::json([
                    'error' => [
                        'code' => 'FORBIDDEN',
                        'message' => 'Solo administradores pueden ver el resumen general'
                    ]
                ], 403);
            }

            // Obtener todas las áreas activas
            $areasRepo = new \App\Repositories\AreaRepository();
            $areas = $areasRepo->findAll();

            $result = [];
            $globalStats = [
                'total_kpis' => 0,
                'green_count' => 0,
                'yellow_count' => 0,
                'red_count' => 0,
                'na_count' => 0,
                'avg_performance' => 0,
                'performance_sum' => 0,
                'performance_count' => 0,
            ];

            foreach ($areas as $area) {
                $areaKpis = $this->summaryService->getSummary($area['id'], null, $dateFrom, $dateTo);
                
                if (!empty($areaKpis)) {
                    $areaStats = [
                        'green' => 0,
                        'yellow' => 0,
                        'red' => 0,
                        'na' => 0,
                    ];

                    foreach ($areaKpis as $kpi) {
                        $globalStats['total_kpis']++;
                        $isNA = $kpi['is_na'] === true;
                        $color = strtolower($kpi['color'] ?? 'white');

                        if ($isNA) {
                            $areaStats['na']++;
                            $globalStats['na_count']++;
                        } else {
                            switch ($color) {
                                case 'green':
                                    $areaStats['green']++;
                                    $globalStats['green_count']++;
                                    break;
                                case 'yellow':
                                    $areaStats['yellow']++;
                                    $globalStats['yellow_count']++;
                                    break;
                                case 'red':
                                    $areaStats['red']++;
                                    $globalStats['red_count']++;
                                    break;
                                default:
                                    $areaStats['na']++;
                                    $globalStats['na_count']++;
                            }
                        }

                        // Promedio de rendimiento solo para KPIs con valor numérico (no NA)
                        if (!$isNA && isset($kpi['value']) && is_numeric($kpi['value'])) {
                            $globalStats['performance_sum'] += floatval($kpi['value']);
                            $globalStats['performance_count']++;
                        }
                    }

                    $result[] = [
                        'area_id' => $area['id'],
                        'area_name' => $area['name'],
                        'area_code' => $area['code'] ?? null,
                        'kpis' => $areaKpis,
                        'stats' => $areaStats,
                        'total_kpis' => count($areaKpis),
                    ];
                }
            }

            $globalStats['avg_performance'] = $globalStats['performance_count'] > 0
                ? round($globalStats['performance_sum'] / $globalStats['performance_count'], 1)
                : 0;

            // Ordenar por nombre de área
            usort($result, function($a, $b) {
                return strcmp($a['area_name'], $b['area_name']);
            });

            return Response::json([
                'data' => $result,
                'global_stats' => $globalStats,
                'meta' => [
                    'date_from' => $dateFrom,
                    'date_to' => $dateTo,
                    'areas_with_kpis' => count($result),
                    'generated_at' => date('Y-m-d H:i:s')
                ]
            ]);
        } catch (\Exception $e) {
            error_log('KpiController::summaryAll error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/kpis/{kpiId}/details
     * Obtener detalle de un KPI específico con las tareas que lo componen
     */
    public function details(Request $request, string $kpiId)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            $areaId = $request->getQuery('area_id');
            $period = $request->getQuery('period') ?? date('Y-m');

            // Determinar área según permisos
            if ($userContext['role'] === 'admin') {
                if (!$areaId) {
                    return Response::json([
                        'error' => [
                            'code' => 'VALIDATION_ERROR',
                            'message' => 'area_id es requerido'
                        ]
                    ], 400);
                }
                $areaId = (int)$areaId;
            } else {
                $areaId = (int)$userContext['area_id'];
            }

            $details = $this->summaryService->getKpiDetails((int)$kpiId, $areaId, $period);

            return Response::json(['data' => $details]);
        } catch (\Exception $e) {
            error_log('KpiController::details error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/kpis/{kpiId}/trend
     * Obtener tendencia histórica de un KPI
     */
    public function trend(Request $request, string $kpiId)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            $areaId = $request->getQuery('area_id');
            $periods = (int)($request->getQuery('periods') ?? 6);

            // Determinar área según permisos
            if ($userContext['role'] === 'admin') {
                if (!$areaId) {
                    return Response::json([
                        'error' => [
                            'code' => 'VALIDATION_ERROR',
                            'message' => 'area_id es requerido'
                        ]
                    ], 400);
                }
                $areaId = (int)$areaId;
            } else {
                $areaId = (int)$userContext['area_id'];
            }

            $trend = $this->summaryService->getKpiTrend((int)$kpiId, $areaId, $periods);
            $kpi = $this->kpiRepository->findById((int)$kpiId);

            return Response::json([
                'data' => [
                    'kpi' => $kpi,
                    'trend' => $trend
                ]
            ]);
        } catch (\Exception $e) {
            error_log('KpiController::trend error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/kpis/periods
     * Obtener periodos disponibles para un área
     */
    public function periods(Request $request)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            $areaId = $request->getQuery('area_id');

            // Determinar área según permisos
            if ($userContext['role'] === 'admin') {
                if (!$areaId) {
                    return Response::json([
                        'error' => [
                            'code' => 'VALIDATION_ERROR',
                            'message' => 'area_id es requerido'
                        ]
                    ], 400);
                }
                $areaId = (int)$areaId;
            } else {
                $areaId = (int)$userContext['area_id'];
            }

            $periods = $this->summaryService->getAvailablePeriods($areaId);

            return Response::json(['data' => $periods]);
        } catch (\Exception $e) {
            error_log('KpiController::periods error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/kpis/issues
     * Obtener issues pendientes (thresholds inconsistentes)
     */
    public function issues(Request $request)
    {
        try {
            $userContext = $request->getAttribute('userContext');

            // Solo admin puede ver issues
            if ($userContext['role'] !== 'admin') {
                return Response::json([
                    'error' => [
                        'code' => 'FORBIDDEN',
                        'message' => 'Solo administradores pueden ver issues'
                    ]
                ], 403);
            }

            $issues = $this->summaryService->getPendingIssues();

            return Response::json(['data' => $issues]);
        } catch (\Exception $e) {
            error_log('KpiController::issues error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/kpis/global-trend
     * Obtener tendencia histórica global de rendimiento KPI
     */
    public function globalTrend(Request $request)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            if ($userContext['role'] !== 'admin') {
                return Response::json(['error' => ['code' => 'FORBIDDEN', 'message' => 'Acceso denegado']], 403);
            }

            $months = (int)($request->getQuery('months') ?? 6);
            if ($months < 1 || $months > 24) {
                $months = 6;
            }

            $trend = $this->summaryService->getGlobalTrend($months);

            return Response::json(['data' => $trend]);
        } catch (\Exception $e) {
            error_log('KpiController::globalTrend error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * POST /api/v1/kpis/backfill
     * Recalcular KPIs para todas las tareas (admin only)
     */
    public function backfill(Request $request)
    {
        try {
            $userContext = $request->getAttribute('userContext');

            // Solo admin puede ejecutar backfill
            if ($userContext['role'] !== 'admin') {
                return Response::json([
                    'error' => [
                        'code' => 'FORBIDDEN',
                        'message' => 'Solo administradores pueden ejecutar backfill'
                    ]
                ], 403);
            }

            $results = $this->engineService->backfillAllTasks();

            return Response::json([
                'data' => $results,
                'message' => "Procesadas {$results['processed']} tareas"
            ]);
        } catch (\Exception $e) {
            error_log('KpiController::backfill error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * PUT /api/v1/tasks/{taskId}/kpi-inputs
     * Guardar inputs KPI para una tarea
     */
    public function saveTaskInputs(Request $request, string $taskId)
    {
        try {
            $userContext = $request->getAttribute('userContext');
            $body = $request->getBody();

            if (empty($body['inputs']) || !is_array($body['inputs'])) {
                return Response::json([
                    'error' => [
                        'code' => 'VALIDATION_ERROR',
                        'message' => 'inputs es requerido y debe ser un array'
                    ]
                ], 400);
            }

            // Guardar inputs
            $this->engineService->saveTaskInputs((int)$taskId, $body['inputs']);

            // Recalcular KPI
            $this->engineService->recomputeForTask((int)$taskId, $userContext);

            return Response::json([
                'data' => [
                    'task_id' => (int)$taskId,
                    'inputs' => $body['inputs'],
                    'message' => 'Inputs guardados y KPI recalculado'
                ]
            ]);
        } catch (\Exception $e) {
            error_log('KpiController::saveTaskInputs error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }

    /**
     * GET /api/v1/tasks/{taskId}/kpi-inputs
     * Obtener inputs KPI de una tarea
     */
    public function getTaskInputs(Request $request, string $taskId)
    {
        try {
            $inputs = $this->engineService->getTaskInputs((int)$taskId);

            return Response::json(['data' => $inputs]);
        } catch (\Exception $e) {
            error_log('KpiController::getTaskInputs error: ' . $e->getMessage());
            return Response::json([
                'error' => [
                    'code' => 'INTERNAL_ERROR',
                    'message' => $e->getMessage()
                ]
            ], 500);
        }
    }
}
