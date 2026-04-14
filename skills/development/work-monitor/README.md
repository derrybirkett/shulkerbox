# Work Monitor Skill

Context-aware monitoring of Jira tickets, GitHub PRs, and work activity across all projects.

## Quick Start

### Using the Skill

```bash
# In any directory
"What needs my attention?"
"Activity summary"
"Show all my work"

# In project directory (auto-detects context)
cd ~/Projects/my-project
"What needs my attention?"  # Filters to that project

# Explicit project filtering
"Check my-project work"

# Specific items
"Check PR #123"
"Check TICKET-456"
```

## Features

### Phase 1: GitHub PR Monitoring ✅
- Track your open PRs
- Monitor review requests
- Check PR comments and @mentions
- CI check status
- Team activity

### Phase 2: Jira Integration (via Atlassian MCP)
- Ticket tracking and assignment
- PR-to-ticket mapping
- Status and comment monitoring
- Fallback: Extract tickets from PR titles

### Phase 3: Confluence (Future)
- Linked documentation
- Page updates
- Search by ticket ID

## Directory Structure

```
work-monitor/
├── SKILL.md                     # Main skill definition
├── README.md                    # This file
├── config/
│   └── global.json             # User preferences
├── contexts/
│   └── generic-context.md      # Generic fallback
├── templates/
│   └── daily-digest.md         # Output template
└── cache/                      # Runtime cache (auto-generated)
    ├── github-pr-state.json
    ├── jira-ticket-state.json
    └── last-check.json
```

## Configuration

Edit `config/global.json` to customize:

- User information (GitHub username, Jira email)
- Notification preferences
- Output format
- Cache settings
- Project configurations

## Adding New Projects

1. Create context file: `contexts/my-project-context.md`
2. Add to `config/global.json`:
   ```json
   "projects": {
     "my-project": {
       "enabled": true,
       "github_repo": "org/repo",
       "jira_project": "KEY",
       "context_file": "contexts/my-project-context.md"
     }
   }
   ```

## Context Detection

The skill automatically detects your current context:

1. **Project Directory**: Filters to that project
2. **Generic Directory**: Shows all work
3. **Explicit Request**: Filters as requested

## Jira MCP Setup (Future)

To enable full Jira integration:

1. Install Jira MCP server
2. Configure with your Jira instance
3. Update skill to use MCP tools
4. Test with "Check my Jira tickets"

## Troubleshooting

### Skill not detecting project
- Check: `git remote get-url origin`
- Verify project in `global.json`
- Try explicit: "Check [project] work"

### Missing PRs
- Check: `gh auth status`
- Clear cache: `rm cache/*.json`
- Test: `gh pr list --limit 1`

### No GitHub CLI
- Install: `brew install gh`
- Authenticate: `gh auth login`

## Related Skills

- **designer-agent**: Design validation for UI changes in PRs
- **github-issues-workflow**: Issue tracking and workflow management

## Version

**Current**: 1.0.0 (Phase 1 - GitHub only)
**Next**: 1.1.0 (Add Jira MCP integration)

## Maintainer

Derry Birkett

## Last Updated

2026-03-03
