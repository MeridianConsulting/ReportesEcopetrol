SELECT r.*, u.email
FROM reports r
JOIN users u ON u.id = r.reported_by
WHERE r.service_order_id = ?
  AND r.period_id = ?
  AND r.deleted_at IS NULL
ORDER BY r.report_date DESC;