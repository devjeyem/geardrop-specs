# 05 — Debugging playbook

**Purpose:** Prevent fabricated troubleshooting steps and establish the first diagnostic move.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

No application logs, runtime errors, health checks, tests, or commands are verified. The application repositories contain no source files.

1. If a behavior is reported, first establish the repository, revision, command, expected result, actual result, and relevant configuration-variable names (never values). **Why:** no executable baseline exists. **Miss →** diagnosis becomes an unsupported story.
2. Record exact error text and a minimal reproduction in `INBOX.md` if its cause is not verified. **Why:** `handoff.md` requires evidence and confidence labels. **Miss →** a guess becomes institutional knowledge.
