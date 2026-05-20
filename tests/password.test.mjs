import test from 'node:test';
import assert from 'node:assert/strict';

import { hashPassword, verifyPassword } from '../src/lib/password.ts';

test('verifies passwords hashed by the app', async () => {
  const hash = await hashPassword('correct horse battery staple');

  assert.equal(await verifyPassword('correct horse battery staple', hash), true);
  assert.equal(await verifyPassword('wrong password', hash), false);
});

test('rejects malformed password hashes', async () => {
  assert.equal(await verifyPassword('password', 'not-a-real-hash'), false);
});
