CREATE TABLE IF NOT EXISTS public.user_role (
  id BIGSERIAL PRIMARY KEY,
  role TEXT NOT NULL UNIQUE,
  is_active BOOLEAN NOT NULL DEFAULT true,
  CONSTRAINT user_role_role_check CHECK (role IN ('Admin', 'Manager', 'User'))
);

CREATE INDEX IF NOT EXISTS idx_user_role_is_active ON public.user_role(is_active);

INSERT INTO public.user_role (role, is_active)
VALUES
  ('Admin', true),
  ('Manager', true),
  ('User', true)
ON CONFLICT (role) DO UPDATE
SET is_active = EXCLUDED.is_active;

ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS user_role_id BIGINT;

UPDATE public.users u
SET user_role_id = ur.id
FROM public.user_role ur
WHERE ur.role = u.role
  AND u.user_role_id IS NULL;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM public.users
    WHERE user_role_id IS NULL
  ) THEN
    RAISE EXCEPTION 'Failed to backfill public.users.user_role_id for one or more rows';
  END IF;
END;
$$;

ALTER TABLE public.users
ALTER COLUMN user_role_id SET NOT NULL;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'users_user_role_id_fkey'
      AND conrelid = 'public.users'::regclass
  ) THEN
    ALTER TABLE public.users
    ADD CONSTRAINT users_user_role_id_fkey
    FOREIGN KEY (user_role_id) REFERENCES public.user_role(id);
  END IF;
END;
$$;

CREATE INDEX IF NOT EXISTS idx_users_user_role_id ON public.users(user_role_id);

DROP INDEX IF EXISTS idx_users_role;

ALTER TABLE public.users
DROP CONSTRAINT IF EXISTS users_role_check;

ALTER TABLE public.users
DROP COLUMN IF EXISTS role;
