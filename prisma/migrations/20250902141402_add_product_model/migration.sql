-- CreateTable
CREATE TABLE "public"."Product" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "subtype" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "costPrice" DECIMAL(65,30),
    "sellPrice" DECIMAL(65,30),
    "stockBalance" INTEGER,
    "stockValue" DECIMAL(65,30),
    "sellerCode" TEXT,
    "image" TEXT,
    "flagActivate" BOOLEAN NOT NULL DEFAULT true,
    "adminNote" TEXT,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Product_code_key" ON "public"."Product"("code");
