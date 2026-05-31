# User Role Normalization Design

## Summary

Normalize application roles into a dedicated lookup table and remove the duplicated role text column from `public.users`.

The new source of truth will be:

- `public.user_role(id, role, is_active)`
- `public.users.user_role_id -> public.user_role(id)`

The app will continue to use role names (`Admin`, `Manager`, `User`) in TypeScript, auth session data, validation, and UI labels. Database writes will resolve those role names to `user_role.id`, and reads will join back to `user_role.role`.

## Goals

- Replace `public.users.role` with `public.users.user_role_id`
- Seed exactly three roles: `Admin`, `Manager`, `User`
- Keep existing app permissions and UI behavior unchanged
- Refactor all role-related reads and writes across the codebase
- Fail loudly during migration if a legacy role value cannot be mapped

## Non-Goals

- No role CRUD UI or API
- No permission model redesign
- No behavior change for access control

## Database Design

### New Table

Create `public.user_role` with:

- `id BIGSERIAL PRIMARY KEY`
- `role TEXT NOT NULL UNIQUE`
- `is_active BOOLEAN NOT NULL DEFAULT true`

Constraints:

- `user_role.role` must be limited to `Admin`, `Manager`, `User`

Indexes:

- unique index on `role`
- index on `is_active`

### Users Table Change

Add:

- `public.users.user_role_id BIGINT REFERENCES public.user_role(id)`

Migration flow:

1. Create `public.user_role`
2. Seed `Admin`, `Manager`, `User`
3. Add nullable `public.users.user_role_id`
4. Backfill from current `public.users.role`
5. Abort if any user row still has null `user_role_id`
6. Mark `user_role_id` as `NOT NULL`
7. Add index on `users.user_role_id`
8. Drop legacy `users.role` check constraint, index, and column

## Application Design

### Read Path

Any code that currently reads `users.role` will instead:

- join `public.user_role ur ON ur.id = u.user_role_id`
- select `ur.role AS role`

This preserves the current application-facing shape.

### Write Path

Any code that currently inserts or updates `users.role` will instead:

- accept the same role string input (`Admin`, `Manager`, `User`)
- resolve the matching `user_role.id` inside SQL
- persist `users.user_role_id`

The app must not rely on hard-coded role IDs.

### Auth and Access

Authentication and JWT/session callbacks will keep returning `role` as a string union. No middleware or permission behavior should change.

### Admin Users UI

The admin users page will continue to:

- display the same three role options
- submit the same role string values
- receive role strings from the API

Only the persistence layer changes.

## Error Handling

- Migration must fail if an unexpected legacy role value exists
- Create/update user flows must fail if a provided role string cannot resolve to a seeded role row
- Duplicate provider ID behavior remains unchanged

## Testing Strategy

- Update unit tests for user management to verify role lookup SQL behavior
- Update auth-oriented user query tests or related fixtures to verify join-based role reads
- Keep access control tests focused on the existing role strings

## Risks

- Missing one raw `users.role` reference could break login or admin user management
- Using hard-coded role IDs would create fragile behavior across environments
- Migration order matters because reads and writes must stay valid after the column swap

## Implementation Notes

- This repo’s active schema changes live under `db/migrations`
- The app uses direct SQL in server-side modules rather than Prisma models for the user flows being changed
- User instruction override: implementation may proceed immediately after this spec without a separate review pause
