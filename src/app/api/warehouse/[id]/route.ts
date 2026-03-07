import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateWarehouseSchema } from '@/lib/validation/schemas';

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;

    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json(
        { error: 'Invalid ID format' },
        { status: 400 }
      );
    }

    const numericId = parsedId.data.id;
    const body = await request.json();

    const validation = await validateRequest(updateWarehouseSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const existingResult = await pgQuery('SELECT id FROM public."Warehouse" WHERE id = $1 LIMIT 1', [numericId]);
    if (existingResult.rows.length === 0) {
      return NextResponse.json({ error: 'Warehouse record not found' }, { status: 404 });
    }

    const columnMap: Record<string, string> = {
      stockId: '"stockId"',
      transactionType: '"transactionType"',
      transactionDate: '"transactionDate"',
      category: 'category',
      productType: '"productType"',
      productSubtype: '"productSubtype"',
      productCode: '"productCode"',
      productName: '"productName"',
      productImage: '"productImage"',
      unit: 'unit',
      productLot: '"productLot"',
      productPrice: '"productPrice"',
      receivedFromCompany: '"receivedFromCompany"',
      receiptBillNumber: '"receiptBillNumber"',
      requestingDepartment: '"requestingDepartment"',
      requisitionNumber: '"requisitionNumber"',
      quotaAmount: '"quotaAmount"',
      carriedForwardQty: '"carriedForwardQty"',
      carriedForwardValue: '"carriedForwardValue"',
      transactionPrice: '"transactionPrice"',
      transactionQuantity: '"transactionQuantity"',
      transactionValue: '"transactionValue"',
      remainingQuantity: '"remainingQuantity"',
      remainingValue: '"remainingValue"',
      inventoryStatus: '"inventoryStatus"',
    };

    const assignments: string[] = [];
    const values: unknown[] = [];
    Object.entries(validation.data as Record<string, unknown>).forEach(([key, value]) => {
      const column = columnMap[key];
      if (!column) return;
      values.push(value ?? null);
      assignments.push(`${column} = $${values.length}`);
    });

    if (assignments.length === 0) {
      const unchanged = await pgQuery('SELECT id, "stockId", "transactionType", "transactionDate", category, "productType", "productSubtype", "productCode", "productName", "productImage", unit, "productLot", "productPrice"::float8 AS "productPrice", "receivedFromCompany", "receiptBillNumber", "requestingDepartment", "requisitionNumber", "quotaAmount", "carriedForwardQty", "carriedForwardValue"::float8 AS "carriedForwardValue", "transactionPrice"::float8 AS "transactionPrice", "transactionQuantity", "transactionValue"::float8 AS "transactionValue", "remainingQuantity", "remainingValue"::float8 AS "remainingValue", "inventoryStatus" FROM public."Warehouse" WHERE id = $1 LIMIT 1', [numericId]);
      return NextResponse.json(unchanged.rows[0]);
    }

    values.push(numericId);
    const updated = await pgQuery(
      `UPDATE public."Warehouse" SET ${assignments.join(', ')} WHERE id = $${values.length}
       RETURNING id, "stockId", "transactionType", "transactionDate", category, "productType", "productSubtype", "productCode", "productName", "productImage", unit, "productLot", "productPrice"::float8 AS "productPrice", "receivedFromCompany", "receiptBillNumber", "requestingDepartment", "requisitionNumber", "quotaAmount", "carriedForwardQty", "carriedForwardValue"::float8 AS "carriedForwardValue", "transactionPrice"::float8 AS "transactionPrice", "transactionQuantity", "transactionValue"::float8 AS "transactionValue", "remainingQuantity", "remainingValue"::float8 AS "remainingValue", "inventoryStatus"`,
      values
    );
    return NextResponse.json(updated.rows[0]);
  } catch (error) {
    console.error('Error updating warehouse record:', error);
    return NextResponse.json({ error: 'Failed to update warehouse record' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;

    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json(
        { error: 'Invalid ID format' },
        { status: 400 }
      );
    }

    const numericId = parsedId.data.id;
    await pgQuery('DELETE FROM public."Warehouse" WHERE id = $1', [numericId]);
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting warehouse record:', error);
    return NextResponse.json({ error: 'Failed to delete warehouse record' }, { status: 500 });
  }
}
