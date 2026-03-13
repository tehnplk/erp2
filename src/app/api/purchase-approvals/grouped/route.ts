import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    
    // Get query parameters
    const product_name = searchParams.get('product_name');
    const category = searchParams.get('category');
    const product_type = searchParams.get('product_type');
    const product_subtype = searchParams.get('product_subtype');
    const department = searchParams.get('department');
    const budget_year = searchParams.get('budget_year');
    const order_by = searchParams.get('order_by') || 'created_at';
    const sort_order = searchParams.get('sort_order') || 'desc';
    const page = parseInt(searchParams.get('page') || '1');
    const page_size = parseInt(searchParams.get('page_size') || '20');

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    // Filter on main approval records - join through purchase_plan to usage_plan
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
      whereClauses.push(`up.budget_year = $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      approve_code: 'pa.approve_code',
      doc_no: 'pa.doc_no',
      doc_date: 'pa.doc_date',
      status: 'pa.status',
      total_amount: 'pa.total_amount',
      total_items: 'pa.total_items',
      created_at: 'pa.created_at',
      updated_at: 'pa.updated_at',
      department: 'up.requesting_dept',
      budget_year: 'up.budget_year',
    };
    const safeOrderField = allowedOrderFields[order_by] || 'pa.created_at';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';

    const mainQuery = `
      SELECT 
        pa.id,
        pa.approve_code,
        pa.doc_no,
        pa.doc_date,
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
        MAX(up.requesting_dept) as department,
        MAX(up.budget_year) as budget_year,
        COUNT(pad.id) as item_count
      FROM public.purchase_approval pa
      LEFT JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id
      LEFT JOIN public.purchase_plan pp ON pad.purchase_plan_id = pp.id
      LEFT JOIN public.usage_plan up ON pp.usage_plan_id = up.id
      ${whereSql}
      GROUP BY pa.id, pa.approve_code, pa.doc_no, pa.doc_date, pa.status, pa.total_amount, pa.total_items,
               pa.prepared_by, pa.approved_by, pa.approved_at, pa.notes, pa.created_at, pa.updated_at, pa.version
      ORDER BY MAX(${safeOrderField}) ${safeSortOrder}
    `;

    const subItemsQuery = `
      SELECT 
        pad.id,
        pa.id as purchase_approval_id,
        pa.approve_code,
        pad.purchase_plan_id,
        pad.line_number,
        pad.status as detail_status,
        pad.approved_quantity,
        pad.approved_amount,
        pad.remarks,
        pad.created_at as detail_created_at,
        pad.updated_at as detail_updated_at,
        pad.version as detail_version,
        up.product_name,
        up.product_code,
        up.category,
        up.type as product_type,
        up.subtype as product_subtype,
        up.requested_amount as requested_quantity,
        up.unit,
        up.price_per_unit,
        (up.requested_amount * up.price_per_unit) as total_value,
        up.budget_year as plan_budget_year,
        up.requesting_dept as usage_plan_dept,
        pp.purchase_qty,
        pp.purchase_value
      FROM public.purchase_approval pa
      LEFT JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id
      LEFT JOIN public.purchase_plan pp ON pad.purchase_plan_id = pp.id
      LEFT JOIN public.usage_plan up ON pp.usage_plan_id = up.id
      ORDER BY pa.approve_code, pad.line_number
    `;
    
    const [mainResult, subItemsResult] = await Promise.all([
      pgQuery(mainQuery, params),
      pgQuery(subItemsQuery, [])
    ]);

    // Group sub-items by approve_code
    const subItemsByApproval = subItemsResult.rows.reduce((acc, item) => {
      if (!acc[item.approve_code]) {
        acc[item.approve_code] = [];
      }
      acc[item.approve_code].push(item);
      return acc;
    }, {} as Record<string, any[]>);

    // Combine main approvals with their sub-items
    const items = mainResult.rows.map(approval => ({
      ...approval,
      sub_items: subItemsByApproval[approval.approve_code] || []
    }));

    // Handle pagination
    const hasPagination = searchParams.has('page') || searchParams.has('page_size');
    
    if (!hasPagination) {
      return apiSuccess(items, undefined, items.length, 200);
    }

    const currentPage = page > 0 ? page : 1;
    const currentPageSize = page_size > 0 ? page_size : 20;
    const skip = (currentPage - 1) * currentPageSize;
    
    const paginatedItems = items.slice(skip, skip + currentPageSize);

    return apiSuccess(paginatedItems, undefined, items.length, 200, { 
      page: currentPage, 
      page_size: currentPageSize 
    });

  } catch (error) {
    console.error('Error fetching purchase approvals grouped:', error);
    return apiError(`Failed to fetch purchase approvals: ${error}`);
  }
}