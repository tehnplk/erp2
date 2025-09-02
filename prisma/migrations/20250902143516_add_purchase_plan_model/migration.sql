-- CreateTable
CREATE TABLE "public"."PurchasePlan" (
    "id" SERIAL NOT NULL,
    "productCode" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "productName" TEXT NOT NULL,
    "productType" TEXT NOT NULL,
    "productSubtype" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "pricePerUnit" DECIMAL(65,30) NOT NULL,
    "budgetYear" INTEGER NOT NULL,
    "planId" INTEGER NOT NULL,
    "inPlan" TEXT NOT NULL,
    "carriedForwardQuantity" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "carriedForwardValue" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "requiredQuantityForYear" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "totalRequiredValue" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "additionalPurchaseQty" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "additionalPurchaseValue" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "purchasingDepartment" TEXT NOT NULL,

    CONSTRAINT "PurchasePlan_pkey" PRIMARY KEY ("id")
);
