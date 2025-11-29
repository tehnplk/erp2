import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateSurveySchema } from '@/lib/validation/schemas';

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
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

    const validation = await validateRequest(updateSurveySchema, body);
    if (!validation.success) {
      return validation.error;
    }
    
    const survey = await prisma.survey.update({
      where: { id: numericId },
      data: validation.data as any,
    });
    
    return NextResponse.json(survey);
  } catch (error) {
    console.error('Error updating survey:', error);
    return NextResponse.json(
      { error: 'Failed to update survey' },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
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
    
    await prisma.survey.delete({
      where: { id: numericId }
    });
    
    return NextResponse.json({ message: 'Survey deleted successfully' });
  } catch (error) {
    console.error('Error deleting survey:', error);
    return NextResponse.json(
      { error: 'Failed to delete survey' },
      { status: 500 }
    );
  }
}
