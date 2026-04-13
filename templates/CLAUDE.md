# Project Name

Brief description of what this project does and its purpose.

## Build Commands

```bash
# Install dependencies
npm install  # or: pnpm install, yarn install

# Development
npm run dev

# Build
npm run build

# Test
npm test

# Lint
npm run lint
```

## Conventions

### Commits
- Use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`
- Present tense, lowercase, no trailing period
- One logical change per commit

### Code Style
- [Your formatting rules - or defer to automated tools]
- [Naming conventions]
- [File organization patterns]

### Testing
- Write tests for new features
- Run tests before committing
- [Coverage requirements, if any]

## Architecture

### Directory Structure
```
src/
  components/    # React components (or your structure)
  utils/         # Utility functions
  types/         # TypeScript type definitions
```

### Key Patterns
- [Important architectural decisions]
- [Design patterns in use]
- [Data flow conventions]

## Never

- ❌ Don't commit directly to `main` - use PRs
- ❌ Don't skip tests
- ❌ Don't commit secrets or credentials
- ❌ [Project-specific anti-patterns]

## Dependencies

### Adding packages
```bash
npm install package-name
# Document why major dependencies were added
```

### Updating packages
- Review changelogs before upgrading
- Test thoroughly after major version bumps

## Resources

- Documentation: [link]
- API Reference: [link]
- Design System: [link]

---

**Keep this under 200 lines.** Move reference material to skills in `.claude/skills/`.
For path-specific rules (like test conventions), use `.claude/rules/` files.
