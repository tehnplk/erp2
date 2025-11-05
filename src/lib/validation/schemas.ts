import { z } from 'zod';

// Common validation patterns
const positiveNumber = z.string().transform((val: string) => parseFloat(val)).pipe(z.number().min(0));
const positiveInteger = z.string().transform((val: string) => parseInt(val)).pipe(z.number().int().min(0));
const nonEmptyString = z.string().min(1, 'This field is required');

// Product schemas
export const createProductSchema = z.object({
  code: nonEmptyString,
  category: nonEmptyString,
  name: nonEmptyString,
  type: z.string().optional(),
  subtype: z.string().optional(),
  unit: z.string().optional(),
  costPrice: positiveNumber.optional(),
  sellPrice: positiveNumber.optional(),
  stockBalance: positiveInteger.optional(),
  stockValue: positiveNumber.optional(),
  sellerCode: z.string().optional(),
  image: z.string().optional(),
  adminNote: z.string().optional()
});

export const updateProductSchema = createProductSchema.partial();

export const productQuerySchema = z.object({
  name: z.string().optional(),
  category: z.string().optional(),
  type: z.string().optional(),
  subtype: z.string().optional(),
  orderBy: z.enum(['id', 'code', 'name', 'category', 'type', 'subtype', 'costPrice', 'sellPrice']).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional()
});

// Seller schemas
export const createSellerSchema = z.object({
  code: nonEmptyString,
  prefix: z.string().optional(),
  name: nonEmptyString,
  business: z.string().optional(),
  address: z.string().optional(),
  phone: z.string().optional(),
  fax: z.string().optional(),
  mobile: z.string().optional()
});

export const updateSellerSchema = createSellerSchema.partial();

// Department schemas
export const createDepartmentSchema = z.object({
  name: nonEmptyString
});

export const updateDepartmentSchema = createDepartmentSchema.partial();

// Category schemas
export const createCategorySchema = z.object({
  category: nonEmptyString,
  type: nonEmptyString,
  subtype: nonEmptyString
});

export const updateCategorySchema = createCategorySchema.partial();

// Warehouse schemas
export const createWarehouseSchema = z.object({
  stockId: z.string().nullable().optional(),
  transactionType: z.string().nullable().optional(),
  transactionDate: z.string().nullable().optional(),
  category: z.string().nullable().optional(),
  productType: z.string().nullable().optional(),
  productSubtype: z.string().nullable().optional(),
  productCode: z.string().nullable().optional(),
  productName: z.string().nullable().optional(),
  productImage: z.string().nullable().optional(),
  unit: z.string().nullable().optional(),
  productLot: z.string().nullable().optional(),
  productPrice: z.string().transform((val: string) => val === null || val === undefined || val === '' ? 0 : parseFloat(val)).pipe(z.number()).optional(),
  receivedFromCompany: z.string().nullable().optional(),
  receiptBillNumber: z.string().nullable().optional(),
  requestingDepartment: z.string().nullable().optional(),
  requisitionNumber: z.string().nullable().optional(),
  quotaAmount: z.string().transform((val: string) => val === null || val === undefined || val === '' ? null : parseInt(val)).pipe(z.number().nullable()).optional(),
  carriedForwardQty: z.string().transform((val: string) => val === null || val === undefined || val === '' ? null : parseInt(val)).pipe(z.number().nullable()).optional(),
  carriedForwardValue: z.string().transform((val: string) => val === null || val === undefined || val === '' ? 0 : parseFloat(val)).pipe(z.number()).optional(),
  transactionPrice: z.string().transform((val: string) => val === null || val === undefined || val === '' ? 0 : parseFloat(val)).pipe(z.number()).optional(),
  transactionQuantity: z.string().transform((val: string) => val === null || val === undefined || val === '' ? null : parseInt(val)).pipe(z.number().nullable()).optional(),
  transactionValue: z.string().transform((val: string) => val === null || val === undefined || val === '' ? 0 : parseFloat(val)).pipe(z.number()).optional(),
  remainingQuantity: z.string().transform((val: string) => val === null || val === undefined || val === '' ? null : parseInt(val)).pipe(z.number().nullable()).optional(),
  remainingValue: z.string().transform((val: string) => val === null || val === undefined || val === '' ? 0 : parseFloat(val)).pipe(z.number()).optional(),
  inventoryStatus: z.string().nullable().optional()
});

export const warehouseQuerySchema = z.object({
  productName: z.string().optional(),
  category: z.string().optional(),
  productType: z.string().optional(),
  productSubtype: z.string().optional(),
  requestingDepartment: z.string().optional(),
  orderBy: z.enum([
    'id', 'transactionDate', 'productCode', 'productName', 
    'transactionQuantity', 'remainingQuantity', 'category', 
    'productType', 'productSubtype', 'requestingDepartment'
  ]).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional()
});

// Purchase Plan schemas
export const createPurchasePlanSchema = z.object({
  productCode: z.string().optional(),
  category: z.string().optional(),
  productName: z.string().optional(),
  productType: z.string().optional(),
  productSubtype: z.string().optional(),
  unit: z.string().optional(),
  pricePerUnit: positiveNumber.optional(),
  budgetYear: z.string().optional(),
  planId: positiveInteger.optional(),
  inPlan: z.string().optional(),
  carriedForwardQuantity: positiveInteger.optional(),
  carriedForwardValue: positiveNumber.optional(),
  requiredQuantityForYear: positiveInteger.optional(),
  totalRequiredValue: positiveNumber.optional(),
  additionalPurchaseQty: positiveInteger.optional(),
  additionalPurchaseValue: positiveNumber.optional(),
  purchasingDepartment: z.string().optional()
});

export const purchasePlanQuerySchema = z.object({
  productName: z.string().optional(),
  category: z.string().optional(),
  productType: z.string().optional(),
  productSubtype: z.string().optional(),
  purchasingDepartment: z.string().optional(),
  budgetYear: z.string().optional(),
  orderBy: z.enum([
    'id', 'productCode', 'productName', 'category', 
    'productType', 'productSubtype', 'budgetYear', 
    'purchasingDepartment'
  ]).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional()
});

// Purchase Approval schemas
export const createPurchaseApprovalSchema = z.object({
  approvalId: z.string().optional(),
  department: z.string().optional(),
  recordNumber: z.string().optional(),
  requestDate: z.string().optional(),
  productName: z.string().optional(),
  productCode: z.string().optional(),
  category: z.string().optional(),
  productType: z.string().optional(),
  productSubtype: z.string().optional(),
  requestedQuantity: positiveInteger.optional(),
  unit: z.string().optional(),
  pricePerUnit: positiveNumber.optional(),
  totalValue: positiveNumber.optional(),
  overPlanCase: z.string().optional(),
  requester: z.string().optional(),
  approver: z.string().optional()
});

export const purchaseApprovalQuerySchema = z.object({
  productName: z.string().optional(),
  category: z.string().optional(),
  productType: z.string().optional(),
  productSubtype: z.string().optional(),
  department: z.string().optional(),
  orderBy: z.enum([
    'id', 'department', 'recordNumber', 'requestDate', 
    'productName', 'productCode', 'category', 'productType', 
    'productSubtype', 'requester', 'approver'
  ]).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional()
});

// ID parameter validation
export const idParamSchema = z.object({
  id: z.string().transform((val: string) => parseInt(val)).pipe(z.number().int().positive('Invalid ID format'))
});
