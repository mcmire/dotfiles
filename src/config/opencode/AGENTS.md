# Personal Rules

<!-- OpenCode must never modify this section automatically. -->

## Code Style

<!-- Add your JavaScript/TypeScript and general code style preferences here. -->

### JavaScript/TypeScript

- Use braces to surround the body of an `if` statement, even if it could fit on one line.
- Always define types and constants at the top of the file (in that order).
- Always use `function` to define named functions, never use arrow functions (unless the function needs access to `this`).
- When writing scripts:
  - Always define the `main` function first, and then define supporting functions in reverse order below that.
  - If the file is executable, add a shebang at the top (`#!/usr/bin/env yarn tsx` if it is present in `package.json`, `#!/usr/bin/env node` otherwise) and include this above the main function:
    ```typescript
    // Run the script.
    main().catch((error) => {
      error.exitCode = 1;
    });
    ```
- Always use `yargs` to parse command-line options, never parse them by hand. Set up Yargs such that `--help` (or `-h`) works. Add a brief summary for each option and one or two examples.
- Import Node's `path` module using a wildcard import (`import * as ...`, not `import { ... } as ...`).
- Provide JSDoc when defining types, interfaces, properties of types/interfaces, functions, classes, and top-level variables (constants). Explain why the symbol exists and where it is used.
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

## Shell Scripting

- Always run `shellcheck` after updating a Bash script.

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
