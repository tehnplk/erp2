import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';

export async function POST(request: NextRequest) {
  try {
    const { product_code, requesting_dept, budget_year } = await request.json();

    // Validate input
    if (!product_code || !requesting_dept || !budget_year) {
      return NextResponse.json(
        { error: 'ข้อมูลไม่ครบถ้วน' },
        { status: 400 }
      );
    }

    // Check existing usage plans for the same product, department, and budget year
    const query = `
      SELECT COUNT(*) as count
      FROM public.usage_plan 
      WHERE product_code = $1 
        AND requesting_dept = $2 
        AND budget_year = $3
    `;
    
    const result = await pgQuery(query, [product_code, requesting_dept, budget_year]);
    const existingCount = parseInt(result.rows[0].count);

    // If already 2 or more usage plans exist, return error
    if (existingCount >= 2) {
      return NextResponse.json(
        { error: 'ในปีงบประมาณนี้ แผนกนี้ ขอใช้สินค้านี้ ครบ 2 ครั้งแล้ว' },
        { status: 400 }
      );
    }

    // If less than 2, allow the operation
    return NextResponse.json({ 
      allowed: true,
      existingCount: existingCount 
    });

  } catch (error) {
    console.error('Error checking usage plan constraint:', error);
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการตรวจสอบข้อมูล' },
      { status: 500 }
    );
  }
}
