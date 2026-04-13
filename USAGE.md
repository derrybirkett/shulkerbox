# Usage Guide

This guide shows how to link and use Shulkerbox resources across different tools and environments.

## Initial Setup

1. **Clone Shulkerbox to a standard location:**
   ```bash
   git clone <repo-url> ~/shulkerbox
   ```

2. **Add scripts to your PATH** (optional but recommended):
   ```bash
   echo 'export PATH="$HOME/shulkerbox/scripts/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

## Claude Code

### Link Skills
```bash
# Create a symlink to Shulkerbox skills
ln -s ~/shulkerbox/skills ~/.claude/skills

# Or add specific skills
mkdir -p ~/.claude/skills
ln -s ~/shulkerbox/skills/wrap-up ~/.claude/skills/wrap-up
```

### Use Skills
```bash
# In Claude Code CLI
claude /wrap-up

# Or if you added scripts to PATH
wrap-up
```

### Link Hooks
```bash
# Link hooks to your project
ln -s ~/shulkerbox/hooks/.claude/hooks ./.claude/hooks

# Or link globally (affects all projects)
ln -s ~/shulkerbox/hooks/.claude/hooks ~/.claude/hooks
```

## Copilot CLI

### Install Skills as Plugins
```bash
# Copilot CLI uses a plugin architecture
# Link or copy skills to the plugins directory
ln -s ~/shulkerbox/skills ~/.copilot/plugins/shulkerbox
```

### Use Skills
```bash
# Use the skill command
copilot skill wrap-up
```

## Gemini CLI

### Link Skills
```bash
# Gemini CLI looks for skills in specific directories
mkdir -p ~/.gemini/skills
ln -s ~/shulkerbox/skills/* ~/.gemini/skills/
```

### Use Skills
```bash
# Activate skill via the CLI
gemini activate-skill wrap-up
```

## VS Code Extension

### Configure in settings.json
```json
{
  "claude.skillsPath": "~/shulkerbox/skills",
  "claude.hooksPath": "~/shulkerbox/hooks",
  "claude.scriptsPath": "~/shulkerbox/scripts"
}
```

### Use Skills
- Command Palette: `Claude: Run Skill`
- Select from available skills

## JetBrains IDEs

### Configure in Settings
1. Open Settings → Tools → Claude Code
2. Set Skills Path: `~/shulkerbox/skills`
3. Set Hooks Path: `~/shulkerbox/hooks`

### Use Skills
- Action Menu: `Run Claude Skill`
- Select from available skills

## Standalone Scripts

Scripts in `scripts/bin/` can be used independently:

```bash
# Add to PATH (recommended)
export PATH="$HOME/shulkerbox/scripts/bin:$PATH"

# Then use directly
wrap-up

# Or invoke directly
~/shulkerbox/scripts/bin/wrap-up
```

## Example: Using wrap-up Skill

The `wrap-up` skill is an end-of-session workflow that commits, tags, and pushes your changes.

### In Claude Code
```bash
# Via skill invocation
claude /wrap-up

# Or if script is in PATH
wrap-up
```

### In Copilot CLI
```bash
copilot skill wrap-up
```

### What it does
1. Shows git status and diff
2. Stages all changes
3. Prompts for conventional commit message
4. Creates commit
5. Determines and applies semver tag
6. Pushes to origin with tags
7. Optionally adds learning notes
8. Creates handover notes for next session

## Multi-Tool Workflow

You can use the same skills across different tools in the same project:

```bash
# Morning: Start with Claude Code
cd ~/my-project
claude /spec-first "Add user authentication"

# Afternoon: Continue with Copilot CLI
copilot skill task-model "Break down auth work"

# Evening: Wrap up with either tool
wrap-up  # Uses the script in PATH
```

## Best Practices

1. **Symlink, don't copy**: Use symlinks so updates propagate to all tools
2. **Version control**: Keep Shulkerbox in git to track changes
3. **Tool-agnostic skills**: Write skills that work across platforms
4. **Document dependencies**: Note if a skill requires specific tools
5. **Test cross-platform**: Verify skills work in different environments

## Troubleshooting

### Symlinks not working
```bash
# Check if symlink is valid
ls -la ~/.claude/skills

# Recreate if broken
rm ~/.claude/skills
ln -s ~/shulkerbox/skills ~/.claude/skills
```

### Script not found
```bash
# Verify PATH includes scripts
echo $PATH | grep shulkerbox

# Or use absolute path
~/shulkerbox/scripts/bin/wrap-up
```

### Permission denied
```bash
# Make scripts executable
chmod +x ~/shulkerbox/scripts/bin/*
```

## Adding New Resources

### Adding a Skill
```bash
# Create skill directory and file
mkdir -p ~/shulkerbox/skills/my-skill
cat > ~/shulkerbox/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: Does something useful
user-invocable: true
---

# My Skill

[Skill content here]
EOF

# Commit
git add skills/my-skill
git commit -m "feat: add my-skill"
```

### Adding a Script
```bash
# Create script
cat > ~/shulkerbox/scripts/bin/my-script << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Script logic here
EOF

# Make executable
chmod +x ~/shulkerbox/scripts/bin/my-script

# Commit
git add scripts/bin/my-script
git commit -m "feat: add my-script"
```

### Adding a Hook
```bash
# Create hook
mkdir -p ~/shulkerbox/hooks/.claude/hooks
cat > ~/shulkerbox/hooks/.claude/hooks/post-commit << 'EOF'
#!/usr/bin/env bash
# Hook logic here
EOF

# Make executable
chmod +x ~/shulkerbox/hooks/.claude/hooks/post-commit

# Commit
git add hooks/
git commit -m "feat: add post-commit hook"
```
