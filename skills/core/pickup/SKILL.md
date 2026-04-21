---
name: pickup
description: Start-of-session context restoration. Use proactively at session start to show where we left off.
user-invocable: true
disable-model-invocation: false
metadata:
  tags: [session-start, plan, continuous]
  category: core
  audience: core
---

# Pickup

Start-of-session context restoration. Read the handover from the last session and present priorities for today.

## Trigger

- Session start (via session-start hook notification)
- User says "pickup", "where were we?", "what's next?", "resume work"
- After user returns from break/meeting

## Purpose

Zero-friction session startup. Within 30 seconds, user knows:
- Where they left off
- What's most important
- What context they need
- Which work to tackle first

## Workflow

### 0. Check Recent Activity (Git Context)

Before reading the inbox, check for uncommitted work and recent commit activity to detect mid-task resumption:

```bash
git status --short
git diff --stat
git log --oneline --since="24 hours ago" -10
git tag --sort=-v:refname | head -3
```

**Analysis:**
- **Uncommitted changes present?** → Note: "You have uncommitted work from last session"
- **Recent commits since last tag?** → Show what's been done since last version
- **Working tree clean but recent commits exist?** → Possible mid-wrap-up resumption (commits not tagged yet)
- **Both clean and no recent commits?** → Fresh start or long break

**Present Git Context:**
```
📊 Session Context
   Last tag: v1.0.0 (2 commits ago)
   Uncommitted: 3 files modified, 1 file added
   Recent commits (last 24h):
     - 23e0aa8 refactor: reorganize skills and agents
     - 5c52374 feat: wrap-up writes to activity log
```

This helps detect:
- **Mid-reorganization resumption** (commits exist but work incomplete)
- **Forgotten wrap-ups** from previous session (commits not tagged)
- **What's changed** since last versioned state
- **Session continuity** (pick up where you left off)

**Integration:** This git context is shown FIRST, then handover items from inbox, providing complete continuity.

### 1. Read Inbox

Open `notes/inbox.md` and find the most recent handover section:

```markdown
## Handover — YYYY-MM-DD
```

Extract all items with their:
- Tags (`@urgent`, `@in-progress`, `@ready`, `@blocked`, `@decision-needed`)
- Priority levels
- Context
- Status

### 2. Check for Resolved Blockers

For each `@blocked` or `@waiting-on:X` item:
- Check if blocker might be resolved (time passed, related work done)
- Flag items that may be ready now
- Keep blocked items if blocker still applies

### 3. Prioritize for Presentation

Sort items by:
1. **@urgent** items first (red)
2. **@in-progress** items next (yellow)
3. **@ready** items with high priority (green)
4. **@decision-needed** items (blue)
5. **@blocked** items last (gray)

Select top 3-5 items to present (don't overwhelm with full list).

### 4. Present Pickup

Format output:

```
Welcome back! Here's where we left off:

🔴 URGENT (X items)
   [Top urgent item with brief context]
   
🟡 IN PROGRESS (Y items)
   [Item 1]: [Brief description] — Z% complete
   Context: [One-line context]
   Next: [First action]
   
   [Item 2 if exists]

🟢 READY (N items)
   [Top ready item with next action]

[If any blockers resolved:]
✅ UNBLOCKED: [Item that was waiting is now ready]

Which would you like to tackle first?
```

### 5. Await User Choice

User responds with:
- Number (1, 2, 3...)
- Description ("the auth bug", "onboarding")
- Priority ("urgent one", "the in-progress work")
- New request ("actually, let's do X")

### 6. Load Context & Agent

Based on choice:
- Load relevant file paths
- Provide stored context
- Load appropriate agent persona:
  - `@design` items → Designer agent
  - `@code` items → Developer agent
  - `@product` items → Product agent
  - General → Continue as main assistant

### 7. Start Work

Begin with confirmation:
```
Great choice. [Restate item + context]
[Load agent if needed]
[Begin work]
```

## Integration with Other Skills

**handover**: Writes the pickup data to inbox

**session-start hook**: Notifies that pickup is available

**productivity-agent**: May invoke pickup during standup

## Display Format Examples

### Example 1: Simple Pickup

```
Welcome back! Here's where we left off:

🔴 URGENT (1 item)
   Fix authentication bug in token validation
   Context: Security review approved approach yesterday
   Next: Finish implementation in auth/tokens.ts:42
   
🟡 IN PROGRESS (1 item)
   Complete onboarding flow — 75% complete
   Next: Implement step 4 validation
   
🟢 READY (2 items)
   Update API documentation
   Refactor user model

Which would you like to tackle first?
```

### Example 2: Blocker Resolved

```
Welcome back! Here's where we left off:

✅ UNBLOCKED: GraphQL migration research
   Was waiting on: PM approval (received this morning)
   Ready to: Continue evaluating migration patterns
   
🟡 IN PROGRESS (1 item)
   Design system color updates — 60% complete
   Next: Validate WCAG contrast ratios
   
🟢 READY (3 items)
   Implement dashboard analytics
   Fix flaky test in user flow
   Document API changes

Which would you like to tackle first?
```

### Example 3: Decision Pending

```
Welcome back! Here's where we left off:

❓ DECISION NEEDED
   Validation approach for onboarding
   Option A: Client-side (faster UX)
   Option B: Server validation (more secure)
   Context: Discussed both yesterday, leaning toward B
   
🟡 IN PROGRESS (1 item)
   Onboarding step 3 — waiting on validation decision
   
🟢 READY (2 items)
   Update user profile UI
   Add error logging

Would you like to make the validation decision first, or tackle something else?
```

### Example 4: Multiple Urgents

```
Welcome back! Here's where we left off:

🔴 URGENT (2 items)
   1. Prod bug: Users can't log in
      Context: Started investigation, found cause in session store
      Next: Deploy hotfix to clear stale sessions
      
   2. Deploy window closes in 3 hours
      Context: Need to merge and deploy auth changes
      Next: Run final tests, create PR

🟡 IN PROGRESS (1 item)
   Feature development — parked for urgents

Which urgent should we tackle first?
```

## Context Loading Examples

### Example: Developer Work

```
User: Let's fix the auth bug

Claude: Great choice. Loading context...

Auth Bug Fix (Priority: urgent)
- File: src/auth/tokens.ts:42
- Issue: JWT tokens accepting expired timestamps
- Approach: Validated by security yesterday
- Status: Implementation 80% done, tests needed

Let me check the current state of tokens.ts...
[Reads file and continues]
```

### Example: Design Work

```
User: The onboarding validation decision

Claude: Perfect. Let me load the designer agent context...

[Switches to designer agent persona]

Validation Decision for Onboarding Step 4
- Option A: Client-side validation
  Pros: Immediate feedback, no latency
  Cons: Can be bypassed, needs server duplication
  
- Option B: Server validation + optimistic UI  
  Pros: Secure, single source of truth
  Cons: Network latency, more complex

From a UX perspective, let's evaluate Option B's optimistic UI approach.
This can give us both security AND good user experience...
[Designer agent analyzes]
```

## Smart Behaviors

### Auto-Prioritization

If only 1 urgent item exists, offer to start immediately:
```
Welcome back! You have 1 urgent item:

🔴 Fix prod login bug
   Context: [Brief context]
   
This is urgent. Should we start on this right away?
```

### Blocker Detection

Check common blockers that may be resolved:
- **Time-based**: "waiting for end of day" → check if time passed
- **Approval-based**: "waiting for review" → check for new comments/approvals
- **Dependency-based**: "waiting for X PR" → check if PR merged

### Context Freshness

If handover is >3 days old:
```
Note: Last handover was 3 days ago. Some context may be stale.
[Present priorities]
Quick: Has anything changed since then?
```

### Empty Inbox

If no handover exists:
```
No handover from previous session. Starting fresh!

Recent activity from activity log:
- [Last 2-3 commits or work items]

What would you like to work on today?
```

## Best Practices

### Quick Scanning

Present items in scannable format:
- ✅ **Emojis for categories** (🔴🟡🟢❓🔵)
- ✅ **Bold for actions**
- ✅ **One-line context** (expand on request)
- ✅ **Clear "next action"** for each item

### Context Richness

Balance brevity with completeness:
- Enough to start immediately
- Not so much you need to read paragraphs
- Details available on request: "Tell me more about item 2"

### Respect User Choice

Don't force a specific item:
- Present options neutrally
- Allow "actually, let's do X instead"
- Support "show me all items" for full list

### Agent Loading

Load appropriate persona based on work type:
- Design/UX work → Designer agent
- Code/architecture → Developer agent  
- Features/specs → Product agent
- General → Stay as main assistant

## Anti-Patterns

❌ **Don't**:
- Dump entire inbox (overwhelming)
- Present items without context (confusing)
- Force user to pick from your list (inflexible)
- Auto-start work without confirmation (presumptuous)
- Show resolved/completed items (stale data)

✅ **Do**:
- Show top 3-5 items (scannability)
- Include brief context (orientation)
- Allow custom requests (flexibility)
- Confirm choice before starting (respect)
- Filter to active items only (relevance)

## Verification

After pickup:
- User understands where they left off (<30 seconds)
- User knows which item to tackle (decision made)
- Relevant context is loaded (no re-explaining)
- Appropriate agent persona activated if needed
- Work begins smoothly (no friction)

## Session Start Flow

```
[Session starts]
└─> session-start hook shows notification
    └─> User runs /pickup (or auto-triggered)
        └─> pickup reads notes/inbox.md
            └─> Presents top 3-5 priorities
                └─> User selects focus
                    └─> Load context + agent
                        └─> Begin work
```

Total time: <30 seconds from session start to productive work.
