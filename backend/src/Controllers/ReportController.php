<?php

namespace App\Controllers;

use App\Core\Request;
use App\Core\Response;
use App\Services\ReportService;

class ReportController
{
  private $reportService;

  public function __construct()
  {
    $this->reportService = new ReportService();
  }

  public function daily(Request $request)
  {
    $userContext = $request->getAttribute('userContext');
    $date = $request->getQuery('date');
    $areaId = $request->getQuery('area_id') ? (int)$request->getQuery('area_id') : null;

    $report = $this->reportService->getDailyReport($date, $areaId, $userContext);

    return Response::json([
      'data' => $report
    ]);
  }

  public function management(Request $request)
  {
    $dateFrom = $request->getQuery('date_from');
    $dateTo = $request->getQuery('date_to');
    // Sin fechas o vacías = "Todo" (todos los datos)
    if ($dateFrom === '' || $dateFrom === null) {
      $dateFrom = null;
    }
    if ($dateTo === '' || $dateTo === null) {
      $dateTo = null;
    }

    $report = $this->reportService->getManagementReport($dateFrom, $dateTo);

    return Response::json([
      'data' => $report
    ]);
  }

  public function weeklyEvolution(Request $request)
  {
    $data = $this->reportService->getWeeklyEvolution();

    return Response::json([
      'data' => $data
    ]);
  }

  public function quarterlyCompliance(Request $request)
  {
    $data = $this->reportService->getQuarterlyCompliance();

    return Response::json([
      'data' => $data
    ]);
  }

  public function advancedStats(Request $request)
  {
    $data = $this->reportService->getAdvancedStats();

    return Response::json([
      'data' => $data
    ]);
  }

  /**
   * Líneas de reporte del usuario (ODS): para pantalla "Mis reportes" / My Tasks.
   */
  public function myReportLines(Request $request)
  {
    $userContext = $request->getAttribute('userContext');
    $userId = (int)($userContext['id'] ?? 0);
    if (!$userId) {
      return Response::json(['error' => ['code' => 'UNAUTHORIZED', 'message' => 'User not found']], 401);
    }
    $rows = $this->reportService->getMyReportLines($userId);
    return Response::json(['data' => $rows]);
  }

  /** Catálogo: órdenes de servicio (ODS) */
  public function serviceOrders(Request $request)
  {
    $list = $this->reportService->getServiceOrdersList();
    return Response::json(['data' => $list]);
  }

  /** Catálogo: períodos (mes a reportar) */
  public function reportPeriods(Request $request)
  {
    $list = $this->reportService->getReportPeriodsList();
    return Response::json(['data' => $list]);
  }

  /** Catálogo: medios de entrega */
  public function deliveryMedia(Request $request)
  {
    $list = $this->reportService->getDeliveryMediaList();
    return Response::json(['data' => $list]);
  }

  /** Crear línea de reporte (POST) */
  public function reportLineStore(Request $request)
  {
    $userContext = $request->getAttribute('userContext');
    $userId = (int)($userContext['id'] ?? 0);
    if (!$userId) {
      return Response::json(['error' => ['code' => 'UNAUTHORIZED', 'message' => 'User not found']], 401);
    }
    $body = $request->getBody() ?? [];
    if (!is_array($body)) {
      return Response::json(['error' => ['code' => 'BAD_REQUEST', 'message' => 'Invalid body']], 400);
    }
    try {
      $result = $this->reportService->storeReportLine($userId, $body);
      return Response::json(['data' => $result]);
    } catch (\InvalidArgumentException $e) {
      return Response::json(['error' => ['code' => 'VALIDATION', 'message' => $e->getMessage()]], 400);
    } catch (\Exception $e) {
      return Response::json(['error' => ['code' => 'SERVER_ERROR', 'message' => $e->getMessage()]], 500);
    }
  }

  /** Actualizar línea de reporte (PUT) */
  public function reportLineUpdate(Request $request, $id)
  {
    $userContext = $request->getAttribute('userContext');
    $userId = (int)($userContext['id'] ?? 0);
    if (!$userId) {
      return Response::json(['error' => ['code' => 'UNAUTHORIZED', 'message' => 'User not found']], 401);
    }
    $lineId = (int) $id;
    $body = $request->getBody() ?? [];
    if (!is_array($body)) {
      return Response::json(['error' => ['code' => 'BAD_REQUEST', 'message' => 'Invalid body']], 400);
    }
    try {
      $this->reportService->updateReportLine($userId, $lineId, $body);
      return Response::json(['data' => ['report_line_id' => $lineId]]);
    } catch (\RuntimeException $e) {
      return Response::json(['error' => ['code' => 'NOT_FOUND', 'message' => $e->getMessage()]], 404);
    } catch (\Exception $e) {
      return Response::json(['error' => ['code' => 'SERVER_ERROR', 'message' => $e->getMessage()]], 500);
    }
  }

  /** Eliminar línea de reporte (DELETE) */
  public function reportLineDestroy(Request $request, $id)
  {
    $userContext = $request->getAttribute('userContext');
    $userId = (int)($userContext['id'] ?? 0);
    if (!$userId) {
      return Response::json(['error' => ['code' => 'UNAUTHORIZED', 'message' => 'User not found']], 401);
    }
    $lineId = (int) $id;
    try {
      $this->reportService->deleteReportLine($userId, $lineId);
      return Response::json(['data' => ['deleted' => true]]);
    } catch (\RuntimeException $e) {
      return Response::json(['error' => ['code' => 'NOT_FOUND', 'message' => $e->getMessage()]], 404);
    } catch (\Exception $e) {
      return Response::json(['error' => ['code' => 'SERVER_ERROR', 'message' => $e->getMessage()]], 500);
    }
  }
}

