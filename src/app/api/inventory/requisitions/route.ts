import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { createInventoryRequisitionSchema, inventoryRequisitionQuerySchema } from '@/lib/validation/schemas';

type InventoryRequisitionItemRow = {
  id: number;
  requisition_id: number;
  inventory_item_id: number;
  requested_qty: number;
  approved_qty: number;
  issued_qty: number;
  line_status: string;
  note: string | null;
  product_code: string | null;
  product_name: string | null;
  available_qty: number;
};

const inventoryRequisitionSelect = `
  SELECT
    ir.id,
    ir.requisition_no,
    ir.request_date,
    ir.requesting_department,
    ir.status,
    ir.requested_by,
    ir.approved_by,
    ir.approved_at,
    ir.issued_by,
    ir.issued_at,
    ir.note,
    ir.created_at,
    ir.updated_at,
    COALESCE(SUM(iri.requested_qty), 0)::int AS requested_qty_total,
    COALESCE(SUM(iri.approved_qty), 0)::int AS approved_qty_total,
    COALESCE(SUM(iri.issued_qty), 0)::int AS issued_qty_total
  FROM public.inventory_requisition ir
  LEFT JOIN public.inventory_requisition_item iri ON iri.requisition_id = ir.id
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryRequisitionQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const page = queryValidation.data.page ?? 1;
    const pageSize = Math.max(1, Math.min(200, Number(searchParams.get('page_size') || queryValidation.data.pageSize || 20)));
    const cacheKey = `erp:inventory:requisitions:list:${JSON.stringify({ ...queryValidation.data, page, page_size: pageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, pageSize });
    }

    const {
      requisition_no,
      requesting_department,
      status,
      order_by,
      sort_order,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (requisition_no) {
      params.push(`%${requisition_no}%`);
      whereClauses.push(`ir.requisition_no ILIKE $${params.length}`);
    }

    if (requesting_department) {
      params.push(requesting_department);
      whereClauses.push(`ir.requesting_department = $${params.length}`);
    }

    if (status) {
      params.push(status);
      whereClauses.push(`ir.status = $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'ir.id',
      requisition_no: 'ir.requisition_no',
      request_date: 'ir.request_date',
      requesting_department: 'ir.requesting_department',
      status: 'ir.status',
    };

    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'ir.id';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const groupBySql = 'GROUP BY ir.id';
    const offset = (page - 1) * pageSize;

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.inventory_requisition ir ${whereSql}`, params),
      pgQuery(`${inventoryRequisitionSelect} ${whereSql} ${groupBySql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset]),
    ]);

    const requisitionIds = itemsResult.rows.map((row) => row.id).filter(Boolean);

    let lineItemsByRequisitionId = new Map<number, InventoryRequisitionItemRow[]>();
    if (requisitionIds.length > 0) {
      const itemParams = requisitionIds.map((_, index) => `$${index + 1}`).join(', ');
      const lineItemsResult = await pgQuery<InventoryRequisitionItemRow>(
        `SELECT
           iri.id,
           iri.requisition_id,
           iri.inventory_item_id,
           iri.requested_qty,
           iri.approved_qty,
           iri.issued_qty,
           iri.line_status,
           iri.note,
           ii.product_code,
           ii.product_name,
           COALESCE(ib.available_qty, 0)::int AS available_qty
         FROM public.inventory_requisition_item iri
         INNER JOIN public.inventory_item ii ON ii.id = iri.inventory_item_id
         LEFT JOIN public.inventory_balance ib ON ib.inventory_item_id = iri.inventory_item_id
         WHERE iri.requisition_id IN (${itemParams})
         ORDER BY iri.id ASC`,
        requisitionIds
      );

      lineItemsByRequisitionId = lineItemsResult.rows.reduce((map, row) => {
        const current = map.get(row.requisition_id) || [];
        current.push(row);
        map.set(row.requisition_id, current);
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

    const { requisition_no, request_date, requesting_department, requested_by, note, items } = validation.data;
    const resolvedRequisitionNo = requisition_no || `REQ-${Date.now()}`;
    const resolvedRequestDate = request_date || new Date().toISOString();

    await client.query('BEGIN');

    const requisitionResult = await client.query(
      `INSERT INTO public.inventory_requisition (requisition_no, request_date, requesting_department, status, requested_by, note)
       VALUES ($1, $2, $3, 'DRAFT', $4, $5)
       RETURNING id, requisition_no, request_date, requesting_department, status`,
      [resolvedRequisitionNo, resolvedRequestDate, requesting_department, requested_by || null, note || null]
    );

    const requisition = requisitionResult.rows[0];

    for (const item of items) {
      await client.query(
        `INSERT INTO public.inventory_requisition_item (requisition_id, inventory_item_id, requested_qty, approved_qty, issued_qty, line_status, note)
         VALUES ($1, $2, $3, 0, 0, 'DRAFT', $4)`,
        [requisition.id, item.inventory_item_id, item.requested_qty, item.note || null]
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
