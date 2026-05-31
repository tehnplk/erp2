# User Role Normalization Design

Date: 2026-05-31
Project: `e:\NextJS\erp`
Status: Approved for planning

## Summary

Normalize the local role system by moving role definitions into a new `public.user_role` lookup table and replacing `public.users.role` with `public.users.user_role_id`. The application will continue to use role names (`Admin`, `Manager`, `User`) at the TypeScript and UI layers, while the database stores a foreign key to the role lookup row.

This change is local-only for now. The `user_role` table is seed-only. No role management UI or API will be added.

## Goals

- Remove duplicated role text storage from `public.users`.
- Make `public.user_role` the database source of truth for roles.
- Preserve current application behavior for auth, access control, middleware, and admin user management.
- Keep role handling readable in app code by continuing to expose role names after query joins.
- Make the migration fail loudly if unexpected legacy role data is found.

## Non-Goals

- No production database changes in this task.
- No CRUD screens or APIs for managing roles.
- No permission model redesign.
- No change to the existing role names or permission rules.

## Current State

The local database stores role text directly on `public.users.role` with a check constraint for `Admin`, `Manager`, and `User`. Application code reads and writes role text directly in:

- `src/lib/users.ts`
- `src/lib/user-management.ts`
- `src/auth.ts`
- `src/lib/access-control.ts`
- `src/app/admin/users/*`
- `src/app/api/users/*`
- related tests and auth type definitions

## Proposed Data Model

### New Table

`public.user_role`

- `id` integer generated identity primary key
- `role` text not null unique
- `is_active` boolean not null default true

Allowed seeded values:

- `Admin`
- `Manager`
- `User`

### Updated Users Table

Replace:

- `public.users.role text not null`

With:

- `public.users.user_role_id integer not null references public.user_role(id)`

## Migration Design

Create a new SQL migration under `db/migrations` that:

1. Creates `public.user_role` if it does not exist.
2. Seeds `Admin`, `Manager`, and `User` in an idempotent way.
3. Adds nullable `public.users.user_role_id`.
4. Backfills `user_role_id` by joining `public.user_role.role = public.users.role`.
5. Verifies there are no rows with null `user_role_id` after backfill.
6. Marks `user_role_id` as `NOT NULL`.
7. Adds the foreign key and supporting indexes.
8. Drops the old role check constraint, role index, and `public.users.role` column.

## Failure Strategy

The migration must not guess. If any existing `public.users.role` value does not map to a seeded `public.user_role.role`, the migration should stop with a clear error before dropping the old column.

## Query and Write Design

Application code will continue to work with role text values, but SQL will resolve them through joins.

### Read Pattern

Queries that need a user role will:

- join `public.user_role ur ON ur.id = u.user_role_id`
- select `ur.role AS role`

This keeps downstream TypeScript types stable while using normalized storage.

### Create Pattern

User creation will:

- accept role text from the app layer
- resolve the matching `user_role.id` in SQL
- insert that id into `public.users.user_role_id`

The write path must not hard-code numeric role IDs.

### Update Pattern

User updates will:

- accept role text from the app layer
- resolve the matching `user_role.id` in SQL
- update `public.users.user_role_id`

## Application Refactor Scope

### Auth

`src/lib/users.ts` and `src/auth.ts` will be updated so the authenticated user still exposes:

- `session.user.role`
- `token.role`

These values will come from the joined `public.user_role.role` field instead of `public.users.role`.

### Access Control

`src/lib/access-control.ts` will continue to use the same role union and permission map:

- `Admin`
- `Manager`
- `User`

No permission behavior change is intended.

### User Management

`src/lib/user-management.ts` will be refactored so:

- list queries join `public.user_role`
- create queries resolve `user_role_id`
- update queries resolve `user_role_id`
- returned API records still expose `role` text for the UI

### API and UI

`src/app/api/users/*` and `src/app/admin/users/*` will keep their current request and response role shape. The admin UI remains seed-only and will still offer exactly:

- `Admin`
- `Manager`
- `User`

### Types and Validation

Type definitions and zod validation can keep the role union and role enums unchanged because the external app contract does not change.

## Testing Strategy

Refactor tests to verify the normalized behavior rather than direct `users.role` storage.

Coverage should include:

- auth queries still return role text
- user list queries still return role text
- create user resolves role text to `user_role_id`
- update user resolves role text to `user_role_id`
- access control behavior remains unchanged

Test data and SQL mocks should reflect joins or lookup-based writes where relevant.

## Risks

- SQL updates may miss a query path that still references `public.users.role`.
- Tests may still assume role text is written directly to `public.users`.
- Future developers may be tempted to depend on seeded numeric role IDs if conventions are not explicit.

## Mitigations

- Search the codebase for all role references before implementation.
- Keep role name output stable at the app boundary.
- Resolve role IDs by role text in SQL instead of hard-coding IDs.
- Update tests alongside each read/write path change.

## Implementation Outline

1. Add migration for `user_role`, backfill, and `users.user_role_id`.
2. Update shared user/auth queries to join `user_role`.
3. Update create and update user write paths to resolve role IDs.
4. Update API, UI, and type consumers as needed while preserving role text externally.
5. Update and run targeted tests for user management and access control.

## Acceptance Criteria

- Local DB has `public.user_role` with seeded rows for `Admin`, `Manager`, and `User`.
- `public.users` stores `user_role_id` and no longer stores `role`.
- App auth and admin user management still operate using role text externally.
- Permission behavior remains unchanged.
- No app code depends on hard-coded role IDs.
