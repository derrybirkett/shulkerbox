# Scope: Stale Placeholders

Detect placeholder text, TODO markers, and stale year references in content and source files.

## Detection

### Step 1 — Pattern grep

Search `content/` MDX files and `content/*/index.ts` files for placeholder markers:

```bash
grep -rn \
  -e "\bTBD\b" \
  -e "\bComing soon\b" \
  -e "placeholder" \
  -e "lorem ipsum" \
  -e "\[TODO" \
  -e "TODO:" \
  content/ --include="*.mdx" --include="*.ts" --include="*.tsx"
```

Also check for stale year markers. Flag year references more than `year_marker_cutoff` years before the current year:

```bash
# Example: current year 2026, cutoff 2: flag years ≤ 2024
grep -rn "\b202[0-3]\b\|\b201[0-9]\b" content/ --include="*.mdx" --include="*.ts"
```

### Step 2 — LLM verification

For each match:

1. **Is `TBD` / `Coming soon` in a frontmatter field that's still actively used?** (e.g., `description: "TBD"`) — genuine placeholder. **Flag.**

2. **Is it in a comment explaining what the code does?** (e.g., `// TODO: handle edge case`) — code-level TODO, not a content placeholder. These are fine; **skip unless in content/*.mdx**.

3. **Is the year marker in a date field vs. inline prose?**
   - Date field with stale year → **flag** (data is wrong)
   - Inline prose reference ("In 2022, we launched...") → **skip** (historical fact, not stale)

4. **Is lorem ipsum in a published content file?** — always flag, regardless of context.

## Threshold

Any confirmed placeholder occurrence qualifies (no minimum count). Confidence is always `high` — placeholders are cheap to verify visually.

## Confidence Calculation

| Condition | Confidence |
|---|---|
| `TBD`, `Coming soon`, `lorem ipsum`, or `placeholder` in content files | high |
| Year marker in a frontmatter date field that is ≥ cutoff years old | high |
| Year marker in historical prose context | skip |
| Code-level `TODO:` comments outside content/ | skip |

## Evidence Format

List each occurrence with file, line, and the matched text:

```
- `content/certs/index.ts:12` — `description: "TBD"` (placeholder in published certification data)
- `content/cases/old-project.mdx:3` — `date: "2023-01-01"` (date field is 3+ years old; case may be stale)
- `content/notes/draft.mdx:45` — `lorem ipsum dolor sit amet` (lorem text in published note)
```

## Suggested Action Template

> `content/certs/index.ts` contains 2 placeholder values (`TBD`) in fields that render on the Certifications page. Replace with real values or hide the certification until content is ready.
