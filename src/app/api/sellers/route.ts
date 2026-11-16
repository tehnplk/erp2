import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateRequest, validateQuery } from '@/lib/validation/validate';
import { createSellerSchema, sellerQuerySchema } from '@/lib/validation/schemas';
import { runListQuery } from '@/lib/list-query';

// GET /api/sellers - Get sellers with optional pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(sellerQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { name, include_inactive: includeInactive, page, page_size: pageSize } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];
    if (name) {
      params.push(`%${name}%`);
      whereClauses.push(`name ILIKE $${params.length}`);
    }

    if (!includeInactive) {
      whereClauses.unshift('is_active = true');
    }
    const list = await runListQuery(
      {
        columns: 'id, code, prefix, name, business, address, phone, fax, mobile, COALESCE(category_code_sale, ARRAY[]::text[]) AS category_code_sale, is_active',
        from: 'public.seller',
        where: whereClauses,
        params,
        orderBy: 'id ASC',
        page,
        pageSize,
        cache: { namespace: 'erp:sellers:list', ttlSeconds: 3600, get: cacheGet, set: cacheSet },
      },
      pgQuery
    );
    return apiSuccess(list.rows, undefined, list.totalCount, 200, list.meta);
  } catch (error) {
    console.error('Error fetching sellers:', error);
    return apiError('Failed to fetch sellers');
  }
}

// POST /api/sellers - Create new seller
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createSellerSchema, body);
    if (!validation.success) {
      return validation.error;
    }
    
    const { code } = validation.data as any;

    // Check if seller with this code already exists
    const existingResult = await pgQuery('SELECT id FROM public.seller WHERE code = $1 LIMIT 1', [code]);
    if (existingResult.rows.length > 0) {
      return apiConflict('Seller with this code already exists');
    }

    const result = await pgQuery(
      `INSERT INTO public.seller (code, prefix, name, business, address, phone, fax, mobile, category_code_sale, is_active)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9::text[], $10)
       RETURNING id, code, prefix, name, business, address, phone, fax, mobile, COALESCE(category_code_sale, ARRAY[]::text[]) AS category_code_sale, is_active`,
      [
        validation.data.code,
        validation.data.prefix || null,
        validation.data.name,
        validation.data.business || null,
        validation.data.address || null,
        validation.data.phone || null,
        validation.data.fax || null,
        validation.data.mobile || null,
        validation.data.category_code_sale ?? [],
        validation.data.is_active ?? true,
      ]
    );

    await cacheDelByPattern('erp:sellers:list:*');

    return apiSuccess(result.rows[0], 'Seller created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating seller:', error);
    return apiError('Failed to create seller');
  }
}
