# Hooks

Event-driven scripts that respond to development events. Only hooks that
actually exist are listed here — no aspirational structure.

## Available hooks

| Hook | Event | What it does |
|---|---|---|
| [`git/post-commit-activity-log`](git/post-commit-activity-log) | git post-commit | Appends every commit (timestamp, repo, branch, subject) to `notes/activity-log.md` — the log the [activity-log skill](../skills/productivity/activity-log/SKILL.md) queries and enriches. No-op in repos without that file. |

## Install

```bash
cp .bloom/shulkerbox/hooks/git/post-commit-activity-log .git/hooks/post-commit
chmod +x .git/hooks/post-commit
```

Note: the no-main-commits git hooks live in [stack](https://github.com/derrybirkett/stack)
(`configs/git/hooks/`), not here — stack owns repo configuration, shulkerbox
owns workflow automation.

## Writing a new hook

- One file per hook under a directory named for the event source (`git/`,
  `claude/`, ...).
- Fast, silent on success, idempotent, exits non-zero only when a pre- hook
  should abort the operation.
- A hook ships in the same PR as its README row. If a hook is unused for a
  month, prune it.
