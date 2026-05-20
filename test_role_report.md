# Role Test Report

Generated: 2026-05-20 11:35 ICT
Target: `http://localhost:3000`
Requirement source: `docs/detail_improve.md`

## Result

PASS

The old view-only role has been removed. View-only access is now handled by anonymous, unauthenticated visitors. Authenticated department accounts use role `User`.

| Check | Result |
| --- | ---: |
| Unit auth/user tests | 12 / 12 passed |
| TypeScript check | Passed |
| Live Playwright CLI login: `0001` | Passed |
| Live Playwright CLI login: `admin` | Passed |
| Admin user-management page | Passed |
| Legacy view-only role rows in DB | 0 |
| Legacy role references in active source/tests/db/docs | 0 |

## Current Users

All listed users use password `112233`.

| User type | Username | Role | Department owner |
| --- | --- | --- | --- |
| Admin | `admin` | `Admin` | `false` |
| Manager | `manager` | `Manager` | `false` |
| Department users | `0001` through `0047` | `User` | `true` |

DB role counts verified with `db-cli`:

| Role | Department owner | Count |
| --- | --- | ---: |
| Admin | false | 1 |
| Manager | false | 1 |
| User | true | 47 |

## Access Model

| Profile | Expected access | Result |
| --- | --- | --- |
| Anonymous | View only for documented modules; create, edit, delete blocked | Passed by unit tests |
| User | View only by base role | Passed by unit tests |
| Department owner | User base access plus owner permissions on usage plans, purchase plans, purchase approvals, and inventory stock | Passed by unit tests |
| Manager | View, create, and edit; delete blocked | Passed by unit tests |
| Admin | View, create, edit, and delete | Passed by unit tests |

## Playwright CLI Checks

| Check | Evidence |
| --- | --- |
| `0001 / 112233` login | Redirected to `/`; navbar showed only department name; dropdown showed username `0001`, department, and role `User` |
| `admin / 112233` login | Opened `/users`; page showed 49 active users and 1 admin |
| Add-user modal | Thai labels shown; role dropdown options were `ผู้ใช้งาน`, `ผู้จัดการ`, `ผู้ดูแลระบบ`; no legacy view-only role option |

## Commands

```powershell
npx tsc --noEmit
node --test tests/access-control.test.mjs tests/password.test.mjs tests/user-management.test.mjs
rg -n "<legacy role pattern>" src tests db docs
db-cli --exec "<role-count and legacy-role-count queries>"
playwright-cli open http://localhost:3000/login
```
