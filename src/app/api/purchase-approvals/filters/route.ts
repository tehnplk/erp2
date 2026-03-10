import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

export async function GET() {
  try {
    const cacheKey = 'erp:purchase:approvals:filters';
    const cached = await cacheGet<any>(cacheKey);
    if (cached) return NextResponse.json(cached);

    const [categoryRowsResult, departmentsResult, requestersResult, approversResult, budgetYearsResult] = await Promise.all([
      pgQuery(
        `SELECT category, type, subtype
         FROM public.category
         ORDER BY category ASC, type ASC, subtype ASC`
      ),
      pgQuery('SELECT DISTINCT department FROM public.purchase_approval ORDER BY department ASC'),
      pgQuery('SELECT DISTINCT requester FROM public.purchase_approval WHERE requester IS NOT NULL ORDER BY requester ASC'),
      pgQuery('SELECT DISTINCT approver FROM public.purchase_approval WHERE approver IS NOT NULL ORDER BY approver ASC'),
      pgQuery('SELECT DISTINCT budget_year FROM public.purchase_approval WHERE budget_year IS NOT NULL ORDER BY budget_year DESC'),
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      departments: departmentsResult.rows.map((item: any) => item.department).filter(Boolean),
      categories: Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean))),
      product_types: Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean))),
      product_subtypes: Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean))),
      category_options: categoryRows,
      requesters: requestersResult.rows.map((item: any) => item.requester).filter(Boolean),
      approvers: approversResult.rows.map((item: any) => item.approver).filter(Boolean),
      budget_years: budgetYearsResult.rows.map((item: any) => String(item.budget_year)).filter(Boolean)
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
