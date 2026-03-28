BEGIN;

CREATE OR REPLACE VIEW public.inventory_stock_summary AS
WITH receipt_last_received AS (
  SELECT
    ri.product_id,
    MAX(r.receipt_date) AS last_received_at
  FROM public.inventory_receipt_item ri
  INNER JOIN public.inventory_receipt r ON r.id = ri.receipt_id
  GROUP BY ri.product_id
)
SELECT
  p.id AS product_id,
  p.code AS product_code,
  p.name AS product_name,
  p.category,
  p.type AS product_type,
  p.subtype AS product_subtype,
  p.unit,
  COUNT(isl.id)::int AS lot_count,
  COALESCE(SUM(isl.qty_on_hand), 0)::numeric(14,2) AS total_qty,
  COALESCE(SUM(isl.total_value), 0)::numeric(14,2) AS total_value,
  CASE
    WHEN COALESCE(SUM(isl.qty_on_hand), 0) = 0 THEN 0::numeric
    ELSE ROUND(COALESCE(SUM(isl.total_value), 0) / NULLIF(SUM(isl.qty_on_hand), 0), 4)
  END AS avg_unit_price,
  rlr.last_received_at,
  MAX(isl.updated_at) AS updated_at,
  COALESCE(STRING_AGG(DISTINCT isl.lot_no, ', ' ORDER BY isl.lot_no) FILTER (WHERE isl.lot_no IS NOT NULL), '-') AS lot_numbers,
  (
    SELECT r.delivery_note_no
    FROM public.inventory_receipt_item ri
    INNER JOIN public.inventory_receipt r ON r.id = ri.receipt_id
    WHERE ri.product_id = p.id
      AND r.receipt_type = 'DELIVERY_NOTE'
    ORDER BY r.receipt_date DESC, r.id DESC
    LIMIT 1
  ) AS last_delivery_note_no
FROM public.product p
INNER JOIN public.inventory_stock_lot isl ON isl.product_id = p.id
LEFT JOIN receipt_last_received rlr ON rlr.product_id = p.id
WHERE p.is_active = true
GROUP BY p.id, p.code, p.name, p.category, p.type, p.subtype, p.unit, rlr.last_received_at;

COMMIT;
