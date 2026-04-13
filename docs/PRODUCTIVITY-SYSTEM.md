# Productivity System

A personal knowledge management and self-improvement system built on skills, agents, and structured reflection.

## Overview

The productivity system consists of:
- **productivity-agent**: A coaching persona that maintains your "development moleskine"
- **activity-log**: Auto-captures and queries your commit history
- **weekly-review**: Structured end-of-week reflection ritual
- **work-monitor**: Real-time view of PRs, tickets, and work activity

Together, these create a self-improving loop that surfaces patterns, identifies friction, and guides what to build next.

## The Development Moleskine

Your moleskine lives in `notes/` and contains:

```
notes/
├── activity-log.md       # Auto-populated commit history
├── inbox.md             # Unprocessed captures and ideas
├── friction.md          # Recurring pain points
├── insights.md          # Mid-conversation observations
├── skills-plan.md       # Backlog of skills to build
└── reviews/             # Weekly review archives
    └── YYYY-WW.md
```

Template files are available in [templates/notes/](../templates/notes/).

## Setup

### 1. Initialize Your Moleskine

```bash
# Copy templates to your preferred location
mkdir -p ~/Projects/skills/notes/reviews
cp ~/shulkerbox/templates/notes/*.md ~/Projects/skills/notes/
```

### 2. Install the Post-Commit Hook

This hook auto-captures commits to the activity log:

```bash
# Create global hooks directory
mkdir -p ~/.git-hooks

# Link the hook
ln -s ~/shulkerbox/hooks/.claude/hooks/post-commit ~/.git-hooks/post-commit
chmod +x ~/.git-hooks/post-commit

# Configure git globally
git config --global core.hooksPath ~/.git-hooks
```

### 3. Link the Skills

```bash
# Link productivity skills to Claude Code
ln -s ~/shulkerbox/skills/productivity-agent ~/.claude/skills/
ln -s ~/shulkerbox/skills/activity-log ~/.claude/skills/
ln -s ~/shulkerbox/skills/weekly-review ~/.claude/skills/
ln -s ~/shulkerbox/skills/work-monitor ~/.claude/skills/
```

## Daily Workflows

### Morning Standup Prep
```bash
claude /productivity-agent standup
```

**What it does:**
- Reads activity log from past 24-48 hours
- Summarizes: what was done, what's next, any blockers
- Keeps it under 60 seconds to say aloud

### Check What Needs Attention
```bash
claude /work-monitor
```

**What it does:**
- Shows PRs awaiting your review
- Shows unread comments on your PRs
- Shows failing CI checks
- Shows Jira tickets needing response (if MCP configured)

### Capture Mid-Session Insights
```bash
claude /note-that "observation or insight"
```

**What it does:**
- Appends to `notes/insights.md`
- Surfaces during weekly reviews
- No need to interrupt your flow

## Weekly Workflow

### End-of-Week Review
```bash
claude /weekly-review
```

**The ritual that makes the system self-improving.**

Run every Friday afternoon or Monday morning. The skill will:

1. **Gather context** from all moleskine files
2. **Ask four questions:**
   - What felt hard or slow this week?
   - What's one thing you'd do differently?
   - What's the most useful thing you learned?
   - What's been nagging at you that you haven't dealt with?
3. **Write the review** to `notes/reviews/YYYY-WW.md`
4. **Update supporting files** (inbox, friction, skills-plan)
5. **Every 4th week:** Audit skills and prune unused ones

## The Self-Improvement Loop

```
┌─────────────┐
│   Do Work   │
└──────┬──────┘
       │ (auto-captured via hook)
       ↓
┌─────────────┐
│ Activity Log│
└──────┬──────┘
       │ (weekly review reads)
       ↓
┌─────────────┐
│Weekly Review│ ←── Also reads: inbox, friction, insights
└──────┬──────┘
       │ (surfaces patterns)
       ↓
┌─────────────┐
│ Skills Plan │ ←── What to build next
└──────┬──────┘
       │ (build skills)
       ↓
┌─────────────┐
│  New Skill  │ ──→ Makes future work easier
└─────────────┘
       │
       └──→ Back to "Do Work"
```

## Key Principles

### Honest Reflection Over Comfortable Summaries
The weekly review asks hard questions. Don't accept "fine" or "nothing" as answers.

### Review or It Doesn't Improve
Run `weekly-review` every week without fail. The system only works if you close the loop.

### Ruthless Pruning
- Inbox items not processed in 2 reviews → Discard
- Friction items with no resolution after a month → Fix or close
- Skills with 0 mentions in 4 reviews → Consider pruning
- A bloated moleskine is a useless one

### From Friction to Skills
When in doubt about what to work on next, check the friction log first. The best skills solve real recurring pain.

## Productivity Agent Modes

The productivity-agent has several modes you can invoke:

### Standup
```bash
claude /productivity-agent standup
```
Past 24-48 hours activity, summarized in three bullets.

### Weekly Review
```bash
claude /productivity-agent "weekly review"
```
Full weekly-review skill execution.

### Inbox Triage
```bash
claude /productivity-agent "triage my inbox"
```
Process each inbox item: action, backlog, or discard.

### Friction Check
```bash
claude /productivity-agent "what's been frustrating me?"
```
Surface open friction items and suggest what to address next.

### Learning Review
```bash
claude /productivity-agent "what have I learned lately?"
```
Scan activity log and reviews for TIL entries, identify themes.

## Advanced: Activity Log Queries

The activity-log skill supports flexible queries:

```bash
# Recent activity
claude /activity-log "this week"

# Specific repo
claude /activity-log "show activity for shulkerbox"

# Weekly digest
claude /activity-log "weekly digest"

# Add learning note to last entry
claude /activity-log "add a note"
```

## File Templates

See [templates/notes/](../templates/notes/) for example files:
- [activity-log.md](../templates/notes/activity-log.md)
- [inbox.md](../templates/notes/inbox.md)
- [friction.md](../templates/notes/friction.md)
- [insights.md](../templates/notes/insights.md)
- [skills-plan.md](../templates/notes/skills-plan.md)
- [reviews/2026-15.md](../templates/notes/reviews/2026-15.md)

## Philosophy

This system embodies:
- **Systems thinking** over individual tasks
- **Reflection** over just execution
- **Patterns** over isolated incidents
- **Building tools** over repeating work
- **Honesty** over performative productivity

The goal isn't to track everything — it's to **surface what matters** and **build skills that make you better over time**.

## Troubleshooting

### Activity log not updating
Check that the post-commit hook is installed and executable:
```bash
git config --global core.hooksPath
ls -la ~/.git-hooks/post-commit
```

### Skills not found
Verify symlinks:
```bash
ls -la ~/.claude/skills/ | grep productivity
```

### Notes files missing
Copy from templates:
```bash
cp ~/shulkerbox/templates/notes/*.md ~/Projects/skills/notes/
```

## Related Skills

- [wrap-up](../skills/wrap-up/) - End-of-session commit, tag, push workflow
- [note-that](../skills/note-that/) - Quick insight capture (if available)
- [spec-first](../skills/spec-first/) - Write specs before code (if available)

## Evolution

This system is designed to evolve:
- Skills that get used stay
- Skills with 0 mentions in 4 reviews get pruned
- Friction leads to new skills
- Reviews surface what to build next

**The system should serve you, not constrain you.** Adapt it to your workflow.
