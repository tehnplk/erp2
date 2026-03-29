DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint c
    JOIN pg_class t ON c.conrelid = t.oid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname = 'public'
      AND t.relname = 'sys_setting'
      AND c.conname = 'sys_setting_sys_name_key'
  ) THEN
    ALTER TABLE public.sys_setting
      ADD CONSTRAINT sys_setting_sys_name_key UNIQUE (sys_name);
  END IF;
END $$;
