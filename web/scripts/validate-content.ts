/**
 * Content integrity checks beyond per-file Zod validation:
 * referential integrity, required levels, check sanity. Runs as `prebuild`
 * and in CI — exits non-zero on errors, prints warnings otherwise.
 *
 * Run: npx tsx scripts/validate-content.ts
 */
import * as fs from "node:fs";
import * as path from "node:path";
import * as YAML from "yaml";

import {
  chaptersFileSchema,
  conceptMetaSchema,
  levelFrontmatterSchema,
  quizFileSchema,
  worldsFileSchema,
} from "../src/lib/content/schema";

const CONTENT = path.resolve(import.meta.dirname, "../content");

const errors: string[] = [];
const warnings: string[] = [];

function fail(msg: string) {
  errors.push(msg);
}
function warn(msg: string) {
  warnings.push(msg);
}

// ---------- load concepts ----------

type LoadedLevel = ReturnType<typeof levelFrontmatterSchema.parse>;
const concepts = new Map<string, ReturnType<typeof conceptMetaSchema.parse>>();
const levelsByConcept = new Map<string, Map<number, LoadedLevel>>();

const conceptsRoot = path.join(CONTENT, "concepts");
for (const domain of fs.readdirSync(conceptsRoot)) {
  const domainDir = path.join(conceptsRoot, domain);
  if (!fs.statSync(domainDir).isDirectory()) continue;

  for (const conceptDir of fs.readdirSync(domainDir)) {
    const dir = path.join(domainDir, conceptDir);
    const metaPath = path.join(dir, "meta.yaml");
    if (!fs.existsSync(metaPath)) {
      fail(`${domain}/${conceptDir}: missing meta.yaml`);
      continue;
    }
    let meta;
    try {
      meta = conceptMetaSchema.parse(YAML.parse(fs.readFileSync(metaPath, "utf-8")));
    } catch (e) {
      fail(`${domain}/${conceptDir}/meta.yaml: ${(e as Error).message}`);
      continue;
    }
    if (meta.id !== conceptDir) {
      fail(`${domain}/${conceptDir}: meta id "${meta.id}" ≠ directory name`);
    }
    if (meta.domain !== domain) {
      fail(`${domain}/${conceptDir}: meta domain "${meta.domain}" ≠ directory`);
    }
    if (concepts.has(meta.id)) {
      fail(`duplicate concept id: ${meta.id}`);
    }
    concepts.set(meta.id, meta);

    const levels = new Map<number, LoadedLevel>();
    for (const file of fs.readdirSync(dir)) {
      if (!file.endsWith(".mdx")) continue;
      const raw = fs.readFileSync(path.join(dir, file), "utf-8");
      const match = raw.match(/^---\n([\s\S]*?)\n---/);
      if (!match) {
        fail(`${domain}/${conceptDir}/${file}: missing frontmatter`);
        continue;
      }
      let fm: LoadedLevel;
      try {
        fm = levelFrontmatterSchema.parse(YAML.parse(match[1]));
      } catch (e) {
        fail(`${domain}/${conceptDir}/${file}: ${(e as Error).message}`);
        continue;
      }
      if (fm.concept !== meta.id) {
        fail(`${domain}/${conceptDir}/${file}: frontmatter concept ≠ ${meta.id}`);
      }
      const expectedPrefix = `l${fm.level}-`;
      if (!file.startsWith(expectedPrefix)) {
        fail(`${domain}/${conceptDir}/${file}: level ${fm.level} ≠ filename`);
      }
      if (levels.has(fm.level)) {
        fail(`${domain}/${conceptDir}: duplicate level ${fm.level}`);
      }
      // Check questions: answer index in range, unique ids.
      for (const check of fm.check) {
        if (check.answer >= check.options.length) {
          fail(
            `${domain}/${conceptDir}/${file}: check ${check.id} answer index out of range`,
          );
        }
      }
      if (fm.status !== "seed" && fm.check.length === 0) {
        warn(`${domain}/${conceptDir}/${file}: status ${fm.status} but no check questions`);
      }
      if (!fm.recall) {
        warn(`${domain}/${conceptDir}/${file}: no recall prompt (won't appear in reviews)`);
      }
      if (fm.level === 4 && fm.papers.length === 0) {
        warn(`${domain}/${conceptDir}/${file}: L4 frontier with no papers`);
      }

      // ---- the `final` quality bar ----
      //
      // "final" has to mean something, or it drifts back to being a restated
      // flashcard. These are the properties that separate the authored pages
      // from the auto-migrated seeds.
      if (fm.status === "final") {
        const body = raw.slice(match[0].length);
        const where = `${domain}/${conceptDir}/${file}`;

        if (fm.check.length < 2) {
          warn(`${where}: final needs ≥2 check questions (has ${fm.check.length})`);
        }
        if (fm.level === 1) {
          if (fm.media.length === 0) {
            warn(`${where}: final L1 has no media — add a video or lecture link`);
          }
          if (!/<Steps>/.test(body) && !/<Figure\b/.test(body)) {
            warn(`${where}: final L1 has neither <Steps> nor <Figure> — it should show, not just tell`);
          }
        }
        if (fm.level === 5 && !fm.interview) {
          fail(`${where}: final L5 must have an \`interview\` block`);
        }
        if (fm.media.length > 0 && !/<WatchThis\s*\/>/.test(body)) {
          warn(`${where}: declares media but never renders <WatchThis />`);
        }
        if (fm.interview && !/<InterviewAnswer\s*\/>/.test(body)) {
          warn(`${where}: declares interview but never renders <InterviewAnswer />`);
        }
      }
      levels.set(fm.level, fm);
    }

    for (const required of [1, 2, 5]) {
      if (!levels.has(required)) {
        fail(`${meta.id}: missing required level file l${required}-*`);
      }
    }
    levelsByConcept.set(meta.id, levels);
  }
}

// ---------- related concept references ----------

for (const [id, meta] of concepts) {
  for (const rel of meta.related_concept_ids) {
    if (!concepts.has(rel)) {
      warn(`${id}: related concept "${rel}" does not exist`);
    }
  }
}

// ---------- quizzes ----------

let questionCount = 0;
const quizIds = new Set<string>();
const quizzesRoot = path.join(CONTENT, "quizzes");
for (const file of fs.readdirSync(quizzesRoot)) {
  try {
    const parsed = quizFileSchema.parse(
      YAML.parse(fs.readFileSync(path.join(quizzesRoot, file), "utf-8")),
    );
    for (const q of parsed.questions) {
      questionCount++;
      if (quizIds.has(q.id)) fail(`duplicate quiz question id: ${q.id}`);
      quizIds.add(q.id);
      if (q.correct_answer >= q.options.length) {
        fail(`quiz ${q.id}: correct_answer index out of range`);
      }
      for (const cid of q.concept_ids) {
        if (!concepts.has(cid)) {
          warn(`quiz ${q.id}: concept "${cid}" does not exist`);
        }
      }
    }
  } catch (e) {
    fail(`quizzes/${file}: ${(e as Error).message}`);
  }
}

// ---------- curriculum ----------

const worlds = worldsFileSchema.parse(
  YAML.parse(fs.readFileSync(path.join(CONTENT, "curriculum/worlds.yaml"), "utf-8")),
).worlds;
const chapters = chaptersFileSchema.parse(
  YAML.parse(fs.readFileSync(path.join(CONTENT, "curriculum/chapters.yaml"), "utf-8")),
).chapters;

const worldIds = new Set(worlds.map((w) => w.id));
const chapterIds = new Set(chapters.map((c) => c.id));
const mappedConcepts = new Set<string>();

for (const w of worlds) {
  for (const p of w.prerequisite_world_ids) {
    if (!worldIds.has(p)) fail(`world ${w.id}: unknown prerequisite ${p}`);
  }
}
for (const ch of chapters) {
  if (!worldIds.has(ch.world_id)) fail(`chapter ${ch.id}: unknown world ${ch.world_id}`);
  for (const p of ch.prerequisite_chapter_ids) {
    if (!chapterIds.has(p)) fail(`chapter ${ch.id}: unknown prerequisite ${p}`);
  }
  for (const cid of ch.concept_ids) {
    if (!concepts.has(cid)) {
      fail(`chapter ${ch.id}: unknown concept "${cid}"`);
    }
    mappedConcepts.add(cid);
  }
  if (ch.concept_ids.length === 0) {
    warn(`chapter ${ch.id} ("${ch.title}") has no concepts mapped`);
  }
}

const orphans = [...concepts.keys()].filter((id) => !mappedConcepts.has(id));
if (orphans.length > 0) {
  warn(`${orphans.length} concepts not mapped to any chapter: ${orphans.join(", ")}`);
}

// ---------- report ----------

// ---------- authoring progress ----------

let completeConcepts = 0;
let finalFiles = 0;
let totalFiles = 0;
for (const levels of levelsByConcept.values()) {
  const statuses = [...levels.values()].map((l) => l.status);
  totalFiles += statuses.length;
  finalFiles += statuses.filter((s) => s === "final").length;
  if (statuses.length === 5 && statuses.every((s) => s === "final")) {
    completeConcepts += 1;
  }
}

console.log(
  `Validated ${concepts.size} concepts, ${questionCount} quiz questions, ${worlds.length} worlds, ${chapters.length} chapters.`,
);
console.log(
  `Authoring: ${completeConcepts}/${concepts.size} concepts complete (all 5 parts final) · ` +
    `${finalFiles}/${totalFiles} level files final.`,
);
for (const w of warnings) console.warn(`  warn: ${w}`);
if (errors.length > 0) {
  for (const e of errors) console.error(`  ERROR: ${e}`);
  console.error(`\n${errors.length} error(s).`);
  process.exit(1);
}
console.log(`${warnings.length} warning(s), 0 errors.`);
