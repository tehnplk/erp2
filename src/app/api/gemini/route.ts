import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

// Define types for Google GenAI API
interface GeminiPart {
    text: string;
}

interface GeminiContent {
    role: 'user' | 'model';
    parts: GeminiPart[];
}

interface Message {
    role: 'user' | 'assistant' | 'system';
    content: string;
}

export async function POST(request: Request) {
    try {
        const { message, messages } = await request.json();

        if (!message) {
            return NextResponse.json(
                { error: 'Message is required' },
                { status: 400 }
            );
        }

        // --- Configuration ---
        const apiKey = process.env.GOOGLE_API_KEY;
        // Models: 'gemini-2.0-flash-lite-preview-02-05', 'gemini-1.5-flash', 'gemini-1.5-pro'
        const modelName = 'gemini-2.0-flash-lite-preview-02-05'; 
        const api = `https://generativelanguage.googleapis.com/v1beta/models/${modelName}:generateContent?key=${apiKey}`;

        if (!apiKey) {
            return NextResponse.json(
                { message: 'Server Error: GOOGLE_API_KEY is missing.' },
                { status: 500 }
            );
        }

        // Convert OpenAI-style messages to Gemini-style contents
        // Note: Gemini REST API uses 'user' and 'model' roles. 'system' instructions are handled differently in v1beta via systemInstruction, 
        // but for simple chat, we can prepend or use the `systemInstruction` field if supported, 
        // or just treat it as initial context.
        // For simplicity and compatibility with this endpoint structure, we'll map:
        // user -> user
        // assistant -> model
        
        const contents: GeminiContent[] = [];
        const prismaSchema = `
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  password  String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Department {
  id   Int    @id @default(autoincrement())
  name String
}

model Seller {
  id          Int     @id @default(autoincrement())
  code        String  @unique
  prefix      String?
  name        String
  business    String?
  address     String?
  phone       String?
  fax         String?
  mobile      String?
}

model Product {
  id            Int      @id @default(autoincrement())
  code          String   @unique
  category      String
  name          String
  type          String
  subtype       String
  unit          String
  costPrice     Decimal? @db.Decimal(10, 2)
  sellPrice     Decimal? @db.Decimal(10, 2)
  stockBalance  Int?
  stockValue    Decimal? @db.Decimal(10, 2)
  sellerCode    String?
  image         String?
  flagActivate  Boolean  @default(true)
  adminNote     String?
}

model Survey {
  id              Int      @id @default(autoincrement())
  productCode       String?
  category        String?
  type            String?
  subtype         String?
  productName     String?
  requestedAmount Int?
  unit            String?
  pricePerUnit    Decimal @default(0) @db.Decimal(10, 2)
  requestingDept  String?
  approvedQuota   Int?
}

model Category {
  id       Int    @id @default(autoincrement())
  category String
  type     String
  subtype  String?
}

model PurchasePlan {
  id                      Int      @id @default(autoincrement())
  productCode             String?
  category                String?
  productName             String?
  productType             String?
  productSubtype          String?
  unit                    String?
  pricePerUnit            Decimal @default(0) @db.Decimal(10, 2)
  budgetYear              String?
  planId                  Int?
  inPlan                  String?
  carriedForwardQuantity  Int?
  carriedForwardValue     Decimal  @default(0) @db.Decimal(10, 2)
  requiredQuantityForYear Int?
  totalRequiredValue      Decimal  @default(0) @db.Decimal(10, 2)
  additionalPurchaseQty   Int?
  additionalPurchaseValue Decimal  @default(0) @db.Decimal(10, 2)
  purchasingDepartment    String?
}

model PurchaseApproval {
  id                Int      @id @default(autoincrement())
  approvalId        String?
  department        String?
  recordNumber      String?
  requestDate       String?
  productName       String?
  productCode       String?
  category          String?
  productType       String?
  productSubtype    String?
  requestedQuantity Int?
  unit              String?
  pricePerUnit      Decimal @default(0) @db.Decimal(10, 2)
  totalValue        Decimal @default(0) @db.Decimal(10, 2)
  overPlanCase      String?
  requester         String?
  approver          String?
}

model Warehouse {
  id                    Int      @id @default(autoincrement())
  stockId               String?
  transactionType       String?
  transactionDate       String?
  category              String?
  productType           String?
  productSubtype        String?
  productCode           String?
  productName           String?
  productImage          String?
  unit                  String?
  productLot            String?
  productPrice          Decimal? @default(0) @db.Decimal(10, 2)
  receivedFromCompany   String?
  receiptBillNumber     String?
  requestingDepartment  String?
  requisitionNumber     String?
  quotaAmount           Int?
  carriedForwardQty     Int?
  carriedForwardValue   Decimal  @default(0) @db.Decimal(10, 2)
  transactionPrice      Decimal  @default(0) @db.Decimal(10, 2)
  transactionQuantity   Int?
  transactionValue      Decimal  @default(0) @db.Decimal(10, 2)
  remainingQuantity     Int?
  remainingValue        Decimal  @default(0) @db.Decimal(10, 2)
  inventoryStatus       String?
}
`;

        let systemInstruction = `You are a helpful AI assistant for a Hospital ERP system. 
You have knowledge of the database schema and can execute SQL queries to retrieve real-time data.

Database Schema (Prisma):
${prismaSchema}

IMPORTANT INSTRUCTIONS:
1. If the user asks for data from the database, YOU MUST generate a SQL query.
2. To execute a SQL query, your response must be a JSON object in this EXACT format:
   { "sql": "SELECT * FROM \\"Product\\" LIMIT 5" }
3. ONLY use SELECT statements. Do not use INSERT, UPDATE, DELETE, DROP, etc.
4. Always use double quotes for table and column names (e.g., "Product", "productName") because PostgreSQL is case-sensitive.
5. If no database query is needed, just answer normally as plain text.
`;

        // Helper function to call Gemini API
        const callGemini = async (payload: any) => {
            const response = await fetch(api, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload),
            });
            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.error?.message || 'Failed to get response from Google Gemini');
            }
            return data.candidates?.[0]?.content?.parts?.[0]?.text || '';
        };

        // Process history messages
        if (messages && Array.isArray(messages)) {
            messages.forEach((msg: Message) => {
                if (msg.role === 'system') {
                    systemInstruction = msg.content;
                } else if (msg.role === 'user' || msg.role === 'assistant') {
                    contents.push({
                        role: msg.role === 'assistant' ? 'model' : 'user',
                        parts: [{ text: msg.content }]
                    });
                }
            });
        }

        // Add current user message
        contents.push({
            role: 'user',
            parts: [{ text: message }]
        });

        // Step 1: Initial call to Gemini
        let payload = {
            contents: contents,
            systemInstruction: { parts: [{ text: systemInstruction }] },
            generationConfig: { temperature: 0.2, maxOutputTokens: 1000 } // Low temp for SQL generation
        };

        let aiMessage = await callGemini(payload);
        let cleanMessage = aiMessage.trim();
        
        // Remove markdown code blocks if present (e.g., ```json ... ```)
        if (cleanMessage.startsWith('```')) {
            cleanMessage = cleanMessage.replace(/^```(json)?\n/, '').replace(/\n```$/, '');
        }

        // Check if response is a SQL query request
        try {
            const parsed = JSON.parse(cleanMessage);
            
            if (parsed.sql) {
                console.log('Executing SQL:', parsed.sql);
                
                // Security check: Only allow SELECT
                if (!parsed.sql.trim().toUpperCase().startsWith('SELECT')) {
                     throw new Error('Only SELECT queries are allowed for security reasons.');
                }

                // Step 2: Execute SQL
                try {
                    const results = await prisma.$queryRawUnsafe(parsed.sql);
                    
                    // Step 3: Send results back to Gemini
                    const resultStr = JSON.stringify(results, (_, v) => typeof v === 'bigint' ? v.toString() : v); // Handle BigInt
                    
                    contents.push({ role: 'model', parts: [{ text: aiMessage }] }); // AI's SQL request
                    contents.push({ 
                        role: 'user', 
                        parts: [{ text: `Here is the data from the database: ${resultStr}\nPlease analyze this data and answer my original question.` }] 
                    });

                    payload = {
                        contents: contents,
                        systemInstruction: { parts: [{ text: systemInstruction }] },
                        generationConfig: { temperature: 0.7, maxOutputTokens: 1000 }
                    };

                    aiMessage = await callGemini(payload);

                } catch (dbError: any) {
                    console.error('Database execution error:', dbError);
                    // Inform Gemini about the error so it can apologize/retry
                    contents.push({ role: 'model', parts: [{ text: aiMessage }] });
                    contents.push({ 
                        role: 'user', 
                        parts: [{ text: `Error executing SQL: ${dbError.message}. Please try again with a corrected query or explain the issue.` }] 
                    });
                    
                    payload = {
                        contents: contents,
                        systemInstruction: { parts: [{ text: systemInstruction }] },
                        generationConfig: { temperature: 0.7, maxOutputTokens: 1000 }
                    };
                    aiMessage = await callGemini(payload);
                }
            }
        } catch (e) {
            // Not JSON or SQL, assume normal text response
            // Do nothing, just return aiMessage as is
        }

        return NextResponse.json({ message: aiMessage });

    } catch (error: any) {
        console.error('Error calling LLM:', error);
        return NextResponse.json(
            { message: `Error: ${error.message || 'Unknown error'}` },
            { status: 500 }
        );
    }
}
