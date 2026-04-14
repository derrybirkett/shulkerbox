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
- **Library**: Curated reference materials, documentation links, and research

## Structure

```
shulkerbox/
├── skills/           # Workflows organized by category
│   ├── core/         # Essential workflows (wrap-up, handover, pickup, note-that)
│   ├── productivity/ # Reflection & learning (activity-log, weekly-review)
│   ├── development/  # Dev workflows (work-monitor)
│   ├── design/       # Design workflows
│   └── coaching/     # Meta-skills
├── agents/           # Agent personas with expertise
│   └── productivity/ # Personal systems coach
├── .claude/          # Project subagents (context isolation)
│   └── agents/       # Task workers (code-reviewer, test-runner, etc.)
├── hooks/            # Event-driven shell hooks
│   └── .claude/hooks/# Git hooks (pre-commit, post-commit, session-start)
├── automation/       # Scheduled tasks and maintenance
├── notes/            # Project-specific notes (git-ignored)
├── scripts/          # Automation and utility scripts
├── plugins/          # Tool extensions
├── templates/        # Project templates and scaffolding
├── configs/          # Shared configurations
├── library/          # Reference materials and documentation links
└── docs/             # Documentation and guides
```

## Core Concepts

### Skills vs Agents vs Subagents

Shulkerbox follows Claude Code's architectural patterns:

**Skills** (SKILL.md in `skills/`)
- Reusable workflows that run in main conversation context
- Step-by-step instructions for common tasks
- Invoked with `/skill-name` or auto-triggered by Claude
- Examples: `/wrap-up`, `/note-that`, `/pickup`

**Agents** (AGENT.md in `agents/`)
- Specialized personas with domain expertise and coaching style
- Embody knowledge, opinions, and decision-making approaches
- Guide work through specific lenses (productivity, design, development)
- Example: [productivity agent](agents/productivity/)

**Subagents** (.md in `.claude/agents/`)
- Task workers with isolated context windows
- Keep verbose operations out of main conversation
- Tool-restricted for specific purposes (read-only review, isolated testing)
- Examples: code-reviewer, test-runner, researcher

[→ Full Architecture Guide](docs/ARCHITECTURE.md)

## Featured Systems

### Session Continuity
Never lose context between sessions:
- **handover**: Captures pending tasks, decisions, and blockers at session end
- **pickup**: Restores context in <30s at session start
- **session-start hook**: Auto-notifies of pending work

### Self-Improvement Loop
Continuous learning and workflow optimization:
- **note-that**: Frictionless mid-conversation insight capture
- **activity-log**: Auto-captures commit history (via post-commit hook)
- **weekly-review**: End-of-week reflection that surfaces patterns
- **productivity-agent**: Coaching persona that observes and improves workflows

### Work Management
Real-time visibility into your work:
- **work-monitor**: GitHub PRs, Jira tickets, and team activity
- Context-aware: auto-detects current project

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

See [QUICKSTART.md](QUICKSTART.md) for 5-minute setup or [USAGE.md](USAGE.md) for detailed usage guide.

**Quick setup:**

```bash
# Clone
git clone https://github.com/derrybirkett/shulkerbox.git ~/shulkerbox

# Link skills
ln -s ~/shulkerbox/skills ~/.claude/skills

# Add scripts to PATH
echo 'export PATH="$HOME/shulkerbox/scripts/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Try it
wrap-up
```

## Key Documentation

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - Core concepts and design principles ⭐
- **[QUICKSTART.md](QUICKSTART.md)** - Get running in 5 minutes
- **[USAGE.md](USAGE.md)** - Detailed usage across tools
- **[Productivity System](docs/PRODUCTIVITY-SYSTEM.md)** - Self-improvement loop guide
- **[Subagents Guide](docs/SUBAGENTS.md)** - When and how to use isolated workers
- **[Library](library/)** - Curated reference materials and patterns

## Project Notes

Shulkerbox includes a project-scoped notes system:

- **[notes/](notes/)** - Activity log, inbox, insights, friction log (git-ignored by default)
- **[templates/notes/](templates/notes/)** - Note templates for new projects

Skills like `wrap-up`, `note-that`, and `weekly-review` interact with `notes/` to maintain project context.

## Templates

Start new projects with our templates:

- **[CLAUDE.md](templates/CLAUDE.md)** - Project conventions and always-on context
- **[.claude/rules/](templates/.claude/rules/)** - Path-specific guidelines (load only when working with matching files)
- **[notes/ templates](templates/notes/)** - Copy to new projects for note-taking structure

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
