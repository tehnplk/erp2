import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const orderBy = searchParams.get('orderBy');
    
    const products = await prisma.product.findMany({
      orderBy: orderBy === 'code' ? 
        { code: 'asc' } : 
        { id: 'desc' }
    });
    
    return NextResponse.json(products);
  } catch (error) {
    console.error('Error fetching products:', error);
    return NextResponse.json({ error: 'Failed to fetch products' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
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
      adminNote
    } = body;

    if (!code || !name || !category) {
      return NextResponse.json(
        { error: 'Code, name, and category are required' },
        { status: 400 }
      );
    }

    const existingProduct = await prisma.product.findUnique({
      where: { code }
    });

    if (existingProduct) {
      return NextResponse.json(
        { error: 'Product with this code already exists' },
        { status: 409 }
      );
    }

    const product = await prisma.product.create({
      data: {
        code,
        category,
        name,
        type,
        subtype,
        unit,
        costPrice: costPrice ? parseFloat(costPrice) : null,
        sellPrice: sellPrice ? parseFloat(sellPrice) : null,
        stockBalance: stockBalance ? parseInt(stockBalance) : null,
        stockValue: stockValue ? parseFloat(stockValue) : null,
        sellerCode,
        image,
        adminNote
      }
    });

    return NextResponse.json(product, { status: 201 });
  } catch (error) {
    console.error('Error creating product:', error);
    return NextResponse.json(
      { error: 'Failed to create product' },
      { status: 500 }
    );
  }
}
