# 10 — Deployment

**Purpose:** Apply the verified release policy without inventing deployment mechanics.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

No deployable, CI workflow, environment, or release website is present. The verified lifecycle in `git-guidelines.md` is `main` → `beta` → `release` → production, with separate developer, QA, independent integration, and final-approval gates.

Release tags must be chronological, immutable, based on ISO weeks with commits, and not cut for the current week before Friday 5:00 PM local time. **Miss →** a tag can misrepresent the tested build or violate the release record. The actual project prefix remains unverified because `business-logic-v1.0.md` has placeholders.
