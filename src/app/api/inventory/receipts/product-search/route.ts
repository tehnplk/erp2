import { NextRequest } from 'next/server';
import { apiError, apiSuccess } from '@/lib/api-response';
import { pgQuery } from '@/lib/pg';
import { inventoryProductSearchQuerySchema } from '@/lib/validation/schemas';
import { validateQuery } from '@/lib/validation/validate';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryProductSearchQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { q, limit = 20 } = queryValidation.data;
    const keyword = `%${q.trim()}%`;

    const result = await pgQuery<{
      id: number;
      code: string;
      name: string;
      unit: string | null;
      cost_price: number | null;
    }>(
      `SELECT id, code, name, unit, cost_price::float8
       FROM public.product
       WHERE is_active = true
         AND (code ILIKE $1 OR name ILIKE $1)
       ORDER BY code ASC
       LIMIT $2`,
      [keyword, limit]
    );

    return apiSuccess(result.rows);
  } catch (error) {
    console.error('Error searching product:', error);
    return apiError('Failed to search product');
  }
}
