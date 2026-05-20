import test from 'node:test';
import assert from 'node:assert/strict';

import {
  canAccess,
  getActionForMethod,
  resolvePermissionModule,
} from '../src/lib/access-control.ts';

test('maps HTTP methods to permission actions', () => {
  assert.equal(getActionForMethod('GET'), 'view');
  assert.equal(getActionForMethod('HEAD'), 'view');
  assert.equal(getActionForMethod('POST'), 'create');
  assert.equal(getActionForMethod('PUT'), 'edit');
  assert.equal(getActionForMethod('PATCH'), 'edit');
  assert.equal(getActionForMethod('DELETE'), 'delete');
});

test('resolves app and API paths to documented permission modules', () => {
  assert.equal(resolvePermissionModule('/products'), '/products');
  assert.equal(resolvePermissionModule('/api/products/12'), '/products');
  assert.equal(resolvePermissionModule('/api/categories'), '/categories');
  assert.equal(resolvePermissionModule('/api/inventory/stock/lots'), '/inventory/stock');
  assert.equal(resolvePermissionModule('/inventory/stock'), '/inventory/stock');
  assert.equal(resolvePermissionModule('/inventory/receipts'), null);
});

test('applies Admin Manager and User role permissions from detail_improve.md', () => {
  assert.equal(canAccess({ role: 'Admin' }, '/api/products/1', 'DELETE'), true);
  assert.equal(canAccess({ role: 'Manager' }, '/api/products/1', 'DELETE'), false);
  assert.equal(canAccess({ role: 'Manager' }, '/api/products/1', 'PUT'), true);
  assert.equal(canAccess({ role: 'User' }, '/api/products', 'GET'), true);
  assert.equal(canAccess({ role: 'User' }, '/api/products', 'POST'), false);
});

test('allows unauthenticated users to view documented modules only', () => {
  assert.equal(canAccess(null, '/api/products', 'GET'), true);
  assert.equal(canAccess(null, '/api/categories', 'GET'), true);
  assert.equal(canAccess(null, '/api/products', 'POST'), false);
  assert.equal(canAccess(null, '/api/inventory/stock', 'HEAD'), true);
  assert.equal(canAccess(null, '/api/inventory/stock', 'DELETE'), false);
  assert.equal(canAccess(null, '/api/inventory/receipts', 'GET'), false);
});

test('adds department-match permissions only on department-scoped modules', () => {
  const matchedDepartmentUser = { role: 'User', departmentId: 1 };
  const userWithoutDepartmentMatch = { role: 'User', departmentId: null };

  assert.equal(canAccess(matchedDepartmentUser, '/api/usage-plans/2', 'PUT'), true);
  assert.equal(canAccess(matchedDepartmentUser, '/api/usage-plans/2', 'DELETE'), false);
  assert.equal(canAccess(matchedDepartmentUser, '/api/purchase-plans', 'POST'), true);
  assert.equal(canAccess(matchedDepartmentUser, '/api/purchase-approvals/2', 'PATCH'), true);
  assert.equal(canAccess(matchedDepartmentUser, '/api/inventory/stock', 'POST'), true);
  assert.equal(canAccess(matchedDepartmentUser, '/api/products', 'POST'), false);
  assert.equal(canAccess(userWithoutDepartmentMatch, '/api/purchase-plans', 'POST'), false);
});
