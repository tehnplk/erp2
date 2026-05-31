# User Role Normalization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `public.users.role` with a seeded `public.user_role` lookup table while preserving existing application behavior.

**Architecture:** Add a migration that normalizes role storage, then refactor all user/auth SQL paths to join through `user_role` while keeping role strings as the app-facing contract. Update tests first so the persistence change is captured before the production code changes.

**Tech Stack:** PostgreSQL, Next.js, NextAuth, TypeScript, direct SQL modules, Node test runner

---

### Task 1: Document and map the role-system touchpoints

**Files:**
- Create: `docs/superpowers/specs/2026-05-31-user-role-normalization-design.md`
- Create: `docs/superpowers/plans/2026-05-31-user-role-normalization.md`
- Modify: `src/lib/users.ts`
- Modify: `src/lib/user-management.ts`
- Modify: `src/auth.ts`
- Modify: `src/app/admin/users/users-admin-client.tsx`
- Modify: `src/lib/validation/schemas.ts`
- Test: `tests/user-management.test.mjs`

- [ ] Confirm the migration order and all direct role references before changing behavior.

### Task 2: Add failing role-lookup tests

**Files:**
- Modify: `tests/user-management.test.mjs`
- Test: `tests/user-management.test.mjs`

- [ ] Add assertions that create/update flows no longer write `users.role` and instead resolve `user_role_id`.
- [ ] Add assertions that list/create/update queries read role via joined `ur.role AS role`.
- [ ] Run the focused test file and confirm the new expectations fail before implementation.

### Task 3: Add the normalization migration

**Files:**
- Create: `db/migrations/20260531_normalize_user_roles.sql`

- [ ] Create `public.user_role`, seed the three roles, backfill `users.user_role_id`, and remove the legacy `users.role` column.
- [ ] Include a guard that raises an error if any user cannot be mapped.

### Task 4: Refactor user/auth SQL reads and writes

**Files:**
- Modify: `src/lib/users.ts`
- Modify: `src/lib/user-management.ts`
- Modify: `src/auth.ts`

- [ ] Update auth user loading to join `public.user_role`.
- [ ] Update list/create/update SQL to persist `user_role_id` through role-name lookup subqueries and return role text through joins.
- [ ] Keep exported TypeScript role shapes unchanged for callers.

### Task 5: Update app-level types and callers

**Files:**
- Modify: `src/lib/validation/schemas.ts`
- Modify: `src/types/next-auth.d.ts`
- Modify: `src/app/api/users/route.ts`
- Modify: `src/app/api/users/[id]/route.ts`
- Modify: `src/app/admin/users/users-admin-client.tsx`

- [ ] Keep the role API contract as `Admin | Manager | User`.
- [ ] Update any type assumptions or client-side sorting/filtering code only if the query shape changes.

### Task 6: Verify focused behavior

**Files:**
- Test: `tests/user-management.test.mjs`
- Test: any additional touched test files

- [ ] Run focused tests covering the refactored role persistence path.
- [ ] Review the diff for any leftover `public.users.role` SQL references.
