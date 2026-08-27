/**
 * Authoring status report.
 *
 *   npm run status            # summary + concepts still to do, by priority
 *   npm run status -- --all   # every concept
 *
 * Reads the level files directly rather than the compiled collection, so it
 * works without a build.
 */

import * as fs from "node:fs";
import * as path from "node:path";
import YAML from "yaml";

const CONTENT = path.join(process.cwd(), "content", "concepts");
const showAll = process.argv.includes("--all");

type Row = {
  id: string;
  domain: string;
  importance: number;
  levels: Record<number, string>;
};

const rows: Row[] = [];

for (const domain of fs.readdirSync(CONTENT)) {
  const domainDir = path.join(CONTENT, domain);
  if (!fs.statSync(domainDir).isDirectory()) continue;

  for (const id of fs.readdirSync(domainDir)) {
    const dir = path.join(domainDir, id);
    if (!fs.statSync(dir).isDirectory()) continue;

    const metaPath = path.join(dir, "meta.yaml");
    if (!fs.existsSync(metaPath)) continue;
    const meta = YAML.parse(fs.readFileSync(metaPath, "utf-8"));

    const levels: Record<number, string> = {};
    for (const file of fs.readdirSync(dir)) {
      if (!file.endsWith(".mdx")) continue;
      const raw = fs.readFileSync(path.join(dir, file), "utf-8");
      const match = /^---\n([\s\S]*?)\n---/.exec(raw);
      if (!match) continue;
      const fm = YAML.parse(match[1]);
      levels[fm.level] = fm.status ?? "seed";
    }
    rows.push({ id, domain, importance: meta.importance ?? 0, levels });
  }
}

const MARK: Record<string, string> = { final: "F", draft: "d", seed: "·" };
const cell = (r: Row, l: number) => MARK[r.levels[l]] ?? "-";
const isDone = (r: Row) =>
  [1, 2, 3, 4, 5].every((l) => r.levels[l] === "final");

rows.sort(
  (a, b) =>
    b.importance - a.importance ||
    a.domain.localeCompare(b.domain) ||
    a.id.localeCompare(b.id),
);

const done = rows.filter(isDone);
const todo = rows.filter((r) => !isDone(r));

const line = (r: Row) =>
  `  ${isDone(r) ? "✓" : " "} ${r.id.padEnd(30)} ${r.domain.padEnd(19)} ` +
  `imp ${r.importance}   ${[1, 2, 3, 4, 5].map((l) => cell(r, l)).join(" ")}`;

console.log(`\nCORTEX content status   (F = final, d = draft, · = seed, - = missing)\n`);
console.log(`  ${"".padEnd(32)}${"".padEnd(19)}      L1 L2 L3 L4 L5`);

console.log(`\nDONE (${done.length}/${rows.length} concepts)\n`);
for (const r of done) console.log(line(r));

const shown = showAll ? todo : todo.filter((r) => r.importance >= 5);
console.log(
  `\nTO DO — ${showAll ? "all" : "importance 5 only, pass --all for the rest"} ` +
    `(${shown.length} of ${todo.length})\n`,
);
for (const r of shown) console.log(line(r));

const files = rows.flatMap((r) => Object.values(r.levels));
const finalFiles = files.filter((s) => s === "final").length;
console.log(
  `\n${done.length}/${rows.length} concepts complete · ` +
    `${finalFiles}/${files.length} level files final · ` +
    `${rows.length * 5 - files.length} level files not yet created\n`,
);
