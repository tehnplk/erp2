import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
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

    const { name, page, pageSize } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];
    if (name) {
      params.push(`%${name}%`);
      whereClauses.push(`name ILIKE $${params.length}`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const baseSelect = 'SELECT id, code, prefix, name, business, address, phone, fax, mobile FROM public."Seller"';

    if (!page || !pageSize) {
      const result = await pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC`, params);
      return apiSuccess(result.rows, undefined, result.rows.length);
    }

    const skip = (page - 1) * pageSize;
    const [countResult, result] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."Seller" ${whereSql}`, params),
      pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, skip]),
    ]);
    
    return apiSuccess(result.rows, undefined, countResult.rows[0]?.count || 0, 200, { page, pageSize });
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
    const existingResult = await pgQuery('SELECT id FROM public."Seller" WHERE code = $1 LIMIT 1', [code]);
    if (existingResult.rows.length > 0) {
      return apiConflict('Seller with this code already exists');
    }

    const result = await pgQuery(
      `INSERT INTO public."Seller" (code, prefix, name, business, address, phone, fax, mobile)
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

    return apiSuccess(result.rows[0], 'Seller created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating seller:', error);
    return apiError('Failed to create seller');
  }
}
