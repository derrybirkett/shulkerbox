---
name: wrap-up
description: End-of-session workflow. Stages changes, commits with conventional message, handles both direct-to-main and PR-based workflows, manages version tags, and prepares handover notes.
user-invocable: true
disable-model-invocation: true
argument-hint: optional commit message
metadata:
  tags: [git, commit, versioning, workflow, session, release, handover, pr]
  category: core
  audience: core
---

# Wrap Up

End-of-session workflow that commits, tags, and pushes.

## Trigger

`wrap up` or `/wrap-up`

## Steps

Execute in order. Stop and report if any step fails.

### 0. Load config

Read `.shulkerbox/config.yml` from the repo root if it exists. Use the `wrap_up:`
section. **If the file or any key is missing, use these defaults (legacy behavior):**

| Key | Default |
|---|---|
| `wrap_up.changelog.enabled` | `false` |
| `wrap_up.changelog.path` | `CHANGELOG.md` |
| `wrap_up.releases.enabled` | `false` |
| `wrap_up.issues.enabled` | `false` |
| `wrap_up.issues.label_namespace` | `next` |
| `wrap_up.activity_log.enabled` | `true` |
| `wrap_up.activity_log.path` | `notes/activity-log.md` |
| `wrap_up.learnings.target` | `activity_log` |

With defaults, this skill behaves exactly as it did before this config existed
(handover to inbox, learnings as an activity-log blockquote, no changelog/release).

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

### 2.5. Pre-Commit Verification

Run automated checks before committing to catch common issues:

#### Check 1: TODOs and FIXMEs
```bash
git diff --cached | grep -E "^\+.*TODO|^\+.*FIXME|^\+.*XXX"
```
**If found:** List them and ask: "⚠️  Adding TODO/FIXME markers. Commit anyway? [y/N]"

#### Check 2: Sensitive Files
```bash
git diff --cached --name-only | grep -E "\.env$|\.env\.|credentials|secrets|password|private.*key|api.*key|token"
```
**If found:** Show warning and require explicit confirmation:
```
⚠️  WARNING: Potential sensitive files staged:
   - .env.local
   - config/credentials.json
   
This is likely a mistake. Proceed? [y/N]
```
If user says N, abort to Step 1.

#### Check 3: Broken References (Migration Detection)
If git shows both deletions and additions (potential migration):
```bash
# Detect migration pattern
deleted_count=$(git diff --cached --diff-filter=D --name-only | wc -l)
added_count=$(git diff --cached --diff-filter=A --name-only | wc -l)
```
**If both > 0:** Check if old paths are referenced in documentation:
```bash
git diff --cached --diff-filter=D --name-only | head -3  # Sample old paths
```
Then check if README.md is staged:
```bash
git diff --cached --name-only | grep -E "README|ARCHITECTURE|docs/"
```
**If documentation NOT staged:** Warn: "⚠️  Files moved/deleted but documentation not updated. Proceed? [y/N]"

#### Check 4: Directory Structure Completeness
If creating new directories (check for "A" status with directory paths):
```bash
# List new directories being created
git diff --cached --name-status | grep "^A" | awk '{print $2}' | xargs dirname | sort -u
```
**If migration detected:** Ask: "Directory structure change detected. All planned directories created? [y/N]"

#### Verification Summary
Present results in compact format and proceed automatically unless a blocker is found:
```
✅ Pre-Commit Verification:
   ✅ No TODOs in staged changes
   ✅ No sensitive files detected
   ✅ Documentation updated
   ⚠️  Directory migration: 15 files moved
```

Only pause for explicit blockers (sensitive files detected, TODOs added). Otherwise proceed directly to Step 3.

### 3. Draft and propose commit message

Before asking the user, generate a commit message draft automatically:

```bash
# Get context for the draft
git diff --cached --stat
git diff --cached --name-only
git log --oneline -5   # to match the project's commit style
```

Analyse:
- **Which files changed** — infer the domain (content, app, lib, docs, config)
- **Scale of change** — number of files and lines to gauge scope
- **Recent commit style** — match the project's existing vocabulary and phrasing
- **Branch name** — often signals intent (e.g. `feature/ideas-studio` → ideas/studio work)

Compose a conventional commit message:
```
<type>: <short description in present tense, lowercase, no trailing period>

# Types: feat | fix | chore | docs | refactor | test | style | content
```

Show it briefly and use it immediately — no confirmation needed:

> **Committing:** `feat: complete ideas studio with full post detail view and enriched blog content`

### 4. Commit
```bash
git commit -m "<formatted message>"
```

### 5. Determine next tag
```bash
git tag --sort=-v:refname | head -5
```

Find the latest `v*.*.*` tag. If none exists, start at `v0.1.0`.

#### Automatic Breaking Change Detection

Before asking the user, analyze staged changes for breaking change indicators:

**File Moves/Renames (Path Changes):**
```bash
git diff --cached --name-status | grep "^R"
renamed_count=$(git diff --cached --name-status | grep "^R" | wc -l)
```
If `renamed_count > 0` → Likely breaking (affects imports, references, symlinks)

**Skill/Agent Metadata Changes:**
```bash
git diff --cached -- '**/SKILL.md' | grep -E "^[+-]name:"
git diff --cached -- '**/AGENT.md' | grep -E "^[+-]name:"
git diff --cached -- '**/SKILL.md' | grep -E "^[+-]user-invocable:"
```
If skill/agent names or invocability changed → Breaking

**Directory Structure Changes:**
```bash
# Check if files moved between directories (not just renamed in place)
git diff --cached --name-status | awk '$1 == "R" {print $2, $3}' | \
  awk '{split($1,a,"/"); split($2,b,"/"); if(a[1] != b[1]) print}'
```
If files moved to different top-level directories → Breaking

**Present Detection Results:**
```
🔍 Breaking Change Analysis:
   ✅ 15 files moved between directories (skills/ reorganization)
   ✅ Directory structure changed (flat → categorized)
   ⚠️  This appears to be a BREAKING CHANGE
   
   Suggested: MAJOR version bump
```

**Determine and apply automatically:**
- **major** if breaking changes detected (file moves, name changes, structure changes)
- **minor** if new files/skills/agents added this session
- **patch** otherwise (edits, fixes, docs)

Show the bump and reasoning, then apply immediately — no confirmation needed:

> **Tagging:** `v0.33.2 → v0.33.3` (patch — edits only)

### 5.5. Update changelog (if `wrap_up.changelog.enabled`)

Skip this entire step if `wrap_up.changelog.enabled` is false.

Open the changelog at `wrap_up.changelog.path`. Move any items under
`## [Unreleased]` into a new dated section and add a curated entry for the version
chosen in step 5 (without the leading `v`), dated today:

```markdown
## [Unreleased]

## [X.Y.Z] — YYYY-MM-DD

[One curated sentence — reuse the session summary, phrased for a reader.]

### Added
- [user-facing additions, if any]

### Changed
- [user-facing changes, if any]

### Fixed
- [user-facing fixes, if any]
```

Omit any of Added/Changed/Fixed with no entries; keep a fresh empty
`## [Unreleased]` at the top. Then fold it into the existing commit so the tag
will include it:

```bash
git add <wrap_up.changelog.path>
git commit --amend --no-edit
```

(`--no-edit` preserves the commit message already approved in step 3. The commit
has not been pushed yet at this point, so amending is safe.)

### 5.7. Manifest drift check

Manifests that list other files rot silently. Before tagging, verify the ones
present in this repo and fix any drift now (fold the fix into this session's
commit) rather than deferring:

- **`skills/README.md`** — if `skills/**/SKILL.md` files exist, every skill's
  `name:` must appear in the README's Available Skills section:
  ```bash
  grep -h "^name:" skills/*/*/SKILL.md | sed 's/name: //' | sort
  ```
  Compare against the README; add any missing entries.
- **`council.yaml`** (or any manifest with an `advisors:`-style list) — the
  list must match the actual directories (`ls advisors/`).
- **`versions.yaml`** (bloom hub) — if this tag is a minor or major bump of a
  bloom member repo, append a release row to the hub's `versions.yaml` in the
  same session; its compatibility rules require a new row per minor bump.

If a mismatch cannot be fixed in this session, say so explicitly in the final
report (step 10) — never tag silently over known drift.

### 6. Tag
```bash
git tag v<new-version>
```

### 7. Detect workflow and push

First, detect the current branch and workflow:

```bash
current_branch=$(git branch --show-current)
main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
```

**If on main branch:**
```bash
git push origin main --tags
```
Proceed to step 8.

**If on feature branch:**

The project uses a PR-based workflow. Handle it:

#### 7a. Push feature branch
```bash
git push origin $current_branch
```

#### 7b. Check for existing PR
```bash
gh pr view --json state,number 2>/dev/null
```

**If no PR exists:**
Ask: **"Create pull request for this branch? [Y/n]"**

If yes:
```bash
gh pr create --title "<commit message>" --body "$(cat <<'EOF'
## Summary
<Brief description from commit>

## Changes
<List key changes>

## Test plan
- [ ] <Test items>

🤖 Generated with Claude Code
EOF
)"
```

**If PR exists and is open:**
Show PR URL and status.

Ask: **"PR #<number> is ready to merge. Merge and return to main? [Y/n]"**

If yes:

#### 7c. Merge PR and cleanup
```bash
gh pr merge --squash --delete-branch
git checkout $main_branch
git pull origin $main_branch
git branch -d $current_branch 2>/dev/null || true
git fetch --prune
```

**If user says no:**
Report: "Staying on feature branch. Next session will continue here or you can switch to main manually."

Skip tagging (tags only apply to main branch).

Proceed to step 8.

**If `gh` command not found:**
Report: "GitHub CLI not installed. Push completed. Create PR manually at: `git remote get-url origin`"

### 7.5. Publish GitHub Release (if `wrap_up.releases.enabled` and tag is on main)

Skip if `wrap_up.releases.enabled` is false.

**Only publish a release when the tag is reachable from `main`** — i.e. the push
in step 7 went to `main`. If step 7 used the feature-branch / PR path, the tag is
on an unmerged commit; a release would orphan. In that case, **defer**: report
"release deferred until vX.Y.Z is merged to main" and skip.

When on the main path, publish using this version's changelog section as the body:

```bash
awk -v v="X.Y.Z" '$0 ~ "^## \\["v"\\]"{f=1;print;next} /^## \[/{f=0} f' \
  <wrap_up.changelog.path> > /tmp/release-notes.md
gh release create vX.Y.Z --title "vX.Y.Z" --notes-file /tmp/release-notes.md
```

Substitute the real version for `X.Y.Z` / `vX.Y.Z`. If `gh release create` reports
the release already exists, report it and continue (do not fail the wrap-up).

### 8. Document session in activity log (if `wrap_up.activity_log.enabled`)

Skip if `wrap_up.activity_log.enabled` is false or the directory of
`wrap_up.activity_log.path` does not exist.

Prepend a **slim narrative** entry to `wrap_up.activity_log.path` — the "why / how
it went" story only. **Do not** duplicate learnings (those go to memory in step
8.5) or next-steps (those go to issues in step 9):

```markdown
## YYYY-MM-DD | <short session title>

**Version:** vX.Y.Z

<One or two paragraphs of narrative: what was attempted, key decisions, how it went.>

---
```

### 8.5. Capture learnings

Ask the user for learning notes, **wait for their response**, and **suggest
specific candidate learnings** drawn from this session rather than asking an
open-ended question. For example: "Worth saving as learnings: (a) <X>, (b) <Y>.
Any of those, or others?"

- If `wrap_up.learnings.target` is `memory`: for each confirmed learning, write a
  memory file under the project memory directory and add a one-line pointer to
  `MEMORY.md` (follow the memory format already used in this repo).
- If `wrap_up.learnings.target` is `activity_log` (legacy default): append each
  learning as a blockquote under the activity-log entry from step 8.

### 9. Prepare handover

Review the conversation and extract next steps that were discussed or agreed.
Present them to the user for confirmation:

> **During this session, we agreed on these next steps:**
> - [item] — proposed status: <urgent|in-progress|ready|waiting|decision>
> - ...
>
> **File these?**

If confirmed:

- **If `wrap_up.issues.enabled` is true** — file one GitHub Issue per next step:

  ```bash
  gh issue create \
    --title "<concise next-step title>" \
    --label "<namespace>:<status>" \
    --body "$(printf '%s\n\n> Priority: %s · Effort: %s · Clarity: %s\n' \
        "<context needed to start>" "<priority>" "<effort>" "<clarity>")"
  ```

  where `<namespace>` is `wrap_up.issues.label_namespace` (default `next`) and
  `<status>` is one of `urgent|in-progress|ready|waiting|decision`. Ensure each
  `<namespace>:<status>` label exists first (`gh label create ... --force`).

- **Else (legacy)** — prepend a `## Handover — YYYY-MM-DD` section to
  `notes/inbox.md` as before (one sentence summary + a checkbox task list).

If there were no next steps, or the user declines, skip this step.

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

- Branch strategy: feature branches off `main` (enforced by pre-push hook)
- Merge strategy: squash merge via PR
- Commit convention: conventional commits (feat|fix|chore|docs|refactor|test|style)
- All changes go through feature branches and PRs (no direct push to `main`)
- `main` is always the source of truth
