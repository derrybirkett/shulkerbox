---
name: handover
description: End-of-session context capture. Use when wrapping up work to ensure next session can pick up seamlessly.
user-invocable: true
disable-model-invocation: false
argument-hint: optional focus area
metadata:
  tags: [session-end, capture, plan]
  category: core
  audience: core
---

# Handover

End-of-session context transfer. Capture where you are, what's next, and what context is needed for pickup.

## Trigger

- User runs `/wrap-up` (auto-invokes handover)
- User says "handover", "pass the baton", "document where we are"
- Session is ending with unfinished work

## Purpose

Create a bridge between sessions so next session can start immediately without re-explaining context. Answers:
- What state are we in?
- What are the next steps?
- What decisions are pending?
- What context is needed?
- What's blocking progress?

## Workflow

### 1. Review Conversation

Scan the current conversation for:
- **Current work**: What's in progress right now
- **Completed items**: What was finished this session
- **Pending decisions**: Choices that need to be made
- **Blockers**: What's waiting on something else
- **Open questions**: Things that need clarification
- **Context**: Information needed to continue

### 2. Extract and Categorize

Organize findings into:

**🔴 URGENT** - Needs immediate attention next session
- Bugs blocking deployment
- Time-sensitive decisions
- Critical blockers
- High-priority fixes

**🟡 IN PROGRESS** - Partially complete work
- Current focus with completion %
- What's done, what remains
- Files/areas involved

**🟢 READY** - Can be picked up anytime
- Tasks with clear next steps
- Background work
- Nice-to-haves

**🔵 WAITING** - Blocked on external factors
- Waiting for review/approval
- Dependent on other work
- External dependencies

**❓ DECISIONS** - Choices to be made
- Options A vs B comparisons
- Trade-offs to consider
- Research needed

### 3. Score Priority

For each item, assign:
- **Priority**: urgent | high | medium | low
- **Effort**: quick (<30min) | medium (1-2hr) | large (>2hr)
- **Clarity**: clear (can start immediately) | needs-context | needs-decision

### 4. Generate Tags

Tag items with:
- `@urgent` - Do first
- `@blocked` - Can't proceed yet
- `@decision-needed` - Requires choice
- `@follow-up` - Check back on status
- `@in-progress` - Currently active
- `@ready` - Can start anytime
- `@waiting-on:{person/thing}` - External dependency

### 5. Write to Inbox

Prepend to `notes/inbox.md`:

```markdown
## Handover — YYYY-MM-DD

**From this session:**
[One sentence summary of what was accomplished]

**Next steps:**

### 🔴 URGENT
- [ ] @urgent [Task description] (Priority: urgent, Effort: medium, Clarity: clear)
  Context: [Brief context needed to start]
  
### 🟡 IN PROGRESS  
- [ ] @in-progress [Task description] — 60% complete (Priority: high, Effort: large)
  What's done: [Completed parts]
  What remains: [Next actions]
  Files: [Relevant file paths]
  
### 🟢 READY
- [ ] @ready [Task description] (Priority: medium, Effort: quick, Clarity: clear)
  Next action: [First step]
  
### 🔵 WAITING
- [ ] @waiting-on:security-review [Task description] (Priority: high, Effort: quick, Clarity: needs-context)
  Waiting for: [What's blocking]
  When unblocked: [What to do]
  
### ❓ DECISIONS
- [ ] @decision-needed [Decision to make]
  Option A: [Description + pros/cons]
  Option B: [Description + pros/cons]
  Context: [Why this matters]

---

[Previous inbox content...]
```

### 6. Generate Pickup Script

Create mental pickup script for next session:
1. Which item to surface first (usually @urgent or top @in-progress)
2. What context to provide
3. Which agent persona to load (designer/developer/product)

### 7. Confirm Handover

Report to user:
```
Handover complete:
- X urgent items
- Y in-progress items  
- Z ready items
- N blocked items
- M decisions pending

Run /pickup next session to resume.
```

## Integration with Other Skills

**wrap-up**: Calls handover after git operations complete

**pickup**: Reads handover from inbox to restore context

**productivity-agent**: Reviews handover during standup

## Examples

### Example 1: Bug Fix Session

**Conversation Context**:
- Started investigating auth bug
- Found root cause in token validation
- Security review approved fix approach
- Implementation 80% done
- Need to add tests

**Handover Output**:
```markdown
## Handover — 2026-04-14

**From this session:**
Investigated auth bug, identified root cause in token validation, 
got security approval for fix approach.

**Next steps:**

### 🟡 IN PROGRESS
- [ ] @in-progress Fix authentication token validation bug — 80% complete 
      (Priority: urgent, Effort: quick, Clarity: clear)
  What's done: Root cause identified, fix approach approved by security
  What remains: Finish implementation in auth/tokens.ts:42, add tests
  Files: src/auth/tokens.ts, tests/auth/tokens.test.ts
  Context: Bug causes JWT tokens to accept expired timestamps. Security 
           review completed yesterday, approach validated.

---
```

### Example 2: Feature Development

**Conversation Context**:
- Building onboarding flow
- Steps 1-3 complete
- Step 4 (validation) needs design decision
- Two approaches discussed
- Waiting on PM input

**Handover Output**:
```markdown
## Handover — 2026-04-14

**From this session:**
Built steps 1-3 of onboarding flow, reached decision point on 
validation approach for step 4.

**Next steps:**

### 🟡 IN PROGRESS
- [ ] @in-progress Complete onboarding flow step 4 (validation) — 75% complete
      (Priority: high, Effort: medium, Clarity: needs-decision)
  What's done: Steps 1-3 complete, validation logic structured
  What remains: Choose and implement validation approach
  Files: src/components/Onboarding/Step4.tsx
  
### ❓ DECISIONS
- [ ] @decision-needed Validation approach for onboarding step 4
  Option A: Client-side validation only (faster UX, less server load)
    Pros: Immediate feedback, no latency
    Cons: Can be bypassed, need to duplicate on server anyway
  Option B: Server validation with optimistic UI
    Pros: Secure, single source of truth
    Cons: Network latency, more complex state management
  Context: Product wants fast UX but security is important. 
           Discussed both with team, leaning toward Option B.
           
### 🔵 WAITING
- [ ] @waiting-on:pm-input Final decision on validation approach
  Waiting for: PM to review security requirements
  When unblocked: Implement chosen approach in Step4.tsx

---
```

### Example 3: Refactoring Session

**Conversation Context**:
- Refactoring user model
- Two approaches documented
- Need to run tests before committing
- Some test failures to investigate

**Handover Output**:
```markdown
## Handover — 2026-04-14

**From this session:**
Explored two approaches for user model refactoring, started 
implementation but hit test failures.

**Next steps:**

### 🔴 URGENT
- [ ] @urgent Fix failing tests in user model refactor 
      (Priority: urgent, Effort: medium, Clarity: needs-context)
  Context: Refactored UserModel to use composition pattern. 
           3 tests failing in tests/models/user.test.ts.
           Errors suggest mock data format changed.
  Files: src/models/User.ts, tests/models/user.test.ts
  Next action: Update test mocks to match new UserModel structure

### 🟢 READY
- [ ] @ready Update API endpoints to use refactored UserModel 
      (Priority: medium, Effort: large, Clarity: clear)
  Next action: After tests pass, update these endpoints:
    - POST /api/users
    - PATCH /api/users/:id
    - GET /api/users/:id
  Context: Refactor maintains backward compatibility, just internal changes

---
```

### Example 4: Multi-Task Session

**Conversation Context**:
- Fixed API bug (✅ complete)
- Updated documentation (✅ complete)
- Started GraphQL research (ongoing)
- Discussed design system updates (parked)

**Handover Output**:
```markdown
## Handover — 2026-04-14

**From this session:**
Fixed API authentication bug and updated related docs. Started GraphQL 
migration research.

**Next steps:**

### 🟡 IN PROGRESS
- [ ] @in-progress Research GraphQL migration approach — 30% complete
      (Priority: medium, Effort: large, Clarity: needs-context)
  What's done: Reviewed Apollo vs Relay, documented pros/cons
  What remains: Evaluate data loading patterns, assess migration effort
  Files: docs/research/graphql-migration.md
  Context: Researching for Q3 planning. Need recommendation by end of month.

### 🟢 READY  
- [ ] @ready Design system color palette update 
      (Priority: low, Effort: medium, Clarity: needs-decision)
  Next action: Review Figma designs from designer
  Context: Design team proposed updating grays to improve contrast. 
           Needs WCAG validation and implementation plan.

---
```

## Best Practices

### Quality Handover Checklist

✅ **Context is self-contained**: Next session doesn't need to read entire previous conversation

✅ **Next actions are clear**: First step is obvious, not "continue working on X"

✅ **Priorities are ranked**: Urgent items clearly marked

✅ **Blockers are explicit**: What's waiting and why

✅ **File paths included**: Easy to jump back in

✅ **Decisions documented**: Options and trade-offs captured

### What to Avoid

❌ **Vague items**: "Finish the feature" (what's left?)

❌ **No context**: "Fix bug in tokens.ts" (what bug?)

❌ **No prioritization**: Everything seems equally important

❌ **Too much detail**: Full conversation history (just highlights)

❌ **No tags**: Hard to filter and find items

## Verification

After handover:
- Check `notes/inbox.md` has new handover section
- Verify @tags are applied correctly
- Confirm priority, effort, clarity scores make sense
- Ensure context is self-contained
- Test: could someone else pick this up?
