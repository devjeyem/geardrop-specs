# 07 — Database

**Purpose:** Document storage facts and integrity rules once a schema exists.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

No database provider, schema, migration, connection configuration, or table is present. The phrase "Supabase database API" appears only in `geardrop-api/AGENTS.md`; it does not verify an integration.

Do not choose identity, delete, retention, or indexing behavior from this document yet. The business-logic template requires privacy-by-design, retention limits, no per-user trails, aggregation thresholds, and consent for data resale; these are unimplemented requirements, not verified database controls. **Miss →** policy language may be mistaken for enforced data protection.
