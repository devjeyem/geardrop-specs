# 16 — Engineering principles

**Purpose:** State the durable rules that govern all handoff knowledge.

**Confidence note:** verified against `handoff.md` and the working tree (no commits exist) on 2026-11-23. The code wins.

1. **The code wins.** Document verified facts, mark inference and suspicion, and correct docs that disagree with code. **Reason:** documentation can go stale. **Miss →** a contributor implements a false constraint. Source: `handoff.md`.
2. **Every rule needs a named breakage.** **Reason:** unmotivated rules look arbitrary. **Miss →** necessary safeguards are removed. Source: `handoff.md`.
3. **Keep lockstep data explicit.** **Reason:** mirrored constants, types, columns, and error codes are incident-prone. **Miss →** modules disagree silently. Source: `handoff.md`; see 04.
4. **Never invent implementation knowledge.** **Reason:** this workspace has none to validate. **Miss →** assumptions harden into unsafe requirements. Source: current inventory.

trust the code over any document, including this one
