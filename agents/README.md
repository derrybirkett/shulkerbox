# Agents

Custom agent definitions and personas for specialized development workflows.

## What are Agents?

Agents are specialized personas or configurations that define how an AI assistant behaves in specific contexts. They can have:
- Custom instructions and behaviors
- Specialized knowledge domains
- Specific tool preferences
- Defined workflows and processes

## Structure

Each agent is defined in its own directory:

```
agents/
├── designer-agent/
│   └── AGENT.md
├── developer-agent/
│   └── AGENT.md
└── writer-agent/
    └── AGENT.md
```

## Agent Definition Format

```markdown
---
name: agent-name
description: Brief description of the agent's role
persona: Role or archetype (e.g., "Senior Developer", "UX Designer")
specialization: [list, of, domains]
---

# Agent Name

## Role
What this agent does and when to use it

## Expertise
- Domain knowledge
- Skills and capabilities
- Tool preferences

## Workflow
How this agent approaches tasks

## Interaction Style
How this agent communicates with users
```

## Using Agents

### Claude Code
Agents can be invoked as skills or referenced in project configuration:

```bash
# Via skill system
claude @designer-agent "Review this component"

# In CLAUDE.md
See agents/designer-agent for design review guidelines
```

### Copilot CLI
```bash
copilot agent designer-agent "Review layout"
```

## Available Agents

### productivity-agent
A personal systems coach persona that maintains your development moleskine. Surfaces patterns, identifies what to build next, and keeps your skills repository lean and self-improving.

**Specialization:**
- Systems thinking over individual tasks
- Honest reflection over comfortable summaries
- Pattern recognition and friction identification
- Self-improvement loop facilitation

**Modes:**
- Standup prep (past 24-48 hours summary)
- Weekly review (structured reflection ritual)
- Inbox triage (process captured ideas)
- Friction check (surface recurring pain points)
- Learning review (identify themes and patterns)

**Usage:** `/productivity-agent [mode]`

**Related Skills:** activity-log, weekly-review, work-monitor

[→ Full documentation](../docs/PRODUCTIVITY-SYSTEM.md)

## Example Agent Types

### Developer Agent
A senior developer persona focused on:
- Code quality and architecture
- Testing and reliability
- Performance optimization
- Best practices

### Designer Agent
A UX designer persona focused on:
- User experience patterns
- Accessibility compliance
- Visual hierarchy
- Design systems

### Writer Agent
A technical writer persona focused on:
- Documentation clarity
- API reference quality
- Tutorial structure
- Code examples

## Creating New Agents

1. **Define the role**: What problem does this agent solve?
2. **Specify expertise**: What domains does it cover?
3. **Document workflow**: How should it approach tasks?
4. **Set interaction style**: How should it communicate?

Example structure:
```bash
mkdir -p agents/my-agent
cat > agents/my-agent/AGENT.md << 'EOF'
---
name: my-agent
description: Specialized agent for X
persona: Expert in Y
specialization: [domain1, domain2]
---

# My Agent

[Agent definition here]
EOF
```

## Agent vs Skill

**Agents** define WHO (persona, role, expertise)
**Skills** define HOW (specific workflows, procedures)

Use agents for:
- Complex decision-making
- Domain expertise
- Contextual behavior
- Personalized interaction

Use skills for:
- Specific procedures
- Step-by-step workflows
- Repeatable processes
- Tool automation

## Best Practices

1. **Clear specialization**: Focus on specific domains
2. **Complementary roles**: Agents should work together
3. **Defined boundaries**: Know what each agent handles
4. **Consistent voice**: Maintain persona across interactions
5. **Tool-agnostic**: Work across different platforms
