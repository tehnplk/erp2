import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updatePurchasePlanSchema } from '@/lib/validation/schemas';
import { findDepartmentCodeByName } from '@/lib/department-code';

const purchasePlanSelect = `SELECT id, product_code, category, product_name, product_type, product_subtype, unit, price_per_unit::float8 AS price_per_unit, budget_year, plan_id, in_plan, carried_forward_quantity, carried_forward_value::float8 AS carried_forward_value, required_quantity_for_year, total_required_value::float8 AS total_required_value, additional_purchase_qty, additional_purchase_value::float8 AS additional_purchase_value, purchasing_department, purchasing_department_code FROM public.purchase_plan`;

type PurchasePlanPayload = {
  plan_id?: number | null;
  in_plan?: string | null;
  carried_forward_quantity?: number | null;
  carried_forward_value?: number | null;
  purchasing_department?: string | null;
  purchasing_department_code?: string | null;
};

async function buildPurchasePlanPayload(input: PurchasePlanPayload) {
  const planId = input.plan_id ?? null;

  if (planId === null) {
    return { error: NextResponse.json({ error: 'กรุณาเลือกแผนการใช้ก่อนบันทึก' }, { status: 400 }) };
  }

  const surveyResult = await pgQuery(
    `SELECT id, product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit::float8 AS price_per_unit, requesting_dept, requesting_dept_code, approved_quota, budget_year
     FROM public.usage_plan
     WHERE id = $1
     LIMIT 1`,
    [planId]
  );

  const survey = surveyResult.rows[0];
  if (!survey) {
    return { error: NextResponse.json({ error: 'ไม่พบข้อมูลแผนการใช้ที่เลือก' }, { status: 400 }) };
  }

  const inPlan = input.in_plan?.trim();
  if (!inPlan || !['ในแผน', 'นอกแผน'].includes(inPlan)) {
    return { error: NextResponse.json({ error: 'รายการในแผน/นอกแผน ต้องเป็น "ในแผน" หรือ "นอกแผน"' }, { status: 400 }) };
  }

  const carriedForwardQuantity = input.carried_forward_quantity ?? 0;
  if (carriedForwardQuantity < 0) {
    return { error: NextResponse.json({ error: 'จำนวนยกยอดมาต้องไม่น้อยกว่า 0' }, { status: 400 }) };
  }

  const pricePerUnit = Number(survey.price_per_unit) || 0;
  const approvedQuota = survey.approved_quota ?? 0;
  const requestedAmount = survey.requested_amount ?? 0;
  const productResult = survey.product_code
    ? await pgQuery(
        `SELECT cost_price::float8 AS cost_price
         FROM public.product
         WHERE code = $1
         LIMIT 1`,
        [survey.product_code]
      )
    : { rows: [] };
  const product = productResult.rows[0];
  const productCostPrice = Number(product?.cost_price) || 0;
  const carriedForwardValue = Number((carriedForwardQuantity * productCostPrice).toFixed(2));
  const totalRequiredValue = Number((approvedQuota * pricePerUnit).toFixed(2));
  const additionalPurchaseQtyRaw = requestedAmount - carriedForwardQuantity;
  const additionalPurchaseQty = additionalPurchaseQtyRaw > 0 ? additionalPurchaseQtyRaw : 0;
  const additionalPurchaseValue = Number((additionalPurchaseQty * pricePerUnit).toFixed(2));
  const purchasingDepartment = input.purchasing_department?.trim();

  return {
    payload: {
      product_code: survey.product_code || null,
      category: survey.category || null,
      product_name: survey.product_name || null,
      product_type: survey.type || null,
      product_subtype: survey.subtype || null,
      unit: survey.unit || null,
      price_per_unit: pricePerUnit,
      budget_year: survey.budget_year !== null && survey.budget_year !== undefined ? String(survey.budget_year) : null,
      plan_id: survey.id,
      in_plan: inPlan,
      carried_forward_quantity: carriedForwardQuantity,
      carried_forward_value: carriedForwardValue,
      required_quantity_for_year: requestedAmount,
      total_required_value: totalRequiredValue,
      additional_purchase_qty: additionalPurchaseQty,
      additional_purchase_value: additionalPurchaseValue,
      purchasing_department: purchasingDepartment || null,
      purchasing_department_code: purchasingDepartment
        ? await findDepartmentCodeByName(purchasingDepartment)
        : survey.requesting_dept_code || await findDepartmentCodeByName(survey.requesting_dept || null),
    },
  };
}

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;
    const body = await request.json();
    const validation = await validateRequest(updatePurchasePlanSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const currentResult = await pgQuery(`${purchasePlanSelect} WHERE id = $1 LIMIT 1`, [numericId]);
    const currentItem = currentResult.rows[0];

    if (!currentItem) {
      return NextResponse.json({ error: 'Purchase plan not found' }, { status: 404 });
    }

    const payload = validation.data as PurchasePlanPayload;
    const resolved = await buildPurchasePlanPayload({
      plan_id: payload.plan_id ?? currentItem.plan_id ?? null,
      in_plan: payload.in_plan ?? currentItem.in_plan ?? null,
      carried_forward_quantity: payload.carried_forward_quantity ?? currentItem.carried_forward_quantity ?? 0,
      carried_forward_value: payload.carried_forward_value ?? currentItem.carried_forward_value ?? 0,
      purchasing_department: payload.purchasing_department ?? currentItem.purchasing_department ?? null,
    });

    if ('error' in resolved) {
      return resolved.error;
    }

    const assignments: string[] = [];
    const values: unknown[] = [];
    const columnMap: Record<string, string> = {
      product_code: 'product_code',
      category: 'category',
      product_name: 'product_name',
      product_type: 'product_type',
      product_subtype: 'product_subtype',
      unit: 'unit',
      price_per_unit: 'price_per_unit',
      budget_year: 'budget_year',
      plan_id: 'plan_id',
      in_plan: 'in_plan',
      carried_forward_quantity: 'carried_forward_quantity',
      carried_forward_value: 'carried_forward_value',
      required_quantity_for_year: 'required_quantity_for_year',
      total_required_value: 'total_required_value',
      additional_purchase_qty: 'additional_purchase_qty',
      additional_purchase_value: 'additional_purchase_value',
      purchasing_department: 'purchasing_department',
      purchasing_department_code: 'purchasing_department_code',
    };

    Object.entries(resolved.payload).forEach(([key, value]) => {
      const column = columnMap[key];
      if (!column) {
        return;
      }

      values.push(value ?? null);
      assignments.push(`${column} = $${values.length}`);
    });

    if (assignments.length === 0) {
      return NextResponse.json(currentItem);
    }

    values.push(numericId);

    const updated = await pgQuery(
      `UPDATE public.purchase_plan SET ${assignments.join(', ')} WHERE id = $${values.length} RETURNING id, product_code, category, product_name, product_type, product_subtype, unit, price_per_unit::float8 AS price_per_unit, budget_year, plan_id, in_plan, carried_forward_quantity, carried_forward_value::float8 AS carried_forward_value, required_quantity_for_year, total_required_value::float8 AS total_required_value, additional_purchase_qty, additional_purchase_value::float8 AS additional_purchase_value, purchasing_department, purchasing_department_code`,
      values
    );

    await cacheDelByPattern('erp:purchase:plans:list:*');

    return NextResponse.json(updated.rows[0]);
  } catch (error) {
    console.error('Error updating purchase plan:', error);
    return NextResponse.json({ error: 'Failed to update purchase plan' }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;
    const existing = await pgQuery('SELECT id FROM public.purchase_plan WHERE id = $1 LIMIT 1', [numericId]);
    if (existing.rows.length === 0) {
      return NextResponse.json({ error: 'Purchase plan not found' }, { status: 404 });
    }

    await pgQuery('DELETE FROM public.purchase_plan WHERE id = $1', [numericId]);
    await cacheDelByPattern('erp:purchase:plans:list:*');

    return NextResponse.json({ message: 'Purchase plan deleted successfully' });
  } catch (error) {
    console.error('Error deleting purchase plan:', error);
    return NextResponse.json({ error: 'Failed to delete purchase plan' }, { status: 500 });
  }
}
