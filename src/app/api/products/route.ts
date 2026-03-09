import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { productQuerySchema, createProductSchema } from '@/lib/validation/schemas';

const productSelect = `SELECT id, code, category, name, type, subtype, unit, cost_price::float8 AS cost_price, sell_price::float8 AS sell_price, stock_balance, stock_value::float8 AS stock_value, seller_code, image, flag_activate, admin_note FROM public.product`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(productQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { code, name, search, category, type, subtype, order_by, sort_order, page = 1, page_size: pageSize = 20 } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (search) {
      params.push(`%${search}%`);
      const searchParamIndex = params.length;
      whereClauses.push(`(code ILIKE $${searchParamIndex} OR name ILIKE $${searchParamIndex})`);
    }
    if (code) {
      params.push(`%${code}%`);
      whereClauses.push(`code ILIKE $${params.length}`);
    }
    if (name) {
      params.push(`%${name}%`);
      whereClauses.push(`name ILIKE $${params.length}`);
    }
    if (category) {
      params.push(category);
      whereClauses.push(`category = $${params.length}`);
    }
    if (type) {
      params.push(type);
      whereClauses.push(`type = $${params.length}`);
    }
    if (subtype) {
      params.push(subtype);
      whereClauses.push(`subtype = $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      code: 'code',
      name: 'name',
      category: 'category',
      type: 'type',
      subtype: 'subtype',
      cost_price: 'cost_price',
      sell_price: 'sell_price',
    };
    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'id';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const skip = (page - 1) * pageSize;

    // --- Redis Caching Logic ---
    const cacheKey = `erp:products:list:${JSON.stringify({ ...queryValidation.data, page, page_size: pageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, page_size: pageSize });
    }

    const [totalCountResult, productsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.product ${whereSql}`, params),
      pgQuery(`${productSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, skip]),
    ]);

    const result = {
      items: productsResult.rows,
      totalCount: totalCountResult.rows[0]?.count || 0
    };

    await cacheSet(cacheKey, result, 1800); // 30 minutes

    return apiSuccess(result.items, undefined, result.totalCount, 200, { page, page_size: pageSize });
  } catch (error) {
    console.error('Error fetching products:', error);
    return apiError('Failed to fetch products');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const validation = await validateRequest(createProductSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const { code } = validation.data;
    const existingProductResult = await pgQuery(`SELECT id FROM public.product WHERE code = $1 LIMIT 1`, [code]);
    if (existingProductResult.rows.length > 0) {
      return apiConflict('Product with this code already exists');
    }

    const result = await pgQuery(
      `INSERT INTO public.product (code, category, name, type, subtype, unit, cost_price, sell_price, stock_balance, stock_value, seller_code, image, admin_note)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
       RETURNING id, code, category, name, type, subtype, unit, cost_price::float8 AS cost_price, sell_price::float8 AS sell_price, stock_balance, stock_value::float8 AS stock_value, seller_code, image, flag_activate, admin_note`,
      [
        validation.data.code,
        validation.data.category,
        validation.data.name,
        validation.data.type || null,
        validation.data.subtype || null,
        validation.data.unit || null,
        validation.data.cost_price ?? null,
        validation.data.sell_price ?? null,
        validation.data.stock_balance ?? null,
        validation.data.stock_value ?? null,
        validation.data.seller_code || null,
        validation.data.image || null,
        validation.data.admin_note || null,
      ]
    );

    await cacheDelByPattern('erp:products:list:*');

    return apiSuccess(result.rows[0], 'Product created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating product:', error);
    return apiError('Failed to create product');
  }
}
