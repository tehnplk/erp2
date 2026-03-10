DROP TABLE IF EXISTS tmp_budget_check;
CREATE TEMP TABLE tmp_budget_check (
    schema_name text,
    table_name text,
    column_name text,
    empty_count bigint
);

DO $$
DECLARE
    rec record;
BEGIN
    FOR rec IN
        SELECT table_schema, table_name, column_name
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND column_name ILIKE '%budget%'
    LOOP
        EXECUTE format(
            'INSERT INTO tmp_budget_check(schema_name, table_name, column_name, empty_count)
             SELECT %L, %L, %L, COUNT(*)
             FROM %I.%I
             WHERE %I IS NULL OR btrim(%I::text) = ''''' ,
            rec.table_schema, rec.table_name, rec.column_name,
            rec.table_schema, rec.table_name,
            rec.column_name, rec.column_name
        );
    END LOOP;
END $$;

SELECT schema_name, table_name, column_name, empty_count
FROM tmp_budget_check
WHERE empty_count > 0
ORDER BY table_name, column_name;
