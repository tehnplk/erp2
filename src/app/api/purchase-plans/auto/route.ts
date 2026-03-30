import { NextRequest } from 'next/server';
import { pgPool } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { allocatePurchasePlanId } from '@/lib/purchase-plan';

type AutoGroupRow = {
  product_code: string;
  budget_year: number | null;
  purchase_department_id: number | null;
  usage_plan_ids: number[];
};

export async function POST(_request: NextRequest) {
  const client = await pgPool.connect();

  try {
    await client.query('BEGIN');

    const groupedResult = await client.query<AutoGroupRow>(
       `SELECT
          up.product_code,
          up.budget_year,
          COALESCE(p.purchase_department_id, 0)::int AS purchase_department_id,
          ARRAY_AGG(up.id ORDER BY up.id) AS usage_plan_ids
        FROM public.usage_plan up
       LEFT JOIN public.product p ON p.code = up.product_code
        WHERE up.purchase_plan_id IS NULL
          AND up.plan_flag = 'ในแผน'
          AND up.product_code IS NOT NULL
        GROUP BY up.product_code, up.budget_year, COALESCE(p.purchase_department_id, 0)
        ORDER BY up.product_code, up.budget_year, COALESCE(p.purchase_department_id, 0)`,
    );

    if (groupedResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return apiSuccess(
        { created_count: 0, linked_usage_plan_count: 0 },
        'ไม่พบรายการแผนการใช้ที่เป็นในแผนและยังไม่มี purchase_plan_id สำหรับสร้างแผนจัดซื้ออัตโนมัติ',
      );
    }

    let createdCount = 0;
    let linkedUsagePlanCount = 0;

    for (const group of groupedResult.rows) {
      const usagePlanIds = Array.isArray(group.usage_plan_ids)
        ? group.usage_plan_ids.map((id) => Number(id)).filter((id) => Number.isInteger(id) && id > 0)
        : [];

      if (usagePlanIds.length === 0) {
        continue;
      }

      const targetBudgetYear = Number(group.budget_year ?? 0);
      if (!Number.isFinite(targetBudgetYear) || targetBudgetYear <= 0) {
        continue;
      }
      const targetPurchaseDepartmentId = Number(group.purchase_department_id ?? 0);

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
           AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = 'ในแผน'
         GROUP BY purchase_plan_id
         ORDER BY purchase_plan_id`,
        [group.product_code, targetBudgetYear, targetPurchaseDepartmentId],
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
             AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = 'ในแผน'`,
          [purchasePlanId, duplicatePlanIds, group.product_code, targetBudgetYear, targetPurchaseDepartmentId],
        );


      }

      const updateResult = await client.query(
        `UPDATE public.usage_plan
         SET purchase_plan_id = $1,
             plan_flag = 'ในแผน',
             updated_at = NOW()
         WHERE id = ANY($2::int[])
           AND purchase_plan_id IS NULL`,
        [purchasePlanId, usagePlanIds],
      );

      const quotaResult = await client.query<{ total_quota: number }>(
        `SELECT COALESCE(SUM(GREATEST(COALESCE(approved_quota, requested_amount, 0), 0)), 0)::int AS total_quota
         FROM public.usage_plan
         WHERE purchase_plan_id = $1
           AND product_code = $2
           AND budget_year = $3
           AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = 'ในแผน'`,
        [purchasePlanId, group.product_code, targetBudgetYear],
      );

      const inventoryResult = await client.query<{ inventory_qty: number }>(
        `SELECT COALESCE(SUM(isl.qty_on_hand), 0)::int AS inventory_qty
         FROM public.inventory_stock_lot isl
         INNER JOIN public.product p_stock ON p_stock.id = isl.product_id
         WHERE p_stock.code = $1`,
        [group.product_code],
      );

      const qoutaQty = Number(quotaResult.rows[0]?.total_quota ?? 0);
      const inventoryQty = Number(inventoryResult.rows[0]?.inventory_qty ?? 0);
      const purchaseQty = Math.max(qoutaQty - inventoryQty, 0);



      if (existingPlanResult.rows.length === 0) {
        createdCount += 1;
      }
      linkedUsagePlanCount += Number(updateResult.rowCount ?? 0);
    }

    await client.query('COMMIT');

    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');
    await cacheDelByPattern('erp:usage_plans:list:*');

    return apiSuccess(
      {
        created_count: createdCount,
        linked_usage_plan_count: linkedUsagePlanCount,
      },
      `สร้างแผนจัดซื้ออัตโนมัติสำเร็จ ${createdCount} รายการ`,
    );
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error auto creating purchase plans:', error);
    return apiError('Failed to auto create purchase plans');
  } finally {
    client.release();
  }
}



