# Project Notes

This directory contains project-specific notes, insights, and activity tracking.

## Structure

- **`inbox.md`** — Quick capture for ideas, TODOs, and handovers between sessions
- **`activity-log.md`** — Auto-populated by git hooks, tracks commits and work sessions
- **`insights.md`** — Learnings, patterns, and observations captured mid-session
- **`friction.md`** — Recurring pain points and frustrations
- **`skills-plan.md`** — Planned or in-progress skill development
- **`reviews/`** — Weekly review summaries

## Privacy

By default, `notes/` is git-ignored (see `.gitignore`). Your personal notes stay local.

**To version control your notes:**
```bash
# Remove notes/ from .gitignore, then:
git add notes/
git commit -m "docs: add project notes"
```

## Usage with Skills

Skills like `wrap-up`, `note-that`, `activity-log`, and `weekly-review` interact with these files:
- `wrap-up` → Writes handovers to `inbox.md`
- `note-that` → Appends to `insights.md`
- `activity-log` → Updates `activity-log.md` via git hook
- `weekly-review` → Reads all notes and writes to `reviews/`

**Note:** Some skills currently reference global paths (`~/Projects/skills/notes/`). These will be updated to automatically use the current project's `notes/` directory. For now, you can manually work with files in this directory.

## Templates

The `templates/notes/` directory contains starter templates if you need to reset or reference the original structure.
