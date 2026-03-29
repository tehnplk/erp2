DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'sys_setting'
      AND column_name = 'note'
  ) THEN
    ALTER TABLE public.sys_setting
      ADD COLUMN note text;
  END IF;
END $$;

UPDATE public.sys_setting
SET note = convert_from(decode('e0b895e0b8b1e0b989e0b887e0b884e0b988e0b8b2e0b89be0b8b5e0b887e0b89ae0b89be0b8a3e0b8b0e0b8a1e0b8b2e0b893', 'hex'), 'UTF8')
WHERE sys_name = 'budget_year';
