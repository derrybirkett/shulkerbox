---
name: build-product
description: Alias for /product. Drive a seed idea through the full Bloom loop — define, architect, scaffold, build, review.
user-invocable: true
argument-hint: "[run|resume|status|next-slice] \"your seed idea\""
metadata:
  tags: [bloom, product, build, alias]
  category: core
  audience: core
  alias-of: product
---

# Build Product

Alias for [`/product`](../product/SKILL.md). Same arguments, same behavior.

## Trigger

```
/build-product "<seed>"
/build-product run "<seed>"
/build-product resume
/build-product status
/build-product next-slice
```

## Action

Delegate immediately to the `/product` skill. Pass all arguments through verbatim. Do not duplicate any logic — the canonical definition lives in [`skills/core/product/SKILL.md`](../product/SKILL.md), which itself dispatches to [`agents/product/AGENT.md`](../../../agents/product/AGENT.md).

If `/product` is not available for any reason, fall back to reading and executing [`agents/product/AGENT.md`](../../../agents/product/AGENT.md) directly.

## Why this exists

`/build-product` is explicit about the outcome ("build a product") rather than the actor ("the product agent"). Useful in repos where `/product` might collide with another tool's command namespace. Same engine underneath.
