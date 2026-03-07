import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { warehouseQuerySchema, createWarehouseSchema } from '@/lib/validation/schemas';

const warehouseSelect = `SELECT id, "stockId", "transactionType", "transactionDate", category, "productType", "productSubtype", "productCode", "productName", "productImage", unit, "productLot", "productPrice"::float8 AS "productPrice", "receivedFromCompany", "receiptBillNumber", "requestingDepartment", "requisitionNumber", "quotaAmount", "carriedForwardQty", "carriedForwardValue"::float8 AS "carriedForwardValue", "transactionPrice"::float8 AS "transactionPrice", "transactionQuantity", "transactionValue"::float8 AS "transactionValue", "remainingQuantity", "remainingValue"::float8 AS "remainingValue", "inventoryStatus" FROM public."Warehouse"`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    
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

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (productName) {
      params.push(`%${productName}%`);
      whereClauses.push(`"productName" ILIKE $${params.length}`);
    }
    if (category) {
      params.push(category);
      whereClauses.push(`category = $${params.length}`);
    }
    if (productType) {
      params.push(productType);
      whereClauses.push(`"productType" = $${params.length}`);
    }
    if (productSubtype) {
      params.push(productSubtype);
      whereClauses.push(`"productSubtype" = $${params.length}`);
    }
    if (requestingDepartment) {
      params.push(requestingDepartment);
      whereClauses.push(`"requestingDepartment" = $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      transactionDate: '"transactionDate"',
      productCode: '"productCode"',
      productName: '"productName"',
      transactionQuantity: '"transactionQuantity"',
      remainingQuantity: '"remainingQuantity"',
      category: 'category',
      productType: '"productType"',
      productSubtype: '"productSubtype"',
      requestingDepartment: '"requestingDepartment"',
    };
    const safeOrderField = allowedOrderFields[orderBy || 'id'] || 'id';
    const safeSortOrder = sortOrder === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const offset = (page - 1) * pageSize;

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."Warehouse" ${whereSql}`, params),
      pgQuery(`${warehouseSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset])
    ]);

    return apiSuccess(itemsResult.rows, undefined, countResult.rows[0]?.count || 0, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching warehouse records:', error);
    return apiError('Failed to fetch warehouse records');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    const validation = await validateRequest(createWarehouseSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const data = validation.data as any;
    const item = await pgQuery(
      `INSERT INTO public."Warehouse" ("stockId", "transactionType", "transactionDate", category, "productType", "productSubtype", "productCode", "productName", "productImage", unit, "productLot", "productPrice", "receivedFromCompany", "receiptBillNumber", "requestingDepartment", "requisitionNumber", "quotaAmount", "carriedForwardQty", "carriedForwardValue", "transactionPrice", "transactionQuantity", "transactionValue", "remainingQuantity", "remainingValue", "inventoryStatus")
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25)
       RETURNING id, "stockId", "transactionType", "transactionDate", category, "productType", "productSubtype", "productCode", "productName", "productImage", unit, "productLot", "productPrice"::float8 AS "productPrice", "receivedFromCompany", "receiptBillNumber", "requestingDepartment", "requisitionNumber", "quotaAmount", "carriedForwardQty", "carriedForwardValue"::float8 AS "carriedForwardValue", "transactionPrice"::float8 AS "transactionPrice", "transactionQuantity", "transactionValue"::float8 AS "transactionValue", "remainingQuantity", "remainingValue"::float8 AS "remainingValue", "inventoryStatus"`,
      [
        data.stockId ?? null,
        data.transactionType ?? null,
        data.transactionDate ?? null,
        data.category ?? null,
        data.productType ?? null,
        data.productSubtype ?? null,
        data.productCode ?? null,
        data.productName ?? null,
        data.productImage ?? null,
        data.unit ?? null,
        data.productLot ?? null,
        data.productPrice ?? 0,
        data.receivedFromCompany ?? null,
        data.receiptBillNumber ?? null,
        data.requestingDepartment ?? null,
        data.requisitionNumber ?? null,
        data.quotaAmount ?? null,
        data.carriedForwardQty ?? null,
        data.carriedForwardValue ?? 0,
        data.transactionPrice ?? 0,
        data.transactionQuantity ?? null,
        data.transactionValue ?? 0,
        data.remainingQuantity ?? null,
        data.remainingValue ?? 0,
        data.inventoryStatus ?? null,
      ]
    );
    
    return apiSuccess(item.rows[0], 'Warehouse record created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating warehouse record:', error);
    return apiError('Failed to create warehouse record');
  }
}
