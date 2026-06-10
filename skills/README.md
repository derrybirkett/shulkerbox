# Skills

Reusable workflows and procedures for LLM-powered development tools.

## What are Skills?

Skills are structured markdown documents that define workflows, procedures, and behaviors for AI assistants like Claude Code, Copilot CLI, and Gemini CLI. They provide consistent, repeatable processes across different tools and projects.

## Structure

Each skill is a directory containing a `SKILL.md` file with frontmatter:

```markdown
---
name: skill-name
description: Brief, specific description of what this skill does and when to use it
user-invocable: true
disable-model-invocation: true  # Optional: hide from Claude until user invokes
context: fork                   # Optional: run in isolated context
argument-hint: optional hint for arguments
metadata:
  tags: [category, keywords]
  category: workflow
---

# Skill Name

[Skill content here]
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Kebab-case, unique identifier |
| `description` | Yes | Clear description - Claude uses this to decide relevance! |
| `user-invocable` | Yes | Can user invoke with `/skill-name`? |
| `disable-model-invocation` | No | If `true`, only user can invoke (saves context) |
| `context` | No | Set to `fork` to run in isolated subagent context |
| `argument-hint` | No | Shows in autocomplete |
| `metadata.tags` | No | For discovery and organization |
| `metadata.category` | No | Grouping |

### When to Use Special Fields

**`disable-model-invocation: true`**
- Skills with side effects (git operations, deployments)
- User-only workflows (wrap-up, release)
- Saves context: skill won't load until you invoke it

**`context: fork`**
- Work that reads many files but only needs to return summary
- Parallel tasks that don't need main conversation history
- Keeps main context clean

## Available Skills

### Bloom Skills

#### product
End-to-end product developer. Drives a seed idea through six stages — capability scan → define → architect → scaffold → build slice → review — using whichever Bloom repos are mounted at `.bloom/*`. Falls back to embedded defaults so it works in shulkerbox-only repos.

**Usage:** `/product "<seed>"`

**Sub-commands:**
- `/product run "<seed>"` — autonomous (stops only on block/test fail)
- `/product resume` — pick up from current `docs/` + git state
- `/product status` — capability scan + current stage + next action
- `/product next-slice` — jump to Stage 4 with next priority surface

**Aliases:** `/develop`, `/build-product` (both route to `/product`)

**Related:** [product agent](../agents/product/AGENT.md), [bloom-define](core/bloom-define/SKILL.md)

#### bloom-define
Seed the product spine (`docs/`) from a one-line idea or user story. Populates intent, mission, north-star, product-surfaces, architecture, and IA-graph at a high level for review before any build-out.

**Usage:** `/bloom-define "<seed>"`

### Workflow Skills

#### wrap-up
End-of-session workflow. Stages changes, drafts a conventional commit message, runs pre-commit and manifest-drift checks, manages version tags, and handles both PR-based and direct-to-main workflows (PR-based is the bloom default). Optionally updates the changelog, publishes a GitHub release, files next-step issues, and writes the activity log — driven by `.shulkerbox/config.yml`.

**Usage:** `/wrap-up [optional commit message]`

#### handover
End-of-session context capture. Writes what the next session needs to pick up seamlessly.

**Usage:** `/handover`

#### pickup
Start-of-session context restoration. Shows where the last session left off; the counterpart to handover.

**Usage:** `/pickup`

### Productivity Skills

#### note-that
Frictionless insight capture. Say "note that ..." mid-conversation and the observation is captured to notes without breaking flow.

**Usage:** `/note-that "<observation>"` or just "note that ..."

#### sovereyn
Strategic coaching. Cross-references stated goals against actual shipping behaviour, surfaces drift, asks hard questions.

**Usage:** `/sovereyn`

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

## Context Costs

Understanding context costs helps you build an effective skill library:

### How Skills Load

1. **At session start**: Skill descriptions load (unless `disable-model-invocation: true`)
2. **On invocation**: Full skill content loads into conversation
3. **In subagents**: Skills are fully preloaded at launch (different from main context)

### Cost by Type

| Skill Type | Description Cost | Content Cost |
|------------|------------------|--------------|
| Default skill | Every request | On use |
| `disable-model-invocation: true` | None | On user invocation |
| In subagent (`context: fork`) | None (isolated) | Full at subagent start |

### Optimize Context

- **Write clear descriptions**: Claude uses these to decide relevance
- **Use `disable-model-invocation: true`** for user-only skills (zero cost)
- **Use `context: fork`** for expensive operations that only need to return summary
- **Keep skills focused**: Small, single-purpose skills are easier to load selectively

## Best Practices

1. **Clear, specific descriptions**: Claude reads these to decide when to load the skill
2. **Explicit steps**: Number steps and make them actionable
3. **Error handling**: Specify what to do if steps fail
4. **Tool-agnostic**: Avoid tool-specific commands where possible
5. **Document dependencies**: Note any required tools or setup
6. **Side effects**: Use `disable-model-invocation: true` for skills that modify state

## Cross-Platform Tools

When writing skills that use tools (like file editing, git commands, etc.), remember:

- **Claude Code**: Uses `Edit`, `Bash`, `Read`, `Write` tools
- **Copilot CLI**: Uses `edit_file`, `run_command`, `read_file`, `write_file`
- **Gemini CLI**: Uses similar tool names with slight variations

Write skills at a high level (e.g., "edit file X to change Y") rather than specifying tool names, and let each platform handle the implementation.
