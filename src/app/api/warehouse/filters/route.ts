import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [transactionTypesResult, categoriesResult, productTypesResult, productSubtypesResult, companiesResult, departmentsResult] = await Promise.all([
      pgQuery('SELECT DISTINCT "transactionType" FROM public."Warehouse" ORDER BY "transactionType" ASC'),
      pgQuery('SELECT DISTINCT category FROM public."Warehouse" ORDER BY category ASC'),
      pgQuery('SELECT DISTINCT "productType" FROM public."Warehouse" ORDER BY "productType" ASC'),
      pgQuery('SELECT DISTINCT "productSubtype" FROM public."Warehouse" ORDER BY "productSubtype" ASC'),
      pgQuery('SELECT DISTINCT "receivedFromCompany" FROM public."Warehouse" WHERE "receivedFromCompany" IS NOT NULL ORDER BY "receivedFromCompany" ASC'),
      pgQuery('SELECT DISTINCT "requestingDepartment" FROM public."Warehouse" WHERE "requestingDepartment" IS NOT NULL ORDER BY "requestingDepartment" ASC'),
    ]);

    const transactionTypes = transactionTypesResult.rows.map((item: any) => item.transactionType).filter(Boolean);
    const categories = categoriesResult.rows.map((item: any) => item.category).filter(Boolean);
    const productTypes = productTypesResult.rows.map((item: any) => item.productType).filter(Boolean);
    const productSubtypes = productSubtypesResult.rows.map((item: any) => item.productSubtype).filter(Boolean);
    const companies = companiesResult.rows.map((item: any) => item.receivedFromCompany).filter(Boolean);
    const departments = departmentsResult.rows.map((item: any) => item.requestingDepartment).filter(Boolean);

    return NextResponse.json({
      transactionTypes,
      categories,
      productTypes,
      productSubtypes,
      companies,
      departments,
      requestingDepartments: departments,
    });
  } catch (error) {
    console.error('Error fetching warehouse filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
