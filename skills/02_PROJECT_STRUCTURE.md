# 02 — Project structure

**Purpose:** Place new material in the right repository and avoid claiming absent structure.

**Confidence note:** verified against the working tree (no commits exist) on 2026-11-23. The code wins (see 16).

```
geardrop-ecosystem/
  handoff.md                         # skills-generation contract
  geardrop-api/AGENTS.md             # API repository placeholder
  geardrop-android/AGENTS.md         # Android repository placeholder
  geardrop-web/AGENTS.md             # Web repository placeholder
  geardrop-specs/
    business-logic-v1.0.md            # requirement template
    sense-making.md                   # research CSV instruction
    git-guidelines.md                 # commit/release policy
    skills/                           # maintainable handoff knowledge
```

Put new handoff knowledge in `geardrop-specs/skills/NN_TOPIC.md`; append new numbered content rather than renumbering. The only verified naming convention is the `NN_TOPIC.md` convention mandated by `handoff.md`. **Miss →** unnumbered knowledge cannot be cross-referenced reliably (see 00).
