SELECT id, "productCode", "productName", "budgetYear"
FROM "PurchasePlan"
WHERE ("budgetYear" IS NULL OR btrim("budgetYear") = '')
ORDER BY id
LIMIT 50;
