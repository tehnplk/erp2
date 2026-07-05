DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'seller'
      AND column_name = 'catagory_code_sale'
  )
  AND NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'seller'
      AND column_name = 'category_code_sale'
  ) THEN
    ALTER TABLE public.seller RENAME COLUMN catagory_code_sale TO category_code_sale;
  END IF;
END $$;

ALTER TABLE public.seller
  ADD COLUMN IF NOT EXISTS category_code_sale text[] DEFAULT ARRAY[]::text[];

UPDATE public.seller
SET category_code_sale = ARRAY[]::text[]
WHERE category_code_sale IS NULL;

ALTER TABLE public.seller
  ALTER COLUMN category_code_sale SET DEFAULT ARRAY[]::text[],
  ALTER COLUMN category_code_sale SET NOT NULL;
