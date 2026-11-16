import { normalizePurchasePlanFlag } from './purchase-plan.ts';

export type PurchaseApprovalQuery = (
  text: string,
  params?: unknown[]
) => Promise<{ rows: any[]; rowCount?: number | null }>;

export type ApprovalDocStatusRow = {
  code: string;
  status: string;
};

export const APPROVAL_STATUS = {
  DRAFT: 'DRAFT',
  PENDING: 'PENDING',
  APPROVED: 'APPROVED',
} as const;

export class PurchaseApprovalError extends Error {
  status: number;

  constructor(message: string, status = 500) {
    super(message);
    this.name = 'PurchaseApprovalError';
    this.status = status;
  }
}

export const findApprovalDocStatus = (statuses: ApprovalDocStatusRow[], value?: string | null) => {
  if (!value) {
    return null;
  }
  return statuses.find((item) => item.status === value) ?? statuses.find((item) => item.code === value) ?? null;
};

export type ApprovalStatusFields = {
  status: string;
  approved_by?: string;
  approved_at?: Date;
  pending_note?: unknown;
};

export const approvalStatusFields = (
  statuses: ApprovalDocStatusRow[],
  requested: string | null | undefined,
  options: { currentCode: string | null; actor: string | null; now: Date; pendingNote?: unknown }
): ApprovalStatusFields | null => {
  const target = findApprovalDocStatus(statuses, requested);
  if (!target) {
    return null;
  }

  const fields: ApprovalStatusFields = { status: target.code };
  if (target.status === APPROVAL_STATUS.APPROVED && options.currentCode !== target.code) {
    fields.approved_at = options.now;
    if (options.actor) {
      fields.approved_by = options.actor;
    }
  }
  if (target.status === APPROVAL_STATUS.PENDING && options.pendingNote !== undefined) {
    fields.pending_note = options.pendingNote;
  }
  return fields;
};

export const sessionActor = (user?: { name?: string | null; providerId?: string } | null) =>
  user?.name?.trim() || user?.providerId?.trim() || null;

// The purchase-plans page sends created_by: 'system', which is a placeholder, not a person.
const suppliedActor = (value?: string | null) => {
  const trimmed = value?.trim();
  return trimmed && trimmed.toUpperCase() !== 'SYSTEM' ? value : null;
};

export const remainingQuota = (
  quota: number | null | undefined,
  inventoryQty: number | null | undefined,
  purchasedQty: number | null | undefined
) => Math.max(Number(quota ?? 0) - Number(inventoryQty ?? 0) - Number(purchasedQty ?? 0), 0);

export const exceedsQuota = (
  quota: number | null | undefined,
  inventoryQty: number | null | undefined,
  purchasedQty: number | null | undefined,
  requestedQty: number
) => requestedQty > remainingQuota(quota, inventoryQty, purchasedQty);

export const localDateString = (now: Date) => {
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

export type ApprovalHeaderInput = {
  approve_code?: string;
  doc_no?: string;
  status?: string;
  prepared_by?: string;
  approved_by?: string;
  approved_at?: string;
  notes?: string;
  created_by?: string;
  updated_by?: string;
};

export type ApprovalLineInput = {
  product_code?: string;
  product_name?: string;
  requesting_dept_text?: string;
  purchase_department_name?: string;
  usage_plan_flag?: string;
  budget_year?: number;
  line_number?: number;
  status?: string;
  proposed_quantity?: number;
  proposed_amount?: number;
  approved_quantity?: number;
  approved_amount?: number;
  remarks?: string;
  created_by?: string;
  updated_by?: string;
};

export type CreateApprovalDocumentInput = {
  header: ApprovalHeaderInput;
  details: ApprovalLineInput[];
  docDate: string;
  budgetYear: number;
  statuses: ApprovalDocStatusRow[];
  actor: string | null;
  now: Date;
};

type ProductMeta = {
  code: string;
  name: string | null;
  category: string | null;
  purchase_department_id: number | null;
  purchase_department_name: string | null;
};

const DEFAULT_DOC_NO = 'พล. 0733.301/พิเศษ';
const DOC_SEQ_LOCK_KEY = 'public.purchase_approval.doc_seq';

const lineQuantity = (line: ApprovalLineInput) => Number(line.proposed_quantity ?? line.approved_quantity ?? 0);
const lineAmount = (line: ApprovalLineInput) => Number(line.proposed_amount ?? line.approved_amount ?? 0);
const lineBudgetYear = (line: ApprovalLineInput, budgetYear: number) => Number(line.budget_year || budgetYear);

const loadLineProducts = async (query: PurchaseApprovalQuery, details: ApprovalLineInput[]) => {
  const codes = Array.from(
    new Set(details.map((detail) => detail.product_code?.trim()).filter((code): code is string => Boolean(code)))
  );
  if (codes.length === 0) {
    throw new PurchaseApprovalError('ไม่พบรหัสสินค้าสำหรับสร้างเอกสารอนุมัติ');
  }

  const productResult = await query(
    `SELECT
       p.code,
       p.name,
       p.category,
       p.type,
       p.subtype,
       p.purchase_department_id,
       COALESCE(pd.name, pd.department_code) AS purchase_department_name
     FROM public.product p
     LEFT JOIN public.department pd ON pd.id = p.purchase_department_id
     WHERE p.code = ANY($1::text[])`,
    [codes]
  );
  const products = productResult.rows as ProductMeta[];
  if (products.length !== codes.length) {
    throw new PurchaseApprovalError('พบบางรายการรหัสสินค้าไม่ถูกต้องสำหรับสร้างเอกสารอนุมัติ');
  }

  const categories = Array.from(
    new Set(products.map((row) => row.category).filter((category): category is string => Boolean(category)))
  );
  if (categories.length !== 1) {
    throw new PurchaseApprovalError('การสร้างเอกสารอนุมัติจัดซื้อสามารถเลือกรายการสินค้าได้เฉพาะหมวดเดียวกันเท่านั้น');
  }

  const purchaseDepartmentIds = new Set(
    products.map((row) => Number(row.purchase_department_id)).filter((id) => Number.isFinite(id) && id > 0)
  );
  if (purchaseDepartmentIds.size !== 1) {
    throw new PurchaseApprovalError('การสร้างเอกสารอนุมัติจัดซื้อกำหนดได้เฉพาะหน่วยงานจัดซื้อเดียวกันเท่านั้น');
  }

  const categoryCodeResult = await query(
    `SELECT MIN(category_code) AS category_code
     FROM public.category
     WHERE is_active = true
       AND category = $1`,
    [categories[0]]
  );
  const categoryCode: string | null = categoryCodeResult.rows[0]?.category_code ?? null;
  if (!categoryCode) {
    throw new PurchaseApprovalError('ไม่พบรหัสหมวดสำหรับการสร้างรหัสเอกสาร');
  }

  return { products, categoryCode };
};

// Mirrors the purchase-plans page: a line may not exceed approved_quota - inventory_qty - purchased_qty
// of its purchase_plan row, keyed by (product_code, budget_year, normalised flag).
const assertWithinQuota = async (query: PurchaseApprovalQuery, details: ApprovalLineInput[], budgetYear: number) => {
  const requested = new Map<string, { code: string; budgetYear: number; flag: string; qty: number }>();
  for (const detail of details) {
    const code = detail.product_code?.trim();
    if (!code) continue;
    const line = { code, budgetYear: lineBudgetYear(detail, budgetYear), flag: normalizePurchasePlanFlag(detail.usage_plan_flag) };
    const key = `${line.code}|${line.budgetYear}|${line.flag}`;
    const qty = (requested.get(key)?.qty ?? 0) + lineQuantity(detail);
    requested.set(key, { ...line, qty });
  }

  const planResult = await query(
    `SELECT product_code, budget_year, usage_plan_flag, approved_quota, inventory_qty, purchased_qty
     FROM public.purchase_plan
     WHERE product_code = ANY($1::text[])`,
    [Array.from(new Set(Array.from(requested.values(), (line) => line.code)))]
  );

  for (const line of requested.values()) {
    const plan = planResult.rows.find(
      (row) => row.product_code === line.code && Number(row.budget_year) === line.budgetYear && row.usage_plan_flag === line.flag
    );
    if (exceedsQuota(plan?.approved_quota, plan?.inventory_qty, plan?.purchased_qty, line.qty)) {
      const remaining = remainingQuota(plan?.approved_quota, plan?.inventory_qty, plan?.purchased_qty);
      throw new PurchaseApprovalError(
        `จำนวนซื้อสินค้า ${line.code} เกินโควต้าที่เหลือ (${line.qty.toLocaleString('en-US')} > ${remaining.toLocaleString('en-US')})`,
        409
      );
    }
  }
};

export async function createApprovalDocument(query: PurchaseApprovalQuery, input: CreateApprovalDocumentInput) {
  const { header, details, docDate, budgetYear, statuses, actor, now } = input;

  const statusFields = approvalStatusFields(statuses, header.status || APPROVAL_STATUS.DRAFT, {
    currentCode: null,
    actor,
    now,
  });
  if (!statusFields) {
    throw new PurchaseApprovalError('Invalid approval status');
  }

  const lineProducts = details.length > 0 ? await loadLineProducts(query, details) : null;

  await query('SELECT pg_advisory_xact_lock(hashtext($1))', [DOC_SEQ_LOCK_KEY]);
  if (details.length > 0) {
    await assertWithinQuota(query, details, budgetYear);
  }

  const docSeqResult = await query(
    `SELECT COALESCE(MAX(doc_seq), 0) + 1 AS next_doc_seq FROM public.purchase_approval`
  );
  const docSeq: number = docSeqResult.rows[0]?.next_doc_seq || 1;
  const approveCode =
    header.approve_code ||
    (lineProducts ? `${lineProducts.categoryCode}-${budgetYear || '0000'}-${String(docSeq).padStart(4, '0')}` : null);
  const docNo = header.doc_no || DEFAULT_DOC_NO;

  const createdBy = suppliedActor(header.created_by) ?? actor ?? (header.created_by || 'SYSTEM');
  const headerResult = await query(
    `INSERT INTO public.purchase_approval
     (doc_seq, approve_code, doc_no, doc_date, budget_year, status, prepared_by, approved_by, approved_at, notes, total_amount, total_items, created_by, updated_by, version)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, 0, 0, $11, $12, 1)
     RETURNING id, doc_seq, approve_code, doc_no, doc_date, budget_year, status AS status_code, total_amount, total_items,
              prepared_by, approved_by, approved_at, notes, created_at, updated_at, version`,
    [
      docSeq,
      approveCode,
      docNo,
      docDate,
      budgetYear,
      statusFields.status,
      suppliedActor(header.prepared_by) ?? createdBy,
      header.approved_by || statusFields.approved_by || null,
      header.approved_at || statusFields.approved_at || null,
      header.notes || null,
      createdBy,
      suppliedActor(header.updated_by) ?? createdBy,
    ]
  );
  const createdHeader = headerResult.rows[0];
  createdHeader.status = findApprovalDocStatus(statuses, createdHeader.status_code)?.status ?? null;
  const purchaseApprovalId = createdHeader.id;

  const createdDetails: any[] = [];
  for (let i = 0; i < details.length; i++) {
    const detail = details[i];
    const productMeta = lineProducts?.products.find((row) => row.code === detail.product_code?.trim());
    if (!productMeta) {
      throw new Error(`ไม่พบข้อมูลสินค้าสำหรับรหัส ${detail.product_code}`);
    }

    const quantity = lineQuantity(detail);
    const amount = lineAmount(detail);
    const detailCreatedBy = suppliedActor(detail.created_by) ?? createdBy;
    const detailResult = await query(
      `INSERT INTO public.purchase_approval_detail
       (purchase_approval_id, product_code, product_name, requesting_dept_text, purchase_department_id,
        purchase_department_name, usage_plan_flag, budget_year, line_number, status, proposed_quantity, proposed_amount,
        approved_quantity, approved_amount, cal_unit_price, remarks, created_by, updated_by, version)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, 1)
       RETURNING id, purchase_approval_id, product_code, product_name, requesting_dept_text,
                purchase_department_id, purchase_department_name, usage_plan_flag, budget_year, line_number, status,
                proposed_quantity, proposed_amount, approved_quantity, approved_amount, cal_unit_price, remarks, created_at, updated_at, version`,
      [
        purchaseApprovalId,
        productMeta.code,
        detail.product_name || productMeta.name || null,
        detail.requesting_dept_text || null,
        productMeta.purchase_department_id,
        detail.purchase_department_name || productMeta.purchase_department_name || null,
        detail.usage_plan_flag || 'ในแผน',
        lineBudgetYear(detail, budgetYear),
        detail.line_number || i + 1,
        detail.status || 'PENDING',
        quantity,
        amount,
        Number(detail.approved_quantity || 0),
        Number(detail.approved_amount || 0),
        quantity > 0 ? Number((amount / quantity).toFixed(2)) : 0,
        detail.remarks || null,
        detailCreatedBy,
        suppliedActor(detail.updated_by) ?? detailCreatedBy,
      ]
    );

    const createdDetail = detailResult.rows[0];
    if (createdDetail) {
      createdDetails.push(createdDetail);
      await query(
        `INSERT INTO public.purchase_approval_inventory_link
         (purchase_approval_id, purchase_approval_detail_id, inventory_receipt_status, received_qty)
         VALUES ($1, $2, 'PENDING', 0)`,
        [purchaseApprovalId, createdDetail.id]
      );
    }
  }

  await query(
    `UPDATE public.purchase_approval
     SET total_items = (
       SELECT COUNT(*)
       FROM public.purchase_approval_detail
       WHERE purchase_approval_id = $1
     ),
     total_amount = (
       SELECT COALESCE(SUM(COALESCE(pad.proposed_amount, pad.approved_amount, 0)), 0)
       FROM public.purchase_approval_detail pad
       WHERE pad.purchase_approval_id = $1
     )
     WHERE id = $1`,
    [purchaseApprovalId]
  );

  return { header: createdHeader, details: createdDetails, docSeq, approveCode, docNo };
}
