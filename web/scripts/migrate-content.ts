/**
 * One-time migration: Flutter app content JSONs → web/content tree.
 *
 *   app/assets/content/concepts/<domain>.json
 *     → web/content/concepts/<domain>/<concept_id>/{meta.yaml,l1,l2,l5}.mdx
 *   app/assets/content/quizzes/<domain>_quiz.json
 *     → web/content/quizzes/<domain>.yaml
 *   app/assets/content/curriculum/{worlds,chapters,missions}.json
 *     → web/content/curriculum/{worlds,chapters}.yaml
 *
 * Generated level files are marked `status: seed`: L1 from intuition +
 * practical_example, L2 from definition, L5 from failure_mode +
 * interview_answer. L3 (code) and L4 (frontier) are authored later.
 *
 * Run: npx tsx scripts/migrate-content.ts
 */
import * as fs from "node:fs";
import * as path from "node:path";
import * as YAML from "yaml";

import { splitMathSegments } from "../src/lib/content/math";
import {
  chaptersFileSchema,
  conceptMetaSchema,
  DOMAINS,
  levelFrontmatterSchema,
  quizFileSchema,
  worldsFileSchema,
  type Domain,
} from "../src/lib/content/schema";

const SRC = path.resolve(import.meta.dirname, "../../app/assets/content");
const OUT = path.resolve(import.meta.dirname, "../content");

// ---------- helpers ----------

/**
 * Escape MDX-hazardous characters ({, }, <) in prose, leaving math spans
 * untouched. Backslash escapes are valid MDX/CommonMark character escapes.
 * Already-escaped braces in the source (`\{`) are normalized first so they
 * don't end up double-escaped.
 *
 * Inside math spans, `\$` is rewritten to `\textdollar` because micromark's
 * math tokenizer ends inline math at the first `$` regardless of a preceding
 * backslash — an escaped dollar would silently truncate the span.
 */
function escapeMdxProse(text: string): string {
  return splitMathSegments(text)
    .map((seg) =>
      seg.type === "math"
        ? seg.value.replace(/\\\$/g, "\\textdollar ")
        : seg.value.replace(/\\?([{}<])/g, "\\$1"),
    )
    .join("");
}

/** Naive sentence splitter, good enough for seed recall keyPoints. */
function sentences(text: string): string[] {
  return text
    .split(/(?<=[.!?])\s+(?=[A-Z$'"‘“])/)
    .map((s) => s.trim())
    .filter((s) => s.length > 0);
}

function firstSentences(text: string, n: number): string[] {
  return sentences(text).slice(0, n);
}

/** One-line summary for concept cards: first sentence of the intuition. */
function summaryOf(intuition: string): string {
  const first = sentences(intuition)[0] ?? intuition;
  return first.length > 220 ? `${first.slice(0, 217)}...` : first;
}

function writeFile(relPath: string, content: string): void {
  const full = path.join(OUT, relPath);
  fs.mkdirSync(path.dirname(full), { recursive: true });
  fs.writeFileSync(full, content, "utf-8");
}

function mdxFile(frontmatter: unknown, body: string): string {
  const fm = levelFrontmatterSchema.parse(frontmatter);
  return `---\n${YAML.stringify(fm)}---\n\n${body.trim()}\n`;
}

// ---------- concepts ----------

type SourceConcept = {
  id: string;
  title: string;
  definition: string;
  intuition: string;
  practical_example: string;
  failure_mode: string;
  interview_answer: string;
  tags: string[];
  difficulty: number;
  importance: number;
  related_concept_ids: string[];
};

function migrateConcepts(): number {
  let count = 0;
  for (const domain of DOMAINS) {
    const file = path.join(SRC, "concepts", `${domain}.json`);
    const concepts = JSON.parse(fs.readFileSync(file, "utf-8")) as SourceConcept[];
    for (const c of concepts) {
      migrateConcept(domain, c);
      count++;
    }
  }
  return count;
}

function migrateConcept(domain: Domain, c: SourceConcept): void {
  const dir = `concepts/${domain}/${c.id}`;

  const meta = conceptMetaSchema.parse({
    id: c.id,
    title: c.title,
    domain,
    summary: summaryOf(c.intuition),
    tags: c.tags,
    difficulty: c.difficulty,
    importance: c.importance,
    related_concept_ids: c.related_concept_ids,
  });
  writeFile(`${dir}/meta.yaml`, YAML.stringify(meta));

  writeFile(
    `${dir}/l1-intuition.mdx`,
    mdxFile(
      {
        concept: c.id,
        level: 1,
        status: "seed",
        recall: {
          prompt: `Explain ${c.title} in plain language: what is it, and why does it matter?`,
          keyPoints: firstSentences(c.intuition, 3),
        },
      },
      [
        "## Intuition",
        "",
        escapeMdxProse(c.intuition),
        "",
        "## In practice",
        "",
        escapeMdxProse(c.practical_example),
      ].join("\n"),
    ),
  );

  writeFile(
    `${dir}/l2-math.mdx`,
    mdxFile(
      {
        concept: c.id,
        level: 2,
        status: "seed",
        recall: {
          prompt: `State the formal definition of ${c.title}, including the key equations.`,
          keyPoints: firstSentences(c.definition, 3),
        },
      },
      ["## Formal definition", "", escapeMdxProse(c.definition)].join("\n"),
    ),
  );

  writeFile(
    `${dir}/l5-application.mdx`,
    mdxFile(
      {
        concept: c.id,
        level: 5,
        status: "seed",
        recall: {
          prompt: `How does ${c.title} fail in practice, and how would you present it in an interview?`,
          keyPoints: firstSentences(c.failure_mode, 3),
        },
      },
      [
        "## Failure modes",
        "",
        escapeMdxProse(c.failure_mode),
        "",
        "## Interview-ready answer",
        "",
        escapeMdxProse(c.interview_answer),
      ].join("\n"),
    ),
  );
}

// ---------- quizzes ----------

function migrateQuizzes(): number {
  let count = 0;
  for (const domain of DOMAINS) {
    const file = path.join(SRC, "quizzes", `${domain}_quiz.json`);
    const questions = JSON.parse(fs.readFileSync(file, "utf-8"));
    const parsed = quizFileSchema.parse({ domain, questions });
    writeFile(`quizzes/${domain}.yaml`, YAML.stringify(parsed));
    count += parsed.questions.length;
  }
  return count;
}

// ---------- curriculum ----------

function migrateCurriculum(): { worlds: number; chapters: number } {
  type SourceWorld = {
    id: string;
    title: string;
    description: string;
    icon_name: string;
    order_index: number;
    prerequisite_world_ids: string[];
    required_completion_percent: number;
  };
  type SourceChapter = {
    id: string;
    world_id: string;
    title: string;
    description: string;
    domain_tags: string[];
    order_index: number;
    prerequisite_chapter_ids: string[];
  };
  type SourceMission = { chapter_id: string; concept_ids: string[] };

  const worlds = JSON.parse(
    fs.readFileSync(path.join(SRC, "curriculum/worlds.json"), "utf-8"),
  ) as SourceWorld[];
  const chapters = JSON.parse(
    fs.readFileSync(path.join(SRC, "curriculum/chapters.json"), "utf-8"),
  ) as SourceChapter[];
  const missions = JSON.parse(
    fs.readFileSync(path.join(SRC, "curriculum/missions.json"), "utf-8"),
  ) as SourceMission[];

  const conceptsByChapter = new Map<string, string[]>();
  for (const m of missions) {
    const list = conceptsByChapter.get(m.chapter_id) ?? [];
    for (const id of m.concept_ids) {
      if (!list.includes(id)) list.push(id);
    }
    conceptsByChapter.set(m.chapter_id, list);
  }

  const worldsOut = worldsFileSchema.parse({
    worlds: worlds.map((w) => ({
      id: w.id,
      title: w.title,
      description: w.description,
      icon: w.icon_name,
      order_index: w.order_index,
      prerequisite_world_ids: w.prerequisite_world_ids,
      required_completion_percent: w.required_completion_percent,
    })),
  });
  writeFile("curriculum/worlds.yaml", YAML.stringify(worldsOut));

  const chaptersOut = chaptersFileSchema.parse({
    chapters: chapters.map((ch) => ({
      id: ch.id,
      world_id: ch.world_id,
      title: ch.title,
      description: ch.description,
      domain_tags: ch.domain_tags,
      order_index: ch.order_index,
      prerequisite_chapter_ids: ch.prerequisite_chapter_ids,
      concept_ids: conceptsByChapter.get(ch.id) ?? [],
    })),
  });
  writeFile("curriculum/chapters.yaml", YAML.stringify(chaptersOut));

  return { worlds: worldsOut.worlds.length, chapters: chaptersOut.chapters.length };
}

// ---------- main ----------

for (const sub of ["concepts", "quizzes", "curriculum"]) {
  fs.rmSync(path.join(OUT, sub), { recursive: true, force: true });
}

const conceptCount = migrateConcepts();
const quizCount = migrateQuizzes();
const { worlds, chapters } = migrateCurriculum();

const emptyChapters = YAML.parse(
  fs.readFileSync(path.join(OUT, "curriculum/chapters.yaml"), "utf-8"),
).chapters.filter((c: { concept_ids: string[] }) => c.concept_ids.length === 0);

console.log(`Migrated ${conceptCount} concepts (x3 level files + meta.yaml each)`);
console.log(`Migrated ${quizCount} quiz questions`);
console.log(`Migrated ${worlds} worlds, ${chapters} chapters`);
if (emptyChapters.length > 0) {
  console.warn(
    `WARNING: ${emptyChapters.length} chapters have no concept_ids (manual mapping needed): ${emptyChapters
      .map((c: { id: string }) => c.id)
      .join(", ")}`,
  );
}
