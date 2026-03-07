import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { productQuerySchema, createProductSchema } from '@/lib/validation/schemas';

const productSelect = `SELECT id, code, category, name, type, subtype, unit, "costPrice"::float8 AS "costPrice", "sellPrice"::float8 AS "sellPrice", "stockBalance", "stockValue"::float8 AS "stockValue", "sellerCode", image, "flagActivate", "adminNote" FROM public."Product"`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(productQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { name, category, type, subtype, orderBy, sortOrder, page = 1, pageSize = 20 } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

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
      costPrice: '"costPrice"',
      sellPrice: '"sellPrice"',
    };
    const safeOrderField = allowedOrderFields[orderBy || 'id'] || 'id';
    const safeSortOrder = sortOrder === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const skip = (page - 1) * pageSize;

    const [totalCountResult, productsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."Product" ${whereSql}`, params),
      pgQuery(`${productSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, skip]),
    ]);

    return apiSuccess(productsResult.rows, undefined, totalCountResult.rows[0]?.count || 0, 200, { page, pageSize });
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
    const existingProductResult = await pgQuery(`SELECT id FROM public."Product" WHERE code = $1 LIMIT 1`, [code]);
    if (existingProductResult.rows.length > 0) {
      return apiConflict('Product with this code already exists');
    }

    const result = await pgQuery(
      `INSERT INTO public."Product" (code, category, name, type, subtype, unit, "costPrice", "sellPrice", "stockBalance", "stockValue", "sellerCode", image, "adminNote")
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
       RETURNING id, code, category, name, type, subtype, unit, "costPrice"::float8 AS "costPrice", "sellPrice"::float8 AS "sellPrice", "stockBalance", "stockValue"::float8 AS "stockValue", "sellerCode", image, "flagActivate", "adminNote"`,
      [
        validation.data.code,
        validation.data.category,
        validation.data.name,
        validation.data.type || null,
        validation.data.subtype || null,
        validation.data.unit || null,
        validation.data.costPrice ?? null,
        validation.data.sellPrice ?? null,
        validation.data.stockBalance ?? null,
        validation.data.stockValue ?? null,
        validation.data.sellerCode || null,
        validation.data.image || null,
        validation.data.adminNote || null,
      ]
    );

    return apiSuccess(result.rows[0], 'Product created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating product:', error);
    return apiError('Failed to create product');
  }
}
