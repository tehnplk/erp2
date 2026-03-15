--
-- PostgreSQL database dump
--

\restrict I1HZ2pG5zIu4xoCtZQe6FbJpRtBUCrPs5dyJ9oXd3ok3HpGd90aesI8PIYV7rnd

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO postgres;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: set_purchase_approval_budget_year(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_purchase_approval_budget_year() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.doc_date IS NULL THEN
    NEW.budget_year := NULL;
  ELSIF EXTRACT(MONTH FROM NEW.doc_date) >= 10 THEN
    NEW.budget_year := EXTRACT(YEAR FROM NEW.doc_date)::int + 544;
  ELSE
    NEW.budget_year := EXTRACT(YEAR FROM NEW.doc_date)::int + 543;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_purchase_approval_budget_year() OWNER TO postgres;

--
-- Name: update_purchase_approval_detail_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_purchase_approval_detail_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  NEW.version = OLD.version + 1;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_purchase_approval_detail_updated_at() OWNER TO postgres;

--
-- Name: update_purchase_approval_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_purchase_approval_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  NEW.version = OLD.version + 1;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_purchase_approval_updated_at() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0,
    broadcast_adapter character varying(255) DEFAULT 'gen_rpc'::character varying,
    max_presence_events_per_second integer DEFAULT 1000,
    max_payload_size_in_kb integer DEFAULT 3000,
    max_client_presence_events_per_window integer,
    client_presence_window_ms integer,
    presence_enabled boolean DEFAULT false NOT NULL,
    CONSTRAINT jwt_secret_or_jwt_jwks_required CHECK (((jwt_secret IS NOT NULL) OR (jwt_jwks IS NOT NULL)))
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id integer NOT NULL,
    category text NOT NULL,
    type text NOT NULL,
    subtype text,
    category_code text
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: Category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Category_id_seq" OWNER TO postgres;

--
-- Name: Category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Category_id_seq" OWNED BY public.category.id;


--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name text NOT NULL,
    department_code character varying(4)
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: Department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Department_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Department_id_seq" OWNER TO postgres;

--
-- Name: Department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Department_id_seq" OWNED BY public.department.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id integer NOT NULL,
    code text NOT NULL,
    category text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    subtype text NOT NULL,
    unit text NOT NULL,
    cost_price numeric(10,2),
    sell_price numeric(10,2),
    stock_balance integer,
    stock_value numeric(10,2),
    seller_code text,
    image text,
    flag_activate boolean DEFAULT true NOT NULL,
    admin_note text
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: Product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Product_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Product_id_seq" OWNER TO postgres;

--
-- Name: Product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Product_id_seq" OWNED BY public.product.id;


--
-- Name: purchase_approval_inventory_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_approval_inventory_link (
    id integer NOT NULL,
    purchase_approval_id integer NOT NULL,
    inventory_receipt_status text DEFAULT 'PENDING'::text NOT NULL,
    received_qty integer DEFAULT 0 NOT NULL,
    last_receipt_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    purchase_approval_detail_id integer NOT NULL,
    CONSTRAINT "PurchaseApprovalInventoryLink_receivedQty_non_negative" CHECK ((received_qty >= 0))
);


ALTER TABLE public.purchase_approval_inventory_link OWNER TO postgres;

--
-- Name: TABLE purchase_approval_inventory_link; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.purchase_approval_inventory_link IS 'Link table between purchase approval details and inventory receipts';


--
-- Name: COLUMN purchase_approval_inventory_link.purchase_approval_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_approval_inventory_link.purchase_approval_id IS 'Purchase approval header ID (legacy, kept for compatibility)';


--
-- Name: COLUMN purchase_approval_inventory_link.purchase_approval_detail_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_approval_inventory_link.purchase_approval_detail_id IS 'Purchase approval detail ID (primary reference)';


--
-- Name: PurchaseApprovalInventoryLink_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PurchaseApprovalInventoryLink_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PurchaseApprovalInventoryLink_id_seq" OWNER TO postgres;

--
-- Name: PurchaseApprovalInventoryLink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PurchaseApprovalInventoryLink_id_seq" OWNED BY public.purchase_approval_inventory_link.id;


--
-- Name: purchase_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_plan (
    id integer NOT NULL,
    usage_plan_id integer NOT NULL,
    inventory_qty integer DEFAULT 0,
    inventory_value numeric(10,2) DEFAULT 0,
    purchase_qty integer DEFAULT 0,
    purchase_value numeric(10,2) DEFAULT 0
);


ALTER TABLE public.purchase_plan OWNER TO postgres;

--
-- Name: PurchasePlan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PurchasePlan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PurchasePlan_id_seq" OWNER TO postgres;

--
-- Name: PurchasePlan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PurchasePlan_id_seq" OWNED BY public.purchase_plan.id;


--
-- Name: seller; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seller (
    id integer NOT NULL,
    code text NOT NULL,
    prefix text,
    name text NOT NULL,
    business text,
    address text,
    phone text,
    fax text,
    mobile text
);


ALTER TABLE public.seller OWNER TO postgres;

--
-- Name: Seller_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Seller_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Seller_id_seq" OWNER TO postgres;

--
-- Name: Seller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Seller_id_seq" OWNED BY public.seller.id;


--
-- Name: usage_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usage_plan (
    id integer NOT NULL,
    product_code text,
    category text,
    type text,
    subtype text,
    product_name text,
    requested_amount integer,
    unit text,
    price_per_unit numeric(10,2) DEFAULT 0 NOT NULL,
    requesting_dept text,
    approved_quota integer,
    budget_year integer DEFAULT 2569,
    sequence_no integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requesting_dept_code character varying(4),
    CONSTRAINT "Survey_sequence_no_check" CHECK ((sequence_no = ANY (ARRAY[1, 2])))
);


ALTER TABLE public.usage_plan OWNER TO postgres;

--
-- Name: Survey_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Survey_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Survey_id_seq" OWNER TO postgres;

--
-- Name: Survey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Survey_id_seq" OWNED BY public.usage_plan.id;


--
-- Name: inventory_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_adjustment (
    id integer NOT NULL,
    adjustment_no text NOT NULL,
    adjustment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reason text NOT NULL,
    status text DEFAULT 'DRAFT'::text NOT NULL,
    created_by text,
    approved_by text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.inventory_adjustment OWNER TO postgres;

--
-- Name: inventory_adjustment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_adjustment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_adjustment_id_seq OWNER TO postgres;

--
-- Name: inventory_adjustment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_adjustment_id_seq OWNED BY public.inventory_adjustment.id;


--
-- Name: inventory_adjustment_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_adjustment_item (
    id integer NOT NULL,
    adjustment_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    qty_diff integer NOT NULL,
    unit_cost numeric(18,2) DEFAULT 0 NOT NULL,
    note text
);


ALTER TABLE public.inventory_adjustment_item OWNER TO postgres;

--
-- Name: inventory_adjustment_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_adjustment_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_adjustment_item_id_seq OWNER TO postgres;

--
-- Name: inventory_adjustment_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_adjustment_item_id_seq OWNED BY public.inventory_adjustment_item.id;


--
-- Name: inventory_balance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_balance (
    id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    on_hand_qty integer DEFAULT 0 NOT NULL,
    reserved_qty integer DEFAULT 0 NOT NULL,
    available_qty integer DEFAULT 0 NOT NULL,
    avg_cost numeric(18,2) DEFAULT 0 NOT NULL,
    last_movement_at timestamp without time zone,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT inventory_balance_non_negative CHECK (((on_hand_qty >= 0) AND (reserved_qty >= 0) AND (available_qty >= 0)))
);


ALTER TABLE public.inventory_balance OWNER TO postgres;

--
-- Name: inventory_balance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_balance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_balance_id_seq OWNER TO postgres;

--
-- Name: inventory_balance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_balance_id_seq OWNED BY public.inventory_balance.id;


--
-- Name: inventory_issue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_issue (
    id integer NOT NULL,
    issue_no text NOT NULL,
    issue_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requisition_id integer NOT NULL,
    requesting_department text NOT NULL,
    status text DEFAULT 'POSTED'::text NOT NULL,
    issued_by text,
    approved_by text,
    note text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requesting_department_code character varying(4)
);


ALTER TABLE public.inventory_issue OWNER TO postgres;

--
-- Name: inventory_issue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_issue_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_issue_id_seq OWNER TO postgres;

--
-- Name: inventory_issue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_issue_id_seq OWNED BY public.inventory_issue.id;


--
-- Name: inventory_issue_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_issue_item (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    requisition_item_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    issued_qty integer NOT NULL,
    unit_cost numeric(18,2) DEFAULT 0 NOT NULL,
    total_cost numeric(18,2) DEFAULT 0 NOT NULL,
    CONSTRAINT inventory_issue_item_issued_qty_positive CHECK ((issued_qty > 0))
);


ALTER TABLE public.inventory_issue_item OWNER TO postgres;

--
-- Name: inventory_issue_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_issue_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_issue_item_id_seq OWNER TO postgres;

--
-- Name: inventory_issue_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_issue_item_id_seq OWNED BY public.inventory_issue_item.id;


--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_item (
    id integer NOT NULL,
    product_code text NOT NULL,
    product_name text NOT NULL,
    category text,
    product_type text,
    product_subtype text,
    unit text,
    warehouse_id integer NOT NULL,
    location_id integer,
    lot_no text,
    expiry_date date,
    standard_cost numeric(18,2) DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.inventory_item OWNER TO postgres;

--
-- Name: inventory_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_item_id_seq OWNER TO postgres;

--
-- Name: inventory_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_item_id_seq OWNED BY public.inventory_item.id;


--
-- Name: inventory_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_location (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    location_code text NOT NULL,
    location_name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.inventory_location OWNER TO postgres;

--
-- Name: inventory_location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_location_id_seq OWNER TO postgres;

--
-- Name: inventory_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_location_id_seq OWNED BY public.inventory_location.id;


--
-- Name: inventory_movement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_movement (
    id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    movement_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    movement_type text NOT NULL,
    qty_in integer DEFAULT 0 NOT NULL,
    qty_out integer DEFAULT 0 NOT NULL,
    unit_cost numeric(18,2) DEFAULT 0 NOT NULL,
    total_cost numeric(18,2) DEFAULT 0 NOT NULL,
    balance_qty_after integer DEFAULT 0 NOT NULL,
    balance_value_after numeric(18,2) DEFAULT 0 NOT NULL,
    reference_type text,
    reference_id integer,
    reference_no text,
    source_department text,
    target_department text,
    note text,
    created_by text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT inventory_movement_qty_valid CHECK (((qty_in >= 0) AND (qty_out >= 0)))
);


ALTER TABLE public.inventory_movement OWNER TO postgres;

--
-- Name: inventory_movement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_movement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_movement_id_seq OWNER TO postgres;

--
-- Name: inventory_movement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_movement_id_seq OWNED BY public.inventory_movement.id;


--
-- Name: inventory_period; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_period (
    id integer NOT NULL,
    period_year integer NOT NULL,
    period_month integer NOT NULL,
    status text DEFAULT 'OPEN'::text NOT NULL,
    closed_at timestamp without time zone,
    closed_by text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT inventory_period_month_valid CHECK (((period_month >= 1) AND (period_month <= 12)))
);


ALTER TABLE public.inventory_period OWNER TO postgres;

--
-- Name: inventory_period_balance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_period_balance (
    id integer NOT NULL,
    period_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    opening_qty integer DEFAULT 0 NOT NULL,
    opening_value numeric(18,2) DEFAULT 0 NOT NULL,
    closing_qty integer DEFAULT 0 NOT NULL,
    closing_value numeric(18,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.inventory_period_balance OWNER TO postgres;

--
-- Name: inventory_period_balance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_period_balance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_period_balance_id_seq OWNER TO postgres;

--
-- Name: inventory_period_balance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_period_balance_id_seq OWNED BY public.inventory_period_balance.id;


--
-- Name: inventory_period_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_period_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_period_id_seq OWNER TO postgres;

--
-- Name: inventory_period_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_period_id_seq OWNED BY public.inventory_period.id;


--
-- Name: inventory_receipt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_receipt (
    id integer NOT NULL,
    receipt_no text NOT NULL,
    receipt_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    receipt_type text NOT NULL,
    status text DEFAULT 'POSTED'::text NOT NULL,
    vendor_name text,
    source_reference_type text,
    source_reference_id integer,
    source_reference_no text,
    note text,
    created_by text,
    approved_by text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.inventory_receipt OWNER TO postgres;

--
-- Name: inventory_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_receipt_id_seq OWNER TO postgres;

--
-- Name: inventory_receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_receipt_id_seq OWNED BY public.inventory_receipt.id;


--
-- Name: inventory_receipt_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_receipt_item (
    id integer NOT NULL,
    receipt_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    purchase_approval_id integer,
    qty integer NOT NULL,
    unit_cost numeric(18,2) DEFAULT 0 NOT NULL,
    total_cost numeric(18,2) DEFAULT 0 NOT NULL,
    lot_no text,
    expiry_date date,
    CONSTRAINT inventory_receipt_item_qty_positive CHECK ((qty > 0))
);


ALTER TABLE public.inventory_receipt_item OWNER TO postgres;

--
-- Name: inventory_receipt_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_receipt_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_receipt_item_id_seq OWNER TO postgres;

--
-- Name: inventory_receipt_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_receipt_item_id_seq OWNED BY public.inventory_receipt_item.id;


--
-- Name: inventory_requisition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_requisition (
    id integer NOT NULL,
    requisition_no text NOT NULL,
    request_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requesting_department text NOT NULL,
    status text DEFAULT 'DRAFT'::text NOT NULL,
    requested_by text,
    approved_by text,
    approved_at timestamp without time zone,
    issued_by text,
    issued_at timestamp without time zone,
    note text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    requesting_department_code character varying(4)
);


ALTER TABLE public.inventory_requisition OWNER TO postgres;

--
-- Name: inventory_requisition_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_requisition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_requisition_id_seq OWNER TO postgres;

--
-- Name: inventory_requisition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_requisition_id_seq OWNED BY public.inventory_requisition.id;


--
-- Name: inventory_requisition_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_requisition_item (
    id integer NOT NULL,
    requisition_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    requested_qty integer NOT NULL,
    approved_qty integer DEFAULT 0 NOT NULL,
    issued_qty integer DEFAULT 0 NOT NULL,
    unit_cost_at_issue numeric(18,2) DEFAULT 0 NOT NULL,
    line_status text DEFAULT 'DRAFT'::text NOT NULL,
    note text,
    CONSTRAINT inventory_requisition_item_qty_valid CHECK (((requested_qty > 0) AND (approved_qty >= 0) AND (issued_qty >= 0)))
);


ALTER TABLE public.inventory_requisition_item OWNER TO postgres;

--
-- Name: inventory_requisition_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_requisition_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_requisition_item_id_seq OWNER TO postgres;

--
-- Name: inventory_requisition_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_requisition_item_id_seq OWNED BY public.inventory_requisition_item.id;


--
-- Name: inventory_warehouse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_warehouse (
    id integer NOT NULL,
    warehouse_code text NOT NULL,
    warehouse_name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.inventory_warehouse OWNER TO postgres;

--
-- Name: inventory_warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_warehouse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_warehouse_id_seq OWNER TO postgres;

--
-- Name: inventory_warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_warehouse_id_seq OWNED BY public.inventory_warehouse.id;


--
-- Name: purchase_approval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_approval (
    id integer NOT NULL,
    approve_code text NOT NULL,
    doc_no text DEFAULT 'พล. ๐๗๓๓.๓๐๑/พิเศษ'::text NOT NULL,
    doc_date date DEFAULT CURRENT_DATE NOT NULL,
    status text DEFAULT 'DRAFT'::text NOT NULL,
    total_amount numeric(15,2) DEFAULT 0,
    total_items integer DEFAULT 0,
    prepared_by text,
    approved_by text,
    approved_at timestamp without time zone,
    notes text,
    created_by text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    doc_seq integer,
    pending_note text,
    budget_year integer,
    CONSTRAINT purchase_approval_status_check CHECK ((status = ANY (ARRAY['DRAFT'::text, 'PENDING'::text, 'APPROVED'::text, 'REJECTED'::text, 'CANCELLED'::text])))
);


ALTER TABLE public.purchase_approval OWNER TO postgres;

--
-- Name: TABLE purchase_approval; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.purchase_approval IS 'Purchase approval header table with enhanced logging and status tracking';


--
-- Name: purchase_approval_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_approval_approval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_approval_approval_id_seq OWNER TO postgres;

--
-- Name: purchase_approval_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_approval_backup (
    id integer,
    approval_id text,
    department text,
    record_number text,
    request_date text,
    product_name text,
    product_code text,
    category text,
    product_type text,
    product_subtype text,
    requested_quantity integer,
    unit text,
    price_per_unit numeric(10,2),
    total_value numeric(10,2),
    over_plan_case text,
    requester text,
    approver text,
    budget_year integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    department_code character varying(4)
);


ALTER TABLE public.purchase_approval_backup OWNER TO postgres;

--
-- Name: purchase_approval_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_approval_detail (
    id integer NOT NULL,
    purchase_approval_id integer NOT NULL,
    purchase_plan_id integer NOT NULL,
    line_number integer NOT NULL,
    status text DEFAULT 'PENDING'::text NOT NULL,
    approved_quantity integer DEFAULT 0,
    approved_amount numeric(15,2) DEFAULT 0,
    remarks text,
    created_by text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    CONSTRAINT purchase_approval_detail_status_check CHECK ((status = ANY (ARRAY['PENDING'::text, 'APPROVED'::text, 'REJECTED'::text, 'MODIFIED'::text])))
);


ALTER TABLE public.purchase_approval_detail OWNER TO postgres;

--
-- Name: TABLE purchase_approval_detail; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.purchase_approval_detail IS 'Purchase approval detail table with 1:1 relationship to purchase_plan and enhanced logging';


--
-- Name: purchase_approval_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_approval_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_approval_detail_id_seq OWNER TO postgres;

--
-- Name: purchase_approval_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_approval_detail_id_seq OWNED BY public.purchase_approval_detail.id;


--
-- Name: purchase_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_approval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_approval_id_seq OWNER TO postgres;

--
-- Name: purchase_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_approval_id_seq OWNED BY public.purchase_approval.id;


--
-- Name: purchase_approval_inventory_link_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_approval_inventory_link_backup (
    id integer,
    purchase_approval_id integer,
    inventory_receipt_status text,
    received_qty integer,
    last_receipt_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.purchase_approval_inventory_link_backup OWNER TO postgres;

--
-- Name: test_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_data (
    id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    sex text NOT NULL,
    birth date NOT NULL,
    age integer NOT NULL
);


ALTER TABLE public.test_data OWNER TO postgres;

--
-- Name: test_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.test_data_id_seq OWNER TO postgres;

--
-- Name: test_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_data_id_seq OWNED BY public.test_data.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_03_12; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_12 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_12 OWNER TO supabase_admin;

--
-- Name: messages_2026_03_13; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_13 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_13 OWNER TO supabase_admin;

--
-- Name: messages_2026_03_14; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_14 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_14 OWNER TO supabase_admin;

--
-- Name: messages_2026_03_15; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_15 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_15 OWNER TO supabase_admin;

--
-- Name: messages_2026_03_16; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_16 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_16 OWNER TO supabase_admin;

--
-- Name: messages_2026_03_17; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_17 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_17 OWNER TO supabase_admin;

--
-- Name: messages_2026_03_18; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_18 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_18 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: iceberg_namespaces; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_namespaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    catalog_id uuid NOT NULL
);


ALTER TABLE storage.iceberg_namespaces OWNER TO supabase_storage_admin;

--
-- Name: iceberg_tables; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace_id uuid NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    remote_table_id text,
    shard_key text,
    shard_id text,
    catalog_id uuid NOT NULL
);


ALTER TABLE storage.iceberg_tables OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: messages_2026_03_12; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_12 FOR VALUES FROM ('2026-03-12 00:00:00') TO ('2026-03-13 00:00:00');


--
-- Name: messages_2026_03_13; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_13 FOR VALUES FROM ('2026-03-13 00:00:00') TO ('2026-03-14 00:00:00');


--
-- Name: messages_2026_03_14; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_14 FOR VALUES FROM ('2026-03-14 00:00:00') TO ('2026-03-15 00:00:00');


--
-- Name: messages_2026_03_15; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_15 FOR VALUES FROM ('2026-03-15 00:00:00') TO ('2026-03-16 00:00:00');


--
-- Name: messages_2026_03_16; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_16 FOR VALUES FROM ('2026-03-16 00:00:00') TO ('2026-03-17 00:00:00');


--
-- Name: messages_2026_03_17; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_17 FOR VALUES FROM ('2026-03-17 00:00:00') TO ('2026-03-18 00:00:00');


--
-- Name: messages_2026_03_18; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_18 FOR VALUES FROM ('2026-03-18 00:00:00') TO ('2026-03-19 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public."Category_id_seq"'::regclass);


--
-- Name: department id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public."Department_id_seq"'::regclass);


--
-- Name: inventory_adjustment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment ALTER COLUMN id SET DEFAULT nextval('public.inventory_adjustment_id_seq'::regclass);


--
-- Name: inventory_adjustment_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_adjustment_item_id_seq'::regclass);


--
-- Name: inventory_balance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_balance ALTER COLUMN id SET DEFAULT nextval('public.inventory_balance_id_seq'::regclass);


--
-- Name: inventory_issue id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue ALTER COLUMN id SET DEFAULT nextval('public.inventory_issue_id_seq'::regclass);


--
-- Name: inventory_issue_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_issue_item_id_seq'::regclass);


--
-- Name: inventory_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_item_id_seq'::regclass);


--
-- Name: inventory_location id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_location ALTER COLUMN id SET DEFAULT nextval('public.inventory_location_id_seq'::regclass);


--
-- Name: inventory_movement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movement ALTER COLUMN id SET DEFAULT nextval('public.inventory_movement_id_seq'::regclass);


--
-- Name: inventory_period id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_period ALTER COLUMN id SET DEFAULT nextval('public.inventory_period_id_seq'::regclass);


--
-- Name: inventory_period_balance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_period_balance ALTER COLUMN id SET DEFAULT nextval('public.inventory_period_balance_id_seq'::regclass);


--
-- Name: inventory_receipt id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_receipt ALTER COLUMN id SET DEFAULT nextval('public.inventory_receipt_id_seq'::regclass);


--
-- Name: inventory_receipt_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_receipt_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_receipt_item_id_seq'::regclass);


--
-- Name: inventory_requisition id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_requisition ALTER COLUMN id SET DEFAULT nextval('public.inventory_requisition_id_seq'::regclass);


--
-- Name: inventory_requisition_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_requisition_item ALTER COLUMN id SET DEFAULT nextval('public.inventory_requisition_item_id_seq'::regclass);


--
-- Name: inventory_warehouse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_warehouse ALTER COLUMN id SET DEFAULT nextval('public.inventory_warehouse_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public."Product_id_seq"'::regclass);


--
-- Name: purchase_approval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval ALTER COLUMN id SET DEFAULT nextval('public.purchase_approval_id_seq'::regclass);


--
-- Name: purchase_approval_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_detail ALTER COLUMN id SET DEFAULT nextval('public.purchase_approval_detail_id_seq'::regclass);


--
-- Name: purchase_approval_inventory_link id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_inventory_link ALTER COLUMN id SET DEFAULT nextval('public."PurchaseApprovalInventoryLink_id_seq"'::regclass);


--
-- Name: purchase_plan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_plan ALTER COLUMN id SET DEFAULT nextval('public."PurchasePlan_id_seq"'::regclass);


--
-- Name: seller id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller ALTER COLUMN id SET DEFAULT nextval('public."Seller_id_seq"'::regclass);


--
-- Name: test_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_data ALTER COLUMN id SET DEFAULT nextval('public.test_data_id_seq'::regclass);


--
-- Name: usage_plan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usage_plan ALTER COLUMN id SET DEFAULT nextval('public."Survey_id_seq"'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
59384680-3e9a-47ce-8662-f6516b52009c	postgres_cdc_rls	{"region": "us-east-1", "db_host": "ZP148Qnanu3FH115eFru4w==", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "sWBpZNdjggEPTQVlI52Zfw==", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2026-03-15 06:00:22	2026-03-15 06:00:22
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2026-03-13 00:36:29
20220329161857	2026-03-13 00:36:29
20220410212326	2026-03-13 00:36:29
20220506102948	2026-03-13 00:36:29
20220527210857	2026-03-13 00:36:29
20220815211129	2026-03-13 00:36:29
20220815215024	2026-03-13 00:36:29
20220818141501	2026-03-13 00:36:29
20221018173709	2026-03-13 00:36:29
20221102172703	2026-03-13 00:36:29
20221223010058	2026-03-13 00:36:29
20230110180046	2026-03-13 00:36:29
20230810220907	2026-03-13 00:36:29
20230810220924	2026-03-13 00:36:29
20231024094642	2026-03-13 00:36:29
20240306114423	2026-03-13 00:36:29
20240418082835	2026-03-13 00:36:29
20240625211759	2026-03-13 00:36:29
20240704172020	2026-03-13 00:36:29
20240902173232	2026-03-13 00:36:29
20241106103258	2026-03-13 00:36:29
20250424203323	2026-03-13 00:36:29
20250613072131	2026-03-13 00:36:29
20250711044927	2026-03-13 00:36:29
20250811121559	2026-03-13 00:36:29
20250926223044	2026-03-13 00:36:29
20251204170944	2026-03-13 00:36:29
20251218000543	2026-03-13 00:36:29
20260209232800	2026-03-13 00:36:29
20260304000000	2026-03-13 00:36:29
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only, migrations_ran, broadcast_adapter, max_presence_events_per_second, max_payload_size_in_kb, max_client_presence_events_per_window, client_presence_window_ms, presence_enabled) FROM stdin;
7deab3b0-2b9b-4c83-9fbc-1501877f357d	realtime-dev	realtime-dev	iNjicxc4+llvc9wovDvqymwfnj9teWMlyOIbJ8Fh6j2WNU8CIJ2ZgjR6MUIKqSmeDmvpsKLsZ9jgXJmQPpwL8w==	200	2026-03-15 06:00:22	2026-03-15 06:00:22	100	postgres_cdc_rls	100000	100	100	f	{"keys": [{"x": "M5Sjqn5zwC9Kl1zVfUUGvv9boQjCGd45G8sdopBExB4", "y": "P6IXMvA2WYXSHSOMTBH2jsw_9rrzGy89FjPf6oOsIxQ", "alg": "ES256", "crv": "P-256", "ext": true, "kid": "b81269f1-21d8-4f2e-b719-c2240a840d90", "kty": "EC", "use": "sig", "key_ops": ["verify"]}, {"k": "c3VwZXItc2VjcmV0LWp3dC10b2tlbi13aXRoLWF0LWxlYXN0LTMyLWNoYXJhY3RlcnMtbG9uZw", "kty": "oct"}]}	f	f	68	gen_rpc	1000	3000	\N	\N	f
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, category, type, subtype, category_code) FROM stdin;
185	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	230
186	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	230
187	วัสดุใช้ไป	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง	230
188	วัสดุใช้ไป	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง-งบหน่วยงาน	230
189	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	230
190	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า-งบหน่วยงาน	230
191	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	230
192	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่-งบหน่วยงาน	230
193	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	230
194	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์-งบหน่วยงาน	230
195	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	230
196	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	230
197	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	230
198	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง-งบหน่วยงาน	230
199	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	230
200	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง-งบหน่วยงาน	230
201	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค	230
202	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค-งบหน่วยงาน	230
203	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	230
3	งบค่าเสื่อม	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบระดับหน่วยบริการ	003
134	วัสดุทันตกรรม	วัสดุจัดฟัน	วัสดุจัดฟัน-ประมูล	002
114	ยา	ยาในบัญชียาหลัก	ED	012
176	ค่าใช้สอย	เงินชดเชยค่างานสิ่งก่อสร้าง	เงินชดเชยค่างานสิ่งก่อสร้าง	009
177	ค่าใช้สอย	ค่าประชาสัมพันธ์	ค่าประชาสัมพันธ์	009
178	ค่าใช้สอย	ค่าชดใช้ค่าเสียหาย	ค่าชดใช้ค่าเสียหาย	009
179	ค่าใช้สอย	ค่าใช้สอยอื่นๆ	ค่าใช้สอยอื่นๆ	009
180	ค่าสาธารณูปโภค	ค่าไฟฟ้า	ค่าไฟฟ้า	008
181	ค่าสาธารณูปโภค	ค่าน้ำประปาและน้ำบาดาล	ค่าน้ำประปาและน้ำบาดาล	008
182	ค่าสาธารณูปโภค	ค่าโทรศัพท์	ค่าโทรศัพท์	008
183	ค่าสาธารณูปโภค	ค่าบริการสื่อสารและโทรคมนาคม	ค่าบริการสื่อสารและโทรคมนาคม	008
184	ค่าสาธารณูปโภค	ค่าไปรษณีย์และขนส่ง	ค่าไปรษณีย์และขนส่ง	008
209	ค่าใช้จ่ายโครงการ	ค่าครุภัณฑ์	ค่าครุภัณฑ์	006
210	ค่าใช้จ่ายโครงการ	สิ่งก่อสร้าง	สิ่งก่อสร้าง	006
211	ค่าใช้จ่ายโครงการ	ค่าครุภัณฑ์ต่ำกว่าเกณฑ์	ค่าครุภัณฑ์ต่ำกว่าเกณฑ์	006
212	ค่าใช้จ่ายโครงการ	ค่าเบี้ยเลี้ยง	ค่าเบี้ยเลี้ยง	006
213	ค่าใช้จ่ายโครงการ	ค่าตอบแทน	ค่าตอบแทน	006
214	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมอาคารและสิ่งปลูกสร้าง	006
215	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์สำนักงาน	006
216	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์ยานพาหนะและขนส่ง	006
217	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์ไฟฟ้าและวิทยุ	006
218	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์โฆษณาและเผยแพร่	006
219	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์วิทยาศาสตร์และการแพทย์	006
264	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ห้องผ่าตัด	006
265	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ฟื้นฟูและสนับสนุน	006
269	ค่าใช้จ่ายโครงการ	วัสดุทันตกรรม	วัสดุจัดฟัน	006
207	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	230
4	งบค่าเสื่อม	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบระดับเขตสุขภาพ	003
5	งบค่าเสื่อม	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบระดับจังหวัด	003
6	งบค่าเสื่อม	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบระดับหน่วยบริการ	003
7	งบค่าเสื่อม	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบระดับเขตสุขภาพ	003
8	งบค่าเสื่อม	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบระดับจังหวัด	003
9	งบค่าเสื่อม	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบระดับหน่วยบริการ	003
10	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบระดับเขตสุขภาพ	003
11	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบระดับจังหวัด	003
12	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบระดับหน่วยบริการ	003
13	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบระดับเขตสุขภาพ	003
14	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบระดับจังหวัด	003
15	งบค่าเสื่อม	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบระดับหน่วยบริการ	003
16	งบค่าเสื่อม	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบระดับเขตสุขภาพ	003
17	งบค่าเสื่อม	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบระดับจังหวัด	003
18	งบค่าเสื่อม	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบระดับหน่วยบริการ	003
19	งบค่าเสื่อม	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบระดับเขตสุขภาพ	003
20	งบค่าเสื่อม	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบระดับจังหวัด	003
21	งบค่าเสื่อม	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบระดับหน่วยบริการ	003
22	งบค่าเสื่อม	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบระดับเขตสุขภาพ	003
23	งบค่าเสื่อม	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบระดับจังหวัด	003
24	งบค่าเสื่อม	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบระดับหน่วยบริการ	003
25	งบค่าเสื่อม	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบระดับเขตสุขภาพ	003
26	งบค่าเสื่อม	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบระดับจังหวัด	003
27	งบค่าเสื่อม	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบระดับหน่วยบริการ	003
28	งบค่าเสื่อม	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบระดับเขตสุขภาพ	003
29	งบค่าเสื่อม	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบระดับจังหวัด	003
30	งบค่าเสื่อม	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบระดับหน่วยบริการ	003
31	งบค่าเสื่อม	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบระดับเขตสุขภาพ	003
32	งบค่าเสื่อม	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบระดับจังหวัด	003
2	งบค่าเสื่อม	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบระดับจังหวัด	003
33	งบค่าเสื่อม	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบระดับหน่วยบริการ	003
34	งบค่าเสื่อม	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบระดับเขตสุขภาพ	003
35	งบค่าเสื่อม	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบระดับจังหวัด	003
36	งบค่าเสื่อม	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบระดับหน่วยบริการ	003
37	งบค่าเสื่อม	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบระดับเขตสุขภาพ	003
38	งบค่าเสื่อม	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบระดับจังหวัด	003
39	งบค่าเสื่อม	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบระดับหน่วยบริการ	003
40	งบค่าเสื่อม	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบระดับเขตสุขภาพ	003
41	งบค่าเสื่อม	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบระดับจังหวัด	003
42	งบค่าเสื่อม	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบระดับหน่วยบริการ	003
43	งบค่าเสื่อม	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบระดับเขตสุขภาพ	003
44	งบค่าเสื่อม	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบระดับจังหวัด	003
45	งบค่าเสื่อม	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบระดับหน่วยบริการ	003
46	งบค่าเสื่อม	สิ่งก่อสร้าง	สิ่งก่อสร้าง-งบระดับเขตสุขภาพ	003
47	งบค่าเสื่อม	สิ่งก่อสร้าง	สิ่งก่อสร้าง-งบระดับจังหวัด	003
48	งบค่าเสื่อม	สิ่งก่อสร้าง	สิ่งก่อสร้าง-งบระดับหน่วยบริการ	003
49	งบค่าเสื่อม	ค่าเช่าเบ็ดเตล็ด	ค่าเช่าเบ็ดเตล็ด-งบระดับเขตสุขภาพ	003
50	งบค่าเสื่อม	ค่าเช่าเบ็ดเตล็ด	ค่าเช่าเบ็ดเตล็ด-งบระดับจังหวัด	003
51	งบค่าเสื่อม	ค่าเช่าเบ็ดเตล็ด	ค่าเช่าเบ็ดเตล็ด-งบระดับหน่วยบริการ	003
52	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา	005
53	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบหน่วยงาน	005
54	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร	005
55	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบหน่วยงาน	005
56	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์	005
57	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบหน่วยงาน	005
58	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา	005
59	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบหน่วยงาน	005
60	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต	005
61	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบหน่วยงาน	005
62	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย	005
63	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบหน่วยงาน	005
64	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน	005
65	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบหน่วยงาน	005
66	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์	005
67	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบหน่วยงาน	005
68	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว	005
69	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบหน่วยงาน	005
70	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง	005
71	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบหน่วยงาน	005
72	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	005
73	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบหน่วยงาน	005
74	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน	005
75	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบหน่วยงาน	005
76	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่	005
77	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบหน่วยงาน	005
78	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน	005
79	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบหน่วยงาน	005
80	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ	005
81	ครุภัณฑ์และสิ่งก่อสร้าง	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบหน่วยงาน	005
82	ครุภัณฑ์และสิ่งก่อสร้าง	สิ่งก่อสร้าง	สิ่งก่อสร้าง	005
83	ครุภัณฑ์และสิ่งก่อสร้าง	สิ่งก่อสร้าง	สิ่งก่อสร้าง-งบหน่วยงาน	005
84	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา	010
85	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบหน่วยงาน	010
86	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร	010
87	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การเกษตร	ครุภัณฑ์การเกษตร-งบหน่วยงาน	010
88	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์	010
89	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์	ครุภัณฑ์การแพทย์-งบหน่วยงาน	010
90	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา	010
91	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์รักษา	ครุภัณฑ์การแพทย์รักษา-งบหน่วยงาน	010
92	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต	010
93	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์รักษาชีวิต	ครุภัณฑ์การแพทย์รักษาชีวิต-งบหน่วยงาน	010
94	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย	010
95	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์วินิจฉัย	ครุภัณฑ์การแพทย์วินิจฉัย-งบหน่วยงาน	010
96	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน	010
97	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์การแพทย์สนับสนุน	ครุภัณฑ์การแพทย์สนับสนุน-งบหน่วยงาน	010
98	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์	010
99	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์คอมพิวเตอร์	ครุภัณฑ์คอมพิวเตอร์-งบหน่วยงาน	010
100	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว	010
101	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์งานบ้านงานครัว	ครุภัณฑ์งานบ้านงานครัว-งบหน่วยงาน	010
102	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง	010
103	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์ยานพาหนะและขนส่ง	ครุภัณฑ์ยานพาหนะและขนส่ง-งบหน่วยงาน	010
104	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	010
105	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์	ครุภัณฑ์วิทยาศาสตร์และการแพทย์-งบหน่วยงาน	010
106	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน	010
107	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์สำนักงาน	ครุภัณฑ์สำนักงาน-งบหน่วยงาน	010
108	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่	010
109	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์โฆษณาและเผยแพร่	ครุภัณฑ์โฆษณาและเผยแพร่-งบหน่วยงาน	010
110	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน	010
111	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์โรงงาน	ครุภัณฑ์โรงงาน-งบหน่วยงาน	010
112	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ	010
113	ครุภัณฑ์ต่ำกว่าเกณฑ์	ครุภัณฑ์ไฟฟ้าและวิทยุ	ครุภัณฑ์ไฟฟ้าและวิทยุ-งบหน่วยงาน	010
115	ยา	ยานอกบัญชียาหลัก	NED	012
116	ยา	ยานอกแผน	ยานอกแผน	012
117	วัสดุการแพทย์	วัสดุการแพทย์ทั่วไป	วัสดุการแพทย์ทั่วไป	001
118	วัสดุการแพทย์	วัสดุการแพทย์ทั่วไป	วัสดุการแพทย์ทั่วไป-งบหน่วยงาน	001
119	วัสดุการแพทย์	วัสดุการแพทย์สูตินรีเวชกรรม	วัสดุการแพทย์สูตินรีเวชกรรม	001
120	วัสดุการแพทย์	วัสดุการแพทย์สูตินรีเวชกรรม	วัสดุการแพทย์สูตินรีเวชกรรม-งบหน่วยงาน	001
121	วัสดุการแพทย์	วัสดุการแพทย์กุมารเวชกรรม	วัสดุการแพทย์กุมารเวชกรรม	001
122	วัสดุการแพทย์	วัสดุการแพทย์กุมารเวชกรรม	วัสดุการแพทย์กุมารเวชกรรม-งบหน่วยงาน	001
123	วัสดุการแพทย์	วัสดุการแพทย์อายุรกรรม	วัสดุการแพทย์อายุรกรรม	001
124	วัสดุการแพทย์	วัสดุการแพทย์อายุรกรรม	วัสดุการแพทย์อายุรกรรม-งบหน่วยงาน	001
125	วัสดุการแพทย์	วัสดุการแพทย์ศัลยกรรม	วัสดุการแพทย์ศัลยกรรม	001
126	วัสดุการแพทย์	วัสดุการแพทย์ศัลยกรรม	วัสดุการแพทย์ศัลยกรรม-งบหน่วยงาน	001
127	วัสดุการแพทย์	วัสดุการแพทย์ศัลยกรรมกระดูกและข้อ	วัสดุการแพทย์ศัลยกรรมกระดูกและข้อ	001
128	วัสดุการแพทย์	วัสดุการแพทย์ศัลยกรรมกระดูกและข้อ	วัสดุการแพทย์ศัลยกรรมกระดูกและข้อ-งบหน่วยงาน	001
129	วัสดุการแพทย์	วัสดุการแพทย์สนับสนุน	วัสดุการแพทย์สนับสนุน	001
130	วัสดุการแพทย์	วัสดุการแพทย์สนับสนุน	วัสดุการแพทย์สนับสนุน-งบหน่วยงาน	001
131	วัสดุทันตกรรม	เครื่องมือทันตกรรม	เครื่องมือทันตกรรม	002
132	วัสดุทันตกรรม	เครื่องมือทันตกรรม	เครื่องมือทันตกรรม-ประมูล	002
133	วัสดุทันตกรรม	วัสดุจัดฟัน	วัสดุจัดฟัน	002
135	วัสดุทันตกรรม	วัสดุทันตกรรมทั่วไป	วัสดุทันตกรรมทั่วไป	002
136	วัสดุทันตกรรม	วัสดุทันตกรรมทั่วไป	วัสดุทันตกรรมทั่วไป-ประมูล	002
137	วัสดุทันตกรรม	วัสดุรากฟันเทียม	วัสดุรากฟันเทียม	002
138	วัสดุทันตกรรม	วัสดุรากฟันเทียม	วัสดุรากฟันเทียม-ประมูล	002
139	วัสดุทันตกรรม	เครื่องมือทันตกรรมรากฟันเทียม	เครื่องมือทันตกรรมรากฟันเทียม	002
140	วัสดุทันตกรรม	เครื่องมือทันตกรรมรากฟันเทียม	เครื่องมือทันตกรรมรากฟันเทียม-ประมูล	002
141	วัสดุเภสัชกรรม	วัสดุเภสัชกรรมทั่วไป	วัสดุเภสัชกรรมทั่วไป	004
142	วัสดุเภสัชกรรม	สารเคมี	สารเคมี	004
143	วัสดุวิทยาศาสตร์การแพทย์	Supply	Supply	007
144	วัสดุวิทยาศาสตร์การแพทย์	Reagent	Reagent	007
145	ค่าใช้สอย	ค่าซ่อมแซมอาคารและสิ่งปลูกสร้าง	ค่าซ่อมแซมอาคารและสิ่งปลูกสร้าง	009
146	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์สำนักงาน	ค่าซ่อมแซมครุภัณฑ์สำนักงาน	009
147	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์ยานพาหนะและขนส่ง	ค่าซ่อมแซมครุภัณฑ์ยานพาหนะและขนส่ง	009
148	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์ไฟฟ้าและวิทยุ	ค่าซ่อมแซมครุภัณฑ์ไฟฟ้าและวิทยุ	009
149	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์โฆษณาและเผยแพร่	ค่าซ่อมแซมครุภัณฑ์โฆษณาและเผยแพร่	009
150	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์วิทยาศาสตร์และการแพทย์	ค่าซ่อมแซมครุภัณฑ์วิทยาศาสตร์และการแพทย์	009
151	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์คอมพิวเตอร์	ค่าซ่อมแซมครุภัณฑ์คอมพิวเตอร์	009
152	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์อื่น	ค่าซ่อมแซมครุภัณฑ์อื่น	009
153	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาดูแลลิฟท์	ค่าจ้างเหมาบำรุงรักษาดูแลลิฟท์	009
154	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาสวนหย่อม	ค่าจ้างเหมาบำรุงรักษาสวนหย่อม	009
155	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาครุภัณฑ์วิทยาศาสตร์และการแพทย์	ค่าจ้างเหมาบำรุงรักษาครุภัณฑ์วิทยาศาสตร์และการแพทย์	009
156	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาระบบปรับอากาศ	ค่าจ้างเหมาบำรุงรักษาระบบปรับอากาศ	009
157	ค่าใช้สอย	ค่าจ้างเหมาซ่อมแซมบ้านพัก	ค่าจ้างเหมาซ่อมแซมบ้านพัก	009
158	ค่าใช้สอย	ค่าจ้างเหมาทำความสะอาด	ค่าจ้างเหมาทำความสะอาด	009
159	ค่าใช้สอย	ค่าจ้างเหมาประกอบอาหารผู้ป่วย	ค่าจ้างเหมาประกอบอาหารผู้ป่วย	009
160	ค่าใช้สอย	ค่าจ้างเหมารถ	ค่าจ้างเหมารถ	009
161	ค่าใช้สอย	ค่าจ้างเหมาดูแลความปลอดภัย	ค่าจ้างเหมาดูแลความปลอดภัย	009
162	ค่าใช้สอย	ค่าจ้างเหมาซักรีด	ค่าจ้างเหมาซักรีด	009
163	ค่าใช้สอย	ค่าจ้างเหมากำจัดขยะติดเชื้อ	ค่าจ้างเหมากำจัดขยะติดเชื้อ	009
164	ค่าใช้สอย	ค่าจ้างเหมาบริการทางการแพทย์	ค่าจ้างเหมาบริการทางการแพทย์	009
165	ค่าใช้สอย	ค่าจ้างเหมาบริการอื่น (สนับสนุน)	ค่าจ้างเหมาบริการอื่น (สนับสนุน)	009
166	ค่าใช้สอย	ค่าจ้างตรวจทางห้องปฏิบัติการ (Lab)	ค่าจ้างตรวจทางห้องปฏิบัติการ (Lab)	009
167	ค่าใช้สอย	ค่าจ้างตรวจเอ็กซเรย์ (X-Ray)	ค่าจ้างตรวจเอ็กซเรย์ (X-Ray)	009
168	ค่าใช้สอย	ค่าธรรมเนียมทางกฎหมาย	ค่าธรรมเนียมทางกฎหมาย	009
169	ค่าใช้สอย	ค่าธรรมเนียมธนาคาร	ค่าธรรมเนียมธนาคาร	009
170	ค่าใช้สอย	ค่าจ้างที่ปรึกษา	ค่าจ้างที่ปรึกษา	009
171	ค่าใช้สอย	ค่าเบี้ยประกันภัย	ค่าเบี้ยประกันภัย	009
172	ค่าใช้สอย	ค่าใช้จ่ายในการประชุม	ค่าใช้จ่ายในการประชุม	009
173	ค่าใช้สอย	ค่ารับรองและพิธีการ	ค่ารับรองและพิธีการ	009
174	ค่าใช้สอย	ค่าเช่าอสังหาริมทรัพย์	ค่าเช่าอสังหาริมทรัพย์	009
175	ค่าใช้สอย	ค่าเช่าเบ็ดเตล็ด	ค่าเช่าเบ็ดเตล็ด	009
220	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์คอมพิวเตอร์	006
221	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าซ่อมแซมครุภัณฑ์อื่น	006
222	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาดูแลลิฟท์	006
223	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาสวนหย่อม	006
224	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาครุภัณฑ์วิทยาศาสตร์และการแพทย์	006
225	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบำรุงรักษาระบบปรับอากาศ	006
226	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาซ่อมแซมบ้านพัก	006
227	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาทำความสะอาด	006
228	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาประกอบอาหารผู้ป่วย	006
229	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมารถ	006
230	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาดูแลความปลอดภัย	006
231	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาซักรีด	006
232	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมากำจัดขยะติดเชื้อ	006
233	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบริการทางการแพทย์	006
234	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างเหมาบริการอื่น (สนับสนุน)	006
235	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างตรวจทางห้องปฏิบัติการ (Lab)	006
236	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างตรวจเอ็กซเรย์ (X-Ray)	006
237	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าธรรมเนียมทางกฎหมาย	006
238	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าธรรมเนียมธนาคาร	006
239	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าจ้างที่ปรึกษา	006
240	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าเบี้ยประกันภัย	006
241	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าใช้จ่ายในการประชุม	006
242	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่ารับรองและพิธีการ	006
243	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าเช่าอสังหาริมทรัพย์	006
244	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าเช่าเบ็ดเตล็ด	006
245	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	เงินชดเชยค่างานสิ่งก่อสร้าง	006
246	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าประชาสัมพันธ์	006
247	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าชดใช้ค่าเสียหาย	006
248	ค่าใช้จ่ายโครงการ	ค่าใช้สอย	ค่าใช้สอยอื่นๆ	006
249	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุสำนักงาน	006
250	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุยานพาหนะและขนส่ง	006
251	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุไฟฟ้า	006
252	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	006
253	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุคอมพิวเตอร์	006
254	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุงานบ้านงานครัว	006
255	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุช่างและก่อสร้าง	006
256	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุเชื้อเพลิง	006
257	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุบริโภค	006
258	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	006
259	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุการเกษตร	006
260	ค่าใช้จ่ายโครงการ	ค่าวัสดุใช้ไป	วัสดุอื่นๆ	006
261	ค่าใช้จ่ายโครงการ	ยา	ยาในบัญชียาหลัก	006
262	ค่าใช้จ่ายโครงการ	ยา	ยานอกบัญชียาหลัก	006
263	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ทั่วไป	006
266	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ที่ใช้ในการป้องกันการติดเชื้อ	006
267	ค่าใช้จ่ายโครงการ	วัสดุการแพทย์	วัสดุการแพทย์ที่ใช้ในเทคโนโลยีทางการแพทย์	006
268	ค่าใช้จ่ายโครงการ	วัสดุทันตกรรม	เครื่องมือทันตกรรม	006
270	ค่าใช้จ่ายโครงการ	วัสดุทันตกรรม	วัสดุทันตกรรมทั่วไป	006
271	ค่าใช้จ่ายโครงการ	วัสดุทันตกรรม	วัสดุรากฟันเทียม	006
272	ค่าใช้จ่ายโครงการ	วัสดุเภสัชกรรม	วัสดุเภสัชกรรม	006
273	ค่าใช้จ่ายโครงการ	วัสดุเภสัชกรรม	สารเคมี	006
274	ค่าใช้จ่ายโครงการ	วัสดุวิทยาศาสตร์การแพทย์	วัสดุวิทยาศาสตร์การแพทย์ทั่วไป	006
275	ค่าใช้จ่ายโครงการ	วัสดุวิทยาศาสตร์การแพทย์	Supply	006
276	ค่าใช้จ่ายโครงการ	วัสดุวิทยาศาสตร์การแพทย์	Reagent	006
277	ค่าใช้จ่ายโครงการ	ค่าใช้จ่ายในการจัดประชุม	ค่าใช้สอย ค่าวัสดุ	006
278	ค่าใช้จ่ายโครงการ	ค่าใช้จ่ายในการจัดประชุม-อบรมเชิงปฏิบัติการ	ค่าตอบแทน ค่าใช้สอย ค่าวัสดุ	006
279	ค่าใช้จ่ายโครงการ	ค่าใช้จ่ายในการศึกษาดูงานนอกสถานที่	ค่าที่พัก ค่าเบี้ยเลี้ยง ค่าใช้สอย ค่าวัสดุ	006
280	ค่าใช้จ่ายโครงการ	ค่าใช้จ่ายในการประชุม-อบรมเชิงปฏิบัติการนอกสถานที่	ค่าที่พัก ค่าเบี้ยเลี้ยง ค่าตอบแทน ค่าใช้สอย ค่าวัสดุ	006
1	งบค่าเสื่อม	ครุภัณฑ์การศึกษา	ครุภัณฑ์การศึกษา-งบระดับเขตสุขภาพ	003
204	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	230
205	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	230
206	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร-งบหน่วยงาน	230
208	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ-งบหน่วยงาน	230
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (id, name, department_code) FROM stdin;
1	กลุ่มงานบริหารทั่วไป	0001
2	กลุ่มงานเทคนิคการแพทย์	0002
3	กลุ่มงานทันตกรรม	0003
4	กลุ่มงานเภสัชกรรม	0004
5	งานรังสีวิทยา	0005
6	กลุ่มงานเวชกรรมฟื้นฟู	0006
7	กลุ่มงานประกันสุขภาพ	0007
8	งานแพทย์แผนไทย	0008
9	กลุ่มงานสุขภาพจิต	0009
10	กลุ่มงานบริการด้านปฐมภูมิฯ	0010
11	กลุ่มการพยาบาล	0011
12	ศูนย์คุณภาพ	0012
13	งานผู้ป่วยนอก	0013
14	งานอุบัติเหตุฉุกเฉิน	0014
15	งานโรคไม่ติดต่อเรื้อรัง	0015
16	งานผู้ป่วยในชาย	0016
17	งานผู้ป่วยในหญิงและเด็ก	0017
18	งานห้องคลอด	0018
19	งานห้องผ่าตัด	0019
20	งานวิสัญญี	0020
21	งานจ่ายกลาง	0021
22	PCU_ร่วมใจ	0022
23	PCU_วังทอง	0023
24	งานแผนยุทธศาสตร์	0024
25	เรือนจำจังหวัด	0025
26	เรือนจำกลาง	0026
27	ทัณฑสถานหญิง	0027
28	รพ.สต.พันชาลี	0028
29	รพ.สต.บ้านสุพรรณพนมทอง	0029
30	รพ.สต.แม่ระกา	0030
31	รพ.สต.บ้านวังน้ำใส	0031
32	รพ.สต.บ้านหนองปรือ	0032
33	สอน.บ้านกลาง	0033
34	รพ.สต.บ้านใหม่ชัยเจริญ	0034
35	รพ.สต.บ้านดงพลวง	0035
36	รพ.สต.แก่งโสภา	0036
37	รพ.สต.ท่าหมื่นราม	0037
38	รพ.สต.บ้านหนองเตาอิฐ	0038
39	รพ.สต.วังนกแอ่น	0039
40	รพ.สต.บ้านน้ำพรม	0040
41	รพ.สต.บ้านไผ่ใหญ่	0041
42	รพ.สต.หนองพระ	0042
43	รพ.สต.ชัยนาม	0043
44	รพ.สต.ดินทอง	0044
45	รพ.สต.บ้านแสนสุขพัฒนา	0045
46	รพ.สต.วังพิกุล	0046
47	สสอ.วังทอง	0047
\.


--
-- Data for Name: inventory_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_adjustment (id, adjustment_no, adjustment_date, reason, status, created_by, approved_by, created_at) FROM stdin;
\.


--
-- Data for Name: inventory_adjustment_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_adjustment_item (id, adjustment_id, inventory_item_id, qty_diff, unit_cost, note) FROM stdin;
\.


--
-- Data for Name: inventory_balance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_balance (id, inventory_item_id, on_hand_qty, reserved_qty, available_qty, avg_cost, last_movement_at, updated_at) FROM stdin;
4	4	5	0	5	850.00	2026-03-10 13:24:47.169769	2026-03-10 13:24:47.169769
3	3	5	0	5	1390.00	2026-03-07 17:28:17.098202	2026-03-07 17:28:17.098202
2	2	199	0	199	60.00	2026-03-07 17:20:55.832108	2026-03-07 17:46:24.429834
5	5	10	0	10	980.00	2026-03-07 18:04:06.555924	2026-03-07 18:04:06.555924
7	7	600	0	600	42.00	2026-03-07 18:29:36.711476	2026-03-07 18:29:36.711476
6	6	529	0	529	9.00	2026-03-07 18:17:31.840867	2026-03-09 14:03:03.873062
8	8	19	0	19	990.00	2026-03-09 14:01:35.338289	2026-03-09 14:15:53.577616
9	9	210	0	210	39.00	2026-03-09 14:37:30.189301	2026-03-09 14:38:57.533975
1	1	99	0	99	35.00	2026-03-09 14:39:53.01793	2026-03-09 14:39:53.01793
10	10	1	0	1	320.00	\N	2026-03-10 09:48:50.633911
11	11	9	0	9	70.00	\N	2026-03-10 09:48:50.633911
12	12	8	0	8	170.00	\N	2026-03-10 09:48:50.633911
13	13	44	0	44	150.00	\N	2026-03-10 09:48:50.633911
14	14	9	0	9	280.00	\N	2026-03-10 09:48:50.633911
15	15	5	0	5	0.00	\N	2026-03-10 09:48:50.633911
16	16	7	0	7	390.00	\N	2026-03-10 09:48:50.633911
17	17	7	0	7	390.00	\N	2026-03-10 09:48:50.633911
18	18	7	0	7	390.00	\N	2026-03-10 09:48:50.633911
19	19	4	0	4	350.00	\N	2026-03-10 09:48:50.633911
20	20	3	0	3	350.00	\N	2026-03-10 09:48:50.633911
21	21	2	0	2	350.00	\N	2026-03-10 09:48:50.633911
22	22	2	0	2	350.00	\N	2026-03-10 09:48:50.633911
23	23	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
24	24	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
25	25	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
26	26	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
27	27	10	0	10	890.00	\N	2026-03-10 09:48:50.633911
28	28	6	0	6	980.00	\N	2026-03-10 09:48:50.633911
29	29	4	0	4	390.00	\N	2026-03-10 09:48:50.633911
30	30	6	0	6	980.00	\N	2026-03-10 09:48:50.633911
31	31	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
32	32	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
33	33	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
34	34	156	0	156	6.00	\N	2026-03-10 09:48:50.633911
35	35	25	0	25	65.00	\N	2026-03-10 09:48:50.633911
36	36	65	0	65	35.00	\N	2026-03-10 09:48:50.633911
37	37	12	0	12	15.00	\N	2026-03-10 09:48:50.633911
38	38	6750	0	6750	1.00	\N	2026-03-10 09:48:50.633911
39	39	8	0	8	30.00	\N	2026-03-10 09:48:50.633911
40	40	10	0	10	25.00	\N	2026-03-10 09:48:50.633911
41	41	36	0	36	35.00	\N	2026-03-10 09:48:50.633911
42	42	27	0	27	50.00	\N	2026-03-10 09:48:50.633911
43	43	118	0	118	35.00	\N	2026-03-10 09:48:50.633911
44	44	145	0	145	65.00	\N	2026-03-10 09:48:50.633911
45	45	250	0	250	65.00	\N	2026-03-10 09:48:50.633911
46	46	15	0	15	50.00	\N	2026-03-10 09:48:50.633911
47	47	118	0	118	70.00	\N	2026-03-10 09:48:50.633911
48	48	80	0	80	70.00	\N	2026-03-10 09:48:50.633911
49	49	184	0	184	70.00	\N	2026-03-10 09:48:50.633911
50	50	105	0	105	60.00	\N	2026-03-10 09:48:50.633911
51	51	75	0	75	45.00	\N	2026-03-10 09:48:50.633911
52	52	146	0	146	45.00	\N	2026-03-10 09:48:50.633911
53	53	72	0	72	45.00	\N	2026-03-10 09:48:50.633911
54	54	230	0	230	45.00	\N	2026-03-10 09:48:50.633911
55	55	4	0	4	120.00	\N	2026-03-10 09:48:50.633911
56	56	4	0	4	45.00	\N	2026-03-10 09:48:50.633911
57	57	9	0	9	45.00	\N	2026-03-10 09:48:50.633911
58	58	81	0	81	45.00	\N	2026-03-10 09:48:50.633911
59	59	80	0	80	45.00	\N	2026-03-10 09:48:50.633911
60	60	341	0	341	45.00	\N	2026-03-10 09:48:50.633911
61	61	90	0	90	45.00	\N	2026-03-10 09:48:50.633911
62	62	9	0	9	65.00	\N	2026-03-10 09:48:50.633911
63	63	6	0	6	95.00	\N	2026-03-10 09:48:50.633911
64	64	8	0	8	130.00	\N	2026-03-10 09:48:50.633911
65	65	13	0	13	370.00	\N	2026-03-10 09:48:50.633911
66	66	14	0	14	430.00	\N	2026-03-10 09:48:50.633911
67	67	33	0	33	200.00	\N	2026-03-10 09:48:50.633911
68	68	11	0	11	120.00	\N	2026-03-10 09:48:50.633911
69	69	21	0	21	180.00	\N	2026-03-10 09:48:50.633911
70	70	43	0	43	35.00	\N	2026-03-10 09:48:50.633911
71	71	18	0	18	25.00	\N	2026-03-10 09:48:50.633911
72	72	23	0	23	35.00	\N	2026-03-10 09:48:50.633911
73	73	4	0	4	120.00	\N	2026-03-10 09:48:50.633911
74	74	6	0	6	70.00	\N	2026-03-10 09:48:50.633911
75	75	4	0	4	30.00	\N	2026-03-10 09:48:50.633911
76	76	23	0	23	25.00	\N	2026-03-10 09:48:50.633911
77	77	59	0	59	70.00	\N	2026-03-10 09:48:50.633911
78	78	5	0	5	80.00	\N	2026-03-10 09:48:50.633911
79	79	22	0	22	160.00	\N	2026-03-10 09:48:50.633911
80	80	42	0	42	15.00	\N	2026-03-10 09:48:50.633911
81	81	14	0	14	50.00	\N	2026-03-10 09:48:50.633911
82	82	9	0	9	60.00	\N	2026-03-10 09:48:50.633911
83	83	3	0	3	45.00	\N	2026-03-10 09:48:50.633911
84	84	1	0	1	290.00	\N	2026-03-10 09:48:50.633911
85	85	4	0	4	450.00	\N	2026-03-10 09:48:50.633911
86	86	6	0	6	300.00	\N	2026-03-10 09:48:50.633911
87	87	4	0	4	130.00	\N	2026-03-10 09:48:50.633911
88	88	4	0	4	160.00	\N	2026-03-10 09:48:50.633911
89	89	1	0	1	295.00	\N	2026-03-10 09:48:50.633911
90	90	5	0	5	110.00	\N	2026-03-10 09:48:50.633911
91	91	1	0	1	110.00	\N	2026-03-10 09:48:50.633911
92	92	1	0	1	145.00	\N	2026-03-10 09:48:50.633911
93	93	2	0	2	145.00	\N	2026-03-10 09:48:50.633911
94	94	15	0	15	145.00	\N	2026-03-10 09:48:50.633911
95	95	3	0	3	145.00	\N	2026-03-10 09:48:50.633911
96	96	11	0	11	45.00	\N	2026-03-10 09:48:50.633911
97	97	6	0	6	45.00	\N	2026-03-10 09:48:50.633911
98	98	8	0	8	95.00	\N	2026-03-10 09:48:50.633911
99	99	11	0	11	95.00	\N	2026-03-10 09:48:50.633911
100	100	15	0	15	95.00	\N	2026-03-10 09:48:50.633911
101	101	1	0	1	95.00	\N	2026-03-10 09:48:50.633911
102	102	40	0	40	800.00	\N	2026-03-10 09:48:50.633911
103	103	52	0	52	30.00	\N	2026-03-10 09:48:50.633911
104	104	80	0	80	2.00	\N	2026-03-10 09:48:50.633911
105	105	25	0	25	15.00	\N	2026-03-10 09:48:50.633911
106	106	35	0	35	130.00	\N	2026-03-10 09:48:50.633911
107	107	34	0	34	58.00	\N	2026-03-10 09:48:50.633911
108	108	2	0	2	100.00	\N	2026-03-10 09:48:50.633911
109	109	22	0	22	350.00	\N	2026-03-10 09:48:50.633911
110	110	6	0	6	65.00	\N	2026-03-10 09:48:50.633911
111	111	5	0	5	160.00	\N	2026-03-10 09:48:50.633911
112	112	1	0	1	130.00	\N	2026-03-10 09:48:50.633911
113	113	18	0	18	10.00	\N	2026-03-10 09:48:50.633911
114	114	74	0	74	20.00	\N	2026-03-10 09:48:50.633911
115	115	108	0	108	10.00	\N	2026-03-10 09:48:50.633911
116	116	18	0	18	20.00	\N	2026-03-10 09:48:50.633911
117	117	48	0	48	50.00	\N	2026-03-10 09:48:50.633911
118	118	26	0	26	16.00	\N	2026-03-10 09:48:50.633911
119	119	7	0	7	410.00	\N	2026-03-10 09:48:50.633911
120	120	2	0	2	265.00	\N	2026-03-10 09:48:50.633911
121	121	15	0	15	85.00	\N	2026-03-10 09:48:50.633911
122	122	1	0	1	110.00	\N	2026-03-10 09:48:50.633911
123	123	3	0	3	110.00	\N	2026-03-10 09:48:50.633911
124	124	7	0	7	110.00	\N	2026-03-10 09:48:50.633911
125	125	2	0	2	110.00	\N	2026-03-10 09:48:50.633911
126	126	7	0	7	35.00	\N	2026-03-10 09:48:50.633911
127	127	242	0	242	45.00	\N	2026-03-10 09:48:50.633911
128	128	31	0	31	25.00	\N	2026-03-10 09:48:50.633911
129	129	29	0	29	30.00	\N	2026-03-10 09:48:50.633911
130	130	1	0	1	150.00	\N	2026-03-10 09:48:50.633911
131	131	9	0	9	2000.00	\N	2026-03-10 09:48:50.633911
132	132	250	0	250	120.00	\N	2026-03-10 09:48:50.633911
133	133	270	0	270	50.00	\N	2026-03-10 09:48:50.633911
134	134	17	0	17	10.00	\N	2026-03-10 09:48:50.633911
135	135	7	0	7	95.00	\N	2026-03-10 09:48:50.633911
136	136	4	0	4	95.00	\N	2026-03-10 09:48:50.633911
137	137	6	0	6	95.00	\N	2026-03-10 09:48:50.633911
138	138	14	0	14	95.00	\N	2026-03-10 09:48:50.633911
139	139	61	0	61	120.00	\N	2026-03-10 09:48:50.633911
140	140	5	0	5	130.00	\N	2026-03-10 09:48:50.633911
141	141	59	0	59	65.00	\N	2026-03-10 09:48:50.633911
142	142	17	0	17	30.00	\N	2026-03-10 09:48:50.633911
143	143	35	0	35	20.00	\N	2026-03-10 09:48:50.633911
144	144	117	0	117	55.00	\N	2026-03-10 09:48:50.633911
145	145	26	0	26	40.00	\N	2026-03-10 09:48:50.633911
146	146	42	0	42	25.00	\N	2026-03-10 09:48:50.633911
147	147	86	0	86	20.00	\N	2026-03-10 09:48:50.633911
148	148	2	0	2	850.00	\N	2026-03-10 09:48:50.633911
149	149	2	0	2	200.00	\N	2026-03-10 09:48:50.633911
150	150	3	0	3	85.00	\N	2026-03-10 09:48:50.633911
151	151	3	0	3	360.00	\N	2026-03-10 09:48:50.633911
152	152	10	0	10	65.00	\N	2026-03-10 09:48:50.633911
153	153	1350	0	1350	1.00	\N	2026-03-10 09:48:50.633911
154	154	600	0	600	4.00	\N	2026-03-10 09:48:50.633911
155	155	100	0	100	4.00	\N	2026-03-10 09:48:50.633911
156	183	8	0	8	35.00	\N	2026-03-10 09:48:50.633911
157	156	1450	0	1450	4.00	\N	2026-03-10 09:48:50.633911
158	157	10	0	10	60.00	\N	2026-03-10 09:48:50.633911
159	158	16	0	16	60.00	\N	2026-03-10 09:48:50.633911
160	159	59	0	59	25.00	\N	2026-03-10 09:48:50.633911
161	160	42	0	42	30.00	\N	2026-03-10 09:48:50.633911
162	161	44	0	44	30.00	\N	2026-03-10 09:48:50.633911
163	162	45	0	45	45.00	\N	2026-03-10 09:48:50.633911
164	163	12	0	12	30.00	\N	2026-03-10 09:48:50.633911
165	164	2	0	2	35.00	\N	2026-03-10 09:48:50.633911
166	165	14	0	14	35.00	\N	2026-03-10 09:48:50.633911
167	166	26	0	26	35.00	\N	2026-03-10 09:48:50.633911
168	167	161	0	161	20.00	\N	2026-03-10 09:48:50.633911
169	168	4	0	4	2200.00	\N	2026-03-10 09:48:50.633911
170	169	12	0	12	400.00	\N	2026-03-10 09:48:50.633911
171	170	21	0	21	20.00	\N	2026-03-10 09:48:50.633911
172	171	1	0	1	25.00	\N	2026-03-10 09:48:50.633911
173	172	61	0	61	60.00	\N	2026-03-10 09:48:50.633911
174	173	12	0	12	1600.00	\N	2026-03-10 09:48:50.633911
175	174	10	0	10	40.00	\N	2026-03-10 09:48:50.633911
176	175	59	0	59	15.00	\N	2026-03-10 09:48:50.633911
177	176	173	0	173	15.00	\N	2026-03-10 09:48:50.633911
178	177	201	0	201	15.00	\N	2026-03-10 09:48:50.633911
179	178	24	0	24	25.00	\N	2026-03-10 09:48:50.633911
180	179	44	0	44	25.00	\N	2026-03-10 09:48:50.633911
181	180	1	0	1	25.00	\N	2026-03-10 09:48:50.633911
182	181	56	0	56	45.00	\N	2026-03-10 09:48:50.633911
183	182	64	0	64	45.00	\N	2026-03-10 09:48:50.633911
184	184	14	0	14	60.00	\N	2026-03-10 09:48:50.633911
185	185	3	0	3	350.00	\N	2026-03-10 09:48:50.633911
186	186	40	0	40	15.00	\N	2026-03-10 09:48:50.633911
187	187	20	0	20	15.00	\N	2026-03-10 09:48:50.633911
188	188	40	0	40	15.00	\N	2026-03-10 09:48:50.633911
189	189	20	0	20	15.00	\N	2026-03-10 09:48:50.633911
190	190	1000	0	1000	10.00	\N	2026-03-10 09:48:50.633911
191	191	34	0	34	55.00	\N	2026-03-10 09:48:50.633911
192	192	13	0	13	60.00	\N	2026-03-10 09:48:50.633911
193	193	9	0	9	75.00	\N	2026-03-10 09:48:50.633911
194	194	5	0	5	140.00	\N	2026-03-10 09:48:50.633911
195	195	4	0	4	120.00	\N	2026-03-10 09:48:50.633911
196	196	34	0	34	35.00	\N	2026-03-10 09:48:50.633911
197	197	42	0	42	25.00	\N	2026-03-10 09:48:50.633911
198	198	66	0	66	10.00	\N	2026-03-10 09:48:50.633911
199	199	15	0	15	10.00	\N	2026-03-10 09:48:50.633911
200	200	17	0	17	15.00	\N	2026-03-10 09:48:50.633911
201	201	17	0	17	15.00	\N	2026-03-10 09:48:50.633911
202	202	35	0	35	95.00	\N	2026-03-10 09:48:50.633911
203	203	429	0	429	200.00	\N	2026-03-10 09:48:50.633911
204	204	96	0	96	5.00	\N	2026-03-10 09:48:50.633911
205	205	194	0	194	5.00	\N	2026-03-10 09:48:50.633911
206	206	5	0	5	30.00	\N	2026-03-10 09:48:50.633911
207	207	29	0	29	65.00	\N	2026-03-10 09:48:50.633911
208	208	50	0	50	65.00	\N	2026-03-10 09:48:50.633911
209	209	24	0	24	50.00	\N	2026-03-10 09:48:50.633911
210	210	21	0	21	40.00	\N	2026-03-10 09:48:50.633911
212	212	15	0	15	15.00	\N	2026-03-10 09:48:50.633911
213	213	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
214	214	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
215	215	3	0	3	290.00	\N	2026-03-10 09:48:50.633911
216	216	3	0	3	180.00	\N	2026-03-10 09:48:50.633911
217	217	3	0	3	590.00	\N	2026-03-10 09:48:50.633911
218	218	3	0	3	1350.00	\N	2026-03-10 09:48:50.633911
219	219	2	0	2	390.00	\N	2026-03-10 09:48:50.633911
220	220	2	0	2	890.00	\N	2026-03-10 09:48:50.633911
221	221	2	0	2	690.00	\N	2026-03-10 09:48:50.633911
222	222	2	0	2	990.00	\N	2026-03-10 09:48:50.633911
224	224	2	0	2	299.00	\N	2026-03-10 09:48:50.633911
225	225	1	0	1	1690.00	\N	2026-03-10 09:48:50.633911
226	226	7	0	7	1350.00	\N	2026-03-10 09:48:50.633911
228	228	7	0	7	1350.00	\N	2026-03-10 09:48:50.633911
211	211	4	0	4	15.00	2026-03-10 13:22:46.821769	2026-03-10 13:22:46.821769
223	223	0	0	0	2000.00	2026-03-10 13:22:46.821769	2026-03-10 13:22:46.821769
227	227	3	0	3	1350.00	2026-03-10 13:22:46.821769	2026-03-10 13:24:19.242484
229	229	3	0	3	420.00	2026-03-13 02:51:55.309857	2026-03-13 02:51:55.309857
\.


--
-- Data for Name: inventory_issue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_issue (id, issue_no, issue_date, requisition_id, requesting_department, status, issued_by, approved_by, note, created_at, requesting_department_code) FROM stdin;
1	ISS-1772878855829	2026-03-07 10:20:55.829	2	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-07 17:20:55.832108	0001
2	ISS-1772881226714	2026-03-07 11:00:26.714	4	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-07 18:00:26.716281	0001
3	ISS-1773039695336	2026-03-09 07:01:35.336	6	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-09 14:01:35.338289	0001
4	ISS-1773041993017	2026-03-09 07:39:53.017	1	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-09 14:39:53.01793	0001
5	ISS-1773123766822	2026-03-10 06:22:46.822	10	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-10 13:22:46.821769	0001
6	ISS-1773123887168	2026-03-10 06:24:47.168	4	กลุ่มงานบริหารทั่วไป	POSTED	warehouse-admin	warehouse-admin	\N	2026-03-10 13:24:47.169769	0001
\.


--
-- Data for Name: inventory_issue_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_issue_item (id, issue_id, requisition_item_id, inventory_item_id, issued_qty, unit_cost, total_cost) FROM stdin;
1	1	2	2	1	60.00	60.00
2	2	4	4	1	850.00	850.00
3	3	6	8	1	990.00	990.00
4	4	1	1	1	35.00	35.00
5	5	11	211	20	15.00	300.00
6	5	12	227	4	1350.00	5400.00
7	5	13	223	2	2000.00	4000.00
8	6	4	4	1	850.00	850.00
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_item (id, product_code, product_name, category, product_type, product_subtype, unit, warehouse_id, location_id, lot_no, expiry_date, standard_cost, is_active, created_at, updated_at) FROM stdin;
1	P230-000438	กระดาษเทอร์มอล สำหรับเครื่อง EDC ขนาด 57*40 มม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	35.00	t	2026-03-07 16:47:53.514728	2026-03-07 16:47:53.514728
2	P230-000440	กระดาษเทอร์มอล ขนาด 80*80 มม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	60.00	t	2026-03-07 17:19:22.144226	2026-03-07 17:19:22.144226
3	P230-001093	หมึก Printer Laser TN-2560	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	1390.00	t	2026-03-07 17:28:17.098202	2026-03-07 17:28:17.098202
4	P230-000937	หมึก Printer Laser PANTUM P2500	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	850.00	t	2026-03-07 17:53:32.450051	2026-03-07 17:53:32.450051
5	P230-001114	หมึก Printer Laser FUJI-XEROX CT202877 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	980.00	t	2026-03-07 18:04:06.555924	2026-03-07 18:04:06.555924
6	P230-000341	น้ำดื่ม ชนิดบรรจุแกลลอน ขนาด 18 ลิตร	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ถัง	1	\N	\N	\N	9.00	t	2026-03-07 18:17:31.840867	2026-03-07 18:17:31.840867
7	P230-000064	กระดาษเช็ดมือ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	1	\N	\N	\N	42.00	t	2026-03-07 18:29:36.711476	2026-03-07 18:29:36.711476
8	P230-000040	หมึก Printer Laser 107A	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	990.00	t	2026-03-09 13:59:07.611971	2026-03-09 13:59:07.611971
9	P230-000089	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	39.00	t	2026-03-09 14:37:30.189301	2026-03-09 14:37:30.189301
10	P230-000020	คีย์บอร์ด แบบ USB	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	320.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
11	P230-000021	ซองใส่ CD แบบใส (50 ซอง/แพค)	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	แพค	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
12	P230-000022	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ300	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	170.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
13	P230-000023	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ310	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	150.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
14	P230-000024	แผ่น CD-R (50 ซอง/แพค)	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หลอด	1	\N	\N	\N	280.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
15	P230-000027	หมึก Printer Ink jet GT53 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	0.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
16	P230-000028	หมึก Printer Ink jet GT52 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
17	P230-000029	หมึก Printer Ink jet GT52 สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
18	P230-000030	หมึก Printer Ink jet GT52 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
19	P230-000031	หมึก Printer Ink jet L5190 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
20	P230-000032	หมึก Printer Ink jet L5190 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
21	P230-000033	หมึก Printer Ink jet L5190 สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
22	P230-000034	หมึก Printer Ink jet L5190 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
23	P230-000035	หมึก Printer Ink jet T6641 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
24	P230-000036	หมึก Printer Ink jet T6641 สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
25	P230-000037	หมึก Printer Ink jet T6641 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
26	P230-000038	หมึก Printer Ink jet T6641 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
27	P230-000042	หมึก Printer Laser 30A	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	890.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
28	P230-000044	หมึก Printer Laser 472	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	980.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
29	P230-000047	หมึก Printer Laser 83A	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
30	P230-000049	หมึก Printer Laser Fuji m285Z P235	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	980.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
31	P230-000057	หมึก Printer Ink jet Epson 003 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
32	P230-000059	หมึก Printer Ink jet Epson 003 สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
33	P230-000060	หมึก Printer Ink jet Epson 003 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
34	P230-000062	กระดาษชำระ ขนาดเล็ก	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	1	\N	\N	\N	6.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
35	P230-000063	กระดาษชำระ ชนิดม้วน แบบ 2 ชั้น ขนาดยาว 300 เมตร	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
36	P230-000069	ก้อนดับกลิ่น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
37	P230-000071	แก้วน้ำ แบบทรงสูง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
38	P230-000073	แก้วน้ำ ชนิดพลาสติก ขนาด 6 ออนซ์	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	1.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
39	P230-000074	แก้วน้ำ ชนิดอลูมิเนียม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
40	P230-000076	ขันน้ำ ชนิดพลาสติก แบบมีด้าม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
41	P230-000079	ช้อน ชนิดสแตนเลส แบบสั้น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	โหล	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
42	P230-000080	เชือก ชนิดปอแก้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
43	P230-000082	ด้ามมีดโกน ชนิดพลาสติก แบบใช้แล้วทิ้ง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
44	P230-000087	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเขียว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
45	P230-000088	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเขียว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
46	P230-000090	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
47	P230-000092	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีแดง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
48	P230-000093	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีแดง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
49	P230-000094	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเหลือง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
50	P230-000095	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเหลือง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
51	P230-000098	ถุง ชนิดพลาสติก ขนาด 16*26 นิ้ว สีใส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
52	P230-000099	ถุง ชนิดพลาสติก ขนาด 4.5*7 นิ้ว สีใส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
53	P230-000100	ถุง ชนิดพลาสติก ขนาด 6*9 นิ้ว สีใส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
54	P230-000101	ถุง ชนิดพลาสติก ขนาด 8*12 นิ้ว สีใส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
55	P230-000103	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
56	P230-000106	ถุงมือ ชนิดยาง เบอร์ L สีส้ม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
57	P230-000107	ถุงมือ ชนิดยาง เบอร์ M สีส้ม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
58	P230-000111	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*24 นิ้ว สีขาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
59	P230-000112	ถุงหิ้ว ชนิดพลาสติก ขนาด 15*30 นิ้ว สีขาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
60	P230-000113	ถุงหิ้ว ชนิดพลาสติก ขนาด 8*16 นิ้ว สีขาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
61	P230-000114	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*26 นิ้ว สีขาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
62	P230-000115	ที่ตักขยะ ชนิดพลาสติก แบบมีด้ามจับ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
63	P230-000116	ที่ตักขยะสังกะสี ชนิดสังกะสี แบบมีด้ามจับ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
64	P230-000119	น้ำยา สำหรับเช็ดกระจก	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
65	P230-000121	น้ำยา ชนิดสูตรน้ำ สำหรับดันฝุ่น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	370.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
66	P230-000122	น้ำยา ชนิดสูตรน้ำมันใส สำหรับดันฝุ่น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	430.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
67	P230-000123	น้ำยา สำหรับทำความสะอาดพื้น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	200.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
68	P230-000124	น้ำยา สำหรับล้างจาน	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
69	P230-000125	น้ำยา สำหรับล้างมือ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	1	\N	\N	\N	180.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
70	P230-000127	ใบมีดโกน แบบ 2 คม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่อง	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
71	P230-000128	ปืนยิงแก๊ส	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
72	P230-000129	แป้งฝุ่น สำหรับเด็ก ขนาด 180 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
73	P230-000130	แปรง ชนิดทองเหลือง สำหรับขัดพื้น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
74	P230-000131	แปรง ชนิดพลาสติก สำหรับขัดพื้นแบบมีด้ามยาว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
75	P230-000132	แปรง ชนิดพลาสติก สำหรับขัดห้องน้ำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
76	P230-000133	แปรง ชนิดขนอ่อน สำหรับซักผ้า	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
77	P230-000135	ผงซักฟอก ขนาด 800 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง	1	\N	\N	\N	70.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
78	P230-000138	ผ้าม็อบ สำหรับถูพื้น แบบเปียก ขนาด 12 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	1	\N	\N	\N	80.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
79	P230-000139	ผ้าห่ม สำหรับถูพื้น	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	1	\N	\N	\N	160.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
80	P230-000141	ฝอย ชนิดแสตนเลส ขนาด 14 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
81	P230-000148	ไม้กวาด ชนิดดอกหญ้า	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
82	P230-000149	ไม้กวาด ชนิดทางมะพร้าว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
83	P230-000150	ไม้กวาด ชนิดทางมะพร้าว สำหรับกวาดหยากไย่	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
84	P230-000151	ไม้กวาด ชนิดพลาสติก สำหรับกวาดหยากไย่ แบบปรับระดับได้	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
85	P230-000152	ไม้ดันฝุ่น แบบด้ามไม้ พร้อมผ้าดันฝุ่น ขนาดยาว 24 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	450.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
86	P230-000153	ไม้ดันฝุ่น แบบด้ามอลูมิเนียม ขนาดยาว 24 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	300.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
87	P230-000154	ไม้ถูพื้น ขนาด 10 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
88	P230-000155	ไม้ปัดขนไก่ แบบด้ามพลาสติก	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	160.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
89	P230-000156	ไม้ยางรีดน้ำ ขนาด 18 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	295.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
90	P230-000157	ยางวง แบบเส้นเล็ก ขนาด 500 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
91	P230-000158	ยางวง แบบเส้นใหญ่ ขนาด 500 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
92	P230-000159	รองเท้า แบบบู๊ท เบอร์ 10 สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	145.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
93	P230-000161	รองเท้า แบบบู๊ท เบอร์ 11 สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	145.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
94	P230-000162	รองเท้า แบบบู๊ท เบอร์ 11.5 สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	145.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
95	P230-000163	รองเท้า แบบบู๊ท เบอร์ 12 สีดำ	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	145.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
96	P230-000164	รองเท้า ชนิดฟองน้ำ เบอร์ 10	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
97	P230-000165	รองเท้า ชนิดฟองน้ำ เบอร์ 11	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
98	P230-000167	รองเท้า ชนิดยางพารา เบอร์ L	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
99	P230-000168	รองเท้า ชนิดยางพารา เบอร์ LL	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
100	P230-000169	รองเท้า ชนิดยางพารา เบอร์ M	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
101	P230-000170	รองเท้า ชนิดยางพารา เบอร์ XL	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
102	P230-000171	ลังถึง เบอร์ 36	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	1	\N	\N	\N	800.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
103	P230-000172	สก็อตไบร์ท แบบแผ่นเล็ก ขนาด 4.5*6 นิ้ว	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แผ่น	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
104	P230-000174	สบู่ แบบก้อนเล็ก ขนาด 10 กรัม	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	1	\N	\N	\N	2.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
105	P230-000175	สบู่ แบบก้อนใหญ่	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
106	P230-000177	สเปรย์ ชนิดสูตรน้ำ สำหรับฉีดมด ยุง ขนาด 600 มล.	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
107	P230-000178	สเปรย์ สำหรับปรับอากาศ ขนาด 300 มล.	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	1	\N	\N	\N	58.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
108	P230-000183	เหยือกน้ำ ชนิดพลาสติก ขนาด 1,000 ซีซี	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1	\N	\N	\N	100.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
109	P230-000184	เอี๊ยม ชนิดพลาสติก แบบใช้แล้วทิ้ง ขนาดบรรจุ 100 ชิ้น/ถุง	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
110	P230-000343	น้ำหวาน สำหรับผู้ป่วยเบาหวาน สีแดง	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค	ขวด	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
111	P230-000344	ไฟฉาย แบบหลอด LED	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กระบอก	1	\N	\N	\N	160.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
112	P230-000347	ถ่าน ชนิดอัลคาไลน์ ขนาด 9V	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
113	P230-000348	ถ่าน ชนิดธรรมดา ขนาด AA	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
114	P230-000349	ถ่าน ชนิดอัลคาไลน์ ขนาด AA	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
115	P230-000350	ถ่าน ชนิดธรรมดา ขนาด AAA	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
116	P230-000351	ถ่าน ชนิดอัลคาไลน์ ขนาด AAA	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
117	P230-000352	ถ่าน ชนิดอัลคาไลน์ ขนาดกลาง C	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
118	P230-000353	ถ่าน ชนิดธรรมดา ขนาดใหญ่ D	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	1	\N	\N	\N	16.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
119	P230-000355	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 3 เมตร	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	1	\N	\N	\N	410.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
120	P230-000421	กบเหลาดินสอ แบบหมุน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	265.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
121	P230-000422	กรรไกร ขนาด 8 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	85.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
122	P230-000424	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีขาว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
123	P230-000425	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเขียว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
124	P230-000426	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีชมพู	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
125	P230-000428	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเหลือง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	110.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
126	P230-000429	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
127	P230-000430	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว 24x25 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
128	P230-000431	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1.5 นิ้ว 36x20 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
129	P230-000433	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 2 นิ้ว 20 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
130	P230-000435	กระดาษคาร์บอน สีน้ำเงิน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	150.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
131	P230-000436	กระดาษต่อเนื่อง แบบ 1 ชั้น ขนาด 15x11 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	2000.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
132	P230-000437	กระดาษถ่ายเอกสาร ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
133	P230-000439	กระดาษเทอร์มอล สำหรับเครื่องวัดความดัน ขนาด 57*55 มม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
134	P230-000442	กระดาษบวกเลข สำหรับเครื่องคิดเลข ขนาด 2 1/4 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
135	P230-000443	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเขียว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
136	P230-000444	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีชมพู	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
137	P230-000445	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีฟ้า	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
138	P230-000446	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเหลือง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
139	P230-000447	กระดาษโรเนียว หนา 70 แกรม ขนาด A4 สีขาว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
140	P230-000448	กระดาษโรเนียว หนา 80 แกรม ขนาด F4 สีขาว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	1	\N	\N	\N	130.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
141	P230-000451	กาว ชนิดแท่ง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
142	P230-000452	กาว ชนิดน้ำ แบบป้าย ขนาด 560 ซีซี	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
143	P230-000453	กาว ชนิดน้ำ แบบหัวโฟม ขนาด 50 ซีซี	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
144	P230-000455	คลิปหนีบกระดาษ ขนาด #108 สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	55.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
145	P230-000456	คลิปหนีบกระดาษ ขนาด #109 สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	40.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
146	P230-000457	คลิปหนีบกระดาษ ขนาด #110 สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
147	P230-000458	คลิปหนีบกระดาษ ขนาด #111 สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
148	P230-000460	เครื่องคิดเลข ชนิด 2 ระบบ แบบ 12 หลัก	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	850.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
149	P230-000461	เครื่องเจาะกระดาษ แบบเจาะ 25 แผ่น	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	200.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
150	P230-000462	เครื่องเย็บกระดาษ ขนาด NO.10	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	85.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
151	P230-000463	เครื่องเย็บกระดาษ ขนาด NO.35	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	360.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
152	P230-000464	เชือก ชนิดพลาสติก ขนาดใหญ่ ยาว 180 ม. สี่ขาว-แดง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
153	P230-000465	ซองขาว แบบมีครุฑ ขนาด #9/125	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1	\N	\N	\N	1.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
154	P230-000466	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1	\N	\N	\N	4.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
155	P230-000467	ซองน้ำตาล แบบมีครุฑ ไม่ขยายข้าง หนาพิเศษ ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1	\N	\N	\N	4.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
183	P230-000525	แปรง สำหรับลบกระดานไวท์บอร์ด	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
156	P230-000468	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด F4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1	\N	\N	\N	4.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
157	P230-000470	ตรายาง สำหรั้บปั๊มวันที่ภาษาไทย	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
158	P230-000471	ตรายาง สำหรั้บปั๊มวันที่เลขไทย	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
159	P230-000474	เทปกาว ชนิด OPP ขนาด 2 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
160	P230-000476	เทปใส แบบแกนเล็ก ขนาด 1 นิ้ว 36 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
161	P230-000477	เทปใส แบบแกนใหญ่ ขนาด 1 นิ้ว 36 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
162	P230-000478	เทปใส แบบแกนใหญ่ ขนาด 2 นิ้ว 45 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
163	P230-000479	เทปใส แบบแกนเล็ก ขนาด 3/4 นิ้ว 36 หลา	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
164	P230-000484	แท่นประทับ แบบฝาโลหะ สีดำ #2	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
165	P230-000485	แท่นประทับ แบบฝาโลหะ สีแดง #2	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
166	P230-000486	แท่นประทับ แบบฝาโลหะ สีน้ำเงิน #2	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
167	P230-000492	น้ำยา สำหรับลบคำผิด ขนาด 7 มล.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
168	P230-000503	แบบฟอร์ม ชนิดเคมี 2 ชั้น Doctor's Order แบบต่อเนื่อง เคมี 2 ชั้น 9*11" (1,000 ชุด/กล่อง) ขนาด 9*11 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	2200.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
169	P230-000505	แบบฟอร์ม ปรอท แบบพิมพ์ 2 สี หนา 70 แกรม ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	1	\N	\N	\N	400.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
170	P230-000506	ใบมีดคัตเตอร์ ขนาดเล็ก	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	20.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
171	P230-000507	ใบมีดคัตเตอร์ ขนาดใหญ่	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
172	P230-000509	แบบฟอร์ม ใบรับรองแพทย์ กรณีสมัครงาน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
173	P230-000510	แบบฟอร์ม ใบเสร็จรับเงิน (1,000 ชุด/กล่อง)	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	1600.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
174	P230-000514	ปากกา เขียนแผ่น CD สีน้ำเงิน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	40.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
175	P230-000515	ปากกา เคมี แบบ 2 หัว สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
176	P230-000516	ปากกา เคมี แบบ 2 หัว สีแดง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
177	P230-000517	ปากกา เคมี แบบ 2 หัว สีน้ำเงิน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
178	P230-000518	ปากกา ไวท์บอร์ด ตราม้า สีแดง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
179	P230-000521	ปากกา ไวท์บอร์ด ตราม้า สีน้ำเงิน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
180	P230-000522	ปากกา ไวท์บอร์ด PILOT สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
181	P230-000523	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A5	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
182	P230-000524	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A7	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	1	\N	\N	\N	45.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
184	P230-000530	พลาสติกเคลือบบัตร ขนาด 6*95 ซม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
185	P230-000531	พลาสติกเคลือบบัตร หนา 125 ไมครอน ขนาด A4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
186	P230-000533	แฟ้ม แบบแขวน สีเขียว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
187	P230-000534	แฟ้ม แบบแขวน สีฟ้า	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
188	P230-000535	แฟ้ม แบบแขวน สีส้ม	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
189	P230-000536	แฟ้ม แบบแขวน สีเหลือง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
190	P230-000537	แฟ้ม เวชระเบียน	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
191	P230-000538	แฟ้ม แบบสันแข็ง ขนาด 1 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	55.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
192	P230-000539	แฟ้ม แบบสันแข็ง ขนาด 2 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	60.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
193	P230-000540	แฟ้ม แบบสันแข็ง ขนาด 3 นิ้ว	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	75.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
194	P230-000541	แฟ้ม เสนอเซ็นต์ ขนาด F4	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	140.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
195	P230-000542	แฟ้ม ชนิดปกพลาสติก แบบหนีบ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	1	\N	\N	\N	120.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
196	P230-000543	มีดคัตเตอร์ ชนิดด้ามสแตนเลส ขนาดเล็ก	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	35.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
197	P230-000544	มีดคัตเตอร์ ชนิดด้ามพลาสติก ขนาดใหญ่	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1	\N	\N	\N	25.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
198	P230-000546	ลวดเย็บกระดาษ เบอร์ 10	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
199	P230-000548	ลวดเย็บกระดาษ เบอร์ 35	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	10.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
200	P230-000550	ลวดเสียบกระดาษ ขนาดเล็ก เบอร์ 1	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
201	P230-000551	ลวดเสียบกระดาษ ขนาดใหญ่ เบอร์ 0	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
202	P230-000553	ลิ้นแฟ้ม ชนิดเหล็ก	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1	\N	\N	\N	95.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
203	P230-000560	สติ๊กเกอร์ แบบต่อเนื่อง สำหรับพิมพ์ชื่อผู้ป่วย ขนาด 6*2.5 ซม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1	\N	\N	\N	200.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
204	P230-000561	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีฟ้า	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	1	\N	\N	\N	5.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
205	P230-000562	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีเหลือง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	1	\N	\N	\N	5.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
206	P230-000566	สมุด ชนิดปกสี คู่มือเบิกจ่ายในราชการ 301	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	30.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
207	P230-000568	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือรับ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
208	P230-000569	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือส่ง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	65.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
209	P230-000572	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 1 หุ้มปก ขนาด 24x35 ซม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	50.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
210	P230-000573	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 2 หุ้มปก ขนาด 19x31 ซม.	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	1	\N	\N	\N	40.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
211	P230-000578	หมึกเติม สำหรับแท่นประทับตรายาง สีดำ	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
212	P230-000579	หมึกเติม สำหรับแท่นประทับตรายาง สีแดง	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	1	\N	\N	\N	15.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
213	P230-000712	หมึก Printer Ink jet BT5000C สีฟ้า	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
214	P230-000713	หมึก Printer Ink jet BT5000M สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
215	P230-000714	หมึก Printer Ink jet BT5000Y สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	290.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
216	P230-000784	Flash drive แบบ USB ขนาด 16 Gb	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	180.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
217	P230-000938	หมึก Printer Laser BROTHER FAX2950	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	590.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
218	P230-000940	Power supply ขนาด 550W	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	1350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
219	P230-000942	สาย HDMI ชนิด 4K ขนาด 5 เมตร	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	1	\N	\N	\N	390.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
220	P230-000943	สาย HDMI ชนิด 4K ขนาด 10 เมตร	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	1	\N	\N	\N	890.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
221	P230-000944	กล่องใส่ Hardisk ขนาด 2.5 นิ้ว	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	690.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
222	P230-000945	คีม สำหรับเข้าหัว LAN	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	990.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
223	P230-000987	Hardisk External ขนาด 1 Tb	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	2000.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
224	P230-000989	MP3 player แบบ USB ขนาด 512 MB	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	299.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
225	P230-001106	Hardisk ชนิด SSD Internal ขนาด 500 Gb	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1	\N	\N	\N	1690.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
226	P230-001115	หมึก Printer Laser FUJI-XEROX CT203486 สีดำ	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	1350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
227	P230-001116	หมึก Printer Laser FUJI-XEROX CT203486 สีชมพู	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	1350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
228	P230-001117	หมึก Printer Laser FUJI-XEROX CT203486 สีเหลือง	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1	\N	\N	\N	1350.00	t	2026-03-10 09:48:42.943283	2026-03-10 09:48:42.943283
229	P230-001174	พาน สำหรับจัดดอกไม้	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1	\N	\N	\N	420.00	t	2026-03-13 02:51:55.309857	2026-03-13 02:51:55.309857
\.


--
-- Data for Name: inventory_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_location (id, warehouse_id, location_code, location_name, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inventory_movement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_movement (id, inventory_item_id, movement_date, movement_type, qty_in, qty_out, unit_cost, total_cost, balance_qty_after, balance_value_after, reference_type, reference_id, reference_no, source_department, target_department, note, created_by, created_at) FROM stdin;
1	1	2026-03-07 09:47:53.516	PURCHASE_APPROVAL_RECEIPT	100	0	35.00	3500.00	100	3500.00	InventoryReceipt	1	IR-1772876873516	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 16:47:53.514728
2	2	2026-03-07 10:19:22.146	PURCHASE_APPROVAL_RECEIPT	200	0	60.00	12000.00	200	12000.00	InventoryReceipt	2	IR-1772878762146	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 17:19:22.144226
3	2	2026-03-07 10:20:55.829	ISSUE_APPROVED	0	1	60.00	60.00	199	11940.00	InventoryIssue	1	ISS-1772878855829	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-07 17:20:55.832108
4	3	2026-03-07 10:28:17.1	PURCHASE_APPROVAL_RECEIPT	5	0	1390.00	6950.00	5	6950.00	InventoryReceipt	3	IR-1772879297100	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 17:28:17.098202
5	2	2026-03-07 17:46:04.360453	REQUISITION_RESERVE	0	0	60.00	0.00	199	11940.00	InventoryRequisition	3	REQ-1772879277656	\N	กลุ่มงานบริหารทั่วไป	Reserved 1 items	Admin	2026-03-07 17:46:04.360453
6	2	2026-03-07 17:46:24.429834	REQUISITION_UNRESERVE	0	0	60.00	0.00	199	11940.00	InventoryRequisition	3	REQ-1772879277656	\N	กลุ่มงานบริหารทั่วไป	Unreserved 1 items due to cancellation	Admin	2026-03-07 17:46:24.429834
7	4	2026-03-07 10:53:32.451	PURCHASE_APPROVAL_RECEIPT	5	0	850.00	4250.00	5	4250.00	InventoryReceipt	4	IR-1772880812451	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 17:53:32.450051
8	4	2026-03-07 17:58:31.161224	REQUISITION_RESERVE	0	0	850.00	0.00	5	4250.00	InventoryRequisition	4	REQ-1772881083435	\N	กลุ่มงานบริหารทั่วไป	Reserved 2 items	Test User	2026-03-07 17:58:31.161224
9	4	2026-03-07 11:00:26.714	ISSUE_APPROVED	0	1	850.00	850.00	4	3400.00	InventoryIssue	2	ISS-1772881226714	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-07 18:00:26.716281
10	5	2026-03-07 11:04:06.558	PURCHASE_APPROVAL_RECEIPT	10	0	980.00	9800.00	10	9800.00	InventoryReceipt	5	IR-1772881446558	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 18:04:06.555924
11	6	2026-03-07 11:17:31.847	PURCHASE_APPROVAL_RECEIPT	529	0	9.00	4761.00	529	4761.00	InventoryReceipt	6	IR-1772882251847	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 18:17:31.840867
12	4	2026-03-07 11:29:22.612	PURCHASE_APPROVAL_RECEIPT	2	0	850.00	1700.00	6	5100.00	InventoryReceipt	7	IR-1772882962612	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 18:29:22.602531
13	7	2026-03-07 11:29:36.726	PURCHASE_APPROVAL_RECEIPT	600	0	42.00	25200.00	600	25200.00	InventoryReceipt	8	IR-1772882976726	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-07 18:29:36.711476
14	6	2026-03-07 18:31:01.286754	REQUISITION_RESERVE	0	0	9.00	0.00	529	4761.00	InventoryRequisition	5	REQ-1772882639640	\N	กลุ่มงานบริหารทั่วไป	Reserved 1 items	\N	2026-03-07 18:31:01.286754
15	8	2026-03-09 06:59:07.619	PURCHASE_APPROVAL_RECEIPT	20	0	990.00	19800.00	20	19800.00	InventoryReceipt	9	IR-1773039547618	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-09 13:59:07.611971
16	8	2026-03-09 14:00:49.718026	REQUISITION_RESERVE	0	0	990.00	0.00	20	19800.00	InventoryRequisition	6	REQ-1773039629252	\N	กลุ่มงานบริหารทั่วไป	Reserved 1 items	chrome-mcp-test	2026-03-09 14:00:49.718026
17	8	2026-03-09 07:01:35.336	ISSUE_APPROVED	0	1	990.00	990.00	19	18810.00	InventoryIssue	3	ISS-1773039695336	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-09 14:01:35.338289
18	6	2026-03-09 14:03:03.873062	REQUISITION_UNRESERVE	0	0	9.00	0.00	529	4761.00	InventoryRequisition	5	REQ-1772882639640	\N	กลุ่มงานบริหารทั่วไป	Unreserved 1 items due to cancellation	\N	2026-03-09 14:03:03.873062
19	8	2026-03-09 14:15:48.631119	REQUISITION_RESERVE	0	0	990.00	0.00	19	18810.00	InventoryRequisition	7	REQ-1773040521512	\N	กลุ่มงานบริหารทั่วไป	Reserved 1 items	test-approver	2026-03-09 14:15:48.631119
20	8	2026-03-09 14:15:53.577616	REQUISITION_UNRESERVE	0	0	990.00	0.00	19	18810.00	InventoryRequisition	7	REQ-1773040521512	\N	กลุ่มงานบริหารทั่วไป	Unreserved 1 items due to cancellation	test-user	2026-03-09 14:15:53.577616
21	9	2026-03-09 07:37:30.195	PURCHASE_APPROVAL_RECEIPT	210	0	39.00	8190.00	210	8190.00	InventoryReceipt	10	IR-1773041850195	กลุ่มงานบริหารทั่วไป	\N	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	2026-03-09 14:37:30.189301
22	9	2026-03-09 14:38:42.061156	REQUISITION_RESERVE	0	0	39.00	0.00	210	8190.00	InventoryRequisition	8	REQ-1773041913295	\N	กลุ่มงานบริหารทั่วไป	Reserved 5 items	ผู้ทดสอบ TEST	2026-03-09 14:38:42.061156
23	9	2026-03-09 14:38:57.533975	REQUISITION_UNRESERVE	0	0	39.00	0.00	210	8190.00	InventoryRequisition	8	REQ-1773041913295	\N	กลุ่มงานบริหารทั่วไป	Unreserved 5 items due to cancellation	ผู้ทดสอบ TEST	2026-03-09 14:38:57.533975
24	1	2026-03-09 07:39:53.017	ISSUE_APPROVED	0	1	35.00	35.00	99	3465.00	InventoryIssue	4	ISS-1773041993017	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-09 14:39:53.01793
25	211	2026-03-10 13:16:41.994388	REQUISITION_RESERVE	0	0	15.00	0.00	24	360.00	InventoryRequisition	10	REQ-1773123276560	\N	กลุ่มงานบริหารทั่วไป	Reserved 20 items	\N	2026-03-10 13:16:41.994388
26	227	2026-03-10 13:16:41.994388	REQUISITION_RESERVE	0	0	1350.00	0.00	7	9450.00	InventoryRequisition	10	REQ-1773123276560	\N	กลุ่มงานบริหารทั่วไป	Reserved 5 items	\N	2026-03-10 13:16:41.994388
27	223	2026-03-10 13:16:41.994388	REQUISITION_RESERVE	0	0	2000.00	0.00	2	4000.00	InventoryRequisition	10	REQ-1773123276560	\N	กลุ่มงานบริหารทั่วไป	Reserved 2 items	\N	2026-03-10 13:16:41.994388
28	211	2026-03-10 06:22:46.822	ISSUE_APPROVED	0	20	15.00	300.00	4	60.00	InventoryIssue	5	ISS-1773123766822	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-10 13:22:46.821769
29	227	2026-03-10 06:22:46.822	ISSUE_APPROVED	0	4	1350.00	5400.00	3	4050.00	InventoryIssue	5	ISS-1773123766822	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-10 13:22:46.821769
30	223	2026-03-10 06:22:46.822	ISSUE_APPROVED	0	2	2000.00	4000.00	0	0.00	InventoryIssue	5	ISS-1773123766822	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-10 13:22:46.821769
31	227	2026-03-10 13:24:19.242484	REQUISITION_UNRESERVE	0	0	1350.00	0.00	3	4050.00	InventoryRequisition	10	REQ-1773123276560	\N	กลุ่มงานบริหารทั่วไป	Unreserved 1 items due to cancellation	\N	2026-03-10 13:24:19.242484
32	4	2026-03-10 06:24:47.168	ISSUE_APPROVED	0	1	850.00	850.00	5	4250.00	InventoryIssue	6	ISS-1773123887168	\N	กลุ่มงานบริหารทั่วไป	\N	warehouse-admin	2026-03-10 13:24:47.169769
33	229	2026-03-13 00:00:00	PURCHASE_APPROVAL_RECEIPT	3	0	420.00	1260.00	3	1260.00	InventoryReceipt	11	REC2026000300	กลุ่มงานบริหารทั่วไป	\N	Test receipt from frontend	FRONTEND_TEST	2026-03-13 02:51:55.309857
\.


--
-- Data for Name: inventory_period; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_period (id, period_year, period_month, status, closed_at, closed_by, created_at) FROM stdin;
\.


--
-- Data for Name: inventory_period_balance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_period_balance (id, period_id, inventory_item_id, opening_qty, opening_value, closing_qty, closing_value) FROM stdin;
\.


--
-- Data for Name: inventory_receipt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_receipt (id, receipt_no, receipt_date, receipt_type, status, vendor_name, source_reference_type, source_reference_id, source_reference_no, note, created_by, approved_by, created_at, updated_at) FROM stdin;
1	IR-1772876873516	2026-03-07 09:47:53.516	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1218	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 16:47:53.514728	2026-03-07 16:47:53.514728
2	IR-1772878762146	2026-03-07 10:19:22.146	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1217	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 17:19:22.144226	2026-03-07 17:19:22.144226
3	IR-1772879297100	2026-03-07 10:28:17.1	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1216	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 17:28:17.098202	2026-03-07 17:28:17.098202
4	IR-1772880812451	2026-03-07 10:53:32.451	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1215	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 17:53:32.450051	2026-03-07 17:53:32.450051
5	IR-1772881446558	2026-03-07 11:04:06.558	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1214	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 18:04:06.555924	2026-03-07 18:04:06.555924
6	IR-1772882251847	2026-03-07 11:17:31.847	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1212	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 18:17:31.840867	2026-03-07 18:17:31.840867
7	IR-1772882962612	2026-03-07 11:29:22.612	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1083	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 18:29:22.602531	2026-03-07 18:29:22.602531
8	IR-1772882976726	2026-03-07 11:29:36.726	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1211	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-07 18:29:36.711476	2026-03-07 18:29:36.711476
9	IR-1773039547618	2026-03-09 06:59:07.619	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1213	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-09 13:59:07.611971	2026-03-09 13:59:07.611971
10	IR-1773041850195	2026-03-09 07:37:30.195	FROM_PURCHASE_APPROVAL	POSTED	\N	PurchaseApproval	1204	พล 0733.301/ พิเศษ	Auto receipt from PurchaseApproval พล 0733.301/ พิเศษ	\N	\N	2026-03-09 14:37:30.189301	2026-03-09 14:37:30.189301
11	REC2026000300	2026-03-13 00:00:00	FROM_PURCHASE_APPROVAL	POSTED	Test Vendor	PurchaseApprovalDetail	2	APV2026000300	Test receipt from frontend	FRONTEND_TEST	\N	2026-03-13 02:51:55.309857	2026-03-13 02:51:55.309857
\.


--
-- Data for Name: inventory_receipt_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_receipt_item (id, receipt_id, inventory_item_id, purchase_approval_id, qty, unit_cost, total_cost, lot_no, expiry_date) FROM stdin;
1	11	229	2	3	420.00	1260.00	\N	\N
\.


--
-- Data for Name: inventory_requisition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_requisition (id, requisition_no, request_date, requesting_department, status, requested_by, approved_by, approved_at, issued_by, issued_at, note, created_at, updated_at, requesting_department_code) FROM stdin;
2	REQ-1772878821224	2026-03-07 10:20:21.224	กลุ่มงานบริหารทั่วไป	ISSUED	Chrome MCP Tester	Chrome MCP Tester	2026-03-07 17:20:28.030484	warehouse-admin	2026-03-07 17:20:55.832108	\N	2026-03-07 17:20:21.225435	2026-03-07 17:20:55.832108	0001
3	REQ-1772879277656	2026-03-07 10:27:57.656	กลุ่มงานบริหารทั่วไป	CANCELLED	Final QA	Admin	2026-03-07 17:46:04.360453	\N	\N	Cancelled by Admin: Testing cancellation functionality	2026-03-07 17:27:57.655035	2026-03-07 17:46:24.429834	0001
6	REQ-1773039629252	2026-03-09 07:00:29.252	กลุ่มงานบริหารทั่วไป	ISSUED	chrome-mcp-test	chrome-mcp-test	2026-03-09 14:00:49.718026	warehouse-admin	2026-03-09 14:01:35.338289	\N	2026-03-09 14:00:29.252755	2026-03-09 14:01:35.338289	0001
5	REQ-1772882639640	2026-03-07 11:23:59.64	กลุ่มงานบริหารทั่วไป	CANCELLED	\N	\N	2026-03-07 18:31:01.286754	\N	\N	Cancelled by System	2026-03-07 18:23:59.640893	2026-03-09 14:03:03.873062	0001
7	REQ-1773040521512	2026-03-09 07:15:21.512	กลุ่มงานบริหารทั่วไป	CANCELLED	test-user	test-approver	2026-03-09 14:15:48.631119	\N	\N	Cancelled by test-user: MCP test cancel	2026-03-09 14:15:21.513147	2026-03-09 14:15:53.577616	0001
8	REQ-1773041913295	2026-03-09 07:38:33.295	กลุ่มงานบริหารทั่วไป	CANCELLED	ผู้ทดสอบ TEST	ผู้ทดสอบ TEST	2026-03-09 14:38:42.061156	\N	\N	Cancelled by ผู้ทดสอบ TEST	2026-03-09 14:38:33.296012	2026-03-09 14:38:57.533975	0001
1	REQ-1772876918097	2026-03-07 09:48:38.097	กลุ่มงานบริหารทั่วไป	ISSUED	warehouse-e2e	warehouse-e2e	2026-03-07 16:48:46.130618	warehouse-admin	2026-03-09 14:39:53.01793	\N	2026-03-07 16:48:38.098043	2026-03-09 14:39:53.01793	0001
9	REQ-1773112176498	2026-03-10 03:09:36.498	กลุ่มงานบริหารทั่วไป	CANCELLED	\N	\N	\N	\N	\N	Cancelled by System	2026-03-10 10:09:36.49971	2026-03-10 10:10:08.637745	0001
10	REQ-1773123276560	2026-03-10 06:14:36.56	กลุ่มงานบริหารทั่วไป	CANCELLED	\N	\N	2026-03-10 13:16:41.994388	warehouse-admin	2026-03-10 13:22:46.821769	Cancelled by System	2026-03-10 13:14:36.563138	2026-03-10 13:24:19.242484	0001
4	REQ-1772881083435	2026-03-07 10:58:03.435	กลุ่มงานบริหารทั่วไป	ISSUED	Test User	Test User	2026-03-07 17:58:31.161224	warehouse-admin	2026-03-10 13:24:47.169769	\N	2026-03-07 17:58:03.435709	2026-03-10 13:24:47.169769	0001
\.


--
-- Data for Name: inventory_requisition_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_requisition_item (id, requisition_id, inventory_item_id, requested_qty, approved_qty, issued_qty, unit_cost_at_issue, line_status, note) FROM stdin;
2	2	2	1	1	1	0.00	ISSUED	\N
3	3	2	1	1	0	0.00	CANCELLED	\N
6	6	8	1	1	1	0.00	ISSUED	\N
5	5	6	1	1	0	0.00	CANCELLED	\N
7	7	8	1	1	0	0.00	CANCELLED	test
8	8	9	5	5	0	0.00	CANCELLED	\N
1	1	1	1	1	1	0.00	ISSUED	\N
9	9	217	1	0	0	0.00	CANCELLED	\N
10	9	218	1	0	0	0.00	CANCELLED	\N
11	10	211	20	20	20	0.00	CANCELLED	\N
12	10	227	5	5	4	0.00	CANCELLED	\N
13	10	223	2	2	2	0.00	CANCELLED	\N
4	4	4	2	2	2	0.00	ISSUED	\N
\.


--
-- Data for Name: inventory_warehouse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_warehouse (id, warehouse_code, warehouse_name, is_active, created_at, updated_at) FROM stdin;
1	MAIN	คลังกลาง	t	2026-03-07 16:11:02.414296	2026-03-07 16:11:02.414296
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, code, category, name, type, subtype, unit, cost_price, sell_price, stock_balance, stock_value, seller_code, image, flag_activate, admin_note) FROM stdin;
20	P230-000020	วัสดุใช้ไป	คีย์บอร์ด แบบ USB	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	320.00	\N	0	0.00	\N	\N	t	\N
21	P230-000021	วัสดุใช้ไป	ซองใส่ CD แบบใส (50 ซอง/แพค)	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	แพค	70.00	\N	0	0.00	\N	\N	t	\N
22	P230-000022	วัสดุใช้ไป	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ300	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	170.00	\N	0	0.00	\N	\N	t	\N
23	P230-000023	วัสดุใช้ไป	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ310	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	150.00	\N	0	0.00	\N	\N	t	\N
1	P230-000001	วัสดุใช้ไป	ขวาน ชนิดเหล็ก แบบด้ามไม้	วัสดุการเกษตร	วัสดุการเกษตร	อัน	200.00	\N	0	0.00	\N	\N	t	\N
2	P230-000002	วัสดุใช้ไป	ด้ามขวาน ชนิดไม้	วัสดุการเกษตร	วัสดุการเกษตร	อัน	100.00	\N	0	0.00	\N	\N	t	\N
3	P230-000003	วัสดุใช้ไป	ประกับ สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	230.00	\N	0	0.00	\N	\N	t	\N
4	P230-000004	วัสดุใช้ไป	มีด ชนิดเหล็ก แบบด้ามไม้	วัสดุการเกษตร	วัสดุการเกษตร	เล่ม	250.00	\N	0	0.00	\N	\N	t	\N
5	P230-000005	วัสดุใช้ไป	สายเอ็น สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	ม้วน	630.00	\N	0	0.00	\N	\N	t	\N
6	P230-000006	วัสดุใช้ไป	เข่ง ไม้ไผ่	วัสดุการเกษตร	วัสดุการเกษตร	ใบ	120.00	\N	0	0.00	\N	\N	t	\N
7	P230-000007	วัสดุใช้ไป	ครัช สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	680.00	\N	0	0.00	\N	\N	t	\N
8	P230-000008	วัสดุใช้ไป	ถ้วยรองใบมีด สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	480.00	\N	0	0.00	\N	\N	t	\N
9	P230-000009	วัสดุใช้ไป	จานรองประกับใบตัด สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	70.00	\N	0	0.00	\N	\N	t	\N
10	P230-000010	วัสดุใช้ไป	จานสตาร์ท สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	350.00	\N	0	0.00	\N	\N	t	\N
11	P230-000011	วัสดุใช้ไป	ลูกยางกดน้ำมัน สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	ลูก	50.00	\N	0	0.00	\N	\N	t	\N
12	P230-000012	วัสดุใช้ไป	โซ่ สำหรับเลื่อยยนต์ ขนาด 11.5 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เส้น	630.00	\N	0	0.00	\N	\N	t	\N
13	P230-000013	วัสดุใช้ไป	กรรไกร ชนิดตัดต้นไม้ต่ำ สำหรับตัดแต่งกิ่ง	วัสดุการเกษตร	วัสดุการเกษตร	อัน	300.00	\N	0	0.00	\N	\N	t	\N
14	P230-000014	วัสดุใช้ไป	จาระบี สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	กระปุก	120.00	\N	0	0.00	\N	\N	t	\N
15	P230-000015	วัสดุใช้ไป	ใบมีด สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	100.00	\N	0	0.00	\N	\N	t	\N
16	P230-000016	วัสดุใช้ไป	เลื่อย ชนิดขอชัก สำหรับตัดแต่งกิ่ง	วัสดุการเกษตร	วัสดุการเกษตร	อัน	300.00	\N	0	0.00	\N	\N	t	\N
17	P230-000017	วัสดุใช้ไป	สายยาง สำหรับรดน้ำต้นไม้ ขนาด 5/8 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เส้น	360.00	\N	0	0.00	\N	\N	t	\N
18	P230-000018	วัสดุใช้ไป	สายสะพาย สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	160.00	\N	0	0.00	\N	\N	t	\N
19	P230-000019	วัสดุใช้ไป	หัวเทียน สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	30.00	\N	0	0.00	\N	\N	t	\N
25	P230-000025	วัสดุใช้ไป	เม้าท์ แบบ USB	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	250.00	\N	0	0.00	\N	\N	t	\N
26	P230-000026	วัสดุใช้ไป	สาย LAN	หหห	หห	ห	0.00	\N	0	0.00	\N	\N	t	\N
39	P230-000039	วัสดุใช้ไป	ยกเลิก หมึก Printer Ink jet T7741 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	700.00	\N	0	0.00	\N	\N	f	\N
40	P230-000040	วัสดุใช้ไป	หมึก Printer Laser 107A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	990.00	\N	0	0.00	\N	\N	t	\N
41	P230-000041	วัสดุใช้ไป	หมึก Printer Laser 225	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	430.00	\N	0	0.00	\N	\N	t	\N
43	P230-000043	วัสดุใช้ไป	หมึก Printer Laser 355	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	670.00	\N	0	0.00	\N	\N	t	\N
45	P230-000045	วัสดุใช้ไป	หมึก Printer Laser 48A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1190.00	\N	0	0.00	\N	\N	t	\N
46	P230-000046	วัสดุใช้ไป	หมึก Printer Laser 79A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	690.00	\N	0	0.00	\N	\N	t	\N
48	P230-000048	วัสดุใช้ไป	หมึก Printer Laser 85A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	390.00	\N	0	0.00	\N	\N	t	\N
50	P230-000050	วัสดุใช้ไป	ยกเลิก หมึก Printer Laser TN-2060	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	490.00	\N	0	0.00	\N	\N	f	\N
51	P230-000051	วัสดุใช้ไป	หัว LAN	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1400.00	\N	0	0.00	\N	\N	t	\N
52	P230-000052	วัสดุใช้ไป	ยกเลิก Hardisk ชนิด SATA/SSD External ขนาด 1 Tb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1800.00	\N	0	0.00	\N	\N	f	\N
53	P230-000053	วัสดุใช้ไป	ยกเลิก Hardisk ชนิด Surveillance สำหรับกล้องวงจรปิด (NVR) ขนาด 4 Tb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	3790.00	\N	0	0.00	\N	\N	f	\N
54	P230-000054	วัสดุใช้ไป	ยกเลิก สาย LAN ชนิด CAT5 ขนาด 305 เมตร/กล่อง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	2750.00	\N	0	0.00	\N	\N	f	\N
55	P230-000055	วัสดุใช้ไป	ยกเลิก หมึก Printer Laser 230A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	890.00	\N	0	0.00	\N	\N	f	\N
56	P230-000056	วัสดุใช้ไป	ยกเลิก หัว LAN ชนิด CAT5 10 อัน/pack	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	pack	60.00	\N	0	0.00	\N	\N	f	\N
414	P230-000414	วัสดุใช้ไป	สายไมค์ แบบพร้อมแจ๊ค	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	155.00	\N	0	0.00	\N	\N	t	\N
58	P230-000058	วัสดุใช้ไป	หมึก Printer Ink jet Epson 003 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N
61	P230-000061	วัสดุใช้ไป	กรวยกระดาษ สำหรับดื่มน้ำ ขนาดบรรจุ 5,000 ใบ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ลัง	900.00	\N	0	0.00	\N	\N	t	\N
64	P230-000064	วัสดุใช้ไป	กระดาษเช็ดมือ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	60.00	\N	0	0.00	\N	\N	t	\N
65	P230-000065	วัสดุใช้ไป	กระทะไฟฟ้า แบบเคลือบและมีซึ้ง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	1290.00	\N	0	0.00	\N	\N	t	\N
66	P230-000066	วัสดุใช้ไป	กระป๋องฉีดน้ำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	35.00	\N	0	0.00	\N	\N	t	\N
67	P230-000067	วัสดุใช้ไป	กล่องใส่กระดาษเช็ดมือ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	500.00	\N	0	0.00	\N	\N	t	\N
68	P230-000068	วัสดุใช้ไป	กล่องใส่สบู่เหลว แบบติดผนัง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	300.00	\N	0	0.00	\N	\N	t	\N
70	P230-000070	วัสดุใช้ไป	เกลือเม็ด	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	12.00	\N	0	0.00	\N	\N	t	\N
72	P230-000072	วัสดุใช้ไป	แก้วน้ำ ชนิดพลาสติก ขนาด 4 ออนซ์	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1.00	\N	0	0.00	\N	\N	t	\N
75	P230-000075	วัสดุใช้ไป	ขวดปั๊ม ชนิดพลาสติก สำหรับใส่น้ำยาแอลกอฮอล์	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	40.00	\N	0	0.00	\N	\N	t	\N
77	P230-000077	วัสดุใช้ไป	ข่า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N
78	P230-000078	วัสดุใช้ไป	ขิง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N
81	P230-000081	วัสดุใช้ไป	ด้ามมีดโกน ชนิดพลาสติก แบบปลี่ยนใบมีดได้	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	50.00	\N	0	0.00	\N	\N	t	\N
83	P230-000083	วัสดุใช้ไป	ตะกร้า ชนิดพลาสติก แบบทรงกลม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	250.00	\N	0	0.00	\N	\N	t	\N
823	P230-000823	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 17 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	155.00	\N	0	0.00	\N	\N	t	\N
84	P230-000084	วัสดุใช้ไป	ตะไคร้	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	50.00	\N	0	0.00	\N	\N	t	\N
85	P230-000085	วัสดุใช้ไป	เตา Hotplate แบบใช้ไฟฟ้า ขนาด 9 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตัว	4000.00	\N	0	0.00	\N	\N	t	\N
86	P230-000086	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 42 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	890.00	\N	0	0.00	\N	\N	t	\N
91	P230-000091	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 18*22 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N
96	P230-000096	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 16*18 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N
97	P230-000097	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 28*40 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N
102	P230-000102	วัสดุใช้ไป	ถุงมือ ชนิด PVC	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N
104	P230-000104	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ M	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	120.00	\N	0	0.00	\N	\N	t	\N
105	P230-000105	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L สีเขียว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	120.00	\N	0	0.00	\N	\N	t	\N
108	P230-000108	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบอเนกประสงค์ เบอร์ L	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N
109	P230-000109	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบอเนกประสงค์ เบอร์ M	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N
110	P230-000110	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 30*40 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	120.00	\N	0	0.00	\N	\N	t	\N
117	P230-000117	วัสดุใช้ไป	น้ำมันงาสกัดเย็น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	300.00	\N	0	0.00	\N	\N	t	\N
118	P230-000118	วัสดุใช้ไป	น้ำมันมะพร้าว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	90.00	\N	0	0.00	\N	\N	t	\N
120	P230-000120	วัสดุใช้ไป	น้ำยา สำหรับซาวผ้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	250.00	\N	0	0.00	\N	\N	t	\N
126	P230-000126	วัสดุใช้ไป	ใบมะกรูด	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	50.00	\N	0	0.00	\N	\N	t	\N
134	P230-000134	วัสดุใช้ไป	แปรง ชนิดพลาสติก สำหรับล้างขวด	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	25.00	\N	0	0.00	\N	\N	t	\N
136	P230-000136	วัสดุใช้ไป	ผงซักฟอก สำหรับเครื่องซักผ้า ขนาด 25 กก.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กก.	1050.00	\N	0	0.00	\N	\N	t	\N
137	P230-000137	วัสดุใช้ไป	ผ้าม็อบ สำหรับดันฝุ่น ขนาด 24 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	200.00	\N	0	0.00	\N	\N	t	\N
140	P230-000140	วัสดุใช้ไป	แผ่นขัดพื้น ขนาด 18 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	400.00	\N	0	0.00	\N	\N	t	\N
142	P230-000142	วัสดุใช้ไป	ไพล	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	35.00	\N	0	0.00	\N	\N	t	\N
143	P230-000143	วัสดุใช้ไป	ฟองน้ำ แบบหุ้มตาข่าย	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	15.00	\N	0	0.00	\N	\N	t	\N
144	P230-000144	วัสดุใช้ไป	ฟอยล์ ขนาด 18 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	85.00	\N	0	0.00	\N	\N	t	\N
145	P230-000145	วัสดุใช้ไป	ไฟแช็ค	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	10.00	\N	0	0.00	\N	\N	t	\N
146	P230-000146	วัสดุใช้ไป	มะกรูด	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	40.00	\N	0	0.00	\N	\N	t	\N
147	P230-000147	วัสดุใช้ไป	มะนาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	100.00	\N	0	0.00	\N	\N	t	\N
160	P230-000160	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 10.5 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
187	P230-000187	วัสดุใช้ไป	ผ้าปูที่นอน (ยกเลิก)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	400.00	\N	0	0.00	\N	\N	f	\N
166	P230-000166	วัสดุใช้ไป	รองเท้า ชนิดฟองน้ำ เบอร์ 11.5	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N
173	P230-000173	วัสดุใช้ไป	สก็อตไบร์ท แบบแผ่นใหญ่ ขนาด 6*9 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แผ่น	30.00	\N	0	0.00	\N	\N	t	\N
176	P230-000176	วัสดุใช้ไป	สเปรย์ ชนิดสูตรน้ำ สำหรับฉีดมด ยุง ขนาด 300 มล.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	65.00	\N	0	0.00	\N	\N	t	\N
179	P230-000179	วัสดุใช้ไป	หม้อทะนน	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	15.00	\N	0	0.00	\N	\N	t	\N
180	P230-000180	วัสดุใช้ไป	หม้อหุงข้าว แบบใช้ไฟฟ้า ขนาด 3.8 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	2100.00	\N	0	0.00	\N	\N	t	\N
181	P230-000181	วัสดุใช้ไป	หม้อหุงข้าว แบบใช้ไฟฟ้า ขนาด 5 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	2500.00	\N	0	0.00	\N	\N	t	\N
182	P230-000182	วัสดุใช้ไป	หอมแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	80.00	\N	0	0.00	\N	\N	t	\N
185	P230-000185	วัสดุใช้ไป	กระจกเงา สำหรับแต่งตัว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	บาน	1990.00	\N	0	0.00	\N	\N	t	\N
186	P230-000186	วัสดุใช้ไป	เครื่องพ่นยา แบบใช้แบตเตอรี่ ขนาด 18 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	990.00	\N	0	0.00	\N	\N	t	\N
188	P230-000188	วัสดุใช้ไป	เต๊นท์ผ้าใบ แบบโค้งพร้อมโครงเหล็ก ขนาด 4*8 เมตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หลัง	24500.00	\N	0	0.00	\N	\N	t	\N
189	P230-000189	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก สำหรับขยะติดเชื้อ แบบฝาเรียบ ขนาด 240 ลิตร สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	2390.00	\N	0	0.00	\N	\N	t	\N
190	P230-000190	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก สำหรับขยะติดเชื้อ แบบช่องทิ้ง ขนาด 240 ลิตร สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	2190.00	\N	0	0.00	\N	\N	t	\N
191	P230-000191	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 10 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	295.00	\N	0	0.00	\N	\N	t	\N
192	P230-000192	วัสดุใช้ไป	ถังน้ำ ชนิดพลาสติก แบบมีฝา สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	395.00	\N	0	0.00	\N	\N	t	\N
193	P230-000193	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	39.00	\N	0	0.00	\N	\N	t	\N
194	P230-000194	วัสดุใช้ไป	ที่นอน ชนิดฟองน้ำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หลัง	1400.00	\N	0	0.00	\N	\N	t	\N
195	P230-000195	วัสดุใช้ไป	แทงค์น้ำ ขนาด 1000 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	4690.00	\N	0	0.00	\N	\N	t	\N
196	P230-000196	วัสดุใช้ไป	ผ้าปูที่นอน	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	299.00	\N	0	0.00	\N	\N	t	\N
197	P230-000197	วัสดุใช้ไป	ผ้าห่ม ขนาด 150 x 200 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	178.00	\N	0	0.00	\N	\N	t	\N
198	P230-000198	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 10	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
199	P230-000199	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 10.5	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
200	P230-000200	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 11	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
201	P230-000201	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 11.5	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
202	P230-000202	วัสดุใช้ไป	ราวตากผ้า ชนิดอลูมีเนียม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	950.00	\N	0	0.00	\N	\N	t	\N
203	P230-000203	วัสดุใช้ไป	หมอน ขนาด 19 x 29 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	190.00	\N	0	0.00	\N	\N	t	\N
204	P230-000204	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 24*42 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	240.00	\N	0	0.00	\N	\N	t	\N
205	P230-000205	วัสดุใช้ไป	พรมเช็ดเท้า ขนาด 40*60 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	370.00	\N	0	0.00	\N	\N	t	\N
206	P230-000206	วัสดุใช้ไป	พรมเช็ดเท้า แบบดักฝุ่น ขนาด 50*120 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	590.00	\N	0	0.00	\N	\N	t	\N
207	P230-000207	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	250.00	\N	0	0.00	\N	\N	t	\N
208	P230-000208	วัสดุใช้ไป	สายฉีดชำระ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	150.00	\N	0	0.00	\N	\N	t	\N
209	P230-000209	วัสดุใช้ไป	กล่องลอย ชนิดพลาสติก ขนาด 2*4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	19.00	\N	0	0.00	\N	\N	t	\N
210	P230-000210	วัสดุใช้ไป	กลอนประตู ชนิดสแตนเลส ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	11.00	\N	0	0.00	\N	\N	t	\N
211	P230-000211	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	550.00	\N	0	0.00	\N	\N	t	\N
212	P230-000212	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบเดี่ยว ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	680.00	\N	0	0.00	\N	\N	t	\N
237	P230-000237	วัสดุใช้ไป	ตะปู ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขีด	10.00	\N	0	0.00	\N	\N	t	\N
213	P230-000213	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N
214	P230-000214	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบบอล ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	85.00	\N	0	0.00	\N	\N	t	\N
215	P230-000215	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับฝักบัว ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N
216	P230-000216	วัสดุใช้ไป	ยกเลิก ก๊อกน้ำ ชนิดทองเหลือง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	120.00	\N	0	0.00	\N	\N	f	\N
217	P230-000217	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบสนาม ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	165.00	\N	0	0.00	\N	\N	t	\N
218	P230-000218	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่าง แบบเดี่ยว ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	650.00	\N	0	0.00	\N	\N	t	\N
219	P230-000219	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างจาน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	290.00	\N	0	0.00	\N	\N	t	\N
220	P230-000220	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างหน้า ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	450.00	\N	0	0.00	\N	\N	t	\N
221	P230-000221	วัสดุใช้ไป	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 250 กรัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระปุก	176.00	\N	0	0.00	\N	\N	t	\N
222	P230-000222	วัสดุใช้ไป	กุญแจ ชนิดทองเหลือง แบบคล้อง คอยาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	66.00	\N	0	0.00	\N	\N	t	\N
223	P230-000223	วัสดุใช้ไป	กุญแจ ชนิดทองเหลือง แบบคล้อง ขนาด 38 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	105.00	\N	0	0.00	\N	\N	t	\N
224	P230-000224	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N
225	P230-000225	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	13.00	\N	0	0.00	\N	\N	t	\N
226	P230-000226	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	19.00	\N	0	0.00	\N	\N	t	\N
227	P230-000227	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา เกลียวนอก ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	14.00	\N	0	0.00	\N	\N	t	\N
228	P230-000228	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา เกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	13.00	\N	0	0.00	\N	\N	t	\N
229	P230-000229	วัสดุใช้ไป	ข้องอ ชนิดทองเหลือง แบบ 90 องศา	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	38.00	\N	0	0.00	\N	\N	t	\N
230	P230-000230	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	15.00	\N	0	0.00	\N	\N	t	\N
231	P230-000231	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	7.00	\N	0	0.00	\N	\N	t	\N
232	P230-000232	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N
233	P230-000233	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 3/4 * 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N
234	P230-000234	วัสดุใช้ไป	ขายึด ชนิดเหล็ก สำหรับแขวนโทรทัศน์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	990.00	\N	0	0.00	\N	\N	t	\N
235	P230-000235	วัสดุใช้ไป	ไขควง แบบกลม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	50.00	\N	0	0.00	\N	\N	t	\N
236	P230-000236	วัสดุใช้ไป	ตะไบ ชนิดแบน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	140.00	\N	0	0.00	\N	\N	t	\N
238	P230-000238	วัสดุใช้ไป	เต้ารับ ชนิด 3 ขา แบบคู่	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	85.00	\N	0	0.00	\N	\N	t	\N
239	P230-000239	วัสดุใช้ไป	โถส้วม แบบนั่งยอง ไม่มีฐาน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชด	730.00	\N	0	0.00	\N	\N	t	\N
240	P230-000240	วัสดุใช้ไป	ทราย ชนิดหยาบ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คิว	308.00	\N	0	0.00	\N	\N	t	\N
241	P230-000241	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	100.00	\N	0	0.00	\N	\N	t	\N
242	P230-000242	วัสดุใช้ไป	ชุดน้ำทิ้ง แบบกระปุก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	199.00	\N	0	0.00	\N	\N	t	\N
243	P230-000243	วัสดุใช้ไป	ท่อย่น ชนิดพลาสติก แบบ 2 in 1	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	135.00	\N	0	0.00	\N	\N	t	\N
244	P230-000244	วัสดุใช้ไป	ชุดกดชักโครก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	132.00	\N	0	0.00	\N	\N	t	\N
245	P230-000245	วัสดุใช้ไป	เทป สำหรับพันเกลียว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	17.00	\N	0	0.00	\N	\N	t	\N
246	P230-000246	วัสดุใช้ไป	น๊อต สำหรับหัวฝา ขนาด 1/2*1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	2.50	\N	0	0.00	\N	\N	t	\N
247	P230-000247	วัสดุใช้ไป	น้ำกลั่นแบตเตอรี่ สำหรับแบตเตอรี่ ขนาด 1 ลิตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขวด	25.00	\N	0	0.00	\N	\N	t	\N
248	P230-000248	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC แบบสวม ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	135.00	\N	0	0.00	\N	\N	t	\N
249	P230-000249	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	44.00	\N	0	0.00	\N	\N	t	\N
250	P230-000250	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	72.00	\N	0	0.00	\N	\N	t	\N
251	P230-000251	วัสดุใช้ไป	บอลวาล์ว ชนิดเหล็ก แบบเกลียวนอก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	105.00	\N	0	0.00	\N	\N	t	\N
252	P230-000252	วัสดุใช้ไป	บานพับ แบบผีเสื้อ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	22.00	\N	0	0.00	\N	\N	t	\N
253	P230-000253	วัสดุใช้ไป	ปูน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	130.00	\N	0	0.00	\N	\N	t	\N
254	P230-000254	วัสดุใช้ไป	ฝักบัวอาบน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N
255	P230-000255	วัสดุใช้ไป	ฝาครอบ ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	7.00	\N	0	0.00	\N	\N	t	\N
256	P230-000256	วัสดุใช้ไป	พุก ชนิดเหล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	8.00	\N	0	0.00	\N	\N	t	\N
257	P230-000257	วัสดุใช้ไป	มือกดน้ำ แบบด้านข้าง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N
258	P230-000258	วัสดุใช้ไป	ไม้อัด หนา 10 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	517.00	\N	0	0.00	\N	\N	t	\N
259	P230-000259	วัสดุใช้ไป	ราวพาดผ้า	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	85.00	\N	0	0.00	\N	\N	t	\N
260	P230-000260	วัสดุใช้ไป	ลวด สำหรับผูกเหล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	132.00	\N	0	0.00	\N	\N	t	\N
261	P230-000261	วัสดุใช้ไป	ลูกบิด สำหรับห้องน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	220.00	\N	0	0.00	\N	\N	t	\N
262	P230-000262	วัสดุใช้ไป	ลูกลอย ชนิดงอ สำหรับแท๊งค์น้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	320.00	\N	0	0.00	\N	\N	t	\N
263	P230-000263	วัสดุใช้ไป	ล้อรถเข็น แบบสกรูคู่ ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	55.00	\N	0	0.00	\N	\N	t	\N
264	P230-000264	วัสดุใช้ไป	วาล์ว แบบครบชุด	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	359.00	\N	0	0.00	\N	\N	t	\N
1206	P230-001206	วัสดุใช้ไป	คาปาซิเตอร์ ขนาด 16UF 450V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	430.00	\N	0	0.00	\N	\N	t	\N
265	P230-000265	วัสดุใช้ไป	วาล์ว สำหรับฝักบัว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	399.00	\N	0	0.00	\N	\N	t	\N
266	P230-000266	วัสดุใช้ไป	สะดืออ่าง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	45.00	\N	0	0.00	\N	\N	t	\N
267	P230-000267	วัสดุใช้ไป	สายฉีดชำระ แบบชุดเล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	150.00	\N	0	0.00	\N	\N	t	\N
268	P230-000268	วัสดุใช้ไป	สายน้ำดี ขนาด 18 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	60.00	\N	0	0.00	\N	\N	t	\N
269	P230-000269	วัสดุใช้ไป	สายน้ำดี ขนาด 20 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	60.00	\N	0	0.00	\N	\N	t	\N
270	P230-000270	วัสดุใช้ไป	สายน้ำดี ขนาด 24 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	65.00	\N	0	0.00	\N	\N	t	\N
271	P230-000271	วัสดุใช้ไป	สายน้ำดี ขนาด 40 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	90.00	\N	0	0.00	\N	\N	t	\N
272	P230-000272	วัสดุใช้ไป	สายฝักบัว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N
273	P230-000273	วัสดุใช้ไป	สายยู ชนิดเหล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	17.00	\N	0	0.00	\N	\N	t	\N
274	P230-000274	วัสดุใช้ไป	สายยู ชนิดสแตนเลส	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	28.00	\N	0	0.00	\N	\N	t	\N
275	P230-000275	วัสดุใช้ไป	สีสเปรย์ สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	65.00	\N	0	0.00	\N	\N	t	\N
276	P230-000276	วัสดุใช้ไป	หิน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คิว	572.00	\N	0	0.00	\N	\N	t	\N
277	P230-000277	วัสดุใช้ไป	หินคลุก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คิว	517.00	\N	0	0.00	\N	\N	t	\N
278	P230-000278	วัสดุใช้ไป	เหล็ก แบบกล่อง ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	418.00	\N	0	0.00	\N	\N	t	\N
279	P230-000279	วัสดุใช้ไป	เหล็ก แบบฉาก ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	572.00	\N	0	0.00	\N	\N	t	\N
280	P230-000280	วัสดุใช้ไป	เหล็ก แบบตัวซี ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	561.00	\N	0	0.00	\N	\N	t	\N
281	P230-000281	วัสดุใช้ไป	เหล็ก แบบเพลท ขนาด 4*4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	50.00	\N	0	0.00	\N	\N	t	\N
282	P230-000282	วัสดุใช้ไป	สต๊อปวาล์ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N
283	P230-000283	วัสดุใช้ไป	ล้อรถเข็น แบบเกลียว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	550.00	\N	0	0.00	\N	\N	t	\N
284	P230-000284	วัสดุใช้ไป	ฝาอุด ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	7.00	\N	0	0.00	\N	\N	t	\N
285	P230-000285	วัสดุใช้ไป	น้ำมันเอนกประสงค์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	115.00	\N	0	0.00	\N	\N	t	\N
286	P230-000286	วัสดุใช้ไป	สายน้ำดี ขนาด 22 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	72.00	\N	0	0.00	\N	\N	t	\N
287	P230-000287	วัสดุใช้ไป	โถส้วม แบบชักโครก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	2390.00	\N	0	0.00	\N	\N	t	\N
288	P230-000288	วัสดุใช้ไป	กุญแจ ชนิดทองเหลือง แบบคล้อง ขนาด 45 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	1045.00	\N	0	0.00	\N	\N	t	\N
289	P230-000289	วัสดุใช้ไป	เทอมินอล สำหรับต่อสาย	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	4.00	\N	0	0.00	\N	\N	t	\N
290	P230-000290	วัสดุใช้ไป	ทรอนิค	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N
291	P230-000291	วัสดุใช้ไป	ลูกเสียบยาง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	10.00	\N	0	0.00	\N	\N	t	\N
292	P230-000292	วัสดุใช้ไป	รางหลอดไฟ ชนิดทรอนิค สำหรับหลอด LED	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	155.00	\N	0	0.00	\N	\N	t	\N
293	P230-000293	วัสดุใช้ไป	น๊อต แบบธุบ ขนาด 7 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	25.00	\N	0	0.00	\N	\N	t	\N
294	P230-000294	วัสดุใช้ไป	น๊อต แบบธุบ ขนาด 8 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	30.00	\N	0	0.00	\N	\N	t	\N
295	P230-000295	วัสดุใช้ไป	แหวน ชนิดเหล็ก แบบเหลี่ยม ขนาด 5/8 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	5.00	\N	0	0.00	\N	\N	t	\N
296	P230-000296	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	60.00	\N	0	0.00	\N	\N	t	\N
297	P230-000297	วัสดุใช้ไป	ยกเลิก ข้องอ ชนิด PVC หนา แบบ 90 องศา ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	88.00	\N	0	0.00	\N	\N	f	\N
298	P230-000298	วัสดุใช้ไป	สามทาง ชนิด PVC แบบลด ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	55.00	\N	0	0.00	\N	\N	t	\N
299	P230-000299	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อ	230.00	\N	0	0.00	\N	\N	t	\N
300	P230-000300	วัสดุใช้ไป	ยูเนียน ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	165.00	\N	0	0.00	\N	\N	t	\N
301	P230-000301	วัสดุใช้ไป	ตะแกรงน้ำมัน ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	12.00	\N	0	0.00	\N	\N	t	\N
302	P230-000302	วัสดุใช้ไป	ดอกสว่าน ขนาด 1/8	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอก	28.00	\N	0	0.00	\N	\N	t	\N
303	P230-000303	วัสดุใช้ไป	ปูนขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	70.00	\N	0	0.00	\N	\N	t	\N
304	P230-000304	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	550.00	\N	0	0.00	\N	\N	t	\N
305	P230-000305	วัสดุใช้ไป	น้ำยา สำหรับกำจัดมด ปลวก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	132.00	\N	0	0.00	\N	\N	t	\N
306	P230-000306	วัสดุใช้ไป	ยกเลิก สายน้ำดี	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	55.00	\N	0	0.00	\N	\N	f	\N
307	P230-000307	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ต่อล่าง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	638.00	\N	0	0.00	\N	\N	t	\N
308	P230-000308	วัสดุใช้ไป	นิปเปิ้ล ชนิดทองเหลือง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	22.00	\N	0	0.00	\N	\N	t	\N
309	P230-000309	วัสดุใช้ไป	ยกเลิก มินิวาล์ว ชนิดทองเหลือง แบบ 3 ทาง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	154.00	\N	0	0.00	\N	\N	f	\N
310	P230-000310	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก แบบก้ามปู ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	6.00	\N	0	0.00	\N	\N	t	\N
311	P230-000311	วัสดุใช้ไป	เกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	10.00	\N	0	0.00	\N	\N	t	\N
312	P230-000312	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 45 องศา ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	10.00	\N	0	0.00	\N	\N	t	\N
313	P230-000313	วัสดุใช้ไป	อิฐแดง ขนาดเล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก้อน	1.00	\N	0	0.00	\N	\N	t	\N
314	P230-000314	วัสดุใช้ไป	ยกเลิก ฝาบิด	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	150.00	\N	0	0.00	\N	\N	f	\N
315	P230-000315	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 6 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อ	2050.00	\N	0	0.00	\N	\N	t	\N
316	P230-000316	วัสดุใช้ไป	เกรียง สำหรับก่ออิฐ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ด้าม	72.00	\N	0	0.00	\N	\N	t	\N
317	P230-000317	วัสดุใช้ไป	ยกเลิก สีน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	236.00	\N	0	0.00	\N	\N	f	\N
318	P230-000318	วัสดุใช้ไป	น้ำยาเคมีไข้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระปุก	105.00	\N	0	0.00	\N	\N	t	\N
319	P230-000319	วัสดุใช้ไป	กระดาษทราย ชนิดละเอียด เบอร์ xx	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	11.00	\N	0	0.00	\N	\N	t	\N
320	P230-000320	วัสดุใช้ไป	มินิวาล์ว ชนิดทองเหลือง แบบ 3 ทาง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	138.00	\N	0	0.00	\N	\N	t	\N
321	P230-000321	วัสดุใช้ไป	ซิลิโคน สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หลอด	132.00	\N	0	0.00	\N	\N	t	\N
322	P230-000322	วัสดุใช้ไป	กาว ชนิดร้อน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หลอด	28.00	\N	0	0.00	\N	\N	t	\N
323	P230-000323	วัสดุใช้ไป	สามทาง ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	8.00	\N	0	0.00	\N	\N	t	\N
324	P230-000324	วัสดุใช้ไป	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 50 กรัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	45.00	\N	0	0.00	\N	\N	t	\N
325	P230-000325	วัสดุใช้ไป	ใบเลื่อย	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ใบ	45.00	\N	0	0.00	\N	\N	t	\N
326	P230-000326	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อ	55.00	\N	0	0.00	\N	\N	t	\N
327	P230-000327	วัสดุใช้ไป	อะคริลิค สำหรับกันซึม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อ้น	2848.00	\N	0	0.00	\N	\N	t	\N
328	P230-000328	วัสดุใช้ไป	ตาข่าย ชนิดไฟเบอร์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	460.00	\N	0	0.00	\N	\N	t	\N
329	P230-000329	วัสดุใช้ไป	ยกเลิก ชุดน้ำทิ้ง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	898.00	\N	0	0.00	\N	\N	f	\N
330	P230-000330	วัสดุใช้ไป	แก๊ส ชนิดถัง สำหรับงานแพทย์แผนไทย ขนาด 15 กก.	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ถัง	380.00	\N	0	0.00	\N	\N	t	\N
331	P230-000331	วัสดุใช้ไป	แก๊ส ชนิดถัง สำหรับงานจ่ายกลาง ขนาด 48 กก.	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ถัง	1500.00	\N	0	0.00	\N	\N	t	\N
332	P230-000332	วัสดุใช้ไป	แก๊ส ชนิดถัง สำหรับงานโรงครัว ขนาด 48 กก.	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ถัง	1500.00	\N	0	0.00	\N	\N	t	\N
333	P230-000333	วัสดุใช้ไป	น้ำมันเชื้อเพลิง ชนิดเบนซินแก๊สโซฮอลล์ 91	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ลิตร	40.00	\N	0	0.00	\N	\N	t	\N
334	P230-000334	วัสดุใช้ไป	น้ำมันเชื้อเพลิง ชนิดเบนซินแก๊สโซฮอลล์ 95	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ลิตร	40.00	\N	0	0.00	\N	\N	t	\N
335	P230-000335	วัสดุใช้ไป	น้ำมันเครื่อง ชนิด 2T	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	กระป๋อง	150.00	\N	0	0.00	\N	\N	t	\N
336	P230-000336	วัสดุใช้ไป	น้ำมันเครื่อง ชนิด 4T	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	กระป๋อง	185.00	\N	0	0.00	\N	\N	t	\N
337	P230-000337	วัสดุใช้ไป	น้ำมันเครื่อง ชนิด 6T	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	กระป๋อง	960.00	\N	0	0.00	\N	\N	t	\N
338	P230-000338	วัสดุใช้ไป	น้ำมันเชื้อเพลิง ชนิดดีเซล	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ลิตร	40.00	\N	0	0.00	\N	\N	t	\N
339	P230-000339	วัสดุใช้ไป	น้ำมันเชื้อเพลิง ชนิดเบนซิน 95	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	ลิตร	40.00	\N	0	0.00	\N	\N	t	\N
340	P230-000340	วัสดุใช้ไป	น้ำมันเบรค ขนาด 500 มล.	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	กระป๋อง	295.00	\N	0	0.00	\N	\N	t	\N
341	P230-000341	วัสดุใช้ไป	น้ำดื่ม ชนิดบรรจุแกลลอน ขนาด 18 ลิตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ถัง	10.00	\N	0	0.00	\N	\N	t	\N
342	P230-000342	วัสดุใช้ไป	น้ำดื่ม ชนิดบรรจุขวด ขนาด 600 ซีซี	วัสดุสำนักงาน	วัสดุสำนักงาน	โหล	39.00	\N	0	0.00	\N	\N	t	\N
345	P230-000345	วัสดุใช้ไป	ถ่าน ชนิด Recharge ขนาด AA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	600.00	\N	0	0.00	\N	\N	t	\N
346	P230-000346	วัสดุใช้ไป	ถ่าน ชนิด Recharge ขนาด AAA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	600.00	\N	0	0.00	\N	\N	t	\N
354	P230-000354	วัสดุใช้ไป	แบตเตอรี่ แบบแห้ง สำหรับเครื่องสำรองไฟ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	1200.00	\N	0	0.00	\N	\N	t	\N
356	P230-000356	วัสดุใช้ไป	ปลั๊กไฟพ่วง แบบ 5 ช่อง 5 สวิตซ์ ยาว 3 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	410.00	\N	0	0.00	\N	\N	t	\N
357	P230-000357	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 18 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	100.00	\N	0	0.00	\N	\N	t	\N
358	P230-000358	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 22 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	155.00	\N	0	0.00	\N	\N	t	\N
359	P230-000359	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 9 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	110.00	\N	0	0.00	\N	\N	t	\N
360	P230-000360	วัสดุใช้ไป	Adaptor ขนาด 12V.	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	265.00	\N	0	0.00	\N	\N	t	\N
361	P230-000361	วัสดุใช้ไป	กล่องเบรคเกอร์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N
362	P230-000362	วัสดุใช้ไป	กล่องลอย ชนิดพลาสติก ขนาด 2*4 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N
363	P230-000363	วัสดุใช้ไป	กล่องลอย ชนิดพลาสติก ขนาด 4*4 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	18.00	\N	0	0.00	\N	\N	t	\N
364	P230-000364	วัสดุใช้ไป	ก้ามปู สำหรับล๊อคท่อ ขนาด 1/2 นิ้ว สีเหลือง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	5.00	\N	0	0.00	\N	\N	t	\N
365	P230-000365	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก สำหรับสายทีวี 3C	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N
366	P230-000366	วัสดุใช้ไป	ข้อต่อ ชนิดพลาสติก แบบโค้ง ขนาด 1/2 นิ้ว สีเหลือง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	8.00	\N	0	0.00	\N	\N	t	\N
367	P230-000367	วัสดุใช้ไป	ข้อต่อ ชนิดพลาสติก แบบโค้ง ขนาด 1/2 นิ้ว สีเหลือง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	6.00	\N	0	0.00	\N	\N	t	\N
368	P230-000368	วัสดุใช้ไป	ขาหลอดนีออน แบบครึ่งท่อน	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คู่	25.00	\N	0	0.00	\N	\N	t	\N
369	P230-000369	วัสดุใช้ไป	ขาหลอดนีออน แบบล๊อค	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คู่	25.00	\N	0	0.00	\N	\N	t	\N
370	P230-000370	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 10 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	110.00	\N	0	0.00	\N	\N	t	\N
371	P230-000371	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 15 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	160.00	\N	0	0.00	\N	\N	t	\N
372	P230-000372	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 6 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	50.00	\N	0	0.00	\N	\N	t	\N
373	P230-000373	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 8 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	60.00	\N	0	0.00	\N	\N	t	\N
374	P230-000374	วัสดุใช้ไป	ตะกั่วบัตกรี แบบปากกา ยาว 3 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	50.00	\N	0	0.00	\N	\N	t	\N
375	P230-000375	วัสดุใช้ไป	ตะปู สำหรับยิงฝ้า ขนาด 1*6 สีดำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	110.00	\N	0	0.00	\N	\N	t	\N
376	P230-000376	วัสดุใช้ไป	HDMI splitter ขนาด 8 port	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	1050.00	\N	0	0.00	\N	\N	t	\N
377	P230-000377	วัสดุใช้ไป	ตู้พลาสติก แบบกันน้ำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตู้	125.00	\N	0	0.00	\N	\N	t	\N
413	P230-000413	วัสดุใช้ไป	สายลำโพง แบบใส ขนาดใหญ่	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	10.00	\N	0	0.00	\N	\N	t	\N
378	P230-000378	วัสดุใช้ไป	ท่อสายไฟ ชนิด PVC แบบท่อตรง ขนาด 1/2 นิ้ว สีเหลือง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	55.00	\N	0	0.00	\N	\N	t	\N
379	P230-000379	วัสดุใช้ไป	เทป สำหรับฟันสายไฟ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	35.00	\N	0	0.00	\N	\N	t	\N
380	P230-000380	วัสดุใช้ไป	แท่งกราวด์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	95.00	\N	0	0.00	\N	\N	t	\N
381	P230-000381	วัสดุใช้ไป	บัลลาส ชนิดหลอดฮาโลเจน ขนาด 12V 35 Watt	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	745.00	\N	0	0.00	\N	\N	t	\N
382	P230-000382	วัสดุใช้ไป	เบรคเกอร์ ขนาด 30A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	145.00	\N	0	0.00	\N	\N	t	\N
383	P230-000383	วัสดุใช้ไป	แบตเตอรี่ แบบแห้ง ขนาด 12V 7.5A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูก	600.00	\N	0	0.00	\N	\N	t	\N
384	P230-000384	วัสดุใช้ไป	ปลั๊กไฟ แบบกราวคู่	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	55.00	\N	0	0.00	\N	\N	t	\N
385	P230-000385	วัสดุใช้ไป	ปลั๊กไฟ แบบตุ๊กตา	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	85.00	\N	0	0.00	\N	\N	t	\N
386	P230-000386	วัสดุใช้ไป	แป้นพลาสติก ขนาด 4*6 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N
387	P230-000387	วัสดุใช้ไป	พุก ชนิดพลาสติก เบอร์ 7	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N
388	P230-000388	วัสดุใช้ไป	ไมล์สาย	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	490.00	\N	0	0.00	\N	\N	t	\N
389	P230-000389	วัสดุใช้ไป	ปลั๊กไฟพ่วง ยาว 5 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	240.00	\N	0	0.00	\N	\N	t	\N
390	P230-000390	วัสดุใช้ไป	รางสายไฟ แบบมินิเท้งกิ้ง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	75.00	\N	0	0.00	\N	\N	t	\N
391	P230-000391	วัสดุใช้ไป	รางสายไฟ ยาว 2 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	90.00	\N	0	0.00	\N	\N	t	\N
392	P230-000392	วัสดุใช้ไป	ลูกเสียบ แบบตัวผู้	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	15.00	\N	0	0.00	\N	\N	t	\N
393	P230-000393	วัสดุใช้ไป	ลูกเสียบ แบบตัวเมีย	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	14.00	\N	0	0.00	\N	\N	t	\N
394	P230-000394	วัสดุใช้ไป	ไฟสนาม แบบสปอตไลท์ ขนาด 50W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	460.00	\N	0	0.00	\N	\N	t	\N
395	P230-000395	วัสดุใช้ไป	สวิทช์ไฟ แบบแสงแดด	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	180.00	\N	0	0.00	\N	\N	t	\N
396	P230-000396	วัสดุใช้ไป	สวิทช์ไฟ แบบฝัง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	25.00	\N	0	0.00	\N	\N	t	\N
397	P230-000397	วัสดุใช้ไป	สาย HDMI ขนาด 3 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	95.00	\N	0	0.00	\N	\N	t	\N
398	P230-000398	วัสดุใช้ไป	สาย HDMI ขนาด 5 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	155.00	\N	0	0.00	\N	\N	t	\N
399	P230-000399	วัสดุใช้ไป	สายดิน ขนาด 1*2.5 สีขาว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	950.00	\N	0	0.00	\N	\N	t	\N
400	P230-000400	วัสดุใช้ไป	สายดิน ขนาด 1*2.5 สีดำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	950.00	\N	0	0.00	\N	\N	t	\N
401	P230-000401	วัสดุใช้ไป	สายดิน	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	950.00	\N	0	0.00	\N	\N	t	\N
402	P230-000402	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 2 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N
403	P230-000403	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 3 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N
404	P230-000404	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 6 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	33.00	\N	0	0.00	\N	\N	t	\N
405	P230-000405	วัสดุใช้ไป	ยกเลิก หลอดไฟ ชนิด LED ขนาด 18 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	72.00	\N	0	0.00	\N	\N	f	\N
406	P230-000406	วัสดุใช้ไป	ยกเลิก หลอดไฟ ชนิด LED ขนาด 22 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	155.00	\N	0	0.00	\N	\N	f	\N
407	P230-000407	วัสดุใช้ไป	หลอดไฟ ชนิดนีออน ขนาด 36 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	95.00	\N	0	0.00	\N	\N	t	\N
408	P230-000408	วัสดุใช้ไป	ปลั๊กไฟ แบบฝัง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	115.00	\N	0	0.00	\N	\N	t	\N
409	P230-000409	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 1 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N
410	P230-000410	วัสดุใช้ไป	ไฟฉาย แบบหลอดไส้	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	250.00	\N	0	0.00	\N	\N	t	\N
411	P230-000411	วัสดุใช้ไป	ปลั๊กไฟ แบบตัวผู้	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	10.00	\N	0	0.00	\N	\N	t	\N
412	P230-000412	วัสดุใช้ไป	ลูกเซอร์กิต	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	95.00	\N	0	0.00	\N	\N	t	\N
415	P230-000415	วัสดุใช้ไป	กริ่ง แบบไร้สาย มีรีโมท	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	260.00	\N	0	0.00	\N	\N	t	\N
416	P230-000416	วัสดุใช้ไป	เพรสเซอร์สวิทช์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	1050.00	\N	0	0.00	\N	\N	t	\N
417	P230-000417	วัสดุใช้ไป	แบตเตอรี่ สำหรับเครื่อง DRX	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	39100.00	\N	0	0.00	\N	\N	t	\N
418	P230-000418	วัสดุใช้ไป	สายโทรศัพท์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	620.00	\N	0	0.00	\N	\N	t	\N
419	P230-000419	วัสดุใช้ไป	ยกเลิก ปลั๊กไฟ แบบฝัง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	25.00	\N	0	0.00	\N	\N	f	\N
420	P230-000420	วัสดุใช้ไป	สาย VCT	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	1590.00	\N	0	0.00	\N	\N	t	\N
423	P230-000423	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีส้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N
427	P230-000427	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N
432	P230-000432	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1/2 นิ้ว 36x20 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	20.00	\N	0	0.00	\N	\N	t	\N
434	P230-000434	วัสดุใช้ไป	กระดาษไข สำหรับเครื่องโรเนียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1200.00	\N	0	0.00	\N	\N	t	\N
441	P230-000441	วัสดุใช้ไป	กระดาษบรุ๊ฟ ขนาด 31x43 นิ้ว สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	4.00	\N	0	0.00	\N	\N	t	\N
449	P230-000449	วัสดุใช้ไป	เทปกาว ชนิด 2 หน้า แบบบาง ขนาด 3/4 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N
450	P230-000450	วัสดุใช้ไป	กาว แบบติดแน่น (ตราช้าง) ขนาด 3 กรัม	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	25.00	\N	0	0.00	\N	\N	t	\N
454	P230-000454	วัสดุใช้ไป	กาว ชนิดลาเท็กซ์ ขนาด 32 ออนซ์	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	60.00	\N	0	0.00	\N	\N	t	\N
459	P230-000459	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #112 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N
469	P230-000469	วัสดุใช้ไป	ซองใส่บัตร ชนิดพลาสติก สำหรับบัตรคนต่างด้าว ขนาด 5.6x8.8 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	4.00	\N	0	0.00	\N	\N	t	\N
472	P230-000472	วัสดุใช้ไป	ชั้นอเนกประสงค์ ชนิดลวดเคลือบพลาสติก แบบ 3 ชั้น	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	900.00	\N	0	0.00	\N	\N	t	\N
473	P230-000473	วัสดุใช้ไป	ทะเบียนคุมเงินงบประมาณ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	180.00	\N	0	0.00	\N	\N	t	\N
475	P230-000475	วัสดุใช้ไป	ยกเลิก เทปกาว ชนิด 2 หน้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	125.00	\N	0	0.00	\N	\N	f	\N
480	P230-000480	วัสดุใช้ไป	แท่นตัดกระดาษ ชนิดมือโยก แบบฐานไม้ ขนาด 13x15"	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1350.00	\N	0	0.00	\N	\N	t	\N
481	P230-000481	วัสดุใช้ไป	แท่นประทับ แบบฝาพลาสติก สีดำ #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
482	P230-000482	วัสดุใช้ไป	แท่นประทับ แบบฝาพลาสติก สีแดง #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
483	P230-000483	วัสดุใช้ไป	แท่นประทับ แบบฝาพลาสติก สีน้ำเงิน #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
487	P230-000487	วัสดุใช้ไป	ธง วปร. รัชกาลที่ 10 ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N
488	P230-000488	วัสดุใช้ไป	ธงชาติ ขนาด 120*180 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	180.00	\N	0	0.00	\N	\N	t	\N
489	P230-000489	วัสดุใช้ไป	ธงชาติ ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N
490	P230-000490	วัสดุใช้ไป	ธง สท. พระราชินี ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N
491	P230-000491	วัสดุใช้ไป	ธงฟ้า สก. พระพันปีหลวง ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N
493	P230-000493	วัสดุใช้ไป	บัตรคิว สำหรับคิวรถ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	7.00	\N	0	0.00	\N	\N	t	\N
494	P230-000494	วัสดุใช้ไป	บัตรนัดผู้ป่วย ขนาด 5*3.5 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	1.00	\N	0	0.00	\N	\N	t	\N
495	P230-000495	วัสดุใช้ไป	ยกเลิก บัตรนัดรักษา	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1400.00	\N	0	0.00	\N	\N	f	\N
496	P230-000496	วัสดุใช้ไป	บัตรประจำตัวผู้รับบริการ	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	1.00	\N	0	0.00	\N	\N	t	\N
497	P230-000497	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการกุมารเวชกรรม สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	25.00	\N	0	0.00	\N	\N	t	\N
498	P230-000498	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการทันตกรรม สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	25.00	\N	0	0.00	\N	\N	t	\N
499	P230-000499	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการทั่วไป สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N
500	P230-000500	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการโรคเรื้อรัง สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N
501	P230-000501	วัสดุใช้ไป	บัตรคิว สำหรับผู้รับบริการส่งเสริมสุขภาพ สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N
502	P230-000502	วัสดุใช้ไป	บัตรคิว สำหรับแพทย์นัด สีส้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N
504	P230-000504	วัสดุใช้ไป	แบบฟอร์ม แจ้งรายการค่ารักษาพยาบาล	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1500.00	\N	0	0.00	\N	\N	t	\N
508	P230-000508	วัสดุใช้ไป	แบบฟอร์ม ใบรับรองแพทย์ กรณีป่วย	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	60.00	\N	0	0.00	\N	\N	t	\N
511	P230-000511	วัสดุใช้ไป	ปากกา Paint Marker ขนาด 0.8-1.2 mm สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	85.00	\N	0	0.00	\N	\N	t	\N
512	P230-000512	วัสดุใช้ไป	ปากกา Paint Marker ขนาด 0.8-1.2 mm สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	85.00	\N	0	0.00	\N	\N	t	\N
513	P230-000513	วัสดุใช้ไป	ปากกา Paint Marker ขนาด 4.0-8.5 mm สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	85.00	\N	0	0.00	\N	\N	t	\N
519	P230-000519	วัสดุใช้ไป	ปากกา ไวท์บอร์ด PILOT สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N
520	P230-000520	วัสดุใช้ไป	ปากกา ไวท์บอร์ด PILOT สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N
526	P230-000526	วัสดุใช้ไป	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	ตลับ	7800.00	\N	0	0.00	\N	\N	t	\N
527	P230-000527	วัสดุใช้ไป	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตลับ	16000.00	\N	0	0.00	\N	\N	t	\N
528	P230-000528	วัสดุใช้ไป	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ตลับ	16000.00	\N	0	0.00	\N	\N	t	\N
529	P230-000529	วัสดุใช้ไป	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตลับ	16000.00	\N	0	0.00	\N	\N	t	\N
532	P230-000532	วัสดุใช้ไป	พลาสติกใส แบบยืด	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	25.00	\N	0	0.00	\N	\N	t	\N
545	P230-000545	วัสดุใช้ไป	มีดคัตเตอร์ ชนิดด้ามสแตนเลส ขนาดใหญ่	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	45.00	\N	0	0.00	\N	\N	t	\N
547	P230-000547	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 3	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	15.00	\N	0	0.00	\N	\N	t	\N
549	P230-000549	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 8	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	10.00	\N	0	0.00	\N	\N	t	\N
552	P230-000552	วัสดุใช้ไป	ลิ้นแฟ้ม ชนิดพลาสติก	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	95.00	\N	0	0.00	\N	\N	t	\N
554	P230-000554	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N
555	P230-000555	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N
556	P230-000556	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีม่วง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N
557	P230-000557	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีส้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N
736	P230-000736	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 1 W สีแดง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	35.00	\N	0	0.00	\N	\N	t	\N
558	P230-000558	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N
559	P230-000559	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สี่ขาวมัน	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	45.00	\N	0	0.00	\N	\N	t	\N
563	P230-000563	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดพลาสติก แบบใส ขนาดใหญ่ สีใสหลังเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	20.00	\N	0	0.00	\N	\N	t	\N
564	P230-000564	วัสดุใช้ไป	สมุด สำหรับ Refer คลอด (บส.08/1)	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	50.00	\N	0	0.00	\N	\N	t	\N
565	P230-000565	วัสดุใช้ไป	สมุด สำหรับ Refer ทั่วไป (บส.08)	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	50.00	\N	0	0.00	\N	\N	t	\N
567	P230-000567	วัสดุใช้ไป	สมุด สำหรับตรวจสุขภาพ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	5.00	\N	0	0.00	\N	\N	t	\N
570	P230-000570	วัสดุใช้ไป	สมุด ชนิดหุ้มปก สำหรับบันทึกมุมมัน	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	250.00	\N	0	0.00	\N	\N	t	\N
571	P230-000571	วัสดุใช้ไป	สมุด สำหรับใบรับรองความพิการ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	65.00	\N	0	0.00	\N	\N	t	\N
574	P230-000574	วัสดุใช้ไป	สมุด สำหรับประจำตัวผู้ป่วยนอก สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	18.00	\N	0	0.00	\N	\N	t	\N
575	P230-000575	วัสดุใช้ไป	สมุด สำหรับประจำตัวผู้ป่วยโรคปอด	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	30.00	\N	0	0.00	\N	\N	t	\N
576	P230-000576	วัสดุใช้ไป	หมึกพิมพ์ สำหรับเครื่องโรเนียว สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	500.00	\N	0	0.00	\N	\N	t	\N
577	P230-000577	วัสดุใช้ไป	หมึกเติม สำหรับแท่นประทับตรายาง สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	15.00	\N	0	0.00	\N	\N	t	\N
580	P230-000580	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบหูหิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	159.00	\N	0	0.00	\N	\N	t	\N
581	P230-000581	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 4 ชั้น	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	280.00	\N	0	0.00	\N	\N	t	\N
582	P230-000582	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 3 ช่อง สำหรับใส่เอกสาร	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	230.00	\N	0	0.00	\N	\N	t	\N
583	P230-000583	วัสดุใช้ไป	เก้าอี้ ชนิดโครงเหล็ก สำหรับจัดเลี้ยง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	859.00	\N	0	0.00	\N	\N	t	\N
584	P230-000584	วัสดุใช้ไป	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	259.00	\N	0	0.00	\N	\N	f	\N
585	P230-000585	วัสดุใช้ไป	ชั้นอเนกประสงค์ ชนิดพลาสติก แบบ 4 ลิ้นชัก	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	290.00	\N	0	0.00	\N	\N	t	\N
586	P230-000586	วัสดุใช้ไป	ซองใส่บัตร ชนิดพลาสติก	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	214.00	\N	0	0.00	\N	\N	t	\N
587	P230-000587	วัสดุใช้ไป	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 4 ลิ้นชัก	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้	740.00	\N	0	0.00	\N	\N	t	\N
588	P230-000588	วัสดุใช้ไป	โต๊ะเอนกประสงค์ แบบพับได้	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	1850.00	\N	0	0.00	\N	\N	t	\N
589	P230-000589	วัสดุใช้ไป	โต๊ะเอนกประสงค์	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	659.00	\N	0	0.00	\N	\N	t	\N
590	P230-000590	วัสดุใช้ไป	ที่แขวนตรายาง แบบ 2 ชั้น	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	98.00	\N	0	0.00	\N	\N	t	\N
591	P230-000591	วัสดุใช้ไป	ธงชาติ ขนาด 100*150 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	100.00	\N	0	0.00	\N	\N	t	\N
592	P230-000592	วัสดุใช้ไป	ธง จภ. สมเด็จเจ้าฟ้าจุฬาภรณ์ฯ ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	50.00	\N	0	0.00	\N	\N	t	\N
593	P230-000593	วัสดุใช้ไป	พลาสติกใส หนา 0.20 มม. ขนาดกว้าง 2 เมตร ยาว 15 เมตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	2000.00	\N	0	0.00	\N	\N	t	\N
594	P230-000594	วัสดุใช้ไป	พลาสติกใส สำหรับหุ้มปก หนา 0.09 มม. ขนาดกว้าง 48 นิ้ว ยาว 75 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	1500.00	\N	0	0.00	\N	\N	t	\N
595	P230-000595	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์12/10	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	92.00	\N	0	0.00	\N	\N	t	\N
596	P230-000596	วัสดุใช้ไป	หนังสือ มาตรฐานโรงพยาบาลและบริการสุขภาพ ฉบับที่ 5	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	500.00	\N	0	0.00	\N	\N	t	\N
597	P230-000597	วัสดุใช้ไป	ยกเลิก กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีล้อ พร้อมฝาปิด ขนาด 100 ลิตร	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	429.00	\N	0	0.00	\N	\N	f	\N
598	P230-000598	วัสดุใช้ไป	เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	199.00	\N	0	0.00	\N	\N	t	\N
599	P230-000599	วัสดุใช้ไป	ยกเลิก พลาสติกใส หนา 0.20 มม. ขนาดกว้าง 2 เมตร ยาว 15 เมตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	2000.00	\N	0	0.00	\N	\N	f	\N
600	P230-000600	วัสดุใช้ไป	ชั้นวางรองเท้า แบบ 3 ชั้น	วัสดุสำนักงาน	วัสดุสำนักงาน	ชั้น	990.00	\N	0	0.00	\N	\N	t	\N
601	P230-000601	วัสดุใช้ไป	กระดาษการ์ด แบบพื้นด้าน ขนาด A4 สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	pack	100.00	\N	0	0.00	\N	\N	t	\N
602	P230-000602	วัสดุใช้ไป	เสาธง ชนิดไม้ ขนาดสูง 2 เมตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	65.00	\N	0	0.00	\N	\N	t	\N
603	P230-000603	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก ขนาด 33*26*23 ซม. สีใส	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	190.00	\N	0	0.00	\N	\N	t	\N
604	P230-000604	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก ขนาด 11.5*21*10.5 ซม. สีใส	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	59.00	\N	0	0.00	\N	\N	t	\N
605	P230-000605	วัสดุใช้ไป	ธง สธ. สมเด็จพระเทพฯ ขนาด 60*90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	40.00	\N	0	0.00	\N	\N	t	\N
606	P230-000606	วัสดุใช้ไป	กางเกงเด็กกลาง ผ้าย้อม ขนาดเด็ก 4-7 ปี สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N
607	P230-000607	วัสดุใช้ไป	กางเกงเด็กเล็ก ผ้าย้อม ขนาดเด็ก 1-3 ปี สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N
608	P230-000608	วัสดุใช้ไป	กางเกงผู้ใหญ่ ผ้าย้อม แบบมีเชือกผูก ขนาด XXL สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	235.00	\N	0	0.00	\N	\N	t	\N
609	P230-000609	วัสดุใช้ไป	กางเกงผู้ใหญ่ ผ้าย้อม แบบมีเชือกผูก ขนาด XL สีเม็ดมะปราง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	235.00	\N	0	0.00	\N	\N	t	\N
610	P230-000610	วัสดุใช้ไป	ชุดกระโปรงแพทย์ ผ้าโทเร แบบหญิง ขนาด L สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	450.00	\N	0	0.00	\N	\N	t	\N
611	P230-000611	วัสดุใช้ไป	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด M สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	550.00	\N	0	0.00	\N	\N	t	\N
612	P230-000612	วัสดุใช้ไป	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด S , M , L , XL สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	550.00	\N	0	0.00	\N	\N	t	\N
613	P230-000613	วัสดุใช้ไป	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด S , L , XL , XXL สีฟ้า	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	550.00	\N	0	0.00	\N	\N	t	\N
614	P230-000614	วัสดุใช้ไป	ถุงเท้าคลอด ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 18"x36"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N
615	P230-000615	วัสดุใช้ไป	ปลอกหมอน ผ้าโทเร แบบพับใน 8 นิ้ว ขนาด 18"x25" สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N
1171	P230-001171	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N
616	P230-000616	วัสดุใช้ไป	ปลอกหมอน ผ้าโทเร แบบพับใน 8 นิ้ว ขนาด 18"x25" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N
617	P230-000617	วัสดุใช้ไป	ปลอกหมอน ผ้าฟอกขาว แบบพับใน 8 นิ้ว ขนาด 18"x25"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N
618	P230-000618	วัสดุใช้ไป	ผ้าขวางเตียง ผ้าฟอกขาว ขนาด 44"x72"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	290.00	\N	0	0.00	\N	\N	t	\N
619	P230-000619	วัสดุใช้ไป	ผ้าเช็ดตัวผืนใหญ่ ผ้าทอเดี่ยว 11 ปอนด์ แบบ 11 ปอนด์ ขนาด 30"x60" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	250.00	\N	0	0.00	\N	\N	t	\N
620	P230-000620	วัสดุใช้ไป	ผ้าเช็ดตัวลดไข้ ผ้าทอเดี่ยว 0.95 ปอนด์ ขนาด 12"x12" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	20.00	\N	0	0.00	\N	\N	t	\N
621	P230-000621	วัสดุใช้ไป	ผ้าเช็ดมือผ่าตัด ผ้าทอเดี่ยว 2.8 ปอนด์ ขนาด 15"x30" สีขาว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	100.00	\N	0	0.00	\N	\N	t	\N
622	P230-000622	วัสดุใช้ไป	ยกเลิก ผ้าดิบ	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	พับ	50.00	\N	0	0.00	\N	\N	f	\N
623	P230-000623	วัสดุใช้ไป	ผ้าถุง ผ้าย้อม ขนาด 88"x40" สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	345.00	\N	0	0.00	\N	\N	t	\N
624	P230-000624	วัสดุใช้ไป	ผ้าถุง ผ้าวินเซนต์ ขนาด 88"x40" สีแดงเลือดนก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	345.00	\N	0	0.00	\N	\N	t	\N
625	P230-000625	วัสดุใช้ไป	ผ้าปิดตา แบบสามเหลี่ยม	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	65.00	\N	0	0.00	\N	\N	t	\N
626	P230-000626	วัสดุใช้ไป	ผ้าปูเตียง ผ้าโทเรหนา แบบปล่อยชาย ขนาด 100"x3 หลา สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	450.00	\N	0	0.00	\N	\N	t	\N
627	P230-000627	วัสดุใช้ไป	ผ้าปูเตียง ผ้าฟอกขาว แบบปล่อยชาย ขนาด 60"x3 หลา	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	210.00	\N	0	0.00	\N	\N	t	\N
628	P230-000628	วัสดุใช้ไป	ผ้าปูเตียง ผ้าโทเร แบบรัดมุม ขนาด 27"x74" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	175.00	\N	0	0.00	\N	\N	t	\N
737	P230-000737	วัสดุใช้ไป	ปลั๊กไฟ แบบกราวเดี่ยว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	45.00	\N	0	0.00	\N	\N	t	\N
629	P230-000629	วัสดุใช้ไป	ผ้าปูรถนอน ผ้าย้อม แบบปล่อยชาย ขนาด 45"x3 หลา สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	170.00	\N	0	0.00	\N	\N	t	\N
630	P230-000630	วัสดุใช้ไป	ผ้าปูรถนอน ผ้าย้อม แบบปล่อยชาย ขนาด 45"x3 หลา สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	180.00	\N	0	0.00	\N	\N	t	\N
631	P230-000631	วัสดุใช้ไป	ผ้าผูกยึดผู้ป่วย ผ้าฟอกขาว ขนาดยาว 36"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เส้น	130.00	\N	0	0.00	\N	\N	t	\N
632	P230-000632	วัสดุใช้ไป	ผ้ายาง ชนิด 2 หน้า ขนาด 36"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ม้วน	920.00	\N	0	0.00	\N	\N	t	\N
633	P230-000633	วัสดุใช้ไป	ผ้ายาง ชนิดหนังเทียม ขนาด 36"x54"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	120.00	\N	0	0.00	\N	\N	t	\N
634	P230-000634	วัสดุใช้ไป	ผ้ายาง ชนิด 2 หน้า แบบเล็ก ขนาด 24"x24" สีชมพู-เขียว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	100.00	\N	0	0.00	\N	\N	t	\N
635	P230-000635	วัสดุใช้ไป	ผ้าสวม Mayo ผ้าย้อม แบบ 2 ชั้น ขนาด 18" x72 " สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	245.00	\N	0	0.00	\N	\N	t	\N
636	P230-000636	วัสดุใช้ไป	ผ้าสี่เหลียม 1 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x4") ขนาด 30"x30" สีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N
637	P230-000637	วัสดุใช้ไป	ยกเลิก ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x4") ขนาด 45"x60" สีเขียวแก่มุมสีขาว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	210.00	\N	0	0.00	\N	\N	f	\N
638	P230-000638	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว แบบเจาะรูกลาง (4"x4") ขนาด 25"x25" มุมสีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	99.00	\N	0	0.00	\N	\N	t	\N
639	P230-000639	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว แบบเจาะรูกลาง (4"x4") ขนาด 44"x44" มุมสีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	180.00	\N	0	0.00	\N	\N	t	\N
640	P230-000640	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x6") ขนาด 60"x100" สีเขียวแก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	420.00	\N	0	0.00	\N	\N	t	\N
641	P230-000641	วัสดุใช้ไป	ผ้ารองถาดสี่เหลี่ยม ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 25"x25"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	99.00	\N	0	0.00	\N	\N	t	\N
642	P230-000642	วัสดุใช้ไป	ผ้ารองเทเครื่องมือ ผ้าฟอกขาว แบบสี่เหลียม 2 ชั้น ขนาด 44"x44"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	180.00	\N	0	0.00	\N	\N	t	\N
643	P230-000643	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลี่ยม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 16"x16" (Supply) ขนาด 16"x16" มุมสีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	30.00	\N	0	0.00	\N	\N	t	\N
644	P230-000644	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลี่ยม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 25"x25" (Supply) ขนาด 25"x25" มุมสีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	99.00	\N	0	0.00	\N	\N	t	\N
645	P230-000645	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 44"x44" (OR) ขนาด 44"x44" มุมสีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	180.00	\N	0	0.00	\N	\N	t	\N
646	P230-000646	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีเขียวแก่ 25"x25" (OR) ขนาด 25"x25" สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	110.00	\N	0	0.00	\N	\N	t	\N
647	P230-000647	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลียม 2 ชั้น ผ้าย้อมสีเขียวแก่ 45"x60" (OR) ขนาด 45"x60" สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	395.00	\N	0	0.00	\N	\N	t	\N
648	P230-000648	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีเขียวแก่มุมสีม่วง 44"x44" (OR) ขนาด 44"x44" สีเขียวแก่มุมสีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	310.00	\N	0	0.00	\N	\N	t	\N
649	P230-000649	วัสดุใช้ไป	ยกเลิก ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีม่วง 16"x16" (Dent ยกเลิกใช้แล้ว) ขนาด 16"x16" สีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	30.00	\N	0	0.00	\N	\N	f	\N
650	P230-000650	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลียม 2 ชั้น ผ้าย้อมสีม่วง 25"x25" (Dent) ขนาด 25"x25" สีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	90.00	\N	0	0.00	\N	\N	t	\N
651	P230-000651	วัสดุใช้ไป	ผ้าห่ม ผ้าทอเดี่ยว ขนาด 60"x80" สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	600.00	\N	0	0.00	\N	\N	t	\N
652	P230-000652	วัสดุใช้ไป	ผ้าห่อ Spore test ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 16"x26"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	80.00	\N	0	0.00	\N	\N	t	\N
653	P230-000653	วัสดุใช้ไป	เสื้อกาวน์นอก ผ้าโทเรหนา แบบแขนสั้น ขนาด L , XL , XXL สีขา	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	550.00	\N	0	0.00	\N	\N	t	\N
654	P230-000654	วัสดุใช้ไป	เสื้อกาวน์ผ่าตัด ผ้าย้อม ขนาด XXL สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	450.00	\N	0	0.00	\N	\N	t	\N
655	P230-000655	วัสดุใช้ไป	เสื้อกาวน์ผ่าตัด ผ้าย้อม ขนาด XXL สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	450.00	\N	0	0.00	\N	\N	t	\N
656	P230-000656	วัสดุใช้ไป	เสื้อคลุมกิโมโน ผ้าโทเรหนา แบบแขนสั้น ขนาด XL สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	380.00	\N	0	0.00	\N	\N	t	\N
657	P230-000657	วัสดุใช้ไป	เสื้อคลุมกิโมโน ผ้าโทเรหนา แบบแขนสั้น ขนาด L , XL สีชมพู	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	380.00	\N	0	0.00	\N	\N	t	\N
658	P230-000658	วัสดุใช้ไป	ยกเลิก เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ๊ำแขน กระเป๋าในขวา ขนาด L สีม่วง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	f	\N
659	P230-000659	วัสดุใช้ไป	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด L , XL สีขาว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	t	\N
660	P230-000660	วัสดุใช้ไป	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด L , XL สีน้ำเงิน	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	t	\N
661	P230-000661	วัสดุใช้ไป	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด M , L , XL สีฟ้า	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	t	\N
662	P230-000662	วัสดุใช้ไป	เสื้อเด็กกลาง ผ้าย้อม ขนาดเด็ก 4-7 ปี สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N
663	P230-000663	วัสดุใช้ไป	เสื้อเด็กเล็ก ผ้าย้อม ขนาดเด็ก 1-3 ปี สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	150.00	\N	0	0.00	\N	\N	t	\N
664	P230-000664	วัสดุใช้ไป	เสื้อผู้ใหญ่ ผ้าย้อม แบบป้ายข้าง ขนาด XXL สีเขียวโศก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	250.00	\N	0	0.00	\N	\N	t	\N
665	P230-000665	วัสดุใช้ไป	เสื้อผู้ใหญ่ ผ้าวินเซนต์ แบบป้ายข้าง ขนาด XXL สีแดงเลือดนก	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	250.00	\N	0	0.00	\N	\N	t	\N
666	P230-000666	วัสดุใช้ไป	เสื้อผู้ใหญ่ ผ้าวินเซนต์ แบบป้ายข้าง ขนาด XL สีเม็ดมะปราง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	250.00	\N	0	0.00	\N	\N	t	\N
667	P230-000667	วัสดุใช้ไป	เสื้อกางเกงแพทย์ ผ้าโทเร แบบคอวี และกางเกง ขนาด L สีเขียวแก่	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	500.00	\N	0	0.00	\N	\N	t	\N
668	P230-000668	วัสดุใช้ไป	เสื้อกางเกงแพทย์ ผ้าวินเซนต์ แบบคอวี และกางเกง ขนาด XXL สีเม็ดมะปราง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	580.00	\N	0	0.00	\N	\N	t	\N
669	P230-000669	วัสดุใช้ไป	เสื้อกางเกงแพทย์ ผ้าวินเซนต์ แบบคอวี และกางเกง ขนาด XXXL สีเม็ดมะปราง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	650.00	\N	0	0.00	\N	\N	t	\N
670	P230-000670	วัสดุใช้ไป	เอี๊ยม ผ้ายางหนังเทียม	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	195.00	\N	0	0.00	\N	\N	t	\N
671	P230-000671	วัสดุใช้ไป	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด L คละสี	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	800.00	\N	0	0.00	\N	\N	t	\N
672	P230-000672	วัสดุใช้ไป	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด M คละสี	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	800.00	\N	0	0.00	\N	\N	t	\N
673	P230-000673	วัสดุใช้ไป	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด XL คละสี	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	800.00	\N	0	0.00	\N	\N	t	\N
674	P230-000674	วัสดุใช้ไป	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด XXL คละสี	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	800.00	\N	0	0.00	\N	\N	t	\N
675	P230-000675	วัสดุใช้ไป	ตรายาง สำหรับปั๊มเจาะเลือดประจำปีผู้ป่วย	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	150.00	\N	0	0.00	\N	\N	t	\N
676	P230-000676	วัสดุใช้ไป	ตรายาง สำหรับปั๊มโทรเลื่อนนัด	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	180.00	\N	0	0.00	\N	\N	t	\N
677	P230-000677	วัสดุใช้ไป	ตรายาง สำหรับปั๊มบันทึกกิจกรรมในผู้ป่วยCOPD/Asthma	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	200.00	\N	0	0.00	\N	\N	t	\N
678	P230-000678	วัสดุใช้ไป	ตรายาง สำหรับปั๊มแนะนำสำหรับการเตรียมตัวเจาะเลือด	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	100.00	\N	0	0.00	\N	\N	t	\N
679	P230-000679	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 60 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถัง	995.00	\N	0	0.00	\N	\N	t	\N
680	P230-000680	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก ขนาด 60 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถัง	950.00	\N	0	0.00	\N	\N	t	\N
681	P230-000681	วัสดุใช้ไป	พรมเช็ดเท้า แบบดักฝุ่น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ผืน	350.00	\N	0	0.00	\N	\N	t	\N
682	P230-000682	วัสดุใช้ไป	ฉากกันห้อง แบบครึ่งกระจกใส ขัดลาย ขนาด 80*160 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ชุด	5500.00	\N	0	0.00	\N	\N	t	\N
683	P230-000683	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีหูหิ้ว ฝาปิดระบบล็อก 2 ด้าน ความจุ 19 ลิตร ขนาด 38.5 x 26 x 22 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ใบ	250.00	\N	0	0.00	\N	\N	t	\N
684	P230-000684	วัสดุใช้ไป	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 5 ชั้น ขนาด 17.5 × 24.5 × 27 ซม	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	475.00	\N	0	0.00	\N	\N	t	\N
685	P230-000685	วัสดุใช้ไป	ชั้นอเนกประสงค์ ชนิดตะแกรงเหล็ก แบบ 4 ชั้น ขนาด 90 x 45 x 160 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	1780.00	\N	0	0.00	\N	\N	t	\N
686	P230-000686	วัสดุใช้ไป	ชั้นอเนกประสงค์ แบบ 4 ชั้น ขนาด 42 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	488.00	\N	0	0.00	\N	\N	t	\N
687	P230-000687	วัสดุใช้ไป	ที่วัดส่วนสูง แบบมีฐาน ขนาด 200 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ชุด	1750.00	\N	0	0.00	\N	\N	t	\N
688	P230-000688	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีหูหิ้ว ฝาปิดระบบล็อก 2 ด้าน ความจุ 19 ลิตร ขนาด 38.5 x 26 x 22 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ใบ	240.00	\N	0	0.00	\N	\N	t	\N
689	P230-000689	วัสดุใช้ไป	บันได ชนิดอลูมีเนียม แบบ 8 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง-งบหน่วยงาน	อัน	2550.00	\N	0	0.00	\N	\N	t	\N
690	P230-000690	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบฝาปิด ขนาด 50 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถัง	2150.00	\N	0	0.00	\N	\N	t	\N
691	P230-000691	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบฝาปิด ขนาด 40 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถัง	1700.00	\N	0	0.00	\N	\N	t	\N
692	P230-000692	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 35 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	750.00	\N	0	0.00	\N	\N	t	\N
693	P230-000693	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 18 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	500.00	\N	0	0.00	\N	\N	t	\N
694	P230-000694	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก ทรงสูง แบบมีล้อและมีฝา ขนาด 120 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	1800.00	\N	0	0.00	\N	\N	t	\N
695	P230-000695	วัสดุใช้ไป	กระดาษโน๊ต แบบมีกาว ขนาด 3x3 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	แพ็ค	30.00	\N	0	0.00	\N	\N	t	\N
696	P230-000696	วัสดุใช้ไป	กระดาษโน๊ต แบบมีกาว ขนาด 0.8x3 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	แพ็ค	25.00	\N	0	0.00	\N	\N	t	\N
697	P230-000697	วัสดุใช้ไป	รองเท้า ชนิดผ้ารังผึ้ง แบบ Slippers	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	คู่	110.00	\N	0	0.00	\N	\N	t	\N
698	P230-000698	วัสดุใช้ไป	พรมเช็ดเท้า ขนาด 45*70 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ผืน	499.00	\N	0	0.00	\N	\N	t	\N
699	P230-000699	วัสดุใช้ไป	พรมเช็ดเท้า ขนาด 45*120 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ผืน	830.00	\N	0	0.00	\N	\N	t	\N
700	P230-000700	วัสดุใช้ไป	อิฐ ประสาน ขนาด 10*10*30 ซม.	วัสดุการเกษตร	วัสดุการเกษตร	ก้อน	20.00	\N	0	0.00	\N	\N	t	\N
701	P230-000701	วัสดุใช้ไป	ดิน ชนิดถุงสำเร็จ สำหรับปลูกต้นไม้	วัสดุการเกษตร	วัสดุการเกษตร	ถุง	10.00	\N	0	0.00	\N	\N	t	\N
702	P230-000702	วัสดุใช้ไป	แบตเตอรี่ แบบชาร์จไฟ ขนาด 800 มิลลิแอมป์	วัสดุไฟฟ้า	วัสดุไฟฟ้า-งบหน่วยงาน	ก้อน	500.00	\N	0	0.00	\N	\N	t	\N
703	P230-000703	วัสดุใช้ไป	ตะกร้า ชนิดพลาสติก แบบทรงเหลี่ยม ขนาด 14 x 14.5 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	180.00	\N	0	0.00	\N	\N	t	\N
704	P230-000704	วัสดุใช้ไป	กระดาน White board ติดผนัง ขนาด 120 x 90 cm. แบบติดผนัง ขนาด 120 x 90 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	แผ่น	1500.00	\N	0	0.00	\N	\N	t	\N
705	P230-000705	วัสดุใช้ไป	บันได ชนิดอเนกประสงค์ แบบ 20 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง-งบหน่วยงาน	ตัว	5900.00	\N	0	0.00	\N	\N	t	\N
706	P230-000706	วัสดุใช้ไป	ตะกร้า ชนิดพลาสติก แบบทรงกลมและมีหูหิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ใบ	250.00	\N	0	0.00	\N	\N	t	\N
707	P230-000707	วัสดุใช้ไป	แมกเนติก	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	730.00	\N	0	0.00	\N	\N	t	\N
708	P230-000708	วัสดุใช้ไป	โอเวอร์โหลด	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	970.00	\N	0	0.00	\N	\N	t	\N
709	P230-000709	วัสดุใช้ไป	ล้อรถเข็น แบบแป้นหมุน ขนาด 5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	265.00	\N	0	0.00	\N	\N	t	\N
710	P230-000710	วัสดุใช้ไป	ล้อรถเข็น แบบแป้นตาย ขนาด 5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	245.00	\N	0	0.00	\N	\N	t	\N
711	P230-000711	วัสดุใช้ไป	หมึก Printer Ink jet BT-D60 BK สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N
715	P230-000715	วัสดุใช้ไป	หน้าจาน ชนิดเหล็ก แบบเกลียว ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	600.00	\N	0	0.00	\N	\N	t	\N
716	P230-000716	วัสดุใช้ไป	น๊อต สำหรับหน้าแปลน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	30.00	\N	0	0.00	\N	\N	t	\N
717	P230-000717	วัสดุใช้ไป	ยางประเก็น สำหรับหน้าแปลน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	120.00	\N	0	0.00	\N	\N	t	\N
718	P230-000718	วัสดุใช้ไป	ชุดกรองอากาศ (Silencer valve) สำหรับเครื่องเติมอากาศ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	19474.00	\N	0	0.00	\N	\N	t	\N
719	P230-000719	วัสดุใช้ไป	ชุดน้ำทิ้ง สำหรับอ่างล้างเครื่องมือ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	358.00	\N	0	0.00	\N	\N	t	\N
720	P230-000720	วัสดุใช้ไป	ลูกบิด ชนิดหัวกลม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	99.00	\N	0	0.00	\N	\N	t	\N
721	P230-000721	วัสดุใช้ไป	สามทาง ชนิด PVC แบบลด ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	18.00	\N	0	0.00	\N	\N	t	\N
722	P230-000722	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก สำหรับจับท่อ ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	4.00	\N	0	0.00	\N	\N	t	\N
723	P230-000723	วัสดุใช้ไป	ประตูน้ำ ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	350.00	\N	0	0.00	\N	\N	t	\N
724	P230-000724	วัสดุใช้ไป	ประตูน้ำ ชนิดทองเหลือง ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	295.00	\N	0	0.00	\N	\N	t	\N
725	P230-000725	วัสดุใช้ไป	สกรู ชนิดเกลียวปล่อย ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	78.00	\N	0	0.00	\N	\N	t	\N
726	P230-000726	วัสดุใช้ไป	แปรงสลัดน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ด้าม	60.00	\N	0	0.00	\N	\N	t	\N
727	P230-000727	วัสดุใช้ไป	ฟองน้ำ สำหรับฉาบปูน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	8.00	\N	0	0.00	\N	\N	t	\N
728	P230-000728	วัสดุใช้ไป	แผ่นขัดเอนกประสงค์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	550.00	\N	0	0.00	\N	\N	t	\N
729	P230-000729	วัสดุใช้ไป	ไม้อัด หนา 15 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	715.00	\N	0	0.00	\N	\N	t	\N
730	P230-000730	วัสดุใช้ไป	คาบูเรเตอร์ สำหรับเครื่องตัดแต่งกิ่งไม้	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	520.00	\N	0	0.00	\N	\N	t	\N
731	P230-000731	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	42.00	\N	0	0.00	\N	\N	t	\N
732	P230-000732	วัสดุใช้ไป	แฟ้ม แบบแขวน สีม่วง	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N
733	P230-000733	วัสดุใช้ไป	ขายึด ชนิดเหล็ก สำหรับอ่าง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	40.00	\N	0	0.00	\N	\N	t	\N
734	P230-000734	วัสดุใช้ไป	เทอร์โมฟิวส์ แบบ 188 องศา ขนาด 10A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	10.00	\N	0	0.00	\N	\N	t	\N
735	P230-000735	วัสดุใช้ไป	เทอมินอล สำหรับต่อสายไฟ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	4.00	\N	0	0.00	\N	\N	t	\N
738	P230-000738	วัสดุใช้ไป	ยกเลิก กิ๊บ ชนิดพลาสติก	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	f	\N
739	P230-000739	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก สำหรับสายโทรศัพท์ 2C	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N
740	P230-000740	วัสดุใช้ไป	ใบพัดลม ขนาด 16 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	120.00	\N	0	0.00	\N	\N	t	\N
741	P230-000741	วัสดุใช้ไป	ปลั๊กอุด แบบอุด ขนาด 1/2 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	6.00	\N	0	0.00	\N	\N	t	\N
742	P230-000742	วัสดุใช้ไป	พวงมาลา ชนิดดอกไม้ประดิษฐ์	วัสดุสำนักงาน	วัสดุสำนักงาน	พวง	2000.00	\N	0	0.00	\N	\N	t	\N
743	P230-000743	วัสดุใช้ไป	น้ำยาฆ่าหญ้า แบบแกลลอน	วัสดุการเกษตร	วัสดุการเกษตร	แกลลอน	900.00	\N	0	0.00	\N	\N	t	\N
744	P230-000744	วัสดุใช้ไป	เข็มหมุด	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่่อง	65.00	\N	0	0.00	\N	\N	t	\N
745	P230-000745	วัสดุใช้ไป	ปุ่มกด สำหรับประตูรีโมทอัตโนมัติ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	3500.00	\N	0	0.00	\N	\N	t	\N
746	P230-000746	วัสดุใช้ไป	สมุด สำหรับลงนามถวายพระพร	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	600.00	\N	0	0.00	\N	\N	t	\N
747	P230-000747	วัสดุใช้ไป	พระบรมฉายาลักษณ์ สมเด็จเจ้าฟ้าพัชรกิติยาภาฯ	วัสดุสำนักงาน	วัสดุสำนักงาน	บาน	1200.00	\N	0	0.00	\N	\N	t	\N
748	P230-000748	วัสดุใช้ไป	ไขควง สำหรับเช็คกระแสไฟฟ้า	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	135.00	\N	0	0.00	\N	\N	t	\N
749	P230-000749	วัสดุใช้ไป	ขาหลอดนีออน แบบสปริงหัวโต	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คู่	35.00	\N	0	0.00	\N	\N	t	\N
750	P230-000750	วัสดุใช้ไป	ลูกเสียบ ชนิดขาแบน แบบยาง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	10.00	\N	0	0.00	\N	\N	t	\N
751	P230-000751	วัสดุใช้ไป	รางสายไฟ แบบ TT202	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	40.00	\N	0	0.00	\N	\N	t	\N
752	P230-000752	วัสดุใช้ไป	กิ๊บ ชนิดพลาสติก ขนาด 2*1.5 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N
753	P230-000753	วัสดุใช้ไป	ขั้วแป้นเกลียว ชนิดกระเบื้อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N
754	P230-000754	วัสดุใช้ไป	สายไฟ แบบแข็ง ขนาด 2*1.5 ยาว 20 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ม้วน	280.00	\N	0	0.00	\N	\N	t	\N
755	P230-000755	วัสดุใช้ไป	รางสายไฟ แบบ TD204	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	90.00	\N	0	0.00	\N	\N	t	\N
756	P230-000756	วัสดุใช้ไป	ฝาครอบ ชนิด PVC	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	6.00	\N	0	0.00	\N	\N	t	\N
757	P230-000757	วัสดุใช้ไป	กล่องโทรศัพท์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	35.00	\N	0	0.00	\N	\N	t	\N
758	P230-000758	วัสดุใช้ไป	คอนเรนเซอร์ ขนาด 40/450V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	250.00	\N	0	0.00	\N	\N	t	\N
759	P230-000759	วัสดุใช้ไป	คอนเรนเซอร์ ขนาด 30/300V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	480.00	\N	0	0.00	\N	\N	t	\N
760	P230-000760	วัสดุใช้ไป	ขาหนีบ สำหรับสปอตไลท์	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	65.00	\N	0	0.00	\N	\N	t	\N
761	P230-000761	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 25 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	135.00	\N	0	0.00	\N	\N	t	\N
762	P230-000762	วัสดุใช้ไป	ลูกเสียบ ชนิดขาแบน แบบ 3 ตา	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	15.00	\N	0	0.00	\N	\N	t	\N
763	P230-000763	วัสดุใช้ไป	สายไฟ แบบอ่อน ขนาด 2*1	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	12.00	\N	0	0.00	\N	\N	t	\N
764	P230-000764	วัสดุใช้ไป	ฟิวส์ ชนิดสั้น แบบหลอด ขนาด 10A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	20.00	\N	0	0.00	\N	\N	t	\N
765	P230-000765	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	35.00	\N	0	0.00	\N	\N	t	\N
766	P230-000766	วัสดุใช้ไป	สามทาง ชนิด PVC แบบลด ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	20.00	\N	0	0.00	\N	\N	t	\N
767	P230-000767	วัสดุใช้ไป	ข้องอ ชนิด PVC แบบ 45 องศา ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	18.00	\N	0	0.00	\N	\N	t	\N
768	P230-000768	วัสดุใช้ไป	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 100 กรัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	70.00	\N	0	0.00	\N	\N	t	\N
822	P230-000822	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 7 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	80.00	\N	0	0.00	\N	\N	t	\N
769	P230-000769	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC แบบสวม ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	47.00	\N	0	0.00	\N	\N	t	\N
770	P230-000770	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 3*1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	132.00	\N	0	0.00	\N	\N	t	\N
771	P230-000771	วัสดุใช้ไป	ยกเลิก ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	15.00	\N	0	0.00	\N	\N	f	\N
772	P230-000772	วัสดุใช้ไป	ขายึด ชนิดเหล็ก สำหรับซิงค์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	40.00	\N	0	0.00	\N	\N	t	\N
773	P230-000773	วัสดุใช้ไป	วอลฟุตตี้ ขนาด 1 กก.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	121.00	\N	0	0.00	\N	\N	t	\N
774	P230-000774	วัสดุใช้ไป	สกรู ชนิดไดวอ ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	95.00	\N	0	0.00	\N	\N	t	\N
775	P230-000775	วัสดุใช้ไป	สีน้ำ สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	95.00	\N	0	0.00	\N	\N	t	\N
776	P230-000776	วัสดุใช้ไป	ยงยิปซั่ม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	33.00	\N	0	0.00	\N	\N	t	\N
777	P230-000777	วัสดุใช้ไป	ลูกบิด สำหรับประตูทั่วไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	242.00	\N	0	0.00	\N	\N	t	\N
778	P230-000778	วัสดุใช้ไป	ลวดเชื่อม สำหรับสแตนเลส	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	15.00	\N	0	0.00	\N	\N	t	\N
779	P230-000779	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 10 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	295.00	\N	0	0.00	\N	\N	t	\N
780	P230-000780	วัสดุใช้ไป	เหล็ก ชนิดหนา 2.3 มม. แบบแผ่น ขนาด 4*8 ฟุต	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	1505.00	\N	0	0.00	\N	\N	t	\N
781	P230-000781	วัสดุใช้ไป	กลอนประตู ชนิดอลูมีเนียม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	550.00	\N	0	0.00	\N	\N	t	\N
782	P230-000782	วัสดุใช้ไป	สายยาง ขนาด 5/4 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เส้น	2160.00	\N	0	0.00	\N	\N	t	\N
783	P230-000783	วัสดุใช้ไป	ถุงมือ ชนิดผ้า	วัสดุการเกษตร	วัสดุการเกษตร	คู่	98.00	\N	0	0.00	\N	\N	t	\N
785	P230-000785	วัสดุใช้ไป	พุก ชนิดพลาสติก เบอร์ 6	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N
786	P230-000786	วัสดุใช้ไป	ยางในจักรยาน ขนาด 26*1.95	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง	เส้น	130.00	\N	0	0.00	\N	\N	t	\N
787	P230-000787	วัสดุใช้ไป	ยกเลิก ตู้พลาสติก แบบกันน้ำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตู้	135.00	\N	0	0.00	\N	\N	f	\N
788	P230-000788	วัสดุใช้ไป	เบรคเกอร์ ขนาด 20A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	125.00	\N	0	0.00	\N	\N	t	\N
789	P230-000789	วัสดุใช้ไป	ข้อต่อ ชนิดพลาสติก สำหรับเข้ากล่อง ขนาด 1/2 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	24.00	\N	0	0.00	\N	\N	t	\N
790	P230-000790	วัสดุใช้ไป	กิ๊บ ชนิดทองเหลือง สำหรับรัดสายท่อแก็ส	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	15.00	\N	0	0.00	\N	\N	t	\N
791	P230-000791	วัสดุใช้ไป	สามทาง ชนิด PVC แบบลด ขนาด 1*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	20.00	\N	0	0.00	\N	\N	t	\N
792	P230-000792	วัสดุใช้ไป	ยกเลิก ข้อต่อตรง ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	12.00	\N	0	0.00	\N	\N	f	\N
793	P230-000793	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 1*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	6.00	\N	0	0.00	\N	\N	t	\N
794	P230-000794	วัสดุใช้ไป	ข้อต่อสายยาง ชนิด PVC ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	12.00	\N	0	0.00	\N	\N	t	\N
795	P230-000795	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง แบบเหยียบ วาล์วกลม ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	600.00	\N	0	0.00	\N	\N	t	\N
796	P230-000796	วัสดุใช้ไป	ฝักบัวอาบน้ำ แบบพร้อมวาล์วฝักบัว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	297.00	\N	0	0.00	\N	\N	t	\N
797	P230-000797	วัสดุใช้ไป	มือจับ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	24.00	\N	0	0.00	\N	\N	t	\N
798	P230-000798	วัสดุใช้ไป	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 2 หุน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	90.00	\N	0	0.00	\N	\N	t	\N
799	P230-000799	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N
800	P230-000800	วัสดุใช้ไป	กิ๊บ ชนิดทองเหลือง สำหรับรัดท่อ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	3.00	\N	0	0.00	\N	\N	t	\N
801	P230-000801	วัสดุใช้ไป	ลวดเชื่อม สำหรับเหล็ก ขนาด 2 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ห่อ	200.00	\N	0	0.00	\N	\N	t	\N
802	P230-000802	วัสดุใช้ไป	ใบตัด สำหรับตัดเหล็ก ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	22.00	\N	0	0.00	\N	\N	t	\N
803	P230-000803	วัสดุใช้ไป	ดอกสว่าน ขนาด 9/64	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอก	33.00	\N	0	0.00	\N	\N	t	\N
804	P230-000804	วัสดุใช้ไป	ปืนยิงซิลิโคน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ด้าม	95.00	\N	0	0.00	\N	\N	t	\N
805	P230-000805	วัสดุใช้ไป	กาว ชนิด 2 ตัน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	132.00	\N	0	0.00	\N	\N	t	\N
806	P230-000806	วัสดุใช้ไป	ไม้อัด หนา 8 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	420.00	\N	0	0.00	\N	\N	t	\N
807	P230-000807	วัสดุใช้ไป	ท่อสายไฟ ชนิด PVC แบบท่ออ่อน ขนาด 1/2 นิ้ว สีขาว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	17.00	\N	0	0.00	\N	\N	t	\N
808	P230-000808	วัสดุใช้ไป	กล่องพักสาย ชนิดพลาสติก แบบเหลี่ยม ขนาด 2/4 นิ้ว สีขาว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N
809	P230-000809	วัสดุใช้ไป	ข้อต่อตรง ชนิดเหล็ก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	33.00	\N	0	0.00	\N	\N	t	\N
810	P230-000810	วัสดุใช้ไป	ยกเลิก ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	440.00	\N	0	0.00	\N	\N	f	\N
811	P230-000811	วัสดุใช้ไป	บานพับ ขนาด 3*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	17.00	\N	0	0.00	\N	\N	t	\N
812	P230-000812	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบต่อหลัง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	275.00	\N	0	0.00	\N	\N	t	\N
813	P230-000813	วัสดุใช้ไป	เบาะหุ้มจักรยาน	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง	อัน	180.00	\N	0	0.00	\N	\N	t	\N
814	P230-000814	วัสดุใช้ไป	แท่งกราวด์ ขนาด 1.8 ม.	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	160.00	\N	0	0.00	\N	\N	t	\N
815	P230-000815	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับแก้วชน แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N
816	P230-000816	วัสดุใช้ไป	ชุดสายชำระ แบบรวมหัวฉีดและสายชำระ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	390.00	\N	0	0.00	\N	\N	t	\N
817	P230-000817	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	48.00	\N	0	0.00	\N	\N	t	\N
818	P230-000818	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 3/4 * 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	10.00	\N	0	0.00	\N	\N	t	\N
819	P230-000819	วัสดุใช้ไป	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 1/4 หุน 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	55.00	\N	0	0.00	\N	\N	t	\N
820	P230-000820	วัสดุใช้ไป	มินิวาล์ว ชนิดทองเหลือง แบบเกลียวนอก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	155.00	\N	0	0.00	\N	\N	t	\N
821	P230-000821	วัสดุใช้ไป	กระดาษชาร์ท หนา 450 แกรม สีเทา-ขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	20.00	\N	0	0.00	\N	\N	t	\N
824	P230-000824	วัสดุใช้ไป	สีน้ำมัน ชนิดทาภายนอก ขนาด 2.5 ลิตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	2490.00	\N	0	0.00	\N	\N	t	\N
825	P230-000825	วัสดุใช้ไป	สีน้ำมัน ชนิดทาภายใน ขนาด 1 ลิตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	1195.00	\N	0	0.00	\N	\N	t	\N
826	P230-000826	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 2.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	65.00	\N	0	0.00	\N	\N	t	\N
827	P230-000827	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	95.00	\N	0	0.00	\N	\N	t	\N
828	P230-000828	วัสดุใช้ไป	ลูกกลิ้งทาสี ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	79.00	\N	0	0.00	\N	\N	t	\N
829	P230-000829	วัสดุใช้ไป	ด้ามต่อ สำหรับต่อลูกกลิ้งทาสี ยาว 2 เมตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	109.00	\N	0	0.00	\N	\N	t	\N
830	P230-000830	วัสดุใช้ไป	แม่สี เบอร์ BV	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี.	1.50	\N	0	0.00	\N	\N	t	\N
831	P230-000831	วัสดุใช้ไป	แม่สี เบอร์ OK	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี.	1.50	\N	0	0.00	\N	\N	t	\N
832	P230-000832	วัสดุใช้ไป	แม่สี เบอร์ SS	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี.	2.00	\N	0	0.00	\N	\N	t	\N
833	P230-000833	วัสดุใช้ไป	แม่สี เบอร์ ST	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี.	2.50	\N	0	0.00	\N	\N	t	\N
834	P230-000834	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 3/4 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	11.50	\N	0	0.00	\N	\N	t	\N
835	P230-000835	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	150.00	\N	0	0.00	\N	\N	t	\N
836	P230-000836	วัสดุใช้ไป	ยูเนียน ชนิดเหล็ก ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	205.00	\N	0	0.00	\N	\N	t	\N
837	P230-000837	วัสดุใช้ไป	ยกเลิก ข้องอ ชนิด PVC หนา แบบ 90 องศา ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	40.00	\N	0	0.00	\N	\N	f	\N
838	P230-000838	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	28.00	\N	0	0.00	\N	\N	t	\N
839	P230-000839	วัสดุใช้ไป	เกลียวนอก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	28.00	\N	0	0.00	\N	\N	t	\N
840	P230-000840	วัสดุใช้ไป	หนังสือ มาตฐาน SPA part I , II , III , IV	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	550.00	\N	0	0.00	\N	\N	t	\N
841	P230-000841	วัสดุใช้ไป	รางสายไฟ แบบ DT1225 นาโน	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	55.00	\N	0	0.00	\N	\N	t	\N
842	P230-000842	วัสดุใช้ไป	สต๊อปวาล์ว ชนิดลอย แบบหัวแก้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N
843	P230-000843	วัสดุใช้ไป	สายน้ำดี ขนาด 32 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	75.00	\N	0	0.00	\N	\N	t	\N
844	P230-000844	วัสดุใช้ไป	จานเอ็น สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	อัน	130.00	\N	0	0.00	\N	\N	t	\N
845	P230-000845	วัสดุใช้ไป	กรรไกร สำหรับต้นไม้สูง สำหรับตัดแต่งกิ่ง ขนาด 1.5 เมตร	วัสดุการเกษตร	วัสดุการเกษตร	อัน	1790.00	\N	0	0.00	\N	\N	t	\N
846	P230-000846	วัสดุใช้ไป	ตะไบ ชนิดกลม สำหรับเลื่อยยนต์ ขนาด 3/8 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	อัน	180.00	\N	0	0.00	\N	\N	t	\N
847	P230-000847	วัสดุใช้ไป	ตะไบ ชนิดกลม สำหรับเลื่อยยนต์ ขนาด 4 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	อัน	260.00	\N	0	0.00	\N	\N	t	\N
848	P230-000848	วัสดุใช้ไป	ยกเลิก จารบี สำหรับเครื่องตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	กระป๋อง	100.00	\N	0	0.00	\N	\N	f	\N
849	P230-000849	วัสดุใช้ไป	HDMI extender	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	1390.00	\N	0	0.00	\N	\N	t	\N
850	P230-000850	วัสดุใช้ไป	มือจับ แบบก้านโยก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	1490.00	\N	0	0.00	\N	\N	t	\N
851	P230-000851	วัสดุใช้ไป	ยกเลิก ปากกา เขียนแผ่น CD สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	40.00	\N	0	0.00	\N	\N	f	\N
852	P230-000852	วัสดุใช้ไป	ยกเลิก ปากกา เขียนแผ่น CD สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	40.00	\N	0	0.00	\N	\N	f	\N
853	P230-000853	วัสดุใช้ไป	ชุดดรัมหมึก HP e77830 สำหรับเครื่องถ่ายเอกสาร	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	9500.00	\N	0	0.00	\N	\N	t	\N
854	P230-000854	วัสดุใช้ไป	เทปกาว ชนิด 2 หน้า แบบบาง ขนาด 1 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	132.00	\N	0	0.00	\N	\N	t	\N
855	P230-000855	วัสดุใช้ไป	ถังขยะ ชนิดสแตนเลส แบบเท้าเหยียบ ขนาด 20 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1690.00	\N	0	0.00	\N	\N	t	\N
856	P230-000856	วัสดุใช้ไป	สกรู ชนิดเกลียวปล่อย ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	77.00	\N	0	0.00	\N	\N	t	\N
857	P230-000857	วัสดุใช้ไป	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 6.5 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	94.00	\N	0	0.00	\N	\N	t	\N
858	P230-000858	วัสดุใช้ไป	รีเวท ขนาด (4-3)	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	31.00	\N	0	0.00	\N	\N	t	\N
859	P230-000859	วัสดุใช้ไป	ล้อรถเข็น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	660.00	\N	0	0.00	\N	\N	t	\N
860	P230-000860	วัสดุใช้ไป	กาว ชนิดยาง ขนาดเล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระปุก	83.00	\N	0	0.00	\N	\N	t	\N
861	P230-000861	วัสดุใช้ไป	ล้อรถเข็น ชนิดยาง แบบเกลียว ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	121.00	\N	0	0.00	\N	\N	t	\N
862	P230-000862	วัสดุใช้ไป	กระเบื้อง ชนิดลอนคู่ ขนาด 1.5 เมตร สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	70.00	\N	0	0.00	\N	\N	t	\N
863	P230-000863	วัสดุใช้ไป	สกรู ชนิดปลายสว่าน ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	3.50	\N	0	0.00	\N	\N	t	\N
864	P230-000864	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีล้อ พร้อมฝาปิด ขนาด 100 ลิตร	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	359.00	\N	0	0.00	\N	\N	t	\N
865	P230-000865	วัสดุใช้ไป	สายยาง ขนาด 1/2 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เมตร	20.00	\N	0	0.00	\N	\N	t	\N
866	P230-000866	วัสดุใช้ไป	ยกเลิก หมึก Printer Laser Fuji Apeos C325/328 dw	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	f	\N
867	P230-000867	วัสดุใช้ไป	สกรู ชนิดปลายสว่าน ขนาด 8*3/4	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	20.00	\N	0	0.00	\N	\N	t	\N
868	P230-000868	วัสดุใช้ไป	น๊อต แบบเกลียวปล่อย ขนาด 7*1/2	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	15.00	\N	0	0.00	\N	\N	t	\N
869	P230-000869	วัสดุใช้ไป	พุก ชนิดพลาสติก แบบผีเสื้อ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	5.00	\N	0	0.00	\N	\N	t	\N
870	P230-000870	วัสดุใช้ไป	น๊อต แบบเกลียวปล่อย ขนาด 8*2	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	25.00	\N	0	0.00	\N	\N	t	\N
871	P230-000871	วัสดุใช้ไป	แม่สี เบอร์ CS04 สีดำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี	2.50	\N	0	0.00	\N	\N	t	\N
872	P230-000872	วัสดุใช้ไป	แม่สี เบอร์ CS06 สีน้ำเงิน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี	2.50	\N	0	0.00	\N	\N	t	\N
873	P230-000873	วัสดุใช้ไป	แม่สี เบอร์ CS08 สีแดงออกไซด์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซีซี	1.75	\N	0	0.00	\N	\N	t	\N
874	P230-000874	วัสดุใช้ไป	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี BK	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6600.00	\N	0	0.00	\N	\N	t	\N
875	P230-000875	วัสดุใช้ไป	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี C	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6600.00	\N	0	0.00	\N	\N	t	\N
876	P230-000876	วัสดุใช้ไป	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี M	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6600.00	\N	0	0.00	\N	\N	t	\N
986	P230-000986	วัสดุใช้ไป	น้ำยาฆ่าหญ้า แบบขวด	วัสดุการเกษตร	วัสดุการเกษตร	ขวด	500.00	\N	0	0.00	\N	\N	t	\N
877	P230-000877	วัสดุใช้ไป	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี Y	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6600.00	\N	0	0.00	\N	\N	t	\N
878	P230-000878	วัสดุใช้ไป	กรอบบัตรประจำตัว แบบแข็ง	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	12.00	\N	0	0.00	\N	\N	t	\N
879	P230-000879	วัสดุใช้ไป	สายคล้องคอ สำหรับบัตรประจำตัว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
880	P230-000880	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	44.00	\N	0	0.00	\N	\N	t	\N
881	P230-000881	วัสดุใช้ไป	บอลวาล์ว ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	1265.00	\N	0	0.00	\N	\N	t	\N
882	P230-000882	วัสดุใช้ไป	แผ่นปิดรอยต่อ ขนาดม้วนใหญ่	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	550.00	\N	0	0.00	\N	\N	t	\N
883	P230-000883	วัสดุใช้ไป	ล้อรถเข็น ชนิดบอล แบบเกลียว ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	155.00	\N	0	0.00	\N	\N	t	\N
884	P230-000884	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	26.00	\N	0	0.00	\N	\N	t	\N
885	P230-000885	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบลด ขนาด 13.5*2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	420.00	\N	0	0.00	\N	\N	t	\N
886	P230-000886	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบลด ขนาด 8.5*2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	227.00	\N	0	0.00	\N	\N	t	\N
887	P230-000887	วัสดุใช้ไป	ไฟสนาม แบบสปอตไลท์ ขนาด 2000 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	3890.00	\N	0	0.00	\N	\N	t	\N
888	P230-000888	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N
889	P230-000889	วัสดุใช้ไป	ยางรองชักโครก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	40.00	\N	0	0.00	\N	\N	t	\N
890	P230-000890	วัสดุใช้ไป	สายชักโครก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	65.00	\N	0	0.00	\N	\N	t	\N
891	P230-000891	วัสดุใช้ไป	ประตูน้ำ ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	220.00	\N	0	0.00	\N	\N	t	\N
892	P230-000892	วัสดุใช้ไป	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 500 กรัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	300.00	\N	0	0.00	\N	\N	t	\N
893	P230-000893	วัสดุใช้ไป	ฝาครอบ ชนิด PVC ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	14.00	\N	0	0.00	\N	\N	t	\N
894	P230-000894	วัสดุใช้ไป	ฝาครอบ ชนิด PVC ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	9.00	\N	0	0.00	\N	\N	t	\N
895	P230-000895	วัสดุใช้ไป	ข้อต่อลด ชนิด PVC ขนาด 2*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	44.00	\N	0	0.00	\N	\N	t	\N
896	P230-000896	วัสดุใช้ไป	ฟลัชวาล์ว ชนิดท่อโค้ง สำหรับโถชาย	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	679.00	\N	0	0.00	\N	\N	t	\N
897	P230-000897	วัสดุใช้ไป	ฝานั่งรองชักโครก ชนิดพลาสติก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	499.00	\N	0	0.00	\N	\N	t	\N
898	P230-000898	วัสดุใช้ไป	ตะแกรงรังผึ้ง ขนาด 2*1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	29.00	\N	0	0.00	\N	\N	t	\N
899	P230-000899	วัสดุใช้ไป	สีสะท้อนแสง ขนาด 3 ลิตร สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	820.00	\N	0	0.00	\N	\N	t	\N
900	P230-000900	วัสดุใช้ไป	สีสะท้อนแสง ขนาด 3 ลิตร สีดำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	850.00	\N	0	0.00	\N	\N	t	\N
901	P230-000901	วัสดุใช้ไป	สีน้ำมัน สีเทา	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	650.00	\N	0	0.00	\N	\N	t	\N
902	P230-000902	วัสดุใช้ไป	ทินเนอร์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	175.00	\N	0	0.00	\N	\N	t	\N
929	P230-000929	วัสดุใช้ไป	ดอกสว่าน ชนิดโรตารี่	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	380.00	\N	0	0.00	\N	\N	t	\N
903	P230-000903	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	85.00	\N	0	0.00	\N	\N	t	\N
904	P230-000904	วัสดุใช้ไป	สกรู ชนิดเกลียวปล่อย ขนาด 3.5*40 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	36.00	\N	0	0.00	\N	\N	t	\N
905	P230-000905	วัสดุใช้ไป	อีพ๊อคซี่ สำหรับเสียบเหล็ก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิโลกรัม	359.00	\N	0	0.00	\N	\N	t	\N
906	P230-000906	วัสดุใช้ไป	ดอกสว่าน ชนิดเจาะเหล็ก แบบ 19 ชิ้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	390.00	\N	0	0.00	\N	\N	t	\N
907	P230-000907	วัสดุใช้ไป	สายวัด ยาว 30 เมตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	639.00	\N	0	0.00	\N	\N	t	\N
908	P230-000908	วัสดุใช้ไป	มีดคัทเตอร์ แบบด้ามพลาสติก ยาว 18 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	149.00	\N	0	0.00	\N	\N	t	\N
909	P230-000909	วัสดุใช้ไป	ประแจเลื่อน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	255.00	\N	0	0.00	\N	\N	t	\N
910	P230-000910	วัสดุใช้ไป	ไขควง แบบสลับหัว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	109.00	\N	0	0.00	\N	\N	t	\N
911	P230-000911	วัสดุใช้ไป	ปากกา สำหรับตัดกระเบื้องและกระจก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	289.00	\N	0	0.00	\N	\N	t	\N
912	P230-000912	วัสดุใช้ไป	แปรง ชนิดลวด แบบรูปถ้วย ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	89.00	\N	0	0.00	\N	\N	t	\N
913	P230-000913	วัสดุใช้ไป	คีม ชนิดปากแหลม ขนาด 6 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	179.00	\N	0	0.00	\N	\N	t	\N
914	P230-000914	วัสดุใช้ไป	คีม ชนิดปากแหลม ขนาด 8 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	230.00	\N	0	0.00	\N	\N	t	\N
915	P230-000915	วัสดุใช้ไป	สกัด ชนิดปากแบน แบบด้ามยาง ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	99.00	\N	0	0.00	\N	\N	t	\N
916	P230-000916	วัสดุใช้ไป	ไขควง แบบสลับหัว ขนาด 6 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	60.00	\N	0	0.00	\N	\N	t	\N
917	P230-000917	วัสดุใช้ไป	ประแจ แบบแหวนข้างปากตาย เบอร์ 21	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	99.00	\N	0	0.00	\N	\N	t	\N
918	P230-000918	วัสดุใช้ไป	มีดคัทเตอร์ แบบด้ามโลหะ ยาว 18 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	49.00	\N	0	0.00	\N	\N	t	\N
919	P230-000919	วัสดุใช้ไป	ชุด 6 เหลี่ยม แบบ 13 ชิ้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	599.00	\N	0	0.00	\N	\N	t	\N
920	P230-000920	วัสดุใช้ไป	คีม ชนิดปากตรง สำหรับล๊อค ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	225.00	\N	0	0.00	\N	\N	t	\N
921	P230-000921	วัสดุใช้ไป	ไขควง แบบสลับหัว ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	59.00	\N	0	0.00	\N	\N	t	\N
922	P230-000922	วัสดุใช้ไป	ค้อน ชนิดเหล็ก แบบหงอน ด้ามไฟเบอร์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	169.00	\N	0	0.00	\N	\N	t	\N
923	P230-000923	วัสดุใช้ไป	ปากกา สำหรับเช็คกระแสไฟ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	139.00	\N	0	0.00	\N	\N	t	\N
924	P230-000924	วัสดุใช้ไป	ชุด 6 เหลี่ยม แบบ 9 ชิ้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	169.00	\N	0	0.00	\N	\N	t	\N
925	P230-000925	วัสดุใช้ไป	ด้ามกบไสไม้ แบบพร้อมลิ่ม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	30.00	\N	0	0.00	\N	\N	t	\N
926	P230-000926	วัสดุใช้ไป	คีม ชนิดปากเฉียง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	125.00	\N	0	0.00	\N	\N	t	\N
927	P230-000927	วัสดุใช้ไป	กรรไกร สำหรับตัดแผ่นโลหะ ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	239.00	\N	0	0.00	\N	\N	t	\N
928	P230-000928	วัสดุใช้ไป	สิ่ว ชนิดเหล็ก แบบด้ามไม้	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	50.00	\N	0	0.00	\N	\N	t	\N
930	P230-000930	วัสดุใช้ไป	ประแจ แบบแหวนข้างปากตาย เบอร์ 14	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	69.00	\N	0	0.00	\N	\N	t	\N
931	P230-000931	วัสดุใช้ไป	ไขควง ซ่อมนาฬิกา แบบ 4 ชิ้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	89.00	\N	0	0.00	\N	\N	t	\N
932	P230-000932	วัสดุใช้ไป	กบไสไม้ ขนาด 8 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	260.00	\N	0	0.00	\N	\N	t	\N
933	P230-000933	วัสดุใช้ไป	ใบมีดกบไสไม้ ขนาด 1.3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	65.00	\N	0	0.00	\N	\N	t	\N
934	P230-000934	วัสดุใช้ไป	สกัด ชนิดปากแหลม แบบด้ามยาง ขนาด 10 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	99.00	\N	0	0.00	\N	\N	t	\N
935	P230-000935	วัสดุใช้ไป	เลื่อย ชนิดโครงเหล็ก ขนาด 12 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	115.00	\N	0	0.00	\N	\N	t	\N
936	P230-000936	วัสดุใช้ไป	หมึก Printer Laser TN 1000	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	390.00	\N	0	0.00	\N	\N	t	\N
937	P230-000937	วัสดุใช้ไป	หมึก Printer Laser PANTUM P2500	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	850.00	\N	0	0.00	\N	\N	t	\N
939	P230-000939	วัสดุใช้ไป	ถ่าน BIOS แบบ LR2032	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	55.00	\N	0	0.00	\N	\N	t	\N
941	P230-000941	วัสดุใช้ไป	Hardisk ชนิด SSD External ขนาด 240 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1090.00	\N	0	0.00	\N	\N	t	\N
946	P230-000946	วัสดุใช้ไป	หมึก Printer Laser Fuji Apeos C325/328 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N
947	P230-000947	วัสดุใช้ไป	หมึก Printer Laser Fuji Apeos C325/328 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N
948	P230-000948	วัสดุใช้ไป	หมึก Printer Laser Fuji Apeos C325/328 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N
949	P230-000949	วัสดุใช้ไป	หมึก Printer Laser Fuji Apeos C325/328 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N
950	P230-000950	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ถัขนาด 3 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	390.00	\N	0	0.00	\N	\N	t	\N
951	P230-000951	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 5 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	390.00	\N	0	0.00	\N	\N	t	\N
952	P230-000952	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	60.00	\N	0	0.00	\N	\N	t	\N
953	P230-000953	วัสดุใช้ไป	ตะกร้า ชนิดหวาย แบบทรงเหลี่ยม ขนาด 30 x 20 x 9 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	200.00	\N	0	0.00	\N	\N	t	\N
954	P230-000954	วัสดุใช้ไป	ตะกร้า ชนิดพลาสติก แบบทรงเหลี่ยม ขนาด 32 x 21 x 14 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	250.00	\N	0	0.00	\N	\N	t	\N
955	P230-000955	วัสดุใช้ไป	สบู่ แบบเหลว สำหรับทารก ขนาด 850 ซีซี.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	60.00	\N	0	0.00	\N	\N	t	\N
956	P230-000956	วัสดุใช้ไป	หวี สำหรับเด็ก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	30.00	\N	0	0.00	\N	\N	t	\N
985	P230-000985	วัสดุใช้ไป	เมล็ดพันธ์ดอกไม้	วัสดุการเกษตร	วัสดุการเกษตร	กิโลกรัม	500.00	\N	0	0.00	\N	\N	t	\N
957	P230-000957	วัสดุใช้ไป	ตะกร้า สำหรับใส่อุปกรณ์อาบน้ำเด็ก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	40.00	\N	0	0.00	\N	\N	t	\N
958	P230-000958	วัสดุใช้ไป	กะละมัง สำหรับอาบน้ำเด็ก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	260.00	\N	0	0.00	\N	\N	t	\N
959	P230-000959	วัสดุใช้ไป	กระติกน้ำแข็ง ขนาด 10 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	200.00	\N	0	0.00	\N	\N	t	\N
960	P230-000960	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*20 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	60.00	\N	0	0.00	\N	\N	t	\N
961	P230-000961	วัสดุใช้ไป	น้ำกลั่นแบตเตอรี่ สำหรับเครื่องนึ่ง EO ขนาด 1 ลิตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขวด	200.00	\N	0	0.00	\N	\N	t	\N
962	P230-000962	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 40 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	120.00	\N	0	0.00	\N	\N	t	\N
963	P230-000963	วัสดุใช้ไป	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 10 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	399.00	\N	0	0.00	\N	\N	t	\N
964	P230-000964	วัสดุใช้ไป	กรอบรูป ขนาด 4x6 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	200.00	\N	0	0.00	\N	\N	t	\N
965	P230-000965	วัสดุใช้ไป	พู่กัน เบอร์8	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	40.00	\N	0	0.00	\N	\N	t	\N
966	P230-000966	วัสดุใช้ไป	ยกเลิก แฟ้ม แบบแขวน สีม่วง	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	90.00	\N	0	0.00	\N	\N	f	\N
967	P230-000967	วัสดุใช้ไป	เทปกาว ชนิดแลกซีน ขนาด 1.5 นิ้ว ยาว 8 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N
968	P230-000968	วัสดุใช้ไป	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N
969	P230-000969	วัสดุใช้ไป	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N
970	P230-000970	วัสดุใช้ไป	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N
971	P230-000971	วัสดุใช้ไป	เครื่องเย็บกระดาษ ขนาดใหญ่	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	2500.00	\N	0	0.00	\N	\N	t	\N
972	P230-000972	วัสดุใช้ไป	กระดาษโน๊ต แบบมีกาว ขนาด 7.5x 7.5 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	80.00	\N	0	0.00	\N	\N	t	\N
973	P230-000973	วัสดุใช้ไป	กระดาษโน๊ต แบบมีกาว ขนาด 2.5x 7.5 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	80.00	\N	0	0.00	\N	\N	t	\N
974	P230-000974	วัสดุใช้ไป	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N
975	P230-000975	วัสดุใช้ไป	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N
976	P230-000976	วัสดุใช้ไป	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	120.00	\N	0	0.00	\N	\N	t	\N
977	P230-000977	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 23/10	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	60.00	\N	0	0.00	\N	\N	t	\N
978	P230-000978	วัสดุใช้ไป	เสื้อกาวน์ แบบกันน้ำ	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	490.00	\N	0	0.00	\N	\N	t	\N
979	P230-000979	วัสดุใช้ไป	ใบหินเจียร แบบหนา ขนาด 4 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	ใบ	350.00	\N	0	0.00	\N	\N	t	\N
980	P230-000980	วัสดุใช้ไป	ลวดมัดเหล็ก	วัสดุการเกษตร	วัสดุการเกษตร	ม้วน	120.00	\N	0	0.00	\N	\N	t	\N
981	P230-000981	วัสดุใช้ไป	คีม สำหรับมัดลวด	วัสดุการเกษตร	วัสดุการเกษตร	อัน	100.00	\N	0	0.00	\N	\N	t	\N
982	P230-000982	วัสดุใช้ไป	ไขควง ชนิดปากแฉก	วัสดุการเกษตร	วัสดุการเกษตร	อัน	180.00	\N	0	0.00	\N	\N	t	\N
983	P230-000983	วัสดุใช้ไป	ไขควง ชนิดปากแบน	วัสดุการเกษตร	วัสดุการเกษตร	อัน	180.00	\N	0	0.00	\N	\N	t	\N
984	P230-000984	วัสดุใช้ไป	เชือก ชนิดป่านมะนิลา ขนาด 18 มม. สีขาว	วัสดุการเกษตร	วัสดุการเกษตร	เมตร	450.00	\N	0	0.00	\N	\N	t	\N
1257	P230-001257	วัสดุใช้ไป	โคมไฟโรงงาน ขนาด 18 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	478.00	\N	0	0.00	\N	\N	t	\N
988	P230-000988	วัสดุใช้ไป	Hardisk ชนิด SSD External ขนาด 500 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เครื่อง	3000.00	\N	0	0.00	\N	\N	t	\N
990	P230-000990	วัสดุใช้ไป	เสื้อผู้ป่วยแขนสั้น ชนิดกระดุมหรือเชือกผูก แบบผ่าหลัง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	400.00	\N	0	0.00	\N	\N	t	\N
991	P230-000991	วัสดุใช้ไป	เสื้อกั๊ก สะท้อนแสง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N
992	P230-000992	วัสดุใช้ไป	บอร์ด สำหรับผังบุคลากร ขนาด 50 x 70 ซม.	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	อัน	550.00	\N	0	0.00	\N	\N	t	\N
993	P230-000993	วัสดุใช้ไป	ป้ายชื่อ สำหรับหน่วยงาน	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ชิ้น	4000.00	\N	0	0.00	\N	\N	t	\N
994	P230-000994	วัสดุใช้ไป	ยกเลิก ถังขยะ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1000.00	\N	0	0.00	\N	\N	f	\N
995	P230-000995	วัสดุใช้ไป	ถังผ้า สำหรับผู้ป่วยห้องพิเศษ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1000.00	\N	0	0.00	\N	\N	t	\N
996	P230-000996	วัสดุใช้ไป	ถังผ้า สำหรับผู้ป่วยสามัญ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1500.00	\N	0	0.00	\N	\N	t	\N
997	P230-000997	วัสดุใช้ไป	โมเดลอาหาร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	7500.00	\N	0	0.00	\N	\N	t	\N
998	P230-000998	วัสดุใช้ไป	กล่องพลาสติก ทรงสี่เหลี่ยม แบบพร้อมหูหิ้วและฝาปิดระบบล๊อค	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	220.00	\N	0	0.00	\N	\N	t	\N
999	P230-000999	วัสดุใช้ไป	หมอน สำหรับรองให้นมบุตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	500.00	\N	0	0.00	\N	\N	t	\N
1000	P230-001000	วัสดุใช้ไป	กล่องพลาสติก ทรงสี่เหลี่ยม แบบมีฝาปิด ขนาด 100 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	500.00	\N	0	0.00	\N	\N	t	\N
1001	P230-001001	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก ถังขยะพลาสติก ขนาดไม่น้อยกว่า 60 ลิตร แบบเท้าเหยียบ ขนาด 60 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถัง	1500.00	\N	0	0.00	\N	\N	t	\N
1002	P230-001002	วัสดุใช้ไป	กล่องรองเท้า แบบฝาหน้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่อง	150.00	\N	0	0.00	\N	\N	t	\N
1003	P230-001003	วัสดุใช้ไป	กระจกเงา ขนาด 55 x 90 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	บาน	2090.00	\N	0	0.00	\N	\N	t	\N
1004	P230-001004	วัสดุใช้ไป	ตะกร้า แบบทรงเหลี่ยม ขนาด 37.5 x 26.5 x 14.2 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	159.00	\N	0	0.00	\N	\N	t	\N
1005	P230-001005	วัสดุใช้ไป	รองเท้า แบบ Slippers ขนาด Free size	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	259.00	\N	0	0.00	\N	\N	t	\N
1006	P230-001006	วัสดุใช้ไป	ผ้าขนหนู ขนาด 24 x 48 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	โหล	1200.00	\N	0	0.00	\N	\N	t	\N
1007	P230-001007	วัสดุใช้ไป	มู่ลี่ ชนิดไวนิล ขนาด 120 x 160 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	750.00	\N	0	0.00	\N	\N	t	\N
1008	P230-001008	วัสดุใช้ไป	เก้าอี้ ชนิดพลาสติก เกรด A สำหรับผู้ป่วย	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	500.00	\N	0	0.00	\N	\N	t	\N
1009	P230-001009	วัสดุใช้ไป	นาฬิกา แบบแขวนผนัง	วัสดุสำนักงาน	วัสดุสำนักงาน	เรือน	400.00	\N	0	0.00	\N	\N	t	\N
1010	P230-001010	วัสดุใช้ไป	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	290.00	\N	0	0.00	\N	\N	f	\N
1011	P230-001011	วัสดุใช้ไป	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 7 ชั้น ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	1000.00	\N	0	0.00	\N	\N	t	\N
1012	P230-001012	วัสดุใช้ไป	เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	350.00	\N	0	0.00	\N	\N	t	\N
1013	P230-001013	วัสดุใช้ไป	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	290.00	\N	0	0.00	\N	\N	f	\N
1014	P230-001014	วัสดุใช้ไป	ป้ายอะคริลิค ขนาด 12 x 25 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	170.00	\N	0	0.00	\N	\N	t	\N
1015	P230-001015	วัสดุใช้ไป	ป้ายอะคริลิค ขนาด 10 x 15 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	150.00	\N	0	0.00	\N	\N	t	\N
1016	P230-001016	วัสดุใช้ไป	ป้ายอะคริลิค ขนาด 20 x 50 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	300.00	\N	0	0.00	\N	\N	t	\N
1017	P230-001017	วัสดุใช้ไป	ป้ายอะคริลิค ขนาด 15 x 15 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ชิ้น	170.00	\N	0	0.00	\N	\N	t	\N
1018	P230-001018	วัสดุใช้ไป	ชั้นอเนกประสงค์ ชนิดพลาสติก	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	300.00	\N	0	0.00	\N	\N	t	\N
1019	P230-001019	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก สำหรับเก็บเครื่องมือ ขนาด 12 นิ้ว สีใส	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	300.00	\N	0	0.00	\N	\N	t	\N
1020	P230-001020	วัสดุใช้ไป	ชาร์ททะเบียนผู้ป่วย แบบอลูมีเนียม	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	600.00	\N	0	0.00	\N	\N	t	\N
1021	P230-001021	วัสดุใช้ไป	กรวยจราจร ชนิดพับเก็บได้ พลาสติก ขนาด 42 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	กรวย	350.00	\N	0	0.00	\N	\N	t	\N
1022	P230-001022	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่าง แบบกากบาท ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	520.00	\N	0	0.00	\N	\N	t	\N
1023	P230-001023	วัสดุใช้ไป	ตะแกรงน้ำทิ้ง แบบสแตนเลส ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	12.00	\N	0	0.00	\N	\N	t	\N
1024	P230-001024	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบใบพาย ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	550.00	\N	0	0.00	\N	\N	t	\N
1025	P230-001025	วัสดุใช้ไป	สกรูปลายสว่าน ขนาด 8 x 1	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	20.00	\N	0	0.00	\N	\N	t	\N
1026	P230-001026	วัสดุใช้ไป	สกรูปลายสว่าน ขนาด 8 x 2	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	25.00	\N	0	0.00	\N	\N	t	\N
1027	P230-001027	วัสดุใช้ไป	สกรูปลายสว่าน ขนาด 3/4	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	20.00	\N	0	0.00	\N	\N	t	\N
1028	P230-001028	วัสดุใช้ไป	ตระแกรง ชนิดพลาสติก แบบก้างปลารังผึ้ง ขนาดกลาง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N
1029	P230-001029	วัสดุใช้ไป	โคมไฟ ชนิดคู่ แบบออกไก่ ขนาด 2 x 40 watt.	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	320.00	\N	0	0.00	\N	\N	t	\N
1030	P230-001030	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 10 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	75.00	\N	0	0.00	\N	\N	t	\N
1031	P230-001031	วัสดุใช้ไป	สีน้ำมัน สีทองคำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระป๋อง	385.00	\N	0	0.00	\N	\N	t	\N
1032	P230-001032	วัสดุใช้ไป	กาว ชนิด epoxy	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	132.00	\N	0	0.00	\N	\N	t	\N
1033	P230-001033	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบต่อล่าง ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	605.00	\N	0	0.00	\N	\N	t	\N
1034	P230-001034	วัสดุใช้ไป	ยกเลิก ไมค์โครโฟน แบบไร้สาย	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ชุด	2900.00	\N	0	0.00	\N	\N	f	\N
1035	P230-001035	วัสดุใช้ไป	แบตเตอรี่ ขนาด 4V 5AH DEL	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูก	219.00	\N	0	0.00	\N	\N	t	\N
1036	P230-001036	วัสดุใช้ไป	ป้ายชื่อ แบบสามเหลี่ยม ขนาด 4x12 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	95.00	\N	0	0.00	\N	\N	t	\N
1037	P230-001037	วัสดุใช้ไป	ก้างปลา	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	20.00	\N	0	0.00	\N	\N	t	\N
1038	P230-001038	วัสดุใช้ไป	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	1485.00	\N	0	0.00	\N	\N	t	\N
1039	P230-001039	วัสดุใช้ไป	เกลียวเร่ง ขนาด 3 หุน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	60.00	\N	0	0.00	\N	\N	t	\N
1040	P230-001040	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบกันน้ำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	56.00	\N	0	0.00	\N	\N	t	\N
1041	P230-001041	วัสดุใช้ไป	ถังปูน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ใบ	50.00	\N	0	0.00	\N	\N	t	\N
1042	P230-001042	วัสดุใช้ไป	เทปพิมพ์	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	600.00	\N	0	0.00	\N	\N	t	\N
1043	P230-001043	วัสดุใช้ไป	กระดาษถ่ายเอกสาร ขนาด A3	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	265.00	\N	0	0.00	\N	\N	t	\N
1044	P230-001044	วัสดุใช้ไป	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีขาวด้าน	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	125.00	\N	0	0.00	\N	\N	t	\N
1045	P230-001045	วัสดุใช้ไป	แผ่นรองตัด ขนาด 30*45 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	240.00	\N	0	0.00	\N	\N	t	\N
1046	P230-001046	วัสดุใช้ไป	ถังน้ำดื่ม ชนิดพลาสติก ขนาด 20 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	100.00	\N	0	0.00	\N	\N	t	\N
1047	P230-001047	วัสดุใช้ไป	กิ๊บ ชนิดทองเหลือง สำหรับสายสลิง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	7.00	\N	0	0.00	\N	\N	t	\N
1048	P230-001048	วัสดุใช้ไป	กาว ชนิดซิลิโคน สำหรับยาแนว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	50.00	\N	0	0.00	\N	\N	t	\N
1049	P230-001049	วัสดุใช้ไป	ถุงมือ ชนิดถัก แบบเคลือบไนไตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	35.00	\N	0	0.00	\N	\N	t	\N
1050	P230-001050	วัสดุใช้ไป	น้ำยา สำหรับประสานคอนกรีต	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	219.00	\N	0	0.00	\N	\N	t	\N
1051	P230-001051	วัสดุใช้ไป	น้ำยา สำหรับขจัดท่อตัน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	230.00	\N	0	0.00	\N	\N	t	\N
1052	P230-001052	วัสดุใช้ไป	เกล็ดโซดาไฟ สำหรับขจัดท่อตัน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	69.00	\N	0	0.00	\N	\N	t	\N
1053	P230-001053	วัสดุใช้ไป	สเปร์ย ชนิดโฟม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	359.00	\N	0	0.00	\N	\N	t	\N
1054	P230-001054	วัสดุใช้ไป	สามทาง ชนิด PVC แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	20.00	\N	0	0.00	\N	\N	t	\N
1055	P230-001055	วัสดุใช้ไป	น๊อต แบบเกลียว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	30.00	\N	0	0.00	\N	\N	t	\N
1056	P230-001056	วัสดุใช้ไป	ลวด	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิโลกรัม	70.00	\N	0	0.00	\N	\N	t	\N
1057	P230-001057	วัสดุใช้ไป	น๊อต ขนาด 2 หุน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิโลกรัม	100.00	\N	0	0.00	\N	\N	t	\N
1058	P230-001058	วัสดุใช้ไป	ท่อน้ำ ชนิดเหล็ก แบบตรง ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	1285.00	\N	0	0.00	\N	\N	t	\N
1059	P230-001059	วัสดุใช้ไป	นิปเปิ้ล ชนิดเหล็ก ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	110.00	\N	0	0.00	\N	\N	t	\N
1060	P230-001060	วัสดุใช้ไป	ข้องอ ชนิดเหล็ก แบบ 90 องศา ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	160.00	\N	0	0.00	\N	\N	t	\N
1061	P230-001061	วัสดุใช้ไป	สามทาง ชนิดเหล็ก แบบลด ขนาด 1*1/3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	220.00	\N	0	0.00	\N	\N	t	\N
1062	P230-001062	วัสดุใช้ไป	Ram BUS 2666 DDR4 ขนาด 8 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	790.00	\N	0	0.00	\N	\N	t	\N
1063	P230-001063	วัสดุใช้ไป	กุญแจ แบบบิด สำหรับบานเลื่อน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	570.00	\N	0	0.00	\N	\N	t	\N
1064	P230-001064	วัสดุใช้ไป	ปืนฉีด สำหรับปั้มลม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	320.00	\N	0	0.00	\N	\N	t	\N
1065	P230-001065	วัสดุใช้ไป	บันได ชนิดไม้ไผ่ แบบ 13 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	900.00	\N	0	0.00	\N	\N	t	\N
1066	P230-001066	วัสดุใช้ไป	สปริงเกอร์	วัสดุการเกษตร	วัสดุการเกษตร	ตัว	17.00	\N	0	0.00	\N	\N	t	\N
1067	P230-001067	วัสดุใช้ไป	ข้อต่อ ชนิดเหล็ก สำหรับต่อสายยาง ขนาด 1/2 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	ตัว	28.00	\N	0	0.00	\N	\N	t	\N
1068	P230-001068	วัสดุใช้ไป	สาย Printer แบบ USB ขนาดยาว 5 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	159.00	\N	0	0.00	\N	\N	t	\N
1069	P230-001069	วัสดุใช้ไป	สาย Printer แบบ USB ขนาดยาว 10 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	220.00	\N	0	0.00	\N	\N	t	\N
1070	P230-001070	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างหน้า แบบหางปลา ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	590.00	\N	0	0.00	\N	\N	t	\N
1071	P230-001071	วัสดุใช้ไป	แม่สี เบอร์ 9RC	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	260.00	\N	0	0.00	\N	\N	t	\N
1072	P230-001072	วัสดุใช้ไป	เหล็กนำ STN	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	45.00	\N	0	0.00	\N	\N	t	\N
1073	P230-001073	วัสดุใช้ไป	ไมค์โครโฟน แบบมีสาย	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ตัว	790.00	\N	0	0.00	\N	\N	t	\N
1074	P230-001074	วัสดุใช้ไป	ไมค์โครโฟน ชนิดคู่ แบบไร้สาย	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ชุด	890.00	\N	0	0.00	\N	\N	t	\N
1075	P230-001075	วัสดุใช้ไป	หลอดไฟ ชนิด LED แบบฟูลเซ็ท ขนาด 16 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	295.00	\N	0	0.00	\N	\N	t	\N
1076	P230-001076	วัสดุใช้ไป	สาย RCA2 ขนาด 1.8 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	65.00	\N	0	0.00	\N	\N	t	\N
1077	P230-001077	วัสดุใช้ไป	กระจกโค้ง สำหรับมุมอับสายตา ขนาด 80 ซม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	980.00	\N	0	0.00	\N	\N	t	\N
1078	P230-001078	วัสดุใช้ไป	แบตเตอรี่ สำหรับเครื่องเอกซเรย์เคลื่อนที่ ขนาด 12V 9Ah	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชิ้น	2400.00	\N	0	0.00	\N	\N	t	\N
1079	P230-001079	วัสดุใช้ไป	ชุดหูฝานั่งรองชักโครก ชนิดพลาสติก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	650.00	\N	0	0.00	\N	\N	t	\N
1080	P230-001080	วัสดุใช้ไป	สกรู ชนิดไดวอ ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	95.00	\N	0	0.00	\N	\N	t	\N
1081	P230-001081	วัสดุใช้ไป	สกรู ชนิดหัวบล๊อค แบบปลายแหลม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	3.50	\N	0	0.00	\N	\N	t	\N
1082	P230-001082	วัสดุใช้ไป	กาว ชนิดยาง ขนาดใหญ่	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระปุก	144.00	\N	0	0.00	\N	\N	t	\N
1083	P230-001083	วัสดุใช้ไป	จอบ ชนิดเหล็ก แบบด้ามไม้	วัสดุการเกษตร	วัสดุการเกษตร	อัน	295.00	\N	0	0.00	\N	\N	t	\N
1084	P230-001084	วัสดุใช้ไป	เสียม ชนิดเหล็ก แบบด้ามไม้	วัสดุการเกษตร	วัสดุการเกษตร	อัน	315.00	\N	0	0.00	\N	\N	t	\N
1085	P230-001085	วัสดุใช้ไป	บันได ชนิดอลูมีเนียม แบบ 5 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	1090.00	\N	0	0.00	\N	\N	t	\N
1086	P230-001086	วัสดุใช้ไป	ป้าย ชนิดอลูมีเนียม ห้ามจอดรถ สีสท้อนแสง	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	แผ่น	535.00	\N	0	0.00	\N	\N	t	\N
1087	P230-001087	วัสดุใช้ไป	ป้าย ชนิดอลูมีเนียม ระวังสายไฟฟ้าแรงสูง สีสท้อนแสง	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	แผ่น	535.00	\N	0	0.00	\N	\N	t	\N
1088	P230-001088	วัสดุใช้ไป	ตาข่าย สำหรับกันสัตว์ปีนเสาไฟฟ้า ขนาด 45*65 ซม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	650.00	\N	0	0.00	\N	\N	t	\N
1089	P230-001089	วัสดุใช้ไป	กระดาษถ่ายเอกสาร ขนาด A5	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	65.00	\N	0	0.00	\N	\N	t	\N
1090	P230-001090	วัสดุใช้ไป	สายยาง ขนาด 5/8 นิ้ว ยาว 20 เมตร	วัสดุการเกษตร	วัสดุการเกษตร	เส้น	590.00	\N	0	0.00	\N	\N	t	\N
1091	P230-001091	วัสดุใช้ไป	ป้ายตราสัญลักษณ์ วปร. แบบพร้อมฐานตั้งโต๊ะ	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	650.00	\N	0	0.00	\N	\N	t	\N
1092	P230-001092	วัสดุใช้ไป	บันได ชนิดอลูมีเนียม แบบ 4 ขั้น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	2190.00	\N	0	0.00	\N	\N	t	\N
1093	P230-001093	วัสดุใช้ไป	หมึก Printer Laser TN-2560	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1390.00	\N	0	0.00	\N	\N	t	\N
1094	P230-001094	วัสดุใช้ไป	ก๊อกน้ำ ชนิดทองเหลือง สำหรับตู้คูลเลอร์ ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	390.00	\N	0	0.00	\N	\N	t	\N
1122	P230-001122	วัสดุใช้ไป	หลอดไฟ ชนิด LED แบบโซล่าเซล ขนาดใหญ่ ขนาด 535 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	400.00	\N	0	0.00	\N	\N	t	\N
1095	P230-001095	วัสดุใช้ไป	กุญแจ แบบขอสับ สำหรับบานเลื่อน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	450.00	\N	0	0.00	\N	\N	t	\N
1096	P230-001096	วัสดุใช้ไป	คีม ชนิดปากงอ สำหรับหนีบแหวน ขนาด 6 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	215.00	\N	0	0.00	\N	\N	t	\N
1097	P230-001097	วัสดุใช้ไป	คีม สำหรับปลอกสายไฟ ขนาด 9 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	200.00	\N	0	0.00	\N	\N	t	\N
1098	P230-001098	วัสดุใช้ไป	สายดิน ขนาด 1*2.5 สีเขียว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	12.00	\N	0	0.00	\N	\N	t	\N
1099	P230-001099	วัสดุใช้ไป	สายไฟ แบบคอนโทรล	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	10.00	\N	0	0.00	\N	\N	t	\N
1100	P230-001100	วัสดุใช้ไป	แท่งกราวด์ สำหรับโหลดทองแดง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	65.00	\N	0	0.00	\N	\N	t	\N
1101	P230-001101	วัสดุใช้ไป	หางปลา สำหรับสายคอนโทรล	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	270.00	\N	0	0.00	\N	\N	t	\N
1102	P230-001102	วัสดุใช้ไป	ยางปั๊มท่อน้ำ ขนาดหน้าใหญ่	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	110.00	\N	0	0.00	\N	\N	t	\N
1103	P230-001103	วัสดุใช้ไป	ผ้าใบคลุมเต้นท์ แบบโค้ง ขนาด 4*8 เมตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ผืน	13375.00	\N	0	0.00	\N	\N	t	\N
1104	P230-001104	วัสดุใช้ไป	ขันน้ำ ชนิดพลาสติก แบบไม่มีด้าม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	25.00	\N	0	0.00	\N	\N	t	\N
1105	P230-001105	วัสดุใช้ไป	ท่อสูบน้ำ ชนิดผ้าใบ PVC ขนาด 2 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	เมตร	80.00	\N	0	0.00	\N	\N	t	\N
1107	P230-001107	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 4 ช่อง และฝาล๊อค ขนาด 37.5 x 25.6 x 10 ซม. สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	159.00	\N	0	0.00	\N	\N	t	\N
1108	P230-001108	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 6 ช่อง และฝาล๊อค ขนาด 55.5 x 25.6 x 10 ซม. สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	199.00	\N	0	0.00	\N	\N	t	\N
1109	P230-001109	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีฝาล๊อค ขนาด 70.5 ลิตร สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	309.00	\N	0	0.00	\N	\N	t	\N
1110	P230-001110	วัสดุใช้ไป	ท่อน้ำ ชนิดเหล็ก ขนาด 2.5 นิ้ว สีดำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อ	1050.00	\N	0	0.00	\N	\N	t	\N
1111	P230-001111	วัสดุใช้ไป	น๊อต แบบเกลียวปล่อย ขนาด 7*1.5	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N
1112	P230-001112	วัสดุใช้ไป	ตะแกรงน้ำทิ้ง แบบสแตนเลส ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	11.00	\N	0	0.00	\N	\N	t	\N
1113	P230-001113	วัสดุใช้ไป	ปูน สำหรับยาแนว สีขาว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	50.00	\N	0	0.00	\N	\N	t	\N
1118	P230-001118	วัสดุใช้ไป	ราวจับ ชนิดสแตนเลส สำหรับจับกันลื่น	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	1159.00	\N	0	0.00	\N	\N	t	\N
1119	P230-001119	วัสดุใช้ไป	กล่องกระดาษชำระ ชนิดพลาสติก สำหรับห้องน้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	219.00	\N	0	0.00	\N	\N	t	\N
1120	P230-001120	วัสดุใช้ไป	หลอดไฟ ชนิด LED แบบไฟฉุกเฉินโซล่าเซล ขนาด 180 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	180.00	\N	0	0.00	\N	\N	t	\N
1121	P230-001121	วัสดุใช้ไป	ไฟฉุกเฉิน ชนิด LED ขนาด 2*6 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	1890.00	\N	0	0.00	\N	\N	t	\N
1123	P230-001123	วัสดุใช้ไป	ปลั๊กไฟพ่วง พร้อมล้อเก็บสายไฟ แบบ 4 ช่อง ขนาด 3600 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	2090.00	\N	0	0.00	\N	\N	t	\N
1124	P230-001124	วัสดุใช้ไป	สามทาง ชนิด PVC ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	70.00	\N	0	0.00	\N	\N	t	\N
1125	P230-001125	วัสดุใช้ไป	กระถาง พร้อมจานรอง สำหรับปลูกต้นไม้ ขนาด 9 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	ชุด	220.00	\N	0	0.00	\N	\N	t	\N
1126	P230-001126	วัสดุใช้ไป	รางสายไฟ แบบ TD205	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	85.00	\N	0	0.00	\N	\N	t	\N
1127	P230-001127	วัสดุใช้ไป	ก้านกดน้ำ แบบ BT007	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	149.00	\N	0	0.00	\N	\N	t	\N
1128	P230-001128	วัสดุใช้ไป	ก้านกดน้ำ แบบ BT008	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	109.00	\N	0	0.00	\N	\N	t	\N
1129	P230-001129	วัสดุใช้ไป	แผ่นเจียร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	25.00	\N	0	0.00	\N	\N	t	\N
1130	P230-001130	วัสดุใช้ไป	Memory card ชนิด Micro SD ขนาด 32 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	199.00	\N	0	0.00	\N	\N	t	\N
1131	P230-001131	วัสดุใช้ไป	ข้อต่อตรง ชนิด PVC แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	6.00	\N	0	0.00	\N	\N	t	\N
1132	P230-001132	วัสดุใช้ไป	สายเทป แบบร่อง ยาว 2 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	50.00	\N	0	0.00	\N	\N	t	\N
1133	P230-001133	วัสดุใช้ไป	หลอดไฟ ชนิด LED แบบตาแมว ขนาด 5 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	120.00	\N	0	0.00	\N	\N	t	\N
1134	P230-001134	วัสดุใช้ไป	สวิทช์ไฟ แบบ 2 จังหวะ ขนาด 22 มิลลิเมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	65.00	\N	0	0.00	\N	\N	t	\N
1135	P230-001135	วัสดุใช้ไป	ฝาอุดปลั๊กไฟ ชนิดพลาสติก	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	10.00	\N	0	0.00	\N	\N	t	\N
1136	P230-001136	วัสดุใช้ไป	เบรคเกอร์ ขนาด 60A	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	650.00	\N	0	0.00	\N	\N	t	\N
1137	P230-001137	วัสดุใช้ไป	หน้ากากปลั๊กไฟ แบบ 4 ช่อง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	30.00	\N	0	0.00	\N	\N	t	\N
1138	P230-001138	วัสดุใช้ไป	แบตเตอรี่ แบบกึ่งแห้ง สำหรับรถยนต์ ขนาด 12V 80Ah	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	3400.00	\N	0	0.00	\N	\N	t	\N
1139	P230-001139	วัสดุใช้ไป	ข้อต่อตรง ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	35.00	\N	0	0.00	\N	\N	t	\N
1140	P230-001140	วัสดุใช้ไป	ข้องอ ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	45.00	\N	0	0.00	\N	\N	t	\N
1141	P230-001141	วัสดุใช้ไป	เทป สำหรับกั้นเขต ขนาด 70 มม. ยาว 500 เมตร	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ม้วน	299.00	\N	0	0.00	\N	\N	t	\N
1142	P230-001142	วัสดุใช้ไป	กล่องเก็บของ ชนิดพลาสติก แบบ 18 ช่อง ขนาด 12 x 23.5 x 3 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	59.00	\N	0	0.00	\N	\N	t	\N
1143	P230-001143	วัสดุใช้ไป	พัดลมดูดอากาศ ขนาด 12 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	1390.00	\N	0	0.00	\N	\N	t	\N
1144	P230-001144	วัสดุใช้ไป	เชือก ชนิดไนล่อน	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	100.00	\N	0	0.00	\N	\N	t	\N
1145	P230-001145	วัสดุใช้ไป	พุก ชนิดตะกั่ว แบบพร้อมน๊อต	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	15.00	\N	0	0.00	\N	\N	t	\N
1146	P230-001146	วัสดุใช้ไป	กันชน สำหรับประตู	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	44.00	\N	0	0.00	\N	\N	t	\N
1147	P230-001147	วัสดุใช้ไป	ผ้าสำหรับทำความสะอาด ขนาด 30 x 40 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	195.00	\N	0	0.00	\N	\N	t	\N
1148	P230-001148	วัสดุใช้ไป	ไม้ดันฝุ่น แบบผ้าไมโครไฟเบอร์ ขนาดยาว 16 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	429.00	\N	0	0.00	\N	\N	t	\N
1149	P230-001149	วัสดุใช้ไป	ลูกปืนประตู สำหรับบานผลัก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	450.00	\N	0	0.00	\N	\N	t	\N
1150	P230-001150	วัสดุใช้ไป	เทปกาว ชนิดบิวทิว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	769.00	\N	0	0.00	\N	\N	t	\N
1151	P230-001151	วัสดุใช้ไป	ล้อรถเข็น แบบสกรูหมุน ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	190.00	\N	0	0.00	\N	\N	t	\N
1152	P230-001152	วัสดุใช้ไป	ล้อรถเข็น แบบสกรูหมุน มีเบรค ขนาด 3 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	225.00	\N	0	0.00	\N	\N	t	\N
1153	P230-001153	วัสดุใช้ไป	ล้อรถเข็น แบบสกรูหมุน ขนาด 4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	209.00	\N	0	0.00	\N	\N	t	\N
1154	P230-001154	วัสดุใช้ไป	กระบอกเพชร สำหรับเจาะผนัง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	590.00	\N	0	0.00	\N	\N	t	\N
1155	P230-001155	วัสดุใช้ไป	มิเตอร์น้ำ	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	520.00	\N	0	0.00	\N	\N	t	\N
1156	P230-001156	วัสดุใช้ไป	กิ๊บ รัดสายไฟ เบอร์ 4	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แพค	10.00	\N	0	0.00	\N	\N	t	\N
1157	P230-001157	วัสดุใช้ไป	ตะปู ขนาด 3/4 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แพค	10.00	\N	0	0.00	\N	\N	t	\N
1158	P230-001158	วัสดุใช้ไป	มิเตอร์ไฟฟ้า	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	550.00	\N	0	0.00	\N	\N	t	\N
1159	P230-001159	วัสดุใช้ไป	แค้ม แบบคู่	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	30.00	\N	0	0.00	\N	\N	t	\N
1160	P230-001160	วัสดุใช้ไป	แค้ม แบบเดี่ยว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	23.00	\N	0	0.00	\N	\N	t	\N
1161	P230-001161	วัสดุใช้ไป	กล่องอเนกประสงค์ สำหรับเก็บนมผง ขนาด 2300 มล.	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	425.00	\N	0	0.00	\N	\N	t	\N
1162	P230-001162	วัสดุใช้ไป	ตู้อเนกประสงค์ ชนิดพลาสติก แบบมีลิ้นชักและล้อ ขนาด 42.10 x 35.80 x 105.50 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้	899.00	\N	0	0.00	\N	\N	t	\N
1163	P230-001163	วัสดุใช้ไป	เก้าอี้กลม ชนิดพลาสติก	วัสดุสำนักงาน	วัสดุสำนักงาน	ตัว	149.00	\N	0	0.00	\N	\N	t	\N
1164	P230-001164	วัสดุใช้ไป	แผ่นสมาร์ทบอร์ด หนา 6 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	275.00	\N	0	0.00	\N	\N	t	\N
1165	P230-001165	วัสดุใช้ไป	ชุดทรานเฟอร์เบลล์ HP e77830 สำหรับเครื่องถ่ายเอกสาร	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	16000.00	\N	0	0.00	\N	\N	t	\N
1166	P230-001166	วัสดุใช้ไป	สักหลาดหมึก สำหรับเครื่องคิดเลข	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	180.00	\N	0	0.00	\N	\N	t	\N
1167	P230-001167	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ แบบ CR2032 ขนาด 3V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	32.00	\N	0	0.00	\N	\N	t	\N
1168	P230-001168	วัสดุใช้ไป	ฉากกั้นห้อง แบบทึบ ขนาด 240 x 250 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	6300.00	\N	0	0.00	\N	\N	t	\N
1169	P230-001169	วัสดุใช้ไป	ชุดผ้าปูที่นอน พร้อมผ้านวมและปลอกหมอน	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุด	965.00	\N	0	0.00	\N	\N	t	\N
1170	P230-001170	วัสดุใช้ไป	หมอนข้าง	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ใบ	219.00	\N	0	0.00	\N	\N	t	\N
1172	P230-001172	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N
1173	P230-001173	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N
1174	P230-001174	วัสดุใช้ไป	พาน สำหรับจัดดอกไม้	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	420.00	\N	0	0.00	\N	\N	t	\N
1175	P230-001175	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีม่วงเข้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N
1176	P230-001176	วัสดุใช้ไป	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีม่วงอ่อน	วัสดุสำนักงาน	วัสดุสำนักงาน	เมตร	53.00	\N	0	0.00	\N	\N	t	\N
1177	P230-001177	วัสดุใช้ไป	คาบูเรเตอร์ สำหรับเครื่องตัดตัดหญ้า	วัสดุการเกษตร	วัสดุการเกษตร	ชุด	1700.00	\N	0	0.00	\N	\N	t	\N
1178	P230-001178	วัสดุใช้ไป	พัดลมดูดอากาศ ขนาด 8 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	990.00	\N	0	0.00	\N	\N	t	\N
1179	P230-001179	วัสดุใช้ไป	ลูกลอย สำหรับเครื่องปั๊มน้ำไฟฟ้า	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	520.00	\N	0	0.00	\N	\N	t	\N
1180	P230-001180	วัสดุใช้ไป	โคมไฟ แบบปีกอลูมีเนียม ขนาด 1 x 40	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	500.00	\N	0	0.00	\N	\N	t	\N
1181	P230-001181	วัสดุใช้ไป	ลูกลอยไฟฟ้า แบบหัวนก	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	480.00	\N	0	0.00	\N	\N	t	\N
1182	P230-001182	วัสดุใช้ไป	สี สำหรับทาฝ้า สีขาว ขนาด 2.5 Gallon	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แกลลอน	1705.00	\N	0	0.00	\N	\N	t	\N
1183	P230-001183	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	20.00	\N	0	0.00	\N	\N	t	\N
1184	P230-001184	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 1.5 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	25.00	\N	0	0.00	\N	\N	t	\N
1185	P230-001185	วัสดุใช้ไป	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	30.00	\N	0	0.00	\N	\N	t	\N
1186	P230-001186	วัสดุใช้ไป	ท่อหด สำหรับหุ้มสายไฟ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	10.00	\N	0	0.00	\N	\N	t	\N
1187	P230-001187	วัสดุใช้ไป	Color box สำหรับ Printer M282nw no.206a สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	1250.00	\N	0	0.00	\N	\N	t	\N
1188	P230-001188	วัสดุใช้ไป	Color box สำหรับ Printer M282nw no.206a สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	1250.00	\N	0	0.00	\N	\N	t	\N
1189	P230-001189	วัสดุใช้ไป	Color box สำหรับ Printer M282nw no.206a สีแดง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	1250.00	\N	0	0.00	\N	\N	t	\N
1190	P230-001190	วัสดุใช้ไป	Color box สำหรับ Printer M282nw no.206a สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	1250.00	\N	0	0.00	\N	\N	t	\N
1191	P230-001191	วัสดุใช้ไป	ตะขอ แบบเกลียว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	2.50	\N	0	0.00	\N	\N	t	\N
1192	P230-001192	วัสดุใช้ไป	เกลียวเร่ง ชนิดเหล็ก ขนาด 1 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัว	0.50	\N	0	0.00	\N	\N	t	\N
1193	P230-001193	วัสดุใช้ไป	กระเบื้อง ชนิดแผ่นเรียบ หนา 6 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	275.00	\N	0	0.00	\N	\N	t	\N
1194	P230-001194	วัสดุใช้ไป	น้ำยา สำหรับขจัดคราบ (Cement residual parts)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	980.00	\N	0	0.00	\N	\N	t	\N
1195	P230-001195	วัสดุใช้ไป	ยางชะลอความเร็วรถ ขนาด 100 x 10 x 2 ซม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	379.00	\N	0	0.00	\N	\N	t	\N
1196	P230-001196	วัสดุใช้ไป	หลอดไฟ ชนิดนีออน แบบวงกลม สำหรับโคมไฟซาลาเปา ขนาด 48 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ดวง	180.00	\N	0	0.00	\N	\N	t	\N
1197	P230-001197	วัสดุใช้ไป	หลอดไฟ ชนิด LED ขนาด 13 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ดวง	110.00	\N	0	0.00	\N	\N	t	\N
1198	P230-001198	วัสดุใช้ไป	ชุดปะเอนกประสงค์ สำหรับซ่อมโซฟา	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	80.00	\N	0	0.00	\N	\N	t	\N
1199	P230-001199	วัสดุใช้ไป	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 45 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	859.00	\N	0	0.00	\N	\N	t	\N
1200	P230-001200	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 3 ชั้น ขนาด 30*36*50 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	499.00	\N	0	0.00	\N	\N	t	\N
1201	P230-001201	วัสดุใช้ไป	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 3 ชั้น ขนาด 30*36*35 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	425.00	\N	0	0.00	\N	\N	t	\N
1202	P230-001202	วัสดุใช้ไป	Ram BUS 2666 DDR4 ขนาด 4 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	850.00	\N	0	0.00	\N	\N	t	\N
1203	P230-001203	วัสดุใช้ไป	โคมไฟ แบบดาวไลท์ หลอด LED ขนาด 5 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	130.00	\N	0	0.00	\N	\N	t	\N
1204	P230-001204	วัสดุใช้ไป	ขาหนีบกระจก ชนิดสแตนเลส	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	135.00	\N	0	0.00	\N	\N	t	\N
1205	P230-001205	วัสดุใช้ไป	กระจกใส หนา 3 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	480.00	\N	0	0.00	\N	\N	t	\N
1207	P230-001207	วัสดุใช้ไป	สายยาง สำหรับที่นอนลม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	85.00	\N	0	0.00	\N	\N	t	\N
1208	P230-001208	วัสดุใช้ไป	กระดาษโฟโต้ A4 180 แกรม	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	120.00	\N	0	0.00	\N	\N	t	\N
1209	P230-001209	วัสดุใช้ไป	กระดาษการ์ดหอม สีขาว A4 180 แกรม	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	120.00	\N	0	0.00	\N	\N	t	\N
1210	P230-001210	วัสดุใช้ไป	กระดาษการ์ดขาว A4 150 แกรม	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	120.00	\N	0	0.00	\N	\N	t	\N
1211	P230-001211	วัสดุใช้ไป	กระดาษสติ๊กเกอร์ ขาวมัน A4 90 แกรม	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	120.00	\N	0	0.00	\N	\N	t	\N
1212	P230-001212	วัสดุใช้ไป	ถาดอาหารสแตนเลส พร้อมฝาปิด 5 ช่อง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	500.00	\N	0	0.00	\N	\N	t	\N
1213	P230-001213	วัสดุใช้ไป	ถาดเสริฟเหลี่ยม 10 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	250.00	\N	0	0.00	\N	\N	t	\N
1214	P230-001214	วัสดุใช้ไป	ถ้วยสแตนเลสพร้อมฝาปิด ขนาด 16 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถ้วย	300.00	\N	0	0.00	\N	\N	t	\N
1215	P230-001215	วัสดุใช้ไป	กล่องพลาสติกฝาล็อค 60 ลิตร	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบ	500.00	\N	0	0.00	\N	\N	t	\N
1216	P230-001216	วัสดุใช้ไป	ถุงมือยางยาว แบบรัดข้อ เบอร์ S	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	120.00	\N	0	0.00	\N	\N	t	\N
1217	P230-001217	วัสดุใช้ไป	ผ้าขวางเตียง ผ้าฟอกขาว 42"x72" ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	290.00	\N	0	0.00	\N	\N	t	\N
1218	P230-001218	วัสดุใช้ไป	ผ้าถุง ผ้าคอมทวิว สีแดงเลือดนก สรว 88"x40" (LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	350.00	\N	0	0.00	\N	\N	t	\N
1219	P230-001219	วัสดุใช้ไป	ผ้าปูเตียง ปล่อยชาย ผ้าโทเรหนา สีเขียวโศก (แผนไทย) 100"x108'' (แผนไทย)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	650.00	\N	0	0.00	\N	\N	t	\N
1220	P230-001220	วัสดุใช้ไป	ผ้าปูเตียง ปล่อยชาย ผ้าฟอกขาว 58"x108" ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	400.00	\N	0	0.00	\N	\N	t	\N
1221	P230-001221	วัสดุใช้ไป	ผ้าปูรถนอน ปล่อยชาย ผ้าย้อมสีเขียวโศก 42"x108"	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	400.00	\N	0	0.00	\N	\N	t	\N
1222	P230-001222	วัสดุใช้ไป	ผ้าปูรถนอน ปล่อยชาย ผ้าย้อมสีเขียวแก่ 42"x108" (ER)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	400.00	\N	0	0.00	\N	\N	t	\N
1223	P230-001223	วัสดุใช้ไป	ผ้าสี่เหลียม 2 ชั้น เจาะรูกลาง (4"x6") ผ้าย้อมสีเขียวแก่ 58"x100 " (OR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผืน	1200.00	\N	0	0.00	\N	\N	t	\N
1224	P230-001224	วัสดุใช้ไป	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีแดงเลือดนก XXL (LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	350.00	\N	0	0.00	\N	\N	t	\N
1225	P230-001225	วัสดุใช้ไป	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีม่วง XL (แผนไทย)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	280.00	\N	0	0.00	\N	\N	t	\N
1226	P230-001226	วัสดุใช้ไป	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีเขียว XL ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N
1227	P230-001227	วัสดุใช้ไป	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีเขียว XXL ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N
1228	P230-001228	วัสดุใช้ไป	กางเกงผู้ใหญ่ มีเชือกผูก ผ้าคอมทวิว สีเขียว XL ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N
1256	P230-001256	วัสดุใช้ไป	ไฟสนาม แบบสปอตไลท์ ขนาด 70W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	1290.00	\N	0	0.00	\N	\N	t	\N
1229	P230-001229	วัสดุใช้ไป	กางเกงผู้ใหญ่ มีเชือกผูก ผ้าคอมทวิว สีเขียว XXL ( Wช/Wญ/LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N
1230	P230-001230	วัสดุใช้ไป	ผ้าถุง ผ้าคอมทวิว สีแดงเลือดนก สรว 88"x40" (LR)	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ตัว	300.00	\N	0	0.00	\N	\N	t	\N
1231	P230-001231	วัสดุใช้ไป	นาฬิกาจับเวลา	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	900.00	\N	0	0.00	\N	\N	t	\N
1232	P230-001232	วัสดุใช้ไป	เสื้อกาวน์ยาว	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	ตัว	550.00	\N	0	0.00	\N	\N	t	\N
1233	P230-001233	วัสดุใช้ไป	ตะกร้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	อัน	30.00	\N	0	0.00	\N	\N	t	\N
1234	P230-001234	วัสดุใช้ไป	กระติ๊กน้ำแข็ง 5 ลิตร ใส่วัคซีนและยาเย็น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	อัน	175.00	\N	0	0.00	\N	\N	t	\N
1235	P230-001235	วัสดุใช้ไป	ชุดถ้วยกาแฟ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ชุด	139.00	\N	0	0.00	\N	\N	t	\N
1236	P230-001236	วัสดุใช้ไป	กล่องเก็บของ	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	419.00	\N	0	0.00	\N	\N	t	\N
1237	P230-001237	วัสดุใช้ไป	ตระกร้าผ้าเหลี่ยมมีฝาหูหิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	329.00	\N	0	0.00	\N	\N	t	\N
1238	P230-001238	วัสดุใช้ไป	USB MP3 รวมเพลงฮิต	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่-งบหน่วยงาน	อัน	299.00	\N	0	0.00	\N	\N	t	\N
1239	P230-001239	วัสดุใช้ไป	กระดิ่งไร้สายแบบเสียบปลั๊ก	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	890.00	\N	0	0.00	\N	\N	t	\N
1240	P230-001240	วัสดุใช้ไป	กล่องเครื่องมือ 30ช่อง	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	อัน	750.00	\N	0	0.00	\N	\N	t	\N
1241	P230-001241	วัสดุใช้ไป	ฟิล์มสูญกาศพิมพ์ลาย	วัสดุอื่นๆ	วัสดุอื่นๆ-งบหน่วยงาน	ชุด	500.00	\N	0	0.00	\N	\N	t	\N
1242	P230-001242	วัสดุใช้ไป	หมอนหนุนศรีษะสำหรับผู้ป่วย	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	อัน	400.00	\N	0	0.00	\N	\N	t	\N
1243	P230-001243	วัสดุใช้ไป	สายรัด NST	วัสดุอื่นๆ	วัสดุอื่นๆ-งบหน่วยงาน	อัน	1380.00	\N	0	0.00	\N	\N	t	\N
1244	P230-001244	วัสดุใช้ไป	หมอนให้นมบุตร	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	อัน	300.00	\N	0	0.00	\N	\N	t	\N
1245	P230-001245	วัสดุใช้ไป	ป้ายชื่อ สำหรับพวงกุญแจ	วัสดุสำนักงาน	วัสดุสำนักงาน	pack	95.00	\N	0	0.00	\N	\N	t	\N
1246	P230-001246	วัสดุใช้ไป	หลอดไฟ ชนิดนีออน ขนาด 8 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	100.00	\N	0	0.00	\N	\N	t	\N
1247	P230-001247	วัสดุใช้ไป	หลอดไฟ ชนิดนีออน ขนาด 22 W	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอด	120.00	\N	0	0.00	\N	\N	t	\N
1248	P230-001248	วัสดุใช้ไป	อะไหล่เครื่องฉีดน้ำไฟฟ้า	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	100.00	\N	0	0.00	\N	\N	t	\N
1249	P230-001249	วัสดุใช้ไป	ตัวล๊อคบานเลื่อนกระจก	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	160.00	\N	0	0.00	\N	\N	t	\N
1250	P230-001250	วัสดุใช้ไป	กระจกบานเกล็ด ขนาด 4*36 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่น	65.00	\N	0	0.00	\N	\N	t	\N
1251	P230-001251	วัสดุใช้ไป	รีเวท ขนาด 1/8*5/16	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	pack	25.00	\N	0	0.00	\N	\N	t	\N
1252	P230-001252	วัสดุใช้ไป	รีเวท ขนาด 1/8*3/8	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	pack	25.00	\N	0	0.00	\N	\N	t	\N
1253	P230-001253	วัสดุใช้ไป	กุญแจประตูบานเลื่อนสวิง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	650.00	\N	0	0.00	\N	\N	t	\N
1254	P230-001254	วัสดุใช้ไป	ชุดฝักบัว แบบ Rain shower	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	3590.00	\N	0	0.00	\N	\N	t	\N
1255	P230-001255	วัสดุใช้ไป	กะละมังซักผ้า ชนิดพลาสติก ขนาด 40 ซม.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	80.00	\N	0	0.00	\N	\N	t	\N
1258	P230-001258	วัสดุใช้ไป	ผงยิบซัม	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิโลกรัม	33.00	\N	0	0.00	\N	\N	t	\N
1259	P230-001259	วัสดุใช้ไป	ตะปูคอนกรีต	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่อง	18.00	\N	0	0.00	\N	\N	t	\N
1260	P230-001260	วัสดุใช้ไป	ใบตัด ชนิดไฟเบอร์ ขนาด 14 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	110.00	\N	0	0.00	\N	\N	t	\N
1261	P230-001261	วัสดุใช้ไป	กาวตะปู	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หลอด	132.00	\N	0	0.00	\N	\N	t	\N
1262	P230-001262	วัสดุใช้ไป	ลูกบล๊อค เบอร์ 8	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	55.00	\N	0	0.00	\N	\N	t	\N
1263	P230-001263	วัสดุใช้ไป	เหล็กเส้น ขนาด 6 มม.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เส้น	132.00	\N	0	0.00	\N	\N	t	\N
1264	P230-001264	วัสดุใช้ไป	ราวแขวน ขนาด 75 ซม. (งบหน่วยงาน ward หญิง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	560.50	\N	0	0.00	\N	\N	t	\N
1265	P230-001265	วัสดุใช้ไป	ถังขยะพลาสติก แบบฝาเหยียบ ขนาด 50 ลิตร (งบหน่วยงาน ward หญิง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	499.00	\N	0	0.00	\N	\N	t	\N
1266	P230-001266	วัสดุใช้ไป	ถังขยะพลาสติก แบบฝาเหยียบ ขนาด 80 ลิตร (งบหน่วยงาน ward หญิง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	699.00	\N	0	0.00	\N	\N	t	\N
1267	P230-001267	วัสดุใช้ไป	ถังขยะสแตนเลส แบบฝาเหยียบ ขนาด 30 ลิตร (งบหน่วยงาน ward หญิง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1590.00	\N	0	0.00	\N	\N	t	\N
1268	P230-001268	วัสดุใช้ไป	ถังขยะสแตนเลส แบบฝาเหยียบ ขนาด 30 ลิตร (งบหน่วยงานห้องคลอด)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	2590.00	\N	0	0.00	\N	\N	t	\N
1269	P230-001269	วัสดุใช้ไป	บล๊อค ชนิด PVC ขนาด 4*4	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ชุด	225.00	\N	0	0.00	\N	\N	t	\N
1270	P230-001270	วัสดุใช้ไป	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 4 นิ้ว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถุง	30.00	\N	0	0.00	\N	\N	t	\N
1271	P230-001271	วัสดุใช้ไป	สาย THW ขนาด 1*2.5	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เส้น	1090.00	\N	0	0.00	\N	\N	t	\N
1272	P230-001272	วัสดุใช้ไป	ประตูน้ำ ขนาด 3 x 5.5 นิ้ว สำหรับบ่อสูบตะกอน	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	8900.00	\N	0	0.00	\N	\N	t	\N
1273	P230-001273	วัสดุใช้ไป	ชั้นวางของเอนกประสงค์ 3 ชั้น แบบมีล้อ (งานทันตกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	1290.00	\N	0	0.00	\N	\N	t	\N
1274	P230-001274	วัสดุใช้ไป	แผงกั้นจราจร ขนาด 1.5 เมตร แบบไม่มีล้อ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	1550.00	\N	0	0.00	\N	\N	t	\N
1275	P230-001275	วัสดุใช้ไป	กรวยจราจร  ชนิดพลาสติก ขนาด 70 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	299.00	\N	0	0.00	\N	\N	t	\N
1276	P230-001276	วัสดุใช้ไป	ตะแกรงใสของอเนกประสงค์ ขนาด 21.3*29.3*9 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	39.00	\N	0	0.00	\N	\N	t	\N
1277	P230-001277	วัสดุใช้ไป	ตะแกรงใสของอเนกประสงค์ ขนาด 24*33.5*9 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	49.00	\N	0	0.00	\N	\N	t	\N
1278	P230-001278	วัสดุใช้ไป	ตะแกรงใสของอเนกประสงค์ ขนาด 25.5*37.5*14.5 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	59.00	\N	0	0.00	\N	\N	t	\N
1279	P230-001279	วัสดุใช้ไป	ตู้ลิ้นชักพลาสติก แบบ 4 ชั้น ขนาด 40*50*104 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	170.00	\N	0	0.00	\N	\N	t	\N
1280	P230-001280	วัสดุใช้ไป	ตู้ลิ้นชักพลาสติก แบบ 3 ชั้น ขนาด 15.5*20*23 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	990.00	\N	0	0.00	\N	\N	t	\N
1281	P230-001281	วัสดุใช้ไป	ตู้ลิ้นชักพลาสติก แบบ 4 ชั้น ขนาด 18*27*27 ซม. (งานเภสัชกรรม)	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุด	97.00	\N	0	0.00	\N	\N	t	\N
1282	P230-001282	วัสดุใช้ไป	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 5 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	365.00	\N	0	0.00	\N	\N	t	\N
1283	P230-001283	วัสดุใช้ไป	สามทาง ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อัน	58.00	\N	0	0.00	\N	\N	t	\N
1284	P230-001284	วัสดุใช้ไป	กระจกส่องตัว (งานเทคนิคการแพทย์)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1735.00	\N	0	0.00	\N	\N	t	\N
1285	P230-001285	วัสดุใช้ไป	กล่องบรรจุตัวอย่าง (งานเทคนิคการแพทย์)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	253.00	\N	0	0.00	\N	\N	t	\N
1286	P230-001286	วัสดุใช้ไป	ชั้นวางรองเท้า (งานเทคนิคการแพทย์)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	599.00	\N	0	0.00	\N	\N	t	\N
1287	P230-001287	วัสดุใช้ไป	ชั้นวางของแบบมีล้อเลื่อน (งานเทคนิคการแพทย์)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	695.00	\N	0	0.00	\N	\N	t	\N
1288	P230-001288	วัสดุใช้ไป	ขาวางลำโพง	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด	420.00	\N	0	0.00	\N	\N	t	\N
1289	P230-001289	วัสดุใช้ไป	ฟิล์มยืด (งานแพทย์แผนไทย)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	25.00	\N	0	0.00	\N	\N	t	\N
1290	P230-001290	วัสดุใช้ไป	ชุดกรวยอิมฮอฟฟ์/กรวยตกตะกอน (Imhoff cone) ขนาด 1000 ml พร้อมขาตั้ง (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	ชุุด	8185.50	\N	0	0.00	\N	\N	t	\N
1291	P230-001291	วัสดุใช้ไป	ชุดทดสอบโคลิฟอร์มแบคทีเรีย (SI-2) (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	กล่อง	1000.00	\N	0	0.00	\N	\N	t	\N
1292	P230-001292	วัสดุใช้ไป	น้ำยาตรวจเชื้อโคลิฟอร์มแบคทีเรียขั้นต้นในน้ำและน้ำแข็ง (อ11) (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	กล่อง	1000.00	\N	0	0.00	\N	\N	t	\N
1293	P230-001293	วัสดุใช้ไป	คลอรีนน้ำ ขนาด 20 กิโลกรัม (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	ถัง	760.00	\N	0	0.00	\N	\N	t	\N
1294	P230-001294	วัสดุใช้ไป	คลอรีนผง 65% ขนาด 50 กิโลกรัม (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	วัสดุอื่นๆ	วัสดุอื่นๆ	ถัง	4200.00	\N	0	0.00	\N	\N	t	\N
1295	P230-001295	วัสดุใช้ไป	USB RJ45 extension	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ชุด	290.00	\N	0	0.00	\N	\N	t	\N
1296	P230-001296	วัสดุใช้ไป	ผ้าใบ สำหรับคลุมเต้นท์จั่ว ขนาด 5x12 เมตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	21892.20	\N	0	0.00	\N	\N	t	\N
1297	P230-001297	วัสดุใช้ไป	ท่อเป่าปอดแกนกระดาษสำหรับเครื่องเป่าปอด	วัสดุอื่นๆ	วัสดุอื่นๆ	ชิ้น	6.50	\N	0	0.00	\N	\N	t	\N
1298	P230-001298	วัสดุใช้ไป	ป้ายบอกตำแหน่งถังดับเพลิง ขนาด 15 x 15 x 30 ซม. แบบพับ มองเห็นได้ทั้ง 2 ด้าน	วัสดุอื่นๆ	วัสดุอื่นๆ	ชิ้น	485.00	\N	0	0.00	\N	\N	t	\N
1299	P230-001299	วัสดุใช้ไป	ถังดับเพลิง ชนิดเหลวระเหย BF2000 ขนาด 15 lbs	วัสดุอื่นๆ	วัสดุอื่นๆ	ชิ้น	4495.00	\N	0	0.00	\N	\N	t	\N
1300	P230-001300	วัสดุใช้ไป	ป้ายวิธีการใช้ถังดับเพลิง แบบอลูมิเนียม ขนาด 30 x 45 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	ชิ้น	785.00	\N	0	0.00	\N	\N	t	\N
1301	P230-001301	วัสดุใช้ไป	น้ำยาล้างห้องน้ำ ขนาด 3.5 ลิตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	180.00	\N	0	0.00	\N	\N	t	\N
1302	P230-001302	วัสดุใช้ไป	น้ำยาล้างห้องน้ำ ขนาด 900 ซีซี	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวด	55.00	\N	0	0.00	\N	\N	t	\N
1303	P230-001303	วัสดุใช้ไป	สาย THW ขนาด 1*2.5 สีแดง	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	15.00	\N	0	0.00	\N	\N	t	\N
1304	P230-001304	วัสดุใช้ไป	สาย THW ขนาด 1*2.5 สีดำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	13.00	\N	0	0.00	\N	\N	t	\N
1305	P230-001305	วัสดุใช้ไป	สาย THW ขนาด 1*2.5 สีเขียว	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เมตร	15.00	\N	0	0.00	\N	\N	t	\N
1306	P230-001306	วัสดุใช้ไป	หัวแจ๊คตัวผู้ ขนาด 3.5 มม/4 pole	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	20.00	\N	0	0.00	\N	\N	t	\N
1307	P230-001307	วัสดุใช้ไป	สวิทช์ควบคุมการไหลของปั๊มน้ำ	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตัว	1050.00	\N	0	0.00	\N	\N	t	\N
1308	P230-001308	วัสดุใช้ไป	ยางมะตอย แบบสำเร็จรูป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	89.00	\N	0	0.00	\N	\N	t	\N
1309	P230-001309	วัสดุใช้ไป	ผงย่อยจุลินทรีย์ สำหรับสุขภัณฑ์	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุง	189.00	\N	0	0.00	\N	\N	t	\N
1310	P230-001310	วัสดุใช้ไป	ซิลิโคน แบบมีกรด ขนาด 300 มล.	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หลอด	199.00	\N	0	0.00	\N	\N	t	\N
1311	P230-001311	วัสดุใช้ไป	ป้ายบอกทางหนีไฟ ขนาด 20 x 30 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้าย	300.00	\N	0	0.00	\N	\N	t	\N
1312	P230-001312	วัสดุใช้ไป	ป้ายจุดรวมพล ขนาด 80 x 100 ซม.	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้าย	6900.00	\N	0	0.00	\N	\N	t	\N
1313	P230-001313	วัสดุใช้ไป	สาย VGA to VGA ยาว 5 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	250.00	\N	0	0.00	\N	\N	t	\N
1314	P230-001314	วัสดุใช้ไป	ตะกร้าล้อลาก สำหรับใส่ผ้า ขนาด 51*39*63.5  cm	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	350.00	\N	0	0.00	\N	\N	t	\N
1315	P230-001315	วัสดุใช้ไป	ไส้กรองน้ำเรซิน (งานจ่ายกลาง)	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	1200.00	\N	0	0.00	\N	\N	t	\N
1316	P230-001316	วัสดุใช้ไป	ไส้กรองน้ำคาร์บอน (งานจ่ายกลาง)	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	1200.00	\N	0	0.00	\N	\N	t	\N
1317	P230-001317	วัสดุใช้ไป	ไส้กรอง PP20 (งานจ่ายกลาง)	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	1200.00	\N	0	0.00	\N	\N	t	\N
1318	P230-001318	วัสดุใช้ไป	ฟิวเตอร์งเมมเบรนกรองน้ำ RO (งานจ่ายกลาง)	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	1200.00	\N	0	0.00	\N	\N	t	\N
1319	P230-001319	วัสดุใช้ไป	ที่วัดลมยาง	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	600.00	\N	0	0.00	\N	\N	t	\N
1320	P230-001320	วัสดุใช้ไป	น้ำยาเคลือบเงารถ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	300.00	\N	0	0.00	\N	\N	t	\N
1321	P230-001321	วัสดุใช้ไป	น้ำยาเช็ดรถ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	300.00	\N	0	0.00	\N	\N	t	\N
1322	P230-001322	วัสดุใช้ไป	ผ้าเช็ดรถ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	120.00	\N	0	0.00	\N	\N	t	\N
1323	P230-001323	วัสดุใช้ไป	ฟองน้ำล้างรถ	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	120.00	\N	0	0.00	\N	\N	t	\N
1324	P230-001324	วัสดุใช้ไป	ที่รีดกระจกสำหรับรถยนต์	วัสดุอื่นๆ	วัสดุอื่นๆ	อัน	120.00	\N	0	0.00	\N	\N	t	\N
1325	P230-001325	วัสดุใช้ไป	เสียม ชนิดเหล็ก แบบด้ามไม้ ขนาด 2 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	อัน	350.00	\N	0	0.00	\N	\N	t	\N
1326	P230-001326	วัสดุใช้ไป	ตะไบสามเหลี่ยม	วัสดุการเกษตร	วัสดุการเกษตร	อัน	350.00	\N	0	0.00	\N	\N	t	\N
1327	P230-001327	วัสดุใช้ไป	บาร์เลท่อย ขนาด 11.5 นิ้ว	วัสดุการเกษตร	วัสดุการเกษตร	อัน	350.00	\N	0	0.00	\N	\N	t	\N
1328	P230-001328	วัสดุใช้ไป	แผ่นโฟมจิ๊กซอว์ แบบ ABC ขนาด 29*29 ซม. (PCU วังทอง)	วัสดุอื่นๆ	วัสดุอื่นๆ	ชุด	310.00	\N	0	0.00	\N	\N	t	\N
1329	P230-001329	วัสดุใช้ไป	แผ่นโฟมจิ๊กซอว์ แบบ ก-ฮ ขนาด 29*29 ซม. (PCU วังทอง)	วัสดุอื่นๆ	วัสดุอื่นๆ	ชุด	390.00	\N	0	0.00	\N	\N	t	\N
24	P230-000024	วัสดุใช้ไป	แผ่น CD-R (50 ซอง/แพค)	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หลอด	280.00	\N	0	0.00	\N	\N	t	\N
27	P230-000027	วัสดุใช้ไป	หมึก Printer Ink jet GT53 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	0.00	\N	0	0.00	\N	\N	t	\N
28	P230-000028	วัสดุใช้ไป	หมึก Printer Ink jet GT52 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	390.00	\N	0	0.00	\N	\N	t	\N
29	P230-000029	วัสดุใช้ไป	หมึก Printer Ink jet GT52 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	390.00	\N	0	0.00	\N	\N	t	\N
30	P230-000030	วัสดุใช้ไป	หมึก Printer Ink jet GT52 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	390.00	\N	0	0.00	\N	\N	t	\N
31	P230-000031	วัสดุใช้ไป	หมึก Printer Ink jet L5190 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N
32	P230-000032	วัสดุใช้ไป	หมึก Printer Ink jet L5190 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N
33	P230-000033	วัสดุใช้ไป	หมึก Printer Ink jet L5190 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N
34	P230-000034	วัสดุใช้ไป	หมึก Printer Ink jet L5190 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N
35	P230-000035	วัสดุใช้ไป	หมึก Printer Ink jet T6641 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N
36	P230-000036	วัสดุใช้ไป	หมึก Printer Ink jet T6641 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N
37	P230-000037	วัสดุใช้ไป	หมึก Printer Ink jet T6641 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N
38	P230-000038	วัสดุใช้ไป	หมึก Printer Ink jet T6641 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N
42	P230-000042	วัสดุใช้ไป	หมึก Printer Laser 30A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	890.00	\N	0	0.00	\N	\N	t	\N
44	P230-000044	วัสดุใช้ไป	หมึก Printer Laser 472	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	980.00	\N	0	0.00	\N	\N	t	\N
47	P230-000047	วัสดุใช้ไป	หมึก Printer Laser 83A	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	390.00	\N	0	0.00	\N	\N	t	\N
49	P230-000049	วัสดุใช้ไป	หมึก Printer Laser Fuji m285Z P235	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	980.00	\N	0	0.00	\N	\N	t	\N
57	P230-000057	วัสดุใช้ไป	หมึก Printer Ink jet Epson 003 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N
59	P230-000059	วัสดุใช้ไป	หมึก Printer Ink jet Epson 003 สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N
60	P230-000060	วัสดุใช้ไป	หมึก Printer Ink jet Epson 003 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ขวด	290.00	\N	0	0.00	\N	\N	t	\N
62	P230-000062	วัสดุใช้ไป	กระดาษชำระ ขนาดเล็ก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	6.00	\N	0	0.00	\N	\N	t	\N
63	P230-000063	วัสดุใช้ไป	กระดาษชำระ ชนิดม้วน แบบ 2 ชั้น ขนาดยาว 300 เมตร	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	65.00	\N	0	0.00	\N	\N	t	\N
69	P230-000069	วัสดุใช้ไป	ก้อนดับกลิ่น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	35.00	\N	0	0.00	\N	\N	t	\N
71	P230-000071	วัสดุใช้ไป	แก้วน้ำ แบบทรงสูง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	15.00	\N	0	0.00	\N	\N	t	\N
73	P230-000073	วัสดุใช้ไป	แก้วน้ำ ชนิดพลาสติก ขนาด 6 ออนซ์	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	1.00	\N	0	0.00	\N	\N	t	\N
74	P230-000074	วัสดุใช้ไป	แก้วน้ำ ชนิดอลูมิเนียม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	30.00	\N	0	0.00	\N	\N	t	\N
76	P230-000076	วัสดุใช้ไป	ขันน้ำ ชนิดพลาสติก แบบมีด้าม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	25.00	\N	0	0.00	\N	\N	t	\N
79	P230-000079	วัสดุใช้ไป	ช้อน ชนิดสแตนเลส แบบสั้น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	โหล	35.00	\N	0	0.00	\N	\N	t	\N
80	P230-000080	วัสดุใช้ไป	เชือก ชนิดปอแก้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ม้วน	50.00	\N	0	0.00	\N	\N	t	\N
82	P230-000082	วัสดุใช้ไป	ด้ามมีดโกน ชนิดพลาสติก แบบใช้แล้วทิ้ง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	35.00	\N	0	0.00	\N	\N	t	\N
87	P230-000087	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเขียว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	65.00	\N	0	0.00	\N	\N	t	\N
88	P230-000088	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเขียว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	65.00	\N	0	0.00	\N	\N	t	\N
89	P230-000089	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	50.00	\N	0	0.00	\N	\N	t	\N
90	P230-000090	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	50.00	\N	0	0.00	\N	\N	t	\N
92	P230-000092	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	70.00	\N	0	0.00	\N	\N	t	\N
93	P230-000093	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีแดง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	70.00	\N	0	0.00	\N	\N	t	\N
94	P230-000094	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเหลือง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	70.00	\N	0	0.00	\N	\N	t	\N
95	P230-000095	วัสดุใช้ไป	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเหลือง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กิโลกรัม	60.00	\N	0	0.00	\N	\N	t	\N
98	P230-000098	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 16*26 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N
99	P230-000099	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 4.5*7 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N
100	P230-000100	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 6*9 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N
101	P230-000101	วัสดุใช้ไป	ถุง ชนิดพลาสติก ขนาด 8*12 นิ้ว สีใส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N
103	P230-000103	วัสดุใช้ไป	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	120.00	\N	0	0.00	\N	\N	t	\N
106	P230-000106	วัสดุใช้ไป	ถุงมือ ชนิดยาง เบอร์ L สีส้ม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N
107	P230-000107	วัสดุใช้ไป	ถุงมือ ชนิดยาง เบอร์ M สีส้ม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N
111	P230-000111	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*24 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N
112	P230-000112	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 15*30 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N
113	P230-000113	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 8*16 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N
114	P230-000114	วัสดุใช้ไป	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*26 นิ้ว สีขาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แพค	45.00	\N	0	0.00	\N	\N	t	\N
115	P230-000115	วัสดุใช้ไป	ที่ตักขยะ ชนิดพลาสติก แบบมีด้ามจับ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	65.00	\N	0	0.00	\N	\N	t	\N
116	P230-000116	วัสดุใช้ไป	ที่ตักขยะสังกะสี ชนิดสังกะสี แบบมีด้ามจับ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	95.00	\N	0	0.00	\N	\N	t	\N
119	P230-000119	วัสดุใช้ไป	น้ำยา สำหรับเช็ดกระจก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	130.00	\N	0	0.00	\N	\N	t	\N
121	P230-000121	วัสดุใช้ไป	น้ำยา ชนิดสูตรน้ำ สำหรับดันฝุ่น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	370.00	\N	0	0.00	\N	\N	t	\N
122	P230-000122	วัสดุใช้ไป	น้ำยา ชนิดสูตรน้ำมันใส สำหรับดันฝุ่น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	430.00	\N	0	0.00	\N	\N	t	\N
123	P230-000123	วัสดุใช้ไป	น้ำยา สำหรับทำความสะอาดพื้น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	200.00	\N	0	0.00	\N	\N	t	\N
124	P230-000124	วัสดุใช้ไป	น้ำยา สำหรับล้างจาน	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	120.00	\N	0	0.00	\N	\N	t	\N
125	P230-000125	วัสดุใช้ไป	น้ำยา สำหรับล้างมือ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แกลลอน	180.00	\N	0	0.00	\N	\N	t	\N
127	P230-000127	วัสดุใช้ไป	ใบมีดโกน แบบ 2 คม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่อง	35.00	\N	0	0.00	\N	\N	t	\N
128	P230-000128	วัสดุใช้ไป	ปืนยิงแก๊ส	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	25.00	\N	0	0.00	\N	\N	t	\N
129	P230-000129	วัสดุใช้ไป	แป้งฝุ่น สำหรับเด็ก ขนาด 180 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	35.00	\N	0	0.00	\N	\N	t	\N
130	P230-000130	วัสดุใช้ไป	แปรง ชนิดทองเหลือง สำหรับขัดพื้น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	120.00	\N	0	0.00	\N	\N	t	\N
131	P230-000131	วัสดุใช้ไป	แปรง ชนิดพลาสติก สำหรับขัดพื้นแบบมีด้ามยาว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	70.00	\N	0	0.00	\N	\N	t	\N
132	P230-000132	วัสดุใช้ไป	แปรง ชนิดพลาสติก สำหรับขัดห้องน้ำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	30.00	\N	0	0.00	\N	\N	t	\N
171	P230-000171	วัสดุใช้ไป	ลังถึง เบอร์ 36	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชุด	800.00	\N	0	0.00	\N	\N	t	\N
133	P230-000133	วัสดุใช้ไป	แปรง ชนิดขนอ่อน สำหรับซักผ้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	25.00	\N	0	0.00	\N	\N	t	\N
135	P230-000135	วัสดุใช้ไป	ผงซักฟอก ขนาด 800 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง	70.00	\N	0	0.00	\N	\N	t	\N
138	P230-000138	วัสดุใช้ไป	ผ้าม็อบ สำหรับถูพื้น แบบเปียก ขนาด 12 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	80.00	\N	0	0.00	\N	\N	t	\N
139	P230-000139	วัสดุใช้ไป	ผ้าห่ม สำหรับถูพื้น	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผืน	160.00	\N	0	0.00	\N	\N	t	\N
141	P230-000141	วัสดุใช้ไป	ฝอย ชนิดแสตนเลส ขนาด 14 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	15.00	\N	0	0.00	\N	\N	t	\N
148	P230-000148	วัสดุใช้ไป	ไม้กวาด ชนิดดอกหญ้า	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	50.00	\N	0	0.00	\N	\N	t	\N
149	P230-000149	วัสดุใช้ไป	ไม้กวาด ชนิดทางมะพร้าว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	60.00	\N	0	0.00	\N	\N	t	\N
150	P230-000150	วัสดุใช้ไป	ไม้กวาด ชนิดทางมะพร้าว สำหรับกวาดหยากไย่	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	45.00	\N	0	0.00	\N	\N	t	\N
151	P230-000151	วัสดุใช้ไป	ไม้กวาด ชนิดพลาสติก สำหรับกวาดหยากไย่ แบบปรับระดับได้	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	290.00	\N	0	0.00	\N	\N	t	\N
152	P230-000152	วัสดุใช้ไป	ไม้ดันฝุ่น แบบด้ามไม้ พร้อมผ้าดันฝุ่น ขนาดยาว 24 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	450.00	\N	0	0.00	\N	\N	t	\N
153	P230-000153	วัสดุใช้ไป	ไม้ดันฝุ่น แบบด้ามอลูมิเนียม ขนาดยาว 24 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	300.00	\N	0	0.00	\N	\N	t	\N
154	P230-000154	วัสดุใช้ไป	ไม้ถูพื้น ขนาด 10 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	130.00	\N	0	0.00	\N	\N	t	\N
155	P230-000155	วัสดุใช้ไป	ไม้ปัดขนไก่ แบบด้ามพลาสติก	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	160.00	\N	0	0.00	\N	\N	t	\N
156	P230-000156	วัสดุใช้ไป	ไม้ยางรีดน้ำ ขนาด 18 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	อัน	295.00	\N	0	0.00	\N	\N	t	\N
157	P230-000157	วัสดุใช้ไป	ยางวง แบบเส้นเล็ก ขนาด 500 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N
158	P230-000158	วัสดุใช้ไป	ยางวง แบบเส้นใหญ่ ขนาด 500 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N
159	P230-000159	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 10 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
161	P230-000161	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 11 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
162	P230-000162	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 11.5 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
163	P230-000163	วัสดุใช้ไป	รองเท้า แบบบู๊ท เบอร์ 12 สีดำ	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	145.00	\N	0	0.00	\N	\N	t	\N
164	P230-000164	วัสดุใช้ไป	รองเท้า ชนิดฟองน้ำ เบอร์ 10	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N
165	P230-000165	วัสดุใช้ไป	รองเท้า ชนิดฟองน้ำ เบอร์ 11	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	45.00	\N	0	0.00	\N	\N	t	\N
167	P230-000167	วัสดุใช้ไป	รองเท้า ชนิดยางพารา เบอร์ L	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	95.00	\N	0	0.00	\N	\N	t	\N
168	P230-000168	วัสดุใช้ไป	รองเท้า ชนิดยางพารา เบอร์ LL	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	95.00	\N	0	0.00	\N	\N	t	\N
169	P230-000169	วัสดุใช้ไป	รองเท้า ชนิดยางพารา เบอร์ M	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	95.00	\N	0	0.00	\N	\N	t	\N
170	P230-000170	วัสดุใช้ไป	รองเท้า ชนิดยางพารา เบอร์ XL	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	คู่	95.00	\N	0	0.00	\N	\N	t	\N
172	P230-000172	วัสดุใช้ไป	สก็อตไบร์ท แบบแผ่นเล็ก ขนาด 4.5*6 นิ้ว	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แผ่น	30.00	\N	0	0.00	\N	\N	t	\N
174	P230-000174	วัสดุใช้ไป	สบู่ แบบก้อนเล็ก ขนาด 10 กรัม	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	2.00	\N	0	0.00	\N	\N	t	\N
175	P230-000175	วัสดุใช้ไป	สบู่ แบบก้อนใหญ่	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อน	15.00	\N	0	0.00	\N	\N	t	\N
177	P230-000177	วัสดุใช้ไป	สเปรย์ ชนิดสูตรน้ำ สำหรับฉีดมด ยุง ขนาด 600 มล.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	130.00	\N	0	0.00	\N	\N	t	\N
178	P230-000178	วัสดุใช้ไป	สเปรย์ สำหรับปรับอากาศ ขนาด 300 มล.	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋อง	58.00	\N	0	0.00	\N	\N	t	\N
183	P230-000183	วัสดุใช้ไป	เหยือกน้ำ ชนิดพลาสติก ขนาด 1,000 ซีซี	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบ	100.00	\N	0	0.00	\N	\N	t	\N
184	P230-000184	วัสดุใช้ไป	เอี๊ยม ชนิดพลาสติก แบบใช้แล้วทิ้ง ขนาดบรรจุ 100 ชิ้น/ถุง	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง	350.00	\N	0	0.00	\N	\N	t	\N
343	P230-000343	วัสดุใช้ไป	น้ำหวาน สำหรับผู้ป่วยเบาหวาน สีแดง	วัสดุบริโภค	วัสดุบริโภค	ขวด	65.00	\N	0	0.00	\N	\N	t	\N
344	P230-000344	วัสดุใช้ไป	ไฟฉาย แบบหลอด LED	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กระบอก	160.00	\N	0	0.00	\N	\N	t	\N
347	P230-000347	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ ขนาด 9V	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	130.00	\N	0	0.00	\N	\N	t	\N
348	P230-000348	วัสดุใช้ไป	ถ่าน ชนิดธรรมดา ขนาด AA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	10.00	\N	0	0.00	\N	\N	t	\N
349	P230-000349	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ ขนาด AA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	20.00	\N	0	0.00	\N	\N	t	\N
350	P230-000350	วัสดุใช้ไป	ถ่าน ชนิดธรรมดา ขนาด AAA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	10.00	\N	0	0.00	\N	\N	t	\N
351	P230-000351	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ ขนาด AAA	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	20.00	\N	0	0.00	\N	\N	t	\N
352	P230-000352	วัสดุใช้ไป	ถ่าน ชนิดอัลคาไลน์ ขนาดกลาง C	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	50.00	\N	0	0.00	\N	\N	t	\N
353	P230-000353	วัสดุใช้ไป	ถ่าน ชนิดธรรมดา ขนาดใหญ่ D	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้อน	16.00	\N	0	0.00	\N	\N	t	\N
355	P230-000355	วัสดุใช้ไป	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 3 เมตร	วัสดุไฟฟ้า	วัสดุไฟฟ้า	อัน	410.00	\N	0	0.00	\N	\N	t	\N
421	P230-000421	วัสดุใช้ไป	กบเหลาดินสอ แบบหมุน	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	265.00	\N	0	0.00	\N	\N	t	\N
422	P230-000422	วัสดุใช้ไป	กรรไกร ขนาด 8 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	85.00	\N	0	0.00	\N	\N	t	\N
424	P230-000424	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N
425	P230-000425	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N
426	P230-000426	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N
428	P230-000428	วัสดุใช้ไป	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	110.00	\N	0	0.00	\N	\N	t	\N
429	P230-000429	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	35.00	\N	0	0.00	\N	\N	t	\N
430	P230-000430	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว 24x25 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	45.00	\N	0	0.00	\N	\N	t	\N
431	P230-000431	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1.5 นิ้ว 36x20 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	25.00	\N	0	0.00	\N	\N	t	\N
433	P230-000433	วัสดุใช้ไป	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 2 นิ้ว 20 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N
435	P230-000435	วัสดุใช้ไป	กระดาษคาร์บอน สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	150.00	\N	0	0.00	\N	\N	t	\N
470	P230-000470	วัสดุใช้ไป	ตรายาง สำหรั้บปั๊มวันที่ภาษาไทย	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	60.00	\N	0	0.00	\N	\N	t	\N
436	P230-000436	วัสดุใช้ไป	กระดาษต่อเนื่อง แบบ 1 ชั้น ขนาด 15x11 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	2000.00	\N	0	0.00	\N	\N	t	\N
437	P230-000437	วัสดุใช้ไป	กระดาษถ่ายเอกสาร ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	120.00	\N	0	0.00	\N	\N	t	\N
438	P230-000438	วัสดุใช้ไป	กระดาษเทอร์มอล สำหรับเครื่อง EDC ขนาด 57*40 มม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	90.00	\N	0	0.00	\N	\N	t	\N
439	P230-000439	วัสดุใช้ไป	กระดาษเทอร์มอล สำหรับเครื่องวัดความดัน ขนาด 57*55 มม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	50.00	\N	0	0.00	\N	\N	t	\N
440	P230-000440	วัสดุใช้ไป	กระดาษเทอร์มอล ขนาด 80*80 มม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	60.00	\N	0	0.00	\N	\N	t	\N
442	P230-000442	วัสดุใช้ไป	กระดาษบวกเลข สำหรับเครื่องคิดเลข ขนาด 2 1/4 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	10.00	\N	0	0.00	\N	\N	t	\N
443	P230-000443	วัสดุใช้ไป	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	95.00	\N	0	0.00	\N	\N	t	\N
444	P230-000444	วัสดุใช้ไป	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีชมพู	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	95.00	\N	0	0.00	\N	\N	t	\N
445	P230-000445	วัสดุใช้ไป	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	95.00	\N	0	0.00	\N	\N	t	\N
446	P230-000446	วัสดุใช้ไป	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	95.00	\N	0	0.00	\N	\N	t	\N
447	P230-000447	วัสดุใช้ไป	กระดาษโรเนียว หนา 70 แกรม ขนาด A4 สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	120.00	\N	0	0.00	\N	\N	t	\N
448	P230-000448	วัสดุใช้ไป	กระดาษโรเนียว หนา 80 แกรม ขนาด F4 สีขาว	วัสดุสำนักงาน	วัสดุสำนักงาน	รีม	130.00	\N	0	0.00	\N	\N	t	\N
451	P230-000451	วัสดุใช้ไป	กาว ชนิดแท่ง	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	65.00	\N	0	0.00	\N	\N	t	\N
452	P230-000452	วัสดุใช้ไป	กาว ชนิดน้ำ แบบป้าย ขนาด 560 ซีซี	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	30.00	\N	0	0.00	\N	\N	t	\N
453	P230-000453	วัสดุใช้ไป	กาว ชนิดน้ำ แบบหัวโฟม ขนาด 50 ซีซี	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	20.00	\N	0	0.00	\N	\N	t	\N
455	P230-000455	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #108 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	55.00	\N	0	0.00	\N	\N	t	\N
456	P230-000456	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #109 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	40.00	\N	0	0.00	\N	\N	t	\N
457	P230-000457	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #110 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	25.00	\N	0	0.00	\N	\N	t	\N
458	P230-000458	วัสดุใช้ไป	คลิปหนีบกระดาษ ขนาด #111 สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N
460	P230-000460	วัสดุใช้ไป	เครื่องคิดเลข ชนิด 2 ระบบ แบบ 12 หลัก	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	850.00	\N	0	0.00	\N	\N	t	\N
461	P230-000461	วัสดุใช้ไป	เครื่องเจาะกระดาษ แบบเจาะ 25 แผ่น	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	200.00	\N	0	0.00	\N	\N	t	\N
462	P230-000462	วัสดุใช้ไป	เครื่องเย็บกระดาษ ขนาด NO.10	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	85.00	\N	0	0.00	\N	\N	t	\N
463	P230-000463	วัสดุใช้ไป	เครื่องเย็บกระดาษ ขนาด NO.35	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	360.00	\N	0	0.00	\N	\N	t	\N
464	P230-000464	วัสดุใช้ไป	เชือก ชนิดพลาสติก ขนาดใหญ่ ยาว 180 ม. สี่ขาว-แดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	65.00	\N	0	0.00	\N	\N	t	\N
465	P230-000465	วัสดุใช้ไป	ซองขาว แบบมีครุฑ ขนาด #9/125	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	1.00	\N	0	0.00	\N	\N	t	\N
466	P230-000466	วัสดุใช้ไป	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	4.00	\N	0	0.00	\N	\N	t	\N
467	P230-000467	วัสดุใช้ไป	ซองน้ำตาล แบบมีครุฑ ไม่ขยายข้าง หนาพิเศษ ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	4.00	\N	0	0.00	\N	\N	t	\N
468	P230-000468	วัสดุใช้ไป	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด F4	วัสดุสำนักงาน	วัสดุสำนักงาน	ซอง	4.00	\N	0	0.00	\N	\N	t	\N
471	P230-000471	วัสดุใช้ไป	ตรายาง สำหรั้บปั๊มวันที่เลขไทย	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	60.00	\N	0	0.00	\N	\N	t	\N
474	P230-000474	วัสดุใช้ไป	เทปกาว ชนิด OPP ขนาด 2 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	25.00	\N	0	0.00	\N	\N	t	\N
476	P230-000476	วัสดุใช้ไป	เทปใส แบบแกนเล็ก ขนาด 1 นิ้ว 36 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N
477	P230-000477	วัสดุใช้ไป	เทปใส แบบแกนใหญ่ ขนาด 1 นิ้ว 36 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N
478	P230-000478	วัสดุใช้ไป	เทปใส แบบแกนใหญ่ ขนาด 2 นิ้ว 45 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	45.00	\N	0	0.00	\N	\N	t	\N
479	P230-000479	วัสดุใช้ไป	เทปใส แบบแกนเล็ก ขนาด 3/4 นิ้ว 36 หลา	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	30.00	\N	0	0.00	\N	\N	t	\N
484	P230-000484	วัสดุใช้ไป	แท่นประทับ แบบฝาโลหะ สีดำ #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
485	P230-000485	วัสดุใช้ไป	แท่นประทับ แบบฝาโลหะ สีแดง #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
486	P230-000486	วัสดุใช้ไป	แท่นประทับ แบบฝาโลหะ สีน้ำเงิน #2	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
492	P230-000492	วัสดุใช้ไป	น้ำยา สำหรับลบคำผิด ขนาด 7 มล.	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่ง	20.00	\N	0	0.00	\N	\N	t	\N
503	P230-000503	วัสดุใช้ไป	แบบฟอร์ม ชนิดเคมี 2 ชั้น Doctor's Order แบบต่อเนื่อง เคมี 2 ชั้น 9*11" (1,000 ชุด/กล่อง) ขนาด 9*11 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	2200.00	\N	0	0.00	\N	\N	t	\N
505	P230-000505	วัสดุใช้ไป	แบบฟอร์ม ปรอท แบบพิมพ์ 2 สี หนา 70 แกรม ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	ห่อ	400.00	\N	0	0.00	\N	\N	t	\N
506	P230-000506	วัสดุใช้ไป	ใบมีดคัตเตอร์ ขนาดเล็ก	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	20.00	\N	0	0.00	\N	\N	t	\N
507	P230-000507	วัสดุใช้ไป	ใบมีดคัตเตอร์ ขนาดใหญ่	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	25.00	\N	0	0.00	\N	\N	t	\N
509	P230-000509	วัสดุใช้ไป	แบบฟอร์ม ใบรับรองแพทย์ กรณีสมัครงาน	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	60.00	\N	0	0.00	\N	\N	t	\N
510	P230-000510	วัสดุใช้ไป	แบบฟอร์ม ใบเสร็จรับเงิน (1,000 ชุด/กล่อง)	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	1600.00	\N	0	0.00	\N	\N	t	\N
514	P230-000514	วัสดุใช้ไป	ปากกา เขียนแผ่น CD สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	40.00	\N	0	0.00	\N	\N	t	\N
515	P230-000515	วัสดุใช้ไป	ปากกา เคมี แบบ 2 หัว สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	15.00	\N	0	0.00	\N	\N	t	\N
516	P230-000516	วัสดุใช้ไป	ปากกา เคมี แบบ 2 หัว สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	15.00	\N	0	0.00	\N	\N	t	\N
517	P230-000517	วัสดุใช้ไป	ปากกา เคมี แบบ 2 หัว สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	15.00	\N	0	0.00	\N	\N	t	\N
518	P230-000518	วัสดุใช้ไป	ปากกา ไวท์บอร์ด ตราม้า สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N
521	P230-000521	วัสดุใช้ไป	ปากกา ไวท์บอร์ด ตราม้า สีน้ำเงิน	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N
522	P230-000522	วัสดุใช้ไป	ปากกา ไวท์บอร์ด PILOT สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	ด้าม	25.00	\N	0	0.00	\N	\N	t	\N
523	P230-000523	วัสดุใช้ไป	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A5	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	45.00	\N	0	0.00	\N	\N	t	\N
524	P230-000524	วัสดุใช้ไป	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A7	วัสดุสำนักงาน	วัสดุสำนักงาน	แพค	45.00	\N	0	0.00	\N	\N	t	\N
525	P230-000525	วัสดุใช้ไป	แปรง สำหรับลบกระดานไวท์บอร์ด	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
530	P230-000530	วัสดุใช้ไป	พลาสติกเคลือบบัตร ขนาด 6*95 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	60.00	\N	0	0.00	\N	\N	t	\N
531	P230-000531	วัสดุใช้ไป	พลาสติกเคลือบบัตร หนา 125 ไมครอน ขนาด A4	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	350.00	\N	0	0.00	\N	\N	t	\N
533	P230-000533	วัสดุใช้ไป	แฟ้ม แบบแขวน สีเขียว	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N
534	P230-000534	วัสดุใช้ไป	แฟ้ม แบบแขวน สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N
535	P230-000535	วัสดุใช้ไป	แฟ้ม แบบแขวน สีส้ม	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N
536	P230-000536	วัสดุใช้ไป	แฟ้ม แบบแขวน สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	15.00	\N	0	0.00	\N	\N	t	\N
537	P230-000537	วัสดุใช้ไป	แฟ้ม เวชระเบียน	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	10.00	\N	0	0.00	\N	\N	t	\N
538	P230-000538	วัสดุใช้ไป	แฟ้ม แบบสันแข็ง ขนาด 1 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	55.00	\N	0	0.00	\N	\N	t	\N
539	P230-000539	วัสดุใช้ไป	แฟ้ม แบบสันแข็ง ขนาด 2 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	60.00	\N	0	0.00	\N	\N	t	\N
540	P230-000540	วัสดุใช้ไป	แฟ้ม แบบสันแข็ง ขนาด 3 นิ้ว	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	75.00	\N	0	0.00	\N	\N	t	\N
541	P230-000541	วัสดุใช้ไป	แฟ้ม เสนอเซ็นต์ ขนาด F4	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	140.00	\N	0	0.00	\N	\N	t	\N
542	P230-000542	วัสดุใช้ไป	แฟ้ม ชนิดปกพลาสติก แบบหนีบ	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม	120.00	\N	0	0.00	\N	\N	t	\N
543	P230-000543	วัสดุใช้ไป	มีดคัตเตอร์ ชนิดด้ามสแตนเลส ขนาดเล็ก	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	35.00	\N	0	0.00	\N	\N	t	\N
544	P230-000544	วัสดุใช้ไป	มีดคัตเตอร์ ชนิดด้ามพลาสติก ขนาดใหญ่	วัสดุสำนักงาน	วัสดุสำนักงาน	อัน	25.00	\N	0	0.00	\N	\N	t	\N
546	P230-000546	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 10	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	10.00	\N	0	0.00	\N	\N	t	\N
548	P230-000548	วัสดุใช้ไป	ลวดเย็บกระดาษ เบอร์ 35	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	10.00	\N	0	0.00	\N	\N	t	\N
550	P230-000550	วัสดุใช้ไป	ลวดเสียบกระดาษ ขนาดเล็ก เบอร์ 1	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	15.00	\N	0	0.00	\N	\N	t	\N
551	P230-000551	วัสดุใช้ไป	ลวดเสียบกระดาษ ขนาดใหญ่ เบอร์ 0	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	15.00	\N	0	0.00	\N	\N	t	\N
553	P230-000553	วัสดุใช้ไป	ลิ้นแฟ้ม ชนิดเหล็ก	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่อง	95.00	\N	0	0.00	\N	\N	t	\N
560	P230-000560	วัสดุใช้ไป	สติ๊กเกอร์ แบบต่อเนื่อง สำหรับพิมพ์ชื่อผู้ป่วย ขนาด 6*2.5 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	ม้วน	200.00	\N	0	0.00	\N	\N	t	\N
561	P230-000561	วัสดุใช้ไป	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีฟ้า	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	5.00	\N	0	0.00	\N	\N	t	\N
562	P230-000562	วัสดุใช้ไป	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีเหลือง	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่น	5.00	\N	0	0.00	\N	\N	t	\N
566	P230-000566	วัสดุใช้ไป	สมุด ชนิดปกสี คู่มือเบิกจ่ายในราชการ 301	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	30.00	\N	0	0.00	\N	\N	t	\N
568	P230-000568	วัสดุใช้ไป	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือรับ	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	65.00	\N	0	0.00	\N	\N	t	\N
569	P230-000569	วัสดุใช้ไป	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือส่ง	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	65.00	\N	0	0.00	\N	\N	t	\N
572	P230-000572	วัสดุใช้ไป	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 1 หุ้มปก ขนาด 24x35 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	50.00	\N	0	0.00	\N	\N	t	\N
573	P230-000573	วัสดุใช้ไป	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 2 หุ้มปก ขนาด 19x31 ซม.	วัสดุสำนักงาน	วัสดุสำนักงาน	เล่ม	40.00	\N	0	0.00	\N	\N	t	\N
578	P230-000578	วัสดุใช้ไป	หมึกเติม สำหรับแท่นประทับตรายาง สีดำ	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	15.00	\N	0	0.00	\N	\N	t	\N
579	P230-000579	วัสดุใช้ไป	หมึกเติม สำหรับแท่นประทับตรายาง สีแดง	วัสดุสำนักงาน	วัสดุสำนักงาน	ขวด	15.00	\N	0	0.00	\N	\N	t	\N
712	P230-000712	วัสดุใช้ไป	หมึก Printer Ink jet BT5000C สีฟ้า	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	290.00	\N	0	0.00	\N	\N	t	\N
713	P230-000713	วัสดุใช้ไป	หมึก Printer Ink jet BT5000M สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	290.00	\N	0	0.00	\N	\N	t	\N
714	P230-000714	วัสดุใช้ไป	หมึก Printer Ink jet BT5000Y สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	290.00	\N	0	0.00	\N	\N	t	\N
784	P230-000784	วัสดุใช้ไป	Flash drive แบบ USB ขนาด 16 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	180.00	\N	0	0.00	\N	\N	t	\N
938	P230-000938	วัสดุใช้ไป	หมึก Printer Laser BROTHER FAX2950	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	590.00	\N	0	0.00	\N	\N	t	\N
940	P230-000940	วัสดุใช้ไป	Power supply ขนาด 550W	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1350.00	\N	0	0.00	\N	\N	t	\N
942	P230-000942	วัสดุใช้ไป	สาย HDMI ชนิด 4K ขนาด 5 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	390.00	\N	0	0.00	\N	\N	t	\N
943	P230-000943	วัสดุใช้ไป	สาย HDMI ชนิด 4K ขนาด 10 เมตร	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เส้น	890.00	\N	0	0.00	\N	\N	t	\N
944	P230-000944	วัสดุใช้ไป	กล่องใส่ Hardisk ขนาด 2.5 นิ้ว	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	690.00	\N	0	0.00	\N	\N	t	\N
945	P230-000945	วัสดุใช้ไป	คีม สำหรับเข้าหัว LAN	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	990.00	\N	0	0.00	\N	\N	t	\N
987	P230-000987	วัสดุใช้ไป	Hardisk External ขนาด 1 Tb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	2000.00	\N	0	0.00	\N	\N	t	\N
989	P230-000989	วัสดุใช้ไป	MP3 player แบบ USB ขนาด 512 MB	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	299.00	\N	0	0.00	\N	\N	t	\N
1106	P230-001106	วัสดุใช้ไป	Hardisk ชนิด SSD Internal ขนาด 500 Gb	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	อัน	1690.00	\N	0	0.00	\N	\N	t	\N
1114	P230-001114	วัสดุใช้ไป	หมึก Printer Laser FUJI-XEROX CT202877 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	980.00	\N	0	0.00	\N	\N	t	\N
1115	P230-001115	วัสดุใช้ไป	หมึก Printer Laser FUJI-XEROX CT203486 สีดำ	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N
1116	P230-001116	วัสดุใช้ไป	หมึก Printer Laser FUJI-XEROX CT203486 สีชมพู	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N
1117	P230-001117	วัสดุใช้ไป	หมึก Printer Laser FUJI-XEROX CT203486 สีเหลือง	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่อง	1350.00	\N	0	0.00	\N	\N	t	\N
\.


--
-- Data for Name: purchase_approval; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_approval (id, approve_code, doc_no, doc_date, status, total_amount, total_items, prepared_by, approved_by, approved_at, notes, created_by, created_at, updated_by, updated_at, version, doc_seq, pending_note, budget_year) FROM stdin;
38	230-2569-0002	พล. 0733.301/พิเศษ	2026-03-14	CANCELLED	825.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-14 08:53:04.723716	system	2026-03-15 13:54:10.330297	7	2	\N	2569
36	230-2569-0001	พล. 0733.301/พิเศษ	2026-03-14	DRAFT	1170.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-14 08:52:45.290965	system	2026-03-15 13:54:10.330297	6	1	\N	2569
44	230-2569-0005	พล. 0733.301/พิเศษ	2026-03-14	APPROVED	3090.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-14 08:58:24.409082	system	2026-03-15 13:54:10.330297	7	5	\N	2569
40	230-2569-0003	พล. 0733.301/พิเศษ	2026-03-14	DRAFT	700.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-14 08:54:01.139461	SYSTEM	2026-03-15 13:54:10.330297	7	3	\N	2569
42	230-2569-0004	พล. 0733.301/พิเศษ	2026-03-14	DRAFT	1120.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-14 08:56:34.574335	system	2026-03-15 14:13:42.061345	8	4	\N	2569
56	230-2569-0012	พล. 0733.301/พิเศษ	2026-03-13	PENDING	680.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-15 11:39:11.573016	SYSTEM	2026-03-15 13:54:10.330297	7	12	รอการตรวจสอบ	2569
54	230-2569-0010	พล. 0733.301/พิเศษ	2026-03-15	DRAFT	220.00	1	system	\N	\N	สร้างจากแผนจัดซื้อ 1 รายการ	system	2026-03-15 10:57:29.25303	SYSTEM	2026-03-15 13:54:10.330297	7	10	\N	2569
50	230-2569-0008	พล. 0733.301/พิเศษ	2026-03-14	REJECTED	2730.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-14 09:46:08.585109	system	2026-03-15 13:54:10.330297	7	8	\N	2569
52	230-2569-0009	พล. 0733.301/พิเศษ	2026-03-15	APPROVED	1765.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-15 10:54:52.186638	system	2026-03-15 13:54:10.330297	9	9	\N	2569
48	230-2569-0007	พล. 0733.301/พิเศษ	2026-03-14	APPROVED	1400.00	2	system	\N	\N	สร้างจากแผนจัดซื้อ 2 รายการ	system	2026-03-14 09:44:07.48396	system	2026-03-15 13:54:10.330297	7	7	\N	2569
46	230-2569-0006	พล. 0733.301/พิเศษ	2026-03-14	PENDING	4736.00	5	system	\N	\N	สร้างจากแผนจัดซื้อ 5 รายการ	system	2026-03-14 09:20:39.991315	system	2026-03-15 13:54:10.330297	7	6	รอการตรวจสอบจากหัวหน้าแผนกก่อนอนุมัติ	2569
55	230-2569-0011	พล. 0733.301/พิเศษ	2026-03-15	DRAFT	225.00	1	system	\N	\N	สร้างจากแผนจัดซื้อ 1 รายการ	system	2026-03-15 11:20:53.533198	SYSTEM	2026-03-15 14:16:39.849612	11	11	\N	2569
58	230-2569-0013	พล. 0733.301/พิเศษ	2026-03-15	DRAFT	2890.00	3	system	\N	\N	สร้างจากแผนจัดซื้อ 3 รายการ	system	2026-03-15 14:17:57.007074	SYSTEM	2026-03-15 14:20:13.728806	5	13	\N	2569
\.


--
-- Data for Name: purchase_approval_backup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_approval_backup (id, approval_id, department, record_number, request_date, product_name, product_code, category, product_type, product_subtype, requested_quantity, unit, price_per_unit, total_value, over_plan_case, requester, approver, budget_year, created_at, updated_at, department_code) FROM stdin;
1	\N	\N	\N	2026-03-12	เสียม ชนิดเหล็ก แบบด้ามไม้ ขนาด 2 นิ้ว	P230-001325	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	\N	อัน	350.00	0.00	\N	\N	\N	2569	2026-03-12 23:17:46.071349	2026-03-12 23:17:46.071349	\N
2	\N	\N	\N	2026-03-12	เสื้อกาวน์ยาว	P230-001232	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	\N	ตัว	0.00	0.00	\N	\N	\N	2569	2026-03-12 23:18:09.440374	2026-03-12 23:18:09.440374	\N
\.


--
-- Data for Name: purchase_approval_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_approval_detail (id, purchase_approval_id, purchase_plan_id, line_number, status, approved_quantity, approved_amount, remarks, created_by, created_at, updated_by, updated_at, version) FROM stdin;
22	36	16	1	PENDING	2	780.00	\N	system	2026-03-14 08:52:45.295423	system	2026-03-14 08:52:45.295423	1
23	36	15	2	PENDING	1	390.00	\N	system	2026-03-14 08:52:45.304575	system	2026-03-14 08:52:45.304575	1
24	38	14	1	PENDING	3	600.00	\N	system	2026-03-14 08:53:04.727496	system	2026-03-14 08:53:04.727496	1
25	38	13	2	PENDING	5	225.00	\N	system	2026-03-14 08:53:04.735853	system	2026-03-14 08:53:04.735853	1
26	40	11	1	PENDING	1	100.00	\N	system	2026-03-14 08:54:01.144096	system	2026-03-14 08:54:01.144096	1
27	40	10	2	PENDING	2	600.00	\N	system	2026-03-14 08:54:01.158344	system	2026-03-14 08:54:01.158344	1
28	42	9	1	PENDING	10	1000.00	\N	system	2026-03-14 08:56:34.578494	system	2026-03-14 08:56:34.578494	1
29	42	8	2	PENDING	1	120.00	\N	system	2026-03-14 08:56:34.588606	system	2026-03-14 08:56:34.588606	1
30	44	7	1	PENDING	4	1200.00	\N	system	2026-03-14 08:58:24.413188	system	2026-03-14 08:58:24.413188	1
31	44	6	2	PENDING	3	1890.00	\N	system	2026-03-14 08:58:24.421391	system	2026-03-14 08:58:24.421391	1
32	46	33	1	PENDING	2	36.00	\N	system	2026-03-14 09:20:39.996153	system	2026-03-14 09:20:39.996153	1
33	46	31	2	PENDING	5	200.00	\N	system	2026-03-14 09:20:40.006143	system	2026-03-14 09:20:40.006143	1
34	46	30	3	PENDING	1	100.00	\N	system	2026-03-14 09:20:40.013228	system	2026-03-14 09:20:40.013228	1
35	46	29	4	PENDING	2	400.00	\N	system	2026-03-14 09:20:40.023489	system	2026-03-14 09:20:40.023489	1
36	46	28	5	PENDING	1	4000.00	\N	system	2026-03-14 09:20:40.03094	system	2026-03-14 09:20:40.03094	1
37	48	27	1	PENDING	10	1200.00	\N	system	2026-03-14 09:44:07.488401	system	2026-03-14 09:44:07.488401	1
38	48	26	2	PENDING	1	200.00	\N	system	2026-03-14 09:44:07.49773	system	2026-03-14 09:44:07.49773	1
39	50	24	1	PENDING	5	2500.00	\N	system	2026-03-14 09:46:08.593594	system	2026-03-14 09:46:08.593594	1
40	50	23	2	PENDING	1	230.00	\N	system	2026-03-14 09:46:08.608459	system	2026-03-14 09:46:08.608459	1
41	52	39	1	PENDING	20	400.00	\N	system	2026-03-15 10:54:52.19405	system	2026-03-15 10:54:52.19405	1
42	52	38	2	PENDING	21	1365.00	\N	system	2026-03-15 10:54:52.212927	system	2026-03-15 10:54:52.212927	1
43	54	32	1	PENDING	10	220.00	\N	system	2026-03-15 10:57:29.258358	system	2026-03-15 10:57:29.258358	1
44	55	22	1	PENDING	5	225.00	\N	system	2026-03-15 11:20:53.545285	system	2026-03-15 11:20:53.545285	1
45	56	21	1	PENDING	1	630.00	\N	system	2026-03-15 11:39:11.588432	system	2026-03-15 11:39:11.588432	1
46	56	19	2	PENDING	1	50.00	\N	system	2026-03-15 11:39:11.754929	system	2026-03-15 11:39:11.754929	1
47	58	18	1	PENDING	1	730.00	\N	system	2026-03-15 14:17:57.01661	system	2026-03-15 14:17:57.01661	1
48	58	12	2	PENDING	10	1200.00	\N	system	2026-03-15 14:17:57.02699	system	2026-03-15 14:17:57.02699	1
49	58	5	3	PENDING	8	960.00	\N	system	2026-03-15 14:17:57.037517	system	2026-03-15 14:17:57.037517	1
\.


--
-- Data for Name: purchase_approval_inventory_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_approval_inventory_link (id, purchase_approval_id, inventory_receipt_status, received_qty, last_receipt_id, created_at, updated_at, purchase_approval_detail_id) FROM stdin;
22	22	PENDING	0	\N	2026-03-14 08:52:45.300093	2026-03-14 08:52:45.300093	22
23	23	PENDING	0	\N	2026-03-14 08:52:45.3076	2026-03-14 08:52:45.3076	23
24	24	PENDING	0	\N	2026-03-14 08:53:04.732081	2026-03-14 08:53:04.732081	24
25	25	PENDING	0	\N	2026-03-14 08:53:04.739592	2026-03-14 08:53:04.739592	25
26	26	PENDING	0	\N	2026-03-14 08:54:01.151075	2026-03-14 08:54:01.151075	26
27	27	PENDING	0	\N	2026-03-14 08:54:01.163234	2026-03-14 08:54:01.163234	27
28	28	PENDING	0	\N	2026-03-14 08:56:34.58316	2026-03-14 08:56:34.58316	28
29	29	PENDING	0	\N	2026-03-14 08:56:34.59348	2026-03-14 08:56:34.59348	29
30	30	PENDING	0	\N	2026-03-14 08:58:24.417842	2026-03-14 08:58:24.417842	30
31	31	PENDING	0	\N	2026-03-14 08:58:24.426865	2026-03-14 08:58:24.426865	31
32	32	PENDING	0	\N	2026-03-14 09:20:40.001456	2026-03-14 09:20:40.001456	32
33	33	PENDING	0	\N	2026-03-14 09:20:40.00944	2026-03-14 09:20:40.00944	33
34	34	PENDING	0	\N	2026-03-14 09:20:40.017557	2026-03-14 09:20:40.017557	34
35	35	PENDING	0	\N	2026-03-14 09:20:40.026904	2026-03-14 09:20:40.026904	35
36	36	PENDING	0	\N	2026-03-14 09:20:40.035364	2026-03-14 09:20:40.035364	36
37	37	PENDING	0	\N	2026-03-14 09:44:07.493365	2026-03-14 09:44:07.493365	37
38	38	PENDING	0	\N	2026-03-14 09:44:07.500654	2026-03-14 09:44:07.500654	38
39	39	PENDING	0	\N	2026-03-14 09:46:08.601452	2026-03-14 09:46:08.601452	39
40	40	PENDING	0	\N	2026-03-14 09:46:08.615719	2026-03-14 09:46:08.615719	40
41	41	PENDING	0	\N	2026-03-15 10:54:52.202548	2026-03-15 10:54:52.202548	41
42	42	PENDING	0	\N	2026-03-15 10:54:52.217033	2026-03-15 10:54:52.217033	42
43	43	PENDING	0	\N	2026-03-15 10:57:29.263355	2026-03-15 10:57:29.263355	43
44	44	PENDING	0	\N	2026-03-15 11:20:53.555055	2026-03-15 11:20:53.555055	44
45	45	PENDING	0	\N	2026-03-15 11:39:11.596982	2026-03-15 11:39:11.596982	45
46	46	PENDING	0	\N	2026-03-15 11:39:11.840986	2026-03-15 11:39:11.840986	46
47	47	PENDING	0	\N	2026-03-15 14:17:57.021849	2026-03-15 14:17:57.021849	47
48	48	PENDING	0	\N	2026-03-15 14:17:57.03302	2026-03-15 14:17:57.03302	48
49	49	PENDING	0	\N	2026-03-15 14:17:57.041218	2026-03-15 14:17:57.041218	49
\.


--
-- Data for Name: purchase_approval_inventory_link_backup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_approval_inventory_link_backup (id, purchase_approval_id, inventory_receipt_status, received_qty, last_receipt_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchase_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_plan (id, usage_plan_id, inventory_qty, inventory_value, purchase_qty, purchase_value) FROM stdin;
1	1	0	0.00	1	200.00
2	3	0	0.00	2	460.00
3	4	0	0.00	2	500.00
4	5	0	0.00	4	2520.00
5	6	0	0.00	8	960.00
6	12	0	0.00	3	1890.00
7	13	0	0.00	4	1200.00
8	14	0	0.00	1	120.00
9	15	0	0.00	10	1000.00
10	16	0	0.00	2	600.00
11	3370	0	0.00	1	100.00
12	3368	0	0.00	10	1200.00
13	3367	0	0.00	5	225.00
14	3380	0	0.00	3	600.00
15	3359	0	0.00	1	390.00
16	3363	0	0.00	2	780.00
17	3371	0	0.00	5	150.00
18	3362	0	0.00	1	730.00
19	3376	0	0.00	1	50.00
21	3364	0	0.00	1	630.00
22	3379	0	0.00	5	225.00
23	3369	0	0.00	1	230.00
24	3365	0	0.00	5	2500.00
26	3360	0	0.00	1	200.00
27	3374	0	0.00	10	1200.00
28	3378	0	0.00	1	4000.00
29	3377	0	0.00	2	400.00
30	3361	0	0.00	1	100.00
31	3366	0	0.00	5	200.00
32	3352	0	0.00	10	220.00
33	3353	0	0.00	2	36.00
38	3381	0	0.00	21	1365.00
39	3382	0	0.00	20	400.00
20	3375	0	0.00	10	1200.00
\.


--
-- Data for Name: seller; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seller (id, code, prefix, name, business, address, phone, fax, mobile) FROM stdin;
1	st001	บริษัท	บริษัท ทดสอบ จำกัด					
2	st002	ห้างหุ้นส่วนจำกัด	ห้างหุ้นส่วนจำกัด ทดสอบ					
3	st003	บริษัท	บริษัท วัสดุการแพทย์ ก ไก่					
\.


--
-- Data for Name: test_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_data (id, first_name, last_name, sex, birth, age) FROM stdin;
1	สมชาย	ใจดี	ชาย	1990-02-14	36
2	กมลชนก	ศรีสุข	หญิง	1992-07-03	33
3	ปกรณ์	จันทรา	ชาย	1988-11-21	37
4	ธิดารัตน์	มณีวงศ์	หญิง	1995-01-10	31
5	ชยพล	รุ่งเรือง	ชาย	1993-05-18	32
6	พิมพ์ชนก	อารีย์	หญิง	1991-09-27	34
7	จิรายุ	วงษ์ทอง	ชาย	1987-12-05	38
8	ศศิธร	วัฒนกูล	หญิง	1994-04-08	31
9	วรพงษ์	เกษมสุข	ชาย	1996-08-15	29
10	อาทิตยา	จำรูญ	หญิง	1990-10-30	35
\.


--
-- Data for Name: usage_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usage_plan (id, product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit, requesting_dept, approved_quota, budget_year, sequence_no, created_at, updated_at, requesting_dept_code) FROM stdin;
3345	P230-000008	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ถ้วยรองใบมีด สำหรับเครื่องตัดหญ้า	1	อัน	480.00	กลุ่มงานบริหารทั่วไป	1	2569	2	2026-03-10 22:18:13.799425	2026-03-10 22:18:28.248655	0001
3353	P230-000721	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิด PVC แบบลด ขนาด 1 นิ้ว	2	อัน	18.00	กลุ่มงานบริหารทั่วไป	2	2569	2	2026-03-11 07:23:54.254066	2026-03-11 07:23:54.254066	0001
1231	P230-001231	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	นาฬิกาจับเวลา	5	อัน	900.00	กลุ่มงานเทคนิคการแพทย์	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0002
1233	P230-001233	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ตะกร้า	0	อัน	30.00	กลุ่มงานเทคนิคการแพทย์	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0002
3346	P230-000188	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เต๊นท์ผ้าใบ แบบโค้งพร้อมโครงเหล็ก ขนาด 4*8 เมตร	5	หลัง	24500.00	กลุ่มการพยาบาล	5	2569	1	2026-03-10 22:50:24.089795	2026-03-10 22:50:40.112125	0011
3354	P230-000596	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หนังสือ มาตรฐานโรงพยาบาลและบริการสุขภาพ ฉบับที่ 5	8	เล่ม	500.00	กลุ่มงานบริหารทั่วไป	8	2569	2	2026-03-11 07:23:54.259223	2026-03-11 07:23:54.259223	0001
1234	P230-001234	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	กระติ๊กน้ำแข็ง 5 ลิตร ใส่วัคซีนและยาเย็น	0	อัน	175.00	กลุ่มงานเทคนิคการแพทย์	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0002
3342	P230-000053	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก Hardisk ชนิด Surveillance สำหรับกล้องวงจรปิด (NVR) ขนาด 4 Tb	10	อัน	3790.00	กลุ่มงานบริหารทั่วไป	5	2569	2	2026-03-10 09:21:19.502329	2026-03-10 09:21:19.502329	0001
3343	P230-000106	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง เบอร์ L สีส้ม	20	คู่	45.00	กลุ่มงานเทคนิคการแพทย์	10	2569	1	2026-03-10 09:21:19.507182	2026-03-10 09:22:25.300025	0002
20	P230-000020	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	คีย์บอร์ด แบบ USB	20	อัน	320.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
21	P230-000021	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ซองใส่ CD แบบใส (50 ซอง/แพค)	0	แพค	70.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
14	P230-000014	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	จาระบี สำหรับเครื่องตัดหญ้า	1	กระปุก	120.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
15	P230-000015	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ใบมีด สำหรับเครื่องตัดหญ้า	10	อัน	100.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3347	P230-000003	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ประกับ สำหรับเครื่องตัดหญ้า	5	อัน	230.00	กลุ่มงานบริหารทั่วไป	0	2569	2	2026-03-10 23:11:27.301158	2026-03-10 23:11:27.301158	0001
3355	P230-001174	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	พาน สำหรับจัดดอกไม้	1	อัน	420.00	กลุ่มงานบริหารทั่วไป	1	2569	2	2026-03-11 07:23:54.259688	2026-03-11 07:23:54.259688	0001
3337	P230-001328	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	แผ่นโฟมจิ๊กซอว์ แบบ ABC ขนาด 29*29 ซม. (PCU วังทอง)	5	ชุด	310.00	งานผู้ป่วยในหญิงและเด็ก	5	2569	1	2026-03-07 15:41:06.53378	2026-03-08 10:40:27.894897	0017
3344	P230-000103	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L	11	คู่	120.00	กลุ่มงานเทคนิคการแพทย์	11	2569	1	2026-03-10 09:21:19.507184	2026-03-10 14:22:14.486775	0002
16	P230-000016	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	เลื่อย ชนิดขอชัก สำหรับตัดแต่งกิ่ง	2	อัน	300.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
17	P230-000017	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	สายยาง สำหรับรดน้ำต้นไม้ ขนาด 5/8 นิ้ว	3	เส้น	360.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
18	P230-000018	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	สายสะพาย สำหรับเครื่องตัดหญ้า	2	อัน	160.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
19	P230-000019	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	หัวเทียน สำหรับเครื่องตัดหญ้า	2	อัน	30.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
22	P230-000022	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ300	0	กล่อง	170.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
23	P230-000023	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ผ้าหมึก Printer ชนิดแคร่สั้น แบบ LQ310	10	กล่อง	150.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
24	P230-000024	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	แผ่น CD-R (50 ซอง/แพค)	0	หลอด	280.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
25	P230-000025	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	เม้าท์ แบบ USB	22	อัน	250.00	กลุ่มงานบริหารทั่วไป	22	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
28	P230-000028	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet GT52 สีชมพู	0	ขวด	390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
29	P230-000029	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet GT52 สีฟ้า	0	ขวด	390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
30	P230-000030	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet GT52 สีเหลือง	0	ขวด	390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
31	P230-000031	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet L5190 สีชมพู	0	กล่อง	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
32	P230-000032	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet L5190 สีดำ	0	กล่อง	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
33	P230-000033	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet L5190 สีฟ้า	0	กล่อง	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
35	P230-000035	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet T6641 สีดำ	13	ขวด	290.00	กลุ่มงานบริหารทั่วไป	13	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
36	P230-000036	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet T6641 สีฟ้า	4	ขวด	290.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
37	P230-000037	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet T6641 สีชมพู	4	ขวด	290.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
38	P230-000038	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet T6641 สีเหลือง	4	ขวด	290.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
39	P230-000039	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก หมึก Printer Ink jet T7741 สีดำ	0	ขวด	700.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
41	P230-000041	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 225	30	กล่อง	430.00	กลุ่มงานบริหารทั่วไป	30	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
42	P230-000042	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 30A	34	กล่อง	890.00	กลุ่มงานบริหารทั่วไป	34	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
43	P230-000043	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 355	0	กล่อง	670.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
44	P230-000044	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 472	3	กล่อง	980.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
45	P230-000045	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 48A	0	กล่อง	1190.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
46	P230-000046	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 79A	4	กล่อง	690.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
47	P230-000047	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 83A	1	กล่อง	390.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
48	P230-000048	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 85A	2	กล่อง	390.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
49	P230-000049	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser Fuji m285Z P235	144	กล่อง	980.00	กลุ่มงานบริหารทั่วไป	144	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
50	P230-000050	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก หมึก Printer Laser TN-2060	0	กล่อง	490.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
51	P230-000051	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หัว LAN	1	กล่อง	1400.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
52	P230-000052	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก Hardisk ชนิด SATA/SSD External ขนาด 1 Tb	0	อัน	1800.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
53	P230-000053	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก Hardisk ชนิด Surveillance สำหรับกล้องวงจรปิด (NVR) ขนาด 4 Tb	0	อัน	3790.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
54	P230-000054	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก สาย LAN ชนิด CAT5 ขนาด 305 เมตร/กล่อง	0	กล่อง	2750.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
55	P230-000055	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก หมึก Printer Laser 230A	0	กล่อง	890.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
57	P230-000057	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet Epson 003 สีชมพู	5	ขวด	290.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
58	P230-000058	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet Epson 003 สีดำ	6	ขวด	290.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
59	P230-000059	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet Epson 003 สีฟ้า	6	ขวด	290.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
60	P230-000060	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet Epson 003 สีเหลือง	6	ขวด	290.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
61	P230-000061	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กรวยกระดาษ สำหรับดื่มน้ำ ขนาดบรรจุ 5,000 ใบ	15	ลัง	900.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
62	P230-000062	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระดาษชำระ ขนาดเล็ก	20	ม้วน	6.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
63	P230-000063	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระดาษชำระ ชนิดม้วน แบบ 2 ชั้น ขนาดยาว 300 เมตร	819	ม้วน	65.00	กลุ่มงานบริหารทั่วไป	819	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
64	P230-000064	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระดาษเช็ดมือ	4722	ม้วน	60.00	กลุ่มงานบริหารทั่วไป	4722	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
65	P230-000065	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระทะไฟฟ้า แบบเคลือบและมีซึ้ง	1	ชุด	1290.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
66	P230-000066	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระป๋องฉีดน้ำ	50	อัน	35.00	กลุ่มงานบริหารทั่วไป	50	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
67	P230-000067	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องใส่กระดาษเช็ดมือ	4	ใบ	500.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
68	P230-000068	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องใส่สบู่เหลว แบบติดผนัง	3	ใบ	300.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
69	P230-000069	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ก้อนดับกลิ่น	375	ก้อน	35.00	กลุ่มงานบริหารทั่วไป	375	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
70	P230-000070	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เกลือเม็ด	0	กิโลกรัม	12.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
71	P230-000071	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แก้วน้ำ แบบทรงสูง	6	ใบ	15.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
72	P230-000072	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แก้วน้ำ ชนิดพลาสติก ขนาด 4 ออนซ์	0	ใบ	1.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
73	P230-000073	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แก้วน้ำ ชนิดพลาสติก ขนาด 6 ออนซ์	10000	ใบ	1.00	กลุ่มงานบริหารทั่วไป	10000	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
74	P230-000074	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แก้วน้ำ ชนิดอลูมิเนียม	0	ใบ	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
75	P230-000075	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวดปั๊ม ชนิดพลาสติก สำหรับใส่น้ำยาแอลกอฮอล์	8	ขวด	40.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
76	P230-000076	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขันน้ำ ชนิดพลาสติก แบบมีด้าม	8	ใบ	25.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3356	AUTO-DUP-1773189065718	ทดสอบ	ทดสอบ	ทดสอบ	ทดสอบ AUTO-DUP-1773189065718	1	หน่วย	100.00	งานผู้ป่วยนอก	0	2569	1	2026-03-11 07:31:05.776726	2026-03-11 07:31:05.776726	0013
78	P230-000078	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขิง	0	กิโลกรัม	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
79	P230-000079	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ช้อน ชนิดสแตนเลส แบบสั้น	90	โหล	35.00	กลุ่มงานบริหารทั่วไป	90	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
80	P230-000080	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เชือก ชนิดปอแก้ว	165	ม้วน	50.00	กลุ่มงานบริหารทั่วไป	165	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
81	P230-000081	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ด้ามมีดโกน ชนิดพลาสติก แบบปลี่ยนใบมีดได้	0	อัน	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
82	P230-000082	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ด้ามมีดโกน ชนิดพลาสติก แบบใช้แล้วทิ้ง	480	อัน	35.00	กลุ่มงานบริหารทั่วไป	480	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
83	P230-000083	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตะกร้า ชนิดพลาสติก แบบทรงกลม	0	ใบ	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
84	P230-000084	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตะไคร้	0	กิโลกรัม	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
85	P230-000085	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เตา Hotplate แบบใช้ไฟฟ้า ขนาด 9 นิ้ว	4	ตัว	4000.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
86	P230-000086	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 42 ลิตร	16	ใบ	890.00	กลุ่มงานบริหารทั่วไป	16	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
87	P230-000087	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเขียว	555	กิโลกรัม	65.00	กลุ่มงานบริหารทั่วไป	555	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
88	P230-000088	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเขียว	674	กิโลกรัม	65.00	กลุ่มงานบริหารทั่วไป	674	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
89	P230-000089	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีดำ	1587	กิโลกรัม	50.00	กลุ่มงานบริหารทั่วไป	1587	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
90	P230-000090	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีดำ	671	กิโลกรัม	50.00	กลุ่มงานบริหารทั่วไป	671	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
91	P230-000091	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 18*22 นิ้ว สีแดง	0	กิโลกรัม	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
92	P230-000092	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีแดง	1094	กิโลกรัม	70.00	กลุ่มงานบริหารทั่วไป	1094	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
93	P230-000093	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีแดง	239	กิโลกรัม	70.00	กลุ่มงานบริหารทั่วไป	239	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
94	P230-000094	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 24*28 นิ้ว สีเหลือง	444	กิโลกรัม	70.00	กลุ่มงานบริหารทั่วไป	444	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
95	P230-000095	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 36*45 นิ้ว สีเหลือง	1005	กิโลกรัม	60.00	กลุ่มงานบริหารทั่วไป	1005	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
96	P230-000096	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 16*18 นิ้ว สีแดง	2	กิโลกรัม	60.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3357	AUTO-DUP-1773189065718	ทดสอบ	ทดสอบ	ทดสอบ	ทดสอบ AUTO-DUP-1773189065718	1	หน่วย	100.00	งานผู้ป่วยนอก	0	2569	2	2026-03-11 07:31:05.812981	2026-03-11 07:31:05.812981	0013
97	P230-000097	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงขยะ ชนิดพลาสติก ขนาด 28*40 นิ้ว สีแดง	0	กิโลกรัม	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
98	P230-000098	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง ชนิดพลาสติก ขนาด 16*26 นิ้ว สีใส	193	แพค	45.00	กลุ่มงานบริหารทั่วไป	193	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
99	P230-000099	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง ชนิดพลาสติก ขนาด 4.5*7 นิ้ว สีใส	67	แพค	45.00	กลุ่มงานบริหารทั่วไป	67	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
100	P230-000100	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง ชนิดพลาสติก ขนาด 6*9 นิ้ว สีใส	85	แพค	45.00	กลุ่มงานบริหารทั่วไป	85	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
101	P230-000101	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง ชนิดพลาสติก ขนาด 8*12 นิ้ว สีใส	150	แพค	45.00	กลุ่มงานบริหารทั่วไป	150	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
102	P230-000102	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิด PVC	0	คู่	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
103	P230-000103	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L	14	คู่	120.00	กลุ่มงานบริหารทั่วไป	14	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
104	P230-000104	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ M	30	คู่	120.00	กลุ่มงานบริหารทั่วไป	30	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
105	P230-000105	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L สีเขียว	0	คู่	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
106	P230-000106	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง เบอร์ L สีส้ม	47	คู่	45.00	กลุ่มงานบริหารทั่วไป	47	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
107	P230-000107	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง เบอร์ M สีส้ม	61	คู่	45.00	กลุ่มงานบริหารทั่วไป	61	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
108	P230-000108	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบอเนกประสงค์ เบอร์ L	2	คู่	45.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
109	P230-000109	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบอเนกประสงค์ เบอร์ M	4	คู่	45.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
110	P230-000110	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง ชนิดพลาสติก ขนาด 30*40 นิ้ว สีใส	0	แพค	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
111	P230-000111	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*24 นิ้ว สีขาว	356	แพค	45.00	กลุ่มงานบริหารทั่วไป	356	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
112	P230-000112	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงหิ้ว ชนิดพลาสติก ขนาด 15*30 นิ้ว สีขาว	50	แพค	45.00	กลุ่มงานบริหารทั่วไป	50	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
113	P230-000113	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงหิ้ว ชนิดพลาสติก ขนาด 8*16 นิ้ว สีขาว	989	แพค	45.00	กลุ่มงานบริหารทั่วไป	989	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
114	P230-000114	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*26 นิ้ว สีขาว	662	แพค	45.00	กลุ่มงานบริหารทั่วไป	662	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
115	P230-000115	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ที่ตักขยะ ชนิดพลาสติก แบบมีด้ามจับ	26	อัน	65.00	กลุ่มงานบริหารทั่วไป	26	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
116	P230-000116	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ที่ตักขยะสังกะสี ชนิดสังกะสี แบบมีด้ามจับ	5	อัน	95.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
117	P230-000117	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำมันงาสกัดเย็น	0	ขวด	300.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
118	P230-000118	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำมันมะพร้าว	0	กิโลกรัม	90.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
119	P230-000119	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยา สำหรับเช็ดกระจก	14	แกลลอน	130.00	กลุ่มงานบริหารทั่วไป	14	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
120	P230-000120	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยา สำหรับซาวผ้า	0	แกลลอน	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
121	P230-000121	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยา ชนิดสูตรน้ำ สำหรับดันฝุ่น	72	แกลลอน	370.00	กลุ่มงานบริหารทั่วไป	72	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
122	P230-000122	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยา ชนิดสูตรน้ำมันใส สำหรับดันฝุ่น	42	แกลลอน	430.00	กลุ่มงานบริหารทั่วไป	42	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
123	P230-000123	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยา สำหรับทำความสะอาดพื้น	346	แกลลอน	200.00	กลุ่มงานบริหารทั่วไป	346	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
124	P230-000124	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยา สำหรับล้างจาน	144	แกลลอน	120.00	กลุ่มงานบริหารทั่วไป	144	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
125	P230-000125	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยา สำหรับล้างมือ	184	แกลลอน	180.00	กลุ่มงานบริหารทั่วไป	184	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
126	P230-000126	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบมะกรูด	0	กิโลกรัม	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
127	P230-000127	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ใบมีดโกน แบบ 2 คม	77	กล่อง	35.00	กลุ่มงานบริหารทั่วไป	77	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
128	P230-000128	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ปืนยิงแก๊ส	8	อัน	25.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
129	P230-000129	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แป้งฝุ่น สำหรับเด็ก ขนาด 180 กรัม	40	กระป๋อง	35.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
130	P230-000130	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แปรง ชนิดทองเหลือง สำหรับขัดพื้น	0	อัน	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
384	P230-000384	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟ แบบกราวคู่	55	อัน	55.00	กลุ่มงานบริหารทั่วไป	55	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
131	P230-000131	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แปรง ชนิดพลาสติก สำหรับขัดพื้นแบบมีด้ามยาว	32	อัน	70.00	กลุ่มงานบริหารทั่วไป	32	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
132	P230-000132	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แปรง ชนิดพลาสติก สำหรับขัดห้องน้ำ	58	อัน	30.00	กลุ่มงานบริหารทั่วไป	58	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
133	P230-000133	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แปรง ชนิดขนอ่อน สำหรับซักผ้า	72	อัน	25.00	กลุ่มงานบริหารทั่วไป	72	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
134	P230-000134	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แปรง ชนิดพลาสติก สำหรับล้างขวด	14	อัน	25.00	กลุ่มงานบริหารทั่วไป	14	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
135	P230-000135	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผงซักฟอก ขนาด 800 กรัม	921	ถุง	70.00	กลุ่มงานบริหารทั่วไป	921	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
136	P230-000136	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผงซักฟอก สำหรับเครื่องซักผ้า ขนาด 25 กก.	0	กก.	1050.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
137	P230-000137	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าม็อบ สำหรับดันฝุ่น ขนาด 24 นิ้ว	41	ผืน	200.00	กลุ่มงานบริหารทั่วไป	41	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
138	P230-000138	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าม็อบ สำหรับถูพื้น แบบเปียก ขนาด 12 นิ้ว	83	ผืน	80.00	กลุ่มงานบริหารทั่วไป	83	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
139	P230-000139	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าห่ม สำหรับถูพื้น	24	ผืน	160.00	กลุ่มงานบริหารทั่วไป	24	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
140	P230-000140	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แผ่นขัดพื้น ขนาด 18 นิ้ว	5	อัน	400.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
141	P230-000141	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ฝอย ชนิดแสตนเลส ขนาด 14 กรัม	50	อัน	15.00	กลุ่มงานบริหารทั่วไป	50	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
142	P230-000142	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไพล	0	กิโลกรัม	35.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
143	P230-000143	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ฟองน้ำ แบบหุ้มตาข่าย	269	อัน	15.00	กลุ่มงานบริหารทั่วไป	269	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
144	P230-000144	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ฟอยล์ ขนาด 18 นิ้ว	72	อัน	85.00	กลุ่มงานบริหารทั่วไป	72	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
146	P230-000146	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	มะกรูด	0	กิโลกรัม	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
147	P230-000147	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	มะนาว	0	กิโลกรัม	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
148	P230-000148	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้กวาด ชนิดดอกหญ้า	114	อัน	50.00	กลุ่มงานบริหารทั่วไป	114	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
149	P230-000149	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้กวาด ชนิดทางมะพร้าว	16	อัน	60.00	กลุ่มงานบริหารทั่วไป	16	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3334	P230-001324	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ที่รีดกระจกสำหรับรถยนต์	7	อัน	120.00	กลุ่มงานบริหารทั่วไป	7	2569	2	2026-03-07 15:33:55.374249	2026-03-07 15:33:55.374249	0001
150	P230-000150	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้กวาด ชนิดทางมะพร้าว สำหรับกวาดหยากไย่	16	อัน	45.00	กลุ่มงานบริหารทั่วไป	16	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
151	P230-000151	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้กวาด ชนิดพลาสติก สำหรับกวาดหยากไย่ แบบปรับระดับได้	12	อัน	290.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
152	P230-000152	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้ดันฝุ่น แบบด้ามไม้ พร้อมผ้าดันฝุ่น ขนาดยาว 24 นิ้ว	12	อัน	450.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
153	P230-000153	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้ดันฝุ่น แบบด้ามอลูมิเนียม ขนาดยาว 24 นิ้ว	17	อัน	300.00	กลุ่มงานบริหารทั่วไป	17	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
154	P230-000154	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้ถูพื้น ขนาด 10 นิ้ว	20	อัน	130.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
155	P230-000155	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้ปัดขนไก่ แบบด้ามพลาสติก	17	อัน	160.00	กลุ่มงานบริหารทั่วไป	17	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
156	P230-000156	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้ยางรีดน้ำ ขนาด 18 นิ้ว	3	อัน	295.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
157	P230-000157	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ยางวง แบบเส้นเล็ก ขนาด 500 กรัม	52	ห่อ	110.00	กลุ่มงานบริหารทั่วไป	52	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
158	P230-000158	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ยางวง แบบเส้นใหญ่ ขนาด 500 กรัม	55	ห่อ	110.00	กลุ่มงานบริหารทั่วไป	55	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
159	P230-000159	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 10 สีดำ	8	คู่	145.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
160	P230-000160	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 10.5 สีดำ	0	คู่	145.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
161	P230-000161	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 11 สีดำ	13	คู่	145.00	กลุ่มงานบริหารทั่วไป	13	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
162	P230-000162	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 11.5 สีดำ	0	คู่	145.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
163	P230-000163	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 12 สีดำ	0	คู่	145.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
164	P230-000164	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า ชนิดฟองน้ำ เบอร์ 10	27	คู่	45.00	กลุ่มงานบริหารทั่วไป	27	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
165	P230-000165	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า ชนิดฟองน้ำ เบอร์ 11	31	คู่	45.00	กลุ่มงานบริหารทั่วไป	31	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
166	P230-000166	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า ชนิดฟองน้ำ เบอร์ 11.5	0	คู่	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
167	P230-000167	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า ชนิดยางพารา เบอร์ L	0	คู่	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
168	P230-000168	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า ชนิดยางพารา เบอร์ LL	14	คู่	95.00	กลุ่มงานบริหารทั่วไป	14	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
169	P230-000169	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า ชนิดยางพารา เบอร์ M	0	คู่	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
170	P230-000170	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า ชนิดยางพารา เบอร์ XL	5	คู่	95.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
171	P230-000171	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ลังถึง เบอร์ 36	2	ชุด	800.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
385	P230-000385	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟ แบบตุ๊กตา	0	ตัว	85.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
172	P230-000172	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	สก็อตไบร์ท แบบแผ่นเล็ก ขนาด 4.5*6 นิ้ว	1244	แผ่น	30.00	กลุ่มงานบริหารทั่วไป	1244	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
173	P230-000173	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	สก็อตไบร์ท แบบแผ่นใหญ่ ขนาด 6*9 นิ้ว	286	แผ่น	30.00	กลุ่มงานบริหารทั่วไป	286	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
174	P230-000174	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	สบู่ แบบก้อนเล็ก ขนาด 10 กรัม	100	ก้อน	2.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
175	P230-000175	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	สบู่ แบบก้อนใหญ่	8	ก้อน	15.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
176	P230-000176	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	สเปรย์ ชนิดสูตรน้ำ สำหรับฉีดมด ยุง ขนาด 300 มล.	4	กระป๋อง	65.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
177	P230-000177	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	สเปรย์ ชนิดสูตรน้ำ สำหรับฉีดมด ยุง ขนาด 600 มล.	57	กระป๋อง	130.00	กลุ่มงานบริหารทั่วไป	57	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
178	P230-000178	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	สเปรย์ สำหรับปรับอากาศ ขนาด 300 มล.	180	กระป๋อง	58.00	กลุ่มงานบริหารทั่วไป	180	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
179	P230-000179	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หม้อทะนน	60	ใบ	15.00	กลุ่มงานบริหารทั่วไป	60	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
180	P230-000180	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หม้อหุงข้าว แบบใช้ไฟฟ้า ขนาด 3.8 ลิตร	2	ใบ	2100.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
181	P230-000181	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หม้อหุงข้าว แบบใช้ไฟฟ้า ขนาด 5 ลิตร	2	ใบ	2500.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
182	P230-000182	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หอมแดง	0	กิโลกรัม	80.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
183	P230-000183	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เหยือกน้ำ ชนิดพลาสติก ขนาด 1,000 ซีซี	56	ใบ	100.00	กลุ่มงานบริหารทั่วไป	56	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
184	P230-000184	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เอี๊ยม ชนิดพลาสติก แบบใช้แล้วทิ้ง ขนาดบรรจุ 100 ชิ้น/ถุง	66	ถุง	350.00	กลุ่มงานบริหารทั่วไป	66	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
185	P230-000185	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระจกเงา สำหรับแต่งตัว	0	บาน	1990.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
186	P230-000186	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เครื่องพ่นยา แบบใช้แบตเตอรี่ ขนาด 18 ลิตร	0	อัน	990.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
187	P230-000187	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าปูที่นอน (ยกเลิก)	0	ชุด	400.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
188	P230-000188	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เต๊นท์ผ้าใบ แบบโค้งพร้อมโครงเหล็ก ขนาด 4*8 เมตร	1	หลัง	24500.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
189	P230-000189	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก สำหรับขยะติดเชื้อ แบบฝาเรียบ ขนาด 240 ลิตร สีแดง	0	ใบ	2390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
190	P230-000190	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก สำหรับขยะติดเชื้อ แบบช่องทิ้ง ขนาด 240 ลิตร สีแดง	0	ใบ	2190.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
191	P230-000191	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 10 ลิตร	10	ใบ	295.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
192	P230-000192	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังน้ำ ชนิดพลาสติก แบบมีฝา สีดำ	0	ใบ	395.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
193	P230-000193	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	100	แพค	39.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
194	P230-000194	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ที่นอน ชนิดฟองน้ำ	0	หลัง	1400.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
195	P230-000195	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	แทงค์น้ำ ขนาด 1000 ลิตร	1	ชุด	4690.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
196	P230-000196	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าปูที่นอน	0	ชุด	299.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
197	P230-000197	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าห่ม ขนาด 150 x 200 ซม.	2	ผืน	178.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
198	P230-000198	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 10	0	คู่	145.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
199	P230-000199	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 10.5	0	คู่	145.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
200	P230-000200	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 11	0	คู่	145.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
201	P230-000201	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบบู๊ท เบอร์ 11.5	0	คู่	145.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
202	P230-000202	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ราวตากผ้า ชนิดอลูมีเนียม	0	อัน	950.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
203	P230-000203	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หมอน ขนาด 19 x 29 นิ้ว	5	ใบ	190.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
204	P230-000204	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุง ชนิดพลาสติก ขนาด 24*42 นิ้ว สีใส	0	แพค	240.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
205	P230-000205	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	พรมเช็ดเท้า ขนาด 40*60 ซม.	0	ผืน	370.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
206	P230-000206	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	พรมเช็ดเท้า แบบดักฝุ่น ขนาด 50*120 ซม.	3	ผืน	590.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
207	P230-000207	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง ขนาด 1/2 นิ้ว	5	อัน	250.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
208	P230-000208	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายฉีดชำระ	1	อัน	150.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
209	P230-000209	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่องลอย ชนิดพลาสติก ขนาด 2*4 นิ้ว	20	อัน	19.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
210	P230-000210	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กลอนประตู ชนิดสแตนเลส ขนาด 4 นิ้ว	10	ชุด	11.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
211	P230-000211	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ ขนาด 1/2 นิ้ว	8	อัน	550.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
212	P230-000212	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง แบบเดี่ยว ขนาด 1/2 นิ้ว	0	อัน	680.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
213	P230-000213	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	0	อัน	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
214	P230-000214	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง แบบบอล ขนาด 1/2 นิ้ว	0	อัน	85.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
215	P230-000215	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับฝักบัว ขนาด 1/2 นิ้ว	0	อัน	160.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
216	P230-000216	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก ก๊อกน้ำ ชนิดทองเหลือง ขนาด 1/2 นิ้ว	0	อัน	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
217	P230-000217	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง แบบสนาม ขนาด 1/2 นิ้ว	16	อัน	165.00	กลุ่มงานบริหารทั่วไป	16	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
218	P230-000218	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่าง แบบเดี่ยว ขนาด 1/2 นิ้ว	0	อัน	650.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
219	P230-000219	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างจาน ขนาด 1/2 นิ้ว	0	อัน	290.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
220	P230-000220	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างหน้า ขนาด 1/2 นิ้ว	20	อัน	450.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
221	P230-000221	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 250 กรัม	3	กระปุก	176.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
222	P230-000222	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กุญแจ ชนิดทองเหลือง แบบคล้อง คอยาว	0	อัน	66.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
223	P230-000223	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กุญแจ ชนิดทองเหลือง แบบคล้อง ขนาด 38 มม.	8	ชุด	105.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
224	P230-000224	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1/2 นิ้ว	0	อัน	9.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
225	P230-000225	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 3/4 นิ้ว	0	อัน	13.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
226	P230-000226	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1 นิ้ว	2	อัน	19.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
227	P230-000227	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 90 องศา เกลียวนอก ขนาด 1 นิ้ว	2	อัน	14.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
228	P230-000228	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 90 องศา เกลียวใน ขนาด 1/2 นิ้ว	6	อัน	13.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
229	P230-000229	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิดทองเหลือง แบบ 90 องศา	0	อัน	38.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
230	P230-000230	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC ขนาด 1 นิ้ว	6	อัน	15.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
231	P230-000231	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC ขนาด 1/2 นิ้ว	40	อัน	7.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
232	P230-000232	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1 นิ้ว	0	อัน	9.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
233	P230-000233	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อลด ชนิด PVC ขนาด 3/4 * 1/2 นิ้ว	10	อัน	9.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
234	P230-000234	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขายึด ชนิดเหล็ก สำหรับแขวนโทรทัศน์	0	ชุด	990.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
235	P230-000235	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ไขควง แบบกลม	0	อัน	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
236	P230-000236	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะไบ ชนิดแบน	0	อัน	140.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
237	P230-000237	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะปู ขนาด 1 นิ้ว	4	ขีด	10.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
238	P230-000238	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เต้ารับ ชนิด 3 ขา แบบคู่	0	ชุด	85.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
239	P230-000239	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	โถส้วม แบบนั่งยอง ไม่มีฐาน	0	ชด	730.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
240	P230-000240	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ทราย ชนิดหยาบ	0	คิว	308.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
241	P230-000241	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1 นิ้ว	1	เส้น	100.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
242	P230-000242	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุดน้ำทิ้ง แบบกระปุก	1	ชุด	199.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
243	P230-000243	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อย่น ชนิดพลาสติก แบบ 2 in 1	1	อัน	135.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
244	P230-000244	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุดกดชักโครก	2	อัน	132.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
245	P230-000245	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เทป สำหรับพันเกลียว	20	ม้วน	17.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
246	P230-000246	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น๊อต สำหรับหัวฝา ขนาด 1/2*1 นิ้ว	35	ตัว	2.50	กลุ่มงานบริหารทั่วไป	35	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
247	P230-000247	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น้ำกลั่นแบตเตอรี่ สำหรับแบตเตอรี่ ขนาด 1 ลิตร	24	ขวด	25.00	กลุ่มงานบริหารทั่วไป	24	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
248	P230-000248	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บอลวาล์ว ชนิด PVC แบบสวม ขนาด 1/2 นิ้ว	6	อัน	135.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
249	P230-000249	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บอลวาล์ว ชนิด PVC ขนาด 1/2 นิ้ว	6	อัน	44.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
250	P230-000250	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บอลวาล์ว ชนิด PVC ขนาด 1 นิ้ว	0	อัน	72.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
251	P230-000251	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บอลวาล์ว ชนิดเหล็ก แบบเกลียวนอก	2	อัน	105.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
252	P230-000252	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บานพับ แบบผีเสื้อ	0	อัน	22.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
253	P230-000253	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ปูน	0	ถุง	130.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
254	P230-000254	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฝักบัวอาบน้ำ	2	อัน	160.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
255	P230-000255	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฝาครอบ ชนิด PVC ขนาด 1/2 นิ้ว	4	อัน	7.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
256	P230-000256	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	พุก ชนิดเหล็ก	0	ตัว	8.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
257	P230-000257	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	มือกดน้ำ แบบด้านข้าง	0	อัน	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
258	P230-000258	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ไม้อัด หนา 10 มม.	0	แผ่น	517.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
259	P230-000259	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ราวพาดผ้า	0	อัน	85.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
260	P230-000260	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลวด สำหรับผูกเหล็ก	0	ม้วน	132.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
261	P230-000261	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลูกบิด สำหรับห้องน้ำ	20	อัน	220.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
262	P230-000262	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลูกลอย ชนิดงอ สำหรับแท๊งค์น้ำ	1	ชุด	320.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
263	P230-000263	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น แบบสกรูคู่ ขนาด 2 นิ้ว	2	ชุด	55.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
264	P230-000264	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	วาล์ว แบบครบชุด	5	ชุด	359.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
265	P230-000265	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	วาล์ว สำหรับฝักบัว	5	ชุด	399.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
266	P230-000266	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สะดืออ่าง	8	อัน	45.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
267	P230-000267	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายฉีดชำระ แบบชุดเล็ก	15	อัน	150.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
268	P230-000268	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายน้ำดี ขนาด 18 นิ้ว	2	เส้น	60.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
269	P230-000269	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายน้ำดี ขนาด 20 นิ้ว	15	เส้น	60.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
270	P230-000270	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายน้ำดี ขนาด 24 นิ้ว	15	เส้น	65.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
271	P230-000271	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายน้ำดี ขนาด 40 นิ้ว	0	เส้น	90.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
272	P230-000272	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายฝักบัว	2	อัน	95.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
273	P230-000273	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายยู ชนิดเหล็ก	0	อัน	17.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
274	P230-000274	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายยู ชนิดสแตนเลส	10	ชุด	28.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
275	P230-000275	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สีสเปรย์ สีขาว	3	กระป๋อง	65.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
276	P230-000276	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หิน	0	คิว	572.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
277	P230-000277	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หินคลุก	5	คิว	517.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
278	P230-000278	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เหล็ก แบบกล่อง ขนาด 1.5 นิ้ว	0	เส้น	418.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
279	P230-000279	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เหล็ก แบบฉาก ขนาด 2 นิ้ว	0	เส้น	572.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
280	P230-000280	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เหล็ก แบบตัวซี ขนาด 3 นิ้ว	0	เส้น	561.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
360	P230-000360	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	Adaptor ขนาด 12V.	0	ตัว	265.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
281	P230-000281	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เหล็ก แบบเพลท ขนาด 4*4 นิ้ว	6	แผ่น	50.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
282	P230-000282	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สต๊อปวาล์ว	5	อัน	160.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
283	P230-000283	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น แบบเกลียว	2	ชุด	550.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
284	P230-000284	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฝาอุด ชนิด PVC ขนาด 1 นิ้ว	0	อัน	7.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
285	P230-000285	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น้ำมันเอนกประสงค์	0	กระป๋อง	115.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
286	P230-000286	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายน้ำดี ขนาด 22 นิ้ว	2	อัน	72.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
287	P230-000287	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	โถส้วม แบบชักโครก	0	ชุด	2390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
288	P230-000288	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กุญแจ ชนิดทองเหลือง แบบคล้อง ขนาด 45 มม.	2	ชุด	1045.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
289	P230-000289	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เทอมินอล สำหรับต่อสาย	0	อัน	4.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
290	P230-000290	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ทรอนิค	1	อัน	160.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
291	P230-000291	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลูกเสียบยาง	3	อัน	10.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
292	P230-000292	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	รางหลอดไฟ ชนิดทรอนิค สำหรับหลอด LED	0	ชุด	155.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
293	P230-000293	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น๊อต แบบธุบ ขนาด 7 นิ้ว	0	ตัว	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
294	P230-000294	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น๊อต แบบธุบ ขนาด 8 นิ้ว	0	ตัว	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
295	P230-000295	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แหวน ชนิดเหล็ก แบบเหลี่ยม ขนาด 5/8 นิ้ว	0	อัน	5.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
296	P230-000296	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 2 นิ้ว	0	อัน	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
297	P230-000297	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก ข้องอ ชนิด PVC หนา แบบ 90 องศา ขนาด 2 นิ้ว	0	อัน	88.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
298	P230-000298	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิด PVC แบบลด ขนาด 2 นิ้ว	0	อัน	55.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
299	P230-000299	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 2 นิ้ว	4	ท่อ	230.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
300	P230-000300	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยูเนียน ชนิด PVC ขนาด 2 นิ้ว	2	อัน	165.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
301	P230-000301	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะแกรงน้ำมัน ขนาด 2 นิ้ว	0	อัน	12.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
302	P230-000302	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอกสว่าน ขนาด 1/8	0	ดอก	28.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
303	P230-000303	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ปูนขาว	0	ถุง	70.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
304	P230-000304	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ขนาด 1/2 นิ้ว	5	อัน	550.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
305	P230-000305	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น้ำยา สำหรับกำจัดมด ปลวก	0	กระป๋อง	132.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
306	P230-000306	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก สายน้ำดี	0	เส้น	55.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
307	P230-000307	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ต่อล่าง ขนาด 1/2 นิ้ว	0	อัน	638.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
308	P230-000308	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	นิปเปิ้ล ชนิดทองเหลือง ขนาด 1/2 นิ้ว	4	อัน	22.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
309	P230-000309	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก มินิวาล์ว ชนิดทองเหลือง แบบ 3 ทาง ขนาด 1/2 นิ้ว	0	อัน	154.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
310	P230-000310	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิ๊บ ชนิดพลาสติก แบบก้ามปู ขนาด 1/2 นิ้ว	20	อัน	6.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
311	P230-000311	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เกลียวใน ขนาด 1/2 นิ้ว	0	อัน	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
312	P230-000312	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 45 องศา ขนาด 1/2 นิ้ว	2	อัน	10.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
313	P230-000313	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อิฐแดง ขนาดเล็ก	0	ก้อน	1.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
314	P230-000314	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก ฝาบิด	0	อัน	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
315	P230-000315	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 6 นิ้ว	0	ท่อ	2050.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
316	P230-000316	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เกรียง สำหรับก่ออิฐ	0	ด้าม	72.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
317	P230-000317	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก สีน้ำ	0	แกลลอน	236.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
318	P230-000318	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น้ำยาเคมีไข้ว	0	กระปุก	105.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
319	P230-000319	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระดาษทราย ชนิดละเอียด เบอร์ xx	0	แผ่น	11.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
320	P230-000320	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	มินิวาล์ว ชนิดทองเหลือง แบบ 3 ทาง ขนาด 1/2 นิ้ว	4	อัน	138.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
321	P230-000321	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซิลิโคน สีขาว	7	หลอด	132.00	กลุ่มงานบริหารทั่วไป	7	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
322	P230-000322	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิดร้อน	4	หลอด	28.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
323	P230-000323	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิด PVC ขนาด 1/2 นิ้ว	0	อัน	8.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
324	P230-000324	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 50 กรัม	1	กระป๋อง	45.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
325	P230-000325	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ใบเลื่อย	6	ใบ	45.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
326	P230-000326	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1/2 นิ้ว	20	ท่อ	55.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
327	P230-000327	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อะคริลิค สำหรับกันซึม	10	อ้น	2848.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
328	P230-000328	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตาข่าย ชนิดไฟเบอร์	0	อัน	460.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
329	P230-000329	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก ชุดน้ำทิ้ง	0	อัน	898.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
330	P230-000330	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	แก๊ส ชนิดถัง สำหรับงานแพทย์แผนไทย ขนาด 15 กก.	1	ถัง	380.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
331	P230-000331	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	แก๊ส ชนิดถัง สำหรับงานจ่ายกลาง ขนาด 48 กก.	0	ถัง	1500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
332	P230-000332	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	แก๊ส ชนิดถัง สำหรับงานโรงครัว ขนาด 48 กก.	0	ถัง	1500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
333	P230-000333	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	น้ำมันเชื้อเพลิง ชนิดเบนซินแก๊สโซฮอลล์ 91	0	ลิตร	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
334	P230-000334	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	น้ำมันเชื้อเพลิง ชนิดเบนซินแก๊สโซฮอลล์ 95	1956	ลิตร	40.00	กลุ่มงานบริหารทั่วไป	1956	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
335	P230-000335	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	น้ำมันเครื่อง ชนิด 2T	2	กระป๋อง	150.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
336	P230-000336	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	น้ำมันเครื่อง ชนิด 4T	2	กระป๋อง	185.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
337	P230-000337	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	น้ำมันเครื่อง ชนิด 6T	2	กระป๋อง	960.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
338	P230-000338	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	น้ำมันเชื้อเพลิง ชนิดดีเซล	13894	ลิตร	40.00	กลุ่มงานบริหารทั่วไป	13894	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
339	P230-000339	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	น้ำมันเชื้อเพลิง ชนิดเบนซิน 95	0	ลิตร	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
340	P230-000340	วัสดุใช้ไป	วัสดุเชื้อเพลิง	วัสดุเชื้อเพลิง	น้ำมันเบรค ขนาด 500 มล.	1	กระป๋อง	295.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
341	P230-000341	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	น้ำดื่ม ชนิดบรรจุแกลลอน ขนาด 18 ลิตร	12000	ถัง	10.00	กลุ่มงานบริหารทั่วไป	12000	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
342	P230-000342	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	น้ำดื่ม ชนิดบรรจุขวด ขนาด 600 ซีซี	470	โหล	39.00	กลุ่มงานบริหารทั่วไป	470	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
343	P230-000343	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค	น้ำหวาน สำหรับผู้ป่วยเบาหวาน สีแดง	56	ขวด	65.00	กลุ่มงานบริหารทั่วไป	56	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
344	P230-000344	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ไฟฉาย แบบหลอด LED	15	กระบอก	160.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
345	P230-000345	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิด Recharge ขนาด AA	0	ก้อน	600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
346	P230-000346	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิด Recharge ขนาด AAA	0	ก้อน	600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
347	P230-000347	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิดอัลคาไลน์ ขนาด 9V	30	ก้อน	130.00	กลุ่มงานบริหารทั่วไป	30	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
348	P230-000348	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิดธรรมดา ขนาด AA	128	ก้อน	10.00	กลุ่มงานบริหารทั่วไป	128	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
349	P230-000349	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิดอัลคาไลน์ ขนาด AA	721	ก้อน	20.00	กลุ่มงานบริหารทั่วไป	721	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
350	P230-000350	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิดธรรมดา ขนาด AAA	102	ก้อน	10.00	กลุ่มงานบริหารทั่วไป	102	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
351	P230-000351	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิดอัลคาไลน์ ขนาด AAA	362	ก้อน	20.00	กลุ่มงานบริหารทั่วไป	362	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
352	P230-000352	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิดอัลคาไลน์ ขนาดกลาง C	100	ก้อน	50.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
353	P230-000353	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิดธรรมดา ขนาดใหญ่ D	54	ก้อน	16.00	กลุ่มงานบริหารทั่วไป	54	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
354	P230-000354	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แบตเตอรี่ แบบแห้ง สำหรับเครื่องสำรองไฟ	5	อัน	1200.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
355	P230-000355	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 3 เมตร	52	อัน	410.00	กลุ่มงานบริหารทั่วไป	52	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
356	P230-000356	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟพ่วง แบบ 5 ช่อง 5 สวิตซ์ ยาว 3 เมตร	20	อัน	410.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
357	P230-000357	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 18 W	12	หลอด	100.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
358	P230-000358	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 22 W	260	หลอด	155.00	กลุ่มงานบริหารทั่วไป	260	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
359	P230-000359	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 9 W	50	หลอด	110.00	กลุ่มงานบริหารทั่วไป	50	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
361	P230-000361	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่องเบรคเกอร์	20	อัน	15.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
362	P230-000362	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่องลอย ชนิดพลาสติก ขนาด 2*4 นิ้ว	0	อัน	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
363	P230-000363	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่องลอย ชนิดพลาสติก ขนาด 4*4 นิ้ว	20	อัน	18.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
364	P230-000364	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้ามปู สำหรับล๊อคท่อ ขนาด 1/2 นิ้ว สีเหลือง	120	อัน	5.00	กลุ่มงานบริหารทั่วไป	120	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
365	P230-000365	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กิ๊บ ชนิดพลาสติก สำหรับสายทีวี 3C	10	กล่อง	20.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
366	P230-000366	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ข้อต่อ ชนิดพลาสติก แบบโค้ง ขนาด 1/2 นิ้ว สีเหลือง	0	อัน	8.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
367	P230-000367	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ข้อต่อ ชนิดพลาสติก แบบโค้ง ขนาด 1/2 นิ้ว สีเหลือง	0	อัน	6.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
368	P230-000368	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ขาหลอดนีออน แบบครึ่งท่อน	20	คู่	25.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
369	P230-000369	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ขาหลอดนีออน แบบล๊อค	20	คู่	25.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
370	P230-000370	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 10 นิ้ว	2	ถุง	110.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
371	P230-000371	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 15 นิ้ว	2	ถุง	160.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
372	P230-000372	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 6 นิ้ว	2	ถุง	50.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
373	P230-000373	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 8 นิ้ว	2	ถุง	60.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
374	P230-000374	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตะกั่วบัตกรี แบบปากกา ยาว 3 เมตร	2	อัน	50.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
375	P230-000375	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตะปู สำหรับยิงฝ้า ขนาด 1*6 สีดำ	5	กล่อง	110.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
376	P230-000376	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	HDMI splitter ขนาด 8 port	0	ตัว	1050.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
377	P230-000377	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตู้พลาสติก แบบกันน้ำ	2	ตู้	125.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
378	P230-000378	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ท่อสายไฟ ชนิด PVC แบบท่อตรง ขนาด 1/2 นิ้ว สีเหลือง	4	เส้น	55.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
379	P230-000379	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เทป สำหรับฟันสายไฟ	20	ม้วน	35.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
380	P230-000380	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แท่งกราวด์	10	อัน	95.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
381	P230-000381	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	บัลลาส ชนิดหลอดฮาโลเจน ขนาด 12V 35 Watt	0	อัน	745.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
382	P230-000382	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เบรคเกอร์ ขนาด 30A	5	อัน	145.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
383	P230-000383	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แบตเตอรี่ แบบแห้ง ขนาด 12V 7.5A	5	ลูก	600.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3335	P230-001326	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ตะไบสามเหลี่ยม	3	อัน	350.00	กลุ่มงานเทคนิคการแพทย์	3	2569	1	2026-03-07 15:41:06.532165	2026-03-07 15:41:06.532165	0002
386	P230-000386	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แป้นพลาสติก ขนาด 4*6 นิ้ว	10	อัน	20.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
387	P230-000387	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	พุก ชนิดพลาสติก เบอร์ 7	12	กล่อง	20.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
388	P230-000388	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ไมล์สาย	0	ตัว	490.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
389	P230-000389	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟพ่วง ยาว 5 เมตร	1	อัน	240.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
390	P230-000390	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	รางสายไฟ แบบมินิเท้งกิ้ง	0	เส้น	75.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
391	P230-000391	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	รางสายไฟ ยาว 2 เมตร	10	เส้น	90.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
392	P230-000392	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูกเสียบ แบบตัวผู้	0	ตัว	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
393	P230-000393	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูกเสียบ แบบตัวเมีย	0	อัน	14.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
394	P230-000394	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ไฟสนาม แบบสปอตไลท์ ขนาด 50W	2	ชุด	460.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
395	P230-000395	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สวิทช์ไฟ แบบแสงแดด	0	ตัว	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
396	P230-000396	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สวิทช์ไฟ แบบฝัง	24	อัน	25.00	กลุ่มงานบริหารทั่วไป	24	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
397	P230-000397	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สาย HDMI ขนาด 3 เมตร	0	เส้น	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
398	P230-000398	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สาย HDMI ขนาด 5 เมตร	0	เส้น	155.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
399	P230-000399	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายดิน ขนาด 1*2.5 สีขาว	2	ม้วน	950.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
400	P230-000400	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายดิน ขนาด 1*2.5 สีดำ	0	ม้วน	950.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
401	P230-000401	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายดิน	0	ม้วน	950.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
402	P230-000402	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หน้ากากปลั๊กไฟ แบบ 2 ช่อง	10	อัน	20.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
403	P230-000403	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หน้ากากปลั๊กไฟ แบบ 3 ช่อง	20	อัน	15.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
404	P230-000404	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หน้ากากปลั๊กไฟ แบบ 6 ช่อง	40	อัน	33.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
405	P230-000405	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ยกเลิก หลอดไฟ ชนิด LED ขนาด 18 W	0	หลอด	72.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
406	P230-000406	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ยกเลิก หลอดไฟ ชนิด LED ขนาด 22 W	0	หลอด	155.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
407	P230-000407	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิดนีออน ขนาด 36 W	6	อัน	95.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
408	P230-000408	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟ แบบฝัง	2	อัน	115.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
409	P230-000409	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หน้ากากปลั๊กไฟ แบบ 1 ช่อง	8	อัน	15.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
410	P230-000410	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ไฟฉาย แบบหลอดไส้	0	อัน	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
411	P230-000411	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟ แบบตัวผู้	0	อัน	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
412	P230-000412	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูกเซอร์กิต	0	อัน	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
413	P230-000413	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายลำโพง แบบใส ขนาดใหญ่	0	เมตร	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
414	P230-000414	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายไมค์ แบบพร้อมแจ๊ค	0	ชุด	155.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
415	P230-000415	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กริ่ง แบบไร้สาย มีรีโมท	0	ชุด	260.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
416	P230-000416	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เพรสเซอร์สวิทช์	0	ชุด	1050.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
417	P230-000417	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แบตเตอรี่ สำหรับเครื่อง DRX	0	ก้อน	39100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
418	P230-000418	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายโทรศัพท์	0	ม้วน	620.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
419	P230-000419	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ยกเลิก ปลั๊กไฟ แบบฝัง	0	อัน	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
420	P230-000420	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สาย VCT	0	ม้วน	1590.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
421	P230-000421	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กบเหลาดินสอ แบบหมุน	4	อัน	265.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
422	P230-000422	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กรรไกร ขนาด 8 นิ้ว	79	อัน	85.00	กลุ่มงานบริหารทั่วไป	79	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
423	P230-000423	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีส้ม	2	ห่อ	110.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
424	P230-000424	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีขาว	6	ห่อ	110.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
425	P230-000425	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเขียว	32	ห่อ	110.00	กลุ่มงานบริหารทั่วไป	32	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
426	P230-000426	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีชมพู	26	ห่อ	110.00	กลุ่มงานบริหารทั่วไป	26	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
427	P230-000427	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีฟ้า	25	ห่อ	110.00	กลุ่มงานบริหารทั่วไป	25	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
428	P230-000428	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 120 แกรม ขนาด A4 สีเหลือง	29	ห่อ	110.00	กลุ่มงานบริหารทั่วไป	29	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
429	P230-000429	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว	5	ม้วน	35.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
430	P230-000430	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1 นิ้ว 24x25 หลา	754	ม้วน	45.00	กลุ่มงานบริหารทั่วไป	754	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
431	P230-000431	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1.5 นิ้ว 36x20 หลา	713	ม้วน	25.00	กลุ่มงานบริหารทั่วไป	713	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
432	P230-000432	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1/2 นิ้ว 36x20 หลา	13	ม้วน	20.00	กลุ่มงานบริหารทั่วไป	13	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
433	P230-000433	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 2 นิ้ว 20 หลา	86	ม้วน	30.00	กลุ่มงานบริหารทั่วไป	86	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
434	P230-000434	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษไข สำหรับเครื่องโรเนียว	10	ม้วน	1200.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
435	P230-000435	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษคาร์บอน สีน้ำเงิน	14	กล่อง	150.00	กลุ่มงานบริหารทั่วไป	14	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
436	P230-000436	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษต่อเนื่อง แบบ 1 ชั้น ขนาด 15x11 นิ้ว	0	กล่อง	2000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
437	P230-000437	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษถ่ายเอกสาร ขนาด A4	1223	รีม	120.00	กลุ่มงานบริหารทั่วไป	1223	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
438	P230-000438	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษเทอร์มอล สำหรับเครื่อง EDC ขนาด 57*40 มม.	240	ม้วน	90.00	กลุ่มงานบริหารทั่วไป	240	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
439	P230-000439	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษเทอร์มอล สำหรับเครื่องวัดความดัน ขนาด 57*55 มม.	214	ม้วน	50.00	กลุ่มงานบริหารทั่วไป	214	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
488	P230-000488	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ธงชาติ ขนาด 120*180 ซม.	4	ผืน	180.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
440	P230-000440	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษเทอร์มอล ขนาด 80*80 มม.	700	ม้วน	60.00	กลุ่มงานบริหารทั่วไป	700	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
441	P230-000441	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษบรุ๊ฟ ขนาด 31x43 นิ้ว สีขาว	0	แผ่น	4.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
442	P230-000442	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษบวกเลข สำหรับเครื่องคิดเลข ขนาด 2 1/4 นิ้ว	0	ม้วน	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
443	P230-000443	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเขียว	1	ห่อ	95.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
444	P230-000444	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีชมพู	0	ห่อ	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
445	P230-000445	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีฟ้า	0	ห่อ	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
446	P230-000446	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษแบงค์ หนา 55 แกรม สำหรับรองปก ขนาด A4 สีเหลือง	1	ห่อ	95.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
447	P230-000447	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษโรเนียว หนา 70 แกรม ขนาด A4 สีขาว	317	รีม	120.00	กลุ่มงานบริหารทั่วไป	317	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
448	P230-000448	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษโรเนียว หนา 80 แกรม ขนาด F4 สีขาว	0	รีม	130.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
449	P230-000449	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปกาว ชนิด 2 หน้า แบบบาง ขนาด 3/4 นิ้ว	73	ม้วน	30.00	กลุ่มงานบริหารทั่วไป	73	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
450	P230-000450	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กาว แบบติดแน่น (ตราช้าง) ขนาด 3 กรัม	15	อัน	25.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
451	P230-000451	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กาว ชนิดแท่ง	33	แท่ง	65.00	กลุ่มงานบริหารทั่วไป	33	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
452	P230-000452	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กาว ชนิดน้ำ แบบป้าย ขนาด 560 ซีซี	0	ขวด	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
453	P230-000453	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กาว ชนิดน้ำ แบบหัวโฟม ขนาด 50 ซีซี	2	แท่ง	20.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
454	P230-000454	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กาว ชนิดลาเท็กซ์ ขนาด 32 ออนซ์	2	ขวด	60.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
455	P230-000455	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	คลิปหนีบกระดาษ ขนาด #108 สีดำ	46	กล่อง	55.00	กลุ่มงานบริหารทั่วไป	46	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
456	P230-000456	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	คลิปหนีบกระดาษ ขนาด #109 สีดำ	76	กล่อง	40.00	กลุ่มงานบริหารทั่วไป	76	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
457	P230-000457	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	คลิปหนีบกระดาษ ขนาด #110 สีดำ	288	กล่อง	25.00	กลุ่มงานบริหารทั่วไป	288	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
458	P230-000458	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	คลิปหนีบกระดาษ ขนาด #111 สีดำ	21	กล่อง	20.00	กลุ่มงานบริหารทั่วไป	21	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
459	P230-000459	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	คลิปหนีบกระดาษ ขนาด #112 สีดำ	31	กล่อง	20.00	กลุ่มงานบริหารทั่วไป	31	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3348	P230-000596	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หนังสือ มาตรฐานโรงพยาบาลและบริการสุขภาพ ฉบับที่ 5	50	เล่ม	500.00	กลุ่มการพยาบาล	0	2569	1	2026-03-10 23:23:05.926782	2026-03-10 23:23:05.926782	0011
460	P230-000460	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เครื่องคิดเลข ชนิด 2 ระบบ แบบ 12 หลัก	13	อัน	850.00	กลุ่มงานบริหารทั่วไป	13	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
461	P230-000461	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เครื่องเจาะกระดาษ แบบเจาะ 25 แผ่น	9	อัน	200.00	กลุ่มงานบริหารทั่วไป	9	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
462	P230-000462	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เครื่องเย็บกระดาษ ขนาด NO.10	39	อัน	85.00	กลุ่มงานบริหารทั่วไป	39	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
463	P230-000463	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เครื่องเย็บกระดาษ ขนาด NO.35	17	อัน	360.00	กลุ่มงานบริหารทั่วไป	17	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
464	P230-000464	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เชือก ชนิดพลาสติก ขนาดใหญ่ ยาว 180 ม. สี่ขาว-แดง	2	ม้วน	65.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
465	P230-000465	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซองขาว แบบมีครุฑ ขนาด #9/125	740	ซอง	1.00	กลุ่มงานบริหารทั่วไป	740	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
466	P230-000466	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด A4	350	ซอง	4.00	กลุ่มงานบริหารทั่วไป	350	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
467	P230-000467	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซองน้ำตาล แบบมีครุฑ ไม่ขยายข้าง หนาพิเศษ ขนาด A4	2380	ซอง	4.00	กลุ่มงานบริหารทั่วไป	2380	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
468	P230-000468	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซองน้ำตาล แบบมีครุฑ ขยายข้าง หนาพิเศษ ขนาด F4	320	ซอง	4.00	กลุ่มงานบริหารทั่วไป	320	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
469	P230-000469	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซองใส่บัตร ชนิดพลาสติก สำหรับบัตรคนต่างด้าว ขนาด 5.6x8.8 ซม.	1650	ซอง	4.00	กลุ่มงานบริหารทั่วไป	1650	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
470	P230-000470	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตรายาง สำหรั้บปั๊มวันที่ภาษาไทย	15	อัน	60.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
471	P230-000471	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตรายาง สำหรั้บปั๊มวันที่เลขไทย	6	อัน	60.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
472	P230-000472	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชั้นอเนกประสงค์ ชนิดลวดเคลือบพลาสติก แบบ 3 ชั้น	4	อัน	900.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
473	P230-000473	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ทะเบียนคุมเงินงบประมาณ	0	เล่ม	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
474	P230-000474	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปกาว ชนิด OPP ขนาด 2 นิ้ว	96	อัน	25.00	กลุ่มงานบริหารทั่วไป	96	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
475	P230-000475	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก เทปกาว ชนิด 2 หน้า	6	ม้วน	125.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
476	P230-000476	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปใส แบบแกนเล็ก ขนาด 1 นิ้ว 36 หลา	49	ม้วน	30.00	กลุ่มงานบริหารทั่วไป	49	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
477	P230-000477	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปใส แบบแกนใหญ่ ขนาด 1 นิ้ว 36 หลา	145	ม้วน	30.00	กลุ่มงานบริหารทั่วไป	145	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
478	P230-000478	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปใส แบบแกนใหญ่ ขนาด 2 นิ้ว 45 หลา	72	ม้วน	45.00	กลุ่มงานบริหารทั่วไป	72	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
479	P230-000479	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปใส แบบแกนเล็ก ขนาด 3/4 นิ้ว 36 หลา	94	ม้วน	30.00	กลุ่มงานบริหารทั่วไป	94	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
480	P230-000480	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่นตัดกระดาษ ชนิดมือโยก แบบฐานไม้ ขนาด 13x15"	4	อัน	1350.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
481	P230-000481	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่นประทับ แบบฝาพลาสติก สีดำ #2	0	อัน	35.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
482	P230-000482	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่นประทับ แบบฝาพลาสติก สีแดง #2	5	อัน	35.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
483	P230-000483	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่นประทับ แบบฝาพลาสติก สีน้ำเงิน #2	5	อัน	35.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
484	P230-000484	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่นประทับ แบบฝาโลหะ สีดำ #2	24	อัน	35.00	กลุ่มงานบริหารทั่วไป	24	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
485	P230-000485	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่นประทับ แบบฝาโลหะ สีแดง #2	1	อัน	35.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
486	P230-000486	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แท่นประทับ แบบฝาโลหะ สีน้ำเงิน #2	1	อัน	35.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
487	P230-000487	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ธง วปร. รัชกาลที่ 10 ขนาด 60*90 ซม.	8	ผืน	40.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
489	P230-000489	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ธงชาติ ขนาด 60*90 ซม.	4	ผืน	40.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
490	P230-000490	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ธง สท. พระราชินี ขนาด 60*90 ซม.	0	ผืน	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
491	P230-000491	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ธงฟ้า สก. พระพันปีหลวง ขนาด 60*90 ซม.	0	ผืน	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
492	P230-000492	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	น้ำยา สำหรับลบคำผิด ขนาด 7 มล.	116	แท่ง	20.00	กลุ่มงานบริหารทั่วไป	116	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
493	P230-000493	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรคิว สำหรับคิวรถ	0	เล่ม	7.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
494	P230-000494	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรนัดผู้ป่วย ขนาด 5*3.5 นิ้ว	0	ใบ	1.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
495	P230-000495	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก บัตรนัดรักษา	0	กล่อง	1400.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
496	P230-000496	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรประจำตัวผู้รับบริการ	0	แผ่น	1.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
497	P230-000497	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรคิว สำหรับผู้รับบริการกุมารเวชกรรม สีชมพู	0	เล่ม	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
498	P230-000498	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรคิว สำหรับผู้รับบริการทันตกรรม สีฟ้า	0	เล่ม	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
499	P230-000499	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรคิว สำหรับผู้รับบริการทั่วไป สีเขียว	0	เล่ม	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
500	P230-000500	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรคิว สำหรับผู้รับบริการโรคเรื้อรัง สีขาว	12	เล่ม	40.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
501	P230-000501	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรคิว สำหรับผู้รับบริการส่งเสริมสุขภาพ สีเหลือง	0	เล่ม	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
502	P230-000502	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	บัตรคิว สำหรับแพทย์นัด สีส้ม	12	เล่ม	40.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
503	P230-000503	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แบบฟอร์ม ชนิดเคมี 2 ชั้น Doctor's Order แบบต่อเนื่อง เคมี 2 ชั้น 9*11" (1,000 ชุด/กล่อง) ขนาด 9*11 นิ้ว	1	กล่อง	2200.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
504	P230-000504	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แบบฟอร์ม แจ้งรายการค่ารักษาพยาบาล	0	กล่อง	1500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
505	P230-000505	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แบบฟอร์ม ปรอท แบบพิมพ์ 2 สี หนา 70 แกรม ขนาด A4	0	ห่อ	400.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
506	P230-000506	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบมีดคัตเตอร์ ขนาดเล็ก	5	กล่อง	20.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
507	P230-000507	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ใบมีดคัตเตอร์ ขนาดใหญ่	22	กล่อง	25.00	กลุ่มงานบริหารทั่วไป	22	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
508	P230-000508	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แบบฟอร์ม ใบรับรองแพทย์ กรณีป่วย	0	เล่ม	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
509	P230-000509	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แบบฟอร์ม ใบรับรองแพทย์ กรณีสมัครงาน	0	เล่ม	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
510	P230-000510	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แบบฟอร์ม ใบเสร็จรับเงิน (1,000 ชุด/กล่อง)	20	กล่อง	1600.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
511	P230-000511	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา Paint Marker ขนาด 0.8-1.2 mm สีขาว	4	ด้าม	85.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
512	P230-000512	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา Paint Marker ขนาด 0.8-1.2 mm สีน้ำเงิน	5	ด้าม	85.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
513	P230-000513	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา Paint Marker ขนาด 4.0-8.5 mm สีน้ำเงิน	2	ด้าม	85.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
514	P230-000514	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา เขียนแผ่น CD สีน้ำเงิน	14	ด้าม	40.00	กลุ่มงานบริหารทั่วไป	14	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
515	P230-000515	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา เคมี แบบ 2 หัว สีดำ	66	ด้าม	15.00	กลุ่มงานบริหารทั่วไป	66	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
516	P230-000516	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา เคมี แบบ 2 หัว สีแดง	122	ด้าม	15.00	กลุ่มงานบริหารทั่วไป	122	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
517	P230-000517	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา เคมี แบบ 2 หัว สีน้ำเงิน	331	ด้าม	15.00	กลุ่มงานบริหารทั่วไป	331	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
518	P230-000518	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา ไวท์บอร์ด ตราม้า สีแดง	50	ด้าม	25.00	กลุ่มงานบริหารทั่วไป	50	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
519	P230-000519	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา ไวท์บอร์ด PILOT สีแดง	113	ด้าม	25.00	กลุ่มงานบริหารทั่วไป	113	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
520	P230-000520	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา ไวท์บอร์ด PILOT สีน้ำเงิน	115	ด้าม	25.00	กลุ่มงานบริหารทั่วไป	115	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
521	P230-000521	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา ไวท์บอร์ด ตราม้า สีน้ำเงิน	112	ด้าม	25.00	กลุ่มงานบริหารทั่วไป	112	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
522	P230-000522	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ปากกา ไวท์บอร์ด PILOT สีดำ	5	ด้าม	25.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
523	P230-000523	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A5	0	แพค	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
524	P230-000524	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายลาเบล ชนิดสติ๊กเกอร์ ขนาด A7	74	แพค	45.00	กลุ่มงานบริหารทั่วไป	74	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
525	P230-000525	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แปรง สำหรับลบกระดานไวท์บอร์ด	4	อัน	35.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
526	P230-000526	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีดำ	3	ตลับ	7800.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
527	P230-000527	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีแดง	1	ตลับ	16000.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
528	P230-000528	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีน้ำเงิน	1	ตลับ	16000.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
529	P230-000529	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผงหมึก สำหรับเครื่องถ่ายเอกสาร สีเหลือง	1	ตลับ	16000.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
530	P230-000530	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	พลาสติกเคลือบบัตร ขนาด 6*95 ซม.	16	กล่อง	60.00	กลุ่มงานบริหารทั่วไป	16	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
531	P230-000531	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	พลาสติกเคลือบบัตร หนา 125 ไมครอน ขนาด A4	12	กล่อง	350.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
533	P230-000533	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม แบบแขวน สีเขียว	0	แฟ้ม	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
534	P230-000534	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม แบบแขวน สีฟ้า	0	แฟ้ม	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
535	P230-000535	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม แบบแขวน สีส้ม	0	แฟ้ม	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
536	P230-000536	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม แบบแขวน สีเหลือง	0	แฟ้ม	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
537	P230-000537	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม เวชระเบียน	4000	แฟ้ม	10.00	กลุ่มงานบริหารทั่วไป	4000	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
538	P230-000538	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม แบบสันแข็ง ขนาด 1 นิ้ว	17	แฟ้ม	55.00	กลุ่มงานบริหารทั่วไป	17	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
539	P230-000539	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม แบบสันแข็ง ขนาด 2 นิ้ว	18	แฟ้ม	60.00	กลุ่มงานบริหารทั่วไป	18	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
540	P230-000540	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม แบบสันแข็ง ขนาด 3 นิ้ว	30	แฟ้ม	75.00	กลุ่มงานบริหารทั่วไป	30	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
541	P230-000541	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม เสนอเซ็นต์ ขนาด F4	32	แฟ้ม	140.00	กลุ่มงานบริหารทั่วไป	32	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
542	P230-000542	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม ชนิดปกพลาสติก แบบหนีบ	0	แฟ้ม	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
543	P230-000543	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	มีดคัตเตอร์ ชนิดด้ามสแตนเลส ขนาดเล็ก	8	อัน	35.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
544	P230-000544	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	มีดคัตเตอร์ ชนิดด้ามพลาสติก ขนาดใหญ่	7	อัน	25.00	กลุ่มงานบริหารทั่วไป	7	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
545	P230-000545	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	มีดคัตเตอร์ ชนิดด้ามสแตนเลส ขนาดใหญ่	65	อัน	45.00	กลุ่มงานบริหารทั่วไป	65	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
546	P230-000546	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลวดเย็บกระดาษ เบอร์ 10	482	กล่อง	10.00	กลุ่มงานบริหารทั่วไป	482	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
547	P230-000547	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลวดเย็บกระดาษ เบอร์ 3	7	กล่อง	15.00	กลุ่มงานบริหารทั่วไป	7	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
548	P230-000548	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลวดเย็บกระดาษ เบอร์ 35	250	กล่อง	10.00	กลุ่มงานบริหารทั่วไป	250	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
549	P230-000549	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลวดเย็บกระดาษ เบอร์ 8	0	กล่อง	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
550	P230-000550	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลวดเสียบกระดาษ ขนาดเล็ก เบอร์ 1	305	กล่อง	15.00	กลุ่มงานบริหารทั่วไป	305	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
551	P230-000551	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลวดเสียบกระดาษ ขนาดใหญ่ เบอร์ 0	286	กล่อง	15.00	กลุ่มงานบริหารทั่วไป	286	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
552	P230-000552	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลิ้นแฟ้ม ชนิดพลาสติก	2	กล่อง	95.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
553	P230-000553	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลิ้นแฟ้ม ชนิดเหล็ก	0	กล่อง	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
554	P230-000554	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีเขียว	0	ห่อ	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
555	P230-000555	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีฟ้า	0	ห่อ	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
556	P230-000556	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีม่วง	0	ห่อ	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
557	P230-000557	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีส้ม	0	ห่อ	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
558	P230-000558	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีเหลือง	0	ห่อ	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
559	P230-000559	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สี่ขาวมัน	2	ห่อ	45.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
560	P230-000560	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ แบบต่อเนื่อง สำหรับพิมพ์ชื่อผู้ป่วย ขนาด 6*2.5 ซม.	0	ม้วน	200.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
561	P230-000561	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีฟ้า	0	แผ่น	5.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3377	P230-000001	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ขวาน ชนิดเหล็ก แบบด้ามไม้	2	อัน	200.00	กลุ่มการพยาบาล	2	2569	1	2026-03-14 08:02:35.282831	2026-03-14 08:02:35.282831	0011
562	P230-000562	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ สำหรับติดชาร์ทผู้ป่วย สีเหลือง	0	แผ่น	5.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
563	P230-000563	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ ชนิดพลาสติก แบบใส ขนาดใหญ่ สีใสหลังเหลือง	6	แผ่น	20.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
564	P230-000564	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด สำหรับ Refer คลอด (บส.08/1)	0	เล่ม	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
565	P230-000565	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด สำหรับ Refer ทั่วไป (บส.08)	1	เล่ม	50.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
566	P230-000566	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด ชนิดปกสี คู่มือเบิกจ่ายในราชการ 301	0	เล่ม	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
567	P230-000567	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด สำหรับตรวจสุขภาพ	1000	เล่ม	5.00	กลุ่มงานบริหารทั่วไป	1000	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
568	P230-000568	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือรับ	5	เล่ม	65.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
569	P230-000569	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด ชนิดหุ้มปก สำหรับทะเบียนหนังสือส่ง	5	เล่ม	65.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
570	P230-000570	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด ชนิดหุ้มปก สำหรับบันทึกมุมมัน	10	เล่ม	250.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
571	P230-000571	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด สำหรับใบรับรองความพิการ	0	เล่ม	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
572	P230-000572	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 1 หุ้มปก ขนาด 24x35 ซม.	13	เล่ม	50.00	กลุ่มงานบริหารทั่วไป	13	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
573	P230-000573	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด ชนิดหุ้มปก แบบปกน้ำเงิน เบอร์ 2 หุ้มปก ขนาด 19x31 ซม.	34	เล่ม	40.00	กลุ่มงานบริหารทั่วไป	34	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
574	P230-000574	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด สำหรับประจำตัวผู้ป่วยนอก สีน้ำเงิน	1320	เล่ม	18.00	กลุ่มงานบริหารทั่วไป	1320	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
576	P230-000576	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หมึกพิมพ์ สำหรับเครื่องโรเนียว สีดำ	30	กล่อง	500.00	กลุ่มงานบริหารทั่วไป	30	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
577	P230-000577	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หมึกเติม สำหรับแท่นประทับตรายาง สีน้ำเงิน	11	ขวด	15.00	กลุ่มงานบริหารทั่วไป	11	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
578	P230-000578	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หมึกเติม สำหรับแท่นประทับตรายาง สีดำ	5	ขวด	15.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
579	P230-000579	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หมึกเติม สำหรับแท่นประทับตรายาง สีแดง	16	ขวด	15.00	กลุ่มงานบริหารทั่วไป	16	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
580	P230-000580	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก แบบหูหิ้ว	2	ใบ	159.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
581	P230-000581	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 4 ชั้น	1	กล่อง	280.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
582	P230-000582	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 3 ช่อง สำหรับใส่เอกสาร	0	กล่อง	230.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
583	P230-000583	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เก้าอี้ ชนิดโครงเหล็ก สำหรับจัดเลี้ยง	0	ตัว	859.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
584	P230-000584	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	0	ตัว	259.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
585	P230-000585	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชั้นอเนกประสงค์ ชนิดพลาสติก แบบ 4 ลิ้นชัก	6	อัน	290.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
586	P230-000586	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ซองใส่บัตร ชนิดพลาสติก	0	ห่อ	214.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
587	P230-000587	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 4 ลิ้นชัก	6	ตู้	740.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
588	P230-000588	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	โต๊ะเอนกประสงค์ แบบพับได้	1	ตัว	1850.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
589	P230-000589	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	โต๊ะเอนกประสงค์	0	ตัว	659.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
590	P230-000590	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ที่แขวนตรายาง แบบ 2 ชั้น	2	ชุด	98.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
591	P230-000591	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ธงชาติ ขนาด 100*150 ซม.	0	ผืน	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
592	P230-000592	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ธง จภ. สมเด็จเจ้าฟ้าจุฬาภรณ์ฯ ขนาด 60*90 ซม.	0	ผืน	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
593	P230-000593	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	พลาสติกใส หนา 0.20 มม. ขนาดกว้าง 2 เมตร ยาว 15 เมตร	0	ม้วน	2000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
594	P230-000594	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	พลาสติกใส สำหรับหุ้มปก หนา 0.09 มม. ขนาดกว้าง 48 นิ้ว ยาว 75 หลา	0	ม้วน	1500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
595	P230-000595	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลวดเย็บกระดาษ เบอร์12/10	20	กล่อง	92.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
596	P230-000596	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หนังสือ มาตรฐานโรงพยาบาลและบริการสุขภาพ ฉบับที่ 5	0	เล่ม	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
597	P230-000597	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีล้อ พร้อมฝาปิด ขนาด 100 ลิตร	1	กล่อง	429.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
598	P230-000598	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	0	ตัว	199.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
599	P230-000599	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก พลาสติกใส หนา 0.20 มม. ขนาดกว้าง 2 เมตร ยาว 15 เมตร	0	ม้วน	2000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
600	P230-000600	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชั้นวางรองเท้า แบบ 3 ชั้น	1	ชั้น	990.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
601	P230-000601	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด แบบพื้นด้าน ขนาด A4 สีขาว	0	pack	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
602	P230-000602	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เสาธง ชนิดไม้ ขนาดสูง 2 เมตร	0	ชุด	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
603	P230-000603	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก ขนาด 33*26*23 ซม. สีใส	0	กล่อง	190.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
604	P230-000604	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก ขนาด 11.5*21*10.5 ซม. สีใส	0	กล่อง	59.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
605	P230-000605	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ธง สธ. สมเด็จพระเทพฯ ขนาด 60*90 ซม.	0	ผืน	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
606	P230-000606	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	กางเกงเด็กกลาง ผ้าย้อม ขนาดเด็ก 4-7 ปี สีเขียวโศก	0	ผืน	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
607	P230-000607	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	กางเกงเด็กเล็ก ผ้าย้อม ขนาดเด็ก 1-3 ปี สีเขียวโศก	0	ผืน	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
608	P230-000608	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	กางเกงผู้ใหญ่ ผ้าย้อม แบบมีเชือกผูก ขนาด XXL สีเขียวโศก	250	ตัว	235.00	กลุ่มงานบริหารทั่วไป	250	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
609	P230-000609	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	กางเกงผู้ใหญ่ ผ้าย้อม แบบมีเชือกผูก ขนาด XL สีเม็ดมะปราง	0	ตัว	235.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
610	P230-000610	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดกระโปรงแพทย์ ผ้าโทเร แบบหญิง ขนาด L สีเขียวแก่	0	ตัว	450.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
611	P230-000611	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด M สีเขียวโศก	0	ตัว	550.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
612	P230-000612	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด S , M , L , XL สีชมพู	0	ตัว	550.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
613	P230-000613	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดเสื้อกางเกง ผ้าวินเซนต์ แบบเสื้อคอกลม และกางเกงเอวยางยืด ขนาด S , L , XL , XXL สีฟ้า	0	ตัว	550.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
614	P230-000614	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ถุงเท้าคลอด ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 18"x36"	0	ผืน	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
615	P230-000615	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ปลอกหมอน ผ้าโทเร แบบพับใน 8 นิ้ว ขนาด 18"x25" สีเขียวโศก	0	ผืน	80.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
616	P230-000616	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ปลอกหมอน ผ้าโทเร แบบพับใน 8 นิ้ว ขนาด 18"x25" สีชมพู	40	ผืน	80.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
617	P230-000617	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ปลอกหมอน ผ้าฟอกขาว แบบพับใน 8 นิ้ว ขนาด 18"x25"	0	ผืน	80.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
618	P230-000618	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าขวางเตียง ผ้าฟอกขาว ขนาด 44"x72"	0	ตัว	290.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
619	P230-000619	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าเช็ดตัวผืนใหญ่ ผ้าทอเดี่ยว 11 ปอนด์ แบบ 11 ปอนด์ ขนาด 30"x60" สีชมพู	40	ผืน	250.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
620	P230-000620	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าเช็ดตัวลดไข้ ผ้าทอเดี่ยว 0.95 ปอนด์ ขนาด 12"x12" สีชมพู	80	ผืน	20.00	กลุ่มงานบริหารทั่วไป	80	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
621	P230-000621	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าเช็ดมือผ่าตัด ผ้าทอเดี่ยว 2.8 ปอนด์ ขนาด 15"x30" สีขาว	0	ผืน	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
622	P230-000622	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ยกเลิก ผ้าดิบ	0	พับ	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
623	P230-000623	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าถุง ผ้าย้อม ขนาด 88"x40" สีเขียวโศก	100	ผืน	345.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
624	P230-000624	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าถุง ผ้าวินเซนต์ ขนาด 88"x40" สีแดงเลือดนก	0	ผืน	345.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
625	P230-000625	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปิดตา แบบสามเหลี่ยม	0	ผืน	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
626	P230-000626	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูเตียง ผ้าโทเรหนา แบบปล่อยชาย ขนาด 100"x3 หลา สีเขียวโศก	0	ผืน	450.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
627	P230-000627	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูเตียง ผ้าฟอกขาว แบบปล่อยชาย ขนาด 60"x3 หลา	150	ผืน	210.00	กลุ่มงานบริหารทั่วไป	150	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
628	P230-000628	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูเตียง ผ้าโทเร แบบรัดมุม ขนาด 27"x74" สีชมพู	40	ผืน	175.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
629	P230-000629	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูรถนอน ผ้าย้อม แบบปล่อยชาย ขนาด 45"x3 หลา สีเขียวโศก	0	ผืน	170.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
630	P230-000630	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูรถนอน ผ้าย้อม แบบปล่อยชาย ขนาด 45"x3 หลา สีเขียวแก่	100	ผืน	180.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
631	P230-000631	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าผูกยึดผู้ป่วย ผ้าฟอกขาว ขนาดยาว 36"	80	เส้น	130.00	กลุ่มงานบริหารทั่วไป	80	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
632	P230-000632	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้ายาง ชนิด 2 หน้า ขนาด 36"	0	ม้วน	920.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
633	P230-000633	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้ายาง ชนิดหนังเทียม ขนาด 36"x54"	0	ตัว	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
634	P230-000634	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้ายาง ชนิด 2 หน้า แบบเล็ก ขนาด 24"x24" สีชมพู-เขียว	0	ตัว	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
635	P230-000635	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสวม Mayo ผ้าย้อม แบบ 2 ชั้น ขนาด 18" x72 " สีเขียวแก่	0	ผืน	245.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
774	P230-000774	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกรู ชนิดไดวอ ขนาด 1 นิ้ว	0	กล่อง	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
636	P230-000636	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 1 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x4") ขนาด 30"x30" สีม่วง	150	ผืน	80.00	กลุ่มงานบริหารทั่วไป	150	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
637	P230-000637	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ยกเลิก ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x4") ขนาด 45"x60" สีเขียวแก่มุมสีขาว	0	ผืน	210.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
638	P230-000638	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว แบบเจาะรูกลาง (4"x4") ขนาด 25"x25" มุมสีเขียวแก่	300	ผืน	99.00	กลุ่มงานบริหารทั่วไป	300	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
639	P230-000639	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว แบบเจาะรูกลาง (4"x4") ขนาด 44"x44" มุมสีเขียวแก่	0	ผืน	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
640	P230-000640	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม แบบเจาะรูกลาง (4"x6") ขนาด 60"x100" สีเขียวแก	80	ผืน	420.00	กลุ่มงานบริหารทั่วไป	80	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
641	P230-000641	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้ารองถาดสี่เหลี่ยม ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 25"x25"	300	ผืน	99.00	กลุ่มงานบริหารทั่วไป	300	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
642	P230-000642	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้ารองเทเครื่องมือ ผ้าฟอกขาว แบบสี่เหลียม 2 ชั้น ขนาด 44"x44"	80	ผืน	180.00	กลุ่มงานบริหารทั่วไป	80	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
707	P230-000707	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แมกเนติก	0	ตัว	730.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
643	P230-000643	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลี่ยม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 16"x16" (Supply) ขนาด 16"x16" มุมสีม่วง	0	ผืน	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
644	P230-000644	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลี่ยม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 25"x25" (Supply) ขนาด 25"x25" มุมสีม่วง	300	ผืน	99.00	กลุ่มงานบริหารทั่วไป	300	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
645	P230-000645	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 44"x44" (OR) ขนาด 44"x44" มุมสีม่วง	250	ผืน	180.00	กลุ่มงานบริหารทั่วไป	250	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
646	P230-000646	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีเขียวแก่ 25"x25" (OR) ขนาด 25"x25" สีเขียวแก่	100	ผืน	110.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
647	P230-000647	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลียม 2 ชั้น ผ้าย้อมสีเขียวแก่ 45"x60" (OR) ขนาด 45"x60" สีเขียวแก่	100	ผืน	395.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
648	P230-000648	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีเขียวแก่มุมสีม่วง 44"x44" (OR) ขนาด 44"x44" สีเขียวแก่มุมสีม่วง	300	ผืน	310.00	กลุ่มงานบริหารทั่วไป	300	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
649	P230-000649	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ยกเลิก ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลี่ยม 2 ชั้น ผ้าย้อมสีม่วง 16"x16" (Dent ยกเลิกใช้แล้ว) ขนาด 16"x16" สีม่วง	0	ผืน	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
650	P230-000650	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าย้อม ผ้าสี่เหลียม 2 ชั้น ผ้าย้อมสีม่วง 25"x25" (Dent) ขนาด 25"x25" สีม่วง	0	ผืน	90.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
651	P230-000651	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าห่ม ผ้าทอเดี่ยว ขนาด 60"x80" สีชมพู	40	ผืน	600.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
652	P230-000652	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าห่อ Spore test ผ้าฟอกขาว แบบ 2 ชั้น ขนาด 16"x26"	0	ผืน	80.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
653	P230-000653	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อกาวน์นอก ผ้าโทเรหนา แบบแขนสั้น ขนาด L , XL , XXL สีขา	0	ตัว	550.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
654	P230-000654	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อกาวน์ผ่าตัด ผ้าย้อม ขนาด XXL สีเขียวแก่	0	ตัว	450.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
655	P230-000655	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อกาวน์ผ่าตัด ผ้าย้อม ขนาด XXL สีชมพู	0	ตัว	450.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
656	P230-000656	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อคลุมกิโมโน ผ้าโทเรหนา แบบแขนสั้น ขนาด XL สีเขียวแก่	0	ตัว	380.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
657	P230-000657	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อคลุมกิโมโน ผ้าโทเรหนา แบบแขนสั้น ขนาด L , XL สีชมพู	0	ตัว	380.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
658	P230-000658	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ยกเลิก เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ๊ำแขน กระเป๋าในขวา ขนาด L สีม่วง	0	ตัว	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
659	P230-000659	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด L , XL สีขาว	80	ตัว	500.00	กลุ่มงานบริหารทั่วไป	80	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
660	P230-000660	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด L , XL สีน้ำเงิน	0	ตัว	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
661	P230-000661	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อคลุม ผ้าวินเซนต์ แบบแขนยาวจ้ำแขน ขนาด M , L , XL สีฟ้า	0	ตัว	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
662	P230-000662	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อเด็กกลาง ผ้าย้อม ขนาดเด็ก 4-7 ปี สีเขียวโศก	0	ผืน	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
776	P230-000776	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยงยิปซั่ม	0	ถุง	33.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
663	P230-000663	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อเด็กเล็ก ผ้าย้อม ขนาดเด็ก 1-3 ปี สีเขียวโศก	0	ผืน	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
664	P230-000664	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อผู้ใหญ่ ผ้าย้อม แบบป้ายข้าง ขนาด XXL สีเขียวโศก	0	ตัว	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
665	P230-000665	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อผู้ใหญ่ ผ้าวินเซนต์ แบบป้ายข้าง ขนาด XXL สีแดงเลือดนก	0	ตัว	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
666	P230-000666	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อผู้ใหญ่ ผ้าวินเซนต์ แบบป้ายข้าง ขนาด XL สีเม็ดมะปราง	0	ตัว	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
667	P230-000667	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อกางเกงแพทย์ ผ้าโทเร แบบคอวี และกางเกง ขนาด L สีเขียวแก่	0	ตัว	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
668	P230-000668	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อกางเกงแพทย์ ผ้าวินเซนต์ แบบคอวี และกางเกง ขนาด XXL สีเม็ดมะปราง	0	ตัว	580.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
669	P230-000669	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อกางเกงแพทย์ ผ้าวินเซนต์ แบบคอวี และกางเกง ขนาด XXXL สีเม็ดมะปราง	0	ตัว	650.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
670	P230-000670	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เอี๊ยม ผ้ายางหนังเทียม	0	ผืน	195.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
744	P230-000744	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เข็มหมุด	0	กล่่อง	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3336	P230-001325	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	เสียม ชนิดเหล็ก แบบด้ามไม้ ขนาด 2 นิ้ว	2	อัน	350.00	งานผู้ป่วยนอก	2	2569	1	2026-03-07 15:41:06.532328	2026-03-07 15:41:06.532328	0013
671	P230-000671	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด L คละสี	0	ชุด	800.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
672	P230-000672	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด M คละสี	0	ชุด	800.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
673	P230-000673	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด XL คละสี	0	ชุด	800.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
674	P230-000674	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดสครับ ผ้าโทเรหนา แบบเสื้อคอวี และกางเกง ขนาด XXL คละสี	0	ชุด	800.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
700	P230-000700	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	อิฐ ประสาน ขนาด 10*10*30 ซม.	20	ก้อน	20.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
701	P230-000701	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ดิน ชนิดถุงสำเร็จ สำหรับปลูกต้นไม้	10	ถุง	10.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
708	P230-000708	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	โอเวอร์โหลด	0	ตัว	970.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
709	P230-000709	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น แบบแป้นหมุน ขนาด 5 นิ้ว	2	อัน	265.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
710	P230-000710	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น แบบแป้นตาย ขนาด 5 นิ้ว	2	อัน	245.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
711	P230-000711	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet BT-D60 BK สีดำ	6	กล่อง	350.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
712	P230-000712	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet BT5000C สีฟ้า	6	กล่อง	290.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
713	P230-000713	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet BT5000M สีชมพู	6	กล่อง	290.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
714	P230-000714	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet BT5000Y สีเหลือง	6	กล่อง	290.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
715	P230-000715	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	หน้าจาน ชนิดเหล็ก แบบเกลียว ขนาด 2 นิ้ว	0	ตัว	600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
716	P230-000716	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น๊อต สำหรับหน้าแปลน	0	ชุด	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
717	P230-000717	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยางประเก็น สำหรับหน้าแปลน	0	อัน	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
718	P230-000718	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุดกรองอากาศ (Silencer valve) สำหรับเครื่องเติมอากาศ	0	ชุด	19474.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
775	P230-000775	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สีน้ำ สีขาว	0	กระป๋อง	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
719	P230-000719	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุดน้ำทิ้ง สำหรับอ่างล้างเครื่องมือ	2	ชุด	358.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
720	P230-000720	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลูกบิด ชนิดหัวกลม	7	อัน	99.00	กลุ่มงานบริหารทั่วไป	7	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
721	P230-000721	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิด PVC แบบลด ขนาด 1 นิ้ว	5	อัน	18.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
722	P230-000722	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิ๊บ ชนิดพลาสติก สำหรับจับท่อ ขนาด 1 นิ้ว	0	อัน	4.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
723	P230-000723	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ประตูน้ำ ชนิด PVC ขนาด 1 นิ้ว	0	อัน	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
724	P230-000724	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ประตูน้ำ ชนิดทองเหลือง ขนาด 1 นิ้ว	0	อัน	295.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
725	P230-000725	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกรู ชนิดเกลียวปล่อย ขนาด 1 นิ้ว	4	กล่อง	78.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
726	P230-000726	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แปรงสลัดน้ำ	0	ด้าม	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
727	P230-000727	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฟองน้ำ สำหรับฉาบปูน	0	แผ่น	8.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
728	P230-000728	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่นขัดเอนกประสงค์	0	ม้วน	550.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
729	P230-000729	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ไม้อัด หนา 15 มม.	0	แผ่น	715.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
730	P230-000730	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คาบูเรเตอร์ สำหรับเครื่องตัดแต่งกิ่งไม้	0	ชุด	520.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
731	P230-000731	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	12	แพค	42.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
732	P230-000732	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แฟ้ม แบบแขวน สีม่วง	0	แฟ้ม	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
733	P230-000733	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขายึด ชนิดเหล็ก สำหรับอ่าง	2	ชุด	40.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
734	P230-000734	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เทอร์โมฟิวส์ แบบ 188 องศา ขนาด 10A	0	อัน	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
736	P230-000736	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 1 W สีแดง	1	หลอด	35.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
737	P230-000737	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟ แบบกราวเดี่ยว	2	อัน	45.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
738	P230-000738	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ยกเลิก กิ๊บ ชนิดพลาสติก	0	อัน	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3351	P230-000343	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค	น้ำหวาน สำหรับผู้ป่วยเบาหวาน สีแดง	10	ขวด	65.00	กลุ่มงานเทคนิคการแพทย์	10	2569	1	2026-03-11 00:38:52.950089	2026-03-11 00:38:52.950089	0002
739	P230-000739	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กิ๊บ ชนิดพลาสติก สำหรับสายโทรศัพท์ 2C	0	กล่อง	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
740	P230-000740	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ใบพัดลม ขนาด 16 นิ้ว	0	อัน	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
741	P230-000741	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กอุด แบบอุด ขนาด 1/2 นิ้ว	5	อัน	6.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
742	P230-000742	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	พวงมาลา ชนิดดอกไม้ประดิษฐ์	0	พวง	2000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
743	P230-000743	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	น้ำยาฆ่าหญ้า แบบแกลลอน	2	แกลลอน	900.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
745	P230-000745	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปุ่มกด สำหรับประตูรีโมทอัตโนมัติ	0	ชุด	3500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
746	P230-000746	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด สำหรับลงนามถวายพระพร	0	เล่ม	600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
747	P230-000747	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	พระบรมฉายาลักษณ์ สมเด็จเจ้าฟ้าพัชรกิติยาภาฯ	0	บาน	1200.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
748	P230-000748	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ไขควง สำหรับเช็คกระแสไฟฟ้า	0	อัน	135.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
749	P230-000749	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ขาหลอดนีออน แบบสปริงหัวโต	10	คู่	35.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
750	P230-000750	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูกเสียบ ชนิดขาแบน แบบยาง	0	อัน	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
751	P230-000751	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	รางสายไฟ แบบ TT202	0	เส้น	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
752	P230-000752	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กิ๊บ ชนิดพลาสติก ขนาด 2*1.5 นิ้ว	4	อัน	20.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
753	P230-000753	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ขั้วแป้นเกลียว ชนิดกระเบื้อง	0	อัน	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
754	P230-000754	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายไฟ แบบแข็ง ขนาด 2*1.5 ยาว 20 เมตร	6	ม้วน	280.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
755	P230-000755	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	รางสายไฟ แบบ TD204	0	เส้น	90.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
756	P230-000756	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ฝาครอบ ชนิด PVC	0	ตัว	6.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
757	P230-000757	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่องโทรศัพท์	0	อัน	35.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
758	P230-000758	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คอนเรนเซอร์ ขนาด 40/450V	0	ตัว	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
759	P230-000759	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คอนเรนเซอร์ ขนาด 30/300V	0	ตัว	480.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
760	P230-000760	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ขาหนีบ สำหรับสปอตไลท์	0	อัน	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
761	P230-000761	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 25 W	0	อัน	135.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
762	P230-000762	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูกเสียบ ชนิดขาแบน แบบ 3 ตา	0	อัน	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
763	P230-000763	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายไฟ แบบอ่อน ขนาด 2*1	0	เมตร	12.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
764	P230-000764	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ฟิวส์ ชนิดสั้น แบบหลอด ขนาด 10A	0	ถุง	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
765	P230-000765	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 90 องศา ขนาด 1.5 นิ้ว	0	ตัว	35.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
766	P230-000766	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิด PVC แบบลด ขนาด 1.5 นิ้ว	0	ตัว	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
767	P230-000767	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิด PVC แบบ 45 องศา ขนาด 1 นิ้ว	0	ตัว	18.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
768	P230-000768	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 100 กรัม	3	อัน	70.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
769	P230-000769	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บอลวาล์ว ชนิด PVC แบบสวม ขนาด 3/4 นิ้ว	2	อัน	47.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
770	P230-000770	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อลด ชนิด PVC ขนาด 3*1 นิ้ว	2	อัน	132.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
771	P230-000771	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1 นิ้ว	0	อัน	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
772	P230-000772	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขายึด ชนิดเหล็ก สำหรับซิงค์	0	อัน	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
773	P230-000773	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	วอลฟุตตี้ ขนาด 1 กก.	2	กระป๋อง	121.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3379	P230-000102	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิด PVC	5	คู่	45.00	งานผู้ป่วยในชาย	5	2569	1	2026-03-14 08:03:04.888915	2026-03-14 08:03:04.888915	0016
777	P230-000777	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลูกบิด สำหรับประตูทั่วไป	7	ชุด	242.00	กลุ่มงานบริหารทั่วไป	7	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
778	P230-000778	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลวดเชื่อม สำหรับสแตนเลส	20	เส้น	15.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
779	P230-000779	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 10 ลิตร	2	ใบ	295.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
780	P230-000780	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เหล็ก ชนิดหนา 2.3 มม. แบบแผ่น ขนาด 4*8 ฟุต	0	แผ่น	1505.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
781	P230-000781	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กลอนประตู ชนิดอลูมีเนียม	2	ชุด	550.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
782	P230-000782	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	สายยาง ขนาด 5/4 นิ้ว	5	เส้น	2160.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
783	P230-000783	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ถุงมือ ชนิดผ้า	30	คู่	98.00	กลุ่มงานบริหารทั่วไป	30	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
784	P230-000784	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Flash drive แบบ USB ขนาด 16 Gb	1	อัน	180.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
785	P230-000785	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	พุก ชนิดพลาสติก เบอร์ 6	0	กล่อง	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
786	P230-000786	วัสดุใช้ไป	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง	ยางในจักรยาน ขนาด 26*1.95	0	เส้น	130.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
787	P230-000787	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ยกเลิก ตู้พลาสติก แบบกันน้ำ	0	ตู้	135.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
789	P230-000789	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ข้อต่อ ชนิดพลาสติก สำหรับเข้ากล่อง ขนาด 1/2 นิ้ว	40	ตัว	24.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
790	P230-000790	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิ๊บ ชนิดทองเหลือง สำหรับรัดสายท่อแก็ส	2	อัน	15.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
791	P230-000791	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิด PVC แบบลด ขนาด 1*1/2 นิ้ว	0	อัน	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
792	P230-000792	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก ข้อต่อตรง ชนิด PVC ขนาด 1 นิ้ว	0	อัน	12.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
793	P230-000793	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อลด ชนิด PVC ขนาด 1*1/2 นิ้ว	5	อัน	6.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
794	P230-000794	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อสายยาง ชนิด PVC ขนาด 1/2 นิ้ว	5	อัน	12.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
795	P230-000795	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง แบบเหยียบ วาล์วกลม ขนาด 1/2 นิ้ว	0	อัน	600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
796	P230-000796	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฝักบัวอาบน้ำ แบบพร้อมวาล์วฝักบัว	0	ชุด	297.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
797	P230-000797	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	มือจับ	20	อัน	24.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
798	P230-000798	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 2 หุน	0	อัน	90.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
799	P230-000799	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 1/2 นิ้ว	40	อัน	9.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
801	P230-000801	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลวดเชื่อม สำหรับเหล็ก ขนาด 2 มม.	1	ห่อ	200.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
802	P230-000802	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ใบตัด สำหรับตัดเหล็ก ขนาด 4 นิ้ว	1	อัน	22.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
803	P230-000803	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอกสว่าน ขนาด 9/64	0	ดอก	33.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
804	P230-000804	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ปืนยิงซิลิโคน	0	ด้าม	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
805	P230-000805	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิด 2 ตัน	0	ชุด	132.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
806	P230-000806	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ไม้อัด หนา 8 มม.	0	แผ่น	420.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
807	P230-000807	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ท่อสายไฟ ชนิด PVC แบบท่ออ่อน ขนาด 1/2 นิ้ว สีขาว	15	เมตร	17.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
808	P230-000808	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กล่องพักสาย ชนิดพลาสติก แบบเหลี่ยม ขนาด 2/4 นิ้ว สีขาว	10	อัน	20.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
809	P230-000809	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิดเหล็ก ขนาด 1/2 นิ้ว	0	อัน	33.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
810	P230-000810	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก ก๊อกน้ำ ชนิดทองเหลือง แบบดัช ขนาด 1/2 นิ้ว	0	อัน	440.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
811	P230-000811	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บานพับ ขนาด 3*1/2 นิ้ว	0	อัน	17.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
812	P230-000812	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบต่อหลัง ขนาด 1/2 นิ้ว	0	ชุด	275.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
813	P230-000813	วัสดุใช้ไป	วัสดุยานพาหนะและขนส่ง	วัสดุยานพาหนะและขนส่ง	เบาะหุ้มจักรยาน	0	อัน	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
814	P230-000814	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แท่งกราวด์ ขนาด 1.8 ม.	0	อัน	160.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
815	P230-000815	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับแก้วชน แบบเกลียวใน ขนาด 1/2 นิ้ว	20	อัน	95.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
816	P230-000816	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุดสายชำระ แบบรวมหัวฉีดและสายชำระ	6	ชุด	390.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
817	P230-000817	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 3/4 นิ้ว	0	เส้น	48.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
818	P230-000818	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อลด ชนิด PVC ขนาด 3/4 * 1/2 นิ้ว	10	อัน	10.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
819	P230-000819	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 1/4 หุน 4 นิ้ว	0	อัน	55.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
820	P230-000820	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	มินิวาล์ว ชนิดทองเหลือง แบบเกลียวนอก ขนาด 1/2 นิ้ว	2	อัน	155.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
821	P230-000821	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษชาร์ท หนา 450 แกรม สีเทา-ขาว	0	แผ่น	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
822	P230-000822	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 7 W	150	หลอด	80.00	กลุ่มงานบริหารทั่วไป	150	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
823	P230-000823	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 17 W	150	หลอด	155.00	กลุ่มงานบริหารทั่วไป	150	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
824	P230-000824	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สีน้ำมัน ชนิดทาภายนอก ขนาด 2.5 ลิตร	0	แกลลอน	2490.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
825	P230-000825	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สีน้ำมัน ชนิดทาภายใน ขนาด 1 ลิตร	0	แกลลอน	1195.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
826	P230-000826	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 2.5 นิ้ว	0	อัน	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
827	P230-000827	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 4 นิ้ว	0	อัน	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
828	P230-000828	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลูกกลิ้งทาสี ขนาด 10 นิ้ว	0	อัน	79.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
829	P230-000829	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ด้ามต่อ สำหรับต่อลูกกลิ้งทาสี ยาว 2 เมตร	0	อัน	109.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
830	P230-000830	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แม่สี เบอร์ BV	0	ซีซี.	1.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
831	P230-000831	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แม่สี เบอร์ OK	0	ซีซี.	1.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
832	P230-000832	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แม่สี เบอร์ SS	0	ซีซี.	2.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
833	P230-000833	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แม่สี เบอร์ ST	0	ซีซี.	2.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
834	P230-000834	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 3/4 นิ้ว	60	ม้วน	11.50	กลุ่มงานบริหารทั่วไป	60	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
835	P230-000835	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 1.5 นิ้ว	0	เส้น	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
836	P230-000836	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยูเนียน ชนิดเหล็ก ขนาด 1.5 นิ้ว	0	อัน	205.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
837	P230-000837	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยกเลิก ข้องอ ชนิด PVC หนา แบบ 90 องศา ขนาด 1.5 นิ้ว	0	ตัว	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
838	P230-000838	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC ขนาด 1.5 นิ้ว	0	ตัว	28.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
839	P230-000839	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เกลียวนอก ขนาด 1/2 นิ้ว	2	ตัว	28.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
840	P230-000840	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หนังสือ มาตฐาน SPA part I , II , III , IV	0	ชุด	550.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
841	P230-000841	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	รางสายไฟ แบบ DT1225 นาโน	0	เส้น	55.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
842	P230-000842	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สต๊อปวาล์ว ชนิดลอย แบบหัวแก้ว	0	อัน	160.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
843	P230-000843	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายน้ำดี ขนาด 32 นิ้ว	0	เส้น	75.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
844	P230-000844	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	จานเอ็น สำหรับเครื่องตัดหญ้า	2	อัน	130.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
845	P230-000845	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	กรรไกร สำหรับต้นไม้สูง สำหรับตัดแต่งกิ่ง ขนาด 1.5 เมตร	3	อัน	1790.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
846	P230-000846	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ตะไบ ชนิดกลม สำหรับเลื่อยยนต์ ขนาด 3/8 นิ้ว	1	อัน	180.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
847	P230-000847	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ตะไบ ชนิดกลม สำหรับเลื่อยยนต์ ขนาด 4 นิ้ว	1	อัน	260.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
848	P230-000848	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ยกเลิก จารบี สำหรับเครื่องตัดหญ้า	0	กระป๋อง	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
849	P230-000849	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	HDMI extender	0	อัน	1390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
850	P230-000850	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	มือจับ แบบก้านโยก	10	ชุด	1490.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
851	P230-000851	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก ปากกา เขียนแผ่น CD สีน้ำเงิน	0	ด้าม	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
852	P230-000852	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก ปากกา เขียนแผ่น CD สีน้ำเงิน	0	ด้าม	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
853	P230-000853	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุดดรัมหมึก HP e77830 สำหรับเครื่องถ่ายเอกสาร	0	ชุด	9500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
854	P230-000854	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปกาว ชนิด 2 หน้า แบบบาง ขนาด 1 นิ้ว	3	ม้วน	132.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
855	P230-000855	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดสแตนเลส แบบเท้าเหยียบ ขนาด 20 ลิตร	19	ใบ	1690.00	กลุ่มงานบริหารทั่วไป	19	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
856	P230-000856	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกรู ชนิดเกลียวปล่อย ขนาด 1.5 นิ้ว	0	กล่อง	77.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
857	P230-000857	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอกสว่าน ชนิดเจาะคอนกรีต ขนาด 6.5 มม.	0	อัน	94.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
858	P230-000858	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	รีเวท ขนาด (4-3)	0	ถุง	31.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
859	P230-000859	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น	2	ชุด	660.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
860	P230-000860	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิดยาง ขนาดเล็ก	0	กระปุก	83.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
861	P230-000861	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น ชนิดยาง แบบเกลียว ขนาด 2 นิ้ว	2	ชุด	121.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
862	P230-000862	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระเบื้อง ชนิดลอนคู่ ขนาด 1.5 เมตร สีขาว	0	แผ่น	70.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
863	P230-000863	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกรู ชนิดปลายสว่าน ขนาด 4 นิ้ว	0	ตัว	3.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
864	P230-000864	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีล้อ พร้อมฝาปิด ขนาด 100 ลิตร	0	กล่อง	359.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
865	P230-000865	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	สายยาง ขนาด 1/2 นิ้ว	0	เมตร	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
866	P230-000866	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก หมึก Printer Laser Fuji Apeos C325/328 dw	0	กล่อง	1350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
867	P230-000867	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกรู ชนิดปลายสว่าน ขนาด 8*3/4	2	ถุง	20.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
868	P230-000868	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น๊อต แบบเกลียวปล่อย ขนาด 7*1/2	1	ถุง	15.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
869	P230-000869	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	พุก ชนิดพลาสติก แบบผีเสื้อ	0	อัน	5.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
870	P230-000870	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น๊อต แบบเกลียวปล่อย ขนาด 8*2	0	ถุง	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
871	P230-000871	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แม่สี เบอร์ CS04 สีดำ	0	ซีซี	2.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
872	P230-000872	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แม่สี เบอร์ CS06 สีน้ำเงิน	0	ซีซี	2.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
873	P230-000873	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แม่สี เบอร์ CS08 สีแดงออกไซด์	0	ซีซี	1.75	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
874	P230-000874	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี BK	0	ชุด	6600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
875	P230-000875	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี C	0	ชุด	6600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
876	P230-000876	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี M	0	ชุด	6600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
877	P230-000877	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุดแทงค์ HP e77830 สำหรับเครื่องถ่ายเอกสาร สี Y	0	ชุด	6600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
878	P230-000878	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กรอบบัตรประจำตัว แบบแข็ง	150	อัน	12.00	กลุ่มงานบริหารทั่วไป	150	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
879	P230-000879	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สายคล้องคอ สำหรับบัตรประจำตัว	150	อัน	35.00	กลุ่มงานบริหารทั่วไป	150	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
880	P230-000880	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC ขนาด 2 นิ้ว	5	อัน	44.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
881	P230-000881	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บอลวาล์ว ชนิด PVC ขนาด 2 นิ้ว	0	อัน	1265.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
882	P230-000882	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่นปิดรอยต่อ ขนาดม้วนใหญ่	0	ม้วน	550.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
883	P230-000883	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น ชนิดบอล แบบเกลียว ขนาด 2 นิ้ว	2	อัน	155.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
884	P230-000884	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC แบบเกลียวนอก ขนาด 2 นิ้ว	3	อัน	26.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
885	P230-000885	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบลด ขนาด 13.5*2 นิ้ว	0	อัน	420.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
886	P230-000886	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบลด ขนาด 8.5*2 นิ้ว	0	อัน	227.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
887	P230-000887	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ไฟสนาม แบบสปอตไลท์ ขนาด 2000 W	0	อัน	3890.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
888	P230-000888	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC ขนาด 3/4 นิ้ว	10	อัน	9.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
889	P230-000889	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยางรองชักโครก	0	อัน	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
890	P230-000890	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายชักโครก	0	อัน	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
891	P230-000891	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ประตูน้ำ ชนิด PVC ขนาด 2 นิ้ว	0	อัน	220.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
892	P230-000892	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิดประสาน สำหรับทาท่อ PVC ขนาด 500 กรัม	3	กระป๋อง	300.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
893	P230-000893	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฝาครอบ ชนิด PVC ขนาด 1 นิ้ว	2	อัน	14.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
894	P230-000894	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฝาครอบ ชนิด PVC ขนาด 3/4 นิ้ว	2	อัน	9.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
895	P230-000895	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อลด ชนิด PVC ขนาด 2*1/2 นิ้ว	2	อัน	44.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
896	P230-000896	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฟลัชวาล์ว ชนิดท่อโค้ง สำหรับโถชาย	0	อัน	679.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
897	P230-000897	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ฝานั่งรองชักโครก ชนิดพลาสติก	14	อัน	499.00	กลุ่มงานบริหารทั่วไป	14	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
898	P230-000898	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะแกรงรังผึ้ง ขนาด 2*1/2 นิ้ว	0	อัน	29.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
899	P230-000899	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สีสะท้อนแสง ขนาด 3 ลิตร สีขาว	0	กระป๋อง	820.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
900	P230-000900	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สีสะท้อนแสง ขนาด 3 ลิตร สีดำ	0	กระป๋อง	850.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
901	P230-000901	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สีน้ำมัน สีเทา	0	แกลลอน	650.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
902	P230-000902	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ทินเนอร์	0	แกลลอน	175.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3380	P230-000001	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ขวาน ชนิดเหล็ก แบบด้ามไม้	3	อัน	200.00	งานโรคไม่ติดต่อเรื้อรัง	3	2569	1	2026-03-14 08:03:24.086509	2026-03-14 08:03:24.086509	0015
903	P230-000903	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 3 นิ้ว	0	แกลลอน	85.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
904	P230-000904	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกรู ชนิดเกลียวปล่อย ขนาด 3.5*40 มม.	200	กล่อง	36.00	กลุ่มงานบริหารทั่วไป	200	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
905	P230-000905	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อีพ๊อคซี่ สำหรับเสียบเหล็ก	0	กิโลกรัม	359.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
906	P230-000906	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอกสว่าน ชนิดเจาะเหล็ก แบบ 19 ชิ้น	1	ชุด	390.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
907	P230-000907	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายวัด ยาว 30 เมตร	1	ชุด	639.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
908	P230-000908	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	มีดคัทเตอร์ แบบด้ามพลาสติก ยาว 18 มม.	0	อัน	149.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
909	P230-000909	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ประแจเลื่อน	0	อัน	255.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
910	P230-000910	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ไขควง แบบสลับหัว	0	ชุด	109.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
911	P230-000911	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ปากกา สำหรับตัดกระเบื้องและกระจก	0	อัน	289.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
912	P230-000912	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แปรง ชนิดลวด แบบรูปถ้วย ขนาด 3 นิ้ว	1	อัน	89.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
913	P230-000913	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คีม ชนิดปากแหลม ขนาด 6 นิ้ว	0	อัน	179.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
914	P230-000914	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คีม ชนิดปากแหลม ขนาด 8 นิ้ว	0	อัน	230.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
915	P230-000915	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกัด ชนิดปากแบน แบบด้ามยาง ขนาด 10 นิ้ว	0	อัน	99.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
916	P230-000916	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ไขควง แบบสลับหัว ขนาด 6 นิ้ว	0	อัน	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
917	P230-000917	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ประแจ แบบแหวนข้างปากตาย เบอร์ 21	0	อัน	99.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
918	P230-000918	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	มีดคัทเตอร์ แบบด้ามโลหะ ยาว 18 มม.	0	อัน	49.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
919	P230-000919	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด 6 เหลี่ยม แบบ 13 ชิ้น	0	ชุด	599.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
920	P230-000920	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คีม ชนิดปากตรง สำหรับล๊อค ขนาด 10 นิ้ว	0	อัน	225.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
921	P230-000921	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ไขควง แบบสลับหัว ขนาด 1.5 นิ้ว	0	อัน	59.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
922	P230-000922	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ค้อน ชนิดเหล็ก แบบหงอน ด้ามไฟเบอร์	0	อัน	169.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
923	P230-000923	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ปากกา สำหรับเช็คกระแสไฟ	0	อัน	139.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
924	P230-000924	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุด 6 เหลี่ยม แบบ 9 ชิ้น	0	ชุด	169.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
925	P230-000925	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ด้ามกบไสไม้ แบบพร้อมลิ่ม	0	ชุด	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
926	P230-000926	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คีม ชนิดปากเฉียง	0	อัน	125.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
927	P230-000927	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กรรไกร สำหรับตัดแผ่นโลหะ ขนาด 10 นิ้ว	0	อัน	239.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
928	P230-000928	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สิ่ว ชนิดเหล็ก แบบด้ามไม้	0	อัน	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
929	P230-000929	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ดอกสว่าน ชนิดโรตารี่	0	อัน	380.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
930	P230-000930	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ประแจ แบบแหวนข้างปากตาย เบอร์ 14	0	อัน	69.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
931	P230-000931	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ไขควง ซ่อมนาฬิกา แบบ 4 ชิ้น	0	ชุด	89.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
932	P230-000932	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กบไสไม้ ขนาด 8 นิ้ว	0	อัน	260.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
933	P230-000933	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ใบมีดกบไสไม้ ขนาด 1.3/4 นิ้ว	0	อัน	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
934	P230-000934	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกัด ชนิดปากแหลม แบบด้ามยาง ขนาด 10 นิ้ว	0	อัน	99.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
935	P230-000935	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เลื่อย ชนิดโครงเหล็ก ขนาด 12 นิ้ว	1	อัน	115.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
936	P230-000936	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser TN 1000	15	กล่อง	390.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
937	P230-000937	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser PANTUM P2500	11	กล่อง	850.00	กลุ่มงานบริหารทั่วไป	11	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
938	P230-000938	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser BROTHER FAX2950	55	กล่อง	590.00	กลุ่มงานบริหารทั่วไป	55	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
939	P230-000939	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ถ่าน BIOS แบบ LR2032	12	อัน	55.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
940	P230-000940	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Power supply ขนาด 550W	0	อัน	1350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
941	P230-000941	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Hardisk ชนิด SSD External ขนาด 240 Gb	0	อัน	1090.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
942	P230-000942	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	สาย HDMI ชนิด 4K ขนาด 5 เมตร	0	เส้น	390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
943	P230-000943	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	สาย HDMI ชนิด 4K ขนาด 10 เมตร	0	เส้น	890.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
944	P230-000944	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	กล่องใส่ Hardisk ขนาด 2.5 นิ้ว	0	อัน	690.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
945	P230-000945	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	คีม สำหรับเข้าหัว LAN	0	อัน	990.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
946	P230-000946	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser Fuji Apeos C325/328 สีดำ	6	กล่อง	1350.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
947	P230-000947	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser Fuji Apeos C325/328 สีเหลือง	6	กล่อง	1350.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
948	P230-000948	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser Fuji Apeos C325/328 สีฟ้า	6	กล่อง	1350.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
949	P230-000949	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser Fuji Apeos C325/328 สีชมพู	6	กล่อง	1350.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
950	P230-000950	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ถัขนาด 3 ลิตร	0	อัน	390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
951	P230-000951	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 5 ลิตร	0	อัน	390.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
952	P230-000952	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงหิ้ว ชนิดพลาสติก ขนาด 6*14 นิ้ว สีขาว	100	แพค	60.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
953	P230-000953	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตะกร้า ชนิดหวาย แบบทรงเหลี่ยม ขนาด 30 x 20 x 9 ซม.	0	ใบ	200.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
954	P230-000954	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตะกร้า ชนิดพลาสติก แบบทรงเหลี่ยม ขนาด 32 x 21 x 14 ซม.	0	ใบ	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
955	P230-000955	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	สบู่ แบบเหลว สำหรับทารก ขนาด 850 ซีซี.	0	ขวด	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
956	P230-000956	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หวี สำหรับเด็ก	0	อัน	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
957	P230-000957	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตะกร้า สำหรับใส่อุปกรณ์อาบน้ำเด็ก	0	อัน	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
958	P230-000958	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กะละมัง สำหรับอาบน้ำเด็ก	0	ใบ	260.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
959	P230-000959	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระติกน้ำแข็ง ขนาด 10 ลิตร	0	ใบ	200.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
960	P230-000960	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงหิ้ว ชนิดพลาสติก ขนาด 12*20 นิ้ว สีขาว	658	แพค	60.00	กลุ่มงานบริหารทั่วไป	658	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
961	P230-000961	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น้ำกลั่นแบตเตอรี่ สำหรับเครื่องนึ่ง EO ขนาด 1 ลิตร	0	ขวด	200.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
962	P230-000962	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 40 W	0	หลอด	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
963	P230-000963	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 10 เมตร	2	อัน	399.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
964	P230-000964	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กรอบรูป ขนาด 4x6 นิ้ว	0	อัน	200.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
965	P230-000965	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	พู่กัน เบอร์8	0	ด้าม	40.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
966	P230-000966	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก แฟ้ม แบบแขวน สีม่วง	0	แฟ้ม	90.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
967	P230-000967	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปกาว ชนิดแลกซีน ขนาด 1.5 นิ้ว ยาว 8 หลา	0	ม้วน	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
968	P230-000968	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีเขียว	0	ห่อ	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
969	P230-000969	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีชมพู	0	ห่อ	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
970	P230-000970	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 150 แกรม ขนาด A4 สีฟ้า	0	ห่อ	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
971	P230-000971	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เครื่องเย็บกระดาษ ขนาดใหญ่	0	อัน	2500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
972	P230-000972	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษโน๊ต แบบมีกาว ขนาด 7.5x 7.5 ซม.	0	ห่อ	80.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
973	P230-000973	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษโน๊ต แบบมีกาว ขนาด 2.5x 7.5 ซม.	0	ห่อ	80.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
974	P230-000974	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีเหลือง	0	ห่อ	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
975	P230-000975	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีเขียว	0	ห่อ	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
976	P230-000976	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ด หนา 180 แกรม แบบมีกลิ่นหอม ขนาด A4 สีชมพู	0	ห่อ	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
977	P230-000977	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ลวดเย็บกระดาษ เบอร์ 23/10	0	กล่อง	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
978	P230-000978	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อกาวน์ แบบกันน้ำ	0	ตัว	490.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
979	P230-000979	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ใบหินเจียร แบบหนา ขนาด 4 นิ้ว	0	ใบ	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
980	P230-000980	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ลวดมัดเหล็ก	0	ม้วน	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
981	P230-000981	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	คีม สำหรับมัดลวด	0	อัน	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
982	P230-000982	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ไขควง ชนิดปากแฉก	0	อัน	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
983	P230-000983	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ไขควง ชนิดปากแบน	0	อัน	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
984	P230-000984	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	เชือก ชนิดป่านมะนิลา ขนาด 18 มม. สีขาว	6	เมตร	450.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
985	P230-000985	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	เมล็ดพันธ์ดอกไม้	0	กิโลกรัม	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
986	P230-000986	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	น้ำยาฆ่าหญ้า แบบขวด	0	ขวด	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
987	P230-000987	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Hardisk External ขนาด 1 Tb	1	อัน	2000.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
988	P230-000988	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Hardisk ชนิด SSD External ขนาด 500 Gb	0	เครื่อง	3000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
989	P230-000989	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	MP3 player แบบ USB ขนาด 512 MB	0	อัน	299.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
991	P230-000991	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อกั๊ก สะท้อนแสง	0	ตัว	300.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
992	P230-000992	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	บอร์ด สำหรับผังบุคลากร ขนาด 50 x 70 ซม.	1	อัน	550.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
993	P230-000993	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ป้ายชื่อ สำหรับหน่วยงาน	0	ชิ้น	4000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
994	P230-000994	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ยกเลิก ถังขยะ	0	อัน	1000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
995	P230-000995	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังผ้า สำหรับผู้ป่วยห้องพิเศษ	0	อัน	1000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
996	P230-000996	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังผ้า สำหรับผู้ป่วยสามัญ	0	อัน	1500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
997	P230-000997	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	โมเดลอาหาร	0	ชุด	7500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
998	P230-000998	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องพลาสติก ทรงสี่เหลี่ยม แบบพร้อมหูหิ้วและฝาปิดระบบล๊อค	0	ใบ	220.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
999	P230-000999	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	หมอน สำหรับรองให้นมบุตร	0	ใบ	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1000	P230-001000	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องพลาสติก ทรงสี่เหลี่ยม แบบมีฝาปิด ขนาด 100 ลิตร	0	ใบ	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1001	P230-001001	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก ถังขยะพลาสติก ขนาดไม่น้อยกว่า 60 ลิตร แบบเท้าเหยียบ ขนาด 60 ลิตร	0	ถัง	1500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1002	P230-001002	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องรองเท้า แบบฝาหน้า	0	กล่อง	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1003	P230-001003	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระจกเงา ขนาด 55 x 90 ซม.	0	บาน	2090.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1004	P230-001004	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตะกร้า แบบทรงเหลี่ยม ขนาด 37.5 x 26.5 x 14.2 ซม.	0	ใบ	159.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1005	P230-001005	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	รองเท้า แบบ Slippers ขนาด Free size	0	คู่	259.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1006	P230-001006	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าขนหนู ขนาด 24 x 48 นิ้ว	0	โหล	1200.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1007	P230-001007	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	มู่ลี่ ชนิดไวนิล ขนาด 120 x 160 ซม.	0	ผืน	750.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1008	P230-001008	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เก้าอี้ ชนิดพลาสติก เกรด A สำหรับผู้ป่วย	0	ตัว	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1009	P230-001009	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	นาฬิกา แบบแขวนผนัง	4	เรือน	400.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1010	P230-001010	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง	0	ตัว	290.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1011	P230-001011	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 7 ชั้น ขนาด A4	0	อัน	1000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1012	P230-001012	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง สีขาว	0	ตัว	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1013	P230-001013	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ยกเลิก เก้าอี้ ชนิดพลาสติก เกรด A แบบมีพนักพิง สีขาว	0	ตัว	290.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1014	P230-001014	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายอะคริลิค ขนาด 12 x 25 ซม.	0	อัน	170.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1015	P230-001015	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายอะคริลิค ขนาด 10 x 15 ซม.	0	อัน	150.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1016	P230-001016	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายอะคริลิค ขนาด 20 x 50 ซม.	0	อัน	300.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1017	P230-001017	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายอะคริลิค ขนาด 15 x 15 ซม.	0	ชิ้น	170.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1018	P230-001018	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชั้นอเนกประสงค์ ชนิดพลาสติก	0	ตัว	300.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1019	P230-001019	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก สำหรับเก็บเครื่องมือ ขนาด 12 นิ้ว สีใส	0	ใบ	300.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1020	P230-001020	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ชาร์ททะเบียนผู้ป่วย แบบอลูมีเนียม	0	อัน	600.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1021	P230-001021	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	กรวยจราจร ชนิดพับเก็บได้ พลาสติก ขนาด 42 ซม.	20	กรวย	350.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1022	P230-001022	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่าง แบบกากบาท ขนาด 1/2 นิ้ว	0	อัน	520.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1023	P230-001023	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะแกรงน้ำทิ้ง แบบสแตนเลส ขนาด 1.5 นิ้ว	0	อัน	12.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1024	P230-001024	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบใบพาย ขนาด 1/2 นิ้ว	4	อัน	550.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1025	P230-001025	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สกรูปลายสว่าน ขนาด 8 x 1	0	ถุง	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1026	P230-001026	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สกรูปลายสว่าน ขนาด 8 x 2	0	ถุง	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1027	P230-001027	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สกรูปลายสว่าน ขนาด 3/4	0	ถุง	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1028	P230-001028	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ตระแกรง ชนิดพลาสติก แบบก้างปลารังผึ้ง ขนาดกลาง	0	อัน	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1029	P230-001029	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	โคมไฟ ชนิดคู่ แบบออกไก่ ขนาด 2 x 40 watt.	0	ชุด	320.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1030	P230-001030	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 10 W	0	หลอด	75.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1032	P230-001032	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิด epoxy	0	ชุด	132.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1033	P230-001033	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับซิงค์ แบบต่อล่าง ขนาด 1/2 นิ้ว	0	ชุด	605.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1034	P230-001034	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ยกเลิก ไมค์โครโฟน แบบไร้สาย	0	ชุด	2900.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1035	P230-001035	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แบตเตอรี่ ขนาด 4V 5AH DEL	0	ลูก	219.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1036	P230-001036	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายชื่อ แบบสามเหลี่ยม ขนาด 4x12 นิ้ว	0	อัน	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1037	P230-001037	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ก้างปลา	0	อัน	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1038	P230-001038	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิด PVC แบบตรง ขนาด 3 นิ้ว	0	เส้น	1485.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1039	P230-001039	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เกลียวเร่ง ขนาด 3 หุน	0	อัน	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1040	P230-001040	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หน้ากากปลั๊กไฟ แบบกันน้ำ	0	อัน	56.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1041	P230-001041	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถังปูน	0	ใบ	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1042	P230-001042	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เทปพิมพ์	10	ม้วน	600.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1043	P230-001043	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษถ่ายเอกสาร ขนาด A3	0	รีม	265.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1044	P230-001044	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สติ๊กเกอร์ ชนิดกระดาษ แบบสี ขนาด A4 สีขาวด้าน	0	ห่อ	125.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1045	P230-001045	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	แผ่นรองตัด ขนาด 30*45 ซม.	0	อัน	240.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1046	P230-001046	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังน้ำดื่ม ชนิดพลาสติก ขนาด 20 ลิตร	0	ใบ	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1047	P230-001047	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิ๊บ ชนิดทองเหลือง สำหรับสายสลิง	0	อัน	7.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1048	P230-001048	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิดซิลิโคน สำหรับยาแนว	1	อัน	50.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1049	P230-001049	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ถุงมือ ชนิดถัก แบบเคลือบไนไตร	4	อัน	35.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1050	P230-001050	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น้ำยา สำหรับประสานคอนกรีต	2	อัน	219.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1051	P230-001051	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น้ำยา สำหรับขจัดท่อตัน	1	อัน	230.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1052	P230-001052	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เกล็ดโซดาไฟ สำหรับขจัดท่อตัน	2	อัน	69.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1053	P230-001053	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สเปร์ย ชนิดโฟม	0	อัน	359.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1054	P230-001054	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิด PVC แบบเกลียวใน ขนาด 1/2 นิ้ว	0	อัน	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1055	P230-001055	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น๊อต แบบเกลียว	1	ถุง	30.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1056	P230-001056	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลวด	0	กิโลกรัม	70.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1057	P230-001057	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	น๊อต ขนาด 2 หุน	2	กิโลกรัม	100.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1058	P230-001058	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิดเหล็ก แบบตรง ขนาด 1.5 นิ้ว	0	เส้น	1285.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1059	P230-001059	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	นิปเปิ้ล ชนิดเหล็ก ขนาด 1/2 นิ้ว	2	อัน	110.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1060	P230-001060	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิดเหล็ก แบบ 90 องศา ขนาด 1.5 นิ้ว	1	อัน	160.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1061	P230-001061	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิดเหล็ก แบบลด ขนาด 1*1/3 นิ้ว	0	อัน	220.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1062	P230-001062	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Ram BUS 2666 DDR4 ขนาด 8 Gb	0	อัน	790.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1063	P230-001063	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กุญแจ แบบบิด สำหรับบานเลื่อน	0	อัน	570.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1064	P230-001064	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ปืนฉีด สำหรับปั้มลม	0	ชุด	320.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1065	P230-001065	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บันได ชนิดไม้ไผ่ แบบ 13 ขั้น	0	ชุด	900.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1066	P230-001066	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	สปริงเกอร์	12	ตัว	17.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1067	P230-001067	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ข้อต่อ ชนิดเหล็ก สำหรับต่อสายยาง ขนาด 1/2 นิ้ว	5	ตัว	28.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1068	P230-001068	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	สาย Printer แบบ USB ขนาดยาว 5 เมตร	0	เส้น	159.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1069	P230-001069	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	สาย Printer แบบ USB ขนาดยาว 10 เมตร	0	เส้น	220.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1070	P230-001070	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับอ่างล้างหน้า แบบหางปลา ขนาด 1/2 นิ้ว	0	ชุด	590.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1071	P230-001071	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แม่สี เบอร์ 9RC	0	อัน	260.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1072	P230-001072	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เหล็กนำ STN	0	อัน	45.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1073	P230-001073	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ไมค์โครโฟน แบบมีสาย	0	ตัว	790.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1074	P230-001074	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ไมค์โครโฟน ชนิดคู่ แบบไร้สาย	0	ชุด	890.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1075	P230-001075	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED แบบฟูลเซ็ท ขนาด 16 W	0	ชุด	295.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1076	P230-001076	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สาย RCA2 ขนาด 1.8 เมตร	0	เส้น	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1077	P230-001077	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระจกโค้ง สำหรับมุมอับสายตา ขนาด 80 ซม.	2	ชุด	980.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1078	P230-001078	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แบตเตอรี่ สำหรับเครื่องเอกซเรย์เคลื่อนที่ ขนาด 12V 9Ah	0	ชิ้น	2400.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1079	P230-001079	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุดหูฝานั่งรองชักโครก ชนิดพลาสติก	0	ชุด	650.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1080	P230-001080	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกรู ชนิดไดวอ ขนาด 1.5 นิ้ว	0	กล่อง	95.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1129	P230-001129	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่นเจียร	0	อัน	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1081	P230-001081	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สกรู ชนิดหัวบล๊อค แบบปลายแหลม	0	ตัว	3.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1082	P230-001082	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาว ชนิดยาง ขนาดใหญ่	0	กระปุก	144.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1083	P230-001083	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	จอบ ชนิดเหล็ก แบบด้ามไม้	1	อัน	295.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1084	P230-001084	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	เสียม ชนิดเหล็ก แบบด้ามไม้	1	อัน	315.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1085	P230-001085	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บันได ชนิดอลูมีเนียม แบบ 5 ขั้น	0	อัน	1090.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1086	P230-001086	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ป้าย ชนิดอลูมีเนียม ห้ามจอดรถ สีสท้อนแสง	0	แผ่น	535.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1087	P230-001087	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่	ป้าย ชนิดอลูมีเนียม ระวังสายไฟฟ้าแรงสูง สีสท้อนแสง	0	แผ่น	535.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1088	P230-001088	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตาข่าย สำหรับกันสัตว์ปีนเสาไฟฟ้า ขนาด 45*65 ซม.	0	อัน	650.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1089	P230-001089	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษถ่ายเอกสาร ขนาด A5	36	รีม	65.00	กลุ่มงานบริหารทั่วไป	36	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1090	P230-001090	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	สายยาง ขนาด 5/8 นิ้ว ยาว 20 เมตร	0	เส้น	590.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1091	P230-001091	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายตราสัญลักษณ์ วปร. แบบพร้อมฐานตั้งโต๊ะ	0	ชุด	650.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1092	P230-001092	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บันได ชนิดอลูมีเนียม แบบ 4 ขั้น	0	อัน	2190.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1093	P230-001093	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser TN-2560	48	กล่อง	1390.00	กลุ่มงานบริหารทั่วไป	48	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1094	P230-001094	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก๊อกน้ำ ชนิดทองเหลือง สำหรับตู้คูลเลอร์ ขนาด 1/2 นิ้ว	4	อัน	390.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1095	P230-001095	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กุญแจ แบบขอสับ สำหรับบานเลื่อน	0	อัน	450.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1096	P230-001096	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คีม ชนิดปากงอ สำหรับหนีบแหวน ขนาด 6 นิ้ว	0	อัน	215.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1097	P230-001097	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	คีม สำหรับปลอกสายไฟ ขนาด 9 นิ้ว	0	อัน	200.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1098	P230-001098	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายดิน ขนาด 1*2.5 สีเขียว	0	เมตร	12.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1099	P230-001099	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายไฟ แบบคอนโทรล	0	เมตร	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3352	P230-000252	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	บานพับ แบบผีเสื้อ	10	อัน	22.00	กลุ่มงานบริการด้านปฐมภูมิฯ	10	2569	1	2026-03-11 00:39:07.086046	2026-03-11 00:39:07.086046	0010
1100	P230-001100	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แท่งกราวด์ สำหรับโหลดทองแดง	0	อัน	65.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1101	P230-001101	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หางปลา สำหรับสายคอนโทรล	0	กล่อง	270.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1102	P230-001102	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ยางปั๊มท่อน้ำ ขนาดหน้าใหญ่	5	อัน	110.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1103	P230-001103	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผ้าใบคลุมเต้นท์ แบบโค้ง ขนาด 4*8 เมตร	0	ผืน	13375.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1104	P230-001104	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขันน้ำ ชนิดพลาสติก แบบไม่มีด้าม	0	ใบ	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1105	P230-001105	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ท่อสูบน้ำ ชนิดผ้าใบ PVC ขนาด 2 นิ้ว	0	เมตร	80.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1106	P230-001106	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Hardisk ชนิด SSD Internal ขนาด 500 Gb	1	อัน	1690.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1107	P230-001107	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 4 ช่อง และฝาล๊อค ขนาด 37.5 x 25.6 x 10 ซม. สีใส	0	อัน	159.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1108	P230-001108	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องอเนกประสงค์ ชนิดพลาสติก แบบ 6 ช่อง และฝาล๊อค ขนาด 55.5 x 25.6 x 10 ซม. สีใส	0	อัน	199.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1109	P230-001109	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีฝาล๊อค ขนาด 70.5 ลิตร สีขาว	0	อัน	309.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1110	P230-001110	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ท่อน้ำ ชนิดเหล็ก ขนาด 2.5 นิ้ว สีดำ	0	ท่อ	1050.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1111	P230-001111	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	น๊อต แบบเกลียวปล่อย ขนาด 7*1.5	0	กล่อง	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1112	P230-001112	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะแกรงน้ำทิ้ง แบบสแตนเลส ขนาด 2 นิ้ว	2	อัน	11.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1113	P230-001113	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ปูน สำหรับยาแนว สีขาว	5	ถุง	50.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1114	P230-001114	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser FUJI-XEROX CT202877 สีดำ	30	กล่อง	980.00	กลุ่มงานบริหารทั่วไป	30	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1115	P230-001115	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser FUJI-XEROX CT203486 สีดำ	0	กล่อง	1350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1116	P230-001116	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser FUJI-XEROX CT203486 สีชมพู	0	กล่อง	1350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1117	P230-001117	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser FUJI-XEROX CT203486 สีเหลือง	0	กล่อง	1350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1118	P230-001118	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ราวจับ ชนิดสแตนเลส สำหรับจับกันลื่น	0	อัน	1159.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1119	P230-001119	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กล่องกระดาษชำระ ชนิดพลาสติก สำหรับห้องน้ำ	0	อัน	219.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1120	P230-001120	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED แบบไฟฉุกเฉินโซล่าเซล ขนาด 180 W	0	ชุด	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1121	P230-001121	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ไฟฉุกเฉิน ชนิด LED ขนาด 2*6 W	0	ชุด	1890.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1122	P230-001122	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED แบบโซล่าเซล ขนาดใหญ่ ขนาด 535 W	0	ชุด	400.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1123	P230-001123	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟพ่วง พร้อมล้อเก็บสายไฟ แบบ 4 ช่อง ขนาด 3600 W	0	ชุด	2090.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1124	P230-001124	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิด PVC ขนาด 2 นิ้ว	0	อัน	70.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1125	P230-001125	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	กระถาง พร้อมจานรอง สำหรับปลูกต้นไม้ ขนาด 9 นิ้ว	0	ชุด	220.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1126	P230-001126	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	รางสายไฟ แบบ TD205	4	เส้น	85.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1127	P230-001127	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก้านกดน้ำ แบบ BT007	0	อัน	149.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1128	P230-001128	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ก้านกดน้ำ แบบ BT008	2	อัน	109.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1130	P230-001130	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Memory card ชนิด Micro SD ขนาด 32 Gb	4	อัน	199.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1131	P230-001131	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิด PVC แบบเกลียวใน ขนาด 1/2 นิ้ว	0	อัน	6.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1132	P230-001132	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายเทป แบบร่อง ยาว 2 เมตร	10	เส้น	50.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1133	P230-001133	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED แบบตาแมว ขนาด 5 W	4	หลอด	120.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1134	P230-001134	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สวิทช์ไฟ แบบ 2 จังหวะ ขนาด 22 มิลลิเมตร	10	ตัว	65.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1135	P230-001135	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ฝาอุดปลั๊กไฟ ชนิดพลาสติก	10	อัน	10.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1137	P230-001137	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หน้ากากปลั๊กไฟ แบบ 4 ช่อง	20	อัน	30.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1138	P230-001138	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แบตเตอรี่ แบบกึ่งแห้ง สำหรับรถยนต์ ขนาด 12V 80Ah	0	อัน	3400.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1139	P230-001139	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้อต่อตรง ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	3	อัน	35.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1140	P230-001140	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ข้องอ ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	5	อัน	45.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1141	P230-001141	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เทป สำหรับกั้นเขต ขนาด 70 มม. ยาว 500 เมตร	1	ม้วน	299.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1142	P230-001142	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องเก็บของ ชนิดพลาสติก แบบ 18 ช่อง ขนาด 12 x 23.5 x 3 ซม.	0	กล่อง	59.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1143	P230-001143	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	พัดลมดูดอากาศ ขนาด 12 นิ้ว	2	ตัว	1390.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1197	P230-001197	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิด LED ขนาด 13 W	0	ดวง	110.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1144	P230-001144	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เชือก ชนิดไนล่อน	0	กิโลกรัม	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1145	P230-001145	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	พุก ชนิดตะกั่ว แบบพร้อมน๊อต	0	ตัว	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1146	P230-001146	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กันชน สำหรับประตู	0	อัน	44.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1147	P230-001147	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าสำหรับทำความสะอาด ขนาด 30 x 40 ซม.	0	แพค	195.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1148	P230-001148	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไม้ดันฝุ่น แบบผ้าไมโครไฟเบอร์ ขนาดยาว 16 นิ้ว	0	อัน	429.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1149	P230-001149	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลูกปืนประตู สำหรับบานผลัก	0	ชุด	450.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1150	P230-001150	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เทปกาว ชนิดบิวทิว	0	อัน	769.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1151	P230-001151	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น แบบสกรูหมุน ขนาด 3 นิ้ว	0	อัน	190.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1152	P230-001152	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น แบบสกรูหมุน มีเบรค ขนาด 3 นิ้ว	0	อัน	225.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1153	P230-001153	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ล้อรถเข็น แบบสกรูหมุน ขนาด 4 นิ้ว	0	อัน	209.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1154	P230-001154	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระบอกเพชร สำหรับเจาะผนัง	0	อัน	590.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1155	P230-001155	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	มิเตอร์น้ำ	0	อัน	520.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1156	P230-001156	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	กิ๊บ รัดสายไฟ เบอร์ 4	2	แพค	10.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1157	P230-001157	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะปู ขนาด 3/4 นิ้ว	1	แพค	10.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1158	P230-001158	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	มิเตอร์ไฟฟ้า	1	อัน	550.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1159	P230-001159	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แค้ม แบบคู่	5	อัน	30.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1160	P230-001160	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แค้ม แบบเดี่ยว	5	อัน	23.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1161	P230-001161	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ สำหรับเก็บนมผง ขนาด 2300 มล.	0	ใบ	425.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1162	P230-001162	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้อเนกประสงค์ ชนิดพลาสติก แบบมีลิ้นชักและล้อ ขนาด 42.10 x 35.80 x 105.50 ซม.	0	ตู้	899.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1163	P230-001163	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	เก้าอี้กลม ชนิดพลาสติก	0	ตัว	149.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1245	P230-001245	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ป้ายชื่อ สำหรับพวงกุญแจ	4	pack	95.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1164	P230-001164	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แผ่นสมาร์ทบอร์ด หนา 6 มม.	0	แผ่น	275.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1165	P230-001165	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชุดทรานเฟอร์เบลล์ HP e77830 สำหรับเครื่องถ่ายเอกสาร	0	ชุด	16000.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1166	P230-001166	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สักหลาดหมึก สำหรับเครื่องคิดเลข	0	อัน	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1167	P230-001167	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ถ่าน ชนิดอัลคาไลน์ แบบ CR2032 ขนาด 3V	0	ก้อน	32.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1168	P230-001168	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ฉากกั้นห้อง แบบทึบ ขนาด 240 x 250 ซม.	0	ชุด	6300.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1169	P230-001169	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ชุดผ้าปูที่นอน พร้อมผ้านวมและปลอกหมอน	0	ชุด	965.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1170	P230-001170	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	หมอนข้าง	0	ใบ	219.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1171	P230-001171	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีฟ้า	0	เมตร	53.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1172	P230-001172	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีขาว	0	เมตร	53.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1173	P230-001173	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีเหลือง	0	เมตร	53.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1174	P230-001174	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	พาน สำหรับจัดดอกไม้	0	อัน	420.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1175	P230-001175	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีม่วงเข้ม	0	เมตร	53.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1176	P230-001176	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ผ้าต่วน แบบผ้ามัน ขนาดหน้ากว้าง 110 ซม. สีม่วงอ่อน	0	เมตร	53.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1177	P230-001177	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	คาบูเรเตอร์ สำหรับเครื่องตัดตัดหญ้า	0	ชุด	1700.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1178	P230-001178	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	พัดลมดูดอากาศ ขนาด 8 นิ้ว	2	ตัว	990.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3360	P230-000001	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ขวาน ชนิดเหล็ก แบบด้ามไม้	1	อัน	200.00	กลุ่มงานบริหารทั่วไป	1	2569	2	2026-03-11 07:48:27.395608	2026-03-11 07:48:27.395608	0001
1179	P230-001179	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูกลอย สำหรับเครื่องปั๊มน้ำไฟฟ้า	2	ชุด	520.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1180	P230-001180	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	โคมไฟ แบบปีกอลูมีเนียม ขนาด 1 x 40	0	ชุด	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1181	P230-001181	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ลูกลอยไฟฟ้า แบบหัวนก	2	ชุด	480.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1182	P230-001182	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สี สำหรับทาฝ้า สีขาว ขนาด 2.5 Gallon	0	แกลลอน	1705.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1183	P230-001183	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 1 นิ้ว	0	อัน	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1184	P230-001184	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 1.5 นิ้ว	0	อัน	25.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1185	P230-001185	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	แปรงทาสี ชนิดขนสังเคราะห์ ขนาด 2 นิ้ว	0	อัน	30.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1186	P230-001186	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ท่อหด สำหรับหุ้มสายไฟ	10	เส้น	10.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1187	P230-001187	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Color box สำหรับ Printer M282nw no.206a สีดำ	8	ชุด	1250.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1188	P230-001188	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Color box สำหรับ Printer M282nw no.206a สีฟ้า	4	ชุด	1250.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1189	P230-001189	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Color box สำหรับ Printer M282nw no.206a สีแดง	4	ชุด	1250.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1190	P230-001190	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Color box สำหรับ Printer M282nw no.206a สีเหลือง	4	ชุด	1250.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1191	P230-001191	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะขอ แบบเกลียว	0	ตัว	2.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1192	P230-001192	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เกลียวเร่ง ชนิดเหล็ก ขนาด 1 นิ้ว	0	ตัว	0.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1193	P230-001193	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระเบื้อง ชนิดแผ่นเรียบ หนา 6 มม.	0	แผ่น	275.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1194	P230-001194	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยา สำหรับขจัดคราบ (Cement residual parts)	0	ขวด	980.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1195	P230-001195	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยางชะลอความเร็วรถ ขนาด 100 x 10 x 2 ซม.	0	อัน	379.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1196	P230-001196	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิดนีออน แบบวงกลม สำหรับโคมไฟซาลาเปา ขนาด 48 W	0	ดวง	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1198	P230-001198	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุดปะเอนกประสงค์ สำหรับซ่อมโซฟา	1	ชุด	80.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1199	P230-001199	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 45 ลิตร	46	ใบ	859.00	กลุ่มงานบริหารทั่วไป	46	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1200	P230-001200	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 3 ชั้น ขนาด 30*36*50 ซม.	0	อัน	499.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1201	P230-001201	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องอเนกประสงค์ ชนิดพลาสติก แบบลิ้นชัก 3 ชั้น ขนาด 30*36*35 ซม.	0	อัน	425.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1202	P230-001202	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	Ram BUS 2666 DDR4 ขนาด 4 Gb	1	อัน	850.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1203	P230-001203	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	โคมไฟ แบบดาวไลท์ หลอด LED ขนาด 5 W	0	อัน	130.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3361	P230-000002	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ด้ามขวาน ชนิดไม้	1	อัน	100.00	กลุ่มงานบริหารทั่วไป	1	2569	2	2026-03-11 07:48:27.402221	2026-03-11 07:48:27.402221	0001
702	P230-000702	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า-งบหน่วยงาน	แบตเตอรี่ แบบชาร์จไฟ ขนาด 800 มิลลิแอมป์	0	ก้อน	500.00	กลุ่มงานบริการด้านปฐมภูมิฯ	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0010
703	P230-000703	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ตะกร้า ชนิดพลาสติก แบบทรงเหลี่ยม ขนาด 14 x 14.5 นิ้ว	0	ใบ	180.00	กลุ่มงานบริการด้านปฐมภูมิฯ	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0010
704	P230-000704	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	กระดาน White board ติดผนัง ขนาด 120 x 90 cm. แบบติดผนัง ขนาด 120 x 90 ซม.	0	แผ่น	1500.00	กลุ่มงานบริการด้านปฐมภูมิฯ	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0010
705	P230-000705	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง-งบหน่วยงาน	บันได ชนิดอเนกประสงค์ แบบ 20 ขั้น	0	ตัว	5900.00	กลุ่มงานบริการด้านปฐมภูมิฯ	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0010
9	P230-000009	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	จานรองประกับใบตัด สำหรับเครื่องตัดหญ้า	0	อัน	70.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
10	P230-000010	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	จานสตาร์ท สำหรับเครื่องตัดหญ้า	0	อัน	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1232	P230-001232	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	เสื้อกาวน์ยาว	1	ตัว	550.00	กลุ่มงานเทคนิคการแพทย์	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:45:24.714332	0002
1204	P230-001204	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขาหนีบกระจก ชนิดสแตนเลส	0	อัน	135.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1205	P230-001205	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระจกใส หนา 3 มม.	1	แผ่น	480.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1207	P230-001207	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สายยาง สำหรับที่นอนลม	0	เส้น	85.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1208	P230-001208	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษโฟโต้ A4 180 แกรม	0	แพค	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1209	P230-001209	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ดหอม สีขาว A4 180 แกรม	0	แพค	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3362	P230-000707	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	แมกเนติก	1	ตัว	730.00	กลุ่มงานบริหารทั่วไป	1	2569	2	2026-03-11 07:48:58.748691	2026-03-11 07:48:58.748691	0001
3366	P230-000075	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ขวดปั๊ม ชนิดพลาสติก สำหรับใส่น้ำยาแอลกอฮอล์	5	ขวด	40.00	กลุ่มงานบริหารทั่วไป	5	2569	2	2026-03-11 13:55:53.760851	2026-03-11 13:55:53.760851	0001
1210	P230-001210	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษการ์ดขาว A4 150 แกรม	0	แพค	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1211	P230-001211	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษสติ๊กเกอร์ ขาวมัน A4 90 แกรม	0	แพค	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1212	P230-001212	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถาดอาหารสแตนเลส พร้อมฝาปิด 5 ช่อง	0	ใบ	500.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1213	P230-001213	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถาดเสริฟเหลี่ยม 10 นิ้ว	20	ใบ	250.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1214	P230-001214	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถ้วยสแตนเลสพร้อมฝาปิด ขนาด 16 ซม.	20	ถ้วย	300.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1215	P230-001215	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กล่องพลาสติกฝาล็อค 60 ลิตร	4	ใบ	500.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1216	P230-001216	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือยางยาว แบบรัดข้อ เบอร์ S	0	คู่	120.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1217	P230-001217	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าขวางเตียง ผ้าฟอกขาว 42"x72" ( Wช/Wญ/LR)	150	ผืน	290.00	กลุ่มงานบริหารทั่วไป	150	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1218	P230-001218	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าถุง ผ้าคอมทวิว สีแดงเลือดนก สรว 88"x40" (LR)	0	ผืน	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1219	P230-001219	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูเตียง ปล่อยชาย ผ้าโทเรหนา สีเขียวโศก (แผนไทย) 100"x108'' (แผนไทย)	0	ผืน	650.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1220	P230-001220	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูเตียง ปล่อยชาย ผ้าฟอกขาว 58"x108" ( Wช/Wญ/LR)	300	ผืน	400.00	กลุ่มงานบริหารทั่วไป	300	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1221	P230-001221	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูรถนอน ปล่อยชาย ผ้าย้อมสีเขียวโศก 42"x108"	100	ผืน	400.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1222	P230-001222	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าปูรถนอน ปล่อยชาย ผ้าย้อมสีเขียวแก่ 42"x108" (ER)	40	ผืน	400.00	กลุ่มงานบริหารทั่วไป	40	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1223	P230-001223	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น เจาะรูกลาง (4"x6") ผ้าย้อมสีเขียวแก่ 58"x100 " (OR)	100	ผืน	1200.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1224	P230-001224	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีแดงเลือดนก XXL (LR)	20	ตัว	350.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1225	P230-001225	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีม่วง XL (แผนไทย)	0	ตัว	280.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1226	P230-001226	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีเขียว XL ( Wช/Wญ/LR)	100	ตัว	300.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1227	P230-001227	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อผู้ใหญ่ ป้ายข้าง ผ้าคอมทวิว สีเขียว XXL ( Wช/Wญ/LR)	200	ตัว	300.00	กลุ่มงานบริหารทั่วไป	200	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1303	P230-001303	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สาย THW ขนาด 1*2.5 สีแดง	0	เมตร	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1228	P230-001228	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	กางเกงผู้ใหญ่ มีเชือกผูก ผ้าคอมทวิว สีเขียว XL ( Wช/Wญ/LR)	100	ตัว	300.00	กลุ่มงานบริหารทั่วไป	100	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1229	P230-001229	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	กางเกงผู้ใหญ่ มีเชือกผูก ผ้าคอมทวิว สีเขียว XXL ( Wช/Wญ/LR)	200	ตัว	300.00	กลุ่มงานบริหารทั่วไป	200	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1230	P230-001230	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าถุง ผ้าคอมทวิว สีแดงเลือดนก สรว 88"x40" (LR)	0	ตัว	300.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1246	P230-001246	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิดนีออน ขนาด 8 W	70	หลอด	100.00	กลุ่มงานบริหารทั่วไป	70	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1247	P230-001247	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หลอดไฟ ชนิดนีออน ขนาด 22 W	50	หลอด	120.00	กลุ่มงานบริหารทั่วไป	50	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1248	P230-001248	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	อะไหล่เครื่องฉีดน้ำไฟฟ้า	2	ชุด	100.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1249	P230-001249	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตัวล๊อคบานเลื่อนกระจก	3	ชุด	160.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1250	P230-001250	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กระจกบานเกล็ด ขนาด 4*36 นิ้ว	15	แผ่น	65.00	กลุ่มงานบริหารทั่วไป	15	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1251	P230-001251	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	รีเวท ขนาด 1/8*5/16	1	pack	25.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1252	P230-001252	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	รีเวท ขนาด 1/8*3/8	1	pack	25.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1253	P230-001253	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กุญแจประตูบานเลื่อนสวิง	5	ชุด	650.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1254	P230-001254	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ชุดฝักบัว แบบ Rain shower	2	ชุด	3590.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1255	P230-001255	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กะละมังซักผ้า ชนิดพลาสติก ขนาด 40 ซม.	10	ใบ	80.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1256	P230-001256	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ไฟสนาม แบบสปอตไลท์ ขนาด 70W	2	ชุด	1290.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1257	P230-001257	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	โคมไฟโรงงาน ขนาด 18 W	10	ชุด	478.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1258	P230-001258	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ผงยิบซัม	2	กิโลกรัม	33.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1259	P230-001259	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ตะปูคอนกรีต	3	กล่อง	18.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1260	P230-001260	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ใบตัด ชนิดไฟเบอร์ ขนาด 14 นิ้ว	2	อัน	110.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1261	P230-001261	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กาวตะปู	5	หลอด	132.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3363	P230-001329	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	แผ่นโฟมจิ๊กซอว์ แบบ ก-ฮ ขนาด 29*29 ซม. (PCU วังทอง)	2	ชุด	390.00	งานผู้ป่วยนอก	2	2569	1	2026-03-11 07:49:03.011831	2026-03-11 07:49:03.011831	0013
1324	P230-001324	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ที่รีดกระจกสำหรับรถยนต์	2	อัน	120.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1262	P230-001262	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ลูกบล๊อค เบอร์ 8	1	อัน	55.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1263	P230-001263	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	เหล็กเส้น ขนาด 6 มม.	4	เส้น	132.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1264	P230-001264	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ราวแขวน ขนาด 75 ซม. (งบหน่วยงาน ward หญิง)	4	อัน	560.50	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1265	P230-001265	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะพลาสติก แบบฝาเหยียบ ขนาด 50 ลิตร (งบหน่วยงาน ward หญิง)	2	อัน	499.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1266	P230-001266	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะพลาสติก แบบฝาเหยียบ ขนาด 80 ลิตร (งบหน่วยงาน ward หญิง)	4	อัน	699.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1267	P230-001267	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะสแตนเลส แบบฝาเหยียบ ขนาด 30 ลิตร (งบหน่วยงาน ward หญิง)	2	อัน	1590.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1268	P230-001268	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถังขยะสแตนเลส แบบฝาเหยียบ ขนาด 30 ลิตร (งบหน่วยงานห้องคลอด)	2	อัน	2590.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1	P230-000001	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ขวาน ชนิดเหล็ก แบบด้ามไม้	1	อัน	200.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
2	P230-000002	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ด้ามขวาน ชนิดไม้	0	อัน	100.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3	P230-000003	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ประกับ สำหรับเครื่องตัดหญ้า	2	อัน	230.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
4	P230-000004	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	มีด ชนิดเหล็ก แบบด้ามไม้	2	เล่ม	250.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1269	P230-001269	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	บล๊อค ชนิด PVC ขนาด 4*4	5	ชุด	225.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1270	P230-001270	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สายเคเบิลไทร์ ชนิดพลาสติก ขนาด 4 นิ้ว	10	ถุง	30.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1271	P230-001271	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สาย THW ขนาด 1*2.5	2	เส้น	1090.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1272	P230-001272	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ประตูน้ำ ขนาด 3 x 5.5 นิ้ว สำหรับบ่อสูบตะกอน	2	ชุด	8900.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1273	P230-001273	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ชั้นวางของเอนกประสงค์ 3 ชั้น แบบมีล้อ (งานทันตกรรม)	2	ชุด	1290.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1274	P230-001274	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	แผงกั้นจราจร ขนาด 1.5 เมตร แบบไม่มีล้อ	8	อัน	1550.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1275	P230-001275	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	กรวยจราจร  ชนิดพลาสติก ขนาด 70 ซม.	20	อัน	299.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3364	P230-000012	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	โซ่ สำหรับเลื่อยยนต์ ขนาด 11.5 นิ้ว	1	เส้น	630.00	กลุ่มงานบริหารทั่วไป	1	2569	2	2026-03-11 07:49:43.428032	2026-03-11 07:49:43.428032	0001
1276	P230-001276	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตะแกรงใสของอเนกประสงค์ ขนาด 21.3*29.3*9 ซม. (งานเภสัชกรรม)	50	ชุด	39.00	กลุ่มงานบริหารทั่วไป	50	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1280	P230-001280	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้ลิ้นชักพลาสติก แบบ 3 ชั้น ขนาด 15.5*20*23 ซม. (งานเภสัชกรรม)	10	ชุด	990.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1281	P230-001281	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้ลิ้นชักพลาสติก แบบ 4 ชั้น ขนาด 18*27*27 ซม. (งานเภสัชกรรม)	10	ชุด	97.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1282	P230-001282	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	ปลั๊กไฟพ่วง แบบ 4 ช่อง 4 สวิตซ์ ยาว 5 เมตร	20	อัน	365.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1283	P230-001283	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สามทาง ชนิดทองเหลือง แบบเกลียวใน ขนาด 1/2 นิ้ว	1	อัน	58.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1284	P230-001284	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระจกส่องตัว (งานเทคนิคการแพทย์)	1	อัน	1735.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1285	P230-001285	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กล่องบรรจุตัวอย่าง (งานเทคนิคการแพทย์)	2	อัน	253.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1286	P230-001286	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชั้นวางรองเท้า (งานเทคนิคการแพทย์)	1	อัน	599.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1287	P230-001287	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ชั้นวางของแบบมีล้อเลื่อน (งานเทคนิคการแพทย์)	1	อัน	695.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1288	P230-001288	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ขาวางลำโพง	1	ชุด	420.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1289	P230-001289	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ฟิล์มยืด (งานแพทย์แผนไทย)	50	ม้วน	25.00	กลุ่มงานบริหารทั่วไป	50	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1290	P230-001290	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ชุดกรวยอิมฮอฟฟ์/กรวยตกตะกอน (Imhoff cone) ขนาด 1000 ml พร้อมขาตั้ง (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	0	ชุุด	8185.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1291	P230-001291	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ชุดทดสอบโคลิฟอร์มแบคทีเรีย (SI-2) (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	5	กล่อง	1000.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1292	P230-001292	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	น้ำยาตรวจเชื้อโคลิฟอร์มแบคทีเรียขั้นต้นในน้ำและน้ำแข็ง (อ11) (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	5	กล่อง	1000.00	กลุ่มงานบริหารทั่วไป	5	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1293	P230-001293	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	คลอรีนน้ำ ขนาด 20 กิโลกรัม (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	10	ถัง	760.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1294	P230-001294	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	คลอรีนผง 65% ขนาด 50 กิโลกรัม (กลุ่มงานบริการด้านปฐมภูมิและองค์รวม)	10	ถัง	4200.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1295	P230-001295	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	USB RJ45 extension	0	ชุด	290.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1296	P230-001296	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ผ้าใบ สำหรับคลุมเต้นท์จั่ว ขนาด 5x12 เมตร	0	ผืน	21892.20	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1297	P230-001297	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ท่อเป่าปอดแกนกระดาษสำหรับเครื่องเป่าปอด	0	ชิ้น	6.50	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1298	P230-001298	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้ายบอกตำแหน่งถังดับเพลิง ขนาด 15 x 15 x 30 ซม. แบบพับ มองเห็นได้ทั้ง 2 ด้าน	0	ชิ้น	485.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
11	P230-000011	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ลูกยางกดน้ำมัน สำหรับเครื่องตัดหญ้า	0	ลูก	50.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
12	P230-000012	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	โซ่ สำหรับเลื่อยยนต์ ขนาด 11.5 นิ้ว	3	เส้น	630.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
13	P230-000013	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	กรรไกร ชนิดตัดต้นไม้ต่ำ สำหรับตัดแต่งกิ่ง	4	อัน	300.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3365	P230-000596	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	หนังสือ มาตรฐานโรงพยาบาลและบริการสุขภาพ ฉบับที่ 5	5	เล่ม	500.00	กลุ่มการพยาบาล	5	2569	2	2026-03-11 07:54:18.954205	2026-03-11 07:54:18.954205	0011
3367	P230-000108	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบอเนกประสงค์ เบอร์ L	5	คู่	45.00	กลุ่มงานบริหารทั่วไป	5	2569	2	2026-03-11 13:56:23.966474	2026-03-11 13:56:23.966474	0001
34	P230-000034	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet L5190 สีเหลือง	0	กล่อง	350.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3368	P230-000103	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ L	10	คู่	120.00	กลุ่มงานบริหารทั่วไป	10	2569	2	2026-03-11 13:57:00.587993	2026-03-11 22:12:33.212047	0001
40	P230-000040	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Laser 107A	90	กล่อง	990.00	กลุ่มงานบริหารทั่วไป	90	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
56	P230-000056	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	ยกเลิก หัว LAN ชนิด CAT5 10 อัน/pack	0	pack	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3369	P230-000003	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ประกับ สำหรับเครื่องตัดหญ้า	1	อัน	230.00	งานอุบัติเหตุฉุกเฉิน	1	2569	1	2026-03-11 21:34:43.767598	2026-03-11 21:34:43.767598	0014
3371	P230-000643	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	ผ้าสี่เหลียม 2 ชั้น ผ้าฟอกขาว ผ้าสี่เหลี่ยม 2 ชั้น ผ้าฟอกขาวมุมสีม่วง 16"x16" (Supply) ขนาด 16"x16" มุมสีม่วง	5	ผืน	30.00	กลุ่มงานทันตกรรม	5	2569	1	2026-03-12 21:23:16.252535	2026-03-12 21:23:16.252535	0003
77	P230-000077	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ข่า	0	กิโลกรัม	60.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3370	P230-000002	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ด้ามขวาน ชนิดไม้	1	อัน	100.00	ทัณฑสถานหญิง	1	2569	1	2026-03-11 21:34:43.775513	2026-03-11 21:34:43.775513	0027
3372	P230-000085	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เตา Hotplate แบบใช้ไฟฟ้า ขนาด 9 นิ้ว	2	ตัว	4000.00	กลุ่มงานบริหารทั่วไป	2	2569	2	2026-03-12 21:23:16.300536	2026-03-12 21:23:16.300536	0001
3359	P230-001329	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	แผ่นโฟมจิ๊กซอว์ แบบ ก-ฮ ขนาด 29*29 ซม. (PCU วังทอง)	1	ชุด	390.00	กลุ่มการพยาบาล	1	2569	2	2026-03-11 07:33:32.500566	2026-03-12 22:24:19.372429	0011
3374	P230-000104	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ M	10	คู่	120.00	กลุ่มการพยาบาล	10	2569	1	2026-03-12 23:21:01.111498	2026-03-12 23:21:01.111498	0011
145	P230-000145	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ไฟแช็ค	0	อัน	10.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3375	P230-000104	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ถุงมือ ชนิดยาง แบบรัดข้อ เบอร์ M	10	คู่	120.00	กลุ่มการพยาบาล	10	2569	2	2026-03-12 23:21:01.141327	2026-03-12 23:39:30.779444	0011
3358	P230-001329	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	แผ่นโฟมจิ๊กซอว์ แบบ ก-ฮ ขนาด 29*29 ซม. (PCU วังทอง)	1	ชุด	390.00	กลุ่มการพยาบาล	0	2569	1	2026-03-11 07:33:19.065882	2026-03-12 23:43:01.013603	0011
532	P230-000532	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	พลาสติกใส แบบยืด	2	ม้วน	25.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
575	P230-000575	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	สมุด สำหรับประจำตัวผู้ป่วยโรคปอด	20	เล่ม	30.00	กลุ่มงานบริหารทั่วไป	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
800	P230-000800	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	กิ๊บ ชนิดทองเหลือง สำหรับรัดท่อ	8	อัน	3.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1136	P230-001136	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เบรคเกอร์ ขนาด 60A	0	อัน	650.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
990	P230-000990	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย	เสื้อผู้ป่วยแขนสั้น ชนิดกระดุมหรือเชือกผูก แบบผ่าหลัง	0	ตัว	400.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1031	P230-001031	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	สีน้ำมัน สีทองคำ	0	กระป๋อง	385.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1277	P230-001277	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตะแกรงใสของอเนกประสงค์ ขนาด 24*33.5*9 ซม. (งานเภสัชกรรม)	30	ชุด	49.00	กลุ่มงานบริหารทั่วไป	30	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1278	P230-001278	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตะแกรงใสของอเนกประสงค์ ขนาด 25.5*37.5*14.5 ซม. (งานเภสัชกรรม)	10	ชุด	59.00	กลุ่มงานบริหารทั่วไป	10	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1279	P230-001279	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	ตู้ลิ้นชักพลาสติก แบบ 4 ชั้น ขนาด 40*50*104 ซม. (งานเภสัชกรรม)	1	ชุด	170.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1243	P230-001243	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ-งบหน่วยงาน	สายรัด NST	0	อัน	1380.00	งานห้องคลอด	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018
1299	P230-001299	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ถังดับเพลิง ชนิดเหลวระเหย BF2000 ขนาด 15 lbs	0	ชิ้น	4495.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1300	P230-001300	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้ายวิธีการใช้ถังดับเพลิง แบบอลูมิเนียม ขนาด 30 x 45 ซม.	0	ชิ้น	785.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1301	P230-001301	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยาล้างห้องน้ำ ขนาด 3.5 ลิตร	0	แกลลอน	180.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1302	P230-001302	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	น้ำยาล้างห้องน้ำ ขนาด 900 ซีซี	0	ขวด	55.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1304	P230-001304	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สาย THW ขนาด 1*2.5 สีดำ	0	เมตร	13.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1305	P230-001305	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สาย THW ขนาด 1*2.5 สีเขียว	0	เมตร	15.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1310	P230-001310	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ซิลิโคน แบบมีกรด ขนาด 300 มล.	0	หลอด	199.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1311	P230-001311	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้ายบอกทางหนีไฟ ขนาด 20 x 30 ซม.	0	ป้าย	300.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1312	P230-001312	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้ายจุดรวมพล ขนาด 80 x 100 ซม.	0	ป้าย	6900.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1313	P230-001313	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	สาย VGA to VGA ยาว 5 เมตร	0	เส้น	250.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1314	P230-001314	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ตะกร้าล้อลาก สำหรับใส่ผ้า ขนาด 51*39*63.5  cm	3	อัน	350.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1315	P230-001315	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ไส้กรองน้ำเรซิน (งานจ่ายกลาง)	12	อัน	1200.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1316	P230-001316	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ไส้กรองน้ำคาร์บอน (งานจ่ายกลาง)	12	อัน	1200.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1317	P230-001317	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ไส้กรอง PP20 (งานจ่ายกลาง)	28	อัน	1200.00	กลุ่มงานบริหารทั่วไป	28	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1318	P230-001318	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	ฟิวเตอร์งเมมเบรนกรองน้ำ RO (งานจ่ายกลาง)	6	อัน	1200.00	กลุ่มงานบริหารทั่วไป	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1319	P230-001319	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ที่วัดลมยาง	2	อัน	600.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1320	P230-001320	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	น้ำยาเคลือบเงารถ	18	อัน	300.00	กลุ่มงานบริหารทั่วไป	18	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1321	P230-001321	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	น้ำยาเช็ดรถ	18	อัน	300.00	กลุ่มงานบริหารทั่วไป	18	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1322	P230-001322	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ผ้าเช็ดรถ	24	อัน	120.00	กลุ่มงานบริหารทั่วไป	24	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1323	P230-001323	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ฟองน้ำล้างรถ	12	อัน	120.00	กลุ่มงานบริหารทั่วไป	12	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1325	P230-001325	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	เสียม ชนิดเหล็ก แบบด้ามไม้ ขนาด 2 นิ้ว	2	อัน	350.00	กลุ่มงานบริหารทั่วไป	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1326	P230-001326	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ตะไบสามเหลี่ยม	3	อัน	350.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1327	P230-001327	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	บาร์เลท่อย ขนาด 11.5 นิ้ว	3	อัน	350.00	กลุ่มงานบริหารทั่วไป	3	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1328	P230-001328	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	แผ่นโฟมจิ๊กซอว์ แบบ ABC ขนาด 29*29 ซม. (PCU วังทอง)	0	ชุด	310.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
685	P230-000685	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ชั้นอเนกประสงค์ ชนิดตะแกรงเหล็ก แบบ 4 ชั้น ขนาด 90 x 45 x 160 ซม.	0	อัน	1780.00	งานผู้ป่วยนอก	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013
686	P230-000686	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ชั้นอเนกประสงค์ แบบ 4 ชั้น ขนาด 42 ซม.	0	อัน	488.00	งานผู้ป่วยนอก	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013
687	P230-000687	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ที่วัดส่วนสูง แบบมีฐาน ขนาด 200 ซม.	1	ชุด	1750.00	งานผู้ป่วยนอก	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013
688	P230-000688	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีหูหิ้ว ฝาปิดระบบล็อก 2 ด้าน ความจุ 19 ลิตร ขนาด 38.5 x 26 x 22 ซม.	0	ใบ	240.00	งานผู้ป่วยนอก	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013
689	P230-000689	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง-งบหน่วยงาน	บันได ชนิดอลูมีเนียม แบบ 8 ขั้น	0	อัน	2550.00	งานผู้ป่วยนอก	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0013
690	P230-000690	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถังขยะ ชนิดพลาสติก แบบฝาปิด ขนาด 50 ลิตร	0	ถัง	2150.00	งานผู้ป่วยในชาย	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016
691	P230-000691	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถังขยะ ชนิดพลาสติก แบบฝาปิด ขนาด 40 ลิตร	0	ถัง	1700.00	งานผู้ป่วยในชาย	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016
692	P230-000692	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 35 ลิตร	0	ใบ	750.00	งานผู้ป่วยในชาย	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016
693	P230-000693	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 18 ลิตร	0	ใบ	500.00	งานผู้ป่วยในชาย	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016
694	P230-000694	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถังขยะ ชนิดพลาสติก ทรงสูง แบบมีล้อและมีฝา ขนาด 120 ลิตร	0	ใบ	1800.00	งานผู้ป่วยในชาย	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0016
679	P230-000679	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถังขยะ ชนิดพลาสติก แบบเท้าเหยียบ ขนาด 60 ลิตร	4	ถัง	995.00	งานผู้ป่วยในหญิงและเด็ก	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017
680	P230-000680	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ถังขยะ ชนิดพลาสติก ขนาด 60 ลิตร	0	ถัง	950.00	งานผู้ป่วยในหญิงและเด็ก	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017
681	P230-000681	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	พรมเช็ดเท้า แบบดักฝุ่น	2	ผืน	350.00	งานผู้ป่วยในหญิงและเด็ก	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017
682	P230-000682	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ฉากกันห้อง แบบครึ่งกระจกใส ขัดลาย ขนาด 80*160 ซม.	0	ชุด	5500.00	งานผู้ป่วยในหญิงและเด็ก	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017
683	P230-000683	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	กล่องอเนกประสงค์ ชนิดพลาสติก แบบมีหูหิ้ว ฝาปิดระบบล็อก 2 ด้าน ความจุ 19 ลิตร ขนาด 38.5 x 26 x 22 ซม.	0	ใบ	250.00	งานผู้ป่วยในหญิงและเด็ก	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017
684	P230-000684	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ตู้อเนกประสงค์ ชนิดพลาสติก แบบ 5 ชั้น ขนาด 17.5 × 24.5 × 27 ซม	0	อัน	475.00	งานผู้ป่วยในหญิงและเด็ก	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0017
695	P230-000695	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	กระดาษโน๊ต แบบมีกาว ขนาด 3x3 นิ้ว	0	แพ็ค	30.00	งานแพทย์แผนไทย	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0008
696	P230-000696	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	กระดาษโน๊ต แบบมีกาว ขนาด 0.8x3 นิ้ว	0	แพ็ค	25.00	งานแพทย์แผนไทย	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0008
697	P230-000697	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	รองเท้า ชนิดผ้ารังผึ้ง แบบ Slippers	20	คู่	110.00	งานแพทย์แผนไทย	20	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0008
698	P230-000698	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	พรมเช็ดเท้า ขนาด 45*70 ซม.	6	ผืน	499.00	งานแพทย์แผนไทย	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0008
699	P230-000699	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	พรมเช็ดเท้า ขนาด 45*120 ซม.	6	ผืน	830.00	งานแพทย์แผนไทย	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0008
675	P230-000675	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ตรายาง สำหรับปั๊มเจาะเลือดประจำปีผู้ป่วย	4	อัน	150.00	งานโรคไม่ติดต่อเรื้อรัง	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0015
676	P230-000676	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ตรายาง สำหรับปั๊มโทรเลื่อนนัด	0	อัน	180.00	งานโรคไม่ติดต่อเรื้อรัง	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0015
677	P230-000677	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ตรายาง สำหรับปั๊มบันทึกกิจกรรมในผู้ป่วยCOPD/Asthma	0	อัน	200.00	งานโรคไม่ติดต่อเรื้อรัง	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0015
678	P230-000678	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ตรายาง สำหรับปั๊มแนะนำสำหรับการเตรียมตัวเจาะเลือด	4	อัน	100.00	งานโรคไม่ติดต่อเรื้อรัง	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0015
3331	P230-001324	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ที่รีดกระจกสำหรับรถยนต์	10	อัน	120.00	งานโรคไม่ติดต่อเรื้อรัง	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0015
1239	P230-001239	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	กระดิ่งไร้สายแบบเสียบปลั๊ก	2	อัน	890.00	งานห้องคลอด	2	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018
1240	P230-001240	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	กล่องเครื่องมือ 30ช่อง	0	อัน	750.00	งานห้องคลอด	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018
1241	P230-001241	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ-งบหน่วยงาน	ฟิล์มสูญกาศพิมพ์ลาย	6	ชุด	500.00	งานห้องคลอด	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018
1242	P230-001242	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	หมอนหนุนศรีษะสำหรับผู้ป่วย	0	อัน	400.00	งานห้องคลอด	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018
1244	P230-001244	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	หมอนให้นมบุตร	0	อัน	300.00	งานห้องคลอด	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0018
1235	P230-001235	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว-งบหน่วยงาน	ชุดถ้วยกาแฟ	6	ชุด	139.00	ศูนย์คุณภาพ	6	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0012
1236	P230-001236	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	กล่องเก็บของ	4	อัน	419.00	ศูนย์คุณภาพ	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0012
1237	P230-001237	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน-งบหน่วยงาน	ตระกร้าผ้าเหลี่ยมมีฝาหูหิ้ว	4	อัน	329.00	ศูนย์คุณภาพ	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0012
1238	P230-001238	วัสดุใช้ไป	วัสดุโฆษณาและเผยแพร่	วัสดุโฆษณาและเผยแพร่-งบหน่วยงาน	USB MP3 รวมเพลงฮิต	4	อัน	299.00	ศูนย์คุณภาพ	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0012
26	P230-000026	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	สาย LAN	1	กล่อง	0.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:45:24.714332	0001
27	P230-000027	วัสดุใช้ไป	วัสดุคอมพิวเตอร์	วัสดุคอมพิวเตอร์	หมึก Printer Ink jet GT53 สีดำ	1	ขวด	0.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:45:24.714332	0001
3330	P230-001312	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ป้ายจุดรวมพล ขนาด 80 x 100 ซม.	1	ป้าย	6900.00	กลุ่มงานบริหารทั่วไป	1	2569	\N	2026-03-06 14:26:06.795182	2026-03-06 14:45:24.714332	0001
3332	P230-001232	วัสดุใช้ไป	วัสดุสิ่งทอและเครื่องแต่งกาย	วัสดุสิ่งทอและเครื่องแต่งกาย-งบหน่วยงาน	เสื้อกาวน์ยาว	1	ตัว	0.00	กลุ่มงานเทคนิคการแพทย์	2	2569	2	2026-03-06 14:39:47.78097	2026-03-06 14:50:24.02258	0002
3333	P230-001324	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	ที่รีดกระจกสำหรับรถยนต์	1	อัน	120.00	งานผู้ป่วยนอก	1	2569	1	2026-03-06 14:51:10.023273	2026-03-06 14:51:10.023273	0013
1329	P230-001329	วัสดุใช้ไป	วัสดุอื่นๆ	วัสดุอื่นๆ	แผ่นโฟมจิ๊กซอว์ แบบ ก-ฮ ขนาด 29*29 ซม. (PCU วังทอง)	1	ชุด	0.00	กลุ่มงานบริหารทั่วไป	1	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:54:40.404744	0001
735	P230-000735	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เทอมินอล สำหรับต่อสายไฟ	0	อัน	4.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
788	P230-000788	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	เบรคเกอร์ ขนาด 20A	4	อัน	125.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
5	P230-000005	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	สายเอ็น สำหรับเครื่องตัดหญ้า	4	ม้วน	630.00	กลุ่มงานบริหารทั่วไป	4	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
6	P230-000006	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	เข่ง ไม้ไผ่	8	ใบ	120.00	กลุ่มงานบริหารทั่วไป	8	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
7	P230-000007	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ครัช สำหรับเครื่องตัดหญ้า	0	อัน	680.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
8	P230-000008	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ถ้วยรองใบมีด สำหรับเครื่องตัดหญ้า	0	อัน	480.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1206	P230-001206	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	คาปาซิเตอร์ ขนาด 16UF 450V	0	อัน	430.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1306	P230-001306	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	หัวแจ๊คตัวผู้ ขนาด 3.5 มม/4 pole	0	ตัว	20.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1307	P230-001307	วัสดุใช้ไป	วัสดุไฟฟ้า	วัสดุไฟฟ้า	สวิทช์ควบคุมการไหลของปั๊มน้ำ	0	ตัว	1050.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1308	P230-001308	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ยางมะตอย แบบสำเร็จรูป	0	ถุง	89.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
1309	P230-001309	วัสดุใช้ไป	วัสดุช่างและก่อสร้าง	วัสดุช่างและก่อสร้าง	ผงย่อยจุลินทรีย์ สำหรับสุขภัณฑ์	0	ถุง	189.00	กลุ่มงานบริหารทั่วไป	0	2569	1	2026-03-06 14:26:06.795182	2026-03-06 14:28:59.901955	0001
3349	P230-000063	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	กระดาษชำระ ชนิดม้วน แบบ 2 ชั้น ขนาดยาว 300 เมตร	50	ม้วน	65.00	กลุ่มงานทันตกรรม	10	2569	1	2026-03-11 00:29:45.838887	2026-03-14 07:21:32.942705	0003
3376	P230-000011	วัสดุใช้ไป	วัสดุการเกษตร	วัสดุการเกษตร	ลูกยางกดน้ำมัน สำหรับเครื่องตัดหญ้า	1	ลูก	50.00	กลุ่มงานบริหารทั่วไป	1	2569	2	2026-03-14 08:01:55.905645	2026-03-14 08:01:55.905645	0001
3378	P230-000085	วัสดุใช้ไป	วัสดุงานบ้านงานครัว	วัสดุงานบ้านงานครัว	เตา Hotplate แบบใช้ไฟฟ้า ขนาด 9 นิ้ว	1	ตัว	4000.00	กลุ่มงานเภสัชกรรม	1	2569	1	2026-03-14 08:02:50.332027	2026-03-14 08:02:50.332027	0004
3381	P230-000343	วัสดุใช้ไป	วัสดุบริโภค	วัสดุบริโภค	น้ำหวาน สำหรับผู้ป่วยเบาหวาน สีแดง	21	ขวด	65.00	กลุ่มงานบริหารทั่วไป	21	2569	2	2026-03-15 10:33:23.65314	2026-03-15 10:33:23.65314	0001
3382	P230-000432	วัสดุใช้ไป	วัสดุสำนักงาน	วัสดุสำนักงาน	กระดาษกาวย่น แบบม้วน ขนาดกว้าง 1/2 นิ้ว 36x20 หลา	20	ม้วน	20.00	กลุ่มงานบริหารทั่วไป	20	2569	2	2026-03-15 10:53:41.191553	2026-03-15 10:53:41.191553	0001
\.


--
-- Data for Name: messages_2026_03_12; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_03_12 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_13; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_03_13 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_14; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_03_14 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_15; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_03_15 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_16; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_03_16 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_17; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_03_17 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_18; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_03_18 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-13 00:36:30
20211116045059	2026-03-13 00:36:30
20211116050929	2026-03-13 00:36:30
20211116051442	2026-03-13 00:36:30
20211116212300	2026-03-13 00:36:30
20211116213355	2026-03-13 00:36:30
20211116213934	2026-03-13 00:36:30
20211116214523	2026-03-13 00:36:30
20211122062447	2026-03-13 00:36:30
20211124070109	2026-03-13 00:36:30
20211202204204	2026-03-13 00:36:30
20211202204605	2026-03-13 00:36:30
20211210212804	2026-03-13 00:36:30
20211228014915	2026-03-13 00:36:30
20220107221237	2026-03-13 00:36:30
20220228202821	2026-03-13 00:36:30
20220312004840	2026-03-13 00:36:30
20220603231003	2026-03-13 00:36:30
20220603232444	2026-03-13 00:36:30
20220615214548	2026-03-13 00:36:30
20220712093339	2026-03-13 00:36:30
20220908172859	2026-03-13 00:36:30
20220916233421	2026-03-13 00:36:30
20230119133233	2026-03-13 00:36:30
20230128025114	2026-03-13 00:36:30
20230128025212	2026-03-13 00:36:30
20230227211149	2026-03-13 00:36:30
20230228184745	2026-03-13 00:36:30
20230308225145	2026-03-13 00:36:30
20230328144023	2026-03-13 00:36:30
20231018144023	2026-03-13 00:36:30
20231204144023	2026-03-13 00:36:30
20231204144024	2026-03-13 00:36:30
20231204144025	2026-03-13 00:36:30
20240108234812	2026-03-13 00:36:30
20240109165339	2026-03-13 00:36:30
20240227174441	2026-03-13 00:36:30
20240311171622	2026-03-13 00:36:30
20240321100241	2026-03-13 00:36:30
20240401105812	2026-03-13 00:36:30
20240418121054	2026-03-13 00:36:30
20240523004032	2026-03-13 00:36:30
20240618124746	2026-03-13 00:36:30
20240801235015	2026-03-13 00:36:30
20240805133720	2026-03-13 00:36:30
20240827160934	2026-03-13 00:36:30
20240919163303	2026-03-13 00:36:30
20240919163305	2026-03-13 00:36:30
20241019105805	2026-03-13 00:36:31
20241030150047	2026-03-13 00:36:31
20241108114728	2026-03-13 00:36:31
20241121104152	2026-03-13 00:36:31
20241130184212	2026-03-13 00:36:31
20241220035512	2026-03-13 00:36:31
20241220123912	2026-03-13 00:36:31
20241224161212	2026-03-13 00:36:31
20250107150512	2026-03-13 00:36:31
20250110162412	2026-03-13 00:36:31
20250123174212	2026-03-13 00:36:31
20250128220012	2026-03-13 00:36:31
20250506224012	2026-03-13 00:36:31
20250523164012	2026-03-13 00:36:31
20250714121412	2026-03-13 00:36:31
20250905041441	2026-03-13 00:36:31
20251103001201	2026-03-13 00:36:31
20251120212548	2026-03-13 00:36:31
20251120215549	2026-03-13 00:36:31
20260218120000	2026-03-13 00:36:31
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_namespaces (id, bucket_name, name, created_at, updated_at, metadata, catalog_id) FROM stdin;
\.


--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_tables (id, namespace_id, bucket_name, name, location, created_at, updated_at, remote_table_id, shard_key, shard_id, catalog_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-13 00:36:33.887611
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-13 00:36:33.894268
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-13 00:36:33.897078
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-13 00:36:33.904299
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-13 00:36:33.908817
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-13 00:36:33.911308
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-13 00:36:33.915146
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-13 00:36:33.918
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-13 00:36:33.920643
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-13 00:36:33.922958
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-13 00:36:33.926072
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-13 00:36:33.929014
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-13 00:36:33.93238
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-13 00:36:33.935704
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-13 00:36:33.93881
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-13 00:36:33.948159
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-13 00:36:33.950985
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-13 00:36:33.953744
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-13 00:36:33.956004
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-13 00:36:33.959011
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-13 00:36:33.961753
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-13 00:36:33.966457
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-13 00:36:33.971905
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-13 00:36:33.976859
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-13 00:36:33.979698
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-13 00:36:33.982766
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-13 00:36:33.985223
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-13 00:36:33.988066
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-13 00:36:33.990354
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-13 00:36:33.993103
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-13 00:36:33.995303
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-13 00:36:33.998048
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-13 00:36:34.000223
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-13 00:36:34.002933
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-13 00:36:34.005316
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-13 00:36:34.007934
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-13 00:36:34.009966
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-13 00:36:34.012513
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-13 00:36:34.015159
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-13 00:36:34.023926
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-13 00:36:34.026112
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-13 00:36:34.028642
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-13 00:36:34.03071
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-13 00:36:34.033309
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-13 00:36:34.03534
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-13 00:36:34.038834
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-13 00:36:34.043089
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-13 00:36:34.04598
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-13 00:36:34.048527
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-13 00:36:34.06228
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-13 00:36:34.064903
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-13 00:36:34.076874
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-03-13 00:36:34.07902
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-13 00:36:34.082878
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-13 00:36:34.085333
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-13 00:36:34.087298
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-03-13 00:36:34.09065
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2026-03-13 00:36:20.214136+00
20210809183423_update_grants	2026-03-13 00:36:20.214136+00
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: Category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Category_id_seq"', 281, true);


--
-- Name: Department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Department_id_seq"', 48, true);


--
-- Name: Product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Product_id_seq"', 1, false);


--
-- Name: PurchaseApprovalInventoryLink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PurchaseApprovalInventoryLink_id_seq"', 49, true);


--
-- Name: PurchasePlan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PurchasePlan_id_seq"', 39, true);


--
-- Name: Seller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Seller_id_seq"', 5, true);


--
-- Name: Survey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Survey_id_seq"', 3382, true);


--
-- Name: inventory_adjustment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_adjustment_id_seq', 1, false);


--
-- Name: inventory_adjustment_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_adjustment_item_id_seq', 1, false);


--
-- Name: inventory_balance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_balance_id_seq', 229, true);


--
-- Name: inventory_issue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_issue_id_seq', 6, true);


--
-- Name: inventory_issue_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_issue_item_id_seq', 8, true);


--
-- Name: inventory_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_item_id_seq', 229, true);


--
-- Name: inventory_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_location_id_seq', 1, false);


--
-- Name: inventory_movement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_movement_id_seq', 33, true);


--
-- Name: inventory_period_balance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_period_balance_id_seq', 1, false);


--
-- Name: inventory_period_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_period_id_seq', 1, false);


--
-- Name: inventory_receipt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_receipt_id_seq', 11, true);


--
-- Name: inventory_receipt_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_receipt_item_id_seq', 1, true);


--
-- Name: inventory_requisition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_requisition_id_seq', 10, true);


--
-- Name: inventory_requisition_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_requisition_item_id_seq', 13, true);


--
-- Name: inventory_warehouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_warehouse_id_seq', 1, true);


--
-- Name: purchase_approval_approval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_approval_approval_id_seq', 102, true);


--
-- Name: purchase_approval_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_approval_detail_id_seq', 49, true);


--
-- Name: purchase_approval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_approval_id_seq', 58, true);


--
-- Name: test_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_data_id_seq', 10, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: department Department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT "Department_pkey" PRIMARY KEY (id);


--
-- Name: inventory_adjustment_item InventoryAdjustmentItem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_item
    ADD CONSTRAINT "InventoryAdjustmentItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_adjustment InventoryAdjustment_adjustmentNo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment
    ADD CONSTRAINT "InventoryAdjustment_adjustmentNo_key" UNIQUE (adjustment_no);


--
-- Name: inventory_adjustment InventoryAdjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment
    ADD CONSTRAINT "InventoryAdjustment_pkey" PRIMARY KEY (id);


--
-- Name: inventory_balance InventoryBalance_inventoryItemId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_balance
    ADD CONSTRAINT "InventoryBalance_inventoryItemId_key" UNIQUE (inventory_item_id);


--
-- Name: inventory_balance InventoryBalance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_balance
    ADD CONSTRAINT "InventoryBalance_pkey" PRIMARY KEY (id);


--
-- Name: inventory_issue_item InventoryIssueItem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue_item
    ADD CONSTRAINT "InventoryIssueItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_issue InventoryIssue_issueNo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue
    ADD CONSTRAINT "InventoryIssue_issueNo_key" UNIQUE (issue_no);


--
-- Name: inventory_issue InventoryIssue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue
    ADD CONSTRAINT "InventoryIssue_pkey" PRIMARY KEY (id);


--
-- Name: inventory_item InventoryItem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT "InventoryItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_location InventoryLocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_location
    ADD CONSTRAINT "InventoryLocation_pkey" PRIMARY KEY (id);


--
-- Name: inventory_movement InventoryMovement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movement
    ADD CONSTRAINT "InventoryMovement_pkey" PRIMARY KEY (id);


--
-- Name: inventory_period_balance InventoryPeriodBalance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_period_balance
    ADD CONSTRAINT "InventoryPeriodBalance_pkey" PRIMARY KEY (id);


--
-- Name: inventory_period InventoryPeriod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_period
    ADD CONSTRAINT "InventoryPeriod_pkey" PRIMARY KEY (id);


--
-- Name: inventory_receipt_item InventoryReceiptItem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_receipt_item
    ADD CONSTRAINT "InventoryReceiptItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_receipt InventoryReceipt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_receipt
    ADD CONSTRAINT "InventoryReceipt_pkey" PRIMARY KEY (id);


--
-- Name: inventory_receipt InventoryReceipt_receiptNo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_receipt
    ADD CONSTRAINT "InventoryReceipt_receiptNo_key" UNIQUE (receipt_no);


--
-- Name: inventory_requisition_item InventoryRequisitionItem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_requisition_item
    ADD CONSTRAINT "InventoryRequisitionItem_pkey" PRIMARY KEY (id);


--
-- Name: inventory_requisition InventoryRequisition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_requisition
    ADD CONSTRAINT "InventoryRequisition_pkey" PRIMARY KEY (id);


--
-- Name: inventory_requisition InventoryRequisition_requisitionNo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_requisition
    ADD CONSTRAINT "InventoryRequisition_requisitionNo_key" UNIQUE (requisition_no);


--
-- Name: inventory_warehouse InventoryWarehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_warehouse
    ADD CONSTRAINT "InventoryWarehouse_pkey" PRIMARY KEY (id);


--
-- Name: inventory_warehouse InventoryWarehouse_warehouseCode_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_warehouse
    ADD CONSTRAINT "InventoryWarehouse_warehouseCode_key" UNIQUE (warehouse_code);


--
-- Name: product Product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "Product_pkey" PRIMARY KEY (id);


--
-- Name: purchase_approval_inventory_link PurchaseApprovalInventoryLink_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_inventory_link
    ADD CONSTRAINT "PurchaseApprovalInventoryLink_pkey" PRIMARY KEY (id);


--
-- Name: purchase_plan PurchasePlan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_plan
    ADD CONSTRAINT "PurchasePlan_pkey" PRIMARY KEY (id);


--
-- Name: seller Seller_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT "Seller_pkey" PRIMARY KEY (id);


--
-- Name: usage_plan Survey_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usage_plan
    ADD CONSTRAINT "Survey_pkey" PRIMARY KEY (id);


--
-- Name: department department_department_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_department_code_key UNIQUE (department_code);


--
-- Name: inventory_location inventory_location_warehouse_id_location_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_location
    ADD CONSTRAINT inventory_location_warehouse_id_location_code_key UNIQUE (warehouse_id, location_code);


--
-- Name: inventory_period_balance inventory_period_balance_unique_item_per_period; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_period_balance
    ADD CONSTRAINT inventory_period_balance_unique_item_per_period UNIQUE (period_id, inventory_item_id);


--
-- Name: inventory_period inventory_period_unique_period; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_period
    ADD CONSTRAINT inventory_period_unique_period UNIQUE (period_year, period_month);


--
-- Name: purchase_approval purchase_approval_approve_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval
    ADD CONSTRAINT purchase_approval_approve_code_key UNIQUE (approve_code);


--
-- Name: purchase_approval_detail purchase_approval_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_detail
    ADD CONSTRAINT purchase_approval_detail_pkey PRIMARY KEY (id);


--
-- Name: purchase_approval_detail purchase_approval_detail_unique_plan_per_approval; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_detail
    ADD CONSTRAINT purchase_approval_detail_unique_plan_per_approval UNIQUE (purchase_approval_id, purchase_plan_id);


--
-- Name: purchase_approval purchase_approval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval
    ADD CONSTRAINT purchase_approval_pkey PRIMARY KEY (id);


--
-- Name: purchase_plan purchase_plan_usage_plan_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_plan
    ADD CONSTRAINT purchase_plan_usage_plan_id_key UNIQUE (usage_plan_id);


--
-- Name: test_data test_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_data
    ADD CONSTRAINT test_data_pkey PRIMARY KEY (id);


--
-- Name: usage_plan usage_plan_composite_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usage_plan
    ADD CONSTRAINT usage_plan_composite_unique UNIQUE (product_code, budget_year, requesting_dept, sequence_no);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_12 messages_2026_03_12_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_12
    ADD CONSTRAINT messages_2026_03_12_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_13 messages_2026_03_13_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_13
    ADD CONSTRAINT messages_2026_03_13_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_14 messages_2026_03_14_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_14
    ADD CONSTRAINT messages_2026_03_14_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_15 messages_2026_03_15_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_15
    ADD CONSTRAINT messages_2026_03_15_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_16 messages_2026_03_16_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_16
    ADD CONSTRAINT messages_2026_03_16_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_17 messages_2026_03_17_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_17
    ADD CONSTRAINT messages_2026_03_17_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_18 messages_2026_03_18_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_18
    ADD CONSTRAINT messages_2026_03_18_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: iceberg_namespaces iceberg_namespaces_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_pkey PRIMARY KEY (id);


--
-- Name: iceberg_tables iceberg_tables_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: Product_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Product_code_key" ON public.product USING btree (code);


--
-- Name: Seller_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Seller_code_key" ON public.seller USING btree (code);


--
-- Name: Survey_budget_dept_product_sequence_uidx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Survey_budget_dept_product_sequence_uidx" ON public.usage_plan USING btree (budget_year, requesting_dept, product_code, sequence_no);


--
-- Name: idx_purchase_approval_approve_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_approve_code ON public.purchase_approval USING btree (approve_code);


--
-- Name: idx_purchase_approval_budget_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_budget_year ON public.purchase_approval USING btree (budget_year);


--
-- Name: idx_purchase_approval_detail_purchase_approval_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_detail_purchase_approval_id ON public.purchase_approval_detail USING btree (purchase_approval_id);


--
-- Name: idx_purchase_approval_detail_purchase_plan_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_detail_purchase_plan_id ON public.purchase_approval_detail USING btree (purchase_plan_id);


--
-- Name: idx_purchase_approval_detail_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_detail_status ON public.purchase_approval_detail USING btree (status);


--
-- Name: idx_purchase_approval_doc_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_doc_date ON public.purchase_approval USING btree (doc_date);


--
-- Name: idx_purchase_approval_doc_no; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_doc_no ON public.purchase_approval USING btree (doc_no);


--
-- Name: idx_purchase_approval_inventory_link_detail_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_inventory_link_detail_id ON public.purchase_approval_inventory_link USING btree (purchase_approval_detail_id);


--
-- Name: idx_purchase_approval_inventory_link_detail_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_purchase_approval_inventory_link_detail_unique ON public.purchase_approval_inventory_link USING btree (purchase_approval_detail_id);


--
-- Name: idx_purchase_approval_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_approval_status ON public.purchase_approval USING btree (status);


--
-- Name: inventory_item_unique_product_wh_location_lot; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX inventory_item_unique_product_wh_location_lot ON public.inventory_item USING btree (product_code, warehouse_id, COALESCE(location_id, 0), COALESCE(lot_no, ''::text));


--
-- Name: inventory_movement_item_date_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX inventory_movement_item_date_idx ON public.inventory_movement USING btree (inventory_item_id, movement_date DESC);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_12_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_12_inserted_at_topic_idx ON realtime.messages_2026_03_12 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_13_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_13_inserted_at_topic_idx ON realtime.messages_2026_03_13 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_14_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_14_inserted_at_topic_idx ON realtime.messages_2026_03_14 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_15_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_15_inserted_at_topic_idx ON realtime.messages_2026_03_15 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_16_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_16_inserted_at_topic_idx ON realtime.messages_2026_03_16 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_17_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_17_inserted_at_topic_idx ON realtime.messages_2026_03_17 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_18_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_18_inserted_at_topic_idx ON realtime.messages_2026_03_18 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_iceberg_namespaces_bucket_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_namespaces_bucket_id ON storage.iceberg_namespaces USING btree (catalog_id, name);


--
-- Name: idx_iceberg_tables_location; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_tables_location ON storage.iceberg_tables USING btree (location);


--
-- Name: idx_iceberg_tables_namespace_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_tables_namespace_id ON storage.iceberg_tables USING btree (catalog_id, namespace_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2026_03_12_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_12_inserted_at_topic_idx;


--
-- Name: messages_2026_03_12_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_12_pkey;


--
-- Name: messages_2026_03_13_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_13_inserted_at_topic_idx;


--
-- Name: messages_2026_03_13_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_13_pkey;


--
-- Name: messages_2026_03_14_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_14_inserted_at_topic_idx;


--
-- Name: messages_2026_03_14_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_14_pkey;


--
-- Name: messages_2026_03_15_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_15_inserted_at_topic_idx;


--
-- Name: messages_2026_03_15_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_15_pkey;


--
-- Name: messages_2026_03_16_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_16_inserted_at_topic_idx;


--
-- Name: messages_2026_03_16_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_16_pkey;


--
-- Name: messages_2026_03_17_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_17_inserted_at_topic_idx;


--
-- Name: messages_2026_03_17_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_17_pkey;


--
-- Name: messages_2026_03_18_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_18_inserted_at_topic_idx;


--
-- Name: messages_2026_03_18_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_18_pkey;


--
-- Name: purchase_approval_detail purchase_approval_detail_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER purchase_approval_detail_updated_at BEFORE UPDATE ON public.purchase_approval_detail FOR EACH ROW EXECUTE FUNCTION public.update_purchase_approval_detail_updated_at();


--
-- Name: purchase_approval purchase_approval_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER purchase_approval_updated_at BEFORE UPDATE ON public.purchase_approval FOR EACH ROW EXECUTE FUNCTION public.update_purchase_approval_updated_at();


--
-- Name: purchase_approval trg_purchase_approval_budget_year; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_purchase_approval_budget_year BEFORE INSERT OR UPDATE OF doc_date ON public.purchase_approval FOR EACH ROW EXECUTE FUNCTION public.set_purchase_approval_budget_year();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: inventory_adjustment_item InventoryAdjustmentItem_adjustmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_item
    ADD CONSTRAINT "InventoryAdjustmentItem_adjustmentId_fkey" FOREIGN KEY (adjustment_id) REFERENCES public.inventory_adjustment(id) ON DELETE CASCADE;


--
-- Name: inventory_adjustment_item InventoryAdjustmentItem_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjustment_item
    ADD CONSTRAINT "InventoryAdjustmentItem_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_balance InventoryBalance_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_balance
    ADD CONSTRAINT "InventoryBalance_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE CASCADE;


--
-- Name: inventory_issue_item InventoryIssueItem_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue_item
    ADD CONSTRAINT "InventoryIssueItem_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_issue_item InventoryIssueItem_issueId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue_item
    ADD CONSTRAINT "InventoryIssueItem_issueId_fkey" FOREIGN KEY (issue_id) REFERENCES public.inventory_issue(id) ON DELETE CASCADE;


--
-- Name: inventory_issue_item InventoryIssueItem_requisitionItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue_item
    ADD CONSTRAINT "InventoryIssueItem_requisitionItemId_fkey" FOREIGN KEY (requisition_item_id) REFERENCES public.inventory_requisition_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_issue InventoryIssue_requisitionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_issue
    ADD CONSTRAINT "InventoryIssue_requisitionId_fkey" FOREIGN KEY (requisition_id) REFERENCES public.inventory_requisition(id) ON DELETE RESTRICT;


--
-- Name: inventory_item InventoryItem_locationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT "InventoryItem_locationId_fkey" FOREIGN KEY (location_id) REFERENCES public.inventory_location(id) ON DELETE SET NULL;


--
-- Name: inventory_item InventoryItem_warehouseId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT "InventoryItem_warehouseId_fkey" FOREIGN KEY (warehouse_id) REFERENCES public.inventory_warehouse(id) ON DELETE RESTRICT;


--
-- Name: inventory_location InventoryLocation_warehouseId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_location
    ADD CONSTRAINT "InventoryLocation_warehouseId_fkey" FOREIGN KEY (warehouse_id) REFERENCES public.inventory_warehouse(id) ON DELETE RESTRICT;


--
-- Name: inventory_movement InventoryMovement_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movement
    ADD CONSTRAINT "InventoryMovement_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_period_balance InventoryPeriodBalance_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_period_balance
    ADD CONSTRAINT "InventoryPeriodBalance_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_period_balance InventoryPeriodBalance_periodId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_period_balance
    ADD CONSTRAINT "InventoryPeriodBalance_periodId_fkey" FOREIGN KEY (period_id) REFERENCES public.inventory_period(id) ON DELETE CASCADE;


--
-- Name: inventory_receipt_item InventoryReceiptItem_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_receipt_item
    ADD CONSTRAINT "InventoryReceiptItem_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_receipt_item InventoryReceiptItem_receiptId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_receipt_item
    ADD CONSTRAINT "InventoryReceiptItem_receiptId_fkey" FOREIGN KEY (receipt_id) REFERENCES public.inventory_receipt(id) ON DELETE CASCADE;


--
-- Name: inventory_requisition_item InventoryRequisitionItem_inventoryItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_requisition_item
    ADD CONSTRAINT "InventoryRequisitionItem_inventoryItemId_fkey" FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE RESTRICT;


--
-- Name: inventory_requisition_item InventoryRequisitionItem_requisitionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_requisition_item
    ADD CONSTRAINT "InventoryRequisitionItem_requisitionId_fkey" FOREIGN KEY (requisition_id) REFERENCES public.inventory_requisition(id) ON DELETE CASCADE;


--
-- Name: purchase_approval_detail purchase_approval_detail_purchase_approval_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_detail
    ADD CONSTRAINT purchase_approval_detail_purchase_approval_id_fkey FOREIGN KEY (purchase_approval_id) REFERENCES public.purchase_approval(id) ON DELETE CASCADE;


--
-- Name: purchase_approval_detail purchase_approval_detail_purchase_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_detail
    ADD CONSTRAINT purchase_approval_detail_purchase_plan_id_fkey FOREIGN KEY (purchase_plan_id) REFERENCES public.purchase_plan(id) ON DELETE RESTRICT;


--
-- Name: purchase_approval_inventory_link purchase_approval_inventory_link_last_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_inventory_link
    ADD CONSTRAINT purchase_approval_inventory_link_last_receipt_id_fkey FOREIGN KEY (last_receipt_id) REFERENCES public.inventory_receipt(id) ON DELETE SET NULL;


--
-- Name: purchase_approval_inventory_link purchase_approval_inventory_link_purchase_approval_detail_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_approval_inventory_link
    ADD CONSTRAINT purchase_approval_inventory_link_purchase_approval_detail_id_fk FOREIGN KEY (purchase_approval_detail_id) REFERENCES public.purchase_approval_detail(id) ON DELETE CASCADE;


--
-- Name: purchase_plan purchase_plan_usage_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_plan
    ADD CONSTRAINT purchase_plan_usage_plan_id_fkey FOREIGN KEY (usage_plan_id) REFERENCES public.usage_plan(id) ON DELETE CASCADE;


--
-- Name: iceberg_namespaces iceberg_namespaces_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_namespace_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES storage.iceberg_namespaces(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_namespaces; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_namespaces ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_tables; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_tables ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION set_purchase_approval_budget_year(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_purchase_approval_budget_year() TO anon;
GRANT ALL ON FUNCTION public.set_purchase_approval_budget_year() TO authenticated;
GRANT ALL ON FUNCTION public.set_purchase_approval_budget_year() TO service_role;


--
-- Name: FUNCTION update_purchase_approval_detail_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_purchase_approval_detail_updated_at() TO anon;
GRANT ALL ON FUNCTION public.update_purchase_approval_detail_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.update_purchase_approval_detail_updated_at() TO service_role;


--
-- Name: FUNCTION update_purchase_approval_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_purchase_approval_updated_at() TO anon;
GRANT ALL ON FUNCTION public.update_purchase_approval_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.update_purchase_approval_updated_at() TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;


--
-- Name: TABLE category; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.category TO anon;
GRANT ALL ON TABLE public.category TO authenticated;
GRANT ALL ON TABLE public.category TO service_role;


--
-- Name: SEQUENCE "Category_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Category_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."Category_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."Category_id_seq" TO service_role;


--
-- Name: TABLE department; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.department TO anon;
GRANT ALL ON TABLE public.department TO authenticated;
GRANT ALL ON TABLE public.department TO service_role;


--
-- Name: SEQUENCE "Department_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Department_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."Department_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."Department_id_seq" TO service_role;


--
-- Name: TABLE product; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product TO anon;
GRANT ALL ON TABLE public.product TO authenticated;
GRANT ALL ON TABLE public.product TO service_role;


--
-- Name: SEQUENCE "Product_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Product_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."Product_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."Product_id_seq" TO service_role;


--
-- Name: TABLE purchase_approval_inventory_link; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.purchase_approval_inventory_link TO anon;
GRANT ALL ON TABLE public.purchase_approval_inventory_link TO authenticated;
GRANT ALL ON TABLE public.purchase_approval_inventory_link TO service_role;


--
-- Name: SEQUENCE "PurchaseApprovalInventoryLink_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."PurchaseApprovalInventoryLink_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."PurchaseApprovalInventoryLink_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."PurchaseApprovalInventoryLink_id_seq" TO service_role;


--
-- Name: TABLE purchase_plan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.purchase_plan TO anon;
GRANT ALL ON TABLE public.purchase_plan TO authenticated;
GRANT ALL ON TABLE public.purchase_plan TO service_role;


--
-- Name: SEQUENCE "PurchasePlan_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."PurchasePlan_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."PurchasePlan_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."PurchasePlan_id_seq" TO service_role;


--
-- Name: TABLE seller; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.seller TO anon;
GRANT ALL ON TABLE public.seller TO authenticated;
GRANT ALL ON TABLE public.seller TO service_role;


--
-- Name: SEQUENCE "Seller_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Seller_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."Seller_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."Seller_id_seq" TO service_role;


--
-- Name: TABLE usage_plan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usage_plan TO anon;
GRANT ALL ON TABLE public.usage_plan TO authenticated;
GRANT ALL ON TABLE public.usage_plan TO service_role;


--
-- Name: SEQUENCE "Survey_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."Survey_id_seq" TO anon;
GRANT ALL ON SEQUENCE public."Survey_id_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."Survey_id_seq" TO service_role;


--
-- Name: TABLE inventory_adjustment; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_adjustment TO anon;
GRANT ALL ON TABLE public.inventory_adjustment TO authenticated;
GRANT ALL ON TABLE public.inventory_adjustment TO service_role;


--
-- Name: SEQUENCE inventory_adjustment_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_adjustment_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_adjustment_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_adjustment_id_seq TO service_role;


--
-- Name: TABLE inventory_adjustment_item; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_adjustment_item TO anon;
GRANT ALL ON TABLE public.inventory_adjustment_item TO authenticated;
GRANT ALL ON TABLE public.inventory_adjustment_item TO service_role;


--
-- Name: SEQUENCE inventory_adjustment_item_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_adjustment_item_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_adjustment_item_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_adjustment_item_id_seq TO service_role;


--
-- Name: TABLE inventory_balance; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_balance TO anon;
GRANT ALL ON TABLE public.inventory_balance TO authenticated;
GRANT ALL ON TABLE public.inventory_balance TO service_role;


--
-- Name: SEQUENCE inventory_balance_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_balance_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_balance_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_balance_id_seq TO service_role;


--
-- Name: TABLE inventory_issue; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_issue TO anon;
GRANT ALL ON TABLE public.inventory_issue TO authenticated;
GRANT ALL ON TABLE public.inventory_issue TO service_role;


--
-- Name: SEQUENCE inventory_issue_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_issue_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_issue_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_issue_id_seq TO service_role;


--
-- Name: TABLE inventory_issue_item; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_issue_item TO anon;
GRANT ALL ON TABLE public.inventory_issue_item TO authenticated;
GRANT ALL ON TABLE public.inventory_issue_item TO service_role;


--
-- Name: SEQUENCE inventory_issue_item_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_issue_item_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_issue_item_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_issue_item_id_seq TO service_role;


--
-- Name: TABLE inventory_item; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_item TO anon;
GRANT ALL ON TABLE public.inventory_item TO authenticated;
GRANT ALL ON TABLE public.inventory_item TO service_role;


--
-- Name: SEQUENCE inventory_item_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_item_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_item_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_item_id_seq TO service_role;


--
-- Name: TABLE inventory_location; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_location TO anon;
GRANT ALL ON TABLE public.inventory_location TO authenticated;
GRANT ALL ON TABLE public.inventory_location TO service_role;


--
-- Name: SEQUENCE inventory_location_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_location_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_location_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_location_id_seq TO service_role;


--
-- Name: TABLE inventory_movement; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_movement TO anon;
GRANT ALL ON TABLE public.inventory_movement TO authenticated;
GRANT ALL ON TABLE public.inventory_movement TO service_role;


--
-- Name: SEQUENCE inventory_movement_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_movement_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_movement_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_movement_id_seq TO service_role;


--
-- Name: TABLE inventory_period; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_period TO anon;
GRANT ALL ON TABLE public.inventory_period TO authenticated;
GRANT ALL ON TABLE public.inventory_period TO service_role;


--
-- Name: TABLE inventory_period_balance; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_period_balance TO anon;
GRANT ALL ON TABLE public.inventory_period_balance TO authenticated;
GRANT ALL ON TABLE public.inventory_period_balance TO service_role;


--
-- Name: SEQUENCE inventory_period_balance_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_period_balance_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_period_balance_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_period_balance_id_seq TO service_role;


--
-- Name: SEQUENCE inventory_period_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_period_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_period_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_period_id_seq TO service_role;


--
-- Name: TABLE inventory_receipt; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_receipt TO anon;
GRANT ALL ON TABLE public.inventory_receipt TO authenticated;
GRANT ALL ON TABLE public.inventory_receipt TO service_role;


--
-- Name: SEQUENCE inventory_receipt_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_receipt_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_receipt_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_receipt_id_seq TO service_role;


--
-- Name: TABLE inventory_receipt_item; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_receipt_item TO anon;
GRANT ALL ON TABLE public.inventory_receipt_item TO authenticated;
GRANT ALL ON TABLE public.inventory_receipt_item TO service_role;


--
-- Name: SEQUENCE inventory_receipt_item_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_receipt_item_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_receipt_item_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_receipt_item_id_seq TO service_role;


--
-- Name: TABLE inventory_requisition; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_requisition TO anon;
GRANT ALL ON TABLE public.inventory_requisition TO authenticated;
GRANT ALL ON TABLE public.inventory_requisition TO service_role;


--
-- Name: SEQUENCE inventory_requisition_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_requisition_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_requisition_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_requisition_id_seq TO service_role;


--
-- Name: TABLE inventory_requisition_item; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_requisition_item TO anon;
GRANT ALL ON TABLE public.inventory_requisition_item TO authenticated;
GRANT ALL ON TABLE public.inventory_requisition_item TO service_role;


--
-- Name: SEQUENCE inventory_requisition_item_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_requisition_item_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_requisition_item_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_requisition_item_id_seq TO service_role;


--
-- Name: TABLE inventory_warehouse; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventory_warehouse TO anon;
GRANT ALL ON TABLE public.inventory_warehouse TO authenticated;
GRANT ALL ON TABLE public.inventory_warehouse TO service_role;


--
-- Name: SEQUENCE inventory_warehouse_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventory_warehouse_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inventory_warehouse_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventory_warehouse_id_seq TO service_role;


--
-- Name: TABLE purchase_approval; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.purchase_approval TO anon;
GRANT ALL ON TABLE public.purchase_approval TO authenticated;
GRANT ALL ON TABLE public.purchase_approval TO service_role;


--
-- Name: SEQUENCE purchase_approval_approval_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.purchase_approval_approval_id_seq TO anon;
GRANT ALL ON SEQUENCE public.purchase_approval_approval_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.purchase_approval_approval_id_seq TO service_role;


--
-- Name: TABLE purchase_approval_backup; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.purchase_approval_backup TO anon;
GRANT ALL ON TABLE public.purchase_approval_backup TO authenticated;
GRANT ALL ON TABLE public.purchase_approval_backup TO service_role;


--
-- Name: TABLE purchase_approval_detail; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.purchase_approval_detail TO anon;
GRANT ALL ON TABLE public.purchase_approval_detail TO authenticated;
GRANT ALL ON TABLE public.purchase_approval_detail TO service_role;


--
-- Name: SEQUENCE purchase_approval_detail_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.purchase_approval_detail_id_seq TO anon;
GRANT ALL ON SEQUENCE public.purchase_approval_detail_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.purchase_approval_detail_id_seq TO service_role;


--
-- Name: SEQUENCE purchase_approval_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.purchase_approval_id_seq TO anon;
GRANT ALL ON SEQUENCE public.purchase_approval_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.purchase_approval_id_seq TO service_role;


--
-- Name: TABLE purchase_approval_inventory_link_backup; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.purchase_approval_inventory_link_backup TO anon;
GRANT ALL ON TABLE public.purchase_approval_inventory_link_backup TO authenticated;
GRANT ALL ON TABLE public.purchase_approval_inventory_link_backup TO service_role;


--
-- Name: TABLE test_data; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.test_data TO anon;
GRANT ALL ON TABLE public.test_data TO authenticated;
GRANT ALL ON TABLE public.test_data TO service_role;


--
-- Name: SEQUENCE test_data_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.test_data_id_seq TO anon;
GRANT ALL ON SEQUENCE public.test_data_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.test_data_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2026_03_12; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_12 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_12 TO dashboard_user;


--
-- Name: TABLE messages_2026_03_13; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_13 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_13 TO dashboard_user;


--
-- Name: TABLE messages_2026_03_14; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_14 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_14 TO dashboard_user;


--
-- Name: TABLE messages_2026_03_15; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_15 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_15 TO dashboard_user;


--
-- Name: TABLE messages_2026_03_16; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_16 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_16 TO dashboard_user;


--
-- Name: TABLE messages_2026_03_17; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_17 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_17 TO dashboard_user;


--
-- Name: TABLE messages_2026_03_18; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_18 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_18 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE iceberg_namespaces; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_namespaces TO service_role;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO anon;


--
-- Name: TABLE iceberg_tables; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_tables TO service_role;
GRANT SELECT ON TABLE storage.iceberg_tables TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_tables TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;
GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;
GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict I1HZ2pG5zIu4xoCtZQe6FbJpRtBUCrPs5dyJ9oXd3ok3HpGd90aesI8PIYV7rnd

