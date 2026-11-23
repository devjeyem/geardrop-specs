# 07 — Database

**Purpose:** Document storage facts and integrity rules once a schema exists.

**Confidence note:** verified against `db-schema/v1.0.0.sql` on 2026-11-23. The code wins (see 16).

`db-schema/v1.0.0.sql` is the idempotent Supabase PostgreSQL MVP snapshot. It defines `account`, access roles, approved email domains, categories, campus zones, listings, borrow requests, and listing flags. It uses Supabase Auth for Google identities and row-level security for access control.

## Storage invariants

1. Every platform table has a server-only `id bigint GENERATED ALWAYS AS IDENTITY` and a globally shared `uuid`. **Why:** `id` keeps server indexes compact, while `uuid` works offline. **Miss →** a client can collide with or expose server IDs.
2. Relationships use `*_uuid` columns and do not declare server foreign keys. **Why:** clients can sync child rows before parents. **Miss →** out-of-order sync batches fail (see `db-design-choices.md` §3).
3. Normal deletion is `archived_at`, and client mutations must bump `updated_at`. **Why:** tombstones and conflict resolution must sync. **Miss →** deleted or changed rows silently reappear or stop syncing.
4. The public reads only `public_listing`; base listing rows expose owner identifiers only to their owner or staff. **Why:** guests must not receive lender identity or handoff data. **Miss →** anonymous browsing leaks personal data.

See `db-design-choices.md` §9 for immutable versioned migration and snapshot rules.
