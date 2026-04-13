# Path-Specific Rules

Rules in this directory only load when Claude works with files matching their `paths` frontmatter.

## Benefits

- **Save context**: Rules don't load unless needed
- **Targeted guidance**: Specific rules for specific file types
- **Keep CLAUDE.md focused**: Move path-specific details here

## Format

```markdown
---
paths: ["**/*.test.ts", "**/*.tsx"]
---

# Rule Name

Rules content here...
```

## Path Patterns

Use glob patterns:
- `**/*.ts` - All TypeScript files
- `src/**/*.tsx` - TSX files in src/
- `**/*.test.*` - All test files
- `components/**/*` - Everything in components/

## Examples

- `test-conventions.md` - Loads for test files only
- `typescript-conventions.md` - Loads for TypeScript files only
- `api-conventions.md` - Could load for files in `api/` directory

## When to Use

Move content from CLAUDE.md to rules when:
- It applies to specific file types or directories
- It would clutter CLAUDE.md
- It's detailed (more than a few lines)

## Keep CLAUDE.md For

- Project-wide conventions
- Build commands
- "Never do X" rules
- Core architecture

---

**Learn more**: See [Claude Code rules documentation](https://code.claude.com/docs/en/memory#path-specific-rules)
