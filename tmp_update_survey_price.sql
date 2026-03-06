\echo 'Rows to update (matching product costPrice)'
SELECT COUNT(*) AS rows_to_update
FROM public."Survey" s
JOIN public."Product" p
  ON p.code IS NOT DISTINCT FROM s."productCode"
WHERE p."costPrice" IS NOT NULL
  AND COALESCE(s."pricePerUnit", 0) IS DISTINCT FROM p."costPrice";

\echo 'Updating survey pricePerUnit from product costPrice...'
WITH updated AS (
  UPDATE public."Survey" s
  SET "pricePerUnit" = p."costPrice",
      updated_at = NOW()
  FROM public."Product" p
  WHERE p.code IS NOT DISTINCT FROM s."productCode"
    AND p."costPrice" IS NOT NULL
    AND COALESCE(s."pricePerUnit", 0) IS DISTINCT FROM p."costPrice"
  RETURNING s.id, s."productCode", p."costPrice"
)
SELECT COUNT(*) AS rows_updated FROM updated;
