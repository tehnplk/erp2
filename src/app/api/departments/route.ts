import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Ensure proper database connection
prisma.$connect();

// GET /api/departments - Get all departments
export async function GET() {
  try {
    console.log('Attempting to fetch departments...');
    const departments = await prisma.department.findMany({
      orderBy: {
        id: 'asc'
      }
    });
    
    console.log('Departments fetched successfully:', departments.length);
    return NextResponse.json(departments);
  } catch (error) {
    console.error('Error fetching departments:', error);
    console.error('Error details:', {
      message: error instanceof Error ? error.message : 'Unknown error',
      stack: error instanceof Error ? error.stack : undefined
    });
    return NextResponse.json(
      { error: 'Failed to fetch departments', details: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
}

// POST /api/departments - Create a new department
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { name } = body;

    if (!name) {
      return NextResponse.json(
        { error: 'Name is required' },
        { status: 400 }
      );
    }

    const department = await prisma.department.create({
      data: {
        name
      }
    });

    return NextResponse.json(department, { status: 201 });
  } catch (error) {
    console.error('Error creating department:', error);
    return NextResponse.json(
      { error: 'Failed to create department' },
      { status: 500 }
    );
  }
}
