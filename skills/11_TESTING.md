# 11 — Testing

**Purpose:** State the evidence available for quality claims and the required release gates.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

No tests, coverage, fixtures, or test commands are present. Do not report coverage or test success.

The release policy assigns unit testing to developers on `main`, system testing to QA on `beta`, and independent integration testing to published bundles on `release`. **Why:** `git-guidelines.md` separates these gates. **Miss →** unreviewed development code may be represented as independently tested.
