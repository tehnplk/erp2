import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';

type BulkUsagePlanItem = {
  product_code: string;
  requested_amount: number;
};

const buildConstraintError = (product_code?: string) =>
  NextResponse.json(
    {
      error: product_code
        ? `สินค้า ${product_code} ของหน่วยงานนี้ในปีงบนี้ ถูกขอครบ 2 ครั้งแล้ว`
        : 'หน่วยงานเดียวกัน ในปีงบเดียวกัน ขอสินค้ารหัสเดียวกันได้ไม่เกิน 2 ครั้ง',
    },
    { status: 400 }
  );

export async function POST(request: NextRequest) {
  try {
    const body = (await request.json().catch(() => null)) as {
      requesting_dept_code?: string;
      budget_year?: number | string;
      items?: Array<{
        product_code?: string;
        requested_amount?: number | string;
      }>;
    } | null;

    if (!body) {
      return NextResponse.json({ error: 'ข้อมูลไม่ถูกต้อง' }, { status: 400 });
    }

    const requesting_dept_code = (body.requesting_dept_code || '').trim();
    const budget_year = Number(body.budget_year);

    if (!requesting_dept_code) {
      return NextResponse.json({ error: 'กรุณาเลือกหน่วยงานที่ต้องการใช้' }, { status: 400 });
    }

    if (!Number.isFinite(budget_year) || budget_year <= 0) {
      return NextResponse.json({ error: 'ปีงบไม่ถูกต้อง' }, { status: 400 });
    }

    if (!Array.isArray(body.items) || body.items.length === 0) {
      return NextResponse.json({ error: 'กรุณาเพิ่มสินค้าอย่างน้อย 1 รายการ' }, { status: 400 });
    }

    const items: BulkUsagePlanItem[] = [];
    const seen_product_codes = new Set<string>();
    for (const item of body.items) {
      const product_code = (item?.product_code || '').trim();
      const requested_amount = Number(item?.requested_amount);

      if (!product_code) {
        return NextResponse.json({ error: 'พบรหัสสินค้าที่ไม่ถูกต้องในรายการ' }, { status: 400 });
      }

      if (!Number.isFinite(requested_amount) || requested_amount < 0) {
        return NextResponse.json({ error: `จำนวนที่ขอของสินค้า ${product_code} ไม่ถูกต้อง` }, { status: 400 });
      }

      if (seen_product_codes.has(product_code)) {
        return NextResponse.json({ error: `พบรหัสสินค้า ${product_code} ซ้ำในรายการที่เพิ่ม` }, { status: 400 });
      }
      seen_product_codes.add(product_code);

      items.push({
        product_code,
        requested_amount,
      });
    }

    const created_ids: number[] = [];

    for (const item of items) {
      const existing_count_result = await pgQuery<{ count: number }>(
        `SELECT COUNT(*)::int AS count
         FROM public.usage_plan
         WHERE budget_year = $1
           AND requesting_dept_code IS NOT DISTINCT FROM $2
           AND product_code IS NOT DISTINCT FROM $3`,
        [budget_year, requesting_dept_code, item.product_code]
      );

      const existing_count = Number(existing_count_result.rows[0]?.count || 0);
      if (existing_count >= 2) {
        return buildConstraintError(item.product_code);
      }

      const sequence_no = existing_count + 1;

      const insert_result = await pgQuery<{ id: number }>(
        `INSERT INTO public.usage_plan (
          product_code,
          requested_amount,
          requesting_dept_code,
          plan_flag,
          approved_quota,
          budget_year,
          sequence_no
        ) VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING id`,
        [
          item.product_code,
          item.requested_amount,
          requesting_dept_code,
          'ในแผน',
          item.requested_amount,
          budget_year,
          sequence_no,
        ]
      );

      created_ids.push(insert_result.rows[0].id);
    }

    const created_rows_result = await pgQuery(
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
        false AS has_purchase_plan,
        false AS has_purchase_approval
      FROM public.usage_plan up
      LEFT JOIN public.product p ON p.code = up.product_code
      LEFT JOIN public.department d ON d.department_code = up.requesting_dept_code
      LEFT JOIN LATERAL (
        SELECT c.type, c.subtype
        FROM public.category c
        WHERE c.category = p.category
          AND c.is_active = true
        ORDER BY c.category_code ASC
        LIMIT 1
      ) c ON true
      WHERE up.id = ANY($1::int[])
      ORDER BY up.id DESC`,
      [created_ids]
    );

    await cacheDelByPattern('erp:usage_plans:list:*');

    return NextResponse.json(
      {
        created_count: created_ids.length,
        usage_plans: created_rows_result.rows,
      },
      { status: 201 }
    );
  } catch (error) {
    console.error('Error creating usage plans in bulk:', error);
    return NextResponse.json({ error: 'Failed to create usage plans in bulk' }, { status: 500 });
  }
}
