import { NextRequest } from 'next/server';
import { PoolClient } from 'pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { pgPool, pgQuery } from '@/lib/pg';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { createInventoryIssueSchema, inventoryIssueQuerySchema } from '@/lib/validation/schemas';

const ISSUE_PREFIX = 'ISS';

function buildIssueNo() {
  return `${ISSUE_PREFIX}-${new Date().toISOString().replace(/[-:.TZ]/g, '').slice(0, 14)}`;
}

function getCurrentBudgetYearFallback() {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
}

async function getConfiguredBudgetYear(client: PoolClient) {
  const settingResult = await client.query<{ sys_value: string | null }>(
    `
      SELECT NULLIF(TRIM(sys_value), '') AS sys_value
      FROM public.sys_setting
      WHERE sys_name = 'budget_year'
      LIMIT 1
    `
  );
  const settingValue = Number(settingResult.rows[0]?.sys_value ?? '');
  if (Number.isFinite(settingValue) && settingValue > 0) {
    return settingValue;
  }
  return getCurrentBudgetYearFallback();
}

async function validateIssueQuotaAgainstUsagePlan(
  client: PoolClient,
  params: {
    requestingDepartmentId: number;
    budgetYear: number;
    items: Array<{ stock_lot_id: number; issued_qty: number }>;
    excludeIssueId?: number;
  }
) {
  const { requestingDepartmentId, budgetYear, items, excludeIssueId } = params;
  if (items.length === 0) return;

  const departmentResult = await client.query<{ department_code: string }>(
    `SELECT department_code FROM public.department WHERE id = $1 LIMIT 1`,
    [requestingDepartmentId]
  );
  const departmentCode = departmentResult.rows[0]?.department_code;
  if (!departmentCode) {
    throw new Error('ไม่พบหน่วยงานที่ระบุ');
  }

  const lotIds = [...new Set(items.map((item) => Number(item.stock_lot_id)).filter((value) => Number.isFinite(value) && value > 0))];
  if (lotIds.length === 0) return;

  const lotRowsResult = await client.query<{ stock_lot_id: number; product_code: string }>(
    `
      SELECT isl.id AS stock_lot_id, p.code AS product_code
      FROM public.inventory_stock_lot isl
      INNER JOIN public.product p ON p.id = isl.product_id
      WHERE isl.id = ANY($1::int[])
    `,
    [lotIds]
  );
  const lotToProductCode = new Map<number, string>();
  for (const row of lotRowsResult.rows) {
    lotToProductCode.set(Number(row.stock_lot_id), row.product_code);
  }

  const requestedByProductCode = new Map<string, number>();
  for (const item of items) {
    const lotId = Number(item.stock_lot_id);
    const productCode = lotToProductCode.get(lotId);
    if (!productCode) {
      throw new Error(`ไม่พบข้อมูลล็อตสินค้า ${lotId}`);
    }
    const qty = Number(item.issued_qty);
    requestedByProductCode.set(productCode, (requestedByProductCode.get(productCode) ?? 0) + qty);
  }

  const productCodes = [...requestedByProductCode.keys()];
  if (productCodes.length === 0) return;

  const approvedQuotaResult = await client.query<{ product_code: string; approved_quota: string | number }>(
    `
      SELECT up.product_code, COALESCE(SUM(COALESCE(up.approved_quota, 0)), 0)::int AS approved_quota
      FROM public.usage_plan up
      WHERE up.requesting_dept_code = $1
        AND up.budget_year = $2
        AND up.product_code = ANY($3::text[])
      GROUP BY up.product_code
    `,
    [departmentCode, budgetYear, productCodes]
  );
  const approvedQuotaByProductCode = new Map<string, number>();
  for (const row of approvedQuotaResult.rows) {
    approvedQuotaByProductCode.set(row.product_code, Number(row.approved_quota || 0));
  }

  const issuedQtyResult = await client.query<{ product_code: string; issued_qty: string | number }>(
    `
      SELECT p.code AS product_code, COALESCE(SUM(iit.issued_qty), 0)::int AS issued_qty
      FROM public.inventory_issue_item iit
      INNER JOIN public.inventory_issue ii ON ii.id = iit.issue_id
      INNER JOIN public.inventory_stock_lot isl ON isl.id = iit.stock_lot_id
      INNER JOIN public.product p ON p.id = isl.product_id
      WHERE ii.requesting_department_id = $1
        AND p.code = ANY($2::text[])
        AND (
          CASE
            WHEN EXTRACT(MONTH FROM ii.issue_date) >= 10
              THEN EXTRACT(YEAR FROM ii.issue_date)::int + 544
            ELSE EXTRACT(YEAR FROM ii.issue_date)::int + 543
          END
        ) = $3
        AND ($4::int IS NULL OR ii.id <> $4)
      GROUP BY p.code
    `,
    [requestingDepartmentId, productCodes, budgetYear, excludeIssueId ?? null]
  );
  const issuedQtyByProductCode = new Map<string, number>();
  for (const row of issuedQtyResult.rows) {
    issuedQtyByProductCode.set(row.product_code, Number(row.issued_qty || 0));
  }

  for (const [productCode, requestedQty] of requestedByProductCode.entries()) {
    const approvedQuota = approvedQuotaByProductCode.get(productCode) ?? 0;
    const issuedQty = issuedQtyByProductCode.get(productCode) ?? 0;
    const remainingQuota = approvedQuota - issuedQty;
    if (requestedQty > remainingQuota) {
      throw new Error(
        `สินค้า ${productCode} เบิกเกินโควต้าปีงบ ${budgetYear} (โควต้า ${approvedQuota}, เบิกแล้ว ${issuedQty}, ขอเบิก ${requestedQty})`
      );
    }
  }
}

async function reduceStockLot(client: PoolClient, stockLotId: number, qty: number) {
  const lotResult = await client.query<{
    id: number;
    qty_on_hand: string | number;
    total_value: string | number;
    avg_unit_price: string | number;
  }>(
    `
      SELECT
        id,
        qty_on_hand::float8 AS qty_on_hand,
        total_value::float8 AS total_value,
        CASE
          WHEN qty_on_hand <= 0 THEN 0
          ELSE ROUND(total_value / qty_on_hand, 4)
        END::float8 AS avg_unit_price
      FROM public.inventory_stock_lot
      WHERE id = $1
      FOR UPDATE
    `,
    [stockLotId]
  );

  const lot = lotResult.rows[0];
  if (!lot) {
    throw new Error(`Stock lot not found: ${stockLotId}`);
  }

  const availableQty = Number(lot.qty_on_hand);
  if (availableQty < qty) {
    throw new Error(`ไม่สามารถเบิกเกินคงเหลือของล็อต ${stockLotId}`);
  }

  const unitPrice = Number(lot.avg_unit_price || 0);
  const lineValue = Number((qty * unitPrice).toFixed(2));

  const updateResult = await client.query(
    `
      UPDATE public.inventory_stock_lot
      SET
        qty_on_hand = qty_on_hand - $2,
        total_value = GREATEST(total_value - $3, 0),
        updated_at = now()
      WHERE id = $1
        AND qty_on_hand >= $2
      RETURNING id
    `,
    [stockLotId, qty, lineValue]
  );

  if (updateResult.rowCount === 0) {
    throw new Error(`ไม่สามารถอัปเดตล็อต ${stockLotId} ได้`);
  }

  return { unitPrice, lineValue };
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryIssueQuerySchema, searchParams);
    if (!queryValidation.success) return queryValidation.error;

    const {
      requesting_department_id,
      search,
      order_by = 'issue_date',
      sort_order = 'desc',
      page = 1,
      page_size = 20,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: Array<string | number> = [];

    if (search?.trim()) {
      params.push(`%${search.trim()}%`);
      const p = `$${params.length}`;
      whereClauses.push(`(
        ii.issue_no ILIKE ${p}
        OR COALESCE(ii.note, '') ILIKE ${p}
        OR EXISTS (
          SELECT 1
          FROM public.inventory_issue_item iit
          INNER JOIN public.inventory_stock_lot isl ON isl.id = iit.stock_lot_id
          INNER JOIN public.product p_item ON p_item.id = isl.product_id
          WHERE iit.issue_id = ii.id
            AND (p_item.code ILIKE ${p} OR p_item.name ILIKE ${p} OR isl.lot_no ILIKE ${p})
        )
      )`);
    }

    if (requesting_department_id) {
      params.push(requesting_department_id);
      whereClauses.push(`ii.requesting_department_id = $${params.length}`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const orderMap: Record<string, string> = {
      issue_no: 'ii.issue_no',
      issue_date: 'ii.issue_date',
      requesting_department: 'd.name',
      total_items: 'COUNT(iit.id)',
      total_qty: 'COALESCE(SUM(iit.issued_qty), 0)',
      total_value: 'COALESCE(SUM(iit.total_value), 0)',
      note: 'ii.note',
      created_at: 'ii.created_at',
    };
    const safeOrderBy = orderMap[order_by] || 'ii.issue_date';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const nullsClause = order_by === 'note' ? ' NULLS LAST' : '';
    const offset = (page - 1) * page_size;

    const [countResult, rowsResult] = await Promise.all([
      pgQuery<{ count: number }>(
        `
          SELECT COUNT(*)::int AS count
          FROM public.inventory_issue ii
          INNER JOIN public.department d ON d.id = ii.requesting_department_id
          ${whereSql}
        `,
        params
      ),
      pgQuery<{
        id: number;
        issue_no: string;
        issue_date: string;
        requesting_department_id: number;
        department_name: string;
        department_code: string;
        note: string | null;
        total_items: number;
        total_qty: string | number;
        total_value: string | number;
        created_at: string;
      }>(
        `
          SELECT
            ii.id,
            ii.issue_no,
            ii.issue_date::text,
            ii.requesting_department_id,
            d.name AS department_name,
            d.department_code,
            ii.note,
            COUNT(iit.id)::int AS total_items,
            COALESCE(SUM(iit.issued_qty), 0)::float8 AS total_qty,
            COALESCE(SUM(iit.total_value), 0)::float8 AS total_value,
            ii.created_at::text
          FROM public.inventory_issue ii
          INNER JOIN public.department d ON d.id = ii.requesting_department_id
          LEFT JOIN public.inventory_issue_item iit ON iit.issue_id = ii.id
          ${whereSql}
          GROUP BY ii.id, d.name, d.department_code
          ORDER BY ${safeOrderBy} ${safeSortOrder}${nullsClause}, ii.id DESC
          LIMIT $${params.length + 1} OFFSET $${params.length + 2}
        `,
        [...params, page_size, offset]
      ),
    ]);

    return apiSuccess(rowsResult.rows, undefined, countResult.rows[0]?.count ?? 0, 200, { page, page_size });
  } catch (error) {
    console.error('Error listing inventory issues:', error);
    return apiError('Failed to list inventory issues');
  }
}

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(createInventoryIssueSchema, body);
    if (!validation.success) return validation.error;

    const { issue_date, requesting_department_id, note, items } = validation.data;

    await client.query('BEGIN');
    const budgetYear = await getConfiguredBudgetYear(client);
    await validateIssueQuotaAgainstUsagePlan(client, {
      requestingDepartmentId: Number(requesting_department_id),
      budgetYear,
      items: items.map((item) => ({ stock_lot_id: Number(item.stock_lot_id), issued_qty: Number(item.issued_qty) })),
    });

    const issueInsert = await client.query<{ id: number; issue_no: string }>(
      `
        INSERT INTO public.inventory_issue (issue_no, issue_date, requesting_department_id, note)
        VALUES ($1, $2, $3, $4)
        RETURNING id, issue_no
      `,
      [buildIssueNo(), issue_date, requesting_department_id, note?.trim() || null]
    );

    const issue = issueInsert.rows[0];
    for (const item of items) {
      const qty = Number(item.issued_qty);
      const reduced = await reduceStockLot(client, Number(item.stock_lot_id), qty);

      await client.query(
        `
          INSERT INTO public.inventory_issue_item
            (issue_id, stock_lot_id, issued_qty, unit_price, total_value)
          VALUES ($1, $2, $3, $4, $5)
        `,
        [
          issue.id,
          Number(item.stock_lot_id),
          qty,
          reduced.unitPrice,
          reduced.lineValue,
        ]
      );
    }

    await client.query('COMMIT');

    return apiSuccess(
      {
        id: issue.id,
        issue_no: issue.issue_no,
      },
      'Inventory issue created successfully',
      undefined,
      201
    );
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error creating inventory issue:', error);
    return apiError(error instanceof Error ? error.message : 'Failed to create inventory issue');
  } finally {
    client.release();
  }
}
