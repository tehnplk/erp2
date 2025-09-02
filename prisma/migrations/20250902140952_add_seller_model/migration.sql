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

-- CreateIndex
CREATE UNIQUE INDEX "Seller_code_key" ON "public"."Seller"("code");
