import { Plugin } from "@opencode/plugin";
import * as path from "node:path";
import * as fs from "node:fs";

const MEMORIES_DIR = path.join(
  process.env.HOME ?? "~",
  ".config/opencode/memories",
);
const AGENTS_MD = path.join(
  process.env.HOME ?? "~",
  ".config/opencode/AGENTS.md",
);

const MAX_LINES = 200;

export default Plugin.define({
  id: "personal-memory",
  async setup(ctx) {
    await ctx.tool.transform((editor) => {
      editor.namespace({
        name: "memory",
        description: "Read and update personal memory topics",
      });
      editor.add({
        name: "read_topic",
        description:
          "Read the full contents of a memory topic file. Call this when the current task " +
          "seems related to a topic listed in the Memory Index of AGENTS.md. Do not call " +
          "this proactively at session start — only fetch detail when it is relevant.",
        input: {
          type: "object",
          properties: {
            filename: {
              type: "string",
              description:
                "Base filename without extension, e.g. 'typescript-patterns'. " +
                "Must match a file listed in the AGENTS.md Memory Index.",
            },
            namespace: {
              type: "string",
              enum: ["semantic", "procedural"],
              description:
                "Subdirectory: 'semantic' for style preferences, 'procedural' for solution patterns.",
            },
          },
          required: ["filename", "namespace"],
          additionalProperties: false,
        },
        options: { namespace: "memory" },
        async execute(input) {
          // Type assertion: OpenCode's JSON Schema input type is unknown at compile time.
          const { filename, namespace } = input as {
            filename: string;
            namespace: "semantic" | "procedural";
          };
          const filePath = path.join(MEMORIES_DIR, namespace, `${filename}.memory.md`);
          if (!fs.existsSync(filePath)) {
            return {
              content: `Error: Memory file not found: memories/${namespace}/${filename}.memory.md`,
            };
          }
          return { content: fs.readFileSync(filePath, "utf8") };
        },
      });
      editor.add({
        name: "update",
        description:
          "Write a new memory topic file, or append to an existing one, and update the " +
          "Memory Index in AGENTS.md. Only call this tool after the user has confirmed the " +
          "memory draft presented by /remember — never write memories without confirmation.",
        input: {
          type: "object",
          properties: {
            filename: {
              type: "string",
              description: "Base filename without extension, kebab-case, e.g. 'typescript-error-handling'.",
            },
            namespace: {
              type: "string",
              enum: ["semantic", "procedural"],
              description:
                "Subdirectory: 'semantic' for style preferences, 'procedural' for solution patterns.",
            },
            title: {
              type: "string",
              description: "Human-readable title for the memory frontmatter.",
            },
            tags: {
              type: "array",
              items: { type: "string" },
              description: "Array of tag strings for the memory frontmatter.",
            },
            content: {
              type: "string",
              description:
                "Markdown body of the memory. When appending, this becomes a new dated section " +
                "appended to the existing file.",
            },
            append_to_existing: {
              type: "boolean",
              description:
                "If true and the file already exists, append content as a new dated section " +
                "rather than overwriting. If false or the file does not exist, create a new file.",
            },
            agents_md_summary: {
              type: "string",
              description:
                "One-line summary for the Memory Index in AGENTS.md, e.g. " +
                "'How to handle TypeScript strict-null errors in React components'.",
            },
          },
          required: [
            "filename",
            "namespace",
            "title",
            "tags",
            "content",
            "append_to_existing",
            "agents_md_summary",
          ],
          additionalProperties: false,
        },
        options: { namespace: "memory" },
        async execute(input) {
          // Type assertion: OpenCode's JSON Schema input type is unknown at compile time.
          const {
            filename,
            namespace,
            title,
            tags,
            content,
            append_to_existing,
            agents_md_summary,
          } = input as {
            filename: string;
            namespace: "semantic" | "procedural";
            title: string;
            tags: string[];
            content: string;
            append_to_existing: boolean;
            agents_md_summary: string;
          };
          const dir = path.join(MEMORIES_DIR, namespace);
          const filePath = path.join(dir, `${filename}.memory.md`);
          const now = new Date().toISOString();

          fs.mkdirSync(dir, { recursive: true });

          const fileExists = fs.existsSync(filePath);

          if (append_to_existing && fileExists) {
            let existing = fs.readFileSync(filePath, "utf8");
            existing = existing.replace(/^(modified:\s*).*$/m, `$1${now}`);
            if (!/^modified:/m.test(existing)) {
              existing = existing.replace(/^(created:\s*.*)$/m, `$1\nmodified: ${now}`);
            }
            const dateLine = now.slice(0, 10);
            fs.writeFileSync(filePath, `${existing}\n## ${dateLine}\n\n${content}\n`);
          } else {
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

          const agentsMdResult = updateAgentsMd({ filename, namespace, agents_md_summary });
          const action = append_to_existing && fileExists ? "Appended to" : "Created";
          return {
            content: [`${action}: memories/${namespace}/${filename}.memory.md`, agentsMdResult].join("\n"),
          };
        },
      });
    });
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
