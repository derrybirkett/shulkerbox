# Daily Digest Template

## Work Summary - {{PROJECT_NAME}}
**As of**: {{TIMESTAMP}}
**Context**: {{CONTEXT_TYPE}}

---

### PRs Awaiting Your Review ({{PR_REVIEW_COUNT}})

{{#each prs_for_review}}
{{index}}. [{{ticket_number}}] {{title}} (#{{pr_number}})
   - Author: {{author}}
   - Status: {{check_status}}
   - Age: {{age}}
   - Priority: {{priority_indicator}}
   - Link: {{url}}
{{/each}}

{{#if no_prs_for_review}}
✅ No PRs awaiting your review
{{/if}}

---

### Your PRs with Activity ({{YOUR_PR_COUNT}})

{{#each your_prs}}
{{index}}. [{{ticket_number}}] {{title}} (#{{pr_number}})
   - {{activity_summary}}
   - Status: {{status}}
   - Link: {{url}}
{{/each}}

{{#if no_your_prs}}
📝 No activity on your PRs
{{/if}}

---

### Jira Tickets Needing Attention ({{TICKET_COUNT}})

{{#each tickets}}
{{index}}. {{ticket_key}}: {{summary}}
   - Status: {{status}}
   - Priority: {{priority}}
   - Activity: {{activity_summary}}
   - Link: {{url}}
{{/each}}

{{#if no_tickets}}
✅ All tickets up to date
{{/if}}

---

### Special Items

{{#if failing_checks}}
⚠️ **PRs with Failing Checks** ({{failing_count}})
{{#each failing_prs}}
- PR #{{pr_number}}: {{check_summary}}
{{/each}}
{{/if}}

{{#if mentions}}
💬 **You Were Mentioned** ({{mention_count}})
{{#each mentions}}
- {{source}}: {{context}}
{{/each}}
{{/if}}

{{#if stale_items}}
⏰ **Stale Items** ({{stale_count}})
{{#each stale}}
- {{type}} #{{number}}: {{age}} old
{{/each}}
{{/if}}

---

### Action Items

{{#each action_items}}
- [ ] {{description}} ({{priority}})
{{/each}}

{{#if no_action_items}}
✨ No immediate action items
{{/if}}

---

### Statistics

- **PRs reviewed this week**: {{prs_reviewed_count}}
- **PRs merged this week**: {{prs_merged_count}}
- **Tickets completed this week**: {{tickets_completed_count}}
- **Average review time**: {{avg_review_time}}

---

**Tip**: {{helpful_tip}}
