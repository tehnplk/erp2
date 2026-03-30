import { NextRequest } from 'next/server';
import { pgPool } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { idParamSchema } from '@/lib/validation/schemas';

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return apiError('Invalid ID format', 400);
    }

    return apiError('แผนจัดซื้อเป็นข้อมูลจาก view ไม่สามารถแก้ไขตรงได้', 405);
  } catch (error) {
    console.error('Error updating purchase plan:', error);
    return apiError('Failed to update purchase plan');
  }
}

export async function DELETE(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  const client = await pgPool.connect();

  try {
    await client.query('BEGIN');

    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return apiError('Invalid ID format', 400);
    }

    const numericId = parsedId.data.id;
    const planResult = await client.query<{
      product_code: string | null;
      budget_year: number | null;
      purchase_department_id: number | null;
      usage_plan_flag: string | null;
    }>(
      `SELECT product_code, budget_year, purchase_department_id, usage_plan_flag
       FROM public.purchase_plan
       WHERE id = $1
       LIMIT 1`,
      [numericId],
    );

    const plan = planResult.rows[0];
    if (!plan) {
      await client.query('ROLLBACK');
      return apiError('ไม่พบแผนจัดซื้อที่ต้องการลบ', 404);
    }

    const approvalResult = await client.query(
      `SELECT 1
       FROM public.purchase_approval_detail pad
       INNER JOIN public.purchase_approval pa ON pa.id = pad.purchase_approval_id
       WHERE COALESCE(pad.product_code, '') = COALESCE($1, '')
         AND pa.budget_year = $2
         AND CASE WHEN COALESCE(pad.usage_plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END = COALESCE($3, 'ในแผน')
       LIMIT 1`,
      [plan.product_code, plan.budget_year, plan.usage_plan_flag],
    );

    if (approvalResult.rows.length > 0) {
      await client.query('ROLLBACK');
      return apiError('ไม่สามารถยกเลิกแผนจัดซื้อที่ถูกอ้างอิงในเอกสารอนุมัติได้', 409);
    }

    const result = await client.query(
      `UPDATE public.usage_plan up
       SET purchase_plan_id = NULL,
           updated_at = NOW()
       WHERE up.product_code = $1
         AND up.budget_year = $2
         AND (CASE WHEN COALESCE(up.plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = COALESCE($3, 'ในแผน')
         AND EXISTS (
           SELECT 1
           FROM public.product p
           WHERE p.code = up.product_code
             AND COALESCE(p.purchase_department_id, 0) = COALESCE($4, 0)
         )
       RETURNING id`,
      [plan.product_code, plan.budget_year, plan.usage_plan_flag, plan.purchase_department_id],
    );

    await client.query('COMMIT');

    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');

    return apiSuccess(
      { deleted: result.rowCount ?? 0, id: numericId },
      'ยกเลิกการผูกแผนจัดซื้อสำเร็จ',
    );
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error deleting purchase plan:', error);
    return apiError('Failed to delete purchase plan');
  } finally {
    client.release();
  }
}
