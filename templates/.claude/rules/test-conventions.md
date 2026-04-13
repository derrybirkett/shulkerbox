---
paths: ["**/*.test.ts", "**/*.test.tsx", "**/*.spec.ts", "**/*.spec.tsx"]
---

# Test File Conventions

These rules apply only when working with test files.

## Structure

Use `describe`/`it` blocks for organization:

```typescript
describe('ComponentName', () => {
  it('should handle the happy path', () => {
    // Test implementation
  });

  it('should handle edge cases', () => {
    // Test implementation
  });
});
```

## Naming

- Test files: `ComponentName.test.ts` or `ComponentName.spec.ts`
- Describe blocks: Component or function name
- It blocks: "should [expected behavior]"

## Best Practices

- **Arrange, Act, Assert** pattern
- Mock external dependencies
- Test behavior, not implementation
- One assertion per test (when practical)
- Clean up after each test

## Coverage

- New features require tests
- Bug fixes require regression tests
- [Your coverage thresholds, if any]

## Don't

- ❌ Don't test implementation details
- ❌ Don't share mutable state between tests
- ❌ Don't write tests that depend on execution order
