# Hooks

Event-driven shell commands that respond to development events.

## What are Hooks?

Hooks are executable scripts that run automatically in response to events like:
- Git operations (commit, push, merge)
- Tool events (session start, task complete)
- File changes (save, create, delete)
- Build events (success, failure)

## Structure

Hooks are organized by tool and event type:

```
hooks/
├── .claude/
│   └── hooks/
│       ├── post-commit
│       ├── pre-commit
│       └── session-start
├── .git/
│   └── hooks/
│       ├── pre-commit
│       └── post-commit
└── .copilot/
    └── hooks/
```

## Hook Types

### Git Hooks
Standard git hooks that run during git operations:
- `pre-commit` - Run before commit is created
- `post-commit` - Run after commit is created
- `pre-push` - Run before pushing to remote
- `post-merge` - Run after merge completes

### Tool Hooks
Tool-specific hooks for LLM assistants:
- `session-start` - Run when starting a new session
- `session-end` - Run when ending a session
- `task-complete` - Run when a task finishes
- `tool-call` - Run before/after tool invocations

## Writing Hooks

### Basic Template
```bash
#!/usr/bin/env bash
#
# hook-name — Description
#
# Runs: when this event occurs
#

set -euo pipefail

# Hook logic here
```

### Guidelines

1. **Fast execution**: Hooks should complete quickly
2. **Silent by default**: Only output on errors
3. **Non-blocking**: Don't interrupt user workflow
4. **Idempotent**: Safe to run multiple times
5. **Error handling**: Exit with appropriate codes

### Exit Codes
- `0` - Success, continue operation
- `1` - Error, abort operation (for pre- hooks)
- Other - Tool-specific handling

## Using Hooks

### Local (per-project)
```bash
# Link to project
mkdir -p .claude/hooks
ln -s ~/shulkerbox/hooks/.claude/hooks/* .claude/hooks/
```

### Global (all projects)
```bash
# Link globally
ln -s ~/shulkerbox/hooks/.claude/hooks ~/.claude/hooks
```

### Git Hooks
```bash
# Link git hooks
ln -s ~/shulkerbox/hooks/.git/hooks/* .git/hooks/
chmod +x .git/hooks/*
```

## Example Hooks

### Post-Commit Activity Logger
Automatically log commits to an activity log:
```bash
#!/usr/bin/env bash
set -euo pipefail

echo "$(date -Iseconds) - $(git log -1 --pretty=%s)" >> ~/activity.log
```

### Pre-Commit Linter
Run linting before allowing commit:
```bash
#!/usr/bin/env bash
set -euo pipefail

npm run lint
```

### Session Start Reminder
Show pending tasks at session start:
```bash
#!/usr/bin/env bash
set -euo pipefail

if [ -f "TODO.md" ]; then
    echo "📋 Pending tasks:"
    grep "- \[ \]" TODO.md || echo "  None!"
fi
```

## Best Practices

1. **Check dependencies**: Verify required tools are available
2. **Handle missing files**: Don't assume files exist
3. **Use absolute paths**: `$HOME` instead of `~`
4. **Make executable**: `chmod +x hook-file`
5. **Test thoroughly**: Hooks can break workflows if buggy
6. **Document behavior**: Comment what the hook does and when

## Troubleshooting

### Hook not running
```bash
# Check if executable
ls -la .claude/hooks/

# Make executable
chmod +x .claude/hooks/*
```

### Hook failing silently
```bash
# Test manually
./.claude/hooks/hook-name

# Check error output
./.claude/hooks/hook-name 2>&1 | tee hook-error.log
```

### Disable hook temporarily
```bash
# Rename to disable
mv .claude/hooks/hook-name .claude/hooks/hook-name.disabled

# Or remove execute permission
chmod -x .claude/hooks/hook-name
```
