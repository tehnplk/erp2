import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { createDepartmentSchema } from '@/lib/validation/schemas';

// GET /api/departments - Get all departments
export async function GET() {
  try {
    const departments = await prisma.department.findMany({
      orderBy: {
        id: 'asc'
      }
    });
    
    return apiSuccess(departments);
  } catch (error) {
    console.error('Error fetching departments:', error);
    return apiError('Failed to fetch departments');
  }
}

// POST /api/departments - Create a new department
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createDepartmentSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const department = await prisma.department.create({
      data: validation.data as any
    });

    return apiSuccess(department, 'Department created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating department:', error);
    return apiError('Failed to create department');
  }
}
