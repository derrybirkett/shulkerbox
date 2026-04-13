# Claude Code Hooks

Event-driven hooks for Claude Code sessions and git operations.

## Available Hooks

### post-commit
Automatically appends commit information to the activity log after every commit.

**What it does:**
- Captures timestamp, repo name, branch, and commit message
- Appends entry to `notes/activity-log.md`
- Creates the log file with header if it doesn't exist

**Entry format:**
```markdown
## 2026-04-13 12:00 | repo-name (branch)
**commit message**
```

**Setup:**

For global installation (all repos):
```bash
# Create global hooks directory
mkdir -p ~/.git-hooks

# Symlink the hook
ln -s ~/shulkerbox/hooks/.claude/hooks/post-commit ~/.git-hooks/post-commit
chmod +x ~/.git-hooks/post-commit

# Configure git to use global hooks
git config --global core.hooksPath ~/.git-hooks
```

For per-project installation:
```bash
# Copy to project
cp ~/shulkerbox/hooks/.claude/hooks/post-commit .git/hooks/
chmod +x .git/hooks/post-commit
```

**Note:** The hook expects a `notes/` directory in the repository root. Make sure this exists or the hook will create it automatically.

## Usage with Activity Log Skill

The post-commit hook works in tandem with the `activity-log` skill:
- Hook: Auto-captures commits
- Skill: Queries, filters, and enriches log entries

See [skills/activity-log](../../skills/activity-log/) for details.

## Customization

The hook is a simple bash script. You can modify:
- Log file location (default: `notes/activity-log.md`)
- Entry format
- Additional metadata to capture

## Troubleshooting

### Hook not running
```bash
# Check global hooks path
git config --global core.hooksPath

# Verify hook is executable
ls -la ~/.git-hooks/post-commit
chmod +x ~/.git-hooks/post-commit
```

### Activity log not updating
```bash
# Test hook manually
cd your-repo
.git/hooks/post-commit  # or ~/.git-hooks/post-commit

# Check if notes/ directory exists
ls -la notes/
```

### Wrong log location
Edit the hook's `LOG_FILE` variable to point to your preferred location:
```bash
# In the hook file, line 6:
LOG_FILE="$HOME/Projects/skills/notes/activity-log.md"
```
