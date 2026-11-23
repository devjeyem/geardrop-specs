# 09 — Security

**Purpose:** Separate stated privacy expectations from verified controls.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

## Verified requirement-level expectations

`business-logic-v1.0.md` calls for security and privacy by design, Data Privacy Act compliance, location protection, retention limits, no per-user trails, aggregation thresholds, and consent for data resale.

None is implemented or testable in the current workspace. Before adding personal, location, or analytics data, define the threat model, authorization layers, consent record, retention/deletion mechanism, aggregation threshold, and tests. **Why:** the only privacy text is a requirement. **Miss →** users can be exposed by controls that exist on paper only.
