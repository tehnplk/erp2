import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiNotFound } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateSellerSchema } from '@/lib/validation/schemas';

// GET /api/sellers/[id] - Get seller by ID
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;

    const result = await pgQuery(
      'SELECT id, code, prefix, name, business, address, phone, fax, mobile FROM public."Seller" WHERE id = $1 LIMIT 1',
      [id]
    );
    const seller = result.rows[0];

    if (!seller) {
      return apiNotFound('Seller');
    }

    return apiSuccess(seller);
  } catch (error) {
    console.error('Error fetching seller:', error);
    return apiError('Failed to fetch seller');
  }
}

// PUT /api/sellers/[id] - Update seller
export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;
    
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(updateSellerSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const existingResult = await pgQuery('SELECT id FROM public."Seller" WHERE id = $1 LIMIT 1', [id]);
    if (existingResult.rows.length === 0) {
      return apiNotFound('Seller');
    }

    const columnMap: Record<string, string> = {
      code: 'code',
      prefix: 'prefix',
      name: 'name',
      business: 'business',
      address: 'address',
      phone: 'phone',
      fax: 'fax',
      mobile: 'mobile',
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
      const unchangedResult = await pgQuery('SELECT id, code, prefix, name, business, address, phone, fax, mobile FROM public."Seller" WHERE id = $1 LIMIT 1', [id]);
      return apiSuccess(unchangedResult.rows[0], 'Seller updated successfully');
    }

    values.push(id);
    const updatedResult = await pgQuery(
      `UPDATE public."Seller" SET ${assignments.join(', ')} WHERE id = $${values.length}
       RETURNING id, code, prefix, name, business, address, phone, fax, mobile`,
      values
    );

    return apiSuccess(updatedResult.rows[0], 'Seller updated successfully');
  } catch (error) {
    console.error('Error updating seller:', error);
    return apiError('Failed to update seller');
  }
}

// DELETE /api/sellers/[id] - Delete seller
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;

    const existingResult = await pgQuery('SELECT id FROM public."Seller" WHERE id = $1 LIMIT 1', [id]);
    if (existingResult.rows.length === 0) {
      return apiNotFound('Seller');
    }

    await pgQuery('DELETE FROM public."Seller" WHERE id = $1', [id]);

    return apiSuccess(null, 'Seller deleted successfully');
  } catch (error) {
    console.error('Error deleting seller:', error);
    return apiError('Failed to delete seller');
  }
}
