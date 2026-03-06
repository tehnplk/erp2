WITH updated AS (
  UPDATE public."Survey" s
  SET "pricePerUnit" = p."costPrice",
      updated_at = NOW()
  FROM public."Product" p
  WHERE p.code IS NOT DISTINCT FROM s."productCode"
    AND p."costPrice" IS NOT NULL
    AND (s."pricePerUnit" IS NULL OR s."pricePerUnit" <> p."costPrice")
  RETURNING s.id, s."productCode", s."pricePerUnit", p."costPrice"
)
SELECT COUNT(*) AS rows_updated FROM updated;
