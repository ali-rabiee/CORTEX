import { z } from "zod";

/** The seven knowledge domains. Order defines display order. */
export const DOMAINS = [
  "ml_fundamentals",
  "rl",
  "robot_learning",
  "perception",
  "foundation_models",
  "generative_control",
  "systems",
] as const;

export const domainSchema = z.enum(DOMAINS);
export type Domain = z.infer<typeof domainSchema>;

export const DOMAIN_LABELS: Record<Domain, string> = {
  ml_fundamentals: "ML Fundamentals",
  rl: "Reinforcement Learning",
  robot_learning: "Robot Learning",
  perception: "Perception",
  foundation_models: "Foundation Models",
  generative_control: "Generative Control",
  systems: "Systems",
};

/** Tailwind color token per domain (defined in globals.css @theme). */
export const DOMAIN_COLORS: Record<Domain, string> = {
  ml_fundamentals: "domain-ml",
  rl: "domain-rl",
  robot_learning: "domain-robot",
  perception: "domain-perception",
  foundation_models: "domain-foundation",
  generative_control: "domain-generative",
  systems: "domain-systems",
};

/** Mastery levels within a concept. */
export const LEVELS = [1, 2, 3, 4, 5] as const;
export type Level = (typeof LEVELS)[number];

export const LEVEL_INFO: Record<
  Level,
  { slug: string; title: string; tagline: string }
> = {
  1: { slug: "intuition", title: "Intuition", tagline: "What it is and why it matters" },
  2: { slug: "math", title: "Math", tagline: "The formal machinery" },
  3: { slug: "code", title: "Code", tagline: "From equations to Python" },
  4: { slug: "frontier", title: "Frontier", tagline: "The papers that define the state of the art" },
  5: { slug: "application", title: "Application", tagline: "Failure modes, debugging, interviews" },
};

/** Per-concept metadata (meta.yaml). */
export const conceptMetaSchema = z.object({
  id: z.string().min(1),
  title: z.string().min(1),
  domain: domainSchema,
  summary: z.string().min(1),
  tags: z.array(z.string()).default([]),
  difficulty: z.number().int().min(1).max(4),
  importance: z.number().int().min(1).max(5),
  related_concept_ids: z.array(z.string()).default([]),
});
export type ConceptMeta = z.infer<typeof conceptMetaSchema>;

/** A multiple-choice check question used to gate level-ups. */
export const checkQuestionSchema = z.object({
  id: z.string().min(1),
  prompt: z.string().min(1),
  options: z.array(z.string().min(1)).min(2),
  answer: z.number().int().min(0),
  explanation: z.string().min(1),
});
export type CheckQuestion = z.infer<typeof checkQuestionSchema>;

/** What a spaced-repetition review of this concept shows at this level. */
export const recallSchema = z.object({
  prompt: z.string().min(1),
  keyPoints: z.array(z.string().min(1)).min(1),
});
export type Recall = z.infer<typeof recallSchema>;

/** A paper citation rendered as a PaperCard (L4 levels). */
export const paperRefSchema = z.object({
  key: z.string().min(1),
  title: z.string().min(1),
  authors: z.string().optional(),
  venue: z.string().optional(),
  year: z.number().int().min(1950).max(2100),
  arxiv: z
    .string()
    .regex(/^\d{4}\.\d{4,5}(v\d+)?$/, "expected arXiv id like 2304.13705")
    .optional(),
  url: z.string().url().optional(),
  takeaway: z.string().min(1),
});
export type PaperRef = z.infer<typeof paperRefSchema>;

/** Frontmatter of a concept-level MDX file. */
export const levelFrontmatterSchema = z.object({
  concept: z.string().min(1),
  level: z.number().int().min(1).max(5),
  status: z.enum(["seed", "draft", "final"]).default("seed"),
  recall: recallSchema.optional(),
  check: z.array(checkQuestionSchema).default([]),
  papers: z.array(paperRefSchema).default([]),
});

/** A quiz question (domain quiz banks). */
export const quizQuestionSchema = z.object({
  id: z.string().min(1),
  question: z.string().min(1),
  options: z.array(z.string().min(1)).min(2),
  correct_answer: z.number().int().min(0),
  explanation: z.string().min(1),
  concept_ids: z.array(z.string()).default([]),
  difficulty: z.number().int().min(1).max(4),
  tags: z.array(z.string()).default([]),
});
export type QuizQuestion = z.infer<typeof quizQuestionSchema>;

export const quizFileSchema = z.object({
  domain: domainSchema,
  questions: z.array(quizQuestionSchema),
});

/** Curriculum: worlds.yaml */
export const worldSchema = z.object({
  id: z.string().min(1),
  title: z.string().min(1),
  description: z.string().min(1),
  icon: z.string().default("globe"),
  order_index: z.number().int(),
  prerequisite_world_ids: z.array(z.string()).default([]),
  required_completion_percent: z.number().min(0).max(1).default(0.6),
});
export type World = z.infer<typeof worldSchema>;

export const worldsFileSchema = z.object({ worlds: z.array(worldSchema) });

/** Curriculum: chapters.yaml */
export const chapterSchema = z.object({
  id: z.string().min(1),
  world_id: z.string().min(1),
  title: z.string().min(1),
  description: z.string().min(1),
  domain_tags: z.array(z.string()).default([]),
  order_index: z.number().int(),
  prerequisite_chapter_ids: z.array(z.string()).default([]),
  concept_ids: z.array(z.string()).default([]),
});
export type Chapter = z.infer<typeof chapterSchema>;

export const chaptersFileSchema = z.object({ chapters: z.array(chapterSchema) });
