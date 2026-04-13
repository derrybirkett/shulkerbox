---
name: wrap-up
description: End-of-session workflow. Stages all changes, prompts for a conventional commit message, increments the patch version tag, pushes to origin main with tags, and prepares handover notes for the next session.
user-invocable: true
disable-model-invocation: true
argument-hint: optional commit message
metadata:
  tags: [git, commit, versioning, workflow, session, release, handover]
  category: workflow
---

# Wrap Up

End-of-session workflow that commits, tags, and pushes.

## Trigger

`wrap up` or `/wrap-up`

## Steps

Execute in order. Stop and report if any step fails.

### 1. Check status
```bash
git status
git diff --stat
```
Show the user what will be staged. If working tree is clean, say so and ask whether to proceed with just a tag bump.

### 2. Stage all changes
```bash
git add -A
```

### 3. Prompt for commit message
Ask the user: **"Commit message?"**

Format it as a conventional commit:
```
<type>: <short description>

# Types: feat | fix | chore | docs | refactor | test | style
# One logical change per commit
# Present tense, lowercase, no trailing period
```

If the user's input isn't already in conventional format, convert it and confirm before committing.

### 4. Commit
```bash
git commit -m "<formatted message>"
```

### 5. Determine next tag
```bash
git tag --sort=-v:refname | head -5
```

Find the latest `v*.*.*` tag. If none exists, start at `v0.1.0`.

Ask: **"Major, minor, or patch bump?"** — then show the semver rules as a one-liner reminder:

> `patch` = fix or edit existing · `minor` = new skill/agent/file · `major` = breaks how you invoke or find things

Default to **minor** if new skills or agents were added this session, **patch** otherwise. Accept the user's override without argument.

Propose the resulting tag (e.g. `v0.4.0 → v0.5.0`) and confirm before applying.

### 6. Tag
```bash
git tag v<new-version>
```

### 7. Push
```bash
git push origin main --tags
```

### 8. Document session in activity log

Write a session summary to `notes/activity-log.md`:

```markdown
## YYYY-MM-DD HH:MM | Session Wrap-Up

**Version:** vX.Y.Z
**Commits:** [list of commit messages from this session]

[One paragraph summary of what was accomplished this session]

```

Then ask: **"Any learning notes to add?"**

If the user provides one, append it as a blockquote below the session entry:

```markdown
> <learning note>
```

**Notes location:** Use `./notes/activity-log.md` in the current working directory. If `notes/` doesn't exist, skip this step entirely.

### 9. Prepare handover
Review the conversation and extract any next steps that were discussed or agreed upon during the session.

Present them to the user:

**"During this session, we agreed on these next steps:**
- [First agreed item]
- [Second agreed item]
- [etc.]

**Should I add these to the handover?"**

If confirmed, prepend them to `notes/inbox.md` as a new section at the top:

```markdown
## Handover — YYYY-MM-DD

**From this session:**
[One sentence summary of what was accomplished]

**Next steps:**
- [ ] [First task]
- [ ] [Second task]
- [ ] [etc.]

---

[existing inbox content...]
```

Use today's date for the heading. Format as a task list with checkboxes.

If there were no next steps discussed during the session, or the user declines, move on — not every session needs a handover.

### 10. Confirm and end
Report:
- Commit SHA (short, or "none" if just tag bump)
- Tag applied
- Push status
- Activity log updated
- Handover written (if applicable)

Then say **"Session wrapped"** and stop.

---

## Git workflow conventions

- Branch strategy: feature branches off `main`
- Merge strategy: squash merge via PR
- Commit convention: conventional commits (feat|fix|chore|docs|refactor|test|style)
- PRs required for shared work; direct push to `main` allowed for solo projects
- `main` is always the source of truth
