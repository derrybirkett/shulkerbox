# Generic Work Monitoring Context

**Scope**: All projects (default fallback when no specific context detected)

---

## When This Context is Used

- No git repository detected in current directory
- Git repository not recognized (no matching project config)
- User explicitly requests "Show all my work"
- No project-specific context file exists

---

## Monitoring Scope

### GitHub
- **All repositories** where you have PRs or review requests
- **Filter by**: Your PRs, review requests, mentions
- **No repo filtering** unless explicitly requested

### Jira
- **All projects** where you have assigned tickets
- **Filter by**: Assignee, watcher, mentions
- **No project filtering** unless explicitly requested

### Confluence
- **All spaces** (when available)
- **Filter by**: Author, watcher, mentions

---

## Priority Rules

### Urgent (Immediate Attention)
- PRs with failing checks
- @mentions in comments or tickets
- Review requests assigned to you
- Tickets marked as "Blocker" or "Highest" priority

### High Priority (Today)
- PRs waiting for review > 2 days
- Tickets in "Waiting for Developer" status
- New comments on your PRs
- New review requests

### Normal Priority (This Week)
- Recent activity on watched items
- New tickets assigned to you
- General team activity
- Documentation updates

### Low Priority (When Available)
- Informational comments
- Optional reviews
- Nice-to-have features

---

## Output Format

### Daily Digest
```markdown
## Work Summary - All Projects
**As of**: [timestamp]

### PRs Awaiting Your Review (by repo)
**org-a/repo-one** (2)
- [FEAT-123] Add integration UI (#82) - 2 days old
- [FIX-456] Error handling (#79) - 5 hours old

**org-b/repo-two** (1)
- [TICKET-123] Feature implementation (#456) - 1 day old

### Your PRs with Activity
**org-a/repo-one**
- [FEAT-789] New feature (#83) - 2 new comments

### Jira Tickets (by project)
**PROJ-A** (3 tickets)
**PROJ-B** (1 ticket)
```

---

## GitHub Monitoring

### Default Queries

```bash
# Your open PRs (all repos)
gh pr list --author @me

# PRs awaiting your review (all repos)
gh search prs --review-requested=@me --state=open

# Recent mentions
gh search issues --mentions=@me --updated:>7d
```

### Repo Detection

When in a git repository:
1. Extract repo from `git remote get-url origin`
2. Format: Extract owner/repo from URL
3. Filter results to that repo
4. Check if project-specific context exists

---

## Jira Monitoring

### Default JQL Queries

```jql
# Your assigned tickets (all projects)
assignee = currentUser() AND resolution = Unresolved

# Tickets you're watching
watcher = currentUser() AND updated >= -7d

# Recent mentions
comment ~ currentUser() AND updated >= -7d

# High priority items
assignee = currentUser() AND priority in (Highest, High) AND resolution = Unresolved
```

---

## Context Upgrade Path

When a project is detected repeatedly:

1. **Suggest creating project context**
   ```
   Note: I've noticed you're frequently checking [repo-name]
   Would you like to create a project-specific context?
   This will enable faster filtering and custom workflows.
   ```

2. **Generate project template**
   - Extract repo information
   - Detect Jira project key from PR titles
   - Create basic context file
   - User can customize further

3. **Add to global config**
   ```json
   "projects": {
     "project-name": {
       "enabled": true,
       "github_repo": "owner/repo",
       "jira_project": "KEY",
       "context_file": "contexts/project-name-context.md"
     }
   }
   ```

---

## Filtering Options

### By Repository
```
"Check work in derrybirkett/my-project"
"Show PRs for owner/repo"
```

### By Jira Project
```
"Check PROJ tickets"
"Show PROJECT-* tickets"
```

### By Time Range
```
"Activity today"
"What changed this week?"
"PRs opened in last 3 days"
```

### By Status
```
"PRs with failing checks"
"Open review requests"
"Merged PRs today"
```

---

## Smart Grouping

### Group by Repository
Show activity grouped by repo, sorted by priority

### Group by Project
Show Jira tickets grouped by project key

### Group by Priority
Show all items sorted by urgency across projects

### Group by Type
Separate PRs, tickets, docs into sections

---

## Output Customization

### Minimal
Just action items requiring immediate attention

### Standard
Action items + recent activity summary

### Detailed
Full activity with all comments, checks, history

### Report
Comprehensive report with statistics and trends

---

## Best Practices

### When to Use Generic Context

1. **Overview Needed**
   - Morning routine across all projects
   - End of week review
   - Planning next week's work

2. **Multi-Project Work**
   - Working on multiple projects simultaneously
   - Context switching between projects
   - Tracking dependencies across projects

3. **Discovery Mode**
   - New to organization
   - Exploring available work
   - Understanding team activity

### When to Switch to Project Context

1. **Deep Focus**
   - Working on single project for extended period
   - Need project-specific workflows
   - Frequent context-specific queries

2. **Team Collaboration**
   - Active in project team
   - Need team-specific filters
   - Following project conventions

3. **Efficiency**
   - Repeated queries for same project
   - Need faster filtering
   - Want customized output

---

## Example Queries

### Global Overview
```
User: "What needs my attention?"

Response:
## Work Summary - All Projects

### PRs Awaiting Review (3 across 2 repos)
1. derrybirkett/my-project: 2 PRs
2. org-b/other-project: 1 PR

### Your PRs with Activity (2)
1. [FEAT-100] in my-project - 2 comments
2. [PROJ-456] in other-project - 1 approval

### Jira Tickets (5 across 3 projects)
- PROJ-A: 3 tickets
- PROJ: 1 ticket
- TEAM: 1 ticket

[Show details? Specify project to drill down]
```

### Filtered View
```
User: "Check derrybirkett/my-project work"

Response:
[Switches to project context if available]
[Otherwise shows filtered generic view]

## Project Work Summary

### PRs Awaiting Your Review (2)
[Details...]

### Your PRs with Activity (1)
[Details...]

[Full context loaded for future queries]
```

---

## Troubleshooting

### Too Much Information
**Symptom**: Output overwhelming with many projects

**Solutions**:
- Use project-specific queries
- Create project contexts
- Adjust `max_prs_to_show` in config
- Filter by time range

### Missing Items
**Symptom**: Known PRs/tickets not appearing

**Solutions**:
- Check global filters in config
- Verify GitHub/Jira access
- Clear cache
- Check exclude lists

### Wrong Context Detected
**Symptom**: Skill uses wrong project context

**Solutions**:
- Explicitly specify: "Show all my work"
- Check git remote configuration
- Verify project config in global.json
- Use generic context temporarily

---

## Adding New Project Contexts

### Quick Start Template

```bash
# Create new project context
cp contexts/generic-context.md contexts/my-project-context.md

# Edit with project details
# - Repository information
# - Jira project key
# - Team members
# - Special workflows

# Add to global.json
{
  "projects": {
    "my-project": {
      "enabled": true,
      "github_repo": "org/repo",
      "jira_project": "PROJ",
      "context_file": "contexts/my-project-context.md"
    }
  }
}
```

### Project Context Checklist

- [ ] Repository owner/name
- [ ] Jira project key
- [ ] Ticket/branch naming conventions
- [ ] Team channels/collaborators
- [ ] Priority rules
- [ ] Special workflows
- [ ] Tech stack (optional)
- [ ] Integration with other skills (optional)

---

**Context Version**: 1.0.0
**Last Updated**: 2026-03-03
**Usage**: Fallback for unrecognized projects or global overview