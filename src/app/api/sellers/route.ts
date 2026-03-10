import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateRequest, validateQuery } from '@/lib/validation/validate';
import { createSellerSchema, sellerQuerySchema } from '@/lib/validation/schemas';

// GET /api/sellers - Get sellers with optional pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(sellerQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { name, page, page_size: pageSize } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];
    if (name) {
      params.push(`%${name}%`);
      whereClauses.push(`name ILIKE $${params.length}`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const baseSelect = 'SELECT id, code, prefix, name, business, address, phone, fax, mobile FROM public.seller';

    const cacheKeyAll = `erp:sellers:list:all:${JSON.stringify(params)}`;
    if (!page || !pageSize) {
      const cachedAll = await cacheGet<any>(cacheKeyAll);
      if (cachedAll) return apiSuccess(cachedAll.rows, undefined, cachedAll.rows.length);

      const result = await pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC`, params);
      await cacheSet(cacheKeyAll, { rows: result.rows }, 3600);
      return apiSuccess(result.rows, undefined, result.rows.length);
    }

    const skip = (page - 1) * pageSize;

    // --- Redis Caching Logic (Paginated) ---
    const cacheKey = `erp:sellers:list:${JSON.stringify({ ...queryValidation.data, page, page_size: pageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, page_size: pageSize });
    }

    const [countResult, result] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.seller ${whereSql}`, params),
      pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, skip]),
    ]);

    const finalResult = {
      items: result.rows,
      totalCount: countResult.rows[0]?.count || 0
    };

    await cacheSet(cacheKey, finalResult, 3600);
    
    return apiSuccess(finalResult.items, undefined, finalResult.totalCount, 200, { page, page_size: pageSize });
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
      `INSERT INTO public.seller (code, prefix, name, business, address, phone, fax, mobile)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING id, code, prefix, name, business, address, phone, fax, mobile`,
      [
        validation.data.code,
        validation.data.prefix || null,
        validation.data.name,
        validation.data.business || null,
        validation.data.address || null,
        validation.data.phone || null,
        validation.data.fax || null,
        validation.data.mobile || null,
      ]
    );

    await cacheDelByPattern('erp:sellers:list:*');

    return apiSuccess(result.rows[0], 'Seller created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating seller:', error);
    return apiError('Failed to create seller');
  }
}
