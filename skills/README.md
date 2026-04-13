# Skills

Reusable workflows and procedures for LLM-powered development tools.

## What are Skills?

Skills are structured markdown documents that define workflows, procedures, and behaviors for AI assistants like Claude Code, Copilot CLI, and Gemini CLI. They provide consistent, repeatable processes across different tools and projects.

## Structure

Each skill is a directory containing a `SKILL.md` file with frontmatter:

```markdown
---
name: skill-name
description: Brief description of what this skill does
user-invocable: true
argument-hint: optional hint for arguments
metadata:
  tags: [category, keywords]
  category: workflow
---

# Skill Name

[Skill content here]
```

## Available Skills

### Workflow Skills

#### wrap-up
End-of-session workflow. Stages all changes, prompts for a conventional commit message, increments the patch version tag, pushes to origin main with tags, and prepares handover notes.

**Usage:** `/wrap-up` or `wrap-up` (if script is in PATH)

### Productivity Skills

#### activity-log
Maintains a running log of git commits and work sessions. Auto-populated by post-commit hook, queryable for standup prep, learning reviews, and reflection.

**Usage:** `/activity-log [query]`

**Examples:**
- `/activity-log standup` - Last 24-48 hours for standup
- `/activity-log "this week"` - Weekly digest
- `/activity-log "add note"` - Enrich last entry

#### weekly-review
Structured end-of-week reflection. Reads activity log, inbox, and friction log, asks reflective questions, writes review to `notes/reviews/`, and identifies next priorities. The core self-improvement ritual.

**Usage:** `/weekly-review`

**Frequency:** Once per week (Friday afternoon or Monday morning)

#### work-monitor
Context-aware monitoring of GitHub PRs, Jira tickets, and work activity. Adapts to current project, shows what needs attention.

**Usage:** `/work-monitor` or "What needs my attention?"

**Features:**
- PRs awaiting review
- Your open PRs and their status
- Comments and @mentions
- CI check status
- Jira ticket monitoring (requires MCP setup)

### Productivity System

These skills work together as part of the [Productivity System](../docs/PRODUCTIVITY-SYSTEM.md). See that guide for setup and workflows.

## Adding New Skills

1. Create a directory: `mkdir -p skills/my-skill`
2. Create `SKILL.md` with proper frontmatter
3. Document the skill's purpose, trigger, and steps
4. Test across different tools
5. Commit and push

## Tool Compatibility

Skills should be written to work across:
- Claude Code (primary)
- Copilot CLI (with tool mapping)
- Gemini CLI (with tool mapping)
- Other LLM tools that support structured workflows

## Best Practices

1. **Clear triggers**: Define when and how to invoke the skill
2. **Explicit steps**: Number steps and make them actionable
3. **Error handling**: Specify what to do if steps fail
4. **Tool-agnostic**: Avoid tool-specific commands where possible
5. **Document dependencies**: Note any required tools or setup

## Cross-Platform Tools

When writing skills that use tools (like file editing, git commands, etc.), remember:

- **Claude Code**: Uses `Edit`, `Bash`, `Read`, `Write` tools
- **Copilot CLI**: Uses `edit_file`, `run_command`, `read_file`, `write_file`
- **Gemini CLI**: Uses similar tool names with slight variations

Write skills at a high level (e.g., "edit file X to change Y") rather than specifying tool names, and let each platform handle the implementation.
