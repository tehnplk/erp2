# Schema Sync Guide

Use this guide whenever you change database structure and need remote to match local.

## Principle

- `sql/` is the source of truth for schema changes.
- Every schema change must be saved as a dated SQL file in `sql/`.
- Do not edit the remote database manually unless it is an emergency fix that is immediately converted into a migration file.

## Recommended Flow

1. Create or update a migration file in `sql/`.
2. Apply it locally first.
3. Verify the app still works locally.
4. Commit the migration file.
5. `git push` from local.
6. On the remote host, `git pull`.
7. Apply the same migration file on remote.
8. Verify the target tables, constraints, indexes, views, and permissions.

## Local Apply

For local Supabase/Postgres:

```powershell
Get-Content -Raw sql\20260329_example_migration.sql | docker exec -i supabase_db_erp psql -U postgres postgres
```

## Remote Apply

Use the remote host after the local commit has been pushed:

```bash
cd /www/wwwroot/erp2
git pull
bun install
db-cli --exec "$(cat sql/20260329_example_migration.sql)"
```

If the remote script already handles the migration, prefer that script so the process stays consistent.

## Verification

After applying the migration, confirm both sides match:

```sql
SELECT conname, pg_get_constraintdef(c.oid)
FROM pg_constraint c
JOIN pg_class t ON c.conrelid = t.oid
JOIN pg_namespace n ON n.oid = t.relnamespace
WHERE n.nspname = 'public' AND t.relname = 'sys_setting';
```

Useful checks:

- `\d public.<table_name>` for structure
- `SELECT * FROM information_schema.columns WHERE table_schema = 'public' AND table_name = '<table_name>';`
- `SELECT * FROM pg_indexes WHERE schemaname = 'public' AND tablename = '<table_name>';`

## Naming

- Prefix filenames with `YYYYMMDD`.
- Keep names descriptive.
- One migration file should represent one schema change or one tightly related set of changes.

## Rollback

If remote apply fails:

1. Stop and inspect the error.
2. Fix the migration file in git.
3. Commit the fix.
4. Push again.
5. Pull and re-run the migration on remote.

## Notes

- The app should read schema from the current database state, not from assumed local edits.
- If local and remote drift, the migration file wins.
