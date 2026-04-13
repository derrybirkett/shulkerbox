# Shulkerbox

A universal resource repository for product development tools, skills, agents, hooks, scripts, and plugins that work across all IDEs, LLMs, and development environments.

## Purpose

Shulkerbox is a centralized, tool-agnostic repository that stores all reusable development resources in one place. Rather than scattering skills across different tools (Claude Code, Copilot CLI, Gemini CLI) or locking resources into specific IDEs, everything lives here and can be referenced globally.

## What Goes Here

- **Skills**: Reusable workflows and procedures for Claude Code, Copilot CLI, Gemini CLI, etc.
- **Hooks**: Event-driven shell commands that respond to development events
- **Scripts**: Automation utilities, build tools, deployment helpers
- **Agents**: Custom agent definitions and personas
- **Plugins**: Extensions and integrations for various tools
- **Templates**: Project scaffolding, boilerplate, and starter files
- **Configs**: Shared configuration files for tools and environments

## Structure

```
shulkerbox/
├── skills/           # LLM skills and workflows
├── hooks/            # Event-driven shell hooks
├── scripts/          # Automation and utility scripts
├── agents/           # Custom agent definitions
├── plugins/          # Tool extensions
├── templates/        # Project templates
├── configs/          # Shared configurations
└── docs/             # Documentation and guides
```

## Featured Systems

### Productivity System
A personal knowledge management and self-improvement system built on skills, agents, and structured reflection. Includes:
- **productivity-agent**: Coaching persona for your development moleskine
- **activity-log**: Auto-captures commit history for standup and reflection
- **weekly-review**: End-of-week reflection ritual that surfaces patterns
- **work-monitor**: Real-time view of PRs, tickets, and work activity

[→ Full Productivity System Guide](docs/PRODUCTIVITY-SYSTEM.md)

## Usage

### Linking Resources

Resources can be symlinked or directly referenced from your tool configurations:

```bash
# Example: Link skills to Claude Code
ln -s ~/shulkerbox/skills ~/.claude/skills

# Example: Link hooks to your project
ln -s ~/shulkerbox/hooks/.claude/hooks ./.claude/hooks
```

### Cross-Platform Compatibility

Resources are designed to be platform-agnostic:

- **Skills**: Written with tool mapping guidance (Claude Code → Copilot CLI → Gemini CLI)
- **Hooks**: Use portable shell scripting (sh/bash)
- **Scripts**: Include shebang lines and handle cross-platform paths
- **Configs**: Use environment variables for tool-specific paths

### Tool Integration

#### Claude Code
```bash
# Reference skills from shulkerbox
export CLAUDE_SKILLS_PATH=~/shulkerbox/skills
```

#### Copilot CLI
```bash
# Install plugins from shulkerbox
copilot plugins add ~/shulkerbox/plugins/my-plugin
```

#### VS Code / JetBrains
```json
{
  "paths": {
    "templates": "~/shulkerbox/templates",
    "scripts": "~/shulkerbox/scripts"
  }
}
```

## Benefits

1. **Single Source of Truth**: One repository for all development resources
2. **Cross-Tool Compatibility**: Works with Claude, Copilot, Gemini, and other tools
3. **Version Control**: Git history tracks evolution of your workflows
4. **Portability**: Easy to clone and use across machines
5. **Shareability**: Can be forked or referenced by teams

## Getting Started

1. Clone this repository to a standard location:
   ```bash
   git clone <repo-url> ~/shulkerbox
   ```

2. Create the basic directory structure:
   ```bash
   cd ~/shulkerbox
   mkdir -p skills hooks scripts agents plugins templates configs
   ```

3. Link resources to your tools:
   ```bash
   # Example for Claude Code
   ln -s ~/shulkerbox/skills ~/.claude/skills
   ```

4. Add your first resource and commit:
   ```bash
   # Create a new skill
   echo "---" > skills/my-skill.md
   echo "name: my-skill" >> skills/my-skill.md
   echo "---" >> skills/my-skill.md
   
   git add skills/my-skill.md
   git commit -m "Add my-skill"
   ```

## Contributing

This is a personal resource repository, but the patterns can be adapted for team use:

1. Fork the repository
2. Add your resources
3. Ensure cross-platform compatibility
4. Document tool-specific requirements
5. Submit a pull request (for team repos)

## Philosophy

> "Tools come and go, but good workflows persist."

By centralizing resources in a tool-agnostic way, you build a library of knowledge that transcends any single IDE or LLM. When you switch tools or new tools emerge, your accumulated expertise remains accessible.

## License

MIT License - see [LICENSE](LICENSE) file for details

## Related

- [Claude Code](https://claude.ai/code)
- [GitHub Copilot CLI](https://githubnext.com/projects/copilot-cli)
- [Gemini CLI](https://github.com/google/generative-ai-cli)
