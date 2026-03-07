import { z } from 'zod';

// Common validation patterns
const positiveNumber = z.string().transform((val: string) => parseFloat(val)).pipe(z.number().min(0));
const positiveInteger = z.string().transform((val: string) => parseInt(val)).pipe(z.number().int().min(0));
const numberInput = z.union([z.string(), z.number()]).transform((val) => val === '' ? 0 : Number(val)).pipe(z.number().min(0));
const nullableIntInput = z.union([z.string(), z.number(), z.null(), z.undefined()]).transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10)).pipe(z.number().int().min(0).nullable());
const nonEmptyString = z.string().min(1, 'This field is required');
const paginationFields = {
  page: z.coerce.number().int().min(1).optional(),
  pageSize: z.coerce.number().int().min(1).max(200).optional()
};

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
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Inventory schemas
export const inventoryPendingPurchaseApprovalQuerySchema = z.object({
  productName: z.string().optional(),
  department: z.string().optional(),
  budgetYear: z.string().optional(),
  status: z.enum(['PENDING', 'PARTIAL', 'RECEIVED', 'CANCELLED']).optional(),
  orderBy: z.enum(['id', 'productCode', 'productName', 'department', 'budgetYear', 'requestedQuantity', 'receivedQty']).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

export const createInventoryReceiptFromPurchaseApprovalSchema = z.object({
  purchaseApprovalId: z.coerce.number().int().positive(),
  warehouseId: z.coerce.number().int().positive(),
  locationId: z.coerce.number().int().positive().nullable().optional(),
  qty: z.coerce.number().int().positive(),
  unitCost: z.union([z.string(), z.number(), z.null(), z.undefined()]).transform((val) => val === null || val === undefined || val === '' ? null : Number(val)).pipe(z.number().min(0).nullable()).optional(),
  vendorName: z.string().optional(),
  receiptDate: z.string().optional(),
  receiptNo: z.string().optional(),
  lotNo: z.string().optional(),
  expiryDate: z.string().optional(),
  note: z.string().optional(),
  createdBy: z.string().optional()
});

export const inventoryBalanceQuerySchema = z.object({
  productName: z.string().optional(),
  productCode: z.string().optional(),
  category: z.string().optional(),
  productType: z.string().optional(),
  warehouseId: z.coerce.number().int().positive().optional(),
  lowStockOnly: z.enum(['true', 'false']).optional(),
  orderBy: z.enum(['id', 'productCode', 'productName', 'category', 'productType', 'onHandQty', 'availableQty', 'avgCost']).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

export const inventoryMovementQuerySchema = z.object({
  inventoryItemId: z.coerce.number().int().positive().optional(),
  productCode: z.string().optional(),
  movementType: z.string().optional(),
  referenceType: z.string().optional(),
  dateFrom: z.string().optional(),
  dateTo: z.string().optional(),
  orderBy: z.enum(['id', 'movementDate', 'movementType', 'productCode', 'productName', 'qtyIn', 'qtyOut']).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

export const createInventoryRequisitionSchema = z.object({
  requisitionNo: z.string().optional(),
  requestDate: z.string().optional(),
  requestingDepartment: nonEmptyString,
  requestedBy: z.string().optional(),
  note: z.string().optional(),
  items: z.array(z.object({
    inventoryItemId: z.coerce.number().int().positive(),
    requestedQty: z.coerce.number().int().positive(),
    note: z.string().optional()
  })).min(1)
});

export const inventoryRequisitionQuerySchema = z.object({
  requisitionNo: z.string().optional(),
  requestingDepartment: z.string().optional(),
  status: z.enum(['DRAFT', 'SUBMITTED', 'PARTIALLY_APPROVED', 'APPROVED', 'REJECTED', 'PARTIALLY_ISSUED', 'ISSUED', 'CANCELLED']).optional(),
  orderBy: z.enum(['id', 'requisitionNo', 'requestDate', 'requestingDepartment', 'status']).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

export const approveInventoryRequisitionSchema = z.object({
  approvedBy: z.string().optional(),
  note: z.string().optional(),
  items: z.array(z.object({
    requisitionItemId: z.coerce.number().int().positive(),
    approvedQty: z.coerce.number().int().min(0)
  })).min(1)
});

export const createInventoryIssueSchema = z.object({
  requisitionId: z.coerce.number().int().positive(),
  issueNo: z.string().optional(),
  issueDate: z.string().optional(),
  requestingDepartment: nonEmptyString,
  issuedBy: z.string().optional(),
  approvedBy: z.string().optional(),
  note: z.string().optional(),
  items: z.array(z.object({
    requisitionItemId: z.coerce.number().int().positive(),
    inventoryItemId: z.coerce.number().int().positive(),
    issuedQty: z.coerce.number().int().positive()
  })).min(1)
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

export const sellerQuerySchema = z.object({
  name: z.string().optional(),
  ...paginationFields
});

// Department schemas
export const createDepartmentSchema = z.object({
  name: nonEmptyString
});

export const updateDepartmentSchema = createDepartmentSchema.partial();

export const departmentQuerySchema = z.object({
  name: z.string().optional(),
  ...paginationFields
});

// Category schemas
export const createCategorySchema = z.object({
  category: nonEmptyString,
  type: nonEmptyString,
  subtype: nonEmptyString
});

export const updateCategorySchema = createCategorySchema.partial();

export const categoryQuerySchema = z.object({
  category: z.string().optional(),
  type: z.string().optional(),
  subtype: z.string().optional(),
  ...paginationFields
});

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
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Purchase Plan schemas
export const createPurchasePlanSchema = z.object({
  productCode: z.string().optional(),
  category: z.string().optional(),
  productName: z.string().optional(),
  productType: z.string().optional(),
  productSubtype: z.string().optional(),
  unit: z.string().optional(),
  pricePerUnit: numberInput.optional(),
  budgetYear: z.string().optional(),
  planId: nullableIntInput.optional(),
  inPlan: z.string().optional(),
  carriedForwardQuantity: nullableIntInput.optional(),
  carriedForwardValue: numberInput.optional(),
  requiredQuantityForYear: nullableIntInput.optional(),
  totalRequiredValue: numberInput.optional(),
  additionalPurchaseQty: nullableIntInput.optional(),
  additionalPurchaseValue: numberInput.optional(),
  purchasingDepartment: z.string().optional()
});

 export const updatePurchasePlanSchema = createPurchasePlanSchema.partial();

export const purchasePlanQuerySchema = z.object({
  productName: z.string().optional(),
  category: z.string().optional(),
  productType: z.string().optional(),
  productSubtype: z.string().optional(),
  purchasingDepartment: z.string().optional(),
  budgetYear: z.string().optional(),
  orderBy: z.enum([
    'id',
    'productCode',
    'productName',
    'category',
    'productType',
    'productSubtype',
    'unit',
    'pricePerUnit',
    'requiredQuantityForYear',
    'totalRequiredValue',
    'budgetYear',
    'purchasingDepartment'
  ]).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Purchase Approval schemas
export const createPurchaseApprovalSchema = z.object({
  approvalId: z.string().optional(),
  department: z.string().optional(),
  budgetYear: z.union([z.string(), z.number(), z.null(), z.undefined()])
    .transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10))
    .pipe(z.number().int().nullable())
    .optional(),
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
  budgetYear: z.string().optional(),
  orderBy: z.enum([
    'id', 'department', 'budgetYear', 'recordNumber', 'requestDate', 
    'productName', 'productCode', 'category', 'productType', 
    'productSubtype', 'requester', 'approver'
  ]).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Survey schemas
export const createSurveySchema = z.object({
  productCode: z.string().nullable().optional(),
  category: z.string().nullable().optional(),
  type: z.string().nullable().optional(),
  subtype: z.string().nullable().optional(),
  productName: z.string().nullable().optional(),
  requestedAmount: nullableIntInput.optional(),
  unit: z.string().nullable().optional(),
  pricePerUnit: numberInput.optional(),
  requestingDept: z.string().nullable().optional(),
  approvedQuota: nullableIntInput.optional(),
  budgetYear: z.union([z.string(), z.number(), z.null(), z.undefined()])
    .transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10))
    .pipe(z.number().int().nullable())
    .optional(),
  sequenceNo: z.union([z.string(), z.number(), z.null(), z.undefined()])
    .transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10))
    .pipe(z.number().int().min(1).max(2).nullable())
    .optional()
});

export const updateSurveySchema = createSurveySchema.partial();

export const surveyQuerySchema = z.object({
  productName: z.string().optional(),
  category: z.string().optional(),
  type: z.string().optional(),
  requestingDept: z.string().optional(),
  budgetYear: z.string().optional(),
  orderBy: z.enum([
    'id',
    'productCode',
    'productName',
    'category',
    'type',
    'subtype',
    'requestingDept',
    'budgetYear',
    'sequenceNo',
    'createdAt',
    'updatedAt'
  ]).optional(),
  sortOrder: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Warehouse update schema
export const updateWarehouseSchema = createWarehouseSchema.partial();

// ID parameter validation
export const idParamSchema = z.object({
  id: z.string().transform((val: string) => parseInt(val)).pipe(z.number().int().positive('Invalid ID format'))
});
