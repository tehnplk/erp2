import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updatePurchasePlanSchema } from '@/lib/validation/schemas';

async function getPurchasePlanJoinedById(id: number) {
  const result = await pgQuery(
    `SELECT
       pp.id,
       pp.usage_plan_id,
       up.sequence_no,
       up.product_code,
       up.product_name,
       up.category,
       up.type AS product_type,
       up.subtype AS product_subtype,
       up.unit,
       up.price_per_unit::float8 AS price_per_unit,
       up.requested_amount,
       up.approved_quota,
       up.budget_year,
       up.requesting_dept,
       COALESCE(inv.inventory_qty, pp.inventory_qty, 0)::int AS inventory_qty,
       COALESCE(inv.inventory_value, pp.inventory_value, 0)::float8 AS inventory_value,
       COALESCE(pp.purchase_qty, 0)::int AS purchase_qty,
       COALESCE(pp.purchase_value, ROUND(COALESCE(pp.purchase_qty, 0) * COALESCE(up.price_per_unit, 0), 2))::float8 AS purchase_value
     FROM public.purchase_plan pp
     INNER JOIN public.usage_plan up ON up.id = pp.usage_plan_id
     LEFT JOIN (
       SELECT
         ii.product_code,
         COALESCE(SUM(ib.on_hand_qty), 0)::int AS inventory_qty,
         COALESCE(SUM(ib.on_hand_qty * ib.avg_cost), 0)::float8 AS inventory_value
       FROM public.inventory_item ii
       INNER JOIN public.inventory_balance ib ON ib.inventory_item_id = ii.id
       GROUP BY ii.product_code
     ) inv ON inv.product_code = up.product_code
     WHERE pp.id = $1
     LIMIT 1`,
    [id],
  );

  return result.rows[0] || null;
}

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return apiError('Invalid ID format', 400);
    }

    const numericId = parsedId.data.id;
    const body = await request.json();
    const validation = await validateRequest(updatePurchasePlanSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const current = await pgQuery(
      'SELECT pp.id, pp.usage_plan_id, up.price_per_unit::float8 AS price_per_unit FROM public.purchase_plan pp INNER JOIN public.usage_plan up ON up.id = pp.usage_plan_id WHERE pp.id = $1 LIMIT 1',
      [numericId],
    );

    const currentItem = current.rows[0];
    if (!currentItem) {
      return apiError('Purchase plan not found', 404);
    }

    const payload = validation.data as {
      usage_plan_id?: number | null;
      inventory_qty?: number | null;
      inventory_value?: number | null;
      purchase_qty?: number | null;
      purchase_value?: number | null;
    };

    const nextUsagePlanId = payload.usage_plan_id ?? currentItem.usage_plan_id;
    if (nextUsagePlanId === null || nextUsagePlanId === undefined) {
      return apiError('กรุณาระบุ usage_plan_id', 400);
    }

    let pricePerUnit = Number(currentItem.price_per_unit || 0);
    if (nextUsagePlanId !== currentItem.usage_plan_id) {
      const usagePlanResult = await pgQuery('SELECT id, price_per_unit::float8 AS price_per_unit FROM public.usage_plan WHERE id = $1 LIMIT 1', [nextUsagePlanId]);
      const usagePlan = usagePlanResult.rows[0];
      if (!usagePlan) {
        return apiError('ไม่พบข้อมูลแผนการใช้ที่เลือก', 400);
      }

      const duplicateResult = await pgQuery('SELECT id FROM public.purchase_plan WHERE usage_plan_id = $1 AND id <> $2 LIMIT 1', [nextUsagePlanId, numericId]);
      if (duplicateResult.rows.length > 0) {
        return apiError('แผนการใช้นี้ถูกสร้างแผนจัดซื้อแล้ว', 400);
      }

      pricePerUnit = Number(usagePlan.price_per_unit || 0);
    }

    const nextInventoryQty = Number(payload.inventory_qty ?? 0);
    const nextInventoryValue = Number(payload.inventory_value ?? 0);
    const nextPurchaseQty = Number(payload.purchase_qty ?? 0);
    const nextPurchaseValue = Number.isFinite(Number(payload.purchase_value))
      ? Number(payload.purchase_value)
      : Number((nextPurchaseQty * pricePerUnit).toFixed(2));

    const updated = await pgQuery(
      `UPDATE public.purchase_plan
       SET usage_plan_id = $1,
           inventory_qty = $2,
           inventory_value = $3,
           purchase_qty = $4,
           purchase_value = $5
       WHERE id = $6
       RETURNING id, usage_plan_id, inventory_qty, inventory_value::float8 AS inventory_value, purchase_qty, purchase_value::float8 AS purchase_value`,
      [
        nextUsagePlanId,
        Number.isFinite(nextInventoryQty) ? nextInventoryQty : 0,
        Number.isFinite(nextInventoryValue) ? nextInventoryValue : 0,
        Number.isFinite(nextPurchaseQty) ? nextPurchaseQty : 0,
        Number.isFinite(nextPurchaseValue) ? nextPurchaseValue : 0,
        numericId,
      ],
    );

    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');

    const joined = await getPurchasePlanJoinedById(updated.rows[0].id);
    return apiSuccess(joined, 'Purchase plan updated successfully');
  } catch (error) {
    console.error('Error updating purchase plan:', error);
    return apiError('Failed to update purchase plan');
  }
}

export async function DELETE(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return apiError('Invalid ID format', 400);
    }

    const numericId = parsedId.data.id;
    const existing = await pgQuery('SELECT id FROM public.purchase_plan WHERE id = $1 LIMIT 1', [numericId]);
    if (existing.rows.length === 0) {
      return apiError('Purchase plan not found', 404);
    }

    await pgQuery('DELETE FROM public.purchase_plan WHERE id = $1', [numericId]);
    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');

    return apiSuccess(null, 'Purchase plan deleted successfully');
  } catch (error) {
    console.error('Error deleting purchase plan:', error);
    return apiError('Failed to delete purchase plan');
  }
}
