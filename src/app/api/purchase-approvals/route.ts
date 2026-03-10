import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { purchaseApprovalQuerySchema, createPurchaseApprovalSchema } from '@/lib/validation/schemas';
import { findDepartmentCodeByName } from '@/lib/department-code';

const purchaseApprovalSelect = `SELECT id, approval_id, department, department_code, budget_year, record_number, request_date, product_name, product_code, category, product_type, product_subtype, requested_quantity, unit, price_per_unit::float8 AS price_per_unit, total_value::float8 AS total_value, over_plan_case, requester, approver, created_at, updated_at FROM public.purchase_approval`;

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
      whereClauses.push(`product_name ILIKE $${params.length}`);
    }
    if (category) {
      params.push(category);
      whereClauses.push(`category = $${params.length}`);
    }
    if (product_type) {
      params.push(product_type);
      whereClauses.push(`product_type = $${params.length}`);
    }
    if (product_subtype) {
      params.push(product_subtype);
      whereClauses.push(`product_subtype = $${params.length}`);
    }
    if (department) {
      params.push(department);
      whereClauses.push(`department = $${params.length}`);
    }
    if (budget_year) {
      params.push(Number(budget_year));
      whereClauses.push(`budget_year = $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      approval_id: 'approval_id',
      department: 'department',
      budget_year: 'budget_year',
      record_number: 'record_number',
      request_date: 'request_date',
      product_name: 'product_name',
      product_code: 'product_code',
      category: 'category',
      product_type: 'product_type',
      product_subtype: 'product_subtype',
      requester: 'requester',
      approver: 'approver',
    };
    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'id';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';

    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('page_size');

    if (!pageParam && !pageSizeParam) {
      const cacheKeyAll = `erp:purchase:approvals:list:all:${JSON.stringify(queryValidation.data)}`;
      const cachedAll = await cacheGet<any>(cacheKeyAll);
      if (cachedAll) {
        return apiSuccess(cachedAll.items, undefined, cachedAll.totalCount, 200);
      }

      const [totalCount, items] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count FROM public.purchase_approval ${whereSql}`, params),
        pgQuery(`${purchaseApprovalSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params)
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
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.purchase_approval ${whereSql}`, params),
      pgQuery(`${purchaseApprovalSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, currentPageSize, skip])
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

    const departmentCode = await findDepartmentCodeByName(validation.data.department || null);

    const item = await pgQuery(
      `INSERT INTO public.purchase_approval (approval_id, department, department_code, budget_year, record_number, request_date, product_name, product_code, category, product_type, product_subtype, requested_quantity, unit, price_per_unit, total_value, over_plan_case, requester, approver)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)
       RETURNING id, approval_id, department, department_code, budget_year, record_number, request_date, product_name, product_code, category, product_type, product_subtype, requested_quantity, unit, price_per_unit::float8 AS price_per_unit, total_value::float8 AS total_value, over_plan_case, requester, approver, created_at, updated_at`,
      [
        validation.data.approval_id || null,
        validation.data.department || null,
        departmentCode,
        validation.data.budget_year ?? null,
        validation.data.record_number || null,
        validation.data.request_date || null,
        validation.data.product_name || null,
        validation.data.product_code || null,
        validation.data.category || null,
        validation.data.product_type || null,
        validation.data.product_subtype || null,
        validation.data.requested_quantity ?? null,
        validation.data.unit || null,
        validation.data.price_per_unit ?? 0,
        validation.data.total_value ?? 0,
        validation.data.over_plan_case || null,
        validation.data.requester || null,
        validation.data.approver || null,
      ]
    );
    
    await cacheDelByPattern('erp:purchase:approvals:list:*');
    
    return apiSuccess(item.rows[0], 'Purchase approval created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating purchase approval:', error);
    return apiError('Failed to create purchase approval');
  }
}
