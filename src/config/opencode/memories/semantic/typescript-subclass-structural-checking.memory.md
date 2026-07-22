---
id: 2c16e7f4-e463-42aa-90bf-cfe2e97c48ef
type: semantic
created: 2026-07-16T21:18:35.028Z
modified: 2026-07-16T21:18:35.028Z
namespace: _semantic/preferences
title: "Subclassing changes how TypeScript checks assignability (nominal → structural, private fields included)"
tags: [typescript, type-variance, subclassing, assignability, generics, private-fields]
---
## The fact

Whether a generic class value is assignable to (or satisfies a constraint written in terms of) the **same base class at wider type arguments** depends on whether the value is the base class *itself* or a *subclass*:

- A **direct instantiation** of the base class is compared using the class's **own declared variance**. This often succeeds even when the actual type args are narrower than the target's.
- A **subclass** — even an otherwise-empty one — is a *different class*, so TypeScript falls back to a **structural comparison that includes private (`#`) fields**. If a narrow type argument flows into an invariant private field (e.g. a `Map` whose values are functions), it will not be assignable to the base's wide version, and the subclass fails the check.

## Minimal reproduction

```typescript
type Wide = (...args: unknown[]) => void;

class Base<T> {
  // A private field that uses T in an invariant position (Map value = function of T)
  #handlers = new Map<string, (arg: T) => void>();
}

// Empty subclass — adds nothing at all
class Sub<T> extends Base<T> {}

declare function needsWideBase<M extends Base<unknown>>(m: M): void;

declare const base: Base<number>;
declare const sub: Sub<number>;

needsWideBase(base); // ✅ OK — direct instantiation, checked by declared variance
needsWideBase(sub);  // ❌ ERROR — subclass, checked structurally including #handlers:
//   Map<string, (arg: number) => void> is not assignable to
//   Map<string, (arg: unknown) => void>  (contravariance: unknown ⊄ number)
```

The error typically names the **private field** and bottoms out in a parameter-contravariance mismatch (`unknown` is not assignable to `<narrow type>`).

## Why it matters

A constraint like `M extends Base<WideArgs>` will accept direct `Base<...>` instances but may **reject subclasses of `Base`** — surprisingly, even empty subclasses. This is easy to miss when one call site passes the base class (works) and another passes a subclass (fails on a seemingly-unrelated private field).

## The workaround

Don't constrain the type parameter to the base class. Leave it unconstrained and **`infer` the type arguments** via a conditional type:

```typescript
type ExtractArg<M> = M extends Base<infer T> ? T : never;

// Then use ExtractArg<M> instead of constraining M extends Base<...>.
```

Inferring reads the type argument off whatever was passed (base class or subclass) without triggering the private-field structural comparison, so both work.

## How to diagnose

When a "not assignable to constraint" / "does not satisfy the constraint" error names a **private field** (`#something`) of a base class, suspect this behavior. Confirm by testing a plain (non-subclass) instantiation with the same type args — if the base class passes but a subclass of it fails, this is the cause.

## Broader takeaway

TypeScript is mostly structural, but classes with `private`/`#private` members introduce a nominal brand. Subclassing forces a structural fallback that surfaces those private members in assignability checks, so the presence of a subclass (vs. the base class) can flip whether an assignment or constraint succeeds — independent of any public API differences.
