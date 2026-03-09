import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDel, cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';

// GET /api/categories/[id] - Get category by ID
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseInt(id, 10);
    
    if (isNaN(numericId)) {
      return NextResponse.json(
        { success: false, error: 'Invalid category ID' },
        { status: 400 }
      );
    }

    const cacheKey = `erp:categories:detail:${numericId}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return NextResponse.json({
        success: true,
        data: cached
      });
    }

    const result = await pgQuery(
      'SELECT id, category, type, subtype FROM public.category WHERE id = $1 LIMIT 1',
      [numericId]
    );
    const category = result.rows[0];

    if (!category) {
      return NextResponse.json(
        { success: false, error: 'Category not found' },
        { status: 404 }
      );
    }

    await cacheSet(cacheKey, category, 3600);

    return NextResponse.json({
      success: true,
      data: category
    });
  } catch (error) {
    console.error('Error fetching category:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch category' },
      { status: 500 }
    );
  }
}

// PUT /api/categories/[id] - Update category
export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseInt(id, 10);
    const body = await request.json();
    const { category, type, subtype } = body;

    if (isNaN(numericId)) {
      return NextResponse.json(
        { success: false, error: 'Invalid category ID' },
        { status: 400 }
      );
    }

    if (!category || !type || !subtype) {
      return NextResponse.json(
        { success: false, error: 'Category, type, and subtype are required' },
        { status: 400 }
      );
    }

    const existingResult = await pgQuery('SELECT id FROM public.category WHERE id = $1 LIMIT 1', [numericId]);
    if (existingResult.rows.length === 0) {
      return NextResponse.json(
        { success: false, error: 'Category not found' },
        { status: 404 }
      );
    }

    const updatedResult = await pgQuery(
      `UPDATE public.category
       SET category = $1, type = $2, subtype = $3
       WHERE id = $4
       RETURNING id, category, type, subtype`,
      [category, type, subtype, numericId]
    );

    await cacheDelByPattern('erp:categories:list:*');
    await cacheDel(`erp:categories:detail:${numericId}`);

    return NextResponse.json({
      success: true,
      data: updatedResult.rows[0],
      message: 'Category updated successfully'
    });
  } catch (error) {
    console.error('Error updating category:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to update category' },
      { status: 500 }
    );
  }
}

// DELETE /api/categories/[id] - Delete category
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseInt(id, 10);

    if (isNaN(numericId)) {
      return NextResponse.json(
        { success: false, error: 'Invalid category ID' },
        { status: 400 }
      );
    }

    const existingResult = await pgQuery('SELECT id FROM public.category WHERE id = $1 LIMIT 1', [numericId]);
    if (existingResult.rows.length === 0) {
      return NextResponse.json(
        { success: false, error: 'Category not found' },
        { status: 404 }
      );
    }

    await pgQuery('DELETE FROM public.category WHERE id = $1', [numericId]);

    await cacheDelByPattern('erp:categories:list:*');
    await cacheDel(`erp:categories:detail:${numericId}`);

    return NextResponse.json({
      success: true,
      message: 'Category deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting category:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to delete category' },
      { status: 500 }
    );
  }
}
