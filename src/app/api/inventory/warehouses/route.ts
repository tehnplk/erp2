import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';

export async function GET(_request: NextRequest) {
  try {
    const result = await pgQuery<{ id: number; warehouse_code: string; warehouse_name: string }>(
      `SELECT id, warehouse_code, warehouse_name
       FROM public.inventory_warehouse
       WHERE COALESCE(is_active, true) = true
       ORDER BY warehouse_code ASC`
    );

    return apiSuccess(result.rows);
  } catch (error) {
    console.error('Error fetching inventory warehouses:', error);
    return apiError('ไม่สามารถโหลดรายการคลังสินค้าได้');
  }
}
