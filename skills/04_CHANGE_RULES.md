# 04 — Change rules

**Purpose:** Identify verified lockstep work and the gaps that must be resolved before implementation.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

## Lockstep sets

1. `business-logic-v1.0.md` user-level table ↔ MVP Feature Access table. Update both when a role or access policy changes. **Why:** access letters reference the user-level table. **Miss →** a feature grants an undefined or wrong role.
2. `business-logic-v1.0.md` system requirements ↔ MVP features. Reconcile them when a requirement becomes a feature. **Why:** both describe intended behavior. **Miss →** the requirement set and delivery plan contradict each other.
3. `git-guidelines.md` release-tag tables ↔ future tags in each repository. **Why:** the guideline requires chronological, non-moved tags. **Miss →** version history is misleading or violates release policy.

No implementation enums, schemas, error codes, or registries are present. Add them here after source is introduced.
