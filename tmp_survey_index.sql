CREATE UNIQUE INDEX IF NOT EXISTS "Survey_budget_dept_product_sequence_uidx"
ON public."Survey" (budget_year, "requestingDept", "productCode", sequence_no);
