---
id: 113e427b-0083-49e0-8798-a99464df3d86
type: procedural
created: 2026-08-14T16:01:50.025Z
modified: 2026-08-14T16:01:50.025Z
namespace: _procedural/patterns
title: "Version-accurate historical dependency/migration scanning without per-commit installs"
tags: [git-history, npm, ts-morph, ast, metrics, yarn-lock, dependency-analysis]
---
## Problem

You want to measure, across a repo's git history, how a project uses a versioned dependency — e.g. what fraction of "things" (controllers, services, modules, endpoints) have migrated into a shared library vs. still defined locally. The naive approach — checkout each historical commit, `yarn install`, then inspect `node_modules` — is prohibitively slow and fragile for large repos (installs take minutes each, old lockfiles fail to resolve, native toolchains break).

A key subtlety: the library's exported surface **changes per version**, so resolving it once from the latest commit and applying it to all weeks is wrong. Each historical point needs that commit's actual dependency version.

## Solution

Decouple "which version" from "what that version contains", and avoid installs entirely:

1. **Read the pinned version from the lockfile as text.** For each historical commit (checked out via a shallow `--shallow-since` clone), parse the exact version from `yarn.lock` — no install. Support both Yarn Berry (`resolution: "@scope/pkg@npm:1.2.3"`) and Classic (`version "1.2.3"` under a `@scope/pkg@...` header). Absence of the entry (commit predates adoption) yields `null` → count as zero coverage, don't skip.

2. **Fetch just that version's published tarball, cached by version.** `https://registry.npmjs.org/<pkg>/-/<name>-<version>.tgz`, extract with `tar`, cache per version so each distinct version is downloaded once regardless of how many commits pin it. Pipe `fetch` body via `Readable.fromWeb(...)` (the DOM `ReadableStream` needs a type assertion to the Node web-stream type).

3. **Extract the library's effective member set from the tarball with ts-morph.** Critical gotcha: if the member list is a **computed/mapped type** (e.g. `{ [K in keyof Configs as ExtractName<Configs[K]>]: ... }`), its keys are NOT readable as source text and can't be resolved through the type checker either, because that requires the package's external declaration closure (its own `@scope/*` deps), which a bare tarball extract lacks. Instead, **read the literal values from the compiled runtime `.mjs`**: follow the re-export barrel (e.g. `instances/index.mjs`) to each leaf module and read the `name: 'X'` string-literal property directly. Literal values survive compilation even when types don't resolve.

4. **Extract the locally-defined set via AST (ts-morph) of in-repo source.** Parse the client's object literal (found by variable name, or as a named property argument to a call). Collect `PropertyAssignment`/`ShorthandPropertyAssignment`/`MethodDeclaration` names, and **recurse into spread elements**: object-literal spreads, parenthesized expressions, and **both branches of conditional spreads** (`...(flag ? { A } : {})`) so build-flag-gated members are counted. Preprocessor comment gates (e.g. `///: BEGIN:ONLY_INCLUDE_IF(...)`) are just comments to a TS parser, so members between them parse normally.

5. **Union = total; presence-in-library = numerator.** Record one row per distinct member per snapshot with an `isPresentInLibrary` flag. Ratio = present / union. Using the union (not just locally-defined names) means the ratio can reach 100% even after migrated members are removed from the local object.

## ts-morph setup notes

- `new Project({ skipAddingFilesFromTsConfig: true, skipFileDependencyResolution: true, compilerOptions: { allowJs: true, checkJs: false } })` — parse syntax only, independent of the target's dependency graph.
- Search **all** `VariableDeclaration` descendants, not just top-level, since the target may be declared inside a method.
- The ts-morph `Node` export shadows the DOM global `Node`; alias it (`import { Node as AstNode }`) to satisfy `@typescript-eslint/no-shadow`.

## Verification / testing

- Fixture-based tests are the durable ones (small synthetic tarball layout + synthetic client object literals covering spreads/conditionals). Do NOT commit "real clone" integration tests that depend on gitignored local clones — they trip `n/no-sync` (`existsSync`) and `vitest/no-conditional-in-test`, and won't run in CI. Verify against real repos with a throwaway smoke script instead.
