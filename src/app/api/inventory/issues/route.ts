import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { apiConflict, apiError, apiNotFound, apiSuccess } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { createInventoryIssueSchema } from '@/lib/validation/schemas';

export async function GET() {
  try {
    const cacheKey = 'erp:inventory:issues:list:all';
    const cached = await cacheGet<any[]>(cacheKey);
    if (cached) return apiSuccess(cached);

    const result = await pgQuery(`
      SELECT
        ii.id,
        ii.issue_no,
        ii.issue_date,
        ii.requisition_id,
        ii.requesting_department,
        ii.status,
        ii.issued_by,
        ii.approved_by,
        ii.note,
        ii.created_at,
        COALESCE(SUM(iii.issued_qty), 0)::int AS issued_qty_total
      FROM public.inventory_issue ii
      LEFT JOIN public.inventory_issue_item iii ON iii.issue_id = ii.id
      GROUP BY ii.id
      ORDER BY ii.id DESC
    `);

    await cacheSet(cacheKey, result.rows, 300); // 5 minutes

    return apiSuccess(result.rows);
  } catch (error) {
    console.error('Error fetching inventory issues:', error);
    return apiError('Failed to fetch inventory issues');
  }
}

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(createInventoryIssueSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const { requisition_id, issue_no, issue_date, requesting_department, issued_by, approved_by, note, items } = validation.data;
    const resolvedIssueNo = issue_no || `ISS-${Date.now()}`;
    const resolvedIssueDate = issue_date || new Date().toISOString();

    await client.query('BEGIN');

    const requisitionResult = await client.query(
      `SELECT id, status FROM public.inventory_requisition WHERE id = $1 FOR UPDATE`,
      [requisition_id]
    );

    if (requisitionResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return apiNotFound('Inventory requisition');
    }

    const requisition = requisitionResult.rows[0];
    if (!['APPROVED', 'PARTIALLY_APPROVED', 'PARTIALLY_ISSUED'].includes(requisition.status)) {
      await client.query('ROLLBACK');
      return apiConflict('Inventory requisition is not ready for issue posting');
    }

    const issueResult = await client.query(
      `INSERT INTO public.inventory_issue (issue_no, issue_date, requisition_id, requesting_department, status, issued_by, approved_by, note)
       VALUES ($1, $2, $3, $4, 'POSTED', $5, $6, $7)
       RETURNING id, issue_no, issue_date`,
      [resolvedIssueNo, resolvedIssueDate, requisition_id, requesting_department, issued_by || null, approved_by || null, note || null]
    );

    const issue = issueResult.rows[0];

    for (const item of items) {
      const requisitionItemResult = await client.query(
        `SELECT id, inventory_item_id, approved_qty, issued_qty
         FROM public.inventory_requisition_item
         WHERE id = $1 AND requisition_id = $2
         FOR UPDATE`,
        [item.requisition_item_id, requisition_id]
      );

      if (requisitionItemResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return apiNotFound(`Inventory requisition item ${item.requisition_item_id}`);
      }

      const requisitionItem = requisitionItemResult.rows[0];
      const approvedQty = Number(requisitionItem.approved_qty || 0);
      const alreadyIssuedQty = Number(requisitionItem.issued_qty || 0);
      const remainingIssueQty = approvedQty - alreadyIssuedQty;

      if (item.inventory_item_id !== Number(requisitionItem.inventory_item_id)) {
        await client.query('ROLLBACK');
        return apiConflict(`Inventory item mismatch for requisition item ${item.requisition_item_id}`);
      }

      if (item.issued_qty > remainingIssueQty) {
        await client.query('ROLLBACK');
        return apiConflict(`Issued quantity exceeds remaining approved quantity for requisition item ${item.requisition_item_id}`);
      }

      const balanceResult = await client.query(
        `SELECT on_hand_qty, reserved_qty, available_qty, avg_cost
         FROM public.inventory_balance
         WHERE inventory_item_id = $1
         FOR UPDATE`,
        [item.inventory_item_id]
      );

      if (balanceResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return apiNotFound(`Inventory balance for item ${item.inventory_item_id}`);
      }

      const balance = balanceResult.rows[0];
      const onHandQty = Number(balance.on_hand_qty || 0);
      const reservedQty = Number(balance.reserved_qty || 0);
      const availableQty = Number(balance.available_qty || 0);
      const avgCost = Number(balance.avg_cost || 0);

      if (item.issued_qty > onHandQty) {
        await client.query('ROLLBACK');
        return apiConflict(`Issued quantity exceeds on hand quantity for inventory item ${item.inventory_item_id}`);
      }

      if (item.issued_qty > reservedQty) {
        await client.query('ROLLBACK');
        return apiConflict(`Issued quantity exceeds reserved quantity for inventory item ${item.inventory_item_id}`);
      }

      await client.query(
        `INSERT INTO public.inventory_issue_item (issue_id, requisition_item_id, inventory_item_id, issued_qty, unit_cost, total_cost)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [issue.id, item.requisition_item_id, item.inventory_item_id, item.issued_qty, avgCost, item.issued_qty * avgCost]
      );

      const nextOnHandQty = onHandQty - item.issued_qty;
      const nextReservedQty = reservedQty - item.issued_qty;
      const nextAvailableQty = availableQty;

      await client.query(
        `UPDATE public.inventory_balance
         SET on_hand_qty = $2,
             reserved_qty = $3,
             available_qty = $4,
             last_movement_at = CURRENT_TIMESTAMP,
             updated_at = CURRENT_TIMESTAMP
         WHERE inventory_item_id = $1`,
        [item.inventory_item_id, nextOnHandQty, nextReservedQty, nextAvailableQty]
      );

      await client.query(
        `UPDATE public.inventory_requisition_item
         SET issued_qty = issued_qty + $2,
             line_status = CASE
               WHEN issued_qty + $2 >= approved_qty THEN 'ISSUED'
               WHEN issued_qty + $2 > 0 THEN 'PARTIALLY_ISSUED'
               ELSE line_status
             END
         WHERE id = $1`,
        [item.requisition_item_id, item.issued_qty]
      );

      await client.query(
        `INSERT INTO public.inventory_movement
          (inventory_item_id, movement_date, movement_type, qty_in, qty_out, unit_cost, total_cost, balance_qty_after, balance_value_after, reference_type, reference_id, reference_no, target_department, note, created_by)
         VALUES ($1, $2, 'ISSUE_APPROVED', 0, $3, $4, $5, $6, $7, 'InventoryIssue', $8, $9, $10, $11, $12)`,
        [
          item.inventory_item_id,
          resolvedIssueDate,
          item.issued_qty,
          avgCost,
          item.issued_qty * avgCost,
          nextOnHandQty,
          Number((nextOnHandQty * avgCost).toFixed(2)),
          issue.id,
          issue.issue_no,
          requesting_department,
          note || null,
          issued_by || null,
        ]
      );
    }

    const requisitionSummaryResult = await client.query(
      `SELECT
         COALESCE(SUM(approved_qty), 0)::int AS approved_qty_total,
         COALESCE(SUM(issued_qty), 0)::int AS issued_qty_total
       FROM public.inventory_requisition_item
       WHERE requisition_id = $1`,
      [requisition_id]
    );

    const approvedQtyTotal = Number(requisitionSummaryResult.rows[0]?.approved_qty_total || 0);
    const issuedQtyTotal = Number(requisitionSummaryResult.rows[0]?.issued_qty_total || 0);
    const nextStatus = issuedQtyTotal >= approvedQtyTotal ? 'ISSUED' : 'PARTIALLY_ISSUED';

    await client.query(
      `UPDATE public.inventory_requisition
       SET status = $2,
           issued_by = $3,
           issued_at = CURRENT_TIMESTAMP,
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $1`,
      [requisition_id, nextStatus, issued_by || null]
    );

    await client.query('COMMIT');

    // Invalidate Redis Cache
    await cacheDelByPattern('erp:inventory:balances:*');
    await cacheDelByPattern('erp:inventory:issues:list:*');
    await cacheDelByPattern('erp:inventory:requisitions:list:*');

    return apiSuccess({
      issue_id: issue.id,
      issue_no: issue.issue_no,
      requisition_id,
      status: nextStatus,
    }, 'Inventory issue posted successfully', undefined, 201);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error posting inventory issue:', error);
    return apiError('Failed to post inventory issue');
  } finally {
    client.release();
  }
}
