---
description: Save a memory from the current conversation
---

Review the current conversation and identify the key insight, pattern, or solution worth
preserving as a memory. $ARGUMENTS may provide a hint about the topic — use it to guide
what to extract.

Follow these steps exactly and do not skip any:

## Step 1 — Identify the memory

Determine what is worth saving. Good candidates:
- A non-obvious debugging solution or workaround
- A decision with reasoning that would be useful to recall
- A pattern or technique discovered during this conversation
- A preference the user expressed that should be applied in future sessions

If nothing in the conversation is worth preserving, say so and stop.

## Step 2 — Choose a target file

List the existing files in `~/.config/opencode/memories/procedural/` using the Bash tool:

```
ls ~/.config/opencode/memories/procedural/
```

Present the list to the user and ask:

> Should this be saved as a **new memory file**, or **appended to an existing one**?
> Existing files: [list the .memory.md files, or "none yet" if the directory is empty]

Wait for the user's answer before continuing.

## Step 3 — Draft the memory entry

Based on the user's choice, draft the following and present it clearly for review:

- **filename**: kebab-case, no extension (e.g. `typescript-null-errors`)
- **namespace**: almost always `procedural` for `/remember`; use `semantic` only for
  style preferences the user explicitly wants to store
- **title**: short human-readable title
- **tags**: array of relevant tags
- **content**: the full memory body in Markdown — be specific and concrete; include
  context, the problem, the solution, and any caveats
- **append_to_existing**: `true` if appending to an existing file, `false` if creating new
- **agents_md_summary**: a single line (under 80 chars) summarising this memory for the
  index in AGENTS.md

Present the draft like this:

---
**Proposed memory** (`memories/<namespace>/<filename>.memory.md`):

**Title:** <title>
**Tags:** <tags>
**Summary for index:** <agents_md_summary>

**Content:**
<content>
---

## Step 4 — Confirm

Ask:

> Does this look right? Reply **yes** to save, or tell me what to change.

Wait for confirmation. If the user requests changes, revise the draft and show it again.
Do not call any tools until the user confirms with "yes" or equivalent.

## Step 5 — Save

Once confirmed, call `memory_update` with all the drafted arguments.

### If the result contains `COMPACTION_REQUIRED`:

The memory has been saved, but AGENTS.md is now over the 200-line limit. Compact the
Memory Index automatically — do not ask the user for permission:

1. Read `~/.config/opencode/AGENTS.md` in full.
2. Locate the `# Memory Index` section. The `# Personal Rules` section above it must
   not be touched at all — preserve it exactly, character for character.
3. Rewrite the Memory Index entry list so that all topic file references are preserved
   but summaries are shorter or related entries are merged. The goal is to bring the
   total file under 200 lines while losing as little meaning as possible.
4. Write the updated AGENTS.md back using the `write` built-in tool.

If AGENTS.md is still over 200 lines after compaction, warn the user:

> AGENTS.md is still over 200 lines after compacting the Memory Index. Your Personal
> Rules section may be the cause — OpenCode will not modify it. Please review it manually.

### Normal result

Report the path written and the updated AGENTS.md line count to the user.
