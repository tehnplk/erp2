import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { purchaseApprovalQuerySchema, createPurchaseApprovalSchema } from '@/lib/validation/schemas';

const purchaseApprovalSelect = `SELECT id, "approvalId", department, "budgetYear", "recordNumber", "requestDate", "productName", "productCode", category, "productType", "productSubtype", "requestedQuantity", unit, "pricePerUnit"::float8 AS "pricePerUnit", "totalValue"::float8 AS "totalValue", "overPlanCase", requester, approver, created_at, updated_at FROM public."PurchaseApproval"`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    
    // Validate query parameters
    const queryValidation = validateQuery(purchaseApprovalQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }
    
    const {
      orderBy,
      sortOrder,
      productName,
      category,
      productType,
      productSubtype,
      department,
      budgetYear,
      page,
      pageSize
    } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (productName) {
      params.push(`%${productName}%`);
      whereClauses.push(`"productName" ILIKE $${params.length}`);
    }
    if (category) {
      params.push(category);
      whereClauses.push(`category = $${params.length}`);
    }
    if (productType) {
      params.push(productType);
      whereClauses.push(`"productType" = $${params.length}`);
    }
    if (productSubtype) {
      params.push(productSubtype);
      whereClauses.push(`"productSubtype" = $${params.length}`);
    }
    if (department) {
      params.push(department);
      whereClauses.push(`department = $${params.length}`);
    }
    if (budgetYear) {
      params.push(Number(budgetYear));
      whereClauses.push(`"budgetYear" = $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      department: 'department',
      budgetYear: '"budgetYear"',
      recordNumber: '"recordNumber"',
      requestDate: '"requestDate"',
      productName: '"productName"',
      productCode: '"productCode"',
      category: 'category',
      productType: '"productType"',
      productSubtype: '"productSubtype"',
      requester: 'requester',
      approver: 'approver',
    };
    const safeOrderField = allowedOrderFields[orderBy || 'id'] || 'id';
    const safeSortOrder = sortOrder === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';

    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('pageSize');

    if (!pageParam && !pageSizeParam) {
      const [totalCount, items] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count FROM public."PurchaseApproval" ${whereSql}`, params),
        pgQuery(`${purchaseApprovalSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params)
      ]);

      return apiSuccess(items.rows, undefined, totalCount.rows[0]?.count || 0, 200);
    }

    const currentPage = page && typeof page === 'number' ? page : 1;
    const currentPageSize = pageSize && typeof pageSize === 'number' ? pageSize : 20;
    const skip = (currentPage - 1) * currentPageSize;

    const [totalCount, items] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."PurchaseApproval" ${whereSql}`, params),
      pgQuery(`${purchaseApprovalSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, currentPageSize, skip])
    ]);

    return apiSuccess(items.rows, undefined, totalCount.rows[0]?.count || 0, 200, { page: currentPage, pageSize: currentPageSize });
  } catch (error) {
    console.error('Error fetching purchase approvals:', error);
    return apiError('Failed to fetch purchase approvals');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createPurchaseApprovalSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const item = await pgQuery(
      `INSERT INTO public."PurchaseApproval" ("approvalId", department, "budgetYear", "recordNumber", "requestDate", "productName", "productCode", category, "productType", "productSubtype", "requestedQuantity", unit, "pricePerUnit", "totalValue", "overPlanCase", requester, approver)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
       RETURNING id, "approvalId", department, "budgetYear", "recordNumber", "requestDate", "productName", "productCode", category, "productType", "productSubtype", "requestedQuantity", unit, "pricePerUnit"::float8 AS "pricePerUnit", "totalValue"::float8 AS "totalValue", "overPlanCase", requester, approver, created_at, updated_at`,
      [
        validation.data.approvalId || null,
        validation.data.department || null,
        validation.data.budgetYear ?? null,
        validation.data.recordNumber || null,
        validation.data.requestDate || null,
        validation.data.productName || null,
        validation.data.productCode || null,
        validation.data.category || null,
        validation.data.productType || null,
        validation.data.productSubtype || null,
        validation.data.requestedQuantity ?? null,
        validation.data.unit || null,
        validation.data.pricePerUnit ?? 0,
        validation.data.totalValue ?? 0,
        validation.data.overPlanCase || null,
        validation.data.requester || null,
        validation.data.approver || null,
      ]
    );
    
    return apiSuccess(item.rows[0], 'Purchase approval created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating purchase approval:', error);
    return apiError('Failed to create purchase approval');
  }
}
