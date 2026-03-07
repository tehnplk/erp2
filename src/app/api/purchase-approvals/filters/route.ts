import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [departmentsResult, categoriesResult, productTypesResult, productSubtypesResult, requestersResult, approversResult] = await Promise.all([
      pgQuery('SELECT DISTINCT department FROM public."PurchaseApproval" ORDER BY department ASC'),
      pgQuery('SELECT DISTINCT category FROM public."PurchaseApproval" ORDER BY category ASC'),
      pgQuery('SELECT DISTINCT "productType" FROM public."PurchaseApproval" ORDER BY "productType" ASC'),
      pgQuery('SELECT DISTINCT "productSubtype" FROM public."PurchaseApproval" ORDER BY "productSubtype" ASC'),
      pgQuery('SELECT DISTINCT requester FROM public."PurchaseApproval" WHERE requester IS NOT NULL ORDER BY requester ASC'),
      pgQuery('SELECT DISTINCT approver FROM public."PurchaseApproval" WHERE approver IS NOT NULL ORDER BY approver ASC'),
    ]);

    return NextResponse.json({
      departments: departmentsResult.rows.map((item: any) => item.department).filter(Boolean),
      categories: categoriesResult.rows.map((item: any) => item.category).filter(Boolean),
      productTypes: productTypesResult.rows.map((item: any) => item.productType).filter(Boolean),
      productSubtypes: productSubtypesResult.rows.map((item: any) => item.productSubtype).filter(Boolean),
      requesters: requestersResult.rows.map((item: any) => item.requester).filter(Boolean),
      approvers: approversResult.rows.map((item: any) => item.approver).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching purchase approval filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
