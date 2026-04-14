---
name: work-monitor
description: Context-aware monitoring of Jira tickets, GitHub PRs, and work activity. Use when checking work status, PR reviews, ticket updates, or team activity.
user-invocable: true
disable-model-invocation: false
argument-hint: optional query (e.g., "PRs", "tickets", "FEAT-100")
metadata:
  tags: [github, jira, monitoring, pr-review, standup, activity]
  category: development
  audience: core
---

# Work Monitor Skill

**Version**: 1.0.0
**Created**: 2026-03-03
**Purpose**: Context-aware monitoring of Jira tickets, GitHub PRs, and work activity across all projects

---

## When to Use This Skill

Activate this skill when:
- User asks "What needs my attention?"
- User asks about PR status, Jira tickets, or work activity
- Morning standup prep or end-of-day review
- Checking on specific tickets or PRs
- User invokes: `/work-monitor` or related queries

---

## Core Capabilities

### GitHub PR Monitoring (Available Now)
- Your open PRs and their status
- PRs awaiting your review
- Comments and @mentions on PRs
- CI check status
- Recent PR activity

### Jira Ticket Monitoring (Requires MCP Setup)
- Tickets assigned to you
- Comments and @mentions
- Ticket status changes
- Tickets you're watching
- Activity on specific tickets

### Confluence (Future Enhancement)
- Docs linked to tickets
- Recent page updates
- Search by ticket ID

---

## Context Detection

The skill automatically adapts based on your current working directory and context.

### Detection Logic

1. **Check current working directory**
   - Is this a git repository?
   - Does it have a CLAUDE.md file?
   - What's the git remote URL?

2. **Load project-specific context**
   - If in a known project → Load that project's context
   - Otherwise → Use generic context

3. **Apply appropriate filters**
   - Jira project key (if configured)
   - GitHub repository (from git remote)
   - Team-specific labels and workflows

### Context Files

- `~/.claude/skills/work-monitor/contexts/generic-context.md` - Generic workflows
- `~/.claude/skills/work-monitor/config/global.json` - User preferences

---

## Workflows

### 1. Daily Standup Prep

**User Query**: "What needs my attention?" or "What do I need to review?"

**Behavior**:
- Detect current project context
- Show PRs awaiting review (filtered by context)
- Show unread comments on your PRs
- Show failing CI checks
- Show Jira tickets needing response (if MCP available)
- Prioritize by urgency and age

**Output Template**:
```markdown
## Work Summary - [Project Name or "All Projects"]
**As of**: [timestamp]

### PRs Awaiting Your Review (3)
1. [FEAT-100] Create Integration UI (#6782)
   - Author: Patti McLetchie
   - Status: ✅ All checks passed
   - Age: 2 days
   - Link: [View PR]

2. [FIX-200] Flag error handling (#6779)
   - Author: John Doe
   - Status: ⚠️ 1 check failing
   - Age: 5 hours
   - Link: [View PR]

### Your PRs with Activity (2)
1. [FEAT-101] FM target groups (#6783) - 2 new comments
2. [LCHUX-416] Update routes (#6791) - Ready to merge

### Action Items
- [ ] Review PR #6782 (waiting 2 days)
- [ ] Respond to comments on PR #6783
- [ ] Check failing tests on PR #6779
```

---

### 2. PR Deep Dive

**User Query**: "Check PR #6782" or "Status of PR 6782"

**Behavior**:
- Fetch full PR details using `gh pr view`
- Show all comments (highlight @mentions)
- Show review status
- Show CI check status
- Extract related Jira ticket from PR title
- Show linked Jira activity (if MCP available)

**Output Template**:
```markdown
## PR #6782: [FEAT-100] Create Integration UI

**Status**: Open
**Author**: Patti McLetchie
**Created**: 2026-02-28
**Base**: main ← feature/FEAT-100-create-integration

### Checks
✅ Build (3m 24s)
✅ Unit Tests (1m 45s)
✅ Lint (32s)
⚠️ E2E Tests (2 failed)

### Reviews
- Approved by: John Doe
- Changes requested by: Jane Smith

### Recent Comments (5)
1. @dbirkett - "Can you check the spacing on the header?" (2 hours ago)
2. Jane Smith - "Typography variant looks wrong" (4 hours ago)
3. Patti - "Fixed! Ready for re-review" (30 min ago)

### Related Jira
[FEAT-100] - In Progress
- 3 new comments on ticket
- Patti added design specs

### Actions
- [ ] Re-review after Jane's requested changes
- [ ] Check E2E test failures
```

---

### 3. Ticket Lookup

**User Query**: "Check FEAT-100" or "What's new on FEAT-100?"

**Behavior**:
- Find PRs with this ticket number (GitHub search)
- Fetch Jira ticket details (if MCP available)
- Show ticket comments and activity
- Show linked Confluence pages (if available)

**Output Template**:
```markdown
## FEAT-100: Create Integration UI

### Jira Status
**Status**: In Progress → Code Review
**Assignee**: Patti McLetchie
**Priority**: High
**Updated**: 2 hours ago

### Recent Activity (Jira)
- Patti added comment: "Design validation complete" (2h ago)
- Status changed: In Progress → Code Review (2h ago)
- You were mentioned in comment by Patti (3h ago)

### Related PRs
1. #6782 - [FEAT-100] Create Integration UI (Open)
   - Status: ✅ All checks passing
   - 2 approvals, 1 change requested

### Linked Docs (Confluence)
- Integration Creation Flow (updated yesterday)
- Design System - Forms (no recent updates)

### Next Steps
- [ ] Review PR #6782
- [ ] Respond to Patti's mention on ticket
```

---

### 4. End of Day Review

**User Query**: "Activity summary" or "What did I work on today?"

**Behavior**:
- Show all PR activity today (comments, reviews, merges)
- Show Jira ticket updates
- Show what needs attention tomorrow
- Context-aware (current project or all projects)

**Output Template**:
```markdown
## Daily Activity Summary - [Date]
**Project**: [Project Name or All Projects]

### PRs You Worked On (4)
- Reviewed PR #6782 - [FEAT-100] Create Integration UI
- Commented on PR #6779 - [FIX-200] Flag error handling
- Merged PR #6791 - [LCHUX-416] Update routes
- Opened PR #6795 - [FEAT-102] New feature

### PRs You Reviewed (2)
- Approved: PR #6782
- Requested changes: PR #6779

### Jira Activity (3)
- Commented on FEAT-100
- Updated status: FEAT-101 (In Progress → Code Review)
- Created ticket: FEAT-102

### Tomorrow's Action Items
- [ ] Re-review PR #6779 after fixes
- [ ] Continue work on FEAT-102
- [ ] Respond to comment on FEAT-100
```

---

### 5. Team Activity

**User Query**: "Team activity today" or "What's new in [project]?"

**Behavior**:
- Show recent PRs in the repo (context-aware)
- Filter to current project if in project directory
- Show merged PRs
- Show PRs in review
- Highlight team members' activity

**Output Template**:
```markdown
## [Project] Team Activity - Today

### Recently Merged (3)
1. [LCHUX-416] Update routes (#6791) - by Derry Birkett
2. [FIX-200] Flag error handling (#6779) - by John Doe
3. [FEAT-101] FM target groups (#6783) - by Jane Smith

### In Review (5)
1. [FEAT-100] Create Integration UI (#6782) - by Patti McLetchie
2. [FEAT-102] New feature (#6795) - by Derry Birkett
3. [FIX-201] Bug fix (#6796) - by John Doe

### New PRs Today (2)
1. [FEAT-103] Performance optimization (#6797) - by Jane Smith
2. [FEAT-104] UI polish (#6798) - by Patti McLetchie
```

---

### 6. Smart Filtering

**User Queries**:
- "PRs with failing checks"
- "PRs waiting for me"
- "Stale PRs" (no activity in X days)
- "My open tickets"
- "Tickets mentioning me"

**Behavior**: Apply specific filters and show targeted results

---

## GitHub CLI Integration

### Available Commands

The skill uses these `gh` commands:

```bash
# List PRs
gh pr list --author @me --repo OWNER/REPO
gh pr list --search "review-requested:@me" --repo OWNER/REPO
gh pr list --state all --limit 20 --repo OWNER/REPO

# PR details
gh pr view NUMBER --repo OWNER/REPO
gh pr view NUMBER --repo OWNER/REPO --comments
gh pr checks NUMBER --repo OWNER/REPO

# Search PRs by ticket
gh pr list --search "FEAT-100 in:title" --repo OWNER/REPO

# Repo activity
gh pr list --state merged --limit 10 --repo OWNER/REPO
```

### Context-Based Repository Detection

```javascript
// In a project directory
→ gh pr list --repo $(git remote get-url origin | extract_repo)

// No git repo context
→ User must specify repo or show all repos
```

---

## Jira Integration (Atlassian MCP)

### Using Atlassian MCP

The skill uses the Atlassian MCP server for Jira integration when configured.

### Fallback: GitHub PR Title Parsing

When Jira MCP isn't available, the skill will:
- Extract ticket numbers from PR titles (e.g., FEAT-100)
- Link to Jira web URLs
- Provide basic ticket information from PR descriptions

---

## Configuration

### Global Config: `~/.claude/skills/work-monitor/config/global.json`

```json
{
  "user": {
    "name": "Derry Birkett",
    "github_username": "dbirkett",
    "jira_email": "derry.birkett@cloudbees.com"
  },
  "preferences": {
    "default_view": "context-aware",
    "show_all_checks": false,
    "highlight_mentions": true,
    "max_pr_age_warning_days": 3,
    "stale_pr_days": 7
  },
  "notifications": {
    "failing_checks": true,
    "review_requests": true,
    "mentions": true,
    "stale_prs": false
  }
}
```

---

## Cache Management

### Cache Files

Store state in `~/.claude/skills/work-monitor/cache/`:

```
last-check.json          # Timestamp of last check
github-pr-state.json     # Known PRs and their states
github-comments.json     # Last seen comment IDs
jira-ticket-state.json   # Known tickets and states (if MCP available)
```

### Cache Structure

```json
// github-pr-state.json
{
  "derrybirkett/my-project": {
    "6782": {
      "title": "[FEAT-100] Create Integration UI",
      "status": "open",
      "checks_status": "success",
      "last_comment_id": "123456",
      "last_updated": "2026-03-03T10:30:00Z"
    }
  }
}
```

### Cache Usage

- Compare current state vs cached state
- Identify "new" activity since last check
- Highlight changes (status, comments, checks)
- Track what user has already seen

---

## Context-Aware Behavior Examples

### Scenario 1: In a Project Directory

```bash
$ cd ~/Projects/my-project
$ claude "What needs my attention?"
```

**Behavior**:
- Detects git remote → resolves to owner/repo
- Loads: Generic context or project-specific if configured
- Filters: PRs in that repo
- Shows: That project's activity

---

### Scenario 3: No Project Context

```bash
$ cd ~
$ claude "What needs my attention?"
```

**Behavior**:
- No specific project context
- Shows: All PRs across all repos
- Shows: All Jira tickets assigned to you
- Offers: "Want to filter to a specific project?"

---

### Scenario 4: Explicit Override

```bash
$ cd ~/anywhere
$ claude "Check my-project work"
```

**Behavior**:
- Explicit project name in request
- Resolves to matching repo if configured
- Shows: That project's activity regardless of current directory

---

## Integration with Other Skills

### Works With: designer-agent

When PRs contain UI changes:
- Check if Figma links exist in PR descriptions
- Suggest design validation for UI changes

### Works With: github-issues-workflow

- Cross-reference PRs with linked issues
- Move issues through workflow states as PRs progress

---

## Output Formats

### Terminal Summary (Default)
Plain text markdown summary with key information

### Detailed Report
Full details with all comments, checks, history

### Action Items Only
Focused list of things requiring your attention

### Open in Browser
Generate links and optionally open browser tabs for PRs/tickets

---

## Best Practices

### Before Standup
```
"What needs my attention?"
→ Quick overview of action items
```

### After Making Changes
```
"Activity summary"
→ Review what you worked on
```

### When Context Switching
```
"Check [project-name] work"
→ Focus on specific project
```

### End of Day
```
"What should I do tomorrow?"
→ List of pending items
```

---

## Error Handling

### No GitHub CLI
```
Error: GitHub CLI not found
→ Install: brew install gh
→ Authenticate: gh auth login
```

### No Jira MCP
```
Note: Jira MCP not configured
→ Showing Jira tickets from PR titles only
→ For full Jira integration, set up MCP server
```

### No Git Context
```
Note: Not in a git repository
→ Showing all work across all projects
→ To filter, specify project or navigate to project directory
```

---

## Jira MCP Setup Instructions

### To Enable Full Jira Integration

1. **Install Jira MCP Server**
   - Use Atlassian MCP server or custom integration
   - Configure with your Jira instance URL
   - Set up authentication (API token)

2. **Update Skill Config**
   - Add Jira MCP tools to skill
   - Configure default JQL queries
   - Set up notification preferences

3. **Test Integration**
   - Run: "Check my Jira tickets"
   - Verify: Comments, mentions, activity tracking

**I can help you set this up when you're ready!**

---

## Future Enhancements

### Planned Features
- [ ] Confluence integration (document tracking)
- [ ] Slack notifications (optional)
- [ ] Weekly digest reports
- [ ] Trend analysis (PR velocity, review time)
- [ ] Smart prioritization (ML-based urgency detection)
- [ ] Calendar integration (link tickets to meetings)

### Integration Opportunities
- VSCode extension (status bar integration)
- GitHub Actions (automated monitoring)
- Jira automation (trigger workflows)

---

## Quick Reference Commands

### Check Work Status
```
"What needs my attention?"
"What do I need to review?"
"Anything urgent?"
```

### PR Commands
```
"Check PR #6782"
"PRs with failing checks"
"My open PRs"
"PRs waiting for me"
```

### Ticket Commands
```
"Check FEAT-100"
"My open tickets"
"Tickets mentioning me"
```

### Activity Commands
```
"Activity summary"
"What did I work on today?"
"Team activity"
"What's new in [project]?"
```

### Context Override
```
"Check [project] work"
"Show all my work"
"Focus on [project-name]"
```

---

## Troubleshooting

### Skill not detecting project correctly
- Check: `git remote get-url origin`
- Verify: CLAUDE.md exists in repo
- Update: Project context file if needed

### GitHub CLI errors
- Check: `gh auth status`
- Re-auth: `gh auth login`
- Test: `gh pr list --limit 1`

### Missing PRs or tickets
- Clear cache: `rm ~/.claude/skills/work-monitor/cache/*.json`
- Check filters in config
- Verify repo access

---

**Skill Owner**: Derry Birkett
**Last Updated**: 2026-03-03
**Related Skills**: designer-agent, github-issues-workflow

**Status**: Phase 1 (GitHub PR monitoring) ✅
**Next Phase**: Jira MCP integration (pending setup)
