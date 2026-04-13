---
name: activity-log
description: Maintains a running log of git commits and work sessions across all repos. Use to review recent activity, surface learning patterns, prep standup notes, or reflect on what was worked on. A post-commit git hook auto-appends entries; this skill helps query and enrich them.
user-invocable: true
argument-hint: "query or action, e.g. 'standup', 'this week', 'add note'"
metadata:
  tags: [logging, reflection, learning, git, standup, activity, journal]
  category: productivity
---

# Activity Log

This skill maintains and queries a running log of work activity, auto-populated by a post-commit git hook and enrichable with learning notes.

## Log location

```
~/Projects/skills/notes/activity-log.md
```

Each entry is appended automatically on every `git commit` across all repos (requires global hook — see setup below).

## Entry format

```markdown
## 2026-03-27 14:32 | repo-name (branch)
**commit message here**

<!-- optional learning note added via this skill -->
```

---

## Workflows

### Standup prep
> "What did I work on yesterday / this week?"

Read `notes/activity-log.md`, filter by date range, summarise into bullet points grouped by repo.

### Learning review
> "What have I been learning lately?"

Read recent entries and surface patterns: new tools used, problems solved, recurring themes. Output as a short reflection.

### Enrich an entry
> "Add a note to my last log entry"

Append a learning note or reflection below the most recent entry. Use a `> ` blockquote to distinguish manual notes from auto-generated lines.

### Filter by repo
> "Show activity for [repo-name]"

Filter entries where the repo name matches.

### Weekly digest
> "Weekly digest"

Summarise the past 7 days: repos touched, key commits, anything worth remembering, open threads.

---

## Hook setup (one-time)

The post-commit hook lives at `~/Projects/skills/hooks/post-commit`.

To activate it globally across all repos:

```bash
# Create a global hooks directory
mkdir -p ~/.git-hooks

# Symlink the post-commit hook into it
ln -s ~/Projects/skills/hooks/post-commit ~/.git-hooks/post-commit
chmod +x ~/Projects/skills/hooks/post-commit

# Tell git to use it globally
git config --global core.hooksPath ~/.git-hooks
```

To verify:
```bash
git config --global core.hooksPath
# should output: /Users/dbirkett/.git-hooks
```
