import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const orderBy = searchParams.get('orderBy');
    
    // Get filter parameters
    const name = searchParams.get('name');
    const category = searchParams.get('category');
    const type = searchParams.get('type');
    const subtype = searchParams.get('subtype');
    
    // Build where clause
    const where: any = {};
    
    if (name) {
      where.name = {
        contains: name,
        mode: 'insensitive'
      };
    }
    
    if (category) {
      where.category = category;
    }
    
    if (type) {
      where.type = type;
    }
    
    if (subtype) {
      where.subtype = subtype;
    }
    
    const products = await prisma.product.findMany({
      where,
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
