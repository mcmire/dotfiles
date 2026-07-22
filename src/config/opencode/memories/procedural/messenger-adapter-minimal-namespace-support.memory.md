---
id: 630456e1-cfdc-4482-890a-e87e9b3fbed3
type: procedural
created: 2026-07-15T22:10:56.053Z
modified: 2026-07-15T22:10:56.053Z
namespace: _procedural/patterns
title: "Expressing "minimally support these namespaces" for MetaMask Messenger adapters"
tags: [typescript, metamask, messenger, type-variance, react-data-query, base-controller]
---
## Problem

A function or class that accepts a MetaMask `Messenger` and needs it to "minimally support certain namespaces (actions/events), but allow additional namespaces" cannot express that with a structural adapter whose `call` takes an open template literal:

```typescript
// ❌ WRONG — only works by coincidence
type MessengerAdapter<Name extends string> = {
  call(actionType: `${Name}:${string}`, ...params: unknown[]): Promise<unknown>;
};
```

The concrete `Messenger.call` is generic (`call<T extends Action['type']>`), bounded by its *declared literal* action union. A target demanding an open `` `${Name}:${string}` `` template is *wider* than the messenger's declared literals, so (by parameter contravariance) it's unsatisfiable. It only passes when *every* action the messenger declares happens to fall inside the requested namespaces; adding any unrelated namespace breaks it. `Messenger` is also invariant in its Action/Event params (private `#actions`/`#events` maps), so a superset messenger is not directly assignable to a subset one either.

## Canonical solution (matches `BaseController`)

Make the function/class generic over the concrete messenger type (constrained to a loose messenger), then use a capability-check conditional that verifies the required action/event **type strings** are members of the messenger's own unions — extracted with the exported `MessengerActions`/`MessengerEvents` helpers from `@metamask/messenger`. Resolve to the messenger type on success, `never` on failure.

```typescript
import type {
  ActionConstraint,
  EventConstraint,
  Messenger,
  MessengerActions,
  MessengerEvents,
} from '@metamask/messenger';

type LooseMessenger = Messenger<
  string,
  ActionConstraint,
  EventConstraint,
  // Use `any` for the parent so any messenger, delegated or not, is accepted.
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  any
>;

type SupportsDataServices<
  MessengerType extends LooseMessenger,
  Name extends string,
> = DataServiceInvalidateQueriesAction<Name>['type'] extends MessengerActions<MessengerType>['type']
  ? DataServiceGranularCacheUpdatedEvent<Name>['type'] extends MessengerEvents<MessengerType>['type']
    ? MessengerType   // pass: parameter resolves to the messenger itself
    : never           // reject
  : never;

function createUIQueryClient<
  Names extends readonly string[],
  MessengerType extends LooseMessenger,
>(
  dataServices: Names,
  rawMessenger: SupportsDataServices<MessengerType, Names[number]>,
): QueryClient { ... }
```

Key details:
- Prefer the `MessengerActions<M>['type']` / `MessengerEvents<M>['type']` helpers over a hand-rolled `infer Action extends ActionConstraint`. They are the house-style extractors (themselves just `infer`-based) and keep the code aligned with `BaseController`.
- Resolve the capability check to `MessengerType` (pass) or `never` (reject) directly on the parameter. This is cleaner than an earlier draft that resolved to `unknown`/`never` and intersected `MessengerType & Supports<...>`.
- Inside the body, view the messenger through a narrow structural adapter via one localized, commented `as unknown as` bridge, since the messenger's generic methods can't express the runtime-built template-literal action/event strings (e.g. `` `${service}:invalidateQueries` ``). The capability check already proved support, so the assertion is safe. `BaseController` does exactly this (see its `#messenger` assignment and the comment: "The parameter type validates that the expected actions/events are present. We don't have a way to validate the type property because the type is invariant.").

## Gotchas

- The authoritative typecheck is the `tsconfig.type-tests.json` runner (uses `skipLibCheck`). Running raw `tsc` directly against the package `tsconfig.json` surfaces unrelated `@types/node` lib-check noise that can degrade type resolution and produce misleading "unused @ts-expect-error" results. Trust the type-test config / `yarn build` instead.
- Validate the negative case with `@ts-expect-error`: if the constraint regresses and widens, the now-unused directive makes `tsc` fail.

## References

- `packages/base-controller/src/BaseController.ts` — the CANONICAL pattern. See the nested conditional on the `messenger` constructor option (approx. lines 248-263) and the `as unknown as` bridge + comment (approx. lines 268-274).
- `packages/react-data-query/src/createUIQueryClient.ts` — a second application of the same pattern.
- `packages/react-data-query/src/createUIQueryClient.type-test.ts` — positive case with an extra namespace + negative `@ts-expect-error` case.
