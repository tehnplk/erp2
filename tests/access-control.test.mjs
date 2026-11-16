import test from 'node:test';
import assert from 'node:assert/strict';

import {
  canAccess,
  canActOnDepartment,
  decideAccess,
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
  assert.equal(resolvePermissionModule('/settings/products'), null);
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
  assert.equal(canAccess(null, '/settings/products', 'GET'), false);
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

test('decideAccess gives the route decision the middleware enforces', () => {
  const admin = { role: 'Admin', departmentId: null };
  const manager = { role: 'Manager', departmentId: null };
  const userWithDepartment = { role: 'User', departmentId: 1 };
  const cases = [
    [null, '/', 'GET', 'allow'],
    [null, '/login', 'GET', 'allow'],
    [null, '/agent', 'GET', 'allow'],
    [null, '/api/agent/chat', 'POST', 'allow'],
    [null, '/api/sys-setting/public', 'GET', 'allow'],
    [null, '/api/products', 'GET', 'allow'],
    [null, '/api/products', 'POST', 'login'],
    [null, '/settings/products', 'GET', 'login'],
    [null, '/api/sys-setting', 'GET', 'login'],
    [null, '/api/inventory/issues', 'GET', 'login'],
    [manager, '/admin/users', 'GET', 'forbid'],
    [manager, '/api/users/1', 'PUT', 'forbid'],
    [admin, '/api/users/1', 'PUT', 'allow'],
    [manager, '/api/products/1', 'DELETE', 'forbid'],
    [manager, '/api/products/1', 'PUT', 'allow'],
    [userWithDepartment, '/api/usage-plans/2', 'PUT', 'allow'],
    [userWithDepartment, '/api/usage-plans', 'POST', 'forbid'],
    [userWithDepartment, '/api/usage-plans/2', 'DELETE', 'forbid'],
    [userWithDepartment, '/api/inventory/issues', 'POST', 'allow'],
    [userWithDepartment, '/api/sys-setting/1', 'PUT', 'allow'],
  ];

  for (const [user, pathname, method, expected] of cases) {
    assert.equal(decideAccess(user, pathname, method), expected, JSON.stringify({ user, pathname, method }));
  }
});

test('canActOnDepartment limits role User to its own department code', () => {
  const cases = [
    [{ role: 'Admin', departmentCode: null }, '0002', true],
    [{ role: 'Manager', departmentCode: '0001' }, '0002', true],
    [{ role: 'User', departmentCode: '0001' }, '0001', true],
    [{ role: 'User', departmentCode: ' 0001 ' }, '0001', true],
    [{ role: 'User', departmentCode: '0001' }, '0002', false],
    [{ role: 'User', departmentCode: null }, null, false],
    [{ role: 'User', departmentCode: '' }, '', false],
    [{ role: 'User', departmentCode: '0001' }, null, false],
    [null, '0001', false],
  ];

  for (const [user, rowDepartmentCode, expected] of cases) {
    assert.equal(canActOnDepartment(user, rowDepartmentCode), expected, JSON.stringify({ user, rowDepartmentCode }));
  }
});
