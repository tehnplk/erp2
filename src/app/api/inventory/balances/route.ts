import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryBalanceQuerySchema } from '@/lib/validation/schemas';

const inventoryBalanceSelect = `
  SELECT
    ib.id,
    ib."inventoryItemId",
    ii."productCode",
    ii."productName",
    ii.category,
    ii."productType",
    ii."productSubtype",
    ii.unit,
    ii."warehouseId",
    iw."warehouseCode",
    iw."warehouseName",
    ii."locationId",
    ii."lotNo",
    ii."expiryDate",
    ib."onHandQty",
    ib."reservedQty",
    ib."availableQty",
    ib."avgCost"::float8 AS "avgCost",
    ib."lastMovementAt",
    ib.updated_at
  FROM public."InventoryBalance" ib
  INNER JOIN public."InventoryItem" ii ON ii.id = ib."inventoryItemId"
  INNER JOIN public."InventoryWarehouse" iw ON iw.id = ii."warehouseId"
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryBalanceQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      productName,
      productCode,
      category,
      productType,
      warehouseId,
      lowStockOnly,
      orderBy,
      sortOrder,
      page = 1,
      pageSize = 20,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (productName) {
      params.push(`%${productName}%`);
      whereClauses.push(`ii."productName" ILIKE $${params.length}`);
    }

    if (productCode) {
      params.push(`%${productCode}%`);
      whereClauses.push(`ii."productCode" ILIKE $${params.length}`);
    }

    if (category) {
      params.push(category);
      whereClauses.push(`ii.category = $${params.length}`);
    }

    if (productType) {
      params.push(productType);
      whereClauses.push(`ii."productType" = $${params.length}`);
    }

    if (warehouseId) {
      params.push(warehouseId);
      whereClauses.push(`ii."warehouseId" = $${params.length}`);
    }

    if (lowStockOnly === 'true') {
      whereClauses.push(`ib."availableQty" <= 0`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'ib.id',
      productCode: 'ii."productCode"',
      productName: 'ii."productName"',
      category: 'ii.category',
      productType: 'ii."productType"',
      onHandQty: 'ib."onHandQty"',
      availableQty: 'ib."availableQty"',
      avgCost: 'ib."avgCost"',
    };

    const safeOrderField = allowedOrderFields[orderBy || 'id'] || 'ib.id';
    const safeSortOrder = sortOrder === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const offset = (page - 1) * pageSize;

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."InventoryBalance" ib INNER JOIN public."InventoryItem" ii ON ii.id = ib."inventoryItemId" INNER JOIN public."InventoryWarehouse" iw ON iw.id = ii."warehouseId" ${whereSql}`, params),
      pgQuery(`${inventoryBalanceSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset]),
    ]);

    return apiSuccess(itemsResult.rows, undefined, countResult.rows[0]?.count || 0, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching inventory balances:', error);
    return apiError('Failed to fetch inventory balances');
  }
}
