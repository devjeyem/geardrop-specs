# 03 — Code style

**Purpose:** Apply the only verified authoring and Git conventions until code tooling exists.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

No application language, formatter, linter, logger, error model, or test command exists yet. Do not prescribe one without evidence.

## Verified rules

1. Write explanatory comments for the why, not a restatement of syntax. **Why:** `handoff.md` says newcomers can read code but cannot see rejected alternatives or prior failures. **Miss →** guards and compatibility constraints get removed as "cleanup."
2. Commit subjects use `scope: Imperative summary`, sentence case, no period, and 50 characters or fewer. **Why:** `git-guidelines.md` requires it. **Miss →** history loses searchable, consistent intent.
3. Use a specific Geardrop product/feature scope (for example `geardrop-specs/requirements:` once names are confirmed), not generic `ui:` or `core:`. **Why:** the guideline prioritizes product ownership. **Miss →** cross-repository history is ambiguous.
