# 04 — Change rules

**Purpose:** Identify verified lockstep work and the gaps that must be resolved before implementation.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

## Lockstep sets

1. `business-logic-v1.0.md` user-level table ↔ MVP Feature Access table. Update both when a role or access policy changes. **Why:** access letters reference the user-level table. **Miss →** a feature grants an undefined or wrong role.
2. `business-logic-v1.0.md` system requirements ↔ MVP features. Reconcile them when a requirement becomes a feature. **Why:** both describe intended behavior. **Miss →** the requirement set and delivery plan contradict each other.
3. `git-guidelines.md` release-tag tables ↔ future tags in each repository. **Why:** the guideline requires chronological, non-moved tags. **Miss →** version history is misleading or violates release policy.
4. `db-schema/v1.0.0.sql` table UUID columns ↔ every API/client payload and local SQLite mirror. Send `uuid` and `*_uuid`, never server `id`. **Why:** the server identity key is local-only. **Miss →** offline clients create invalid relationships or expose server identifiers.
5. `db-schema/v1.0.0.sql` lifecycle enums ↔ listing/request/moderation clients and API validation. **Why:** the database accepts only its declared status vocabulary. **Miss →** old or unchecked clients fail writes or display impossible states.

The database schema now supplies the initial closed vocabularies; add later lockstep sets here as implementation begins.
