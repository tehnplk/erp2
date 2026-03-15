import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { purchaseApprovalQuerySchema, createPurchaseApprovalSchema } from '@/lib/validation/schemas';

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

const purchaseApprovalSelect = `
  SELECT
    pa.id,
    pa.doc_seq,
    pa.approve_code,
    pa.doc_no,
    pa.doc_date,
    pa.budget_year,
    pa.status,
    pa.total_amount,
    pa.total_items,
    pa.prepared_by,
    pa.approved_by,
    pa.approved_at,
    pa.notes,
    pa.created_at,
    pa.updated_at,
    pa.version,
    COUNT(pad.id)::int AS item_count
`;

const purchaseApprovalFrom = `
  FROM public.purchase_approval pa
  LEFT JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id
  LEFT JOIN public.purchase_plan pp ON pp.id = pad.purchase_plan_id
  LEFT JOIN public.usage_plan up ON up.id = pp.usage_plan_id
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    
    // Validate query parameters
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
      budget_year,
      page,
      page_size: pageSize
    } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (product_name) {
      params.push(`%${product_name}%`);
      whereClauses.push(`up.product_name ILIKE $${params.length}`);
    }
    if (category) {
      params.push(category);
      whereClauses.push(`up.category = $${params.length}`);
    }
    if (product_type) {
      params.push(product_type);
      whereClauses.push(`up.type = $${params.length}`);
    }
    if (product_subtype) {
      params.push(product_subtype);
      whereClauses.push(`up.subtype = $${params.length}`);
    }
    if (department) {
      params.push(department);
      whereClauses.push(`up.requesting_dept = $${params.length}`);
    }
    if (budget_year) {
      params.push(Number(budget_year));
      whereClauses.push(`pa.budget_year = $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'pa.id',
      doc_seq: 'pa.doc_seq',
      approve_code: 'pa.approve_code',
      doc_no: 'pa.doc_no',
      doc_date: 'pa.doc_date',
      status: 'pa.status',
      total_amount: 'pa.total_amount',
      total_items: 'pa.total_items',
      created_at: 'pa.created_at',
      updated_at: 'pa.updated_at',
      department: 'up.requesting_dept',
      budget_year: 'pa.budget_year',
      product_name: 'up.product_name',
      product_code: 'up.product_code',
      category: 'up.category',
      product_type: 'up.type',
      product_subtype: 'up.subtype',
    };
    const safeOrderField = allowedOrderFields[order_by || 'created_at'] || 'pa.created_at';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const groupedSql = `${purchaseApprovalSelect} ${purchaseApprovalFrom} ${whereSql} GROUP BY pa.id, pa.doc_seq, pa.approve_code, pa.doc_no, pa.doc_date, pa.budget_year, pa.status, pa.total_amount, pa.total_items, pa.prepared_by, pa.approved_by, pa.approved_at, pa.notes, pa.created_at, pa.updated_at, pa.version`;

    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('page_size');

    if (!pageParam && !pageSizeParam) {
      const cacheKeyAll = `erp:purchase:approvals:list:all:${JSON.stringify(queryValidation.data)}`;
      const cachedAll = await cacheGet<any>(cacheKeyAll);
      if (cachedAll) {
        return apiSuccess(cachedAll.items, undefined, cachedAll.totalCount, 200);
      }

      const [totalCount, items] = await Promise.all([
        pgQuery(`SELECT COUNT(DISTINCT pa.id)::int AS count ${purchaseApprovalFrom} ${whereSql}`, params),
        pgQuery(`${groupedSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params)
      ]);

      const result = {
        items: items.rows,
        totalCount: totalCount.rows[0]?.count || 0
      };

      await cacheSet(cacheKeyAll, result, 600);

      return apiSuccess(result.items, undefined, result.totalCount, 200);
    }

    const currentPage = page && typeof page === 'number' ? page : 1;
    const currentPageSize = pageSize && typeof pageSize === 'number' ? pageSize : 20;
    const skip = (currentPage - 1) * currentPageSize;
    const cacheKey = `erp:purchase:approvals:list:${JSON.stringify({ ...queryValidation.data, page: currentPage, page_size: currentPageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page: currentPage, page_size: currentPageSize });
    }

    const [totalCount, items] = await Promise.all([
      pgQuery(`SELECT COUNT(DISTINCT pa.id)::int AS count ${purchaseApprovalFrom} ${whereSql}`, params),
      pgQuery(`${groupedSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, currentPageSize, skip])
    ]);

    const result = {
      items: items.rows,
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
    
    // Validate request body
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

    const item = await pgQuery(
      `INSERT INTO public.purchase_approval (doc_seq, approve_code, doc_no, doc_date, budget_year, status, prepared_by, notes, created_by, updated_by)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING id, doc_seq, approve_code, doc_no, doc_date, budget_year, status, total_amount, total_items, prepared_by, approved_by, approved_at, notes, created_at, updated_at, version`,
      [
        docSeq,
        validation.data.approve_code || null,
        validation.data.doc_no || DEFAULT_DOC_NO,
        docDate,
        budgetYear,
        validation.data.status || 'DRAFT',
        validation.data.prepared_by || validation.data.created_by || 'SYSTEM',
        validation.data.notes || null,
        validation.data.created_by || 'SYSTEM',
        validation.data.updated_by || validation.data.created_by || 'SYSTEM',
      ]
    );
    
    await cacheDelByPattern('erp:purchase:approvals:list:*');
    
    return apiSuccess(item.rows[0], 'Purchase approval created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating purchase approval:', error);
    return apiError('Failed to create purchase approval');
  }
}
