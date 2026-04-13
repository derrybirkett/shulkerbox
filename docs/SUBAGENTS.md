# Subagents Guide

How to use subagents for isolated, parallel work in Claude Code.

## What are Subagents?

Subagents are isolated workers that run separately from your main conversation. They have their own context window, execute tasks independently, and return only a summary to your main session.

**Key difference from skills**: Skills load content into your current context. Subagents work in isolated context and return results.

## When to Use Subagents

Use subagents when:

✅ **Context isolation needed**: Task reads many files but only summary matters  
✅ **Parallel work**: Multiple independent tasks can run simultaneously  
✅ **Context is full**: Main session approaching limit, offload work  
✅ **Focused investigation**: Deep dive that doesn't need full conversation history  
✅ **Specialized workers**: Different expertise needed for different tasks

Don't use subagents when:

❌ Work needs full conversation context  
❌ Results need to reference prior discussion  
❌ Task is simple and fast (overhead not worth it)  
❌ You need to see intermediate work

## Subagent vs Skill vs Agent Team

| Feature | Skill | Subagent | Agent Team |
|---------|-------|----------|------------|
| **Context** | Shares your context | Isolated context | Fully independent sessions |
| **Returns** | Works in your conversation | Summary only | Coordinate via shared tasks |
| **Cost** | Low (descriptions always, content on use) | Medium (isolated context) | High (multiple Claude instances) |
| **Use for** | Reference, workflows | Focused research, parallel tasks | Complex work requiring collaboration |

## How Subagents Work

### Lifecycle

1. **Launch**: You or Claude spawns a subagent for a task
2. **Context**: Subagent gets fresh context with:
   - System prompt (shared with parent for cache efficiency)
   - Skills specified in `skills:` field (fully preloaded)
   - CLAUDE.md and git status (inherited)
   - Task description from parent
3. **Work**: Subagent reads files, runs tools, investigates
4. **Return**: Subagent sends summary back to main session
5. **Cleanup**: Subagent context discarded

### What Subagents Don't Get

- Your conversation history
- Skills invoked in main session (unless explicitly passed)
- State from previous subagents

## Creating Subagents

### Method 1: Skill with `context: fork`

Add to skill frontmatter:

```yaml
---
name: deep-dive
description: Investigate codebase thoroughly
context: fork
---
```

When invoked, this skill runs in isolated subagent context.

### Method 2: Claude Spawns Automatically

Claude can spawn subagents when appropriate. Make it more likely by:
- Asking for research that spans many files
- Requesting parallel investigations
- Working in large codebases

### Method 3: Explicit Subagent Definition

Create a subagent definition (advanced):

```yaml
---
name: security-reviewer
type: subagent
skills: [security-patterns, owasp-checklist]
instructions: |
  Review code for security vulnerabilities.
  Focus on: SQL injection, XSS, auth bypass, secrets exposure.
---
```

## Preloading Skills

Subagents don't inherit skills from main session. Specify explicitly:

```yaml
---
name: api-reviewer
context: fork
skills: [api-style-guide, rest-patterns]
---
```

These skills are **fully preloaded** into the subagent's context at launch (different from on-demand loading in main session).

## Examples

### Example 1: Code Review

**Problem**: Reviewing a large PR floods main context with file contents.

**Solution**: Subagent reads all changed files, returns summary.

```yaml
---
name: review-pr
description: Review PR changes for quality and standards
context: fork
skills: [code-standards, security-patterns]
---

# PR Review

Read all changed files, check against:
1. Code standards
2. Security patterns
3. Test coverage
4. Documentation

Return:
- Issues found (with file:line references)
- Recommendations
- Approval status
```

**Benefit**: Main context only sees the summary, not all file contents.

### Example 2: Parallel Research

**Problem**: Need to research multiple topics, each requires reading many files.

**Solution**: Spawn multiple subagents in parallel.

```markdown
Research these in parallel:
1. How authentication works
2. How payments are processed
3. How data is cached
```

Claude spawns 3 subagents, each investigates independently, returns findings.

### Example 3: Focused Investigation

**Problem**: "Find all usages of deprecated API" requires scanning entire codebase.

**Solution**: Subagent does the search, returns summary.

**Benefit**: Your main session stays focused on the task at hand, not filled with search results.

## Best Practices

### 1. Clear Task Descriptions

Subagents start fresh. Give complete context:

❌ **Bad**: "Review the changes"  
✅ **Good**: "Review changes in PR #123 for security issues, focusing on input validation and auth checks"

### 2. Specify Required Skills

Subagents don't inherit skills. List what they need:

```yaml
skills: [api-patterns, security-checklist, code-standards]
```

### 3. Request Structured Output

Help subagent format useful results:

```markdown
Return:
- Issues found (with file:line)
- Severity (high/medium/low)
- Recommendations

Format as markdown with clear sections.
```

### 4. Use for Expensive Operations

Subagents are ideal for:
- Reading many files
- Extensive searches
- Parallel investigations
- Deep analysis that only needs summary

### 5. Don't Overuse

Subagent overhead (context setup, summary generation) only makes sense for substantial work. For simple tasks, work in main context.

## Context Isolation Benefits

### Keeps Main Context Clean

```
Main session: 50k tokens
  ↓ spawn subagent
Subagent: reads 100 files (150k tokens)
  ↓ return summary
Main session: 50k tokens + 2k summary = 52k tokens
```

Without subagent:
```
Main session: 50k tokens
  ↓ read 100 files
Main session: 200k tokens (context limit hit!)
```

### Parallel Work

Multiple subagents can work simultaneously:

```
Main → spawns 3 subagents → all work in parallel → return summaries
```

Sequential would take 3x longer and fill main context.

## Limitations

### No Shared State

Subagents can't see:
- Each other's work
- Your conversation history
- Previous subagent results

For work requiring coordination, consider **agent teams** instead.

### Summary Only

You don't see intermediate work. If you need to examine the reasoning, work in main context.

### Overhead

Each subagent launch has cost:
- Context setup
- Skill preloading
- Summary generation

Only worth it for substantial tasks.

## Troubleshooting

### "Subagent doesn't know about [X]"

Subagents start fresh. Either:
- Pass context in task description
- Add relevant skill to `skills:` field
- Include info in CLAUDE.md (inherited)

### "Need to see intermediate steps"

Subagents return summaries only. For debugging, work in main context or ask subagent to include more detail in summary.

### "Subagents are slow"

Parallel subagents solve this. Ask for parallel execution:
```
"Research these 3 topics in parallel using subagents"
```

## Related

- [Skills](../skills/README.md) - Reusable content subagents can preload
- [CLAUDE.md Template](../templates/CLAUDE.md) - Context inherited by subagents
- [Agent Teams](https://code.claude.com/docs/en/agent-teams) - For work requiring coordination

## Learn More

- [Official Subagents Documentation](https://code.claude.com/docs/en/sub-agents)
- [Context Window Guide](https://code.claude.com/docs/en/context-window)
