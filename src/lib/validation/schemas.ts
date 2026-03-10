import { z } from 'zod';

// Common validation patterns
const positiveNumber = z.string().transform((val: string) => parseFloat(val)).pipe(z.number().min(0));
const positiveInteger = z.string().transform((val: string) => parseInt(val)).pipe(z.number().int().min(0));
const numberInput = z.union([z.string(), z.number()]).transform((val) => val === '' ? 0 : Number(val)).pipe(z.number().min(0));
const nullableIntInput = z.union([z.string(), z.number(), z.null(), z.undefined()]).transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10)).pipe(z.number().int().min(0).nullable());
const nonEmptyString = z.string().min(1, 'This field is required');
const paginationFields = {
  page: z.coerce.number().int().min(1).optional(),
  page_size: z.coerce.number().int().min(1).max(200).optional()
};

// Product schemas
export const createProductSchema = z.object({
  code: nonEmptyString,
  category: nonEmptyString,
  name: nonEmptyString,
  type: z.string().optional(),
  subtype: z.string().optional(),
  unit: z.string().optional(),
  cost_price: positiveNumber.optional(),
  sell_price: positiveNumber.optional(),
  stock_balance: positiveInteger.optional(),
  stock_value: positiveNumber.optional(),
  seller_code: z.string().optional(),
  image: z.string().optional(),
  admin_note: z.string().optional()
});

export const updateProductSchema = createProductSchema.partial();

export const productQuerySchema = z.object({
  code: z.string().optional(),
  name: z.string().optional(),
  search: z.string().optional(),
  category: z.string().optional(),
  type: z.string().optional(),
  subtype: z.string().optional(),
  order_by: z.enum(['id', 'code', 'name', 'category', 'type', 'subtype', 'cost_price', 'sell_price']).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Inventory schemas
export const inventoryPendingPurchaseApprovalQuerySchema = z.object({
  product_name: z.string().optional(),
  department: z.string().optional(),
  budget_year: z.string().optional(),
  status: z.enum(['PENDING', 'PARTIAL', 'RECEIVED', 'CANCELLED']).optional(),
  order_by: z.enum(['id', 'product_code', 'product_name', 'department', 'budget_year', 'requested_quantity', 'received_qty']).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

export const createInventoryReceiptFromPurchaseApprovalSchema = z.object({
  purchase_approval_id: z.coerce.number().int().positive(),
  warehouse_id: z.coerce.number().int().positive(),
  location_id: z.coerce.number().int().positive().nullable().optional(),
  qty: z.coerce.number().int().positive(),
  unit_cost: z.union([z.string(), z.number(), z.null(), z.undefined()]).transform((val) => val === null || val === undefined || val === '' ? null : Number(val)).pipe(z.number().min(0).nullable()).optional(),
  vendor_name: z.string().optional(),
  receipt_date: z.string().optional(),
  receipt_no: z.string().optional(),
  lot_no: z.string().optional(),
  expiry_date: z.string().optional(),
  note: z.string().optional(),
  created_by: z.string().optional()
});

export const inventoryBalanceQuerySchema = z.object({
  product_name: z.string().optional(),
  product_code: z.string().optional(),
  category: z.string().optional(),
  product_type: z.string().optional(),
  warehouse_id: z.coerce.number().int().positive().optional(),
  low_stock_only: z.enum(['true', 'false']).optional(),
  order_by: z.enum(['id', 'product_code', 'product_name', 'category', 'product_type', 'on_hand_qty', 'available_qty', 'avg_cost']).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

export const inventoryMovementQuerySchema = z.object({
  inventory_item_id: z.coerce.number().int().positive().optional(),
  product_code: z.string().optional(),
  movement_type: z.string().optional(),
  reference_type: z.string().optional(),
  date_from: z.string().optional(),
  date_to: z.string().optional(),
  order_by: z.enum(['id', 'movement_date', 'movement_type', 'product_code', 'product_name', 'qty_in', 'qty_out']).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

export const createInventoryRequisitionSchema = z.object({
  requisition_no: z.string().optional(),
  request_date: z.string().optional(),
  requesting_department: nonEmptyString,
  requested_by: z.string().nullable().optional(),
  note: z.string().nullable().optional(),
  items: z.array(z.object({
    inventory_item_id: z.coerce.number().int().positive(),
    requested_qty: z.coerce.number().int().positive(),
    note: z.string().optional()
  })).min(1)
});

export const inventoryRequisitionQuerySchema = z.object({
  requisition_no: z.string().optional(),
  requesting_department: z.string().optional(),
  status: z.enum(['DRAFT', 'SUBMITTED', 'PARTIALLY_APPROVED', 'APPROVED', 'REJECTED', 'PARTIALLY_ISSUED', 'ISSUED', 'CANCELLED']).optional(),
  order_by: z.enum(['id', 'requisition_no', 'request_date', 'requesting_department', 'status']).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

export const approveInventoryRequisitionSchema = z.object({
  approved_by: z.string().nullable().optional(),
  note: z.string().nullable().optional(),
  items: z.array(z.object({
    requisition_item_id: z.coerce.number().int().positive(),
    approved_qty: z.coerce.number().int().min(0)
  })).min(1)
});

export const createInventoryIssueSchema = z.object({
  requisition_id: z.coerce.number().int().positive(),
  issue_no: z.string().optional(),
  issue_date: z.string().optional(),
  requesting_department: nonEmptyString,
  issued_by: z.string().nullable().optional(),
  approved_by: z.string().nullable().optional(),
  note: z.string().nullable().optional(),
  items: z.array(z.object({
    requisition_item_id: z.coerce.number().int().positive(),
    inventory_item_id: z.coerce.number().int().positive(),
    issued_qty: z.coerce.number().int().positive()
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
const departmentCodeSchema = z.string().regex(/^\d{4}$/, 'กรุณากรอกรหัสแผนก 4 หลัก');

export const createDepartmentSchema = z.object({
  name: nonEmptyString,
  department_code: departmentCodeSchema
});

export const updateDepartmentSchema = createDepartmentSchema;

export const departmentQuerySchema = z.object({
  name: z.string().optional(),
  department_code: z.string().optional(),
  ...paginationFields
});

// Category schemas
export const createCategorySchema = z.object({
  category_code: nonEmptyString,
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

// Purchase Plan schemas
export const createPurchasePlanSchema = z.object({
  product_code: z.string().optional(),
  category: z.string().optional(),
  product_name: z.string().optional(),
  product_type: z.string().optional(),
  product_subtype: z.string().optional(),
  unit: z.string().optional(),
  price_per_unit: numberInput.optional(),
  budget_year: z.string().optional(),
  plan_id: nullableIntInput.optional(),
  in_plan: z.string().optional(),
  carried_forward_quantity: nullableIntInput.optional(),
  carried_forward_value: numberInput.optional(),
  required_quantity_for_year: nullableIntInput.optional(),
  total_required_value: numberInput.optional(),
  additional_purchase_qty: nullableIntInput.optional(),
  additional_purchase_value: numberInput.optional(),
  usageplan_dept: z.string().optional(),
  usageplan_dept_code: z.string().optional()
});

export const updatePurchasePlanSchema = createPurchasePlanSchema.partial();

export const purchasePlanQuerySchema = z.object({
  product_name: z.string().optional(),
  category: z.string().optional(),
  type: z.string().optional(),
  product_type: z.string().optional(),
  product_subtype: z.string().optional(),
  requesting_dept: z.string().optional(),
  usageplan_dept: z.string().optional(),
  budget_year: z.string().optional(),
  order_by: z.enum([
    'id',
    'product_code',
    'product_name',
    'category',
    'product_type',
    'product_subtype',
    'unit',
    'price_per_unit',
    'required_quantity_for_year',
    'total_required_value',
    'budget_year',
    'usageplan_dept'
  ]).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Purchase Approval schemas
export const createPurchaseApprovalSchema = z.object({
  approval_id: z.string().optional(),
  department: z.string().optional(),
  budget_year: z.union([z.string(), z.number(), z.null(), z.undefined()])
    .transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10))
    .pipe(z.number().int().nullable())
    .optional(),
  record_number: z.string().optional(),
  request_date: z.string().optional(),
  product_name: z.string().optional(),
  product_code: z.string().optional(),
  category: z.string().optional(),
  product_type: z.string().optional(),
  product_subtype: z.string().optional(),
  requested_quantity: positiveInteger.optional(),
  unit: z.string().optional(),
  price_per_unit: positiveNumber.optional(),
  total_value: positiveNumber.optional(),
  over_plan_case: z.string().optional(),
  requester: z.string().optional(),
  approver: z.string().optional()
});

export const purchaseApprovalQuerySchema = z.object({
  product_name: z.string().optional(),
  category: z.string().optional(),
  product_type: z.string().optional(),
  product_subtype: z.string().optional(),
  department: z.string().optional(),
  budget_year: z.string().optional(),
  order_by: z.enum([
    'id', 'approval_id', 'department', 'budget_year', 'record_number', 'request_date', 
    'product_name', 'product_code', 'category', 'product_type', 
    'product_subtype', 'requester', 'approver'
  ]).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Survey schemas
export const createSurveySchema = z.object({
  product_code: z.string().nullable().optional(),
  category: z.string().nullable().optional(),
  type: z.string().nullable().optional(),
  subtype: z.string().nullable().optional(),
  product_name: z.string().nullable().optional(),
  requested_amount: nullableIntInput.optional(),
  unit: z.string().nullable().optional(),
  price_per_unit: numberInput.optional(),
  requesting_dept: z.string().nullable().optional(),
  approved_quota: nullableIntInput.optional(),
  budget_year: z.union([z.string(), z.number(), z.null(), z.undefined()])
    .transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10))
    .pipe(z.number().int().nullable())
    .optional(),
  sequence_no: z.union([z.string(), z.number(), z.null(), z.undefined()])
    .transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10))
    .pipe(z.number().int().min(1).max(2).nullable())
    .optional()
});

export const updateSurveySchema = createSurveySchema.partial();

export const surveyQuerySchema = z.object({
  product_name: z.string().optional(),
  category: z.string().optional(),
  type: z.string().optional(),
  subtype: z.string().optional(),
  requesting_dept: z.string().optional(),
  budget_year: z.string().optional(),
  order_by: z.enum([
    'id',
    'product_code',
    'product_name',
    'category',
    'type',
    'subtype',
    'requesting_dept',
    'budget_year',
    'sequence_no',
    'created_at',
    'updated_at'
  ]).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// ID parameter validation
export const idParamSchema = z.object({
  id: z.coerce.number().int().positive()
});
