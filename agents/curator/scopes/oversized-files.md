# Scope: Oversized Files

Detect files that have grown large enough that they likely contain multiple separable concerns and would benefit from splitting.

## Detection

### Step 1 — Line and symbol count

For each file in the scan paths:

```bash
# Line count
wc -l lib/**/*.ts components/**/*.tsx app/**/*.tsx 2>/dev/null

# Export count (rough symbol count)
grep -c "^export " "$file" 2>/dev/null
```

Flag files where:
- **Line count > `line_threshold`** (default: 400) AND
- **Exported symbol count > `symbol_threshold`** (default: 5)

Both conditions must be true. A 600-line file with 2 exports is probably a large config or data file — not a splitting candidate.

### Step 2 — LLM verification

For each candidate, read the file and assess:

1. **Framework-shaped file?** — Next.js page files (`app/**/page.tsx`, `app/**/layout.tsx`) legitimately combine route logic. A 500-line page is not necessarily a splitting candidate. **Lower confidence if framework-shaped.**

2. **Do exports cluster into distinct concerns?** — Read the exports and ask: could these be split into 2+ coherent modules with no circular deps?
   - Yes, cleanly separable → **high** confidence
   - Possible but requires refactor judgment → **med** confidence
   - One unified concern, just large → **low** confidence (skip)

3. **Is it a data/config file?** — A file with 500 lines of constant arrays or config objects is intentionally large. **Skip.**

## Threshold

File an issue only if both conditions are met AND LLM rates confidence as `high` or `med`.

## Confidence Calculation

| Condition | Confidence |
|---|---|
| Exports cluster into 2+ distinct, cleanly separable concerns | high |
| File is large and mixed, splitting possible but requires judgment | med |
| One concern, framework-shaped, or data/config file | low (skip) |

## Evidence Format

List the file stats and the distinct concern clusters identified:

```
- `components/work/CaseStudyPage.tsx` — 520 lines, 8 exports
  Cluster A (prose rendering): ProseImage, TodoParagraph, MDX_COMPONENTS
  Cluster B (page structure): CaseStudyPage, GatedCase, CaseMeta
  Cluster C (navigation): NextCaseNav, CaseOutcomes
```

## Suggested Action Template

> `components/work/CaseStudyPage.tsx` is 520 lines with 8 exports that appear to split into 3 separable concerns: prose rendering components, page structure, and navigation fragments. Consider extracting each cluster into its own file to reduce cognitive load and improve testability.
