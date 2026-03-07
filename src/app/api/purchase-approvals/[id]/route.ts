import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const numericId = parseInt(id, 10);
    const body = await request.json();

    if (isNaN(numericId)) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const existingResult = await pgQuery('SELECT id FROM public."PurchaseApproval" WHERE id = $1 LIMIT 1', [numericId]);
    if (existingResult.rows.length === 0) {
      return NextResponse.json({ error: 'Purchase approval not found' }, { status: 404 });
    }

    const data: Record<string, unknown> = {
      approvalId: body.approvalId ?? null,
      department: body.department ?? null,
      budgetYear: body.budgetYear !== undefined ? (body.budgetYear === null || body.budgetYear === '' ? null : parseInt(body.budgetYear, 10)) : undefined,
      recordNumber: body.recordNumber ?? null,
      requestDate: body.requestDate ?? null,
      productName: body.productName ?? null,
      productCode: body.productCode ?? null,
      category: body.category ?? null,
      productType: body.productType ?? null,
      productSubtype: body.productSubtype ?? null,
      requestedQuantity: body.requestedQuantity !== undefined ? (body.requestedQuantity === null || body.requestedQuantity === '' ? null : parseInt(body.requestedQuantity, 10)) : undefined,
      unit: body.unit ?? null,
      pricePerUnit: body.pricePerUnit != null ? parseFloat(body.pricePerUnit) : undefined,
      totalValue: body.totalValue != null ? parseFloat(body.totalValue) : undefined,
      overPlanCase: body.overPlanCase ?? null,
      requester: body.requester ?? null,
      approver: body.approver ?? null,
    };

    const columnMap: Record<string, string> = {
      approvalId: '"approvalId"',
      department: 'department',
      budgetYear: '"budgetYear"',
      recordNumber: '"recordNumber"',
      requestDate: '"requestDate"',
      productName: '"productName"',
      productCode: '"productCode"',
      category: 'category',
      productType: '"productType"',
      productSubtype: '"productSubtype"',
      requestedQuantity: '"requestedQuantity"',
      unit: 'unit',
      pricePerUnit: '"pricePerUnit"',
      totalValue: '"totalValue"',
      overPlanCase: '"overPlanCase"',
      requester: 'requester',
      approver: 'approver',
    };

    const assignments: string[] = [];
    const values: unknown[] = [];
    Object.entries(data).forEach(([key, value]) => {
      if (value === undefined) return;
      const column = columnMap[key];
      if (!column) return;
      values.push(value);
      assignments.push(`${column} = $${values.length}`);
    });

    if (assignments.length === 0) {
      const unchanged = await pgQuery('SELECT id, "approvalId", department, "budgetYear", "recordNumber", "requestDate", "productName", "productCode", category, "productType", "productSubtype", "requestedQuantity", unit, "pricePerUnit"::float8 AS "pricePerUnit", "totalValue"::float8 AS "totalValue", "overPlanCase", requester, approver, created_at, updated_at FROM public."PurchaseApproval" WHERE id = $1 LIMIT 1', [numericId]);
      return NextResponse.json(unchanged.rows[0]);
    }

    assignments.push('updated_at = CURRENT_TIMESTAMP');
    values.push(numericId);
    const updated = await pgQuery(
      `UPDATE public."PurchaseApproval" SET ${assignments.join(', ')} WHERE id = $${values.length}
       RETURNING id, "approvalId", department, "budgetYear", "recordNumber", "requestDate", "productName", "productCode", category, "productType", "productSubtype", "requestedQuantity", unit, "pricePerUnit"::float8 AS "pricePerUnit", "totalValue"::float8 AS "totalValue", "overPlanCase", requester, approver, created_at, updated_at`,
      values
    );
    return NextResponse.json(updated.rows[0]);
  } catch (error) {
    console.error('Error updating purchase approval:', error);
    return NextResponse.json({ error: 'Failed to update purchase approval' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const numericId = parseInt(id, 10);

    if (isNaN(numericId)) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    await pgQuery('DELETE FROM public."PurchaseApproval" WHERE id = $1', [numericId]);
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting purchase approval:', error);
    return NextResponse.json({ error: 'Failed to delete purchase approval' }, { status: 500 });
  }
}
