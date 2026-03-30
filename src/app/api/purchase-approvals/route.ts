import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { purchaseApprovalQuerySchema, createPurchaseApprovalSchema } from '@/lib/validation/schemas';
import { get_approval_doc_status_code, get_approval_doc_status_value } from '@/lib/approval-doc-status';

const DEFAULT_DOC_NO = 'พล. 0733.301/พิเศษ';

const getCurrentDateString = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const getBudgetYearFromDate = (dateValue: string) => {
  const parsedDate = new Date(`${dateValue}T00:00:00`);
  if (Number.isNaN(parsedDate.getTime())) {
    throw new Error('Invalid doc_date');
  }

  const year = parsedDate.getFullYear();
  const month = parsedDate.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(purchaseApprovalQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      order_by,
      sort_order,
      product_name,
      category,
      product_type,
      product_subtype,
      department,
      purchase_department,
      budget_year,
      page,
      page_size: pageSize,
    } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (product_name) {
      params.push(`%${product_name}%`);
      whereClauses.push(`
        EXISTS (
          SELECT 1
          FROM public.purchase_approval_detail pad_filter
          LEFT JOIN public.product p_filter ON p_filter.code = pad_filter.product_code
          WHERE pad_filter.purchase_approval_id = pa.id
            AND (
              COALESCE(pad_filter.product_code, '') ILIKE $${params.length}
              OR COALESCE(pad_filter.product_name, p_filter.name, '') ILIKE $${params.length}
            )
        )
      `);
    }

    if (category) {
      params.push(category);
      whereClauses.push(`
        EXISTS (
          SELECT 1
          FROM public.purchase_approval_detail pad_filter
          LEFT JOIN public.product p_filter ON p_filter.code = pad_filter.product_code
          WHERE pad_filter.purchase_approval_id = pa.id
            AND COALESCE(p_filter.category, '') = $${params.length}
        )
      `);
    }

    if (product_type) {
      params.push(product_type);
      whereClauses.push(`
        EXISTS (
          SELECT 1
          FROM public.purchase_approval_detail pad_filter
          LEFT JOIN public.product p_filter ON p_filter.code = pad_filter.product_code
          WHERE pad_filter.purchase_approval_id = pa.id
            AND COALESCE(p_filter.type, '') = $${params.length}
        )
      `);
    }

    if (product_subtype) {
      params.push(product_subtype);
      whereClauses.push(`
        EXISTS (
          SELECT 1
          FROM public.purchase_approval_detail pad_filter
          LEFT JOIN public.product p_filter ON p_filter.code = pad_filter.product_code
          WHERE pad_filter.purchase_approval_id = pa.id
            AND COALESCE(p_filter.subtype, '') = $${params.length}
        )
      `);
    }

    const resolvedPurchaseDepartment = purchase_department || department;
    if (resolvedPurchaseDepartment) {
      params.push(`%${resolvedPurchaseDepartment}%`);
      whereClauses.push(`
        EXISTS (
          SELECT 1
          FROM public.purchase_approval_detail pad_filter
          LEFT JOIN public.department d_filter ON d_filter.id = pad_filter.purchase_department_id
          WHERE pad_filter.purchase_approval_id = pa.id
            AND COALESCE(pad_filter.purchase_department_name, d_filter.name, d_filter.department_code) ILIKE $${params.length}
        )
      `);
    }

    if (budget_year) {
      params.push(Number(budget_year));
      whereClauses.push(`pa.budget_year = $${params.length}`);
    }

    if (queryValidation.data.status) {
      const statusCode = await get_approval_doc_status_code(queryValidation.data.status);
      if (statusCode) {
        params.push(statusCode);
        whereClauses.push(`pa.status = $${params.length}`);
      }
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'pa.id',
      doc_seq: 'pa.doc_seq',
      approve_code: 'pa.approve_code',
      doc_no: 'pa.doc_no',
      doc_date: 'pa.doc_date',
      status: 'ads.status',
      total_amount: 'pa.total_amount',
      total_items: 'pa.total_items',
      item_count: 'item_count',
      created_at: 'pa.created_at',
      updated_at: 'pa.updated_at',
      department: 'department',
      purchase_department: 'purchase_department',
      budget_year: 'pa.budget_year',
      product_name: 'product_name',
      product_code: 'product_code',
      category: 'category',
      product_type: 'product_type',
      product_subtype: 'product_subtype',
    };
    const safeOrderField = allowedOrderFields[order_by || 'created_at'] || 'pa.created_at';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';

    const groupedSql = `
      SELECT
        pa.id,
        pa.doc_seq,
        pa.approve_code,
        pa.doc_no,
        pa.doc_date,
        pa.budget_year,
        ads.status,
        pa.status AS status_code,
        pa.total_amount,
        pa.total_items,
        pa.prepared_by,
        pa.approved_by,
        pa.approved_at,
        pa.notes,
        pa.created_at,
        pa.updated_at,
        pa.version,
        MAX(COALESCE(pad.purchase_department_name, purchase_pd.name, purchase_pd.department_code)) AS purchase_department,
        STRING_AGG(DISTINCT COALESCE(pad.requesting_dept_text, ''), ', ') FILTER (WHERE COALESCE(pad.requesting_dept_text, '') <> '') AS department,
        MIN(COALESCE(pad.product_name, p.name)) AS product_name,
        MIN(COALESCE(pad.product_code, p.code)) AS product_code,
        MIN(COALESCE(p.category, '')) AS category,
        MIN(COALESCE(p.type, '')) AS product_type,
        MIN(COALESCE(p.subtype, '')) AS product_subtype,
        COUNT(pad.id)::int AS item_count
      FROM public.purchase_approval pa
      LEFT JOIN public.approval_doc_status ads ON ads.code = pa.status AND ads.is_active = true
      LEFT JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id
      LEFT JOIN public.product p ON p.code = pad.product_code
      LEFT JOIN public.department purchase_pd ON purchase_pd.id = pad.purchase_department_id
      ${whereSql}
      GROUP BY pa.id, pa.doc_seq, pa.approve_code, pa.doc_no, pa.doc_date, pa.budget_year, ads.status, pa.status, pa.total_amount, pa.total_items, pa.prepared_by, pa.approved_by, pa.approved_at, pa.notes, pa.created_at, pa.updated_at, pa.version
    `;

    const subItemsQuery = `
      SELECT
        pad.id,
        pa.id AS purchase_approval_id,
        pa.approve_code,
        pad.product_code,
        pad.product_name,
        pad.requesting_dept_text AS usage_plan_dept,
        pad.purchase_department_id,
        pad.purchase_department_name,
        pad.usage_plan_flag,
        pad.budget_year AS plan_budget_year,
        pad.line_number,
        pad.status AS detail_status,
        pad.proposed_quantity,
        pad.proposed_amount,
        pad.approved_quantity,
        pad.approved_amount,
        pad.remarks,
        pad.created_at AS detail_created_at,
        pad.updated_at AS detail_updated_at,
        pad.version AS detail_version,
        p.category AS category,
        p.type AS product_type,
        p.subtype AS product_subtype,
        COALESCE(pad.approved_quantity, pad.proposed_quantity, 0)::int AS requested_quantity,
        p.unit AS unit,
        COALESCE(
          pad.cal_unit_price,
          CASE
            WHEN COALESCE(pad.approved_quantity, pad.proposed_quantity, 0) > 0
              THEN ROUND(
                COALESCE(pad.proposed_amount, pad.approved_amount, 0)::numeric
                / COALESCE(pad.approved_quantity, pad.proposed_quantity, 0),
                2
              )
            ELSE 0
          END
        )::float8 AS price_per_unit,
        COALESCE(pad.proposed_amount, pad.approved_amount, 0)::float8 AS total_value,
        pa.budget_year AS plan_budget_year,
        pad.requesting_dept_text AS usage_plan_dept,
        COALESCE(pad.approved_quantity, pad.proposed_quantity, 0)::int AS purchase_qty,
        ROUND(
          COALESCE(pad.approved_quantity, pad.proposed_quantity, 0) * COALESCE(
            pad.cal_unit_price,
            CASE
              WHEN COALESCE(pad.approved_quantity, pad.proposed_quantity, 0) > 0
                THEN ROUND(
                  COALESCE(pad.proposed_amount, pad.approved_amount, 0)::numeric
                  / COALESCE(pad.approved_quantity, pad.proposed_quantity, 0),
                  2
                )
              ELSE 0
            END
          ),
          2
        )::float8 AS purchase_value
      FROM public.purchase_approval pa
      LEFT JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id
      LEFT JOIN public.product p ON p.code = pad.product_code
      ORDER BY pa.approve_code, pad.line_number
    `;

    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('page_size');

    if (!pageParam && !pageSizeParam) {
      const cacheKeyAll = `erp:purchase:approvals:list:v2:v2:all:${JSON.stringify(queryValidation.data)}`;
      const cachedAll = await cacheGet<any>(cacheKeyAll);
      if (cachedAll) {
        return apiSuccess(cachedAll.items, undefined, cachedAll.totalCount, 200);
      }

      const [totalCount, items, subItems] = await Promise.all([
        pgQuery(`SELECT COUNT(DISTINCT pa.id)::int AS count FROM public.purchase_approval pa LEFT JOIN public.approval_doc_status ads ON ads.code = pa.status AND ads.is_active = true LEFT JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id LEFT JOIN public.product p ON p.code = pad.product_code LEFT JOIN public.department purchase_pd ON purchase_pd.id = pad.purchase_department_id ${whereSql}`, params),
        pgQuery(`${groupedSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params),
        pgQuery(subItemsQuery, []),
      ]);

      const subItemsByApproval = subItems.rows.reduce((acc, item) => {
        if (!acc[item.approve_code]) {
          acc[item.approve_code] = [];
        }
        acc[item.approve_code].push(item);
        return acc;
      }, {} as Record<string, any[]>);

      const result = {
        items: items.rows.map((approval) => ({
          ...approval,
          sub_items: subItemsByApproval[approval.approve_code] || []
        })),
        totalCount: totalCount.rows[0]?.count || 0
      };

      await cacheSet(cacheKeyAll, result, 600);
      return apiSuccess(result.items, undefined, result.totalCount, 200);
    }

    const currentPage = page && typeof page === 'number' ? page : 1;
    const currentPageSize = pageSize && typeof pageSize === 'number' ? pageSize : 20;
    const skip = (currentPage - 1) * currentPageSize;
    const cacheKey = `erp:purchase:approvals:list:v2:${JSON.stringify({ ...queryValidation.data, page: currentPage, page_size: currentPageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page: currentPage, page_size: currentPageSize });
    }

    const [totalCount, items, subItems] = await Promise.all([
      pgQuery(`SELECT COUNT(DISTINCT pa.id)::int AS count FROM public.purchase_approval pa LEFT JOIN public.approval_doc_status ads ON ads.code = pa.status AND ads.is_active = true LEFT JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id LEFT JOIN public.product p ON p.code = pad.product_code LEFT JOIN public.department purchase_pd ON purchase_pd.id = pad.purchase_department_id ${whereSql}`, params),
      pgQuery(`${groupedSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, currentPageSize, skip]),
      pgQuery(subItemsQuery, []),
    ]);

    const subItemsByApproval = subItems.rows.reduce((acc, item) => {
      if (!acc[item.approve_code]) {
        acc[item.approve_code] = [];
      }
      acc[item.approve_code].push(item);
      return acc;
    }, {} as Record<string, any[]>);

    const result = {
      items: items.rows.map((approval) => ({
        ...approval,
        sub_items: subItemsByApproval[approval.approve_code] || []
      })),
      totalCount: totalCount.rows[0]?.count || 0,
      page: currentPage,
      page_size: currentPageSize
    };

    await cacheSet(cacheKey, result, 600);
    return apiSuccess(result.items, undefined, result.totalCount, 200, { page: currentPage, page_size: currentPageSize });
  } catch (error) {
    console.error('Error fetching purchase approvals:', error);
    return apiError('Failed to fetch purchase approvals');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validation = await validateRequest(createPurchaseApprovalSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const docSeqResult = await pgQuery<{ next_doc_seq: number }>(
      `SELECT COALESCE(MAX(doc_seq), 0) + 1 AS next_doc_seq FROM public.purchase_approval`
    );
    const docSeq = docSeqResult.rows[0]?.next_doc_seq || 1;

    const docDate = validation.data.doc_date || getCurrentDateString();
    const budgetYear = getBudgetYearFromDate(docDate);

    const normalizedStatusCode = await get_approval_doc_status_code(validation.data.status);
    if (validation.data.status && !normalizedStatusCode) {
      return apiError('Invalid approval status');
    }

    const item = await pgQuery(
      `INSERT INTO public.purchase_approval (doc_seq, approve_code, doc_no, doc_date, budget_year, status, prepared_by, notes, created_by, updated_by)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING id, doc_seq, approve_code, doc_no, doc_date, budget_year, status AS status_code, total_amount, total_items, prepared_by, approved_by, approved_at, notes, created_at, updated_at, version`,
      [
        docSeq,
        validation.data.approve_code || null,
        validation.data.doc_no || DEFAULT_DOC_NO,
        docDate,
        budgetYear,
        normalizedStatusCode || '001',
        validation.data.prepared_by || validation.data.created_by || 'SYSTEM',
        validation.data.notes || null,
        validation.data.created_by || 'SYSTEM',
        validation.data.updated_by || validation.data.created_by || 'SYSTEM',
      ]
    );
    item.rows[0].status = await get_approval_doc_status_value(item.rows[0].status_code);

    await cacheDelByPattern('erp:purchase:approvals:list:v2:*');

    return apiSuccess(item.rows[0], 'Purchase approval created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating purchase approval:', error);
    return apiError('Failed to create purchase approval');
  }
}

