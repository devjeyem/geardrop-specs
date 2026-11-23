# 13 — Dependencies

**Purpose:** Track dependency choices, upgrade risks, and deliberate rejections.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

No manifests, lockfiles, or source imports exist. Google Sign-In appears as a template requirement in `business-logic-v1.0.md`, not as a selected dependency. `geardrop-api/AGENTS.md` mentions Supabase in a repository description, not a manifest. **Miss →** treating either mention as installed can lead to false security and upgrade advice.
