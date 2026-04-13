# Technical References

API specifications, tool schemas, integration guides, and technical details.

---

## Claude Code

### Skill Format Specification

**Complete frontmatter schema**:
```yaml
---
name: skill-name                      # kebab-case, unique identifier
description: Brief, specific description  # Claude uses this to decide relevance!
user-invocable: true                 # Can user call this with /skill-name?
disable-model-invocation: true       # Optional: only user can invoke (saves context)
context: fork                        # Optional: run in isolated subagent context
argument-hint: optional hint         # Shows in autocomplete
metadata:
  tags: [tag1, tag2]                # For discovery
  category: workflow                # Grouping
---
```

**Field details**:

| Field | Required | Type | Purpose |
|-------|----------|------|---------|
| `name` | Yes | string | Unique kebab-case identifier |
| `description` | Yes | string | Clear, specific description. **Claude reads this to decide when to load the skill!** |
| `user-invocable` | Yes | boolean | Can user invoke with `/skill-name`? |
| `disable-model-invocation` | No | boolean | If `true`, only user can invoke. Saves context by not loading description at session start. Use for side-effect skills. |
| `context` | No | `"fork"` | Run skill in isolated subagent context. Use for expensive operations that only need to return summary. |
| `argument-hint` | No | string | Shows in autocomplete when user types `/skill-name` |
| `metadata.tags` | No | array | For discovery and organization |
| `metadata.category` | No | string | Grouping |

**File structure**:
```
skills/
└── skill-name/
    └── SKILL.md                   # Required
    └── [other files]              # Optional (configs, templates, etc.)
```

**Loading behavior**:

| Configuration | At Session Start | On Use |
|--------------|------------------|--------|
| Default | Description loads | Full content loads |
| `disable-model-invocation: true` | Nothing loads | Full content on user invocation |
| `context: fork` | Description loads | Skill runs in isolated subagent |

**Writing good descriptions**:
```yaml
# ❌ Bad: vague, Claude won't know when to use it
description: Helper for code review

# ✅ Good: specific about what and when
description: Review pull requests for security issues, focusing on OWASP top 10 vulnerabilities

# ❌ Bad: too broad
description: Database utilities

# ✅ Good: clear scope and use case
description: Query patterns and schema documentation for the user_analytics database
```

---

### Hook Events

Available hook events in Claude Code:

| Event | When | Use Case |
|-------|------|----------|
| `session-start` | User starts Claude Code session | Load context, show reminders |
| `session-end` | User ends session | Cleanup, log activity |
| `tool-call` | Before/after tool invocation | Logging, validation |
| `file-write` | File is written | Auto-format, lint |
| `file-read` | File is read | Track accessed files |

*(Check official docs for complete list)*

---

## MCP (Model Context Protocol)

### Server Structure

Minimal MCP server:
```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server({
  name: "my-server",
  version: "1.0.0",
});

server.tool(
  "tool-name",
  { param1: { type: "string", description: "..." } },
  async (params) => {
    // Tool implementation
    return { content: [{ type: "text", text: "result" }] };
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
```

Register in `claude.json`:
```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["path/to/server.js"]
    }
  }
}
```

---

## Git Hooks

### Hook Environment Variables

Available in git hooks:

| Variable | Description |
|----------|-------------|
| `GIT_DIR` | Path to .git directory |
| `GIT_WORK_TREE` | Working tree path |
| `GIT_INDEX_FILE` | Index file location |
| `GIT_AUTHOR_NAME` | Commit author name |
| `GIT_AUTHOR_EMAIL` | Commit author email |

### Hook Exit Codes

| Code | Meaning | Effect |
|------|---------|--------|
| `0` | Success | Continue operation |
| `1` | Error | Abort operation (for pre- hooks) |
| Other | Error | Tool-specific handling |

---

## GitHub API

### Rate Limits

| Endpoint Type | Limit | Reset |
|--------------|-------|-------|
| REST API (authenticated) | 5,000/hour | Hourly |
| REST API (unauthenticated) | 60/hour | Hourly |
| GraphQL | 5,000 points/hour | Hourly |
| Search API | 30/minute | Per minute |

**For work-monitor**: Use authenticated requests, cache aggressively

---

### Useful Endpoints

**List PRs requiring review**:
```bash
gh search prs --review-requested=@me --state=open
```

**PR with checks**:
```bash
gh pr view NUMBER --json title,state,statusCheckRollup
```

**Recent PR activity**:
```bash
gh pr list --state all --limit 10 --json number,title,updatedAt
```

---

## Shell Scripting

### Portable Shebang
```bash
#!/usr/bin/env bash
# More portable than #!/bin/bash
```

### Safe Script Settings
```bash
set -e  # Exit on error
set -u  # Error on undefined variable
set -o pipefail  # Catch errors in pipes
```

Combined:
```bash
set -euo pipefail
```

### Date Formatting (Cross-platform)
```bash
# ISO 8601 format (portable)
date -u +"%Y-%m-%dT%H:%M:%SZ"

# Human-readable
date +"%Y-%m-%d %H:%M"
```

---

## JSON Processing

### jq Common Patterns

**Extract field**:
```bash
echo '{"name":"value"}' | jq -r '.name'
```

**Filter array**:
```bash
jq '[.[] | select(.status == "open")]'
```

**Map and filter**:
```bash
jq '[.[] | {title: .title, number: .number}]'
```

**Count items**:
```bash
jq 'length'
```

---

## Markdown

### CommonMark Features

**Links**:
```markdown
[text](url)
[text](url "title")
[text][ref]

[ref]: url
```

**Code blocks**:
```markdown
```language
code here
```
```

**Frontmatter (YAML)**:
```markdown
---
key: value
---

# Content
```

---

## To Document

- [ ] GitHub GraphQL schema (for complex queries)
- [ ] Claude API tool use schema
- [ ] Bash array/string manipulation reference
- [ ] Regular expression quick reference
- [ ] File path manipulation (basename, dirname, etc.)

---

**Last updated**: 2026-04-13
