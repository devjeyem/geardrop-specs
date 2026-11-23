# 01 — Architecture

**Purpose:** Understand the verified ecosystem boundary before making a design claim.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

## Verified model

The workspace contains four repositories: `geardrop-api`, `geardrop-android`, `geardrop-web`, and `geardrop-specs`. Only `geardrop-specs` contains product material: `business-logic-v1.0.md`, `sense-making.md`, and `git-guidelines.md`. The application repositories contain only `AGENTS.md` and Git metadata; no components, data flow, deployable, or API contract can be verified.

## Boundaries and decisions

1. Keep product claims in `geardrop-specs` until implementation exists. **Why:** `business-logic-v1.0.md` still uses placeholders. **Miss →** invented ownership or interfaces become false handoff guidance.
2. `sense-making.md` is a research-output instruction, not a runtime component. **Why:** it requests a CSV under `planning/`; no such output exists. **Miss →** treating research directions as implemented requirements.

## Debt register

1. **High / verified:** requirements, roles, features, platform, and technology are placeholders in `business-logic-v1.0.md`; no buildable system is specified.
2. **High / verified:** no source, schema, routes, config, CI, or tests exist in the application repositories.

## Decision records

None exist. Record accepted architecture choices here using the format in `handoff.md`.
