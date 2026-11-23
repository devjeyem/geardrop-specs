-- GearDrop Supabase PostgreSQL schema snapshot v1.0.0
--
-- Re-runnable baseline for the MVP. `id` is a server-only indexing key and
-- must never be sent to or accepted from a sync client. `uuid` is the global
-- row identity; every relationship is stored as a `*_uuid` column. Deliberate
-- absence of server FOREIGN KEY constraints supports offline, out-of-order sync.

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
BEGIN
  CREATE TYPE public.app_role AS ENUM (
    'system_administrator', 'administrator', 'moderator', 'contributor'
  );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  CREATE TYPE public.listing_status AS ENUM (
    'available', 'requested', 'borrowed', 'returned', 'closed', 'expired'
  );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  CREATE TYPE public.borrow_request_status AS ENUM (
    'pending', 'accepted', 'declined', 'cancelled', 'return_claimed', 'returned'
  );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  CREATE TYPE public.flag_status AS ENUM ('pending', 'resolved', 'dismissed');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- A domain must be seeded by a service-role/System Administrator before the
-- first Google user can sign in. This prevents an unrestricted public signup.
CREATE TABLE IF NOT EXISTS public.approved_email_domain (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  uuid         uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  domain       text NOT NULL,
  is_active    boolean NOT NULL DEFAULT true,
  created_by_uuid uuid,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  archived_at  timestamptz,
  CONSTRAINT approved_email_domain_domain_check
    CHECK (domain = lower(trim(domain)) AND position('@' IN domain) = 0)
);

CREATE UNIQUE INDEX IF NOT EXISTS approved_email_domain_live_domain_key
  ON public.approved_email_domain (domain) WHERE archived_at IS NULL;

-- uuid equals auth.users.id. The identity key remains server-only; clients use
-- account_uuid values when relating other rows to an account.
CREATE TABLE IF NOT EXISTS public.account (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  uuid         uuid NOT NULL UNIQUE,
  email        text NOT NULL,
  display_name text,
  avatar_url   text,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  archived_at  timestamptz,
  CONSTRAINT account_email_lower_check CHECK (email = lower(trim(email)))
);

CREATE UNIQUE INDEX IF NOT EXISTS account_live_email_key
  ON public.account (email) WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.account_role (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  uuid         uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  account_uuid uuid NOT NULL,
  role         public.app_role NOT NULL,
  created_by_uuid uuid,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  archived_at  timestamptz
);

CREATE UNIQUE INDEX IF NOT EXISTS account_role_live_account_role_key
  ON public.account_role (account_uuid, role) WHERE archived_at IS NULL;
CREATE INDEX IF NOT EXISTS account_role_account_uuid_idx
  ON public.account_role (account_uuid) WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.item_category (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  uuid         uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  name         text NOT NULL,
  description  text,
  sort_order   integer NOT NULL DEFAULT 0,
  created_by_uuid uuid,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  archived_at  timestamptz,
  CONSTRAINT item_category_name_check CHECK (length(trim(name)) > 0)
);

CREATE UNIQUE INDEX IF NOT EXISTS item_category_live_name_key
  ON public.item_category (lower(name)) WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.campus_zone (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  uuid         uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  code         text NOT NULL,
  name         text NOT NULL,
  sort_order   integer NOT NULL DEFAULT 0,
  created_by_uuid uuid,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  archived_at  timestamptz,
  CONSTRAINT campus_zone_code_check CHECK (code = lower(trim(code))),
  CONSTRAINT campus_zone_name_check CHECK (length(trim(name)) > 0)
);

CREATE UNIQUE INDEX IF NOT EXISTS campus_zone_live_code_key
  ON public.campus_zone (code) WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.listing (
  id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  uuid              uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  owner_account_uuid uuid NOT NULL,
  category_uuid     uuid NOT NULL,
  campus_zone_uuid  uuid NOT NULL,
  title             text NOT NULL,
  description       text,
  condition_note    text NOT NULL,
  available_until   timestamptz NOT NULL,
  handoff_window    text,
  status            public.listing_status NOT NULL DEFAULT 'available',
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  archived_at       timestamptz,
  CONSTRAINT listing_title_check CHECK (length(trim(title)) BETWEEN 1 AND 140),
  CONSTRAINT listing_condition_note_check CHECK (length(trim(condition_note)) > 0),
  CONSTRAINT listing_available_until_check CHECK (available_until > created_at)
);

CREATE INDEX IF NOT EXISTS listing_live_browse_idx
  ON public.listing (category_uuid, campus_zone_uuid, available_until)
  WHERE archived_at IS NULL AND status = 'available';
CREATE INDEX IF NOT EXISTS listing_owner_uuid_idx
  ON public.listing (owner_account_uuid, updated_at DESC) WHERE archived_at IS NULL;
CREATE INDEX IF NOT EXISTS listing_status_expiry_idx
  ON public.listing (status, available_until) WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.borrow_request (
  id                     bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  uuid                   uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  listing_uuid           uuid NOT NULL,
  requester_account_uuid uuid NOT NULL,
  request_note           text,
  pickup_note            text,
  status                 public.borrow_request_status NOT NULL DEFAULT 'pending',
  responded_by_uuid      uuid,
  responded_at           timestamptz,
  return_claimed_at      timestamptz,
  returned_at            timestamptz,
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now(),
  archived_at            timestamptz
);

-- Pending, accepted, and return-claim rows are active. A partial unique index
-- prevents double booking while retaining declined/cancelled history for sync.
CREATE UNIQUE INDEX IF NOT EXISTS borrow_request_one_active_listing_key
  ON public.borrow_request (listing_uuid)
  WHERE archived_at IS NULL
    AND status IN ('pending', 'accepted', 'return_claimed');
CREATE INDEX IF NOT EXISTS borrow_request_requester_uuid_idx
  ON public.borrow_request (requester_account_uuid, updated_at DESC)
  WHERE archived_at IS NULL;
CREATE INDEX IF NOT EXISTS borrow_request_listing_uuid_idx
  ON public.borrow_request (listing_uuid, updated_at DESC)
  WHERE archived_at IS NULL;

CREATE TABLE IF NOT EXISTS public.listing_flag (
  id                    bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  uuid                  uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  listing_uuid          uuid NOT NULL,
  reporter_account_uuid uuid NOT NULL,
  reason                text NOT NULL,
  detail                text,
  status                public.flag_status NOT NULL DEFAULT 'pending',
  resolved_by_uuid      uuid,
  resolved_at           timestamptz,
  resolution_note       text,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now(),
  archived_at           timestamptz,
  CONSTRAINT listing_flag_reason_check CHECK (length(trim(reason)) > 0)
);

CREATE INDEX IF NOT EXISTS listing_flag_review_queue_idx
  ON public.listing_flag (status, created_at) WHERE archived_at IS NULL;
CREATE INDEX IF NOT EXISTS listing_flag_listing_uuid_idx
  ON public.listing_flag (listing_uuid) WHERE archived_at IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS listing_flag_one_pending_reporter_key
  ON public.listing_flag (listing_uuid, reporter_account_uuid)
  WHERE archived_at IS NULL AND status = 'pending';

-- Client timestamps are retained for last-write-wins sync. This trigger only
-- supplies missing values and never overwrites a client-provided updated_at.
CREATE OR REPLACE FUNCTION public.set_sync_timestamps()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_at := COALESCE(NEW.created_at, now());
  END IF;
  NEW.updated_at := COALESCE(NEW.updated_at, now());
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS approved_email_domain_set_timestamps ON public.approved_email_domain;
CREATE TRIGGER approved_email_domain_set_timestamps
BEFORE INSERT OR UPDATE ON public.approved_email_domain
FOR EACH ROW EXECUTE FUNCTION public.set_sync_timestamps();

DROP TRIGGER IF EXISTS account_set_timestamps ON public.account;
CREATE TRIGGER account_set_timestamps
BEFORE INSERT OR UPDATE ON public.account
FOR EACH ROW EXECUTE FUNCTION public.set_sync_timestamps();

DROP TRIGGER IF EXISTS account_role_set_timestamps ON public.account_role;
CREATE TRIGGER account_role_set_timestamps
BEFORE INSERT OR UPDATE ON public.account_role
FOR EACH ROW EXECUTE FUNCTION public.set_sync_timestamps();

DROP TRIGGER IF EXISTS item_category_set_timestamps ON public.item_category;
CREATE TRIGGER item_category_set_timestamps
BEFORE INSERT OR UPDATE ON public.item_category
FOR EACH ROW EXECUTE FUNCTION public.set_sync_timestamps();

DROP TRIGGER IF EXISTS campus_zone_set_timestamps ON public.campus_zone;
CREATE TRIGGER campus_zone_set_timestamps
BEFORE INSERT OR UPDATE ON public.campus_zone
FOR EACH ROW EXECUTE FUNCTION public.set_sync_timestamps();

DROP TRIGGER IF EXISTS listing_set_timestamps ON public.listing;
CREATE TRIGGER listing_set_timestamps
BEFORE INSERT OR UPDATE ON public.listing
FOR EACH ROW EXECUTE FUNCTION public.set_sync_timestamps();

DROP TRIGGER IF EXISTS borrow_request_set_timestamps ON public.borrow_request;
CREATE TRIGGER borrow_request_set_timestamps
BEFORE INSERT OR UPDATE ON public.borrow_request
FOR EACH ROW EXECUTE FUNCTION public.set_sync_timestamps();

-- Decision actors are server-stamped from the authenticated session. Clients
-- may propose a status transition but cannot attribute it to another account.
CREATE OR REPLACE FUNCTION public.stamp_borrow_request_decision()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.status IN ('accepted', 'declined')
     AND (TG_OP = 'INSERT' OR NEW.status IS DISTINCT FROM OLD.status) THEN
    NEW.responded_by_uuid := auth.uid();
    NEW.responded_at := now();
  END IF;
  IF NEW.status = 'return_claimed'
     AND (TG_OP = 'INSERT' OR NEW.status IS DISTINCT FROM OLD.status) THEN
    NEW.return_claimed_at := now();
  END IF;
  IF NEW.status = 'returned'
     AND (TG_OP = 'INSERT' OR NEW.status IS DISTINCT FROM OLD.status) THEN
    NEW.returned_at := now();
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS borrow_request_stamp_decision ON public.borrow_request;
CREATE TRIGGER borrow_request_stamp_decision
BEFORE INSERT OR UPDATE ON public.borrow_request
FOR EACH ROW EXECUTE FUNCTION public.stamp_borrow_request_decision();

DROP TRIGGER IF EXISTS listing_flag_set_timestamps ON public.listing_flag;
CREATE TRIGGER listing_flag_set_timestamps
BEFORE INSERT OR UPDATE ON public.listing_flag
FOR EACH ROW EXECUTE FUNCTION public.set_sync_timestamps();

CREATE OR REPLACE FUNCTION public.stamp_flag_resolution()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.status IN ('resolved', 'dismissed')
     AND (TG_OP = 'INSERT' OR NEW.status IS DISTINCT FROM OLD.status) THEN
    NEW.resolved_by_uuid := auth.uid();
    NEW.resolved_at := now();
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS listing_flag_stamp_resolution ON public.listing_flag;
CREATE TRIGGER listing_flag_stamp_resolution
BEFORE INSERT OR UPDATE ON public.listing_flag
FOR EACH ROW EXECUTE FUNCTION public.stamp_flag_resolution();

-- Auth is server-managed: only approved-domain Google accounts become local
-- platform accounts. Seed approved_email_domain before enabling first signup.
CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  user_email text := lower(trim(COALESCE(NEW.email, '')));
  user_domain text := split_part(lower(trim(COALESCE(NEW.email, ''))), '@', 2);
BEGIN
  IF user_email = '' OR user_domain = '' OR NOT EXISTS (
    SELECT 1
    FROM public.approved_email_domain
    WHERE domain = user_domain AND is_active AND archived_at IS NULL
  ) THEN
    RAISE EXCEPTION 'An approved university email domain is required';
  END IF;

  INSERT INTO public.account (uuid, email, display_name, avatar_url)
  VALUES (
    NEW.id,
    user_email,
    NULLIF(NEW.raw_user_meta_data ->> 'full_name', ''),
    NULLIF(NEW.raw_user_meta_data ->> 'avatar_url', '')
  )
  ON CONFLICT (uuid) DO UPDATE
  SET email = EXCLUDED.email,
      display_name = COALESCE(EXCLUDED.display_name, public.account.display_name),
      avatar_url = COALESCE(EXCLUDED.avatar_url, public.account.avatar_url),
      updated_at = now();

  INSERT INTO public.account_role (account_uuid, role)
  SELECT NEW.id, 'contributor'::public.app_role
  WHERE NOT EXISTS (
    SELECT 1 FROM public.account_role
    WHERE account_uuid = NEW.id
      AND role = 'contributor'::public.app_role
      AND archived_at IS NULL
  );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_auth_user();

CREATE OR REPLACE FUNCTION public.is_staff()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.account_role
    WHERE account_uuid = auth.uid()
      AND role IN ('system_administrator', 'administrator', 'moderator')
      AND archived_at IS NULL
  );
$$;

CREATE OR REPLACE FUNCTION public.is_administrator()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.account_role
    WHERE account_uuid = auth.uid()
      AND role IN ('system_administrator', 'administrator')
      AND archived_at IS NULL
  );
$$;

CREATE OR REPLACE FUNCTION public.is_system_administrator()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.account_role
    WHERE account_uuid = auth.uid()
      AND role = 'system_administrator'
      AND archived_at IS NULL
  );
$$;

CREATE OR REPLACE FUNCTION public.is_listing_owner(target_listing_uuid uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.listing
    WHERE uuid = target_listing_uuid
      AND owner_account_uuid = auth.uid()
      AND archived_at IS NULL
  );
$$;

-- This function is intended for a scheduled job or API call. It uses the
-- server clock to close stale availability without physical deletion.
CREATE OR REPLACE FUNCTION public.expire_due_listings()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE changed_count integer;
BEGIN
  UPDATE public.listing
  SET status = 'expired', updated_at = now()
  WHERE archived_at IS NULL
    AND status IN ('available', 'requested')
    AND available_until <= now();
  GET DIAGNOSTICS changed_count = ROW_COUNT;
  RETURN changed_count;
END;
$$;

ALTER TABLE public.approved_email_domain ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.account ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.account_role ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.item_category ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.campus_zone ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.listing ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.borrow_request ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.listing_flag ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS approved_email_domain_admin_policy ON public.approved_email_domain;
CREATE POLICY approved_email_domain_admin_policy ON public.approved_email_domain
  FOR ALL TO authenticated
  USING (public.is_administrator())
  WITH CHECK (public.is_administrator());

DROP POLICY IF EXISTS account_self_or_staff_select ON public.account;
CREATE POLICY account_self_or_staff_select ON public.account
  FOR SELECT TO authenticated
  USING (uuid = auth.uid() OR public.is_staff());
DROP POLICY IF EXISTS account_self_update ON public.account;
CREATE POLICY account_self_update ON public.account
  FOR UPDATE TO authenticated
  USING (uuid = auth.uid())
  WITH CHECK (uuid = auth.uid());

DROP POLICY IF EXISTS account_role_self_or_staff_select ON public.account_role;
CREATE POLICY account_role_self_or_staff_select ON public.account_role
  FOR SELECT TO authenticated
  USING (account_uuid = auth.uid() OR public.is_staff());
DROP POLICY IF EXISTS account_role_system_admin_write ON public.account_role;
CREATE POLICY account_role_system_admin_write ON public.account_role
  FOR ALL TO authenticated
  USING (public.is_system_administrator())
  WITH CHECK (public.is_system_administrator());

DROP POLICY IF EXISTS item_category_authenticated_read ON public.item_category;
CREATE POLICY item_category_authenticated_read ON public.item_category
  FOR SELECT TO authenticated USING (archived_at IS NULL);
DROP POLICY IF EXISTS item_category_admin_write ON public.item_category;
CREATE POLICY item_category_admin_write ON public.item_category
  FOR ALL TO authenticated
  USING (public.is_administrator())
  WITH CHECK (public.is_administrator());

DROP POLICY IF EXISTS campus_zone_authenticated_read ON public.campus_zone;
CREATE POLICY campus_zone_authenticated_read ON public.campus_zone
  FOR SELECT TO authenticated USING (archived_at IS NULL);
DROP POLICY IF EXISTS campus_zone_admin_write ON public.campus_zone;
CREATE POLICY campus_zone_admin_write ON public.campus_zone
  FOR ALL TO authenticated
  USING (public.is_administrator())
  WITH CHECK (public.is_administrator());

DROP POLICY IF EXISTS listing_owner_or_staff_select ON public.listing;
CREATE POLICY listing_owner_or_staff_select ON public.listing
  FOR SELECT TO authenticated
  USING (owner_account_uuid = auth.uid() OR public.is_staff());
DROP POLICY IF EXISTS listing_owner_insert ON public.listing;
CREATE POLICY listing_owner_insert ON public.listing
  FOR INSERT TO authenticated
  WITH CHECK (owner_account_uuid = auth.uid());
DROP POLICY IF EXISTS listing_owner_or_staff_update ON public.listing;
CREATE POLICY listing_owner_or_staff_update ON public.listing
  FOR UPDATE TO authenticated
  USING (owner_account_uuid = auth.uid() OR public.is_staff())
  WITH CHECK (owner_account_uuid = auth.uid() OR public.is_staff());

DROP POLICY IF EXISTS borrow_request_participant_or_staff_select ON public.borrow_request;
CREATE POLICY borrow_request_participant_or_staff_select ON public.borrow_request
  FOR SELECT TO authenticated
  USING (
    requester_account_uuid = auth.uid()
    OR public.is_listing_owner(listing_uuid)
    OR public.is_staff()
  );
DROP POLICY IF EXISTS borrow_request_requester_insert ON public.borrow_request;
CREATE POLICY borrow_request_requester_insert ON public.borrow_request
  FOR INSERT TO authenticated
  WITH CHECK (requester_account_uuid = auth.uid());
DROP POLICY IF EXISTS borrow_request_participant_or_staff_update ON public.borrow_request;
CREATE POLICY borrow_request_participant_or_staff_update ON public.borrow_request
  FOR UPDATE TO authenticated
  USING (
    requester_account_uuid = auth.uid()
    OR public.is_listing_owner(listing_uuid)
    OR public.is_staff()
  )
  WITH CHECK (
    requester_account_uuid = auth.uid()
    OR public.is_listing_owner(listing_uuid)
    OR public.is_staff()
  );

DROP POLICY IF EXISTS listing_flag_reporter_or_staff_select ON public.listing_flag;
CREATE POLICY listing_flag_reporter_or_staff_select ON public.listing_flag
  FOR SELECT TO authenticated
  USING (reporter_account_uuid = auth.uid() OR public.is_staff());
DROP POLICY IF EXISTS listing_flag_reporter_insert ON public.listing_flag;
CREATE POLICY listing_flag_reporter_insert ON public.listing_flag
  FOR INSERT TO authenticated
  WITH CHECK (reporter_account_uuid = auth.uid());
DROP POLICY IF EXISTS listing_flag_staff_update ON public.listing_flag;
CREATE POLICY listing_flag_staff_update ON public.listing_flag
  FOR UPDATE TO authenticated
  USING (public.is_staff())
  WITH CHECK (public.is_staff());

-- Guests receive only this projection: no owner UUID, account email, request,
-- flag, or handoff data is exposed. The view deliberately bypasses base-table
-- RLS only for these non-sensitive, currently available listing fields.
CREATE OR REPLACE VIEW public.public_listing
WITH (security_barrier = true)
AS
SELECT
  l.uuid,
  l.category_uuid,
  c.name AS category_name,
  l.campus_zone_uuid,
  z.code AS campus_zone_code,
  z.name AS campus_zone_name,
  l.title,
  l.description,
  l.condition_note,
  l.available_until,
  l.updated_at
FROM public.listing AS l
JOIN public.item_category AS c ON c.uuid = l.category_uuid AND c.archived_at IS NULL
JOIN public.campus_zone AS z ON z.uuid = l.campus_zone_uuid AND z.archived_at IS NULL
WHERE l.archived_at IS NULL
  AND l.status = 'available'
  AND l.available_until > now();

CREATE OR REPLACE VIEW public.pilot_metrics
WITH (security_invoker = true, security_barrier = true)
AS
SELECT
  (SELECT count(*) FROM public.listing WHERE archived_at IS NULL) AS listings_total,
  (SELECT count(*) FROM public.listing
   WHERE archived_at IS NULL AND status = 'available') AS listings_available,
  (SELECT count(*) FROM public.borrow_request
   WHERE archived_at IS NULL AND status = 'accepted') AS borrows_active,
  (SELECT count(*) FROM public.borrow_request
   WHERE archived_at IS NULL AND status = 'returned') AS borrows_returned,
  (SELECT count(*) FROM public.listing_flag
   WHERE archived_at IS NULL AND status = 'pending') AS flags_pending
WHERE public.is_administrator();

REVOKE ALL ON TABLE public.approved_email_domain, public.account, public.account_role,
  public.item_category, public.campus_zone, public.listing, public.borrow_request,
  public.listing_flag FROM anon, authenticated;
GRANT SELECT ON public.public_listing TO anon, authenticated;
GRANT SELECT ON public.pilot_metrics TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.account, public.account_role, public.item_category,
  public.campus_zone, public.listing, public.borrow_request, public.listing_flag,
  public.approved_email_domain TO authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT EXECUTE ON FUNCTION public.expire_due_listings() TO service_role;
GRANT ALL ON TABLE public.approved_email_domain, public.account, public.account_role,
  public.item_category, public.campus_zone, public.listing, public.borrow_request,
  public.listing_flag TO service_role;

COMMIT;
