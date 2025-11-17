import { NextRequest } from 'next/server';
import { Prisma } from '@prisma/client';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError, apiMethodNotAllowed } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { warehouseQuerySchema, createWarehouseSchema } from '@/lib/validation/schemas';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    
    // Validate query parameters
    const queryValidation = validateQuery(warehouseQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }
    
    const {
      orderBy,
      sortOrder,
      productName,
      category,
      productType,
      productSubtype,
      requestingDepartment,
      page = 1,
      pageSize = 20
    } = queryValidation.data as any;

    // Build safe WHERE using parameterized raw SQL
    const conditions: Prisma.Sql[] = [];
    if (productName) conditions.push(Prisma.sql`"productName" ILIKE ${`%${productName}%`}`);
    if (category) conditions.push(Prisma.sql`"category" = ${category}`);
    if (productType) conditions.push(Prisma.sql`"productType" = ${productType}`);
    if (productSubtype) conditions.push(Prisma.sql`"productSubtype" = ${productSubtype}`);
    if (requestingDepartment) conditions.push(Prisma.sql`"requestingDepartment" = ${requestingDepartment}`);

    const whereSql = conditions.length
      ? Prisma.sql`WHERE ${Prisma.join(conditions, ' AND ')}`
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
    
    const orderColSql = orderBy ? orderColumnMap[orderBy] : orderColumnMap['id'];
    const dirSql = sortOrder === 'asc' ? Prisma.sql`ASC` : Prisma.sql`DESC`;

    const offset = (page - 1) * pageSize;

    // Get total count and paginated items in parallel
    const [countResult, items] = await Promise.all([
      prisma.$queryRaw<{ count: bigint }[]>`
        SELECT COUNT(*)::bigint AS count
        FROM "Warehouse"
        ${whereSql}
      `,
      prisma.$queryRaw<any[]>`
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
        LIMIT ${pageSize} OFFSET ${offset}
      `
    ]);

    const totalCount = Number(countResult[0]?.count ?? 0);

    return apiSuccess(items, undefined, totalCount, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching warehouse records:', error);
    return apiError('Failed to fetch warehouse records');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createWarehouseSchema, body);
    if (!validation.success) {
      return validation.error;
    }
    
    const item = await prisma.warehouse.create({ 
      data: validation.data as any
    });
    
    return apiSuccess(item, 'Warehouse record created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating warehouse record:', error);
    return apiError('Failed to create warehouse record');
  }
}
