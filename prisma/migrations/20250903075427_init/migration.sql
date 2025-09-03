-- CreateTable
CREATE TABLE "public"."User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Department" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Seller" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "prefix" TEXT,
    "name" TEXT NOT NULL,
    "business" TEXT,
    "address" TEXT,
    "phone" TEXT,
    "fax" TEXT,
    "mobile" TEXT,

    CONSTRAINT "Seller_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Product" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "subtype" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "costPrice" DECIMAL(10,2),
    "sellPrice" DECIMAL(10,2),
    "stockBalance" INTEGER,
    "stockValue" DECIMAL(10,2),
    "sellerCode" TEXT,
    "image" TEXT,
    "flagActivate" BOOLEAN NOT NULL DEFAULT true,
    "adminNote" TEXT,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Survey" (
    "id" SERIAL NOT NULL,
    "productCode" TEXT,
    "category" TEXT,
    "type" TEXT,
    "subtype" TEXT,
    "productName" TEXT,
    "requestedAmount" INTEGER,
    "unit" TEXT,
    "pricePerUnit" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "requestingDept" TEXT,
    "approvedQuota" INTEGER,

    CONSTRAINT "Survey_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Category" (
    "id" SERIAL NOT NULL,
    "category" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "subtype" TEXT,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PurchasePlan" (
    "id" SERIAL NOT NULL,
    "productCode" TEXT,
    "category" TEXT,
    "productName" TEXT,
    "productType" TEXT,
    "productSubtype" TEXT,
    "unit" TEXT,
    "pricePerUnit" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "budgetYear" INTEGER,
    "planId" INTEGER,
    "inPlan" TEXT,
    "carriedForwardQuantity" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "carriedForwardValue" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "requiredQuantityForYear" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "totalRequiredValue" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "additionalPurchaseQty" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "additionalPurchaseValue" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "purchasingDepartment" TEXT,

    CONSTRAINT "PurchasePlan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PurchaseApproval" (
    "id" SERIAL NOT NULL,
    "approvalId" TEXT,
    "department" TEXT,
    "recordNumber" TEXT,
    "requestDate" TEXT,
    "productName" TEXT,
    "productCode" TEXT,
    "category" TEXT,
    "productType" TEXT,
    "productSubtype" TEXT,
    "requestedQuantity" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "unit" TEXT,
    "pricePerUnit" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "totalValue" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "overPlanCase" TEXT,
    "requester" TEXT,
    "approver" TEXT,

    CONSTRAINT "PurchaseApproval_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Warehouse" (
    "id" SERIAL NOT NULL,
    "stockId" TEXT,
    "transactionType" TEXT,
    "transactionDate" TEXT,
    "category" TEXT,
    "productType" TEXT,
    "productSubtype" TEXT,
    "productCode" TEXT,
    "productName" TEXT,
    "productImage" TEXT,
    "unit" TEXT,
    "productLot" TEXT,
    "productPrice" DECIMAL(10,2) DEFAULT 0,
    "receivedFromCompany" TEXT,
    "receiptBillNumber" TEXT,
    "requestingDepartment" TEXT,
    "requisitionNumber" TEXT,
    "quotaAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "carriedForwardQty" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "carriedForwardValue" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "transactionPrice" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "transactionQuantity" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "transactionValue" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "remainingQuantity" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "remainingValue" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "inventoryStatus" TEXT,

    CONSTRAINT "Warehouse_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Seller_code_key" ON "public"."Seller"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Product_code_key" ON "public"."Product"("code");
