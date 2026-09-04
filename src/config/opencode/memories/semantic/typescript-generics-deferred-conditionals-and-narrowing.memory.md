---
id: ada9f5e8-4fcf-40db-99e0-fe121e26067f
type: semantic
created: 2026-09-04T19:27:12.033Z
modified: 2026-09-04T19:27:12.033Z
namespace: _semantic/preferences
title: "Generic params are unresolved in the body; value-narrowing ≠ type-parameter resolution"
tags: [typescript, generics, conditional-types, type-narrowing, type-assertions]
---
Three related facts about TypeScript generics that together explain why you often must assert inside a generic function body when its return type is a conditional over its type parameters. They're all illustrated by the single `decode` example below.

**Fact 1 — A generic type parameter is unresolved inside the function body.** It's an abstract placeholder, bound to a concrete type only via substitution *at each call site*. The body is checked once, generically, for all callers — so inside the body the parameter is opaque, not "some type waiting to be figured out." This holds even with no conditional types involved.

**Fact 2 — A conditional type over an unresolved parameter is *deferred*.** TypeScript can't choose a branch without knowing the parameter, so the conditional stays opaque, and no concrete value is assignable to it (it would have to be valid for every branch).

**Fact 3 — Value-narrowing and type-parameter resolution are separate, non-unifiable mechanisms.** Control-flow narrowing (the `if (!struct)` below) narrows the static type of a *value* along a branch. It does **not** narrow any *type parameter* (`S` stays whatever the caller chose). These are independent mechanisms — narrowing acts on values, whereas a conditional type depends on a type parameter — so narrowing a value can never re-evaluate a conditional written over a type parameter. The deeper reason they can't be unified is that the value and the type parameter are set independently, by different actors, and can disagree: the caller fixes the type parameter at the call site (by inference or explicit arguments), while a value's runtime state is whatever flows through on a given execution. The `decode<string, Struct<number>>('hello')` call below shows this — `S` is `Struct<number>` even though no struct value is passed and the `if (!struct)` branch runs.

```ts
// A tiny stand-in for a validation library's Struct (e.g. superstruct).
type Struct<Type> = {
  validate: (value: unknown) => Type;
  __type: Type;
};

function decode<
  Input,
  S extends Struct<unknown> | undefined = undefined,
>(
  value: Input,
  struct?: S,
): S extends Struct<infer Decoded> ? Decoded : Input {
  // Restate the return conditional as a local alias so we can assert to it.
  type Result = S extends Struct<infer Decoded> ? Decoded : Input;

  if (!struct) {
    // The VALUE `struct` is narrowed to `undefined` here, but the TYPE PARAMETER
    // `S` is untouched, so `Result` stays the full deferred conditional. Both of
    // these are rejected:
    //   return value;          // ERROR: 'Input' not assignable to deferred conditional
    //   return value as Input; // ERROR: must target the conditional, not one branch
    return value as unknown as Result; // OK: assert to the conditional itself
  }

  return struct.validate(value) as Result;
}

declare const numberStruct: Struct<number>;

const a = decode('x' as string, numberStruct); // a: number  (struct branch, inferred)
const b = decode('x' as string);               // b: string  (default branch)

// The caller binds `S` to `Struct<number>` explicitly but passes NO struct
// value. At runtime `struct` is `undefined` (the `if (!struct)` branch runs),
// yet `S` is `Struct<number>`, so the return type is `number` — decided by the
// type argument, not the runtime value. Value and type parameter disagree.
const c = decode<string, Struct<number>>('hello'); // c: number
```

**Practical upshot:** When a generic function's return type is a conditional over its type parameters, expect to bridge with a type assertion inside the body (`as unknown as Result`, aliasing the exact conditional — asserting to a single branch like `as Input` is rejected). TypeScript cannot relate a concrete value to a deferred conditional; the correspondence is guaranteed by the function's own generics, not something the checker can verify locally.

All code in this memory was compiler-verified with `strict` mode.
