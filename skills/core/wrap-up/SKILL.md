---
name: wrap-up
description: General end-of-session workflow. Reviews the worktree, stages an explicit change set, verifies risk, commits with a conventional message, optionally updates logs/changelog, and prepares a PR/tag/release handover without unsafe direct-to-main defaults.
user-invocable: true
disable-model-invocation: true
argument-hint: optional commit message or scope
metadata:
  tags: [git, commit, versioning, workflow, session, release, handover, pr]
  category: core
  audience: core
---

# Wrap Up

General end-of-session workflow for closing a coding or ops session without
sweeping in unrelated work. It is intentionally conservative by default:
explicit staging, no direct push to `main`, no release/tag action without a
checkpoint, and no silent continuation over known drift or sensitive files.

## Trigger

`wrap up` or `/wrap-up`

## Principles

- Protect unrelated work first. Never stage all files blindly in a dirty repo.
- Keep release actions separate from commit actions unless the user explicitly confirms both.
- Analyze the change set before committing; after commit, use `git show`, not the emptied index.
- Prefer feature branches and PRs. Direct-to-main is opt-in repo policy only.
- Make the final handover useful even if no commit or push happens.

## Steps

Execute in order. If a command used for inspection can return non-zero for a
clean result, handle that explicitly with `|| true` rather than treating it as a
workflow failure.

### 0. Load Config

Read `.shulkerbox/config.yml` from the repo root if it exists. Use the
`wrap_up:` section. If the file or any key is missing, use these defaults:

| Key | Default |
|---|---|
| `wrap_up.main_branch` | detected from `origin/HEAD`, fallback `main`, then `master` |
| `wrap_up.allow_direct_main` | `false` |
| `wrap_up.auto_stage_all` | `false` |
| `wrap_up.require_commit_confirmation` | `true` |
| `wrap_up.require_push_confirmation` | `true` |
| `wrap_up.changelog.enabled` | `false` |
| `wrap_up.changelog.path` | `CHANGELOG.md` |
| `wrap_up.releases.enabled` | `false` |
| `wrap_up.issues.enabled` | `false` |
| `wrap_up.issues.label_namespace` | `next` |
| `wrap_up.activity_log.enabled` | `true` |
| `wrap_up.activity_log.path` | first existing path from `ACTIVITY_LOG.md`, `notes/activity-log.md` |
| `wrap_up.handover.path` | first existing path from `notes/inbox.md`, `HANDOVER.md` |
| `wrap_up.learnings.target` | `activity_log` |

Also read repo-local instructions when present, including `AGENTS.md`,
`CLAUDE.md`, `README.md`, and contributing docs. Repo policy overrides these
defaults when it is stricter.

### 1. Inspect Worktree

```bash
git status --short --branch
git diff --stat
git diff --cached --stat
git log --oneline -5
```

Report:
- current branch and upstream status
- changed, deleted, renamed, and untracked files
- whether staged changes already exist
- repo-specific wrap-up rules discovered from local instructions

If the worktree is clean, do not propose a commit. Only discuss tag/release work
if the user explicitly asked for a release wrap-up and the current branch is the
main branch, up to date with origin.

### 2. Choose Staging Set

Build an explicit proposed staging set from the session context and the visible
worktree. Group unrelated changes separately.

Default behavior:
- If `wrap_up.auto_stage_all` is `false`, show the proposed file list and ask for
  confirmation before staging.
- If there are unrelated or ambiguous changes, exclude them unless the user
  explicitly includes them.
- If the user supplied a scope argument, use it to narrow the proposed staging
  set.

Only use `git add -A` when all of these are true:
- the repo config opts into `wrap_up.auto_stage_all: true`, or the user
  explicitly approves all-file staging for this run
- the status output has been shown
- sensitive-file checks are run before commit

Prefer pathspec staging:

```bash
git add -- <file-or-dir> [...]
```

After staging, show:

```bash
git diff --cached --stat
git diff --cached --name-status
```

If nothing is staged, stop before commit steps and provide handover notes.

### 2.5. Pre-Commit Verification

Run these checks on the staged change set.

#### TODOs and Markers

```bash
git diff --cached | grep -E '^\+.*(TODO|FIXME|XXX)' || true
```

If found, list them and ask whether to keep them. Default answer is no.

#### Sensitive Files

```bash
git diff --cached --name-only | grep -Ei '(^|/)\.env($|\.|/)|credentials|secrets|password|private.*key|api.*key|token' || true
```

If found, stop and require explicit confirmation. Do not continue silently.

#### Destructive or Broad Changes

```bash
git diff --cached --name-status
git diff --cached --diff-filter=D --name-only
```

Warn for large deletions, migrations, generated artifacts, lockfile churn, or
vendored/dependency directories. If the repo has documentation requirements for
migrations or ops changes, verify those files are staged too.

#### Repo Checks

Run the repo's lightweight verification command when obvious from local docs or
Makefile. If no such command exists, say so. Do not invent heavyweight checks.

Examples:
- `make test`
- `make lint`
- `make health`
- `make infra-scan`

### 3. Analyze Commit and Version Before Committing

Capture metadata while the staged diff still exists:

```bash
git diff --cached --stat
git diff --cached --name-status
git diff --cached --name-only
git diff --cached -- '**/SKILL.md' '**/AGENT.md' 2>/dev/null || true
```

Use this staged metadata for commit summary, release notes, and suggested
version bump.

Suggested bump:
- **major** for breaking interface changes, removals, renames that affect public
  paths, skill/agent name changes, or incompatible config structure changes
- **minor** for new user-visible features, new services, new skills/agents, or
  new operational commands
- **patch** for fixes, docs, maintenance, small config adjustments, or internal
  cleanup

Version detection:

```bash
git tag --list 'v[0-9]*.[0-9]*.[0-9]*' --sort=-v:refname | head -5
```

If no semver tag exists, suggest `v0.1.0`. The bump is a suggestion until the
push/tag checkpoint.

### 4. Draft Commit Message

Use the optional user argument if it is a valid commit message. Otherwise draft a
conventional commit from the staged metadata and recent project style:

```text
<type>: <short description in present tense, lowercase, no trailing period>
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `content`.

Show one compact checkpoint:

```text
Ready to commit?
- Files: <N> staged
- Message: <message>
- Suggested version: <old> -> <new> (<reason>)
- Checks: <passed/skipped/warnings>
```

If `wrap_up.require_commit_confirmation` is true, wait for confirmation. If the
user declines, stop before committing and provide handover notes.

### 5. Commit

```bash
git commit -m "<formatted message>"
```

Record the commit SHA:

```bash
git rev-parse --short HEAD
```

For any later change analysis, use:

```bash
git show --name-status --format= HEAD
```

### 5.5. Update Activity Log and Changelog

If `wrap_up.activity_log.enabled` is true and the activity-log path exists,
prepend a slim narrative entry:

```markdown
## YYYY-MM-DD | <short session title>

**Commit:** <short-sha or none>
**Version:** <suggested or created tag, if relevant>

<One or two short paragraphs: what changed, why, and what remains.>

---
```

If `wrap_up.changelog.enabled` is true, update `wrap_up.changelog.path` before
push/tag. Move `Unreleased` items into a dated release section only when a tag
will actually be created this session.

If either file is changed after the commit, fold it in before push:

```bash
git add -- <log-or-changelog-path>
git commit --amend --no-edit
```

Then refresh the short SHA.

### 5.7. Drift and Manifest Check

Run repo-specific drift checks before pushing or tagging. Use the configured
check if present; otherwise use obvious local scripts only when they exist.

For Shulkerbox-style repos:

```bash
.bloom/shulkerbox/scripts/bin/drift-check 2>/dev/null || scripts/bin/drift-check
```

If drift is found, fix it and amend the commit before push. If it cannot be
fixed in this session, do not tag silently; report the drift as a blocker.

### 6. Push, PR, Merge, Tag

Detect workflow:

```bash
current_branch=$(git branch --show-current)
main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || true)
```

If `main_branch` is empty, use the configured `wrap_up.main_branch`, then `main`,
then `master` if that branch exists.

#### If on Main

If `wrap_up.allow_direct_main` is false, do not push directly. Ask whether to
create a feature branch from the current commit or leave the commit local for
manual handling.

Only if direct-main is explicitly allowed:

```bash
git status --short --branch
```

Show a push/tag checkpoint and wait if `wrap_up.require_push_confirmation` is
true:

```text
Ready to push/tag?
- Branch: <main_branch>
- Commit: <sha>
- Tag: <new tag or none>
- Remote: origin
```

Then:

```bash
git push origin <main_branch>
git tag v<new-version>
git push origin v<new-version>
```

Create tags only after the commit is on the main branch.

#### If on a Feature Branch

Push only after confirmation when required:

```bash
git push origin <current_branch>
```

If `gh` is available, inspect PR state:

```bash
gh pr view --json state,number,url,mergeable,reviewDecision,statusCheckRollup 2>/dev/null || true
```

If no PR exists, ask whether to create one. Use a concise body:

```markdown
## Summary
<brief description>

## Changes
- <key change>

## Verification
- <commands run or not run>
```

If a PR exists, show URL, checks, review state, and mergeability. Ask before
merging. If the user confirms merge:

```bash
gh pr merge --squash --delete-branch
git checkout <main_branch>
git pull --ff-only origin <main_branch>
git tag v<new-version>
git push origin v<new-version>
git branch -d <old-feature-branch> 2>/dev/null || true
git fetch --prune
```

If merge is declined or blocked, do not tag. Report that the suggested version
applies after the PR lands.

### 7. Publish GitHub Release

Skip unless `wrap_up.releases.enabled` is true and a tag was created this
session. Ask before publishing unless repo config explicitly disables that
checkpoint.

```bash
gh release create vX.Y.Z --title "vX.Y.Z" --notes-file <release-notes-file>
```

If the release already exists, report it and continue.

### 8. Capture Learnings

Suggest concrete learnings from mistakes, blockers, or repo-specific patterns
observed this session. Ask the user to confirm which to keep.

- If `wrap_up.learnings.target` is `memory`, write them to the repo's memory
  mechanism if one exists.
- If `wrap_up.learnings.target` is `activity_log`, append them as short
  blockquotes under the activity-log entry.
- If no durable learning location exists, include them in final handover only.

### 9. Prepare Handover

Extract next steps from the session and ask whether to file them.

If `wrap_up.issues.enabled` is true, create GitHub issues with labels under
`wrap_up.issues.label_namespace`.

Otherwise, if `wrap_up.handover.path` exists, prepend:

```markdown
## Handover - YYYY-MM-DD

<one sentence summary>

- [ ] <next step>
```

If no handover path exists, include the handover in the final response.

### 10. Final Report

Report briefly:
- commit SHA, or none
- branch and push status
- PR URL, if created or updated
- tag/release status
- activity log/changelog/handover status
- verification commands run
- remaining next steps

End with: `Session wrapped`.

---

## Git Workflow Conventions

Default convention:
- feature branches off the main branch
- squash merge by PR
- tags created only on main after merge
- no direct push to main unless repo config explicitly allows it
- conventional commits for human-readable history
