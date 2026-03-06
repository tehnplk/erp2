import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateSurveySchema } from '@/lib/validation/schemas';

const buildSurveyConstraintError = () =>
  NextResponse.json(
    { error: 'สินค้าเดิม หน่วยงานเดิม และปีงบเดิม สามารถมีได้ไม่เกิน 2 ครั้ง' },
    { status: 400 }
  );

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

    const currentSurveyResult = await pgQuery(
      `SELECT id, "productCode", category, type, subtype, "productName", "requestedAmount", unit, "pricePerUnit"::float8 AS "pricePerUnit", "requestingDept", "approvedQuota", budget_year AS "budgetYear", sequence_no AS "sequenceNo", created_at AS "createdAt", updated_at AS "updatedAt" FROM public."Survey" WHERE id = $1 LIMIT 1`,
      [numericId]
    );
    const currentSurvey = currentSurveyResult.rows[0];

    if (!currentSurvey) {
      return NextResponse.json({ error: 'Survey not found' }, { status: 404 });
    }

    const nextData = {
      ...currentSurvey,
      ...(validation.data as any),
    };

    if (nextData.budgetYear === null || nextData.budgetYear === undefined) {
      nextData.budgetYear = currentSurvey.budgetYear ?? 2569;
    }

    if (nextData.sequenceNo === null || nextData.sequenceNo === undefined) {
      nextData.sequenceNo = currentSurvey.sequenceNo ?? 1;
    }

    if (nextData.budgetYear !== null && nextData.budgetYear !== undefined) {
      const duplicateWhere: any = {
        budgetYear: nextData.budgetYear,
        requestingDept: nextData.requestingDept || null,
        productCode: nextData.productCode || null,
      };

      const existingRecordsResult = await pgQuery(
        `SELECT id, sequence_no AS "sequenceNo" FROM public."Survey" WHERE budget_year = $1 AND "requestingDept" IS NOT DISTINCT FROM $2 AND "productCode" IS NOT DISTINCT FROM $3`,
        [duplicateWhere.budgetYear, duplicateWhere.requestingDept, duplicateWhere.productCode]
      );
      const recordsExcludingCurrent = existingRecordsResult.rows.filter((survey: any) => survey.id !== numericId);

      if (nextData.sequenceNo !== null && nextData.sequenceNo !== undefined) {
        const duplicatedSequence = recordsExcludingCurrent.some((survey: any) => survey.sequenceNo === nextData.sequenceNo);
        if (duplicatedSequence) {
          return buildSurveyConstraintError();
        }
      }

      if (recordsExcludingCurrent.length >= 2) {
        return buildSurveyConstraintError();
      }
    }
    
    const payload = {
      ...(validation.data as any),
      budgetYear: nextData.budgetYear,
      sequenceNo: nextData.sequenceNo,
    };
    const assignments: string[] = [];
    const values: unknown[] = [];
    const columnMap: Record<string, string> = {
      productCode: '"productCode"',
      category: 'category',
      type: 'type',
      subtype: 'subtype',
      productName: '"productName"',
      requestedAmount: '"requestedAmount"',
      unit: 'unit',
      pricePerUnit: '"pricePerUnit"',
      requestingDept: '"requestingDept"',
      approvedQuota: '"approvedQuota"',
      budgetYear: 'budget_year',
      sequenceNo: 'sequence_no',
    };

    Object.entries(payload).forEach(([key, value]) => {
      const column = columnMap[key];
      if (!column) return;
      values.push(value ?? null);
      assignments.push(`${column} = $${values.length}`);
    });

    if (assignments.length === 0) {
      return NextResponse.json(currentSurvey);
    }

    values.push(numericId);
    const survey = await pgQuery(
      `UPDATE public."Survey" SET ${assignments.join(', ')}, updated_at = NOW() WHERE id = $${values.length} RETURNING id, "productCode", category, type, subtype, "productName", "requestedAmount", unit, "pricePerUnit"::float8 AS "pricePerUnit", "requestingDept", "approvedQuota", budget_year AS "budgetYear", sequence_no AS "sequenceNo", created_at AS "createdAt", updated_at AS "updatedAt"`,
      values
    );
    
    return NextResponse.json(survey.rows[0]);
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
    
    await pgQuery('DELETE FROM public."Survey" WHERE id = $1', [numericId]);
    
    return NextResponse.json({ message: 'Survey deleted successfully' });
  } catch (error) {
    console.error('Error deleting survey:', error);
    return NextResponse.json(
      { error: 'Failed to delete survey' },
      { status: 500 }
    );
  }
}
