# Personal Rules

<!-- OpenCode must never modify this section automatically. -->

## Writing English

- Choose alternatives for the following words and phrases, which are uncommon:
  - "watermark"

### English writing guidelines

Apply these guidelines when generating or editing English prose, such as documentation, decision records, comments, commit messages, and other written artifacts.

- Write like a thoughtful engineer explaining something to another engineer: conversational, precise, and restrained.
- Prefer plain, familiar words over inflated or corporate language. Avoid phrases such as "seamless," "robust," "leverage," "delve into," "it's worth noting," and "I hope this helps" unless they add specific meaning.
- Be direct. Do not begin with a greeting, an acknowledgement, a restatement of the request, or a description of what you are about to do.
- Explain causes and tradeoffs, not just conclusions. When describing a change, distinguish the current situation, the problem it creates, the proposed solution, and any remaining limitations.
- Use concrete examples when they make an abstract point easier to understand. Prefer one useful example over several contrived ones.
- Use contractions naturally (for example, "I've," "doesn't," and "it's") in conversational prose.
- Use first person when describing an experience, decisions, or opinions. Do not manufacture personal experience, certainty, or emotion.
- Make uncertainty explicit. Distinguish facts, inferences, assumptions, and recommendations instead of presenting all of them with the same level of confidence.
- Keep paragraphs focused. Give each paragraph one main idea, and use headings or lists when they improve navigation rather than to impose a template.
- Favor a logical narrative flow: introduce the context, explain what changed or what was learned, then describe the implications. Use transitions sparingly and avoid repetitive summaries.
- Avoid unnecessary qualifiers and hedging, but preserve nuance where it affects the conclusion. Say "This may cause..." when the outcome is genuinely uncertain, and say "This causes..." when it is not.
- For technical writing, name exact APIs, files, versions, and behaviors. Put code, commands, identifiers, and literal values in backticks. Do not replace precise terms with vague descriptions.
- For change descriptions and decision records, explain why the change is needed before describing implementation details. Call out consumer impact, migration steps, and compatibility risks explicitly.
- Do not over-format. Use Markdown emphasis, block quotes, tables, and nested lists only when they clarify the content. Avoid decorative headings and canned sections.
- Edit for clarity and rhythm, not maximal formality. Sentence lengths may vary, but remove repetition, awkward abstractions, and sentences that carry more than one unrelated idea.

## Writing code

<!-- Add your JavaScript/TypeScript and general code style preferences here. -->

### General development workflow

- Always test your work to make sure that it passes the user's intentions. Unit tests are preferred, but any kinds of tests will do.
  - If you find yourself creating smoke tests in temporary files, stop and consider adding real files so that the behavior being added or the fix being made won't break in the future.
- Always write tests first, watch them fail, then implement the code to make them pass. (See "General testing guidelines" for more.)
- When you complete a task and reach a point where you would print a summary of changes to the user, create a commit.

### General code guidelines

- If you find that you need to use a comment to explain a section of code, that is a code smell and you probably want to split that code off into a separate function.
- Don't allow functions to grow out of control and do too many things. Same goes for React components.
- Before implementing a task you think will be complex, search the web to see if anyone else has solved the presented problems before and come up with any existing solutions. Search for existing packages, GitHub gists, blog posts, etc.
- Name functions verbs or verb phrases, never nouns or noun phrases (e.g., use `replaceBrackets` instead of `bracketReplacement`).
- When writing documentation blocks for symbols (e.g. JSDoc, PyDoc, etc.), use the first line to summarize what the symbol represents or does, but then use the remaining paragraphs (short of tags) to explain the reason that the symbol exists and how it's used. Don't describe implementation details in a JSDoc block; that's what inline comments are for.
- When naming variables, never use a past tense verb (e.g. `collected`) unless the variable represents a boolean.
- When naming variables, recognize and reuse full names of concepts instead of abbreviating them when possible. For instance:
  - Don't shorten `messengerClientIdentification` to `identification`
  - Don't shorten `networkConfiguration` to `networkConfig` or `config`
  - Don't shorten `context` to `ctx`
  - Don't shorten `transaction` to `tx`
  The only cases in which it's acceptable to use an abbrevation is `i` for `index`, but only do so if it's the only argument to a function.

### General testing guidelines

- When writing tests, if you need to define test helpers in the same file, place them below all tests. (But if you need to define types, place them at the top of the file.)
- When writing a test, mentally break it up into three stages: "arrange", "act", and "assert". Always use empty lines to divide them.
- Prefer testing one clear behavior per test. This doesn't necessarily mean making one assertion per test. Use the test name as a guide; if you find you are saying "it does this thing AND it does that" or "it does this thing AND NOT that", then divide the test into two.
- If a function isn't exported, don't export it just so you can test it. Test it indirectly through something else that's already exported.
- Don't test constants or variables that return static values (strings, numbers, etc.). Only test logic, which would only be contained in functions or methods.
- If data that is set up in a test matters to the test — i.e., if it's referenced directly or indirectly in an assertion — then state it explicitly in the test itself, do not define it in a test helper which is shared by other tests.
  ``` typescript
  // ❌ BAD
  it('parses wallet-library migration rows', () => {
    const metrics = parseMetricsData(createPersistedMetrics());

    expect(metrics.walletLibraryMigrations[0]).toStrictEqual({
      id: 'MetaMask/metamask-extension:AccountsController:2026-01-01',
      repository: 'MetaMask/metamask-extension',
      createdAt: new Date('2026-01-01T00:00:00.000Z'),
      occurredAt: new Date('2026-01-01T00:00:00.000Z'),
      messengerClientName: 'AccountsController',
      isPresentInWalletLibrary: true,
      commitSha: 'abc123',
      walletLibraryVersion: '10.0.0',
    });
  });

  function createPersistedMetrics(): PersistedMetricsFixture {
    return {
      // ...
      walletLibraryMigrations: [
        {
          id: 'MetaMask/metamask-extension:AccountsController:2026-01-01',
          repository: 'MetaMask/metamask-extension',
          createdAt: '2026-01-01T00:00:00.000Z',
          occurredAt: '2026-01-01T00:00:00.000Z',
          messengerClientName: 'AccountsController',
          isPresentInWalletLibrary: true,
          commitSha: 'abc123',
          walletLibraryVersion: '10.0.0',
        },
      ],
    }
  }

  // ✅ GOOD
  it('parses wallet-library migration rows', () => {
    const metrics = parseMetricsData(
      createPersistedMetrics({
        id: 'MetaMask/metamask-extension:AccountsController:2026-01-01',
        repository: 'MetaMask/metamask-extension',
        createdAt: '2026-01-01T00:00:00.000Z',
        occurredAt: '2026-01-01T00:00:00.000Z',
        messengerClientName: 'AccountsController',
        isPresentInWalletLibrary: true,
        commitSha: 'abc123',
        walletLibraryVersion: '10.0.0',
      })
    );

    expect(metrics.walletLibraryMigrations[0]).toStrictEqual({
      id: 'MetaMask/metamask-extension:AccountsController:2026-01-01',
      repository: 'MetaMask/metamask-extension',
      createdAt: new Date('2026-01-01T00:00:00.000Z'),
      occurredAt: new Date('2026-01-01T00:00:00.000Z'),
      messengerClientName: 'AccountsController',
      isPresentInWalletLibrary: true,
      commitSha: 'abc123',
      walletLibraryVersion: '10.0.0',
    });
  });

  function createPersistedMetrics(overrides?: Partial<PersistedMetricsFixture> = {}): PersistedMetricsFixture {
    const defaults = {
      // ...
      walletLibraryMigrations: [],
    };
    return { ...defaults, ...overrides };
  }
  ```
- When writing tests for a file, prefer to not mock functions or methods that are imported from another file. Only choose to mock imported functions/methods if they make requests or execute shell commands, or if it would be too complex not to mock them.

### GitHub Actions

- When using a public action (e.g. `actions/checkout`, `actions/setup-node`, etc.) make sure to use the latest version, unless there is a good reason not to do so (e.g. organization requires that certain actions be pinned).

### JavaScript/TypeScript

- Use braces to surround the body of an `if` statement, even if it could fit on one line.
- Always define constants and types at the top of the file (in that order).
- When defining named functions, especially those at the top level, always use `function`, never use `const` + arrow functions. (Use arrow functions for methods like `map`, `reduce`, etc.)
- When writing scripts:
  - Always define the `main` function first, and then define supporting functions in reverse order below that (for instance, if `main` calls `foo`, and `foo` calls `bar`, then the order would be `main`, `foo`, `bar`).
  - If the file is executable, add a shebang at the top (`#!/usr/bin/env yarn tsx` if it is present in `package.json`, `#!/usr/bin/env node` otherwise) and include this above the main function:
    ```typescript
    // Run the script.
    main().catch((error) => {
      error.exitCode = 1;
    });
    ```
    - Always use `yargs` to parse command-line options, never parse them by hand. Set up Yargs such that `--help` (or `-h`) works. Add a brief summary for each option and one or two examples.
- Import Node's `path` module using a wildcard import (`import * as ...`, not `import { ... } as ...`).
- Provide JSDoc when defining types, interfaces, properties of types/interfaces, functions, classes, and top-level variables (constants). Use the first line to summarize what the symbol represents or does, but then use the remaining paragraphs (short of tags) to explain the reason that the symbol exists and how it's used.
- Use the "long" block comment when providing JSDoc, not the "short" block comment. This particularly applies to properties of types/interfaces. In other words:
  ```typescript
  type Foo = {
    // ✅ GOOD
    /**
     * The bar.
     */
    bar: number;
  }
  ```
  not this:
  ```typescript
  type Foo = {
    // ❌ BAD
    /** The bar. */
    bar: number;
  }
  ```
- Prefer using arrow functions (`() => { ... }`) over function expressions (`function () { ... }`), particularly when passing functions to other functions (e.g. `it` / `test` in test files). Only use `function () { ... }` if you need a function whose `this` needs to be rebound.
- When adding or modifying a function or method so that it takes more than three arguments, convert the arguments to an options bag rather than use positional arguments.
- When using Vitest, prefer `it` over `test`.
- When adding a dependency to a project, make sure to add the latest version of the package, unless there is a specific reason not to do so (e.g. project requires CommonJS but package is only ESM-compatible).
- When writing or updating tests, check to see if the test harness has been configured to automatically reset mocks, and if so, then do not call `jest.resetAllMocks`/`jest.restoreAllMocks` or `vi.clearAllMocks`/`vi.restoreAllMocks` (or some variation of this) in `beforeEach`/`afterEach` hooks.
- Don't use `await` to call an asynchronous function/method and then act on the result within the same statement. Make the asynchronous call in one statement and then act on the result in another.
- When calling an asynchronous function/method but *not* using `await` but rather capturing the promise, call the variable `promiseFor${nameOfAction` (e.g. `promiseForScanning`, `promiseForFetching`, etc.).
- TypeScript: Don't use type assertions (`as ...`) or non-null assertions (`foo!`) unless absolutely necessary. If you do need to use either, add a comment above the line such as `Type assertion: <Reason>` or `Non-null assertion: <Reason>`.
- TypeScript: Instead of using type annotations, have TypeScript infer the type as much as possible. Use `as const` for statically defined data. If you really need to use a type annotation, try using `satisfies` instead.
  - The only exception to this rule is return types on functions/methods — type annotations are acceptable there (and even required for some projects).
- TypeScript: Don't extract function/method argument types or return types by default; wait until we get to a point where we need to use the type in more than one place.
- TypeScript: Don't use the `private` keyword, use ES private fields instead. 

## Shell Scripting

- Always run `shellcheck` after updating a Bash script.
- Use `if` statements for conditional logic, not `&&` or `||` shorthand.

---

# Memory Index

<!-- This section is maintained automatically by the memory_update tool via /remember. -->
<!-- Keep the total file under 200 lines. If this section grows large, memory_update will -->
<!-- compact it automatically. If the file still exceeds 200 lines after compaction, you -->
<!-- will be warned — OpenCode will never touch the Personal Rules section above. -->

## How to use memories

When a task relates to a topic listed below, call `memory_read_topic` with the filename and namespace to load the full detail before proceeding.

After completing a non-trivial task — especially debugging, a workaround, or a non-obvious decision — suggest running `/remember` to preserve the solution.

## Known topic files

<!-- memory_update appends entries here in the format: -->
<!-- - [[filename]] (namespace): one-line summary -->
- [[messenger-adapter-minimal-namespace-support]] (procedural): How to type a function/class that requires a MetaMask Messenger to minimally support certain namespaces while allowing extra ones (canonical BaseController capability-check pattern, not open-template structural adapter)
- [[typescript-subclass-structural-checking]] (semantic): Why a subclass of a generic base class can fail an `extends BaseClass<...wide args...>` constraint that the base class itself passes (structural check on private fields), and how to work around it by inferring type args instead of constraining
- [[typescript-deferred-any-circular-imports]] (procedural): How to detect a "deferred" `any` from circular imports (a union collapsing to `any`), why structural `IsAny` (`0 extends 1 & T`) fails on it, and the `[T] extends [Brand]` assignability fix plus per-key-object diagnostic.
- [[sqlite-in-git-for-metrics]] (procedural): How to store a small structured dataset as SQLite committed to Git, feeding a browser dashboard
- [[version-accurate-historical-dependency-scanning]] (procedural): Scan a dependency's API across git history version-accurately without per-commit installs
