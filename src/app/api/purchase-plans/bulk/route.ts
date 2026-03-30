import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { allocatePurchasePlanId } from '@/lib/purchase-plan';

interface BulkPurchasePlanRequest {
  usage_plan_ids: number[];
}

interface BulkDeleteRequest {
  ids: number[];
}

function normalizePlanFlag(value: string | null | undefined) {
  return value === 'นอกแผน' ? 'นอกแผน' : 'ในแผน';
}

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    await client.query('BEGIN');

    const body = (await request.json()) as BulkPurchasePlanRequest;
    const usagePlanIds = Array.isArray(body.usage_plan_ids)
      ? body.usage_plan_ids.map((id) => Number(id)).filter((id) => Number.isInteger(id) && id > 0)
      : [];

    if (usagePlanIds.length === 0) {
      await client.query('ROLLBACK');
      return apiError('กรุณาระบุ usage_plan_ids ที่ต้องการสร้างแผนจัดซื้อ', 400);
    }

    const usagePlansResult = await client.query<{
      id: number;
      product_code: string | null;
      budget_year: number | null;
      purchase_department_id: number | null;
      approved_quota: number | null;
      requested_amount: number | null;
      purchase_plan_id: number | null;
      plan_flag: string | null;
    }>(
      `SELECT
         up.id,
         up.product_code,
         up.budget_year,
         COALESCE(p.purchase_department_id, 0)::int AS purchase_department_id,
         up.approved_quota,
         up.requested_amount,
         up.purchase_plan_id,
         up.plan_flag
       FROM public.usage_plan up
       LEFT JOIN public.product p ON p.code = up.product_code
       WHERE up.id = ANY($1::int[])
         AND up.approved_quota > 0`,
      [usagePlanIds],
    );

    if (usagePlansResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return apiError('ไม่พบรายการที่ตรงเงื่อนไขหรือไม่มีโควต้าที่อนุมัติ', 400);
    }

    const eligiblePlans = usagePlansResult.rows.filter((row) => row.purchase_plan_id === null);
    if (eligiblePlans.length === 0) {
      await client.query('ROLLBACK');
      return apiError('รายการที่เลือกถูกสร้างแผนจัดซื้อไว้แล้ว', 400);
    }

    const productCodes = Array.from(
      new Set(eligiblePlans.map((row) => row.product_code).filter((code): code is string => Boolean(code))),
    );
    if (productCodes.length !== 1) {
      await client.query('ROLLBACK');
      return apiError('usage_plan ที่เลือกต้องมีรหัสสินค้าเดียวกันทั้งหมด', 400);
    }

    const budgetYears = Array.from(
      new Set(eligiblePlans.map((row) => Number(row.budget_year)).filter((year) => Number.isFinite(year) && year > 0)),
    );
    if (budgetYears.length !== 1) {
      await client.query('ROLLBACK');
      return apiError('usage_plan ที่เลือกต้องอยู่ในปีงบเดียวกันทั้งหมด', 400);
    }

    const purchaseDepartmentIds = Array.from(
      new Set(eligiblePlans.map((row) => Number(row.purchase_department_id)).filter((id) => Number.isFinite(id) && id >= 0)),
    );
    if (purchaseDepartmentIds.length !== 1) {
      await client.query('ROLLBACK');
      return apiError('usage_plan ที่เลือกต้องมีหน่วยงานจัดซื้อเดียวกันทั้งหมด', 400);
    }

    const planFlags = Array.from(new Set(eligiblePlans.map((row) => normalizePlanFlag(row.plan_flag))));
    if (planFlags.length !== 1) {
      await client.query('ROLLBACK');
      return apiError('usage_plan ที่เลือกต้องเป็นประเภทแผนเดียวกันทั้งหมด', 400);
    }

    const productCode = productCodes[0];
    const budgetYear = budgetYears[0];
    const purchaseDepartmentId = purchaseDepartmentIds[0];
    const planFlag = planFlags[0];

    const existingPlanResult = await client.query<{ id: number }>(
      `SELECT purchase_plan_id AS id
       FROM public.usage_plan
       WHERE purchase_plan_id IS NOT NULL
         AND product_code = $1
         AND budget_year = $2
         AND EXISTS (
           SELECT 1
           FROM public.product p
           WHERE p.code = public.usage_plan.product_code
             AND COALESCE(p.purchase_department_id, 0) = $3
         )
         AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = $4
       GROUP BY purchase_plan_id
       ORDER BY purchase_plan_id`,
      [productCode, budgetYear, purchaseDepartmentId, planFlag],
    );

    let purchasePlanId = Number(existingPlanResult.rows[0]?.id ?? 0);
    if (!purchasePlanId) {
      purchasePlanId = await allocatePurchasePlanId(client);
    }

    const duplicatePlanIds = existingPlanResult.rows
      .slice(1)
      .map((row) => Number(row.id))
      .filter((id) => Number.isInteger(id) && id > 0);

    if (duplicatePlanIds.length > 0) {
        await client.query(
         `UPDATE public.usage_plan
           SET purchase_plan_id = $1,
               updated_at = NOW()
           WHERE purchase_plan_id = ANY($2::int[])
             AND product_code = $3
             AND budget_year = $4
             AND EXISTS (
               SELECT 1
               FROM public.product p
               WHERE p.code = public.usage_plan.product_code
                 AND COALESCE(p.purchase_department_id, 0) = $5
             )
             AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = $6`,
        [purchasePlanId, duplicatePlanIds, productCode, budgetYear, purchaseDepartmentId, planFlag],
      );
    }

    const updateResult = await client.query(
      `UPDATE public.usage_plan
       SET purchase_plan_id = $1,
           plan_flag = $2,
           updated_at = NOW()
       WHERE id = ANY($3::int[])
         AND purchase_plan_id IS NULL`,
      [purchasePlanId, planFlag, usagePlanIds],
    );

    if (updateResult.rowCount !== eligiblePlans.length) {
      await client.query('ROLLBACK');
      return apiError('มีบางรายการถูกผูกกับแผนจัดซื้อแล้ว กรุณารีเฟรชข้อมูลและลองใหม่', 409);
    }

    await client.query('COMMIT');

    const createdPlanResult = await pgQuery('SELECT * FROM public.purchase_plan WHERE id = $1', [purchasePlanId]);

    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');
    await cacheDelByPattern('erp:usage:plans:available*');
    await cacheDelByPattern('erp:surveys:list:*');

    return apiSuccess(
      {
        created_count: existingPlanResult.rows.length === 0 ? 1 : 0,
        created_plans: createdPlanResult.rows,
        linked_usage_plan_count: updateResult.rowCount ?? eligiblePlans.length,
        skipped_count: usagePlansResult.rows.length - eligiblePlans.length,
      },
      `สร้างแผนจัดซื้อ ${existingPlanResult.rows.length === 0 ? 'ใหม่' : 'เพิ่มรายการ'} สำเร็จ`,
      undefined,
      201,
    );
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error creating bulk purchase plans:', error);
    return apiError('Failed to create bulk purchase plans');
  } finally {
    client.release();
  }
}

export async function DELETE(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    await client.query('BEGIN');

    const body = (await request.json()) as BulkDeleteRequest;
    const ids = Array.isArray(body.ids)
      ? body.ids.map((id) => Number(id)).filter((id) => Number.isInteger(id) && id > 0)
      : [];

    if (ids.length === 0) {
      await client.query('ROLLBACK');
      return apiError('No valid IDs provided', 400);
    }

    const approvalResult = await client.query<{ purchase_plan_id: number }>(
      `SELECT DISTINCT purchase_plan_id
       FROM public.purchase_approval_detail
       WHERE purchase_plan_id = ANY($1::int[])`,
      [ids],
    );

    if (approvalResult.rows.length > 0) {
      await client.query('ROLLBACK');
      return apiError('ไม่สามารถยกเลิกแผนจัดซื้อที่ถูกอ้างอิงในเอกสารอนุมัติได้', 409);
    }

    const result = await client.query(
      `UPDATE public.usage_plan
       SET purchase_plan_id = NULL,
           updated_at = NOW()
       WHERE purchase_plan_id = ANY($1::int[])
       RETURNING id`,
      [ids],
    );

    await client.query('COMMIT');

    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');

    return apiSuccess(
      { deleted: result.rowCount ?? 0, ids },
      `ยกเลิกการผูกแผนจัดซื้อ ${result.rowCount ?? 0} รายการสำเร็จ`,
    );
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error deleting bulk purchase plans:', error);
    return apiError('Failed to delete bulk purchase plans');
  } finally {
    client.release();
  }
}
