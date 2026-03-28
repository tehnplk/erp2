BEGIN;

DROP VIEW IF EXISTS public.inventory_stock_lot_detail_summary;

CREATE OR REPLACE VIEW public.inventory_stock_lot_detail_summary AS
SELECT
  ri.id AS receipt_item_id,
  r.id AS receipt_id,
  r.receipt_no,
  r.receipt_type,
  r.receipt_date,
  r.delivery_note_no,
  r.note AS receipt_note,
  isl.id AS stock_lot_id,
  ri.product_id,
  p.code AS product_code,
  p.name AS product_name,
  p.category,
  p.type AS product_type,
  p.subtype AS product_subtype,
  p.unit,
  ri.lot_no,
  ri.received_qty::numeric(14,2) AS total_received_qty,
  ri.total_price::numeric(14,2) AS total_received_value,
  COALESCE(isl.qty_on_hand, 0)::numeric(14,2) AS qty_on_hand,
  COALESCE(isl.total_value, 0)::numeric(14,2) AS total_value,
  COALESCE(isl.avg_unit_price, 0)::numeric(14,4) AS avg_unit_price,
  r.receipt_date AS last_received_at,
  ri.created_at
FROM public.inventory_receipt_item ri
INNER JOIN public.inventory_receipt r ON r.id = ri.receipt_id
INNER JOIN public.product p ON p.id = ri.product_id
LEFT JOIN public.inventory_stock_lot isl
  ON isl.product_id = ri.product_id
 AND isl.lot_no = ri.lot_no
WHERE p.is_active = true;

COMMIT;
