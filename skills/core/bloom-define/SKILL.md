---
name: bloom-define
description: Seed the product spine (docs/) from a one-line idea or user story. Populates intent, mission, north-star, product-surfaces, architecture, and IA-graph at a high level so the user can review and edit before any build-out begins.
user-invocable: true
argument-hint: "\"your one-line idea or user story\""
metadata:
  tags: [bloom, define, product, discovery, spine, idea]
  category: core
  audience: core
---

# Bloom Define

Turns a seed — one sentence, a user story, or a rough idea — into a populated product spine ready for review.

## Trigger

`/bloom-define "As a busy person, I want to track my tasks so I don't forget what I need to do"`

Or with a looser seed:

`/bloom-define "a simple todo list app"`

## What it does

Reads the blank spine templates in `docs/`, reasons from the seed, and writes high-level first-draft content into each file. Nothing is built. This is purely the definition layer — the user reviews and adjusts before any code is written.

## Pre-flight checks

Before populating, confirm:

1. **You are in a bloom product directory** — `docs/intent.md` exists (scaffolded by bloom-init).
2. **The seed argument was provided** — if missing, ask: *"What's the idea? Give me a sentence or a user story."*
3. **docs/ still has blank templates** — check if `docs/intent.md` looks unfilled (contains the template placeholder text). If it already has real content, warn: *"docs/ already has content. Overwrite? [y/N]"* and stop if N.

## Steps

### 1. Read the seed

The argument is the seed. Accept any of:
- A user story: `"As a X, I want Y so that Z"`
- A plain description: `"a todo list app for busy people"`
- A problem statement: `"I always forget my tasks"`

If the seed is a user story, extract role, want, and rationale. If it's a plain description, infer them.

### 2. Read the idea templates for structure

Read `.bloom/idea/templates/` to understand the expected shape of each spine doc. Use them as the output format — don't invent structure.

### 3. Populate the spine docs

Write high-level, honest first drafts. Don't pad or over-engineer. If something can't be inferred from a one-line seed, say so explicitly in the doc with a `<!-- TODO: fill in -->` marker rather than inventing content.

Populate in this order (each builds on the previous):

#### `docs/intent.md`
The spark. Half a page maximum.
- **The idea** — one sentence restatement of the seed, cleaned up
- **The problem** — who has it, why it matters
- **Why now / why us** — one sentence or `<!-- TODO: fill in -->`
- **Pursue / Park / Drop** — leave as `Pursue` (the user is bootstrapping, so they're pursuing)

#### `docs/mission.md`
- **Who we serve** — inferred from the seed role
- **The problem** — one sentence
- **Our solution** — one sentence
- **Vision** — where this leads in 3 years, or `<!-- TODO: fill in -->`
- **Non-goals** — 2–3 obvious exclusions based on the seed (e.g. for a todo app: no calendar sync, no team collaboration, no mobile app — mark these as `<!-- assumption: adjust if wrong -->`)

#### `docs/north-star.md`
- **The metric** — one number that captures whether users are getting value (e.g. `tasks completed per active user per week`)
- **Why this metric** — one sentence
- **Current baseline** — `0 (pre-launch)`
- **Target** — `<!-- TODO: define after first users -->`

#### `docs/product-surfaces.md`
- List the surfaces (pages/routes) implied by the seed. For a todo app: marketing page, auth (sign up / log in), dashboard (task list), task detail.
- Use the template format from `.bloom/idea/templates/product-surfaces.md`.
- Mark anything speculative with `<!-- assumption -->`.

#### `docs/architecture.md`
- **Stack** — read from `.bloom/stack/stack.yaml` (lite profile by default). State it explicitly: "Using the bloom lite profile: Next.js + Supabase."
- **Auth flow** — brief description matching the stack
- **Data model** — minimal. For a todo app: `users`, `tasks` (id, user_id, title, done, created_at). Keep it to what the surfaces actually need.
- Mark anything speculative with `<!-- assumption -->`.

#### `docs/IA-graph.md`
- One section per surface from `product-surfaces.md`.
- For each: key UI elements, primary user action, data shown.
- Keep it to one paragraph per surface. This is IA, not a design spec.

### 4. Present a summary

After writing all six files, show a compact summary table:

```
docs/ populated from seed: "<the seed>"

| File | Status | Notes |
|---|---|---|
| intent.md | ✓ drafted | |
| mission.md | ✓ drafted | 3 assumptions marked |
| north-star.md | ✓ drafted | target metric TBD |
| product-surfaces.md | ✓ drafted | 4 surfaces |
| architecture.md | ✓ drafted | lite profile (Next.js + Supabase) |
| IA-graph.md | ✓ drafted | |

Stack: lite (Next.js 16 + Supabase + Tailwind + shadcn/ui)
Assumptions: <count> marked with <!-- assumption --> — review before build-out.

Next steps:
  Review and edit docs/ — especially mission.md and north-star.md.
  When ready: /bloom-build (or just start coding against the stack profile)
```

### 5. Stop

Do not proceed to build anything. The user reviews first.

## Tone for generated content

- Honest and minimal. Say less rather than more.
- Use plain English, not product-speak.
- Don't write "revolutionize" or "seamless" or "best-in-class".
- Assumptions should be stated as assumptions, not presented as facts.
- The user will edit these — write so they can see what to change.
