import Dexie, { type EntityTable } from "dexie";

/**
 * CORTEX local-first store. All user progress lives in IndexedDB; content is
 * static (compiled into the app). Timestamps are ISO strings so backups are
 * portable JSON.
 */

export type ReviewCardRow = {
  conceptId: string;
  easeFactor: number;
  /** Days. */
  interval: number;
  repetitions: number;
  lastQuality: number | null;
  /** Concept level this card reviews (user's current level). */
  level: number;
  /** ISO timestamp (UTC midnight). */
  nextReviewDate: string;
  createdAt: string;
};

export type ConceptProgressRow = {
  conceptId: string;
  /** Highest passed level, 0–5 (0 = nothing passed yet). */
  currentLevel: number;
  /** ISO timestamp per passed level, keyed by level number. */
  levelPassedAt: Record<number, string>;
  checkAttempts: number;
};

export type ConfidenceLogRow = {
  id?: number;
  conceptId: string;
  domain: string;
  /** 1–5, rated before reveal. */
  confidence: number;
  /** 0–5, rated after reveal. */
  quality: number;
  timestamp: string;
};

export type QuizAttemptRow = {
  id?: number;
  questionId: string;
  domain: string;
  selected: number;
  correct: boolean;
  conceptIds: string[];
  timestamp: string;
};

export type SessionLogRow = {
  id?: number;
  /** Local day key, e.g. "2026-06-11". */
  date: string;
  length: "sprint" | "standard" | "deep";
  reviewedCards: number;
  quizQuestions: number;
  quizCorrect: number;
  avgQuality: number;
  durationSec: number;
  xpEarned: number;
  completedAt: string;
};

export type XpEventRow = {
  id?: number;
  kind: "level_pass" | "session" | "quiz";
  amount: number;
  /** What earned it, e.g. "ppo_clipping:l2". */
  ref: string;
  timestamp: string;
};

export type UserStatsRow = {
  id: "singleton";
  currentStreak: number;
  longestStreak: number;
  /** Local day key of last completed session. */
  lastSessionDay: string | null;
  totalSessions: number;
  totalReviews: number;
};

export type SettingRow = {
  key: string;
  value: unknown;
};

export class CortexDb extends Dexie {
  reviewCards!: EntityTable<ReviewCardRow, "conceptId">;
  conceptProgress!: EntityTable<ConceptProgressRow, "conceptId">;
  confidenceLogs!: EntityTable<ConfidenceLogRow, "id">;
  quizAttempts!: EntityTable<QuizAttemptRow, "id">;
  sessionLogs!: EntityTable<SessionLogRow, "id">;
  xpEvents!: EntityTable<XpEventRow, "id">;
  userStats!: EntityTable<UserStatsRow, "id">;
  settings!: EntityTable<SettingRow, "key">;

  constructor() {
    super("cortex");
    this.version(1).stores({
      reviewCards: "conceptId, nextReviewDate",
      conceptProgress: "conceptId",
      confidenceLogs: "++id, conceptId, domain, timestamp",
      quizAttempts: "++id, questionId, timestamp",
      sessionLogs: "++id, date",
      xpEvents: "++id, timestamp",
      userStats: "id",
      settings: "key",
    });
  }
}

export const db = new CortexDb();

/* ------------------------------------------------------------------ *
 * Local revision counter
 *
 * Bumped on every write so the sync engine can tell "this device has work
 * the server hasn't seen" from "nothing changed since the last sync",
 * without diffing the whole database. Persisted so it survives reloads.
 * ------------------------------------------------------------------ */

const LOCAL_REV_KEY = "cortex.sync.localRev";

function readPersistedRev(): number {
  try {
    return Number(globalThis.localStorage?.getItem(LOCAL_REV_KEY) ?? 0) || 0;
  } catch {
    return 0; // private browsing, or a non-DOM test environment
  }
}

let localRevValue = readPersistedRev();
let suppressDepth = 0;
const revListeners = new Set<(rev: number) => void>();

export function localRev(): number {
  return localRevValue;
}

export function onLocalRevChange(listener: (rev: number) => void): () => void {
  revListeners.add(listener);
  return () => revListeners.delete(listener);
}

function bumpLocalRev(): void {
  if (suppressDepth > 0) return;
  localRevValue += 1;
  try {
    globalThis.localStorage?.setItem(LOCAL_REV_KEY, String(localRevValue));
  } catch {
    /* in-memory only is fine */
  }
  for (const listener of revListeners) listener(localRevValue);
}

/**
 * Run writes that came *from* the server, so applying a pulled snapshot
 * doesn't immediately mark the device dirty and push it straight back.
 */
export async function withoutRevBump<T>(fn: () => Promise<T>): Promise<T> {
  suppressDepth += 1;
  try {
    return await fn();
  } finally {
    suppressDepth -= 1;
  }
}

const MUTATING = new Set(["add", "put", "delete", "deleteRange"]);

db.use({
  stack: "dbcore",
  name: "cortex-local-rev",
  create(core) {
    return {
      ...core,
      table(name) {
        const table = core.table(name);
        return {
          ...table,
          mutate: async (req) => {
            const result = await table.mutate(req);
            if (MUTATING.has(req.type)) bumpLocalRev();
            return result;
          },
        };
      },
    };
  },
});

export const TABLE_NAMES = [
  "reviewCards",
  "conceptProgress",
  "confidenceLogs",
  "quizAttempts",
  "sessionLogs",
  "xpEvents",
  "userStats",
  "settings",
] as const;
export type TableName = (typeof TABLE_NAMES)[number];
