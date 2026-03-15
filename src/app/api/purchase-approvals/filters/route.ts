import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

export async function GET() {
  try {
    const cacheKey = 'erp:purchase:approvals:filters';
    const cached = await cacheGet<any>(cacheKey);
    if (cached) return NextResponse.json(cached);

    const [categoryRowsResult, departmentsResult, budgetYearsResult, preparedByResult, approvedByResult, statusResult] = await Promise.all([
      pgQuery(
        `SELECT category, type, subtype
         FROM public.category
         ORDER BY category ASC, type ASC, subtype ASC`
      ),
      pgQuery(`
        SELECT DISTINCT up.requesting_dept as department
        FROM public.purchase_approval pa
        INNER JOIN public.purchase_approval_detail pad ON pad.purchase_approval_id = pa.id
        INNER JOIN public.purchase_plan pp ON pp.id = pad.purchase_plan_id
        INNER JOIN public.usage_plan up ON up.id = pp.usage_plan_id
        WHERE up.requesting_dept IS NOT NULL 
        ORDER BY up.requesting_dept ASC
      `),
      pgQuery(`
        SELECT DISTINCT pa.budget_year
        FROM public.purchase_approval pa
        WHERE pa.budget_year IS NOT NULL
        ORDER BY pa.budget_year ASC
      `),
      pgQuery('SELECT DISTINCT prepared_by FROM public.purchase_approval WHERE prepared_by IS NOT NULL ORDER BY prepared_by ASC'),
      pgQuery('SELECT DISTINCT approved_by FROM public.purchase_approval WHERE approved_by IS NOT NULL ORDER BY approved_by ASC'),
      pgQuery(`
        SELECT DISTINCT unnest(ARRAY['DRAFT', 'PENDING', 'APPROVED', 'REJECTED', 'CANCELLED']) as status
        ORDER BY status ASC
      `),
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      departments: departmentsResult.rows.map((item: any) => item.department).filter(Boolean),
      budget_years: budgetYearsResult.rows.map((item: any) => String(item.budget_year)).filter(Boolean),
      categories: Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean))),
      product_types: Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean))),
      product_subtypes: Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean))),
      category_options: categoryRows,
      prepared_by: preparedByResult.rows.map((item: any) => item.prepared_by).filter(Boolean),
      approved_by: approvedByResult.rows.map((item: any) => item.approved_by).filter(Boolean),
      status_options: statusResult.rows.map((item: any) => item.status).filter(Boolean)
    };

    await cacheSet(cacheKey, result, 3600);
    return NextResponse.json(result);
  } catch (error) {
    console.error('Error fetching purchase approval filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
