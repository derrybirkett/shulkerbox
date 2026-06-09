# idea fallback — minimal spine templates

Used when `.bloom/idea/` is not mounted. These templates are sparser than the
real `idea` repo's, but enough to give the `product` agent a structured `docs/`
to populate during Stage 1 — Define.

The agent writes these files into the target product's `docs/` directory, with
the user reviewing before any build begins.

---

## docs/intent.md

```markdown
# Intent

## The idea
<!-- One sentence. Clean restatement of the seed. -->

## The problem
<!-- Who has it. Why it matters. One paragraph. -->

## Why now
<!-- One sentence, or `<!-- TODO: fill in -->` -->

## Decision
Pursue
```

---

## docs/mission.md

```markdown
# Mission

## Who we serve
<!-- Role inferred from the seed. One line. -->

## The problem they have
<!-- One sentence. -->

## Our solution
<!-- One sentence. What we build for them. -->

## Vision (3 years)
<!-- Where this leads, or `<!-- TODO: fill in -->`. -->

## Non-goals
<!-- 2-3 explicit exclusions, each marked `<!-- assumption -->` until confirmed. -->
- ...
```

---

## docs/north-star.md

```markdown
# North Star

## The metric
<!-- One number that says whether users are getting value. -->

## Why this metric
<!-- One sentence justifying the choice. -->

## Current baseline
0 (pre-launch)

## Target
<!-- TODO: define after first users -->
```

---

## docs/product-surfaces.md

```markdown
# Product Surfaces

Each surface = one route / page / area of the app. Listed in build priority.

## 1. <Surface name>
- **Route:** `/path`
- **Primary user action:** <one verb-phrase>
- **Data shown:** <one line>
- **Priority:** 1

## 2. <Surface name>
...
```

The agent should generate surfaces implied by the seed. For a todo app, expect:
marketing page, auth, dashboard (list), task detail.

---

## docs/architecture.md

```markdown
# Architecture

## Stack
<!-- Profile name + one-line summary. -->

## Auth flow
<!-- 2-3 lines describing how a user signs up and logs in. -->

## Data model
<!-- One table per entity. Columns only, no SQL. -->

### users
- id
- email
- created_at

### <other entity>
- ...

## Open questions
<!-- TODO markers for anything not yet decided. -->
```

---

## docs/IA-graph.md

```markdown
# Information Architecture

One section per surface from `product-surfaces.md`.

## <Surface name>
- **UI elements:** <list>
- **Primary action:** <verb-phrase>
- **Data shown:** <list>
- **Empty / loading / error states:** <one line each>
```

---

## Tone for generated content

- Honest and minimal. Say less rather than more.
- Plain English, not product-speak.
- Assumptions stated as assumptions.
- Write so the user can see what to change.
