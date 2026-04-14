# Shulkerbox Architecture

## Overview

Shulkerbox is a Claude-native AI co-pilot toolkit built on three core architectural concepts: **Skills**, **Agents**, and **Subagents**. Understanding the distinction between these is essential to using the system effectively.

## Core Concepts

### Skills (SKILL.md files)

**What**: Reusable workflows and procedures  
**Where**: `skills/` directory or `.claude/skills/`  
**Run**: In the MAIN conversation context  
**Purpose**: Give Claude step-by-step instructions for common tasks

**Example**: [wrap-up](../skills/core/wrap-up/), [note-that](../skills/core/note-that/), [weekly-review](../skills/productivity/weekly-review/)

**When to create a skill**:
- Workflow you repeat often (>3 times)
- Multi-step process that needs consistency
- Pattern worth capturing for reuse
- Task that benefits from structured approach

**Structure**:
```yaml
---
name: skill-name
description: When to use this skill (Claude reads this!)
user-invocable: true
disable-model-invocation: false  # true for side effects
metadata:
  tags: [purpose, scope, timing]
  category: core|productivity|development|design|coaching
---

# Skill Name

[Step-by-step instructions]
```

### Agents (AGENT.md files)

**What**: Specialized personas with expertise and opinions  
**Where**: `agents/` directory  
**Purpose**: Embody domain expertise, coaching style, decision-making approach

**Example**: [Productivity Agent](../agents/productivity/), Designer Agent, Developer Agent

**When to create an agent**:
- Need specialized expertise (design, development, product)
- Want consistent persona across sessions
- Require domain-specific coaching
- Building knowledge base over time

**Structure**:
```yaml
---
name: agent-name
persona: Brief persona description
specialization: [domain1, domain2]
skills-used: [skill1, skill2]
---

# Agent Name

## Role
[Who this agent is]

## Expertise
[What domains]

## Interaction Style
[How they communicate]
```

### Subagents (.claude/agents/*.md)

**What**: Task workers with isolated context windows  
**Where**: `.claude/agents/` directory  
**Run**: Separate context via Agent tool, return summaries only  
**Purpose**: Keep verbose operations out of main context, enforce tool restrictions

**Example**: code-reviewer (read-only), test-runner (isolated output), researcher

**When to create a subagent**:
- Operation produces verbose output (tests, logs, search)
- Need tool restrictions (read-only reviewer)
- Want context isolation (research in separate window)
- Task returns summary, not full results

**Structure**:
```yaml
---
name: subagent-name
description: When Claude should delegate to this
tools: Read, Grep, Glob  # Restrict tools
model: haiku  # Can use faster/cheaper model
memory: project  # Persistent learning
---

[System prompt for isolated context]
```

## Directory Structure

```
shulkerbox/
├── skills/                    # Workflows organized by category
│   ├── core/                  # Essential workflows
│   │   ├── wrap-up/
│   │   ├── handover/
│   │   ├── pickup/
│   │   └── note-that/
│   ├── productivity/          # Reflection & learning
│   │   ├── activity-log/
│   │   ├── weekly-review/
│   │   ├── friction-tracker/
│   │   └── learning-review/
│   ├── development/           # Dev workflows
│   ├── design/                # Design workflows
│   └── coaching/              # Meta-skills
│
├── agents/                    # Agent personas
│   ├── productivity/
│   │   ├── AGENT.md
│   │   └── context/          # Agent knowledge base
│   ├── designer/
│   ├── developer/
│   └── product/
│
├── .claude/                   # Project subagents
│   └── agents/
│       ├── code-reviewer.md
│       ├── test-runner.md
│       └── researcher.md
│
├── hooks/                     # Git & session hooks
│   └── .claude/hooks/
│       ├── post-commit
│       ├── pre-commit
│       └── session-start
│
├── automation/                # Scheduled tasks
│   ├── cron/
│   └── maintenance/
│
├── notes/                     # Project notes (git-ignored)
│   ├── activity-log.md
│   ├── inbox.md
│   ├── insights.md
│   ├── friction.md
│   └── reviews/
│
├── templates/                 # Project scaffolding
├── library/                   # Reference materials
├── docs/                      # Documentation
└── configs/                   # Shared configs
```

## Key Workflows

### Session Continuity

**End of Session**:
1. User runs `/wrap-up`
2. wrap-up commits, tags, pushes
3. wrap-up invokes `handover` skill
4. handover extracts context to `notes/inbox.md`
5. Tags items: @urgent, @in-progress, @ready, @blocked

**Start of Session**:
1. session-start hook shows notification
2. User runs `/pickup`
3. pickup reads `notes/inbox.md`
4. Surfaces top 3-5 priorities
5. User selects focus
6. Relevant agent loads

**Total time**: <30 seconds from session start to productive work

### Self-Improvement Loop

```
Work → Activity Log (auto) → Friction Capture (continuous) →
Learning Review → Weekly Review → Skill Generation → Better Work
```

**Trigger Points**:
- **Continuous**: `note-that` captures insights mid-session
- **Continuous**: `friction-tracker` detects pain points
- **Weekly**: `learning-review` extracts patterns
- **Weekly**: `weekly-review` synthesizes + skill audit
- **Monthly**: `skill-improver` suggests new skills

### Agent Orchestration

**Productivity Agent**:
- Observes work patterns from activity log
- Surfaces friction points proactively
- Coaches on workflow improvement
- Maintains learning history
- Prunes unused skills every 4 weeks

**Designer Agent**:
- Validates designs against WCAG
- Enforces design system
- Reviews for usability heuristics

**Developer Agent**:
- Reviews code quality
- Enforces architectural decisions
- Suggests refactorings

**Product Agent**:
- Clarifies user stories
- Validates feature completeness
- Coaches on spec-first approach

## Design Principles

### 1. Context is Precious

Use subagents for verbose operations (tests, searches) to keep main conversation focused.

### 2. Descriptions Drive Behavior

Skill and subagent descriptions tell Claude when to use them. Write clear, specific descriptions.

### 3. Disable When Risky

Use `disable-model-invocation: true` for skills with side effects (commit, push, delete).

### 4. Memory Persists

Agents learn across sessions via `memory: project` in subagent definitions.

### 5. Tools Shape Capabilities

Restrict subagent tools (e.g., read-only reviewer) to enforce intended behavior.

### 6. Observe Then Coach

System watches patterns for 2-3 cycles before suggesting changes.

### 7. Friction Drives Features

Pain points are feature requests. Recurring friction triggers skill creation.

### 8. Prune Ruthlessly

Unused skills removed every 4 weeks during monthly audit.

## Frontmatter Standards

### Skills
```yaml
---
name: skill-name                     # kebab-case
description: When to use this skill  # Claude reads this!
user-invocable: true
disable-model-invocation: false      # true for side effects
metadata:
  tags: [purpose, scope, timing]     # Max 8 tags
  category: core|productivity|...
  audience: core|advanced|reference
---
```

### Subagents
```yaml
---
name: subagent-name
description: When Claude should delegate
tools: Read, Grep, Glob              # Restrict tools
model: sonnet|opus|haiku|inherit
memory: user|project|local           # Persistent learning
permissionMode: default|acceptEdits|...
---
```

### Agents
```yaml
---
name: agent-name
persona: Brief description
specialization: [domain1, domain2]
skills-used: [skill1, skill2]
context-directory: path/to/context/
---
```

## Cross-IDE Compatibility

Shulkerbox is designed to be portable:

**File-Based**: Markdown with frontmatter (universal format)  
**Shell Scripts**: Bash/zsh hooks work on all Unix systems  
**JSON Configs**: Parseable by most tools  
**Git-Based**: Version control for knowledge  
**MCP Integration**: Standard protocol for external tools

See [IDE-COMPATIBILITY.md](IDE-COMPATIBILITY.md) for mappings to VSCode Copilot, JetBrains, etc.

## Success Metrics

**Quantitative**:
- Weekly review completion: >90%
- Friction resolution: <2 weeks average
- Learning capture: >50% of commits have insights
- Session continuity: 100% handovers have pickup
- Skill pruning: 0 skills unused >4 weeks

**Qualitative**:
- Session startup: <30s with pickup
- Handover captures: All context preserved
- Agent personas: Feel distinct and valuable
- Cross-session memory: No re-explaining needed
- Self-improvement: System fills its own gaps

## Philosophy

> **"Tools come and go, but good workflows persist."**

The architecture prioritizes:
- **Patterns over tools**: Capture workflows, not tool commands
- **Knowledge over code**: Document learnings, not just implementations
- **Habits over hacks**: Build sustainable practices
- **Personas over prompts**: Embody expertise, don't just list steps
- **Systems over tasks**: Think in feedback loops

## Migration Path

This architecture represents Phase 1 of the refactoring plan. Future phases add:

**Phase 2**: Complete agent suite (Designer, Developer, Product agents)  
**Phase 3**: Enhanced coaching system (friction-tracker, learning-review)  
**Phase 4**: Automation (cron jobs, self-maintenance)  
**Phase 5**: Polish (configs, plugins, cross-IDE support)

See the full plan at: `.claude/plans/wild-dazzling-crown.md`

## Related Documentation

- [Productivity System](PRODUCTIVITY-SYSTEM.md) - Self-improvement loop
- [Subagents Guide](SUBAGENTS.md) - When and how to use subagents
- [Workflow Guide](WORKFLOW.md) - Git workflow and release process
- [Agent Guide](AGENT-GUIDE.md) - Creating agent personas
- [IDE Compatibility](IDE-COMPATIBILITY.md) - Cross-IDE patterns

## Questions?

See the main [README](../README.md) or open an issue at:
https://github.com/derrybirkett/shulkerbox/issues
