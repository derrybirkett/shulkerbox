# Scope: Dead Exports

Detect exported symbols (functions, types, constants, classes, components) that have no references anywhere else in the codebase.

## Detection

### Step 1 — Automated scan

Run `ts-prune` (or equivalent static analysis) on the TypeScript codebase:

```bash
npx ts-prune --ignore "(test|spec|__tests__|\.d\.ts)" 2>/dev/null
```

This produces a list of exported symbols with no detected imports.

If `ts-prune` is not available, use `grep` to find exported symbols and cross-reference with `grep -r` for usages:

```bash
# Find all exports
grep -rn "^export " lib/ components/ app/ --include="*.ts" --include="*.tsx" | grep -v "^export default" | grep -v "^export \*"
```

### Step 2 — LLM verification

For each candidate from Step 1, verify by reading the file and checking:

1. **Is it a Next.js framework export?** (e.g., `export default function Page`, `export const metadata`, `export async function generateStaticParams`, `export async function generateMetadata`) — these are consumed by Next.js at build time, not imported by user code. **Skip these.**

2. **Is it an MDX-served export?** (e.g., components exported for use in MDX files via `components` prop in `MDXRemote`) — these may not have static import references. **Skip these.**

3. **Is it a re-export barrel?** (e.g., `export { Foo } from './foo'`) — the barrel itself may look unused if callers import from the barrel. Check if the barrel is imported somewhere. **Skip the symbol, but flag if the whole barrel is unused.**

4. **Is there a dynamic import or string-based reference?** (e.g., `require(somePath)`, JSX components constructed from strings) — automated tools miss these. **Skip if dynamic usage is plausible.**

5. **Does it still have no valid import after all checks?** — this is a genuine dead export.

## Threshold

File an issue only if:
- **≥3 unused exports in a single file** (after LLM filtering)
- OR **1-2 unused exports but all are confidence: high**

## Confidence Calculation

| Condition | Confidence |
|---|---|
| LLM agrees all flagged exports are unused, no framework/MDX exceptions apply | high |
| LLM filtered some results but ≥3 still qualify | med |
| LLM filtered most results, <3 remain, or dynamic imports possible | low |

## Evidence Format

List each unused export:

```
- `lib/portfolio/utils.ts:42` — `formatCaseDate` (no imports found; not a framework or MDX export)
- `lib/portfolio/utils.ts:58` — `CaseStatus` (TypeScript type, zero references in .ts/.tsx files)
- `lib/portfolio/utils.ts:71` — `buildSlug` (exported function, no usages in scan paths)
```

## Suggested Action Template

> `lib/portfolio/utils.ts` exports 4 symbols that appear to have no callers within the scanned paths. Consider removing or inlining them. If any are consumed by routes not in the scan paths, add those paths to `curator/config.yml` scan_paths.
