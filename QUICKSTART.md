# Quick Start

Get up and running with Shulkerbox in 5 minutes.

## 1. Clone the Repository

```bash
git clone <repo-url> ~/shulkerbox
cd ~/shulkerbox
```

## 2. Add Scripts to PATH

```bash
# For zsh (macOS default)
echo 'export PATH="$HOME/shulkerbox/scripts/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'export PATH="$HOME/shulkerbox/scripts/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 3. Link Skills to Claude Code

```bash
# Create symlink
ln -s ~/shulkerbox/skills ~/.claude/skills

# Verify
ls -la ~/.claude/skills
```

## 4. Try Your First Skill

```bash
# In any project directory
cd ~/your-project

# Use the wrap-up skill
claude /wrap-up

# Or use the script wrapper
wrap-up
```

## What Just Happened?

The `wrap-up` skill:
1. Showed your uncommitted changes
2. Staged them with `git add -A`
3. Prompted for a commit message (in conventional format)
4. Created the commit
5. Determined the next version tag
6. Pushed to origin with tags
7. Offered to add learning notes and handover tasks

## Next Steps

### Explore Available Resources

```bash
# List skills
ls ~/shulkerbox/skills/

# List scripts
ls ~/shulkerbox/scripts/bin/

# Read documentation
cat ~/shulkerbox/skills/README.md
```

### Add Your Own Skill

```bash
# Create new skill
mkdir -p ~/shulkerbox/skills/my-skill

# Create skill file
cat > ~/shulkerbox/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: My custom workflow
user-invocable: true
---

# My Skill

## Trigger
`/my-skill`

## Steps
1. Do something useful
2. Report results
EOF

# Test it
claude /my-skill
```

### Link Hooks (Optional)

```bash
# For project-specific hooks
cd ~/your-project
mkdir -p .claude/hooks
ln -s ~/shulkerbox/hooks/.claude/hooks/* .claude/hooks/

# For global hooks (all projects)
ln -s ~/shulkerbox/hooks/.claude/hooks ~/.claude/hooks
```

## Common Workflows

### Start New Project
```bash
# Use a project template
cp -r ~/shulkerbox/templates/projects/my-template ./new-project
cd new-project
npm install
```

### Share Config Across Projects
```bash
# Link TypeScript config
ln -s ~/shulkerbox/configs/typescript/tsconfig.base.json tsconfig.json

# Or extend it
echo '{ "extends": "~/shulkerbox/configs/typescript/tsconfig.base.json" }' > tsconfig.json
```

### Add Custom Script
```bash
# Create script
cat > ~/shulkerbox/scripts/bin/my-command << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Hello from my-command!"
EOF

# Make executable
chmod +x ~/shulkerbox/scripts/bin/my-command

# Use it
my-command
```

## Troubleshooting

### "claude: command not found"
Install Claude Code CLI:
- Visit https://claude.ai/code
- Follow installation instructions

### "wrap-up: command not found"
Check PATH:
```bash
echo $PATH | grep shulkerbox
```

If not there, re-source your shell config:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### Skills Not Found
Verify symlink:
```bash
ls -la ~/.claude/skills
```

Should show: `~/.claude/skills -> /Users/you/shulkerbox/skills`

If broken, recreate:
```bash
rm ~/.claude/skills
ln -s ~/shulkerbox/skills ~/.claude/skills
```

## Documentation

- [README.md](README.md) - Overview and philosophy
- [USAGE.md](USAGE.md) - Detailed usage guide
- [skills/README.md](skills/README.md) - Skills documentation
- [scripts/README.md](scripts/README.md) - Scripts documentation
- [hooks/README.md](hooks/README.md) - Hooks documentation

## Get Help

- Check the README files in each directory
- Read the USAGE guide for detailed examples
- Review existing skills for patterns
- Open an issue if you find bugs

## What's Next?

1. **Customize**: Add your own skills, scripts, and templates
2. **Share**: Use the same resources across all tools
3. **Evolve**: Update as you learn new patterns
4. **Contribute**: Share useful resources back

The goal is to build a library of knowledge that persists regardless of which tools you use. Start small, add incrementally, and let it grow naturally with your workflow.
