import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// GET /api/sellers - Get all sellers
export async function GET() {
  try {
    const sellers = await prisma.seller.findMany({
      orderBy: {
        id: 'asc'
      }
    });
    
    return NextResponse.json({
      success: true,
      data: sellers,
      count: sellers.length
    });
  } catch (error) {
    console.error('Error fetching sellers:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch sellers' },
      { status: 500 }
    );
  }
}

// POST /api/sellers - Create new seller
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { code, prefix, name, business, address, phone, fax, mobile } = body;

    // Validate required fields
    if (!code || !name) {
      return NextResponse.json(
        { success: false, error: 'Code and name are required' },
        { status: 400 }
      );
    }

    // Check if seller with this code already exists
    const existingSeller = await prisma.seller.findUnique({
      where: { code }
    });

    if (existingSeller) {
      return NextResponse.json(
        { success: false, error: 'Seller with this code already exists' },
        { status: 400 }
      );
    }

    const newSeller = await prisma.seller.create({
      data: {
        code,
        prefix: prefix || null,
        name,
        business: business || null,
        address: address || null,
        phone: phone || null,
        fax: fax || null,
        mobile: mobile || null
      }
    });

    return NextResponse.json({
      success: true,
      data: newSeller,
      message: 'Seller created successfully'
    }, { status: 201 });
  } catch (error) {
    console.error('Error creating seller:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to create seller' },
      { status: 500 }
    );
  }
}

