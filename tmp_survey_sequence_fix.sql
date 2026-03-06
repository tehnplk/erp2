WITH ranked AS (
  SELECT
    id,
    ROW_NUMBER() OVER (
      PARTITION BY budget_year, "requestingDept", "productCode"
      ORDER BY id
    ) AS seq_rank
  FROM public."Survey"
)
UPDATE public."Survey" s
SET sequence_no = ranked.seq_rank,
    updated_at = CURRENT_TIMESTAMP
FROM ranked
WHERE s.id = ranked.id
  AND ranked.seq_rank <= 2;
