# council fallback — generic review checklist

Used when `.bloom/council/` is not mounted. The real `council` repo holds named
advisor personas (product strategy, engineering quality, design, finance, etc.)
that critique work from distinct angles. This fallback collapses them into one
generic checklist so the `product` agent can still produce a `notes/reviews/slice-<n>.md`
at the end of every Stage 5.

Write the review to `notes/reviews/slice-<n>.md`. The agent fills each section
honestly. Empty answers are better than padded ones.

---

## Review: slice <n> — <surface name>

**Date:** <yyyy-mm-dd>
**Reviewed by:** product agent (council fallback)
**Verdict:** `ship` | `iterate` | `block`

### 1. Are we building the right thing?
- Does this slice serve the user in `docs/mission.md`?
- Does it move the metric in `docs/north-star.md`?
- Would a real user notice if this slice vanished?

### 2. Is the slice cohesive?
- Does it work end-to-end (UI → data → back)?
- Are loading, empty, and error states handled?
- Is it reachable from the surface above it in `docs/IA-graph.md`?

### 3. Does it match the intent?
- Re-read `docs/intent.md`. Anything we shipped that contradicts it?
- Any `<!-- assumption -->` markers from earlier stages that this slice
  confirmed or corrected? Update them.

### 4. Quality bar
- Does the happy-path test pass?
- Did the `designer` subagent run? Any critical accessibility issues?
- Any TODOs added during the slice that need a parent ticket?

### 5. What did we learn?
- One thing that worked.
- One thing that didn't.
- One surprise.

### 6. Next slice
- Which surface from `docs/product-surfaces.md` is up next?
- Any reason to re-prioritise based on what we learned?
- Any decisions to make before we start?

### 7. Risks / debt accepted
- Any shortcut taken that needs paying back?
- Any assumption still unconfirmed after this slice?

---

## Verdict criteria

- **ship** — all of 1–4 are yes; debt is documented; next slice is clear.
- **iterate** — slice mostly works but section 2 or 4 has a gap. Fix in place
  before moving on.
- **block** — slice contradicts intent/mission, or section 4 has a critical
  failure. Stop. Talk to the user before continuing the loop.

The agent must not auto-progress past a `block`. Surface it to the user
explicitly and wait for direction.

---

## When to escalate to full council repo

Pull `.bloom/council/` as a submodule when:
- You want distinct advisor voices (a strategy critique reads differently
  from an engineering one — the value is in the multiple lenses)
- You're shipping commercially and need a structured governance trail
- You want recurring reviews (weekly, milestone) rather than per-slice

The fallback gives you one honest pass per slice. The real council gives you
several, plus accumulated wisdom from past products.
