# 14 — Developer workflows

**Purpose:** Provide the verified workflow for evolving this early-stage ecosystem.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

## Update a requirement

1. Edit `business-logic-v1.0.md`; replace placeholders with approved facts, not assumptions.
2. Reconcile the user-level and feature-access tables (see 04 #1).
3. Record the reason and evidence in the relevant skills document or `INBOX.md`.
4. Use the commit format in 03 once a Git commit is made.

**Why:** the current product source is a template. **Miss →** access policy and stated requirements drift. Add what surprised you to `INBOX.md`.

## Add implementation knowledge

1. Verify paths, commands, and behavior against source and history.
2. Add the rule to its numbered home with reason, failure outcome, and confidence.
3. Add every mirrored implementation value to 04.

**Why:** `handoff.md` requires evidence-based, maintainable handoffs. **Miss →** a speculation gains the authority of a runbook. Add what surprised you to `INBOX.md`.
