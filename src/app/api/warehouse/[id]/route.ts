import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateWarehouseSchema } from '@/lib/validation/schemas';

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;

    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json(
        { error: 'Invalid ID format' },
        { status: 400 }
      );
    }

    const numericId = parsedId.data.id;
    const body = await request.json();

    const validation = await validateRequest(updateWarehouseSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const updated = await prisma.warehouse.update({ where: { id: numericId }, data: validation.data as any });
    return NextResponse.json(updated);
  } catch (error) {
    console.error('Error updating warehouse record:', error);
    return NextResponse.json({ error: 'Failed to update warehouse record' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;

    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json(
        { error: 'Invalid ID format' },
        { status: 400 }
      );
    }

    const numericId = parsedId.data.id;
    await prisma.warehouse.delete({ where: { id: numericId } });
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting warehouse record:', error);
    return NextResponse.json({ error: 'Failed to delete warehouse record' }, { status: 500 });
  }
}
