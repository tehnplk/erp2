import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiNotFound, apiConflict } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateProductSchema } from '@/lib/validation/schemas';

const productSelect = `SELECT id, code, category, name, type, subtype, unit, cost_price::float8 AS cost_price, sell_price::float8 AS sell_price, stock_balance, stock_value::float8 AS stock_value, seller_code, image, flag_activate, admin_note FROM public.product`;

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }

    const { id } = idValidation.data;
    const productResult = await pgQuery(`${productSelect} WHERE id = $1 LIMIT 1`, [id]);
    const product = productResult.rows[0];

    if (!product) {
      return apiNotFound('Product');
    }

    return apiSuccess(product);
  } catch (error) {
    console.error('Error fetching product:', error);
    return apiError('Failed to fetch product');
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }

    const { id } = idValidation.data;
    const body = await request.json();
    const validation = await validateRequest(updateProductSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const existingProductResult = await pgQuery(`SELECT id, code FROM public.product WHERE id = $1 LIMIT 1`, [id]);
    const existingProduct = existingProductResult.rows[0];
    if (!existingProduct) {
      return apiNotFound('Product');
    }

    const { code } = validation.data as any;
    if (code && code !== existingProduct.code) {
      const duplicateCodeResult = await pgQuery(`SELECT id FROM public.product WHERE code = $1 LIMIT 1`, [code]);
      if (duplicateCodeResult.rows.length > 0) {
        return apiConflict('Product with this code already exists');
      }
    }

    const columnMap: Record<string, string> = {
      code: 'code',
      category: 'category',
      name: 'name',
      type: 'type',
      subtype: 'subtype',
      unit: 'unit',
      cost_price: 'cost_price',
      sell_price: 'sell_price',
      stock_balance: 'stock_balance',
      stock_value: 'stock_value',
      seller_code: 'seller_code',
      image: 'image',
      admin_note: 'admin_note',
    };

    const assignments: string[] = [];
    const values: unknown[] = [];

    Object.entries(validation.data as Record<string, unknown>).forEach(([key, value]) => {
      const column = columnMap[key];
      if (!column) return;
      values.push(value ?? null);
      assignments.push(`${column} = $${values.length}`);
    });

    if (assignments.length === 0) {
      const unchangedResult = await pgQuery(`${productSelect} WHERE id = $1 LIMIT 1`, [id]);
      return apiSuccess(unchangedResult.rows[0], 'Product updated successfully');
    }

    values.push(id);
    const result = await pgQuery(
      `UPDATE public.product SET ${assignments.join(', ')} WHERE id = $${values.length} RETURNING id, code, category, name, type, subtype, unit, cost_price::float8 AS cost_price, sell_price::float8 AS sell_price, stock_balance, stock_value::float8 AS stock_value, seller_code, image, flag_activate, admin_note`,
      values
    );

    await cacheDelByPattern('erp:products:list:*');

    return apiSuccess(result.rows[0], 'Product updated successfully');
  } catch (error) {
    console.error('Error updating product:', error);
    return apiError('Failed to update product');
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }

    const { id } = idValidation.data;
    const productResult = await pgQuery(`SELECT id FROM public.product WHERE id = $1 LIMIT 1`, [id]);
    if (productResult.rows.length === 0) {
      return apiNotFound('Product');
    }

    await pgQuery(`DELETE FROM public.product WHERE id = $1`, [id]);
    await cacheDelByPattern('erp:products:list:*');
    return apiSuccess(null, 'Product deleted successfully');
  } catch (error) {
    console.error('Error deleting product:', error);
    return apiError('Failed to delete product');
  }
}
