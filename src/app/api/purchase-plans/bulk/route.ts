import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';

interface BulkPurchasePlanRequest {
  usage_plan_ids: number[];
}

interface BulkDeleteRequest {
  ids: number[];
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json() as BulkPurchasePlanRequest;
    const { usage_plan_ids } = body;

    if (!usage_plan_ids || !Array.isArray(usage_plan_ids) || usage_plan_ids.length === 0) {
      return apiError('กรุณาระบุรายการ usage_plan_ids ที่ต้องการสร้างแผนจัดซื้อ', 400);
    }

    // Validate that all usage plan IDs exist and have approved_quota > 0
    const usagePlansResult = await pgQuery(
      `SELECT 
        up.id, 
        up.price_per_unit::float8 AS price_per_unit,
        up.approved_quota,
        pp.id AS purchase_plan_id
      FROM public.usage_plan up
      LEFT JOIN public.purchase_plan pp ON up.id = pp.usage_plan_id
      WHERE up.id = ANY($1) AND up.approved_quota > 0`,
      [usage_plan_ids]
    );

    if (usagePlansResult.rows.length === 0) {
      return apiError('ไม่พบรายการที่ตรงเงื่อนไขหรือไม่มีโควต้าที่อนุมัติ', 400);
    }

    // Filter out usage plans that already have purchase plans
    const eligiblePlans = usagePlansResult.rows.filter(row => !row.purchase_plan_id);
    
    if (eligiblePlans.length === 0) {
      return apiError('รายการที่เลือกถูกสร้างเป็นแผนจัดซื้อแล้ว', 400);
    }

    // Create purchase plans for eligible usage plans
    const insertResults = [];
    for (const plan of eligiblePlans) {
      const purchase_qty = plan.approved_quota;
      const purchase_value = Number((purchase_qty * Number(plan.price_per_unit || 0)).toFixed(2));

      const insertResult = await pgQuery(
        `INSERT INTO public.purchase_plan (usage_plan_id, inventory_qty, inventory_value, purchase_qty, purchase_value)
         VALUES ($1, 0, 0, $2, $3)
         RETURNING id, usage_plan_id, inventory_qty, inventory_value::float8 AS inventory_value, purchase_qty, purchase_value::float8 AS purchase_value`,
        [plan.id, purchase_qty, purchase_value]
      );

      insertResults.push(insertResult.rows[0]);
    }

    // Clear relevant cache
    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');
    await cacheDelByPattern('erp:usage:plans:available*');
    await cacheDelByPattern('erp:surveys:list:*');

    return apiSuccess(
      { 
        created_count: insertResults.length,
        created_plans: insertResults,
        skipped_count: usagePlansResult.rows.length - eligiblePlans.length
      },
      `สร้างแผนจัดซื้อ ${insertResults.length} รายการสำเร็จ`,
      undefined,
      201
    );

  } catch (error) {
    console.error('Error creating bulk purchase plans:', error);
    return apiError('Failed to create bulk purchase plans');
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const body = await request.json() as BulkDeleteRequest;
    
    if (!body.ids || !Array.isArray(body.ids) || body.ids.length === 0) {
      return apiError('No IDs provided for bulk deletion');
    }

    const ids = body.ids.filter(id => typeof id === 'number' && id > 0);
    if (ids.length === 0) {
      return apiError('No valid IDs provided');
    }

    // Delete purchase plans in bulk
    const placeholders = ids.map((_, index) => `$${index + 1}`).join(', ');
    const result = await pgQuery(
      `DELETE FROM public.purchase_plan WHERE id IN (${placeholders}) RETURNING id`,
      ids
    );
    
    // Clear cache
    await cacheDelByPattern('erp:purchase:plans:list:*');
    
    return apiSuccess(
      { deleted: result.rows.length, ids: result.rows.map(row => row.id) }, 
      `Deleted ${result.rows.length} purchase plans successfully`
    );
  } catch (error) {
    console.error('Error deleting bulk purchase plans:', error);
    return apiError('Failed to delete bulk purchase plans');
  }
}
