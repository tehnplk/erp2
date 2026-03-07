UPDATE public."InventoryWarehouse"
SET "warehouseName" = 'คลังกลาง'
WHERE "warehouseCode" = 'MAIN'
  AND "warehouseName" <> 'คลังกลาง';

SELECT id, "warehouseCode", "warehouseName"
FROM public."InventoryWarehouse"
ORDER BY id;
