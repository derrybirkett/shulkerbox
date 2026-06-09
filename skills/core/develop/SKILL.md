---
name: develop
description: Alias for /product. Drive a seed idea through the full Bloom loop — define, architect, scaffold, build, review.
user-invocable: true
argument-hint: "[run|resume|status|next-slice] \"your seed idea\""
metadata:
  tags: [bloom, product, develop, alias]
  category: core
  audience: core
  alias-of: product
---

# Develop

Alias for [`/product`](../product/SKILL.md). Same arguments, same behavior.

## Trigger

```
/develop "<seed>"
/develop run "<seed>"
/develop resume
/develop status
/develop next-slice
```

## Action

Delegate immediately to the `/product` skill. Pass all arguments through verbatim. Do not duplicate any logic — the canonical definition lives in [`skills/core/product/SKILL.md`](../product/SKILL.md), which itself dispatches to [`agents/product/AGENT.md`](../../../agents/product/AGENT.md).

If `/product` is not available for any reason, fall back to reading and executing [`agents/product/AGENT.md`](../../../agents/product/AGENT.md) directly.

## Why this exists

`/develop` reads more naturally than `/product` when the user is framing the work as a verb ("develop my idea") rather than a noun ("build a product"). Same engine underneath.
