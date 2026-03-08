import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDel, cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';

// GET /api/departments/[id] - Get a specific department
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseInt(id, 10);
    
    if (isNaN(numericId)) {
      return NextResponse.json(
        { error: 'Invalid department ID' },
        { status: 400 }
      );
    }

    const cacheKey = `erp:departments:detail:${numericId}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return NextResponse.json(cached);
    }

    const result = await pgQuery('SELECT id, name FROM public."Department" WHERE id = $1 LIMIT 1', [numericId]);
    const department = result.rows[0];

    if (!department) {
      return NextResponse.json(
        { error: 'Department not found' },
        { status: 404 }
      );
    }

    await cacheSet(cacheKey, department, 3600);

    return NextResponse.json(department);
  } catch (error) {
    console.error('Error fetching department:', error);
    return NextResponse.json(
      { error: 'Failed to fetch department' },
      { status: 500 }
    );
  }
}

// PUT /api/departments/[id] - Update a specific department
export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseInt(id, 10);
    
    if (isNaN(numericId)) {
      return NextResponse.json(
        { error: 'Invalid department ID' },
        { status: 400 }
      );
    }

    const body = await request.json();
    const { name } = body;

    if (!name) {
      return NextResponse.json(
        { error: 'Name is required' },
        { status: 400 }
      );
    }

    const existingResult = await pgQuery('SELECT id FROM public."Department" WHERE id = $1 LIMIT 1', [numericId]);

    if (existingResult.rows.length === 0) {
      return NextResponse.json(
        { error: 'Department not found' },
        { status: 404 }
      );
    }

    const updatedResult = await pgQuery(
      'UPDATE public."Department" SET name = $1 WHERE id = $2 RETURNING id, name',
      [name, numericId]
    );

    await cacheDelByPattern('erp:departments:list:*');
    await cacheDel(`erp:departments:detail:${numericId}`);
    return NextResponse.json(updatedResult.rows[0]);
  } catch (error) {
    console.error('Error updating department:', error);
    return NextResponse.json(
      { error: 'Failed to update department' },
      { status: 500 }
    );
  }
}

// DELETE /api/departments/[id] - Delete a specific department
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseInt(id, 10);
    
    if (isNaN(numericId)) {
      return NextResponse.json(
        { error: 'Invalid department ID' },
        { status: 400 }
      );
    }

    const existingResult = await pgQuery('SELECT id FROM public."Department" WHERE id = $1 LIMIT 1', [numericId]);

    if (existingResult.rows.length === 0) {
      return NextResponse.json(
        { error: 'Department not found' },
        { status: 404 }
      );
    }

    await pgQuery('DELETE FROM public."Department" WHERE id = $1', [numericId]);
    await cacheDelByPattern('erp:departments:list:*');
    await cacheDel(`erp:departments:detail:${numericId}`);

    return NextResponse.json(
      { message: 'Department deleted successfully' },
      { status: 200 }
    );
  } catch (error) {
    console.error('Error deleting department:', error);
    return NextResponse.json(
      { error: 'Failed to delete department' },
      { status: 500 }
    );
  }
}
