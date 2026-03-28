BEGIN;

ALTER TABLE public.inventory_issue
  DROP COLUMN IF EXISTS total_items,
  DROP COLUMN IF EXISTS total_qty;

ALTER TABLE public.inventory_stock_lot
  DROP COLUMN IF EXISTS avg_unit_price,
  DROP COLUMN IF EXISTS last_received_at;

COMMIT;
