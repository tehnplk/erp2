import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient, Prisma } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const orderBy = searchParams.get('orderBy');
    const sortOrder = (searchParams.get('sortOrder') as 'asc' | 'desc') || 'desc';

    const productName = searchParams.get('productName');
    const category = searchParams.get('category');
    const productType = searchParams.get('productType');
    const productSubtype = searchParams.get('productSubtype');
    const requestingDepartment = searchParams.get('requestingDepartment');

    const where: any = {};
    if (productName) where.productName = { contains: productName, mode: 'insensitive' };
    if (category) where.category = category;
    if (productType) where.productType = productType;
    if (productSubtype) where.productSubtype = productSubtype;
    if (requestingDepartment) where.requestingDepartment = requestingDepartment;

    let orderByClause: any = { id: 'desc' };
    if (orderBy) orderByClause = { [orderBy]: sortOrder };

    const totalCount = await prisma.warehouse.count();

    // Build safe WHERE using parameterized raw SQL
    const conditions: Prisma.Sql[] = [];
    if (productName) conditions.push(Prisma.sql`"productName" ILIKE ${`%${productName}%`}`);
    if (category) conditions.push(Prisma.sql`"category" = ${category}`);
    if (productType) conditions.push(Prisma.sql`"productType" = ${productType}`);
    if (productSubtype) conditions.push(Prisma.sql`"productSubtype" = ${productSubtype}`);
    if (requestingDepartment) conditions.push(Prisma.sql`"requestingDepartment" = ${requestingDepartment}`);

    const whereSql = conditions.length
      ? Prisma.sql`WHERE ${Prisma.join(conditions, Prisma.sql` AND `)}`
      : Prisma.sql``;

    // Whitelist sortable columns
    const orderColumnMap: Record<string, Prisma.Sql> = {
      id: Prisma.sql`"id"`,
      transactionDate: Prisma.sql`"transactionDate"`,
      productCode: Prisma.sql`"productCode"`,
      productName: Prisma.sql`"productName"`,
      transactionQuantity: Prisma.sql`"transactionQuantity"`,
      remainingQuantity: Prisma.sql`"remainingQuantity"`,
      category: Prisma.sql`"category"`,
      productType: Prisma.sql`"productType"`,
      productSubtype: Prisma.sql`"productSubtype"`,
      requestingDepartment: Prisma.sql`"requestingDepartment"`,
    };
    const orderColSql = orderBy && orderColumnMap[orderBy] ? orderColumnMap[orderBy] : orderColumnMap['id'];
    const dirSql = sortOrder === 'asc' ? Prisma.sql`ASC` : Prisma.sql`DESC`;

    const items = await prisma.$queryRaw<any[]>`
      SELECT
        "id",
        "transactionDate",
        "productCode",
        "productName",
        "transactionQuantity",
        "remainingQuantity",
        "category",
        "productType",
        "productSubtype",
        "requestingDepartment"
      FROM "Warehouse"
      ${whereSql}
      ORDER BY ${orderColSql} ${dirSql}
    `;

    return NextResponse.json({ items, totalCount });
  } catch (error) {
    console.error('Error fetching warehouse:', error);
    return NextResponse.json({ error: 'Failed to fetch warehouse' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const data: any = {
      stockId: body.stockId ?? null,
      transactionType: body.transactionType ?? null,
      transactionDate: body.transactionDate ?? null,
      category: body.category ?? null,
      productType: body.productType ?? null,
      productSubtype: body.productSubtype ?? null,
      productCode: body.productCode ?? null,
      productName: body.productName ?? null,
      productImage: body.productImage ?? null,
      unit: body.unit ?? null,
      productLot: body.productLot ?? null,
      productPrice: body.productPrice != null ? parseFloat(body.productPrice) : 0,
      receivedFromCompany: body.receivedFromCompany ?? null,
      receiptBillNumber: body.receiptBillNumber ?? null,
      requestingDepartment: body.requestingDepartment ?? null,
      requisitionNumber: body.requisitionNumber ?? null,
      quotaAmount: body.quotaAmount != null && body.quotaAmount !== '' ? parseInt(body.quotaAmount) : null,
      carriedForwardQty: body.carriedForwardQty != null && body.carriedForwardQty !== '' ? parseInt(body.carriedForwardQty) : null,
      carriedForwardValue: body.carriedForwardValue != null ? parseFloat(body.carriedForwardValue) : 0,
      transactionPrice: body.transactionPrice != null ? parseFloat(body.transactionPrice) : 0,
      transactionQuantity: body.transactionQuantity != null && body.transactionQuantity !== '' ? parseInt(body.transactionQuantity) : null,
      transactionValue: body.transactionValue != null ? parseFloat(body.transactionValue) : 0,
      remainingQuantity: body.remainingQuantity != null && body.remainingQuantity !== '' ? parseInt(body.remainingQuantity) : null,
      remainingValue: body.remainingValue != null ? parseFloat(body.remainingValue) : 0,
      inventoryStatus: body.inventoryStatus ?? null,
    };

    const item = await prisma.warehouse.create({ data });
    return NextResponse.json(item, { status: 201 });
  } catch (error) {
    console.error('Error creating warehouse record:', error);
    return NextResponse.json({ error: 'Failed to create warehouse record' }, { status: 500 });
  }
}
