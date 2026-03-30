import { NextRequest, NextResponse } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { allocatePurchasePlanId } from '@/lib/purchase-plan';

const MAX_PRODUCTS = 30;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const departmentCode = (searchParams.get('department_code') || '').trim();
    const category = (searchParams.get('category') || '').trim();
    const search = (searchParams.get('search') || '').trim();

    const [departmentsResult, categoriesResult] = await Promise.all([
      pgQuery(
        `SELECT department_code, name
         FROM public.department
         WHERE is_active = true
           AND department_code IS NOT NULL
           AND department_code <> ''
         ORDER BY department_code ASC`,
      ),
      pgQuery(
        `SELECT DISTINCT category
         FROM public.product
         WHERE is_active = true
           AND category IS NOT NULL
           AND category <> ''
         ORDER BY category ASC`,
      ),
    ]);

    if (!departmentCode || !category || !search) {
      return NextResponse.json({
        departments: departmentsResult.rows,
        categories: categoriesResult.rows.map((row: { category?: string }) => row.category).filter(Boolean),
        products: [],
      });
    }

    const productResult = await pgQuery(
      `SELECT
         p.id,
         p.code,
         p.name,
         p.category,
         p.type,
         p.subtype,
         p.unit,
         COALESCE(p.cost_price, 0)::float8 AS cost_price,
         d.department_code AS purchase_department_code,
         d.name AS purchase_department_name
       FROM public.product p
       LEFT JOIN public.department d ON d.id = p.purchase_department_id
       WHERE p.is_active = true
         AND p.category = $1
         AND d.department_code = $2
         AND (p.code ILIKE $3 OR p.name ILIKE $3)
       ORDER BY p.code ASC
       LIMIT $4`,
      [category, departmentCode, `%${search}%`, MAX_PRODUCTS],
    );

    return NextResponse.json({
      departments: departmentsResult.rows,
      categories: categoriesResult.rows.map((row: { category?: string }) => row.category).filter(Boolean),
      products: productResult.rows,
    });
  } catch (error) {
    console.error('Error fetching out-of-plan product options:', error);
    return NextResponse.json({ error: 'Failed to fetch out-of-plan product options' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const productCode = (body?.product_code || '').trim();
    const requestingDeptCode = (body?.requesting_dept_code || '').trim();
    const category = (body?.category || '').trim();
    const budgetYear = Number(body?.budget_year);
    const qty = Number(body?.purchase_qty);

    if (!productCode) {
      return apiError('กรุณาเลือกรหัสสินค้า', 400);
    }
    if (!requestingDeptCode) {
      return apiError('กรุณาเลือกหน่วยงาน', 400);
    }
    if (!category) {
      return apiError('กรุณาเลือกหมวดสินค้า', 400);
    }
    if (!Number.isFinite(budgetYear) || budgetYear <= 0) {
      return apiError('กรุณาระบุปีงบที่ถูกต้อง', 400);
    }
    if (!Number.isFinite(qty) || qty <= 0) {
      return apiError('กรุณาระบุจำนวนที่ต้องการจัดซื้อให้มากกว่า 0', 400);
    }

    const productResult = await pgQuery<{
      code: string;
      category: string | null;
      cost_price: number | null;
      purchase_department_id: number | null;
      purchase_department_code: string | null;
    }>(
      `SELECT
         p.code,
         p.category,
         COALESCE(p.cost_price, 0)::float8 AS cost_price,
         COALESCE(p.purchase_department_id, 0)::int AS purchase_department_id,
         d.department_code AS purchase_department_code
       FROM public.product p
       LEFT JOIN public.department d ON d.id = p.purchase_department_id
       WHERE p.code = $1
         AND p.is_active = true
       LIMIT 1`,
      [productCode],
    );

    const product = productResult.rows[0];
    if (!product) {
      return apiError('ไม่พบสินค้าในระบบ', 404);
    }
    if ((product.category || '') !== category) {
      return apiError('หมวดสินค้าที่เลือกไม่ตรงกับสินค้า', 400);
    }
    if ((product.purchase_department_code || '') !== requestingDeptCode) {
      return apiError('หน่วยงานที่เลือกไม่ตรงกับหน่วยงานจัดซื้อของสินค้า', 400);
    }
    const targetPurchaseDepartmentId = Number(product.purchase_department_id ?? 0);

    const client = await pgPool.connect();
    try {
      await client.query('BEGIN');

      const usageInsert = await client.query<{ id: number }>(
        `INSERT INTO public.usage_plan
           (product_code, requested_amount, requesting_dept_code, plan_flag, approved_quota, budget_year, sequence_no)
         VALUES ($1, $2, $3, 'นอกแผน', $2, $4, 1)
         RETURNING id`,
        [productCode, Math.trunc(qty), requestingDeptCode, Math.trunc(budgetYear)],
      );

      const usagePlanId = usageInsert.rows[0]?.id;
      if (!usagePlanId) {
        await client.query('ROLLBACK');
        return apiError('ไม่สามารถสร้าง usage plan นอกแผนได้', 500);
      }

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
           AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = 'นอกแผน'
         GROUP BY purchase_plan_id
         ORDER BY purchase_plan_id`,
        [productCode, Math.trunc(budgetYear), targetPurchaseDepartmentId],
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
             AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = 'นอกแผน'`,
          [purchasePlanId, duplicatePlanIds, productCode, Math.trunc(budgetYear), targetPurchaseDepartmentId],
        );


      }

      await client.query(
        `UPDATE public.usage_plan
         SET purchase_plan_id = $1,
             updated_at = NOW()
         WHERE id = $2`,
        [purchasePlanId, usagePlanId],
      );

      const quotaResult = await client.query<{ total_quota: number }>(
        `SELECT COALESCE(SUM(GREATEST(COALESCE(approved_quota, requested_amount, 0), 0)), 0)::int AS total_quota
         FROM public.usage_plan
         WHERE purchase_plan_id = $1
           AND product_code = $2
           AND budget_year = $3
           AND EXISTS (
             SELECT 1
             FROM public.product p
             WHERE p.code = public.usage_plan.product_code
               AND COALESCE(p.purchase_department_id, 0) = $4
           )
           AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = 'นอกแผน'`,
        [purchasePlanId, productCode, Math.trunc(budgetYear), targetPurchaseDepartmentId],
      );

      const inventoryResult = await client.query<{ inventory_qty: number }>(
        `SELECT COALESCE(SUM(isl.qty_on_hand), 0)::int AS inventory_qty
         FROM public.inventory_stock_lot isl
         INNER JOIN public.product p_stock ON p_stock.id = isl.product_id
         WHERE p_stock.code = $1`,
        [productCode],
      );

      const qoutaQty = Number(quotaResult.rows[0]?.total_quota ?? 0);
      const inventoryQty = Number(inventoryResult.rows[0]?.inventory_qty ?? 0);
      const purchaseQty = Math.max(qoutaQty - inventoryQty, 0);



      await client.query('COMMIT');

      await cacheDelByPattern('erp:purchase:plans:list:*');
      await cacheDelByPattern('erp:purchase:plans:filters*');
      await cacheDelByPattern('erp:usage_plans:list:*');

      return apiSuccess(
        {
          usage_plan_id: usagePlanId,
          purchase_plan_id: purchasePlanId,
          plan_flag: 'นอกแผน',
          qouta_qty: qoutaQty,
          inventory_qty: inventoryQty,
          purchase_qty: purchaseQty,
        },
        'บันทึก usage_plan นอกแผนเรียบร้อยแล้ว และ purchase_plan view จะแสดงเป็นนอกแผนอัตโนมัติ',
        undefined,
        201,
      );
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error creating out-of-plan purchase plan:', error);
    return apiError('Failed to create out-of-plan purchase plan');
  }
}



