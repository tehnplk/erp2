import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const product = await prisma.product.findUnique({
      where: { id: parseInt(params.id) }
    });

    if (!product) {
      return NextResponse.json(
        { error: 'Product not found' },
        { status: 404 }
      );
    }

    return NextResponse.json(product);
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch product' },
      { status: 500 }
    );
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const body = await request.json();
    const {
      code,
      category,
      name,
      type,
      subtype,
      unit,
      costPrice,
      sellPrice,
      stockBalance,
      stockValue,
      sellerCode,
      image,
      flagActivate,
      adminNote
    } = body;

    const existingProduct = await prisma.product.findUnique({
      where: { id: parseInt(params.id) }
    });

    if (!existingProduct) {
      return NextResponse.json(
        { error: 'Product not found' },
        { status: 404 }
      );
    }

    if (code && code !== existingProduct.code) {
      const duplicateCode = await prisma.product.findUnique({
        where: { code }
      });
      if (duplicateCode) {
        return NextResponse.json(
          { error: 'Product with this code already exists' },
          { status: 409 }
        );
      }
    }

    const product = await prisma.product.update({
      where: { id: parseInt(params.id) },
      data: {
        code,
        category,
        name,
        type,
        subtype,
        unit,
        costPrice: costPrice !== undefined ? parseFloat(costPrice) : undefined,
        sellPrice: sellPrice !== undefined ? parseFloat(sellPrice) : undefined,
        stockBalance: stockBalance !== undefined ? parseInt(stockBalance) : undefined,
        stockValue: stockValue !== undefined ? parseFloat(stockValue) : undefined,
        sellerCode,
        image,
        flagActivate,
        adminNote
      }
    });

    return NextResponse.json(product);
  } catch (error) {
    console.error('Error updating product:', error);
    return NextResponse.json(
      { error: 'Failed to update product' },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const product = await prisma.product.findUnique({
      where: { id: parseInt(params.id) }
    });

    if (!product) {
      return NextResponse.json(
        { error: 'Product not found' },
        { status: 404 }
      );
    }

    await prisma.product.delete({
      where: { id: parseInt(params.id) }
    });

    return NextResponse.json({ message: 'Product deleted successfully' });
  } catch (error) {
    console.error('Error deleting product:', error);
    return NextResponse.json(
      { error: 'Failed to delete product' },
      { status: 500 }
    );
  }
}
