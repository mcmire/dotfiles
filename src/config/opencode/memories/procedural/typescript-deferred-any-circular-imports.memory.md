---
id: 46bdac18-f26b-4a8d-b83a-9a58806c977c
type: procedural
created: 2026-08-05T19:52:41.054Z
modified: 2026-08-05T19:52:41.054Z
namespace: _procedural/patterns
title: "Detecting a "deferred" `any` caused by circular imports (why `IsAny` fails)"
tags: [typescript, any, circular-imports, type-level, IsAny, skipLibCheck]
---
## Problem
A union type built by aggregating many source types (e.g. `A | B | C | ...`) can silently collapse to `any` because `any | X = any`. A single member resolving to `any` poisons the whole union, erasing type safety for every consumer.

This often happens with no visible error when a dependency's shipped `.d.ts` references a namespace member that no longer exists in the installed version (an API rename across a major version). A missing namespace member resolves to `any`, and `skipLibCheck` (used by most prod/lint builds) suppresses the underlying `TS2694`.

## Why the standard `IsAny` fails to detect it
When the `any` is produced *during* an import cycle (module A imports from B, whose transitive imports reference back into A), it is a "deferred" `any` that behaves differently from a plain, fully-resolved `any`.

`IsAny<T> = 0 extends 1 & T ? true : false` is a conditional whose condition depends on the *internal structure* of `T` (`1 & T`). Feeding a deferred `any` into that structural conditional makes the **whole conditional resolve to `any`**, not `true`. Since `any` is assignable to everything, an assertion like `Expect<IsAny<...>, false>` becomes `Expect<any, false>` and passes silently — the `any` launders itself through any structural detector built on top of it, so the guard never fires.

## The reliable fix: whole-type assignability, not structural conditional
```typescript
declare const brand: unique symbol;
type Brand = { readonly [brand]: true };
type CollapsedToAny<Tau> = [Tau] extends [Brand] ? true : false;
```
This uses assignability between two *whole* types (no `1 & Tau` over internal structure), which stays reliable through the cycle: `any` is assignable to the uninhabited `Brand` → yields a real `true` (which `Expect<..., false>` then rejects); a real type is not → `false`. Tuple wrappers `[Tau]`/`[Brand]` also prevent distribution.

Equivalent primitive for a quick check: `const _: never = value` — the only reliable, circular-safe way to detect a deferred `any`, because `any` is NOT assignable to `never` (a plain assignment, not a conditional type).

## How to find which union member is the offender
Build a per-key **object** (NOT a union — a union collapses to `any` and hides the culprit) mapping each source key to whether that member is `any`, wrapping each check in a 1-tuple (`[IsAny<...>]` vs `[false]`) so a bare `any` can't silently satisfy the check. With `noErrorTruncation` on in tsconfig, tsc prints exactly which key is the offender.

## Diagnostic tips
- Isolate one file: create a temp tsconfig extending the root config with `"files": ["<one file>"]`, and bump `--max-old-space-size` (full-project tsc may OOM on large repos).
- To print a resolved type, assign it to `never` (`const _: never = value`) and read the non-truncated error.
