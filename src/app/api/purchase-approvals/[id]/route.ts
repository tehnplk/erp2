import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { createPurchaseApprovalSchema, idParamSchema } from '@/lib/validation/schemas';
import { findDepartmentCodeByName } from '@/lib/department-code';

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;
    const body = await request.json();
    const validation = await validateRequest(createPurchaseApprovalSchema.partial(), body);
    if (!validation.success) {
      return validation.error;
    }

    const existingResult = await pgQuery('SELECT id FROM public.purchase_approval WHERE id = $1 LIMIT 1', [numericId]);
    if (existingResult.rows.length === 0) {
      return NextResponse.json({ error: 'Purchase approval not found' }, { status: 404 });
    }

    const data: Record<string, unknown> = {
      approval_id: validation.data.approval_id ?? null,
      department: validation.data.department ?? null,
      department_code: validation.data.department === undefined
        ? undefined
        : await findDepartmentCodeByName(validation.data.department ?? null),
      budget_year: validation.data.budget_year ?? null,
      record_number: validation.data.record_number ?? null,
      request_date: validation.data.request_date ?? null,
      product_name: validation.data.product_name ?? null,
      product_code: validation.data.product_code ?? null,
      category: validation.data.category ?? null,
      product_type: validation.data.product_type ?? null,
      product_subtype: validation.data.product_subtype ?? null,
      requested_quantity: validation.data.requested_quantity ?? null,
      unit: validation.data.unit ?? null,
      price_per_unit: validation.data.price_per_unit ?? undefined,
      total_value: validation.data.total_value ?? undefined,
      over_plan_case: validation.data.over_plan_case ?? null,
      requester: validation.data.requester ?? null,
      approver: validation.data.approver ?? null,
    };

    const columnMap: Record<string, string> = {
      approval_id: 'approval_id',
      department: 'department',
      department_code: 'department_code',
      budget_year: 'budget_year',
      record_number: 'record_number',
      request_date: 'request_date',
      product_name: 'product_name',
      product_code: 'product_code',
      category: 'category',
      product_type: 'product_type',
      product_subtype: 'product_subtype',
      requested_quantity: 'requested_quantity',
      unit: 'unit',
      price_per_unit: 'price_per_unit',
      total_value: 'total_value',
      over_plan_case: 'over_plan_case',
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
      const unchanged = await pgQuery('SELECT id, approval_id, department, department_code, budget_year, record_number, request_date, product_name, product_code, category, product_type, product_subtype, requested_quantity, unit, price_per_unit::float8 AS price_per_unit, total_value::float8 AS total_value, over_plan_case, requester, approver, created_at, updated_at FROM public.purchase_approval WHERE id = $1 LIMIT 1', [numericId]);
      return NextResponse.json(unchanged.rows[0]);
    }

    assignments.push('updated_at = CURRENT_TIMESTAMP');
    values.push(numericId);
    const updated = await pgQuery(
      `UPDATE public.purchase_approval SET ${assignments.join(', ')} WHERE id = $${values.length}
       RETURNING id, approval_id, department, department_code, budget_year, record_number, request_date, product_name, product_code, category, product_type, product_subtype, requested_quantity, unit, price_per_unit::float8 AS price_per_unit, total_value::float8 AS total_value, over_plan_case, requester, approver, created_at, updated_at`,
      values
    );
    await cacheDelByPattern('erp:purchase:approvals:list:*');
    return NextResponse.json(updated.rows[0]);
  } catch (error) {
    console.error('Error updating purchase approval:', error);
    return NextResponse.json({ error: 'Failed to update purchase approval' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;

    await pgQuery('DELETE FROM public.purchase_approval WHERE id = $1', [numericId]);
    await cacheDelByPattern('erp:purchase:approvals:list:*');
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting purchase approval:', error);
    return NextResponse.json({ error: 'Failed to delete purchase approval' }, { status: 500 });
  }
}
