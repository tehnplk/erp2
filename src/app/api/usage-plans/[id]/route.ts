import { NextRequest, NextResponse } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, update_usage_plan_schema } from '@/lib/validation/schemas';
import { getConfiguredBudgetYear } from '@/lib/budget-year';
import { usagePlanHasPurchaseApproval, usagePlanHasPurchaseApprovalSql } from '@/lib/purchase-plan';
import { USAGE_PLAN_LIMIT_MESSAGE, claimUsagePlanSequence } from '@/lib/usage-plan';
import { forbidOtherDepartment, invalidateUsagePlanCaches, requireUsagePlanActor } from '@/lib/usage-plan-server';

type UsagePlanRecord = {
  id: number;
  product_code: string | null;
  requested_amount: number | null;
  requesting_dept_code: string | null;
  plan_flag: string | null;
  approved_quota: number | null;
  budget_year: number | null;
  sequence_no: number | null;
  created_at: string | Date | null;
  updated_at: string | Date | null;
};

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const access = await requireUsagePlanActor();
  if ('response' in access) return access.response;

  const { id } = await params;
  const parsedId = idParamSchema.safeParse({ id });
  if (!parsedId.success) {
    return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
  }
  const numericId = parsedId.data.id;

  const client = await pgPool.connect();
  const query = (text: string, values?: unknown[]) => client.query(text, values);

  try {
    await client.query('BEGIN');

    const body = await request.json();

    const validation = await validateRequest(update_usage_plan_schema, body);
    if (!validation.success) {
      await client.query('ROLLBACK');
      return validation.error;
    }

    const currentUsagePlanResult = await client.query<UsagePlanRecord>(
      `SELECT
        id,
        product_code,
        requested_amount,
        requesting_dept_code,
        plan_flag,
        approved_quota,
        budget_year,
        sequence_no,
        created_at,
        updated_at
      FROM public.usage_plan
      WHERE id = $1
      LIMIT 1`,
      [numericId]
    );

    const currentUsagePlan = currentUsagePlanResult.rows[0];
    if (!currentUsagePlan) {
      await client.query('ROLLBACK');
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

    const forbidden = forbidOtherDepartment(
      access.actor,
      currentUsagePlan.requesting_dept_code,
      nextData.requesting_dept_code
    );
    if (forbidden) {
      await client.query('ROLLBACK');
      return forbidden;
    }

    if (nextData.budget_year === null || nextData.budget_year === undefined) {
      nextData.budget_year = currentUsagePlan.budget_year ?? (await getConfiguredBudgetYear(query));
    }

    if (nextData.sequence_no === null || nextData.sequence_no === undefined) {
      nextData.sequence_no = currentUsagePlan.sequence_no ?? 1;
    }

    const identityChanged =
      nextData.budget_year !== currentUsagePlan.budget_year ||
      nextData.requesting_dept_code !== currentUsagePlan.requesting_dept_code ||
      nextData.product_code !== currentUsagePlan.product_code;
    const sequenceChanged = nextData.sequence_no !== currentUsagePlan.sequence_no;

    if (identityChanged || sequenceChanged) {
      const claimedSequenceNo = await claimUsagePlanSequence(
        query,
        {
          budgetYear: nextData.budget_year,
          requestingDeptCode: nextData.requesting_dept_code || null,
          productCode: nextData.product_code || null,
        },
        nextData.sequence_no,
        numericId
      );
      if (claimedSequenceNo === null) {
        await client.query('ROLLBACK');
        return NextResponse.json({ error: USAGE_PLAN_LIMIT_MESSAGE }, { status: 400 });
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
      plan_flag: 'plan_flag',
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
      await client.query('COMMIT');
      return NextResponse.json(currentUsagePlan);
    }

    values.push(numericId);
    await client.query(
      `UPDATE public.usage_plan
       SET ${assignments.join(', ')}, updated_at = NOW()
       WHERE id = $${values.length}
       RETURNING id`,
      values
    );

    const usagePlan = await client.query(
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
        COALESCE(up.plan_flag, 'ในแผน') AS plan_flag,
        up.approved_quota,
        up.budget_year,
        up.sequence_no,
        up.created_at,
        up.updated_at,
        ${usagePlanHasPurchaseApprovalSql('up')} AS has_purchase_approval
      FROM public.usage_plan up
      LEFT JOIN public.product p ON p.code = up.product_code
      LEFT JOIN public.department d ON d.department_code = up.requesting_dept_code
      LEFT JOIN public.category c ON c.category = p.category
      WHERE up.id = $1
      LIMIT 1`,
      [numericId]
    );

    await client.query('COMMIT');
    await invalidateUsagePlanCaches();

    return NextResponse.json(usagePlan.rows[0] || currentUsagePlan);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error updating usage plan:', error);
    return NextResponse.json(
      { error: 'Failed to update usage plan' },
      { status: 500 }
    );
  } finally {
    client.release();
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const access = await requireUsagePlanActor();
  if ('response' in access) return access.response;

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

    const existingResult = await pgQuery<{ requesting_dept_code: string | null }>(
      'SELECT requesting_dept_code FROM public.usage_plan WHERE id = $1',
      [numericId]
    );
    const existing = existingResult.rows[0];
    if (!existing) {
      return NextResponse.json({ error: 'Usage plan not found' }, { status: 404 });
    }

    const forbidden = forbidOtherDepartment(access.actor, existing.requesting_dept_code);
    if (forbidden) return forbidden;

    if (await usagePlanHasPurchaseApproval(pgQuery, numericId)) {
      return NextResponse.json(
        { error: 'รายการนี้ถูกใช้ในเอกสารอนุมัติแล้ว จึงไม่สามารถลบได้' },
        { status: 400 }
      );
    }

    await pgQuery('DELETE FROM public.usage_plan WHERE id = $1', [numericId]);

    await invalidateUsagePlanCaches();

    return NextResponse.json({ message: 'Usage plan deleted successfully' });
  } catch (error) {
    console.error('Error deleting usage plan:', error);
    return NextResponse.json(
      { error: 'Failed to delete usage plan' },
      { status: 500 }
    );
  }
}
