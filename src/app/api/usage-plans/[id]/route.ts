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
      `SELECT id, product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit::float8 AS price_per_unit, requesting_dept, approved_quota, budget_year, sequence_no, created_at, updated_at FROM public.usage_plan WHERE id = $1 LIMIT 1`,
      [numericId]
    );
    const currentUsagePlan = currentUsagePlanResult.rows[0];

    if (!currentUsagePlan) {
      return NextResponse.json({ error: 'Usage plan not found' }, { status: 404 });
    }

    const nextData = {
      ...currentUsagePlan,
      ...(validation.data as any),
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
        requesting_dept: nextData.requesting_dept || null,
        product_code: nextData.product_code || null,
      };

      const existingRecordsResult = await pgQuery(
        `SELECT id, sequence_no FROM public.usage_plan WHERE budget_year = $1 AND requesting_dept IS NOT DISTINCT FROM $2 AND product_code IS NOT DISTINCT FROM $3`,
        [duplicateWhere.budget_year, duplicateWhere.requesting_dept, duplicateWhere.product_code]
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
      ...(validation.data as any),
      budget_year: nextData.budget_year,
      sequence_no: nextData.sequence_no,
    };
    const assignments: string[] = [];
    const values: unknown[] = [];
    const columnMap: Record<string, string> = {
      product_code: 'product_code',
      category: 'category',
      type: 'type',
      subtype: 'subtype',
      product_name: 'product_name',
      requested_amount: 'requested_amount',
      unit: 'unit',
      price_per_unit: 'price_per_unit',
      requesting_dept: 'requesting_dept',
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
    const usagePlan = await pgQuery(
      `UPDATE public.usage_plan SET ${assignments.join(', ')}, updated_at = NOW() WHERE id = $${values.length} RETURNING id, product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit::float8 AS price_per_unit, requesting_dept, approved_quota, budget_year, sequence_no, created_at, updated_at`,
      values
    );
    
    await cacheDelByPattern('erp:usage_plans:list:*');
    
    return NextResponse.json(usagePlan.rows[0]);
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
