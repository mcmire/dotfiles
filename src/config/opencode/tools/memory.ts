import { tool } from "@opencode-ai/plugin";
import path from "path";
import fs from "fs";

const MEMORIES_DIR = path.join(
  process.env.HOME ?? "~",
  ".config/opencode/memories",
);
const AGENTS_MD = path.join(
  process.env.HOME ?? "~",
  ".config/opencode/AGENTS.md",
);

const MAX_LINES = 200;

// ---------------------------------------------------------------------------
// memory_read_topic
// ---------------------------------------------------------------------------

export const read_topic = tool({
  description:
    "Read the full contents of a memory topic file. Call this when the current task " +
    "seems related to a topic listed in the Memory Index of AGENTS.md. Do not call " +
    "this proactively at session start — only fetch detail when it is relevant.",
  args: {
    filename: tool.schema
      .string()
      .describe(
        "Base filename without extension, e.g. 'typescript-patterns'. " +
          "Must match a file listed in the AGENTS.md Memory Index.",
      ),
    namespace: tool.schema
      .enum(["semantic", "procedural"])
      .describe("Subdirectory: 'semantic' for style preferences, 'procedural' for solution patterns."),
  },
  async execute({ filename, namespace }) {
    const filePath = path.join(MEMORIES_DIR, namespace, `${filename}.memory.md`);
    if (!fs.existsSync(filePath)) {
      return `Error: Memory file not found: memories/${namespace}/${filename}.memory.md`;
    }
    return fs.readFileSync(filePath, "utf8");
  },
});

// ---------------------------------------------------------------------------
// memory_update
// ---------------------------------------------------------------------------

export const update = tool({
  description:
    "Write a new memory topic file, or append to an existing one, and update the " +
    "Memory Index in AGENTS.md. Only call this tool after the user has confirmed the " +
    "memory draft presented by /remember — never write memories without confirmation.",
  args: {
    filename: tool.schema
      .string()
      .describe("Base filename without extension, kebab-case, e.g. 'typescript-error-handling'."),
    namespace: tool.schema
      .enum(["semantic", "procedural"])
      .describe("Subdirectory: 'semantic' for style preferences, 'procedural' for solution patterns."),
    title: tool.schema.string().describe("Human-readable title for the memory frontmatter."),
    tags: tool.schema
      .array(tool.schema.string())
      .describe("Array of tag strings for the memory frontmatter."),
    content: tool.schema
      .string()
      .describe(
        "Markdown body of the memory. When appending, this becomes a new dated section " +
          "appended to the existing file.",
      ),
    append_to_existing: tool.schema
      .boolean()
      .describe(
        "If true and the file already exists, append content as a new dated section " +
          "rather than overwriting. If false or the file does not exist, create a new file.",
      ),
    agents_md_summary: tool.schema
      .string()
      .describe(
        "One-line summary for the Memory Index in AGENTS.md, e.g. " +
          "'How to handle TypeScript strict-null errors in React components'.",
      ),
  },
  async execute({ filename, namespace, title, tags, content, append_to_existing, agents_md_summary }) {
    const dir = path.join(MEMORIES_DIR, namespace);
    const filePath = path.join(dir, `${filename}.memory.md`);
    const now = new Date().toISOString();

    // Ensure directory exists
    fs.mkdirSync(dir, { recursive: true });

    const fileExists = fs.existsSync(filePath);

    // 1. Write or append the memory file
    if (append_to_existing && fileExists) {
      // Update `modified` in frontmatter and append a new dated section
      let existing = fs.readFileSync(filePath, "utf8");
      existing = existing.replace(
        /^(modified:\s*).*$/m,
        `$1${now}`,
      );
      if (!/^modified:/m.test(existing)) {
        // Insert modified after created if not present
        existing = existing.replace(
          /^(created:\s*.*)$/m,
          `$1\nmodified: ${now}`,
        );
      }
      const dateLine = now.slice(0, 10); // YYYY-MM-DD
      fs.writeFileSync(filePath, `${existing}\n## ${dateLine}\n\n${content}\n`);
    } else {
      // Create a new file with MIF Level 2 frontmatter
      const id = crypto.randomUUID();
      const frontmatter = [
        "---",
        `id: ${id}`,
        `type: ${namespace === "semantic" ? "semantic" : "procedural"}`,
        `created: ${now}`,
        `modified: ${now}`,
        `namespace: _${namespace === "semantic" ? "semantic/preferences" : "procedural/patterns"}`,
        `title: "${title}"`,
        `tags: [${tags.join(", ")}]`,
        "---",
        "",
      ].join("\n");
      fs.writeFileSync(filePath, `${frontmatter}${content}\n`);
    }

    // 2. Update the Memory Index in AGENTS.md
    const agentsMdResult = updateAgentsMd({ filename, namespace, agents_md_summary });

    const action = append_to_existing && fileExists ? "Appended to" : "Created";
    return [
      `${action}: memories/${namespace}/${filename}.memory.md`,
      agentsMdResult,
    ].join("\n");
  },
});

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function updateAgentsMd({
  filename,
  namespace,
  agents_md_summary,
}: {
  filename: string;
  namespace: string;
  agents_md_summary: string;
}): string {
  if (!fs.existsSync(AGENTS_MD)) {
    return "Warning: AGENTS.md not found — could not update Memory Index.";
  }

  const original = fs.readFileSync(AGENTS_MD, "utf8");
  const entryPattern = new RegExp(
    `^- \\[\\[${escapeRegex(filename)}\\]\\].*$`,
    "m",
  );
  const newEntry = `- [[${filename}]] (${namespace}): ${agents_md_summary}`;

  let updated: string;
  if (entryPattern.test(original)) {
    // Update existing entry in place
    updated = original.replace(entryPattern, newEntry);
  } else {
    // Append new entry before end of file (after last non-empty line in Memory Index)
    updated = original.trimEnd() + "\n" + newEntry + "\n";
  }

  const lineCount = updated.split("\n").length;
  fs.writeFileSync(AGENTS_MD, updated);

  if (lineCount > MAX_LINES) {
    return (
      `Updated AGENTS.md Memory Index (${lineCount} lines). ` +
      `COMPACTION_REQUIRED: AGENTS.md is over the ${MAX_LINES}-line limit. ` +
      `Compact the Memory Index section now (do not touch Personal Rules), ` +
      `then report the final line count to the user.`
    );
  }

  return `Updated AGENTS.md Memory Index (${lineCount} lines).`;
}

function escapeRegex(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}
