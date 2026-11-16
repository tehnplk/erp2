import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheGet, cacheSet } from '@/lib/redis';
import { purchasePlanQuerySchema } from '@/lib/validation/schemas';
import { validateQuery } from '@/lib/validation/validate';

const PURCHASE_PLAN_CACHE_VERSION = 'v9';

function buildWhereClause(filters: {
  product_name?: string;
  category?: string;
  product_type?: string;
  product_subtype?: string;
  usage_plan_flag?: string;
  purchase_department?: string;
  budget_year?: string;
  requesting_dept?: string;
}) {
  const whereClauses: string[] = [];
  const params: unknown[] = [];

  if (filters.product_name) {
    params.push(`%${filters.product_name}%`);
    const searchParamIndex = params.length;
    whereClauses.push(`(pp.product_name ILIKE $${searchParamIndex} OR pp.product_code ILIKE $${searchParamIndex})`);
  }

  if (filters.category) {
    params.push(filters.category);
    whereClauses.push(`pp.category = $${params.length}`);
  }

  if (filters.product_type) {
    params.push(filters.product_type);
    whereClauses.push(`pp.product_type = $${params.length}`);
  }

  if (filters.product_subtype) {
    params.push(filters.product_subtype);
    whereClauses.push(`pp.product_subtype = $${params.length}`);
  }

  if (filters.usage_plan_flag === 'นอกแผน' || filters.usage_plan_flag === 'ในแผน') {
    params.push(filters.usage_plan_flag);
    whereClauses.push(`pp.usage_plan_flag = $${params.length}`);
  }

  if (filters.purchase_department) {
    params.push(filters.purchase_department);
    whereClauses.push(`COALESCE(pp.purchase_department_name, pp.purchase_department_code, '') = $${params.length}`);
  }

  if (filters.budget_year) {
    params.push(Number(filters.budget_year));
    whereClauses.push(`pp.budget_year = $${params.length}`);
  }

  if (filters.requesting_dept) {
    params.push(filters.requesting_dept);
    whereClauses.push(`pp.requesting_dept ILIKE $${params.length}`);
  }

  return {
    params,
    whereSql: whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '',
  };
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(purchasePlanQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      product_name,
      category,
      product_type,
      product_subtype,
      usage_plan_flag,
      purchase_department,
      budget_year,
      requesting_dept,
      order_by,
      sort_order,
      page,
      page_size: pageSize,
    } = queryValidation.data;

    const { params, whereSql } = buildWhereClause({
      product_name,
      category,
      product_type,
      product_subtype,
      usage_plan_flag,
      purchase_department,
      budget_year,
      requesting_dept,
    });

    const allowedOrderFields: Record<string, string> = {
      id: 'pp.id',
      product_code: 'pp.product_code',
      product_name: 'pp.product_name',
      purchase_department: 'COALESCE(pp.purchase_department_name, pp.purchase_department_code)',
      usage_plan_flag: 'pp.usage_plan_flag',
      unit: 'pp.unit',
      approved_quota: 'pp.approved_quota',
      inventory_qty: 'pp.inventory_qty',
      purchased_qty: 'pp.purchased_qty',
      purchase_qty: 'pp.purchase_qty',
      unit_price: 'pp.unit_price',
      purchase_value: 'pp.purchase_value',
      budget_year: 'pp.budget_year',
    };

    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'pp.id';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('page_size');

    const cacheBasePayload = {
      product_name,
      category,
      product_type,
      product_subtype,
      usage_plan_flag,
      purchase_department,
      budget_year,
      requesting_dept,
      order_by: order_by || 'id',
      sort_order: sort_order || 'desc',
    };
    const baseFrom = 'FROM public.purchase_plan pp';

    if (!pageParam && !pageSizeParam) {
      const cacheKeyAll = `erp:purchase:plans:list:${PURCHASE_PLAN_CACHE_VERSION}:all:${JSON.stringify(cacheBasePayload)}`;
      const cachedAll = await cacheGet<{ items: unknown[]; totalCount: number }>(cacheKeyAll);
      if (cachedAll) {
        return apiSuccess(cachedAll.items, undefined, cachedAll.totalCount, 200);
      }

      const [countResult, itemsResult] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count ${baseFrom} ${whereSql}`, params),
        pgQuery(`SELECT pp.* ${baseFrom} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params),
      ]);

      const result = {
        items: itemsResult.rows,
        totalCount: countResult.rows[0]?.count || 0,
      };

      await cacheSet(cacheKeyAll, result, 1800);
      return apiSuccess(result.items, undefined, result.totalCount, 200);
    }

    const currentPage = page ?? 1;
    const currentPageSize = pageSize ?? 20;
    const offset = (currentPage - 1) * currentPageSize;
    const cacheKey = `erp:purchase:plans:list:${PURCHASE_PLAN_CACHE_VERSION}:${JSON.stringify({ ...cacheBasePayload, page: currentPage, page_size: currentPageSize })}`;
    const cached = await cacheGet<{ items: unknown[]; totalCount: number }>(cacheKey);

    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page: currentPage, page_size: currentPageSize });
    }

    const paginatedParams = [...params, currentPageSize, offset];
    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count ${baseFrom} ${whereSql}`, params),
      pgQuery(`SELECT pp.* ${baseFrom} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, paginatedParams),
    ]);

    const result = {
      items: itemsResult.rows,
      totalCount: countResult.rows[0]?.count || 0,
    };

    await cacheSet(cacheKey, result, 1800);
    return apiSuccess(result.items, undefined, result.totalCount, 200, { page: currentPage, page_size: currentPageSize });
  } catch (error) {
    console.error('Error fetching purchase plans:', error);
    return apiError('Failed to fetch purchase plans');
  }
}
