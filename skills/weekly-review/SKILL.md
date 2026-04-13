---
name: weekly-review
description: Structured end-of-week reflection. Reads the activity log, inbox, and friction log, asks a small set of prompts, then writes a review to notes/reviews/. Surfaces what to build next, what to prune, and what was learned. This is the self-improvement loop that makes the skills repo evolve.
user-invocable: true
argument-hint: optional week date (defaults to current week)
metadata:
  tags: [review, reflection, learning, weekly, retrospective, planning]
  category: productivity
---

# Weekly Review

The ritual that makes the moleskine self-improving. Run once a week — Friday afternoon or Monday morning.

## Trigger

`weekly review` or `/weekly-review`

---

## Step 1 — Gather context

**Notes location:** Use `./notes/` in the current repo if it exists, otherwise fall back to `~/Projects/skills/notes/`.

Read these files silently before asking anything:

| File | Purpose |
|---|---|
| `notes/activity-log.md` | What was worked on — filter to the past 7 days |
| `notes/inbox.md` | Unprocessed captures — ideas, snippets, observations |
| `notes/friction.md` | Recurring pain points flagged during the week |
| `notes/skills-plan.md` | Current skills backlog and priorities |
| `notes/insights.md` | Mid-conversation observations captured via `note-that` |
| `notes/reviews/` | Previous reviews — for continuity and pattern spotting |

Also count the files in `notes/reviews/`. If the count after writing this review will be a **multiple of 4** (i.e. reviews 4, 8, 12, …), this is a **pruning week** — Step 5 applies. Note this internally.

Summarise what you found internally. Don't output anything yet.

---

## Step 2 — Ask four questions

Ask these one at a time. Wait for a real answer before moving on. Don't accept "fine" or "nothing" — push gently for specifics.

1. **What felt hard or slow this week?** *(looking for friction not yet in friction.md)*
2. **What's one thing you'd do differently?** *(process, tool, approach — not just outcome)*
3. **What's the most useful thing you learned?** *(TIL — could be tiny)*
4. **What's been nagging at you that you haven't dealt with?** *(the thing you keep putting off)*

---

## Step 3 — Write the review

Save to `notes/reviews/YYYY-WW.md` (ISO week number, e.g. `2026-13.md`).

```markdown
# Week Review: YYYY-WW
**{Mon DD} – {Sun DD} {Month} {Year}**

## Done this week
{Activity log entries from the past 7 days, grouped by repo/project. One line each.}

## Learned
{TIL entries from the week + the answer to question 3 + any new entries in notes/insights.md since the last review. Bullet points.}

## Friction
{Friction log items raised this week + answer to question 1. Note if recurring.}

## Do differently
{Answer to question 2. Honest, specific.}

## Nagging
{Answer to question 4. Just name it — don't solve it here.}

## Next priority
{One thing: the highest-value next skill to build, note to write, or tooling to improve.
Derived from: friction log patterns, inbox items, skills backlog.}

## Inbox processed
{List each inbox item and what was done with it: actioned / added to skills backlog / discarded.}
```

---

## Step 5 — Skill audit *(pruning weeks only — every 4th review)*

Skip this step unless this is a pruning week.

### 5a — Inventory
List every skill directory under `skills/` in the current repo (or `~/Projects/skills/skills/` if using global fallback). For each one, note its name.

### 5b — Usage signal
Scan the last 4 review files (`notes/reviews/`) for mentions of each skill name. A mention counts as: named in "Done this week", "Next priority", "Learned", or "Friction" sections.

Produce a simple table:

| Skill | Mentions (last 4 reviews) | Verdict |
|---|---|---|
| wrap-up | 3 | keep |
| lean-review | 0 | candidate to prune |

### 5c — Prompt on candidates
For each skill with **0 mentions**, ask:
> **"{skill-name}" hasn't appeared in the last 4 weeks. Keep, prune, or merge with another skill?**

Accept one of:
- **Keep** — it's a reference skill (like `design-principles`) or you know you'll use it
- **Prune** — delete it; git history preserves it if you ever want it back
- **Merge** — combine it into another skill; you say which one

Execute the decision immediately. Don't accumulate a list to do later.

### 5d — Add to review doc
Append a `## Skill audit` section to this week's review:

```markdown
## Skill audit *(monthly)*
{table of all skills with mention counts}

**Pruned:** {list or "none"}
**Merged:** {list or "none"}
**Kept (0 mentions):** {list with reason}
```

---

## Step 4 — Update supporting files

**Inbox:** remove items that have been processed (actioned, added to backlog, or consciously discarded). Leave anything that still needs thought.

**Friction log:** if question 1 surfaced new friction not already logged, append it. If an existing item now has a resolution, mark it.

**Skills plan:** if the review surfaces a clear next priority that isn't already on the list, append it.

---

## Step 6 — Close out

Tell the user:
- Where the review was saved
- What the identified next priority is
- How many inbox items remain unprocessed
- One sentence on the pattern you see across the last 2–3 reviews (if enough history exists)
