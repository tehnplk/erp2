import { budgetYearOfDateString, budgetYearSql } from './budget-year.ts';
import { usagePlanQuotaSql } from './purchase-plan.ts';

export type InventoryQuery = (
  text: string,
  params?: unknown[]
) => Promise<{ rows: any[]; rowCount?: number | null }>;

export type IssueLineInput = { stock_lot_id: number; issued_qty: number };

export class InventoryIssueRuleError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'InventoryIssueRuleError';
  }
}

export function quotaUsageColumnsSql(refs: {
  departmentId: string;
  productCode: string;
  productId: string;
  budgetYear: string;
}) {
  return `
    COALESCE((
      SELECT SUM(${usagePlanQuotaSql('up')})::int
      FROM public.department d_quota
      INNER JOIN public.usage_plan up
        ON up.requesting_dept_code = d_quota.department_code
      WHERE d_quota.id = ${refs.departmentId}
        AND up.product_code = ${refs.productCode}
        AND up.budget_year = ${refs.budgetYear}
    ), 0)::int AS current_budget_quota,
    COALESCE((
      SELECT SUM(iit_quota.issued_qty)::int
      FROM public.inventory_issue_item iit_quota
      INNER JOIN public.inventory_issue ii_quota ON ii_quota.id = iit_quota.issue_id
      INNER JOIN public.inventory_stock_lot isl_quota ON isl_quota.id = iit_quota.stock_lot_id
      WHERE ii_quota.requesting_department_id = ${refs.departmentId}
        AND isl_quota.product_id = ${refs.productId}
        AND ${budgetYearSql('ii_quota.issue_date')} = ${refs.budgetYear}
    ), 0)::int AS issued_qty_current_budget_year`;
}

export function buildIssueNo(now: Date, id: number) {
  return `ISS-${now.toISOString().replace(/[-:.TZ]/g, '').slice(0, 14)}-${id}`;
}

export async function insertIssueHeader(
  query: InventoryQuery,
  header: { issueDate: string; requestingDepartmentId: number; note: string | null },
  now: Date = new Date()
) {
  const nextIdResult = await query(
    `SELECT nextval(pg_get_serial_sequence('public.inventory_issue', 'id'))::int AS id`
  );
  const id: number = nextIdResult.rows[0].id;
  const issueNo = buildIssueNo(now, id);
  await query(
    `
      INSERT INTO public.inventory_issue (id, issue_no, issue_date, requesting_department_id, note)
      OVERRIDING SYSTEM VALUE
      VALUES ($1, $2, $3, $4, $5)
    `,
    [id, issueNo, header.issueDate, header.requestingDepartmentId, header.note]
  );
  return { id, issue_no: issueNo };
}

export async function validateIssueQuota(
  query: InventoryQuery,
  params: {
    requestingDepartmentId: number;
    issueDate: string;
    items: IssueLineInput[];
    excludeIssueId?: number;
  }
) {
  const { requestingDepartmentId, issueDate, items, excludeIssueId } = params;
  let budgetYear: number;
  try {
    budgetYear = budgetYearOfDateString(issueDate);
  } catch {
    throw new InventoryIssueRuleError(`วันที่เบิกไม่ถูกต้อง: ${issueDate}`);
  }
  if (items.length === 0) return;

  const departmentResult = await query(
    `SELECT department_code FROM public.department WHERE id = $1 LIMIT 1`,
    [requestingDepartmentId]
  );
  const departmentCode: string | undefined = departmentResult.rows[0]?.department_code;
  if (!departmentCode) {
    throw new InventoryIssueRuleError('ไม่พบหน่วยงานที่ระบุ');
  }

  const lotIds = [...new Set(items.map((item) => Number(item.stock_lot_id)).filter((value) => Number.isFinite(value) && value > 0))];
  if (lotIds.length === 0) return;

  const lotRowsResult = await query(
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
      throw new InventoryIssueRuleError(`ไม่พบข้อมูลล็อตสินค้า ${lotId}`);
    }
    requestedByProductCode.set(productCode, (requestedByProductCode.get(productCode) ?? 0) + Number(item.issued_qty));
  }

  const productCodes = [...requestedByProductCode.keys()];

  const approvedQuotaResult = await query(
    `
      SELECT up.product_code, COALESCE(SUM(${usagePlanQuotaSql('up')}), 0)::int AS approved_quota
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

  const issuedQtyResult = await query(
    `
      SELECT p.code AS product_code, COALESCE(SUM(iit.issued_qty), 0)::int AS issued_qty
      FROM public.inventory_issue_item iit
      INNER JOIN public.inventory_issue ii ON ii.id = iit.issue_id
      INNER JOIN public.inventory_stock_lot isl ON isl.id = iit.stock_lot_id
      INNER JOIN public.product p ON p.id = isl.product_id
      WHERE ii.requesting_department_id = $1
        AND p.code = ANY($2::text[])
        AND ${budgetYearSql('ii.issue_date')} = $3
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
    if (requestedQty > approvedQuota - issuedQty) {
      throw new InventoryIssueRuleError(
        `สินค้า ${productCode} เบิกเกินโควต้าปีงบ ${budgetYear} (โควต้า ${approvedQuota}, เบิกแล้ว ${issuedQty}, ขอเบิก ${requestedQty})`
      );
    }
  }
}

export async function reduceStockLot(query: InventoryQuery, stockLotId: number, qty: number) {
  const lotResult = await query(
    `
      SELECT
        id,
        qty_on_hand::float8 AS qty_on_hand,
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
    throw new InventoryIssueRuleError(`Stock lot not found: ${stockLotId}`);
  }
  if (Number(lot.qty_on_hand) < qty) {
    throw new InventoryIssueRuleError(`ไม่สามารถเบิกเกินคงเหลือของล็อต ${stockLotId}`);
  }

  const unitPrice = Number(lot.avg_unit_price || 0);
  const lineValue = Number((qty * unitPrice).toFixed(2));

  const updateResult = await query(
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

export async function restoreStockLot(query: InventoryQuery, stockLotId: number, qty: number, totalValue: number) {
  const lotResult = await query(
    `SELECT id FROM public.inventory_stock_lot WHERE id = $1 FOR UPDATE`,
    [stockLotId]
  );
  if (!lotResult.rows[0]) {
    throw new InventoryIssueRuleError(`Stock lot not found: ${stockLotId}`);
  }

  await query(
    `
      UPDATE public.inventory_stock_lot
      SET
        qty_on_hand = qty_on_hand + $2,
        total_value = total_value + $3,
        updated_at = now()
      WHERE id = $1
    `,
    [stockLotId, qty, totalValue]
  );
}
