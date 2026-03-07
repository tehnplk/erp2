import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryMovementQuerySchema } from '@/lib/validation/schemas';

const inventoryMovementSelect = `
  SELECT
    im.id,
    im."inventoryItemId",
    ii."productCode",
    ii."productName",
    im."movementDate",
    im."movementType",
    im."qtyIn",
    im."qtyOut",
    im."unitCost"::float8 AS "unitCost",
    im."totalCost"::float8 AS "totalCost",
    im."balanceQtyAfter",
    im."balanceValueAfter"::float8 AS "balanceValueAfter",
    im."referenceType",
    im."referenceId",
    im."referenceNo",
    im."sourceDepartment",
    im."targetDepartment",
    im.note,
    im."createdBy",
    im.created_at
  FROM public."InventoryMovement" im
  INNER JOIN public."InventoryItem" ii ON ii.id = im."inventoryItemId"
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryMovementQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      inventoryItemId,
      productCode,
      movementType,
      referenceType,
      dateFrom,
      dateTo,
      orderBy,
      sortOrder,
      page = 1,
      pageSize = 20,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (inventoryItemId) {
      params.push(inventoryItemId);
      whereClauses.push(`im."inventoryItemId" = $${params.length}`);
    }

    if (productCode) {
      params.push(`%${productCode}%`);
      whereClauses.push(`ii."productCode" ILIKE $${params.length}`);
    }

    if (movementType) {
      params.push(movementType);
      whereClauses.push(`im."movementType" = $${params.length}`);
    }

    if (referenceType) {
      params.push(referenceType);
      whereClauses.push(`im."referenceType" = $${params.length}`);
    }

    if (dateFrom) {
      params.push(dateFrom);
      whereClauses.push(`im."movementDate" >= $${params.length}`);
    }

    if (dateTo) {
      params.push(dateTo);
      whereClauses.push(`im."movementDate" <= $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'im.id',
      movementDate: 'im."movementDate"',
      movementType: 'im."movementType"',
      productCode: 'ii."productCode"',
      productName: 'ii."productName"',
      qtyIn: 'im."qtyIn"',
      qtyOut: 'im."qtyOut"',
    };

    const safeOrderField = allowedOrderFields[orderBy || 'movementDate'] || 'im."movementDate"';
    const safeSortOrder = sortOrder === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const offset = (page - 1) * pageSize;

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."InventoryMovement" im INNER JOIN public."InventoryItem" ii ON ii.id = im."inventoryItemId" ${whereSql}`, params),
      pgQuery(`${inventoryMovementSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset]),
    ]);

    return apiSuccess(itemsResult.rows, undefined, countResult.rows[0]?.count || 0, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching inventory movements:', error);
    return apiError('Failed to fetch inventory movements');
  }
}
