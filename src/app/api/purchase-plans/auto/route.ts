import { NextRequest } from 'next/server';
import { pgPool } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';

type AutoGroupRow = {
  product_code: string;
  purchase_department_id: number | null;
  usage_plan_ids: number[];
  total_quota: number;
};

export async function POST(_request: NextRequest) {
  const client = await pgPool.connect();

  try {
    await client.query('BEGIN');

    const groupedResult = await client.query<AutoGroupRow>(
      `SELECT
         up.product_code,
         p.purchase_department_id,
         ARRAY_AGG(up.id ORDER BY up.id) AS usage_plan_ids,
         COALESCE(SUM(GREATEST(COALESCE(up.approved_quota, up.requested_amount, 0), 0)), 0)::int AS total_quota
       FROM public.usage_plan up
       LEFT JOIN public.product p ON p.code = up.product_code
       WHERE up.purchase_plan_id IS NULL
         AND up.plan_flag = 'ในแผน'
         AND up.product_code IS NOT NULL
       GROUP BY up.product_code, p.purchase_department_id
       ORDER BY up.product_code`,
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
      const quota = Number(group.total_quota || 0);
      const usagePlanIds = Array.isArray(group.usage_plan_ids)
        ? group.usage_plan_ids.map((id) => Number(id)).filter((id) => Number.isInteger(id) && id > 0)
        : [];

      if (usagePlanIds.length === 0) {
        continue;
      }

      const insertResult = await client.query<{ id: number }>(
        `INSERT INTO public.purchase_plan (inventory_qty, qouta_qty, purchase_qty)
         VALUES ($1, $2, $3)
         RETURNING id`,
        [0, quota, quota],
      );

      const purchasePlanId = insertResult.rows[0]?.id;
      if (!purchasePlanId) {
        continue;
      }

      await client.query(
        `UPDATE public.usage_plan
         SET purchase_plan_id = $1,
             plan_flag = 'ในแผน',
             updated_at = NOW()
         WHERE id = ANY($2::int[])
           AND purchase_plan_id IS NULL`,
        [purchasePlanId, usagePlanIds],
      );

      createdCount += 1;
      linkedUsagePlanCount += usagePlanIds.length;
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
