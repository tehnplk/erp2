import test from 'node:test';
import assert from 'node:assert/strict';

import {
  DuplicateUserProviderIdError,
  UserNotFoundError,
  createUserRecord,
  listUserRecords,
  updateUserRecord,
} from '../src/lib/user-management.ts';

const input = {
  provider_id: ' New.User ',
  name: 'New User',
  password: 'Secret1234',
  role: 'Manager',
  department_id: 3,
  is_department_owner: true,
  is_active: true,
};

test('createUserRecord hashes password and inserts a normalized user', async () => {
  const calls = [];
  const query = async (text, params) => {
    calls.push({ text, params });
    return {
      rows: [
        {
          id: '101',
          provider_id: params[0],
          name: params[1],
          role: params[3],
          department_id: params[4],
          department_name: 'Department',
          department_code: '0003',
          is_department_owner: params[5],
          is_active: params[6],
          created_at: '2026-05-20T00:00:00.000Z',
          updated_at: '2026-05-20T00:00:00.000Z',
          last_login_at: null,
        },
      ],
    };
  };

  const user = await createUserRecord(input, {
    query,
    hashPassword: async (password) => `hashed:${password}`,
  });

  assert.equal(calls.length, 1);
  assert.equal(calls[0].params[0], 'New.User');
  assert.match(calls[0].text, /provider_id/);
  assert.equal(calls[0].text.includes('email'), false);
  assert.equal(calls[0].text.includes('user_role_id'), true);
  assert.equal(calls[0].text.includes('JOIN public.user_role'), true);
  assert.equal(calls[0].text.includes('ur.role AS role'), true);
  assert.equal(calls[0].params[2], 'hashed:Secret1234');
  assert.equal(calls[0].params.includes('Secret1234'), false);
  assert.equal(user.provider_id, 'New.User');
  assert.equal(user.role, 'Manager');
});

test('createUserRecord maps duplicate provider id errors', async () => {
  const query = async () => {
    const error = new Error('duplicate key');
    error.code = '23505';
    throw error;
  };

  await assert.rejects(
    () =>
      createUserRecord(input, {
        query,
        hashPassword: async () => 'hashed',
      }),
    DuplicateUserProviderIdError
  );
});

test('updateUserRecord updates profile fields without changing password when blank', async () => {
  const calls = [];
  const query = async (text, params) => {
    calls.push({ text, params });
    return {
      rows: [
        {
          id: '101',
          provider_id: params[0],
          name: params[1],
          role: params[2],
          department_id: params[3],
          department_name: 'Department',
          department_code: '0003',
          is_department_owner: params[4],
          is_active: params[5],
          created_at: '2026-05-20T00:00:00.000Z',
          updated_at: '2026-05-20T00:00:00.000Z',
          last_login_at: null,
        },
      ],
    };
  };

  await updateUserRecord(
    '101',
    {
      provider_id: 'Updated.User',
      name: 'Updated User',
      role: 'Admin',
      department_id: 3,
      is_department_owner: false,
      is_active: true,
      password: '',
    },
    {
      query,
      hashPassword: async () => {
        throw new Error('password should not be hashed');
      },
    }
  );

  assert.equal(calls[0].text.includes('password_hash'), false);
  assert.equal(calls[0].text.includes('user_role_id'), true);
  assert.equal(calls[0].text.includes('JOIN public.user_role'), true);
  assert.equal(calls[0].text.includes('ur.role AS role'), true);
  assert.equal(calls[0].params[0], 'Updated.User');
  assert.match(calls[0].text, /provider_id = \$1/);
});

test('updateUserRecord hashes a provided replacement password', async () => {
  const calls = [];
  const query = async (text, params) => {
    calls.push({ text, params });
    return { rows: [{ id: '101' }] };
  };

  await updateUserRecord(
    '101',
    {
      provider_id: 'updated',
      name: 'Updated',
      password: 'NewSecret123',
      role: 'Manager',
      department_id: null,
      is_department_owner: false,
      is_active: true,
    },
    {
      query,
      hashPassword: async (password) => `hashed:${password}`,
    }
  );

  assert.equal(calls[0].text.includes('password_hash'), true);
  assert.equal(calls[0].text.includes('user_role_id'), true);
  assert.equal(calls[0].params.includes('NewSecret123'), false);
  assert.equal(calls[0].params.includes('hashed:NewSecret123'), true);
});

test('listUserRecords reads role names through the user_role join', async () => {
  const calls = [];
  const query = async (text) => {
    calls.push(text);
    return {
      rows: [
        {
          id: '101',
          provider_id: 'user-1',
          name: 'User 1',
          role: 'User',
          department_id: null,
          department_name: null,
          department_code: null,
          is_department_owner: false,
          is_active: true,
          last_login_at: null,
          created_at: '2026-05-20T00:00:00.000Z',
          updated_at: '2026-05-20T00:00:00.000Z',
        },
      ],
    };
  };

  const users = await listUserRecords(query);

  assert.equal(calls.length, 1);
  assert.equal(calls[0].includes('JOIN public.user_role'), true);
  assert.equal(calls[0].includes('ur.role AS role'), true);
  assert.equal(calls[0].includes('u.user_role_id'), true);
  assert.equal(users[0].role, 'User');
});

test('updateUserRecord throws when the user does not exist', async () => {
  await assert.rejects(
    () =>
      updateUserRecord(
        '404',
        {
          provider_id: 'missing',
          name: null,
          role: 'User',
          department_id: null,
          is_department_owner: false,
          is_active: true,
        },
        {
          query: async () => ({ rows: [] }),
          hashPassword: async () => 'hashed',
        }
      ),
    UserNotFoundError
  );
});
