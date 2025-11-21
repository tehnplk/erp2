/*
  Warnings:

  - You are about to alter the column `requestedQuantity` on the `PurchaseApproval` table. The data in that column could be lost. The data in that column will be cast from `Decimal(10,2)` to `Integer`.
  - You are about to alter the column `carriedForwardQuantity` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(10,2)` to `Integer`.
  - You are about to alter the column `requiredQuantityForYear` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(10,2)` to `Integer`.
  - You are about to alter the column `additionalPurchaseQty` on the `PurchasePlan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(10,2)` to `Integer`.
  - You are about to alter the column `quotaAmount` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(10,2)` to `Integer`.
  - You are about to alter the column `carriedForwardQty` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(10,2)` to `Integer`.
  - You are about to alter the column `transactionQuantity` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(10,2)` to `Integer`.
  - You are about to alter the column `remainingQuantity` on the `Warehouse` table. The data in that column could be lost. The data in that column will be cast from `Decimal(10,2)` to `Integer`.

*/
-- AlterTable
ALTER TABLE "PurchaseApproval" ALTER COLUMN "requestedQuantity" DROP NOT NULL,
ALTER COLUMN "requestedQuantity" DROP DEFAULT,
ALTER COLUMN "requestedQuantity" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "PurchasePlan" ALTER COLUMN "budgetYear" SET DATA TYPE TEXT,
ALTER COLUMN "carriedForwardQuantity" DROP NOT NULL,
ALTER COLUMN "carriedForwardQuantity" DROP DEFAULT,
ALTER COLUMN "carriedForwardQuantity" SET DATA TYPE INTEGER,
ALTER COLUMN "requiredQuantityForYear" DROP NOT NULL,
ALTER COLUMN "requiredQuantityForYear" DROP DEFAULT,
ALTER COLUMN "requiredQuantityForYear" SET DATA TYPE INTEGER,
ALTER COLUMN "additionalPurchaseQty" DROP NOT NULL,
ALTER COLUMN "additionalPurchaseQty" DROP DEFAULT,
ALTER COLUMN "additionalPurchaseQty" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "Warehouse" ALTER COLUMN "quotaAmount" DROP NOT NULL,
ALTER COLUMN "quotaAmount" DROP DEFAULT,
ALTER COLUMN "quotaAmount" SET DATA TYPE INTEGER,
ALTER COLUMN "carriedForwardQty" DROP NOT NULL,
ALTER COLUMN "carriedForwardQty" DROP DEFAULT,
ALTER COLUMN "carriedForwardQty" SET DATA TYPE INTEGER,
ALTER COLUMN "transactionQuantity" DROP NOT NULL,
ALTER COLUMN "transactionQuantity" DROP DEFAULT,
ALTER COLUMN "transactionQuantity" SET DATA TYPE INTEGER,
ALTER COLUMN "remainingQuantity" DROP NOT NULL,
ALTER COLUMN "remainingQuantity" DROP DEFAULT,
ALTER COLUMN "remainingQuantity" SET DATA TYPE INTEGER;
