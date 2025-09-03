/*
  Warnings:

  - You are about to alter the column `costPrice` on the `Product` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `sellPrice` on the `Product` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `stockValue` on the `Product` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `requestedQuantity` on the `PurchaseApproval` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `pricePerUnit` on the `PurchaseApproval` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `totalValue` on the `PurchaseApproval` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `pricePerUnit` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `carriedForwardQuantity` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `carriedForwardValue` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `requiredQuantityForYear` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `totalRequiredValue` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `additionalPurchaseQty` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `additionalPurchaseValue` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to drop the column `productId` on the `Survey` table. All the data in the column will be lost.
  - You are about to alter the column `pricePerUnit` on the `Survey` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `productPrice` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `quotaAmount` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `carriedForwardQty` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `carriedForwardValue` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `transactionPrice` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `transactionQuantity` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `transactionValue` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `remainingQuantity` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - You are about to alter the column `remainingValue` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,2)`.
  - Added the required column `productCode` to the `Survey` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "public"."Product" ALTER COLUMN "costPrice" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "sellPrice" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "stockValue" SET DATA TYPE DECIMAL(10,2);

-- AlterTable
ALTER TABLE "public"."PurchaseApproval" ALTER COLUMN "requestedQuantity" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "pricePerUnit" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "totalValue" SET DATA TYPE DECIMAL(10,2);

-- AlterTable
ALTER TABLE "public"."PurchasePlan" ALTER COLUMN "pricePerUnit" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "carriedForwardQuantity" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "carriedForwardValue" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "requiredQuantityForYear" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "totalRequiredValue" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "additionalPurchaseQty" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "additionalPurchaseValue" SET DATA TYPE DECIMAL(10,2);

-- AlterTable
ALTER TABLE "public"."Survey" DROP COLUMN "productId",
ADD COLUMN     "productCode" TEXT NOT NULL,
ALTER COLUMN "pricePerUnit" SET DATA TYPE DECIMAL(10,2);

-- AlterTable
ALTER TABLE "public"."Warehouse" ALTER COLUMN "productPrice" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "quotaAmount" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "carriedForwardQty" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "carriedForwardValue" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "transactionPrice" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "transactionQuantity" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "transactionValue" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "remainingQuantity" SET DATA TYPE DECIMAL(10,2),
ALTER COLUMN "remainingValue" SET DATA TYPE DECIMAL(10,2);
