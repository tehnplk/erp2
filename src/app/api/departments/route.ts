import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError } from '@/lib/api-response';
import { validateRequest, validateQuery } from '@/lib/validation/validate';
import { createDepartmentSchema, departmentQuerySchema } from '@/lib/validation/schemas';

// GET /api/departments - Get departments with optional filters and pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(departmentQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { name, page, pageSize } = queryValidation.data as any;

    const where: any = {};
    if (name) {
      where.name = {
        contains: name,
        mode: 'insensitive'
      };
    }

    // If no pagination params, return all departments (backwards compatible)
    if (!page || !pageSize) {
      const departments = await prisma.department.findMany({
        where,
        orderBy: { id: 'asc' }
      });
      return apiSuccess(departments, undefined, departments.length);
    }

    const skip = (page - 1) * pageSize;

    const [totalCount, departments] = await Promise.all([
      prisma.department.count({ where }),
      prisma.department.findMany({
        where,
        orderBy: { id: 'asc' },
        skip,
        take: pageSize
      })
    ]);
    
    return apiSuccess(departments, undefined, totalCount, 200, { page, pageSize });
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
