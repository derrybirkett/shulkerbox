# Contributing to Shulkerbox

Thank you for contributing! Shulkerbox is a collection of skills, agents, hooks, and templates for LLM-assisted development workflows.

## How to Contribute

### Reporting Issues

- Check existing issues before creating a new one
- Include clear description, expected behavior, and actual behavior
- For skill issues: include the skill name and how you invoked it
- For agent issues: include the agent name and relevant context

### Contributing Skills, Agents, or Hooks

1. **Fork and clone** the repository
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes** following the guidelines below
4. **Test your changes** in a real project
5. **Commit** with conventional commit messages
6. **Push** your feature branch
7. **Create a pull request** with a clear description

### Branch Workflow

We use a **feature branch workflow**:

- `main` is the stable branch
- Create feature branches for all changes: `feature/`, `fix/`, `docs/`
- All changes go through pull requests
- PRs are squash-merged to keep history clean

**Pre-push hook is enabled** — you cannot push directly to `main`. Always work on a feature branch.

### Commit Message Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` new skills, agents, or features
- `fix:` bug fixes
- `docs:` documentation changes
- `chore:` maintenance, dependencies
- `refactor:` code restructuring
- `test:` test-related changes

**Examples:**
```
feat: add pickup skill for session context restoration
fix: wrap-up skill now handles PR workflow
docs: add contributing guidelines
chore: update dependencies
```

## Skill Contribution Guidelines

### File Structure

```
skills/
├── category/
│   └── skill-name/
│       └── SKILL.md
```

### Skill Template

Every skill must have frontmatter and follow this structure:

```markdown
---
name: skill-name
description: One-line description (shown in skill list)
user-invocable: true|false
disable-model-invocation: true|false
argument-hint: optional hint text
metadata:
  tags: [tag1, tag2]
  category: core|development|productivity
  audience: core|advanced
---

# Skill Name

Brief description of what the skill does.

## Trigger

When this skill should be invoked (user commands, events, etc.)

## Purpose

What problem this solves and why it exists.

## Workflow

Step-by-step instructions for the LLM to execute.

## Examples

Concrete usage examples (optional but encouraged).
```

### Skill Guidelines

- **One job well**: Each skill should do one thing well
- **Clear triggers**: Document when the skill should be invoked
- **Fail gracefully**: Handle missing files, commands, or permissions
- **Idempotent**: Safe to run multiple times
- **Fast**: Complete in seconds, not minutes
- **User confirmation**: Ask before destructive operations

### Testing Your Skill

Before submitting:

1. Test in a real project (not just the shulkerbox repo)
2. Test with missing dependencies (does it fail gracefully?)
3. Test edge cases (empty directories, no git repo, etc.)
4. Document any required dependencies in the skill

## Agent Contribution Guidelines

### File Structure

```
agents/
└── agent-name/
    ├── AGENT.md
    └── context/
        └── (context files)
```

### Agent Template

```markdown
---
name: agent-name
description: One-line description
persona: Brief persona description
specialization: [area1, area2]
interaction-style: How the agent communicates
skills-used: [skill1, skill2]
context-directory: agents/agent-name/context/
---

# Agent Name

Full description of the agent's role and capabilities.

## Role

What this agent does and when to use it.

## Expertise

- Specific capability 1
- Specific capability 2

## Values & Principles

Core beliefs that guide the agent's behavior.

## Workflow

How the agent approaches tasks.

## Context Files

- `context/file1.md` — purpose
- `context/file2.md` — purpose
```

### Agent Guidelines

- **Clear persona**: Agents should have distinct personalities and approaches
- **Specific domain**: Focus on one area of expertise
- **Reusable context**: Context files should be templates, not session-specific
- **Skill integration**: Reference existing skills rather than duplicating logic

## Hook Contribution Guidelines

### File Structure

```
hooks/
├── .claude/hooks/
│   └── hook-name
├── .git/hooks/
│   └── hook-name
└── README.md
```

### Hook Guidelines

- **Fast execution**: Hooks should complete in < 1 second
- **Silent success**: Only output on errors
- **Non-blocking**: Don't interrupt user workflow
- **Executable**: `chmod +x` and include shebang
- **Error codes**: Exit 0 for success, 1 to abort (pre-hooks)

## Documentation Standards

- **README.md**: Overview, quickstart, installation
- **USAGE.md**: Detailed usage instructions
- **Skill/Agent files**: Self-documenting with clear structure
- **Comments**: Only for non-obvious behavior
- **Examples**: Show real-world usage

## Code Review Process

PRs will be reviewed for:

1. **Clarity**: Is the purpose clear?
2. **Testing**: Has it been tested in a real project?
3. **Documentation**: Is it well-documented?
4. **Conventions**: Does it follow file structure and naming?
5. **Dependencies**: Are dependencies documented?
6. **Scope**: Does it do one thing well?

## Release Process

- Main branch is always stable
- Version tags follow semver: `vMAJOR.MINOR.PATCH`
- Releases are created when significant features land
- Changelog is updated with each release

## Getting Help

- Open an issue for questions
- Check existing skills/agents for examples
- Reference the README and USAGE guides

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

---

Thank you for making Shulkerbox better! 🎉
