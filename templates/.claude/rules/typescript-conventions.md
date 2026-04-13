---
paths: ["**/*.ts", "**/*.tsx"]
---

# TypeScript Conventions

These rules apply when working with TypeScript files.

## Type Safety

- Use explicit types for function parameters and return values
- Avoid `any` - use `unknown` if type is truly unknown
- Prefer interfaces for object shapes, types for unions/intersections

## Naming

- Interfaces: `PascalCase` (e.g., `UserProfile`)
- Types: `PascalCase` (e.g., `ApiResponse`)
- Enums: `PascalCase` (e.g., `UserRole`)
- Type parameters: Single capital letter or `PascalCase` (e.g., `T` or `TData`)

## Best Practices

- Use strict mode (`"strict": true` in tsconfig.json)
- Leverage type inference where clear
- Use `const` assertions for literal types
- Prefer `readonly` for immutable data

## Common Patterns

```typescript
// Prefer this
interface Props {
  name: string;
  age: number;
}

// Over this
type Props = {
  name: string;
  age: number;
}
```

## Don't

- ❌ Don't use `any` without a comment explaining why
- ❌ Don't ignore TypeScript errors with `@ts-ignore` unless absolutely necessary
- ❌ Don't over-engineer types - keep them readable
