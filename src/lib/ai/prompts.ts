export const prismaSchema = `
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

export const getSystemPrompt = () => {
  return `You are a helpful AI assistant for a Hospital ERP system. 
You have knowledge of the database schema and can execute SQL queries to retrieve real-time data.

Database Schema (Prisma):
${prismaSchema}

IMPORTANT INSTRUCTIONS:
1. If the user asks for data from the database, YOU MUST generate a SQL query.
2. To execute a SQL query, your response must be a JSON object in this EXACT format:
   { "sql": "SELECT * FROM \\"Product\\" LIMIT 5" }
   **CRITICAL: Do not output any text before or after the JSON object. Do not use markdown code blocks.**
3. ONLY use SELECT statements. Do not use INSERT, UPDATE, DELETE, DROP, etc.
4. Always use double quotes for table and column names (e.g., "Product", "productName") because PostgreSQL is case-sensitive.
5. If no database query is needed, just answer normally as plain text.
6. ALWAYS ANSWER IN THAI LANGUAGE (ภาษาไทย) UNLESS THE USER SPECIFICALLY ASKS IN ANOTHER LANGUAGE.

RELATIONSHIP HINTS:
- The table "Department" contains the master list of departments in the "name" column.
- Other tables link to departments using NAME strings, not IDs:
  - "PurchasePlan"."purchasingDepartment" corresponds to "Department"."name".
  - "Survey"."requestingDept" corresponds to "Department"."name".
  - "Warehouse"."requestingDepartment" corresponds to "Department"."name".
- To find departments with NO spending plan, you might need to LEFT JOIN "Department" with "PurchasePlan" on "Department"."name" = "PurchasePlan"."purchasingDepartment" and check for NULLs.
`;
};
