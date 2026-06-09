---
name: product
description: Drive a seed idea through the full Bloom loop — define, architect, scaffold, build, review — using whichever Bloom repos are mounted, with embedded fallbacks for shulkerbox-only repos.
user-invocable: true
argument-hint: "[run|resume|status|next-slice] \"your seed idea\""
metadata:
  tags: [bloom, product, develop, define, build, review, loop]
  category: core
  audience: core
---

# Product

Slash-command entry point for the `product` agent. Turns a seed into a working product slice by composing `soul`, `idea`, `stack`, `shulkerbox`, and `council` when mounted, and falling back to embedded defaults when only `shulkerbox` is present.

The full behavior lives in [`agents/product/AGENT.md`](../../../agents/product/AGENT.md). This skill is the lightweight handle for invoking it.

## Trigger

```
/product "<seed>"                  # stage-gated, default
/product run "<seed>"              # autonomous, stops only on block/test fail
/product resume                    # pick up from current docs/ + git state
/product status                    # capability scan + stage + next action
/product next-slice                # jump straight to Stage 4 with next priority
```

Examples:

```
/product "a simple todo list app"
/product "As a freelancer, I want to track invoices so I get paid on time"
/product run "a habit tracker with streaks"
/product resume
/product status
```

## Pre-flight

Before running any stage, the skill does three things:

### 1. Confirm the seed (or resume context)

- If no argument and no `docs/intent.md` exists → ask: *"What's the idea? Give me a sentence or a user story."*
- If `resume` → read `docs/intent.md` and recent commits to infer current stage. Announce it.
- If a seed is provided → use it verbatim.

### 2. Capability scan

Probe for sibling Bloom repos:

| Path | If present | If missing |
|---|---|---|
| `.bloom/soul/` | use it | use [`fallbacks/soul-defaults.md`](../../../agents/product/context/fallbacks/soul-defaults.md) |
| `.bloom/idea/` | use it | use [`fallbacks/idea-templates.md`](../../../agents/product/context/fallbacks/idea-templates.md) |
| `.bloom/stack/` | use it | use [`fallbacks/stack-defaults.md`](../../../agents/product/context/fallbacks/stack-defaults.md) |
| `.bloom/council/` | use it | use [`fallbacks/council-checks.md`](../../../agents/product/context/fallbacks/council-checks.md) |
| `.bloom/shulkerbox/` or this repo | always required | hard fail if absent |

Print the scan result before doing anything else:

```
Bloom capability scan
  ✓ shulkerbox       (required)
  ✓ idea             (.bloom/idea/)
  ✗ soul             → fallback
  ✗ stack            → fallback
  ✗ council          → fallback

Mode: shulkerbox + idea, with embedded fallbacks for soul/stack/council.
Proceed? [y/N]
```

In `run` mode, skip the prompt and proceed unless any required piece is missing.

### 3. Target directory check

- Current working directory should be a product root (has, or can have, a `docs/` directory and a `package.json` for built slices).
- If `.bloom/` doesn't exist at all and we're not at the root of `shulkerbox` itself, ask: *"No `.bloom/` directory found. Are we in a product directory, or is this a fresh repo? [product / fresh / abort]"*

## Routing

The skill is a thin dispatcher onto the `product` agent's stages:

| Sub-command | Maps to |
|---|---|
| (no sub) | Stage 0 → 1, then stop |
| `run` | Stage 0 → 6 autonomously |
| `resume` | Infer stage from `docs/` + git, continue from there |
| `status` | Stage 0 only — print capability + current stage + next action |
| `next-slice` | Stage 4 with next-priority surface from `docs/product-surfaces.md` |

Each stage's behavior is fully defined in [`agents/product/AGENT.md`](../../../agents/product/AGENT.md) — this skill should not duplicate it.

## Stop conditions

Regardless of mode, halt and surface to the user when:

- Capability scan finds zero usable pieces (no shulkerbox, no fallbacks readable)
- A stage produces no output (something went wrong)
- Council (or `council-checks.md` fallback) returns `block`
- A test fails after Stage 4
- A decision arises that contradicts `docs/intent.md` or `docs/mission.md` with no clear user preference

Never silently fall through a stop condition. Print the reason and wait.

## Atomic commits

Each stage commits separately. Within Stage 4 (build slice), each logical step (migration, route, server action, UI, test) commits separately. The git log should read like a build log.

Use Conventional Commit prefixes:

- `docs:` for Stage 1 spine writes
- `chore:` for Stage 3 scaffolds
- `feat:` for Stage 4 surface work
- `test:` for happy-path tests
- `docs(review):` for Stage 5 review notes

## Skills invoked along the way

| Skill | Stage |
|---|---|
| [`bloom-define`](../bloom-define/SKILL.md) | Stage 1 (if `.bloom/idea/` mounted) |
| `note-that` | Any stage, when a non-obvious decision is made |
| `handover` | If pausing mid-stage |
| `design-audit` (via designer subagent) | End of Stage 4 for UI slices |

## Output

The skill itself produces nothing — the agent's stages produce:

- `docs/*.md` (Stage 1)
- A running scaffolded app (Stage 3)
- New routes, migrations, components, tests (Stage 4)
- `notes/reviews/slice-<n>.md` (Stage 5)
- A commit per stage (and per logical sub-step in Stage 4)

## Stop

The skill itself stops as soon as control is handed to the agent's first stage. The agent owns the rest of the run.

## Tone

- Announce the mode (full Bloom vs. fallbacks) honestly — never paper over capability gaps.
- One question at a time, never bundled.
- Show diffs and file links, not full file contents.
- Mark assumptions with `<!-- assumption -->` in any generated doc.
