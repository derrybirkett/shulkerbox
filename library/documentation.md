# Documentation Links

Official documentation for tools, platforms, and APIs we integrate with.

---

## Claude & Anthropic

### [Claude Code Documentation](https://code.claude.com/docs/en/features-overview)
**Official documentation for Claude Code CLI and features**

What's here:
- Features overview (skills, hooks, agents, MCP servers)
- CLI commands and usage
- Configuration and settings
- IDE integrations (VS Code, JetBrains)
- Keyboard shortcuts and workflows

Why it matters:
- Authoritative source for how Claude Code works
- Informs skill design and hook implementation
- Shows what's possible with the platform
- **Critical**: Explains context loading and optimization strategies

Key sections to reference:
- [Features Overview](https://code.claude.com/docs/en/features-overview) - When to use each extension type
- [Skills](https://code.claude.com/docs/en/skills) - Skill format, loading behavior, `disable-model-invocation`, `context: fork`
- [CLAUDE.md](https://code.claude.com/docs/en/memory) - Always-on context, path-specific rules in `.claude/rules/`
- [Subagents](https://code.claude.com/docs/en/sub-agents) - Isolated workers, context isolation benefits
- [Hooks](https://code.claude.com/docs/en/hooks-guide) - Event-driven automation
- [MCP](https://code.claude.com/docs/en/mcp) - Connect to external services
- [Context Window](https://code.claude.com/docs/en/context-window) - Understanding context costs
- [Plugins](https://code.claude.com/docs/en/plugins) - Packaging and distribution

**Key learnings**:
1. **Context costs**: Skill descriptions load at start, full content on use
2. **`disable-model-invocation: true`**: Zero context cost until user invokes
3. **Build incrementally**: Add extensions when you hit recognizable triggers
4. **CLAUDE.md vs Skills vs Rules**: Know when to use each
5. **Subagents**: For expensive operations, return summary only
6. **Clear descriptions**: Claude uses these to decide skill relevance

---

### [Anthropic API Documentation](https://docs.anthropic.com/)
**Claude API reference and guides**

What's here:
- API reference (Messages API, tool use)
- SDKs (Python, TypeScript, etc.)
- Prompt engineering guides
- Token counting and pricing
- Rate limits and best practices

Why it matters:
- Essential for building MCP servers
- Prompt caching strategies
- Understanding tool use patterns

---

## GitHub

### [GitHub CLI Manual](https://cli.github.com/manual/)
**Official gh command reference**

What's here:
- All `gh` commands and flags
- GitHub API integration
- Authentication and configuration
- Extensions and aliases

Why it matters:
- Used heavily in work-monitor skill
- Reference for PR/issue automation
- Scripting GitHub workflows

Key commands:
- `gh pr` - Pull request operations
- `gh issue` - Issue management
- `gh api` - Direct API access
- `gh search` - Search repositories, PRs, issues

---

### [GitHub REST API](https://docs.github.com/en/rest)
**GitHub API reference**

What's here:
- REST API endpoints
- Authentication methods
- Rate limiting
- Webhooks

Why it matters:
- Fallback when `gh` CLI isn't sufficient
- Understanding what's possible with GitHub integration
- Building custom automations

---

## MCP (Model Context Protocol)

### [MCP Specification](https://modelcontextprotocol.io/)
**Protocol for connecting AI models to external tools and data**

What's here:
- Protocol specification
- Server implementation guides
- Client integration
- Tool schemas

Why it matters:
- Standard for building integrations
- How to expose tools to Claude
- Resource providers and contexts

---

## Git

### [Git Hooks Documentation](https://git-scm.com/docs/githooks)
**Official git hooks reference**

What's here:
- All available git hooks
- Hook execution order
- Environment variables
- Sample hooks

Why it matters:
- Foundation for activity-log automation
- Understanding hook lifecycle
- Best practices for hook scripts

Key hooks we use:
- `post-commit` - Activity log capture
- `pre-commit` - Validation and linting (future)
- `pre-push` - Checks before push (future)

---

## Markdown & Documentation

### [CommonMark Specification](https://spec.commonmark.org/)
**Markdown standard used by GitHub and Claude Code**

What's here:
- Markdown syntax reference
- Edge cases and corner cases
- Parsing rules

Why it matters:
- Skills and documentation are written in markdown
- Ensures consistent formatting
- Understanding what renders where

---

## Shell Scripting

### [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
**Complete bash scripting reference**

What's here:
- Shell builtin commands
- Parameter expansion
- Shell functions
- Script portability

Why it matters:
- Hooks and scripts use bash
- Cross-platform considerations
- Error handling patterns

Key sections:
- [Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html) - `set -euo pipefail`
- [Conditionals](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html)

---

## Tools & Utilities

### [jq Manual](https://jqlang.github.io/jq/manual/)
**JSON processing in shell scripts**

What's here:
- jq syntax and filters
- JSON manipulation
- Example recipes

Why it matters:
- Processing GitHub API responses
- Parsing config files
- Shell script data handling

---

### [ripgrep User Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)
**Fast search tool used by Claude Code**

What's here:
- Search patterns and syntax
- Performance tips
- Integration with other tools

Why it matters:
- Understanding Claude's Grep tool
- Building search-heavy skills
- Performance considerations

---

## To Add

- [ ] Copilot CLI documentation (if/when we support it)
- [ ] Gemini CLI documentation (if/when we support it)
- [ ] Jira API reference (when adding Jira integration)
- [ ] Slack API reference (if adding Slack integration)

---

**Last updated**: 2026-04-13
