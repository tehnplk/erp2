BEGIN;

ALTER TABLE public.purchase_approval_detail DISABLE TRIGGER ALL;
ALTER TABLE public.purchase_approval_inventory_link DISABLE TRIGGER ALL;

DROP TABLE IF EXISTS temp_purchase_approval_id_map;
CREATE TEMP TABLE temp_purchase_approval_id_map AS
SELECT
  pa.id AS old_id,
  ROW_NUMBER() OVER (ORDER BY pa.created_at, pa.id) AS new_id
FROM public.purchase_approval pa
ORDER BY pa.created_at, pa.id;

UPDATE public.purchase_approval_detail pad
SET purchase_approval_id = map.new_id
FROM temp_purchase_approval_id_map map
WHERE pad.purchase_approval_id = map.old_id;

UPDATE public.purchase_approval_inventory_link pail
SET purchase_approval_id = map.new_id
FROM temp_purchase_approval_id_map map
WHERE pail.purchase_approval_id = map.old_id;

UPDATE public.purchase_approval pa
SET id = -map.new_id
FROM temp_purchase_approval_id_map map
WHERE pa.id = map.old_id;

UPDATE public.purchase_approval
SET id = -id;

WITH category_map AS (
  SELECT category, MIN(category_code) AS category_code
  FROM public.category
  GROUP BY category
), approval_choice AS (
  SELECT DISTINCT ON (pa.id)
    pa.id,
    COALESCE(category_map.category_code, '000') AS category_code,
    up.budget_year
  FROM public.purchase_approval pa
  JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id
  JOIN public.purchase_plan pp ON pp.id = pad.purchase_plan_id
  JOIN public.usage_plan up ON up.id = pp.usage_plan_id
  LEFT JOIN category_map ON category_map.category = up.category
  ORDER BY pa.id, pad.id
)
UPDATE public.purchase_approval pa
SET approve_code = CONCAT(
  approval_choice.category_code,
  '-',
  LPAD(COALESCE(approval_choice.budget_year::text, '0000'), 4, '0'),
  '-',
  LPAD(pa.id::text, 4, '0')
)
FROM approval_choice
WHERE pa.id = approval_choice.id;

SELECT setval('purchase_approval_id_seq', (SELECT MAX(id) FROM public.purchase_approval));

ALTER TABLE public.purchase_approval_detail ENABLE TRIGGER ALL;
ALTER TABLE public.purchase_approval_inventory_link ENABLE TRIGGER ALL;

COMMIT;
