SELECT s.id,
       s."productCode",
       s."pricePerUnit"::float8 AS survey_price,
       p."costPrice"::float8 AS product_cost
FROM public."Survey" s
LEFT JOIN public."Product" p ON p.code IS NOT DISTINCT FROM s."productCode"
WHERE s."productCode" IN ('P230-001231','P230-001232','P230-001233','P230-001234')
ORDER BY s."productCode", s.id;
