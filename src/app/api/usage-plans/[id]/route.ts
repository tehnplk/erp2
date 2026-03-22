import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, update_usage_plan_schema } from '@/lib/validation/schemas';

const buildUsagePlanConstraintError = () =>
  NextResponse.json(
    { error: 'สินค้าเดิม หน่วยงานเดิม และปีงบเดิม สามารถมีได้ไม่เกิน 2 ครั้ง' },
    { status: 400 }
  );

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
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

    const validation = await validateRequest(update_usage_plan_schema, body);
    if (!validation.success) {
      return validation.error;
    }

    const currentUsagePlanResult = await pgQuery(
      `SELECT id, product_code, requested_amount, requesting_dept_code, approved_quota, budget_year, sequence_no, created_at, updated_at FROM public.usage_plan WHERE id = $1 LIMIT 1`,
      [numericId]
    );
    const currentUsagePlan = currentUsagePlanResult.rows[0];

    if (!currentUsagePlan) {
      return NextResponse.json({ error: 'Usage plan not found' }, { status: 404 });
    }

    const requestBody = (body && typeof body === 'object' ? body : {}) as Record<string, unknown>;
    const validatedPayload = Object.fromEntries(
      Object.entries(validation.data as Record<string, unknown>).filter(
        ([key, value]) => Object.prototype.hasOwnProperty.call(requestBody, key) && value !== undefined
      )
    );

    const nextData = {
      ...currentUsagePlan,
      ...validatedPayload,
    };

    if (nextData.budget_year === null || nextData.budget_year === undefined) {
      nextData.budget_year = currentUsagePlan.budget_year ?? 2569;
    }

    if (nextData.sequence_no === null || nextData.sequence_no === undefined) {
      nextData.sequence_no = currentUsagePlan.sequence_no ?? 1;
    }

    if (nextData.budget_year !== null && nextData.budget_year !== undefined) {
      const duplicateWhere: any = {
        budget_year: nextData.budget_year,
        requesting_dept_code: nextData.requesting_dept_code || null,
        product_code: nextData.product_code || null,
      };

      const existingRecordsResult = await pgQuery(
        `SELECT id, sequence_no FROM public.usage_plan WHERE budget_year = $1 AND requesting_dept_code IS NOT DISTINCT FROM $2 AND product_code IS NOT DISTINCT FROM $3`,
        [duplicateWhere.budget_year, duplicateWhere.requesting_dept_code, duplicateWhere.product_code]
      );
      const recordsExcludingCurrent = existingRecordsResult.rows.filter((usagePlan: any) => usagePlan.id !== numericId);

      if (nextData.sequence_no !== null && nextData.sequence_no !== undefined) {
        const duplicatedSequence = recordsExcludingCurrent.some((usagePlan: any) => usagePlan.sequence_no === nextData.sequence_no);
        if (duplicatedSequence) {
          return buildUsagePlanConstraintError();
        }
      }

      if (recordsExcludingCurrent.length >= 2) {
        return buildUsagePlanConstraintError();
      }
    }
    
    const payload = {
      ...validatedPayload,
      budget_year: nextData.budget_year,
      sequence_no: nextData.sequence_no,
    };
    const assignments: string[] = [];
    const values: unknown[] = [];
    const columnMap: Record<string, string> = {
      product_code: 'product_code',
      requested_amount: 'requested_amount',
      requesting_dept_code: 'requesting_dept_code',
      approved_quota: 'approved_quota',
      budget_year: 'budget_year',
      sequence_no: 'sequence_no',
    };

    Object.entries(payload).forEach(([key, value]) => {
      const column = columnMap[key];
      if (!column) return;
      values.push(value ?? null);
      assignments.push(`${column} = $${values.length}`);
    });

    if (assignments.length === 0) {
      return NextResponse.json(currentUsagePlan);
    }

    values.push(numericId);
    await pgQuery(
      `UPDATE public.usage_plan SET ${assignments.join(', ')}, updated_at = NOW() WHERE id = $${values.length} RETURNING id`,
      values
    );

    const usagePlan = await pgQuery(
      `SELECT
        up.id,
        up.product_code,
        p.name AS product_name,
        p.category,
        c.type,
        c.subtype,
        up.requested_amount,
        p.unit,
        COALESCE(p.cost_price, 0)::float8 AS price_per_unit,
        up.requesting_dept_code,
        COALESCE(d.name, up.requesting_dept_code) AS requesting_dept,
        up.approved_quota,
        up.budget_year,
        up.sequence_no,
        up.created_at,
        up.updated_at,
        CASE WHEN pp.id IS NOT NULL THEN true ELSE false END AS has_purchase_plan,
        CASE WHEN EXISTS (SELECT 1 FROM public.purchase_approval_detail pad WHERE pad.purchase_plan_id = pp.id) THEN true ELSE false END AS has_purchase_approval
      FROM public.usage_plan up
      LEFT JOIN public.product p ON p.code = up.product_code
      LEFT JOIN public.department d ON d.department_code = up.requesting_dept_code
      LEFT JOIN public.category c ON c.category = p.category
      LEFT JOIN public.purchase_plan pp ON pp.usage_plan_id = up.id
      WHERE up.id = $1
      LIMIT 1`,
      [numericId]
    );
    
    await cacheDelByPattern('erp:usage_plans:list:*');
    
    return NextResponse.json(usagePlan.rows[0] || currentUsagePlan);
  } catch (error) {
    console.error('Error updating usage plan:', error);
    return NextResponse.json(
      { error: 'Failed to update usage plan' },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
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
    
    await pgQuery('DELETE FROM public.usage_plan WHERE id = $1', [numericId]);
    
    await cacheDelByPattern('erp:usage_plans:list:*');
    
    return NextResponse.json({ message: 'Usage plan deleted successfully' });
  } catch (error) {
    console.error('Error deleting usage plan:', error);
    return NextResponse.json(
      { error: 'Failed to delete usage plan' },
      { status: 500 }
    );
  }
}
