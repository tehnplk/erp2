import { NextRequest, NextResponse } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, update_usage_plan_schema } from '@/lib/validation/schemas';

const buildUsagePlanConstraintError = () =>
  NextResponse.json(
    { error: 'สินค้าเดิม หน่วยงานเดิม และปีงบเดิม สามารถมีได้ไม่เกิน 2 ครั้ง' },
    { status: 400 }
  );

type UsagePlanRecord = {
  id: number;
  product_code: string | null;
  requested_amount: number | null;
  requesting_dept_code: string | null;
  plan_flag: string | null;
  approved_quota: number | null;
  budget_year: number | null;
  sequence_no: number | null;
  purchase_plan_id: number | null;
  created_at: string | Date | null;
  updated_at: string | Date | null;
};

async function syncLinkedPurchasePlanArtifacts(
  client: Awaited<ReturnType<typeof pgPool.connect>>,
  purchasePlanId: number
) {
  const summaryResult = await client.query<{
    product_code: string | null;
    approved_quota: number | null;
  }>(
    `SELECT
       MIN(up.product_code) AS product_code,
       COALESCE(SUM(COALESCE(up.approved_quota, 0)), 0)::int AS approved_quota
     FROM public.usage_plan up
     WHERE up.purchase_plan_id = $1`,
    [purchasePlanId]
  );

  const summary = summaryResult.rows[0];
  if (!summary) {
    return;
  }

  const productCode = summary.product_code ?? null;
  const approvedQuota = Number(summary.approved_quota ?? 0);

  const inventoryResult = await client.query<{ inventory_qty: number }>(
    `SELECT COALESCE(SUM(isl.qty_on_hand), 0)::int AS inventory_qty
     FROM public.inventory_stock_lot isl
     INNER JOIN public.product p_stock ON p_stock.id = isl.product_id
     WHERE p_stock.code = $1`,
    [productCode]
  );

  const inventoryQty = Number(inventoryResult.rows[0]?.inventory_qty ?? 0);
  const purchaseQty = Math.max(approvedQuota - inventoryQty, 0);

  await client.query(
    `UPDATE public.purchase_plan
     SET qouta_qty = $1,
         inventory_qty = $2,
         purchase_qty = $3
     WHERE id = $4`,
    [approvedQuota, inventoryQty, purchaseQty, purchasePlanId]
  );

  const detailResult = await client.query<{
    id: number;
    purchase_approval_id: number;
  }>(
    `SELECT id, purchase_approval_id
     FROM public.purchase_approval_detail
     WHERE purchase_plan_id = $1`,
    [purchasePlanId]
  );

  if (detailResult.rows.length === 0) {
    return;
  }

  const unitPriceResult = await client.query<{ unit_price: number }>(
    `SELECT COALESCE(p.cost_price, 0)::float8 AS unit_price
     FROM public.product p
     WHERE p.code = $1
     LIMIT 1`,
    [productCode]
  );

  const unitPrice = Number(unitPriceResult.rows[0]?.unit_price ?? 0);
  const amount = Number((purchaseQty * unitPrice).toFixed(2));

  for (const detail of detailResult.rows) {
    await client.query(
      `UPDATE public.purchase_approval_detail
       SET proposed_quantity = $1,
           proposed_amount = $2,
           approved_quantity = $1,
           approved_amount = $2,
           cal_unit_price = $3,
           updated_at = NOW()
       WHERE id = $4`,
      [purchaseQty, amount, unitPrice, detail.id]
    );
  }

  const affectedApprovalIds = Array.from(new Set(detailResult.rows.map((detail) => detail.purchase_approval_id)));
  for (const approvalId of affectedApprovalIds) {
    await client.query(
      `UPDATE public.purchase_approval pa
       SET total_items = COALESCE(detail_summary.total_items, 0),
           total_amount = COALESCE(detail_summary.total_amount, 0),
           updated_at = NOW()
       FROM (
         SELECT
           COUNT(*)::int AS total_items,
           COALESCE(SUM(COALESCE(pad.proposed_amount, pad.approved_amount, 0)), 0)::numeric AS total_amount
         FROM public.purchase_approval_detail pad
         WHERE pad.purchase_approval_id = $1
       ) detail_summary
       WHERE pa.id = $1`,
      [approvalId]
    );
  }
}

async function invalidateUsagePlanCascadeCaches() {
  try {
    await Promise.all([
      cacheDelByPattern('erp:usage_plans:list:*'),
      cacheDelByPattern('erp:purchase:plans:list:*'),
      cacheDelByPattern('erp:purchase:plans:filters*'),
      cacheDelByPattern('erp:purchase:approvals:list:*'),
      cacheDelByPattern('erp:purchase:approvals:filters*'),
    ]);
  } catch (error) {
    console.error('Cache invalidation after usage-plan update failed:', error);
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const client = await pgPool.connect();

  try {
    await client.query('BEGIN');

    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      await client.query('ROLLBACK');
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;
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
        purchase_plan_id,
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

    if (nextData.budget_year === null || nextData.budget_year === undefined) {
      nextData.budget_year = currentUsagePlan.budget_year ?? 2569;
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
      const existingRecordsResult = await client.query<{ id: number; sequence_no: number }>(
        `SELECT id, sequence_no
         FROM public.usage_plan
         WHERE budget_year = $1
           AND requesting_dept_code IS NOT DISTINCT FROM $2
           AND product_code IS NOT DISTINCT FROM $3`,
        [nextData.budget_year, nextData.requesting_dept_code || null, nextData.product_code || null]
      );
      const recordsExcludingCurrent = existingRecordsResult.rows.filter((usagePlan) => usagePlan.id !== numericId);

      if (sequenceChanged && nextData.sequence_no !== null && nextData.sequence_no !== undefined) {
        const duplicatedSequence = recordsExcludingCurrent.some((usagePlan) => usagePlan.sequence_no === nextData.sequence_no);
        if (duplicatedSequence) {
          await client.query('ROLLBACK');
          return buildUsagePlanConstraintError();
        }
      }

      if (identityChanged && recordsExcludingCurrent.length >= 2) {
        await client.query('ROLLBACK');
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

    if (currentUsagePlan.purchase_plan_id) {
      await syncLinkedPurchasePlanArtifacts(client, currentUsagePlan.purchase_plan_id);
    }

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
        CASE WHEN up.purchase_plan_id IS NOT NULL THEN true ELSE false END AS has_purchase_plan,
        CASE WHEN EXISTS (SELECT 1 FROM public.purchase_approval_detail pad WHERE pad.purchase_plan_id = up.purchase_plan_id) THEN true ELSE false END AS has_purchase_approval
      FROM public.usage_plan up
      LEFT JOIN public.product p ON p.code = up.product_code
      LEFT JOIN public.department d ON d.department_code = up.requesting_dept_code
      LEFT JOIN public.category c ON c.category = p.category
      WHERE up.id = $1
      LIMIT 1`,
      [numericId]
    );

    await client.query('COMMIT');
    await invalidateUsagePlanCascadeCaches();

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
