import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess } from '@/lib/api-response';

export async function GET(request: NextRequest) {
  try {
    // Return all approved purchase plans regardless of budget year
    const query = `
      SELECT DISTINCT pad.purchase_plan_id
      FROM purchase_approval_detail pad
      JOIN purchase_approval pa ON pad.purchase_approval_id = pa.id
      WHERE pad.status = 'PENDING'
    `;

    const result = await pgQuery(query, []);

    const approvedPlanIds = result.rows.map((row: { purchase_plan_id: number }) => row.purchase_plan_id);

    return apiSuccess(approvedPlanIds);
  } catch (error) {
    console.error('Error in approved purchase plans API:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}
