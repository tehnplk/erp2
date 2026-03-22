import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const search = searchParams.get('search') || '';
    const order_by = searchParams.get('order_by') || 'product_code';
    const sort_order = searchParams.get('sort_order') || 'asc';
    const page = Math.max(1, parseInt(searchParams.get('page') || '1', 10));
    const page_size = Math.min(50, Math.max(1, parseInt(searchParams.get('page_size') || '12', 10)));

    const whereClauses: string[] = ['pp.id IS NULL'];
    const params: unknown[] = [];

    if (search) {
      params.push(`%${search}%`);
      const searchParamIndex = params.length;
      whereClauses.push(`(up.product_code ILIKE $${searchParamIndex} OR p.name ILIKE $${searchParamIndex})`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'up.id',
      product_code: 'up.product_code',
      product_name: 'p.name',
      category: 'p.category',
      product_type: 'c.type',
      product_subtype: 'c.subtype',
      budget_year: 'up.budget_year',
      sequence_no: 'up.sequence_no',
      requesting_dept: 'up.requesting_dept',
    };
    
    const safeOrderField = allowedOrderFields[order_by] || 'up.product_code';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const skip = (page - 1) * page_size;

    const [totalCountResult, usagePlansResult] = await Promise.all([
      pgQuery(`
        SELECT COUNT(DISTINCT up.id)::int AS count 
        FROM public.usage_plan up 
        LEFT JOIN public.purchase_plan pp ON up.id = pp.usage_plan_id 
        LEFT JOIN public.inventory_item ii ON ii.product_code = up.product_code
        LEFT JOIN public.inventory_balance ib ON ib.inventory_item_id = ii.id
        ${whereSql}
      `, params),
      pgQuery(`
        ${usagePlanSelect}
        ${whereSql}
        ${usagePlanGroupBy}
        ORDER BY ${safeOrderField} ${safeSortOrder}
        LIMIT $${params.length + 1} OFFSET $${params.length + 2}
      `, [...params, page_size, skip]),
    ]);

    const result = {
      items: usagePlansResult.rows.map(row => ({
        id: row.id,
        code: row.product_code,
        name: row.product_name,
        category: row.category,
        type: row.product_type,
        subtype: row.product_subtype,
        unit: row.unit,
        cost_price: row.cost_price,
        requesting_dept: row.requesting_dept,
        requested_amount: row.requested_amount,
        approved_quota: row.approved_quota,
        budget_year: row.budget_year,
        sequence_no: row.sequence_no,
        inventory_qty: row.inventory_qty,
        available_qty: row.available_qty,
        ...row
      })),
      totalCount: totalCountResult.rows[0]?.count || 0
    };

    return apiSuccess(result.items, undefined, result.totalCount, 200, { page, page_size });
  } catch (error) {
    console.error('Error fetching available usage plans for purchase:', error);
    return apiError('Failed to fetch available usage plans');
  }
}

const usagePlanSelect = `
  SELECT 
    up.id,
    up.product_code,
    p.name AS product_name,
    p.category,
    c.type as product_type,
    c.subtype as product_subtype,
    p.unit,
    COALESCE(p.cost_price, 0)::float8 AS cost_price,
    up.requesting_dept,
    up.requested_amount,
    up.approved_quota,
    up.budget_year,
    up.sequence_no,
    COALESCE(SUM(ib.on_hand_qty), 0) as inventory_qty,
    COALESCE(SUM(ib.available_qty), 0) as available_qty
  FROM public.usage_plan up
  LEFT JOIN public.product p ON p.code = up.product_code
  LEFT JOIN public.category c ON c.category = p.category
  LEFT JOIN public.purchase_plan pp ON up.id = pp.usage_plan_id
  LEFT JOIN public.inventory_item ii ON ii.product_code = up.product_code
  LEFT JOIN public.inventory_balance ib ON ib.inventory_item_id = ii.id
`;

const usagePlanGroupBy = `
  GROUP BY 
    up.id, up.product_code, p.name, p.category, c.type, c.subtype,
    p.unit, COALESCE(p.cost_price, 0)::float8, up.requesting_dept, up.requested_amount,
    up.approved_quota, up.budget_year, up.sequence_no
`;
