---
trigger: always_on
---

---
applyTo: "app/api/*"
---

## General Rules for Creating API.tsx
    - ทุก modules ของ API ต้องมี 1 ไฟล์ 1 folder
        - api/route.ts -> get,post
        - api/[id]/route.ts -> get by id,put,delete

## Example: app/main/api/forexModel/route.ts

```typescript
import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient() })

/**
 * GET /api/forexModel
 * ดึงข้อมูล ForexModel ทั้งหมด
 */
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const search = searchParams.get('search')

    const whereClause = search
      ? {
          OR: [
            { name: { contains: search } },
            { symbolName: { contains: search } },
          ],
        }
      : {}

    const forexModels = await prisma.forexModel.findMany({
      where: whereClause,
      orderBy: {
        createdAt: 'desc',
      },
    })

    return NextResponse.json({
      success: true,
      data: forexModels,
    })
  } catch (error) {
    console.error('Error fetching forex models:', error)
    return NextResponse.json(
      {
        success: false,
        error: 'Failed to fetch forex models',
      },
      { status: 500 }
    )
  }
}

/**
 * POST /api/forexModel
 * สร้าง ForexModel ใหม่
 */
export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    // Validate required fields
    if (!body.name || !body.symbolName) {
      return NextResponse.json(
        {
          success: false,
          error: 'Name and symbolName are required',
        },
        { status: 400 }
      )
    }

    const newForexModel = await prisma.forexModel.create({
      data: {
        name: body.name,
        symbolName: body.symbolName,
        ruleNote: body.ruleNote || null,
        note: body.note || null,
      },
    })

    return NextResponse.json(
      {
        success: true,
        data: newForexModel,
      },
      { status: 201 }
    )
  } catch (error) {
    console.error('Error creating forex model:', error)
    return NextResponse.json(
      {
        success: false,
        error: 'Failed to create forex model',
      },
      { status: 500 }
    )
  }
}
```

## Example: app/main/api/forexModel/[id]/route.ts

```typescript
import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '../../../../generated/client'
import { PrismaPg } from '@prisma/adapter-pg'
import { Pool } from 'pg'

const pool = new Pool({ connectionString: process.env.DATABASE_URL })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

/**
 * GET /api/forexModel/[id]
 * ดึงข้อมูล ForexModel ตาม ID
 */
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id)

    if (isNaN(id)) {
      return NextResponse.json(
        {
          success: false,
          error: 'Invalid ID format',
        },
        { status: 400 }
      )
    }

    const forexModel = await prisma.forexModel.findUnique({
      where: {
        id: id,
      },
    })

    if (!forexModel) {
      return NextResponse.json(
        {
          success: false,
          error: 'Forex model not found',
        },
        { status: 404 }
      )
    }

    return NextResponse.json({
      success: true,
      data: forexModel,
    })
  } catch (error) {
    console.error('Error fetching forex model:', error)
    return NextResponse.json(
      {
        success: false,
        error: 'Failed to fetch forex model',
      },
      { status: 500 }
    )
  }
}

/**
 * PUT /api/forexModel/[id]
 * อัปเดต ForexModel
 */
export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id)
    const body = await request.json()

    if (isNaN(id)) {
      return NextResponse.json(
        {
          success: false,
          error: 'Invalid ID format',
        },
        { status: 400 }
      )
    }

    // Check if forex model exists
    const existingModel = await prisma.forexModel.findUnique({
      where: { id },
    })

    if (!existingModel) {
      return NextResponse.json(
        {
          success: false,
          error: 'Forex model not found',
        },
        { status: 404 }
      )
    }

    const updatedForexModel = await prisma.forexModel.update({
      where: {
        id: id,
      },
      data: {
        name: body.name,
        symbolName: body.symbolName,
        ruleNote: body.ruleNote || null,
        note: body.note || null,
      },
    })

    return NextResponse.json({
      success: true,
      data: updatedForexModel,
    })
  } catch (error) {
    console.error('Error updating forex model:', error)
    return NextResponse.json(
      {
        success: false,
        error: 'Failed to update forex model',
      },
      { status: 500 }
    )
  }
}

/**
 * DELETE /api/forexModel/[id]
 * ลบ ForexModel
 */
export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id)

    if (isNaN(id)) {
      return NextResponse.json(
        {
          success: false,
          error: 'Invalid ID format',
        },
        { status: 400 }
      )
    }

    // Check if forex model exists
    const existingModel = await prisma.forexModel.findUnique({
      where: { id },
    })

    if (!existingModel) {
      return NextResponse.json(
        {
          success: false,
          error: 'Forex model not found',
        },
        { status: 404 }
      )
    }

    await prisma.forexModel.delete({
      where: {
        id: id,
      },
    })

    return NextResponse.json({
      success: true,
      message: 'Forex model deleted successfully',
    })
  } catch (error) {
    console.error('Error deleting forex model:', error)
    return NextResponse.json(
      {
        success: false,
        error: 'Failed to delete forex model',
      },
      { status: 500 }
    )
  }
}
```

## API Response Format (Standard)
```typescript
// Success Response
{
  success: true,
  data: <result>
}

// Error Response
{
  success: false,
  error: <error message>
}
```

## Key Points
1. **Always use PostgreSQL adapter** with PrismaClient
2. **Validate input** before database operations
3. **Check existence** before update/delete operations
4. **Use consistent error handling** with try-catch
5. **Return appropriate HTTP status codes**: 200 (OK), 201 (Created), 400 (Bad Request), 404 (Not Found), 500 (Server Error)
6. **Parse params.id to integer** for dynamic routes