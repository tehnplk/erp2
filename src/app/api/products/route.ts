import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { productQuerySchema, createProductSchema } from '@/lib/validation/schemas';
import { buildNextProductCode, getProductCodePrefixForCategory } from '@/lib/product-code';
import { runListQuery } from '@/lib/list-query';

const productColumns = `id, code, category, name, type, subtype, unit, purchase_department_id, cost_price::float8 AS cost_price, sell_price::float8 AS sell_price, stock_balance, stock_value::float8 AS stock_value, seller_code, image, flag_activate, admin_note, is_active`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(productQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { code, name, search, category, type, subtype, include_inactive: includeInactive, order_by, sort_order, page = 1, page_size: pageSize = 20 } = queryValidation.data as any;

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

    if (!includeInactive) {
      whereClauses.unshift('is_active = true');
    }
    const list = await runListQuery(
      {
        columns: productColumns,
        from: 'public.product',
        where: whereClauses,
        params,
        orderBy: {
          key: order_by,
          allowed: ['id', 'code', 'name', 'category', 'type', 'subtype', 'cost_price', 'sell_price'],
          fallback: 'id',
          direction: sort_order === 'asc' ? 'ASC' : 'DESC',
        },
        page,
        pageSize,
        cache: { namespace: 'erp:products:list', ttlSeconds: 1800, get: cacheGet, set: cacheSet },
      },
      pgQuery
    );
    return apiSuccess(list.rows, undefined, list.totalCount, 200, list.meta);
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

    const requestedCode = validation.data.code?.trim() ?? '';
    let productCode = requestedCode;

    if (!productCode) {
      const prefix = getProductCodePrefixForCategory(validation.data.category);
      if (!prefix) {
        return apiError('ไม่สามารถสร้างรหัสสินค้าอัตโนมัติสำหรับหมวดนี้ได้', 400);
      }

      const existingCodesResult = await pgQuery<{ code: string }>(
        `SELECT code
         FROM public.product
         WHERE code LIKE $1
         ORDER BY code DESC`,
        [`${prefix}-%`]
      );
      productCode = buildNextProductCode(prefix, existingCodesResult.rows.map((row) => row.code));
    }

    const existingProductResult = await pgQuery(`SELECT id FROM public.product WHERE code = $1 LIMIT 1`, [productCode]);
    if (existingProductResult.rows.length > 0) {
      return apiConflict('Product with this code already exists');
    }

    const result = await pgQuery(
      `INSERT INTO public.product (code, category, name, type, subtype, unit, purchase_department_id, cost_price, sell_price, stock_balance, stock_value, seller_code, image, admin_note, is_active)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
       RETURNING id, code, category, name, type, subtype, unit, purchase_department_id, cost_price::float8 AS cost_price, sell_price::float8 AS sell_price, stock_balance, stock_value::float8 AS stock_value, seller_code, image, flag_activate, admin_note, is_active`,
      [
        productCode,
        validation.data.category,
        validation.data.name,
        validation.data.type || null,
        validation.data.subtype || null,
        validation.data.unit || null,
        validation.data.purchase_department_id ?? null,
        validation.data.cost_price ?? null,
        validation.data.sell_price ?? null,
        validation.data.stock_balance ?? null,
        validation.data.stock_value ?? null,
        validation.data.seller_code || null,
        validation.data.image || null,
        validation.data.admin_note || null,
        validation.data.is_active ?? true,
      ]
    );

    await cacheDelByPattern('erp:products:list:*');

    return apiSuccess(result.rows[0], 'Product created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating product:', error);
    return apiError('Failed to create product');
  }
}
