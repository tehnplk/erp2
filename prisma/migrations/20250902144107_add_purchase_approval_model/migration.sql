-- CreateTable
CREATE TABLE "public"."PurchaseApproval" (
    "id" SERIAL NOT NULL,
    "approvalId" TEXT NOT NULL,
    "department" TEXT NOT NULL,
    "recordNumber" TEXT NOT NULL,
    "requestDate" TEXT NOT NULL,
    "productName" TEXT NOT NULL,
    "productCode" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "productType" TEXT NOT NULL,
    "productSubtype" TEXT NOT NULL,
    "requestedQuantity" DECIMAL(65,30) NOT NULL,
    "unit" TEXT NOT NULL,
    "pricePerUnit" DECIMAL(65,30) NOT NULL,
    "totalValue" DECIMAL(65,30) NOT NULL,
    "overPlanCase" TEXT,
    "requester" TEXT,
    "approver" TEXT,

    CONSTRAINT "PurchaseApproval_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseApproval_approvalId_key" ON "public"."PurchaseApproval"("approvalId");
