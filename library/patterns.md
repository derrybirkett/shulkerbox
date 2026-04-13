# Patterns & Practices

Workflow patterns, skill design principles, and agent behaviors.

---

## Skill Design Patterns

### The Self-Improvement Loop
**Pattern**: Skills that capture work → reflect → identify friction → build better skills

**Example**: productivity-agent system
1. post-commit hook captures work
2. activity-log stores history
3. weekly-review surfaces patterns
4. friction-log identifies pain points
5. skills-plan prioritizes what to build
6. New skills reduce future friction

**Why it works**:
- Closes the feedback loop
- Systematic improvement over time
- Data-driven prioritization

**Apply to**:
- Any system that needs to evolve with use
- Personal tooling and workflows
- Team productivity systems

---

### Progressive Disclosure
**Pattern**: Skills start simple, offer detail on request

**Example**: work-monitor
- Default: Summary of what needs attention
- On request: Full PR details, all comments, history
- Progressive: "Show me more about PR #123"

**Why it works**:
- Reduces cognitive load
- Respects user's context and time
- Scales from quick check to deep dive

**Apply to**:
- Any information-dense skill
- Status reports and summaries
- Monitoring and alerting

---

### Context-Aware Behavior
**Pattern**: Skills adapt based on where/when they're invoked

**Example**: work-monitor detecting git context
- In a project repo → Show that project's PRs
- No git context → Show all work
- Explicit override → User specifies context

**Why it works**:
- Less typing, more relevant results
- Natural workflow integration
- Reduces decision fatigue

**Apply to**:
- File operations (prefer current directory)
- Search (scope to current project)
- Reporting (filter to relevant context)

---

### Prompt, Don't Assume
**Pattern**: Ask questions before taking action, especially for destructive operations

**Example**: wrap-up skill
- Shows what will be committed
- Asks for commit message
- Asks for version bump type
- Confirms before pushing

**Why it works**:
- User maintains control
- Prevents mistakes
- Educates through interaction

**Apply to**:
- Git operations
- File deletion/modification
- Configuration changes

---

### Composable Skills
**Pattern**: Small, focused skills that work together

**Example**: Productivity system
- `activity-log` captures
- `weekly-review` reflects
- `wrap-up` commits
- `note-that` captures insights

Each skill does one thing well, together they form a system.

**Why it works**:
- Easier to maintain
- Flexible combinations
- Clear boundaries

**Apply to**:
- Breaking down complex workflows
- Building skill ecosystems
- Team skill libraries

---

## Hook Patterns

### Silent Success, Vocal Failure
**Pattern**: Hooks produce no output on success, clear messages on failure

**Example**: post-commit hook
- Success: Appends to log, no output
- Failure: Echo error, exit 1

**Why it works**:
- Doesn't interrupt normal workflow
- Errors are immediately visible
- Follows Unix philosophy

**Apply to**:
- All background automation
- Git hooks
- Scheduled tasks

---

### Idempotent Operations
**Pattern**: Safe to run multiple times without side effects

**Example**: post-commit creating log file
- Checks if file exists
- Creates with header if missing
- Appends entry (never overwrites)

**Why it works**:
- Safer automation
- Handles edge cases gracefully
- Can retry on failure

**Apply to**:
- File operations in hooks
- Initialization scripts
- Data capture

---

## Agent Patterns

### Persona-Driven Behavior
**Pattern**: Agents have clear roles, opinions, and interaction styles

**Example**: productivity-agent
- Role: Personal systems coach
- Opinion: "If you don't review, the system doesn't improve"
- Style: Asks hard questions, pushes for specifics

**Why it works**:
- Consistent behavior
- Clear expectations
- More engaging interaction

**Apply to**:
- Specialized agents (designer, developer, writer)
- Domain expertise
- Review and critique workflows

---

### Question-Driven Reflection
**Pattern**: Agents use targeted questions to surface insights

**Example**: weekly-review's four questions
1. What felt hard or slow?
2. What's one thing you'd do differently?
3. What's the most useful thing you learned?
4. What's been nagging at you?

**Why it works**:
- Structured reflection
- Surfaces what matters
- Builds self-awareness over time

**Apply to**:
- Review workflows
- Learning capture
- Decision-making processes

---

---

## Build Incrementally
**Pattern**: Add extensions when you hit a recognizable trigger, not up front

**Triggers and solutions**:

| Trigger | Add |
|---------|-----|
| Claude gets a convention wrong twice | [CLAUDE.md](../templates/CLAUDE.md) |
| Same prompt typed for third time | Capture as user-invocable [skill](../skills/) |
| Copying data Claude can't see | Connect as [MCP server](https://code.claude.com/docs/en/mcp) |
| Side task floods context | Route through [subagent](SUBAGENTS.md) |
| Want it to happen automatically | Write a [hook](../hooks/) |
| Second repo needs same setup | Package as [plugin](https://code.claude.com/docs/en/plugins) |

**Why it works**:
- No premature optimization
- Each addition solves real pain
- System grows organically with your workflow
- Avoid configuration bloat

**Apply to**:
- Starting new projects (don't configure everything day 1)
- Onboarding teams (add pieces as needs emerge)
- Building tool libraries (ship and iterate)

---

## Context Budgeting
**Pattern**: Design skills and workflows with context costs in mind

**Context costs by feature**:

| Feature | At Session Start | On Use |
|---------|-----------------|--------|
| CLAUDE.md | Full content | Every request |
| Skill (default) | Description only | Full content when invoked |
| Skill (`disable-model-invocation: true`) | Nothing | Full content when user invokes |
| MCP server | Tool names | Full schema when tool used |
| Subagent | Nothing (isolated) | Fresh context with specified skills |
| Hook | Nothing | Only if hook returns context |

**Strategies**:
1. **Keep CLAUDE.md under 200 lines** - Move reference material to skills
2. **Use `disable-model-invocation: true`** for user-only skills (zero cost)
3. **Write clear skill descriptions** - Claude uses these to decide relevance
4. **Offload expensive operations to subagents** - Only summary returns
5. **Use path-specific rules** - Only load when working with matching files

**Why it matters**:
- Full context → Better decisions, but risk hitting limits
- Bloated context → Claude loses track of conventions
- Poorly described skills → Wrong skills load, right ones missed

**Apply to**:
- Large codebases (use subagents for broad searches)
- Multiple CLAUDE.md files (keep each focused)
- Skill libraries (clear descriptions prevent conflicts)

---

## Anti-Patterns

### ❌ The Swiss Army Knife
**Anti-pattern**: One skill that does everything

**Why it fails**:
- Hard to maintain
- Unclear when to invoke
- Feature bloat

**Instead**: Compose small, focused skills

---

### ❌ Silent Failures
**Anti-pattern**: Errors are swallowed, user doesn't know something broke

**Why it fails**:
- Data loss (e.g., activity log stops updating)
- Broken workflows go unnoticed
- Hard to debug

**Instead**: Fail loudly, exit with error codes

---

### ❌ Assume Context
**Anti-pattern**: Skills assume specific environment, paths, or state

**Example**: Hardcoded `/Users/dbirkett/...` paths

**Why it fails**:
- Not portable
- Breaks for other users
- Hard to share

**Instead**: Use `$HOME`, detect context, make configurable

---

### ❌ Do First, Ask Later
**Anti-pattern**: Skills take destructive actions without confirmation

**Why it fails**:
- Lost work
- Broken state
- User loses trust

**Instead**: Show intent, ask permission, allow abort

---

## To Document

- [ ] Caching strategies (when to cache, when to refresh)
- [ ] Error recovery patterns
- [ ] Cross-tool compatibility patterns
- [ ] Testing strategies for skills
- [ ] Documentation patterns for skills

---

**Last updated**: 2026-04-13
