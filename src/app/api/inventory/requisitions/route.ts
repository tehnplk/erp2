import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { createInventoryRequisitionSchema, inventoryRequisitionQuerySchema } from '@/lib/validation/schemas';

type InventoryRequisitionItemRow = {
  id: number;
  requisitionId: number;
  inventoryItemId: number;
  requestedQty: number;
  approvedQty: number;
  issuedQty: number;
  lineStatus: string;
  note: string | null;
  productCode: string | null;
  productName: string | null;
  availableQty: number;
};

const inventoryRequisitionSelect = `
  SELECT
    ir.id,
    ir."requisitionNo",
    ir."requestDate",
    ir."requestingDepartment",
    ir.status,
    ir."requestedBy",
    ir."approvedBy",
    ir."approvedAt",
    ir."issuedBy",
    ir."issuedAt",
    ir.note,
    ir.created_at,
    ir.updated_at,
    COALESCE(SUM(iri."requestedQty"), 0)::int AS "requestedQtyTotal",
    COALESCE(SUM(iri."approvedQty"), 0)::int AS "approvedQtyTotal",
    COALESCE(SUM(iri."issuedQty"), 0)::int AS "issuedQtyTotal"
  FROM public."InventoryRequisition" ir
  LEFT JOIN public."InventoryRequisitionItem" iri ON iri."requisitionId" = ir.id
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryRequisitionQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { page = 1, pageSize = 20 } = queryValidation.data;
    const cacheKey = `erp:inventory:requisitions:list:${JSON.stringify({ ...queryValidation.data, page, pageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, pageSize });
    }

    const {
      requisitionNo,
      requestingDepartment,
      status,
      orderBy,
      sortOrder,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (requisitionNo) {
      params.push(`%${requisitionNo}%`);
      whereClauses.push(`ir."requisitionNo" ILIKE $${params.length}`);
    }

    if (requestingDepartment) {
      params.push(requestingDepartment);
      whereClauses.push(`ir."requestingDepartment" = $${params.length}`);
    }

    if (status) {
      params.push(status);
      whereClauses.push(`ir.status = $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'ir.id',
      requisitionNo: 'ir."requisitionNo"',
      requestDate: 'ir."requestDate"',
      requestingDepartment: 'ir."requestingDepartment"',
      status: 'ir.status',
    };

    const safeOrderField = allowedOrderFields[orderBy || 'id'] || 'ir.id';
    const safeSortOrder = sortOrder === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const groupBySql = 'GROUP BY ir.id';
    const offset = (page - 1) * pageSize;

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."InventoryRequisition" ir ${whereSql}`, params),
      pgQuery(`${inventoryRequisitionSelect} ${whereSql} ${groupBySql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset]),
    ]);

    const requisitionIds = itemsResult.rows.map((row) => row.id).filter(Boolean);

    let lineItemsByRequisitionId = new Map<number, InventoryRequisitionItemRow[]>();
    if (requisitionIds.length > 0) {
      const itemParams = requisitionIds.map((_, index) => `$${index + 1}`).join(', ');
      const lineItemsResult = await pgQuery<InventoryRequisitionItemRow>(
        `SELECT
           iri.id,
           iri."requisitionId" AS "requisitionId",
           iri."inventoryItemId" AS "inventoryItemId",
           iri."requestedQty" AS "requestedQty",
           iri."approvedQty" AS "approvedQty",
           iri."issuedQty" AS "issuedQty",
           iri."lineStatus" AS "lineStatus",
           iri.note,
           ii."productCode" AS "productCode",
           ii."productName" AS "productName",
           COALESCE(ib."availableQty", 0)::int AS "availableQty"
         FROM public."InventoryRequisitionItem" iri
         INNER JOIN public."InventoryItem" ii ON ii.id = iri."inventoryItemId"
         LEFT JOIN public."InventoryBalance" ib ON ib."inventoryItemId" = iri."inventoryItemId"
         WHERE iri."requisitionId" IN (${itemParams})
         ORDER BY iri.id ASC`,
        requisitionIds
      );

      lineItemsByRequisitionId = lineItemsResult.rows.reduce((map, row) => {
        const current = map.get(row.requisitionId) || [];
        current.push(row);
        map.set(row.requisitionId, current);
        return map;
      }, new Map<number, InventoryRequisitionItemRow[]>());
    }

    const rowsWithItems = itemsResult.rows.map((row) => ({
      ...row,
      items: lineItemsByRequisitionId.get(row.id) || [],
    }));

    const finalResult = {
      items: rowsWithItems,
      totalCount: countResult.rows[0]?.count || 0
    };

    // Cache the result for 5 minutes
    await cacheSet(cacheKey, finalResult, 300);

    return apiSuccess(finalResult.items, undefined, finalResult.totalCount, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching inventory requisitions:', error);
    return apiError('Failed to fetch inventory requisitions');
  }
}

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(createInventoryRequisitionSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const { requisitionNo, requestDate, requestingDepartment, requestedBy, note, items } = validation.data;
    const resolvedRequisitionNo = requisitionNo || `REQ-${Date.now()}`;
    const resolvedRequestDate = requestDate || new Date().toISOString();

    await client.query('BEGIN');

    const requisitionResult = await client.query(
      `INSERT INTO public."InventoryRequisition" ("requisitionNo", "requestDate", "requestingDepartment", status, "requestedBy", note)
       VALUES ($1, $2, $3, 'DRAFT', $4, $5)
       RETURNING id, "requisitionNo", "requestDate", "requestingDepartment", status`,
      [resolvedRequisitionNo, resolvedRequestDate, requestingDepartment, requestedBy || null, note || null]
    );

    const requisition = requisitionResult.rows[0];

    for (const item of items) {
      await client.query(
        `INSERT INTO public."InventoryRequisitionItem" ("requisitionId", "inventoryItemId", "requestedQty", "approvedQty", "issuedQty", "lineStatus", note)
         VALUES ($1, $2, $3, 0, 0, 'DRAFT', $4)`,
        [requisition.id, item.inventoryItemId, item.requestedQty, item.note || null]
      );
    }

    await client.query('COMMIT');

    await cacheDelByPattern('erp:inventory:requisitions:list:*');

    return apiSuccess(requisition, 'Inventory requisition created successfully', undefined, 201);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error creating inventory requisition:', error);
    return apiError('Failed to create inventory requisition');
  } finally {
    client.release();
  }
}
