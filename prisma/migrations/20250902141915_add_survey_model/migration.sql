-- CreateTable
CREATE TABLE "public"."Survey" (
    "id" SERIAL NOT NULL,
    "productId" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "subtype" TEXT NOT NULL,
    "productName" TEXT NOT NULL,
    "requestedAmount" INTEGER NOT NULL,
    "unit" TEXT NOT NULL,
    "pricePerUnit" DECIMAL(65,30),
    "requestingDept" TEXT NOT NULL,
    "approvedQuota" INTEGER NOT NULL,

    CONSTRAINT "Survey_pkey" PRIMARY KEY ("id")
);
