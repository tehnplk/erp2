import { z } from 'zod';
import { get_approval_doc_status_code } from '@/lib/approval-doc-status';

// Common validation patterns
const positiveNumber = z.union([z.string(), z.number()]).transform((val) => Number(val)).pipe(z.number().min(0));
const positiveInteger = z.union([z.string(), z.number()]).transform((val) => parseInt(String(val), 10)).pipe(z.number().int().min(0));
const numberInput = z.union([z.string(), z.number()]).transform((val) => val === '' ? 0 : Number(val)).pipe(z.number().min(0));
const nullableIntInput = z.union([z.string(), z.number(), z.null(), z.undefined()]).transform((val) => val === null || val === undefined || val === '' ? null : parseInt(String(val), 10)).pipe(z.number().int().min(0).nullable());
const nonEmptyString = z.string().min(1, 'This field is required');
const booleanField = z.coerce.boolean();
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
  purchase_department_id: nullableIntInput.optional(),
  cost_price: positiveNumber.optional(),
  sell_price: positiveNumber.optional(),
  stock_balance: positiveInteger.optional(),
  stock_value: positiveNumber.optional(),
  seller_code: z.string().optional(),
  image: z.string().optional(),
  admin_note: z.string().optional(),
  is_active: booleanField.optional()
});

export const updateProductSchema = createProductSchema.partial();

export const productQuerySchema = z.object({
  code: z.string().optional(),
  name: z.string().optional(),
  search: z.string().optional(),
  category: z.string().optional(),
  type: z.string().optional(),
  subtype: z.string().optional(),
  include_inactive: z.coerce.boolean().optional(),
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
  purchase_approval_detail_id: z.coerce.number().int().positive().optional(),
  purchase_approval_id: z.coerce.number().int().positive().optional(),
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
}).superRefine((data, ctx) => {
  if (!data.purchase_approval_detail_id && !data.purchase_approval_id) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['purchase_approval_detail_id'],
      message: 'purchase_approval_detail_id is required',
    });
  }
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
  mobile: z.string().optional(),
  is_active: booleanField.optional()
});

export const updateSellerSchema = createSellerSchema.partial();

export const sellerQuerySchema = z.object({
  name: z.string().optional(),
  include_inactive: z.coerce.boolean().optional(),
  ...paginationFields
});

// Department schemas
const departmentCodeSchema = z.string().regex(/^\d{4}$/, 'กรุณากรอกรหัสแผนก 4 หลัก');

export const createDepartmentSchema = z.object({
  name: nonEmptyString,
  department_code: departmentCodeSchema,
  is_active: booleanField.optional()
});

export const updateDepartmentSchema = createDepartmentSchema;

export const departmentQuerySchema = z.object({
  name: z.string().optional(),
  department_code: z.string().optional(),
  include_inactive: z.coerce.boolean().optional(),
  ...paginationFields
});

// Category schemas
export const createCategorySchema = z.object({
  category_code: nonEmptyString,
  category: nonEmptyString,
  type: nonEmptyString,
  subtype: nonEmptyString,
  is_active: booleanField.optional()
});

export const updateCategorySchema = createCategorySchema.partial();

export const categoryQuerySchema = z.object({
  category: z.string().optional(),
  type: z.string().optional(),
  subtype: z.string().optional(),
  include_inactive: z.coerce.boolean().optional(),
  ...paginationFields
});

// Purchase Plan schemas
export const createPurchasePlanSchema = z.object({
  usage_plan_ids: z.array(z.coerce.number().int().positive()).optional(),
  inventory_qty: nullableIntInput.optional(),
  qouta_qty: nullableIntInput.optional(),
  purchase_qty: nullableIntInput.optional(),
});

export const updatePurchasePlanSchema = createPurchasePlanSchema.partial();

export const purchasePlanQuerySchema = z.object({
  product_name: z.string().optional(),
  category: z.string().optional(),
  product_type: z.string().optional(),
  product_subtype: z.string().optional(),
  purchase_department: z.string().optional(),
  budget_year: z.string().optional(),
  requesting_dept: z.string().optional(),
  has_purchase_approval: z.enum(['true', 'false']).optional(),
  order_by: z.enum([
    'id',
    'product_code',
    'product_name',
    'purchase_department',
    'approved_quota',
    'inventory_qty',
    'purchased_qty',
    'purchase_qty',
    'unit_price',
    'purchase_value',
    'budget_year'
  ]).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Purchase Approval schemas
export const createPurchaseApprovalSchema = z.object({
  approve_code: z.string().optional(),
  doc_no: z.string().optional(),
  doc_date: z.string().optional(),
  seller_id: z.coerce.number().int().positive().optional(),
  is_inspection: z.boolean().optional(),
  status: z.string().refine((value) => get_approval_doc_status_code(value) !== null, 'Invalid approval status').optional(),
  total_amount: z.number().optional(),
  total_items: z.number().optional(),
  prepared_by: z.string().optional(),
  approved_by: z.string().optional(),
  approved_at: z.string().optional(),
  notes: z.string().optional(),
  pending_note: z.string().optional(),
  created_by: z.string().optional(),
  updated_by: z.string().optional()
});

export const createPurchaseApprovalDetailSchema = z.object({
  purchase_plan_id: z.coerce.number().int().positive(),
  line_number: z.coerce.number().int().positive().optional(),
  status: z.enum(['PENDING', 'APPROVED', 'REJECTED', 'MODIFIED']).optional(),
  proposed_quantity: z.coerce.number().int().min(0).optional(),
  proposed_amount: z.number().min(0).optional(),
  approved_quantity: z.coerce.number().int().min(0).optional(),
  approved_amount: z.number().min(0).optional(),
  remarks: z.string().optional(),
  created_by: z.string().optional(),
  updated_by: z.string().optional()
});

export const createPurchaseApprovalWithDetailsSchema = z.object({
  header: createPurchaseApprovalSchema,
  details: z.array(createPurchaseApprovalDetailSchema).min(1)
});

export const purchaseApprovalQuerySchema = z.object({
  product_name: z.string().optional(),
  category: z.string().optional(),
  product_type: z.string().optional(),
  product_subtype: z.string().optional(),
  department: z.string().optional(),
  purchase_department: z.string().optional(),
  budget_year: z.string().optional(),
  status: z.string().refine((value) => get_approval_doc_status_code(value) !== null, 'Invalid approval status').optional(),
  order_by: z.enum([
    'id', 'approve_code', 'doc_no', 'doc_date', 'status', 'total_amount', 'total_items',
    'prepared_by', 'approved_by', 'approved_at', 'notes', 'created_at', 'updated_at', 'version',
    'department', 'purchase_department', 'budget_year', 'product_name', 'product_code', 'category', 'product_type', 
    'product_subtype'
  ]).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
  ...paginationFields
});

// Usage Plan schemas
export const create_usage_plan_schema = z.object({
  product_code: z.string().nullable().optional(),
  requested_amount: nullableIntInput.optional(),
  requesting_dept_code: z.string().trim().max(4).nullable().optional(),
  plan_flag: z.enum(['ในแผน', 'นอกแผน']).optional(),
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

export const update_usage_plan_schema = create_usage_plan_schema.partial();

export const usage_plan_query_schema = z.object({
  product_code: z.string().optional(),
  requesting_dept_code: z.string().optional(),
  plan_flag: z.enum(['ในแผน', 'นอกแผน']).optional(),
  budget_year: z.string().optional(),
  category: z.string().optional(),
  type: z.string().optional(),
  has_purchase_plan: z.enum(['true', 'false']).optional(),
  order_by: z.enum([
    'id',
    'product_code',
    'requesting_dept_code',
    'requested_amount',
    'approved_quota',
    'plan_flag',
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
