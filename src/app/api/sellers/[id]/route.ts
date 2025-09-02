import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// GET /api/sellers/[id] - Get seller by ID
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    
    if (isNaN(id)) {
      return NextResponse.json(
        { success: false, error: 'Invalid seller ID' },
        { status: 400 }
      );
    }

    const seller = await prisma.seller.findUnique({
      where: { id }
    });

    if (!seller) {
      return NextResponse.json(
        { success: false, error: 'Seller not found' },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      data: seller
    });
  } catch (error) {
    console.error('Error fetching seller:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch seller' },
      { status: 500 }
    );
  }
}

// PUT /api/sellers/[id] - Update seller
export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    const body = await request.json();
    const { code, prefix, name, business, address, phone, fax, mobile } = body;

    if (isNaN(id)) {
      return NextResponse.json(
        { success: false, error: 'Invalid seller ID' },
        { status: 400 }
      );
    }

    // Validate required fields
    if (!code || !name) {
      return NextResponse.json(
        { success: false, error: 'Code and name are required' },
        { status: 400 }
      );
    }

    const updatedSeller = await prisma.seller.update({
      where: { id },
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
      data: updatedSeller,
      message: 'Seller updated successfully'
    });
  } catch (error: any) {
    console.error('Error updating seller:', error);
    if (error.code === 'P2025') {
      return NextResponse.json(
        { success: false, error: 'Seller not found' },
        { status: 404 }
      );
    }
    return NextResponse.json(
      { success: false, error: 'Failed to update seller' },
      { status: 500 }
    );
  }
}

// DELETE /api/sellers/[id] - Delete seller
export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);

    if (isNaN(id)) {
      return NextResponse.json(
        { success: false, error: 'Invalid seller ID' },
        { status: 400 }
      );
    }

    await prisma.seller.delete({
      where: { id }
    });

    return NextResponse.json({
      success: true,
      message: 'Seller deleted successfully'
    });
  } catch (error: any) {
    console.error('Error deleting seller:', error);
    if (error.code === 'P2025') {
      return NextResponse.json(
        { success: false, error: 'Seller not found' },
        { status: 404 }
      );
    }
    return NextResponse.json(
      { success: false, error: 'Failed to delete seller' },
      { status: 500 }
    );
  }
}
