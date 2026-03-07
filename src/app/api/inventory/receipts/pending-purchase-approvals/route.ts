import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryPendingPurchaseApprovalQuerySchema } from '@/lib/validation/schemas';

const pendingPurchaseApprovalSelect = `
  SELECT
    pa.id,
    pa."approvalId",
    pa.department,
    pa."budgetYear",
    pa."recordNumber",
    pa."requestDate",
    pa."productCode",
    pa."productName",
    pa.category,
    pa."productType",
    pa."productSubtype",
    pa."requestedQuantity",
    pa.unit,
    pa."pricePerUnit"::float8 AS "pricePerUnit",
    pa."totalValue"::float8 AS "totalValue",
    link."inventoryReceiptStatus",
    link."receivedQty",
    GREATEST(COALESCE(pa."requestedQuantity", 0) - COALESCE(link."receivedQty", 0), 0) AS "remainingQty"
  FROM public."PurchaseApproval" pa
  INNER JOIN public."PurchaseApprovalInventoryLink" link ON link."purchaseApprovalId" = pa.id
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryPendingPurchaseApprovalQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      productName,
      department,
      budgetYear,
      status,
      orderBy,
      sortOrder,
      page = 1,
      pageSize = 20,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (productName) {
      params.push(`%${productName}%`);
      whereClauses.push(`pa."productName" ILIKE $${params.length}`);
    }

    if (department) {
      params.push(department);
      whereClauses.push(`pa.department = $${params.length}`);
    }

    if (budgetYear) {
      params.push(Number(budgetYear));
      whereClauses.push(`pa."budgetYear" = $${params.length}`);
    }

    if (status) {
      params.push(status);
      whereClauses.push(`link."inventoryReceiptStatus" = $${params.length}`);
    } else {
      whereClauses.push(`link."inventoryReceiptStatus" IN ('PENDING', 'PARTIAL')`);
    }

    whereClauses.push(`GREATEST(COALESCE(pa."requestedQuantity", 0) - COALESCE(link."receivedQty", 0), 0) > 0`);

    const allowedOrderFields: Record<string, string> = {
      id: 'pa.id',
      productCode: 'pa."productCode"',
      productName: 'pa."productName"',
      department: 'pa.department',
      budgetYear: 'pa."budgetYear"',
      requestedQuantity: 'pa."requestedQuantity"',
      receivedQty: 'link."receivedQty"',
    };

    const safeOrderField = allowedOrderFields[orderBy || 'id'] || 'pa.id';
    const safeSortOrder = sortOrder === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const offset = (page - 1) * pageSize;

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."PurchaseApproval" pa INNER JOIN public."PurchaseApprovalInventoryLink" link ON link."purchaseApprovalId" = pa.id ${whereSql}`, params),
      pgQuery(`${pendingPurchaseApprovalSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset]),
    ]);

    return apiSuccess(itemsResult.rows, undefined, countResult.rows[0]?.count || 0, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching pending purchase approvals for inventory receipt:', error);
    return apiError('Failed to fetch pending purchase approvals');
  }
}
