---
name: note-that
description: Frictionless insight capture. Use when the user says "note that" or when capturing observations mid-conversation worth remembering.
user-invocable: true
disable-model-invocation: false
argument-hint: "observation to capture"
metadata:
  tags: [capture, learn, session, continuous]
  category: core
  audience: core
---

# Note That

Frictionless mid-conversation insight capture. No interruption, no confirmation, just instant capture.

## Trigger

User says: "note that: [observation]" or you detect worth-capturing insight

## What to Capture

Capture observations that have value beyond this session:

- **Learning**: "I learned that X causes Y"
- **Friction**: "That was annoying because Z"
- **Decision**: "We decided to use approach A over B because..."
- **Pattern**: "This is the third time we've needed to do X"
- **Observation**: "Interesting that feature Y behaves this way"

**Don't** capture:
- Temporary session state ("we're working on X")
- Obvious facts ("the sky is blue")
- Single-use information

## Workflow

Execute these steps instantly, no confirmation needed:

### 1. Receive Input

User provides observation in one of these forms:
- "note that: [observation]"
- "remember this: [observation]"
- Or you detect insight worth capturing

### 2. Categorize

Determine category:
- `learning` - Gained knowledge or understanding
- `friction` - Pain point or frustration
- `decision` - Choice made with rationale
- `pattern` - Recurring behavior or observation
- `observation` - General noteworthy insight

### 3. Append to Insights

Append to `notes/insights.md`:

```markdown
## [YYYY-MM-DD HH:MM] | [category]

[observation text]
```

Example entries:
```markdown
## 2026-04-14 10:23 | learning

React useEffect cleanup functions run on unmount AND before next effect. 
This prevents stale subscription bugs.

## 2026-04-14 14:15 | friction

Grepping for API endpoints across microservices takes 3 different patterns.
Should unify or create helper.

## 2026-04-14 16:42 | decision

Chose GraphQL over REST for admin API because we need flexible querying
and the schema provides documentation.
```

### 4. Confirm Silently

Respond with brief confirmation:
- "Noted." 
- "Captured."
- "Logged to insights."

Then continue conversation - don't break flow.

## Implementation Notes

**File Location**: Always use `notes/insights.md` in current repo

**Format**:
- Use ISO 8601 timestamp (YYYY-MM-DD HH:MM)
- Categories in lowercase
- Keep observations concise but complete
- One blank line between entries

**Deduplication**: 
- Don't check for duplicates (that adds friction)
- Duplicates are fine - they signal importance
- Weekly review will consolidate similar items

**Privacy**:
- This file is git-ignored by default
- Don't capture sensitive information (passwords, API keys)
- Keep it to learnings and patterns

## Integration with Other Skills

**weekly-review**: Reads `notes/insights.md` to surface learnings

**learning-review**: Analyzes insights for patterns and themes

**productivity-agent**: Uses insights to coach on workflow improvements

## Examples

### Example 1: Learning
```
User: Note that: TypeScript's `satisfies` operator validates 
      types without widening them like `as const` does

Claude: Noted. [continues conversation]
```

Result in `notes/insights.md`:
```markdown
## 2026-04-14 11:30 | learning

TypeScript's `satisfies` operator validates types without 
widening them like `as const` does
```

### Example 2: Friction
```
User: That was frustrating - I had to restart the dev server 
      3 times to clear the cache

Claude: [detects friction signal]
        Noted - dev server cache issues causing restarts.
        [continues helping with task]
```

Result:
```markdown
## 2026-04-14 13:22 | friction

Dev server cache requires manual restarts to clear. 
Happened 3 times this session.
```

### Example 3: Pattern
```
Claude: [observes user has grepped for "import.*Button" 
         three times in the conversation]
         
         I notice you've searched for Button imports 3 times. 
         Note that: Button component locations are hard to remember?

User: Yes, exactly

Claude: Noted. [continues work]
```

Result:
```markdown
## 2026-04-14 15:45 | pattern

Button component locations are hard to remember across 
different component libraries. Searched 3+ times.
```

### Example 4: Decision
```
User: Remember this: We're using Zod for validation instead of 
      Yup because it has better TypeScript inference

Claude: Captured. [continues]
```

Result:
```markdown
## 2026-04-14 09:10 | decision

Using Zod for validation instead of Yup because it has 
better TypeScript inference
```

## Anti-Patterns

❌ **Don't**:
- Ask "Is this worth capturing?" (breaks flow)
- Request confirmation before writing
- Explain what you're doing in detail
- Create new categories beyond the 5 listed
- Refuse to capture because it seems "too simple"

✅ **Do**:
- Capture immediately
- Brief confirmation only
- Trust user judgment on what's worth noting
- When in doubt, capture it
- Keep entries concise but self-contained

## Verification

After using this skill:
- Check `notes/insights.md` has new entry
- Verify timestamp and category are correct
- Confirm observation is readable standalone
- Ensure conversation flow wasn't interrupted
