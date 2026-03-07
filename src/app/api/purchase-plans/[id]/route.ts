import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updatePurchasePlanSchema } from '@/lib/validation/schemas';

const purchasePlanSelect = `SELECT id, "productCode", category, "productName", "productType", "productSubtype", unit, "pricePerUnit"::float8 AS "pricePerUnit", "budgetYear", "planId", "inPlan", "carriedForwardQuantity", "carriedForwardValue"::float8 AS "carriedForwardValue", "requiredQuantityForYear", "totalRequiredValue"::float8 AS "totalRequiredValue", "additionalPurchaseQty", "additionalPurchaseValue"::float8 AS "additionalPurchaseValue", "purchasingDepartment" FROM public."PurchasePlan"`;

type PurchasePlanPayload = {
  planId?: number | null;
  inPlan?: string | null;
  carriedForwardQuantity?: number | null;
  carriedForwardValue?: number | null;
  purchasingDepartment?: string | null;
};

async function buildPurchasePlanPayload(input: PurchasePlanPayload) {
  const planId = input.planId ?? null;

  if (planId === null) {
    return { error: NextResponse.json({ error: 'กรุณาเลือกแผนการใช้ก่อนบันทึก' }, { status: 400 }) };
  }

  const surveyResult = await pgQuery(
    `SELECT id, "productCode", category, type, subtype, "productName", "requestedAmount", unit, "pricePerUnit"::float8 AS "pricePerUnit", "requestingDept", "approvedQuota", budget_year AS "budgetYear"
     FROM public."UsagePlan"
     WHERE id = $1
     LIMIT 1`,
    [planId]
  );

  const survey = surveyResult.rows[0];
  if (!survey) {
    return { error: NextResponse.json({ error: 'ไม่พบข้อมูลแผนการใช้ที่เลือก' }, { status: 400 }) };
  }

  const inPlan = input.inPlan?.trim();
  if (!inPlan || !['ในแผน', 'นอกแผน'].includes(inPlan)) {
    return { error: NextResponse.json({ error: 'รายการในแผน/นอกแผน ต้องเป็น "ในแผน" หรือ "นอกแผน"' }, { status: 400 }) };
  }

  const carriedForwardQuantity = input.carriedForwardQuantity ?? 0;
  if (carriedForwardQuantity < 0) {
    return { error: NextResponse.json({ error: 'จำนวนยกยอดมาต้องไม่น้อยกว่า 0' }, { status: 400 }) };
  }

  const pricePerUnit = Number(survey.pricePerUnit) || 0;
  const approvedQuota = survey.approvedQuota ?? 0;
  const requestedAmount = survey.requestedAmount ?? 0;
  const productResult = survey.productCode
    ? await pgQuery(
        `SELECT "costPrice"::float8 AS "costPrice"
         FROM public."Product"
         WHERE code = $1
         LIMIT 1`,
        [survey.productCode]
      )
    : { rows: [] };
  const product = productResult.rows[0];
  const productCostPrice = Number(product?.costPrice) || 0;
  const carriedForwardValue = Number((carriedForwardQuantity * productCostPrice).toFixed(2));
  const totalRequiredValue = Number((approvedQuota * pricePerUnit).toFixed(2));
  const additionalPurchaseQtyRaw = requestedAmount - carriedForwardQuantity;
  const additionalPurchaseQty = additionalPurchaseQtyRaw > 0 ? additionalPurchaseQtyRaw : 0;
  const additionalPurchaseValue = Number((additionalPurchaseQty * pricePerUnit).toFixed(2));
  const purchasingDepartment = input.purchasingDepartment?.trim();

  return {
    payload: {
      productCode: survey.productCode || null,
      category: survey.category || null,
      productName: survey.productName || null,
      productType: survey.type || null,
      productSubtype: survey.subtype || null,
      unit: survey.unit || null,
      pricePerUnit,
      budgetYear: survey.budgetYear !== null && survey.budgetYear !== undefined ? String(survey.budgetYear) : null,
      planId: survey.id,
      inPlan,
      carriedForwardQuantity,
      carriedForwardValue,
      requiredQuantityForYear: requestedAmount,
      totalRequiredValue,
      additionalPurchaseQty,
      additionalPurchaseValue,
      purchasingDepartment: purchasingDepartment || null,
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
      planId: payload.planId ?? currentItem.planId ?? null,
      inPlan: payload.inPlan ?? currentItem.inPlan ?? null,
      carriedForwardQuantity: payload.carriedForwardQuantity ?? currentItem.carriedForwardQuantity ?? 0,
      carriedForwardValue: payload.carriedForwardValue ?? currentItem.carriedForwardValue ?? 0,
      purchasingDepartment: payload.purchasingDepartment ?? currentItem.purchasingDepartment ?? null,
    });

    if ('error' in resolved) {
      return resolved.error;
    }

    const assignments: string[] = [];
    const values: unknown[] = [];
    const columnMap: Record<string, string> = {
      productCode: '"productCode"',
      category: 'category',
      productName: '"productName"',
      productType: '"productType"',
      productSubtype: '"productSubtype"',
      unit: 'unit',
      pricePerUnit: '"pricePerUnit"',
      budgetYear: '"budgetYear"',
      planId: '"planId"',
      inPlan: '"inPlan"',
      carriedForwardQuantity: '"carriedForwardQuantity"',
      carriedForwardValue: '"carriedForwardValue"',
      requiredQuantityForYear: '"requiredQuantityForYear"',
      totalRequiredValue: '"totalRequiredValue"',
      additionalPurchaseQty: '"additionalPurchaseQty"',
      additionalPurchaseValue: '"additionalPurchaseValue"',
      purchasingDepartment: '"purchasingDepartment"',
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
      `UPDATE public."PurchasePlan" SET ${assignments.join(', ')} WHERE id = $${values.length} RETURNING id, "productCode", category, "productName", "productType", "productSubtype", unit, "pricePerUnit"::float8 AS "pricePerUnit", "budgetYear", "planId", "inPlan", "carriedForwardQuantity", "carriedForwardValue"::float8 AS "carriedForwardValue", "requiredQuantityForYear", "totalRequiredValue"::float8 AS "totalRequiredValue", "additionalPurchaseQty", "additionalPurchaseValue"::float8 AS "additionalPurchaseValue", "purchasingDepartment"`,
      values
    );

    await cacheDelByPattern('erp:purchase:plans:list:*');

    return NextResponse.json(updated.rows[0]);
  } catch (error) {
    console.error('Error updating purchase plan:', error);
    return NextResponse.json({ error: 'Failed to update purchase plan' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;
    await pgQuery('DELETE FROM public."PurchasePlan" WHERE id = $1', [numericId]);
    await cacheDelByPattern('erp:purchase:plans:list:*');
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting purchase plan:', error);
    return NextResponse.json({ error: 'Failed to delete purchase plan' }, { status: 500 });
  }
}
