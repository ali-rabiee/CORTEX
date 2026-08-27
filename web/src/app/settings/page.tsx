"use client";

import {
  AlertTriangle,
  Download,
  HardDriveDownload,
  Upload,
} from "lucide-react";
import { useRef, useState } from "react";

import { SyncSettings } from "@/components/sync/sync-settings";
import {
  downloadBackup,
  exportBackup,
  importBackup,
  resetAllProgress,
} from "@/lib/db/backup";
import { useUserStats, useXpStatus } from "@/lib/db/hooks";

export default function SettingsPage() {
  const stats = useUserStats();
  const xp = useXpStatus();
  const fileInput = useRef<HTMLInputElement>(null);
  const [message, setMessage] = useState<{
    kind: "ok" | "error";
    text: string;
  } | null>(null);

  const handleExport = async () => {
    downloadBackup(await exportBackup());
    setMessage({ kind: "ok", text: "Backup downloaded." });
  };

  const handleImport = async (file: File) => {
    try {
      const json = JSON.parse(await file.text());
      if (
        !window.confirm(
          "Importing replaces ALL local progress with the backup. Continue?",
        )
      ) {
        return;
      }
      await importBackup(json);
      setMessage({ kind: "ok", text: "Backup imported successfully." });
    } catch (e) {
      setMessage({
        kind: "error",
        text: `Import failed: ${e instanceof Error ? e.message : "invalid file"}`,
      });
    }
  };

  const handleReset = async () => {
    if (
      window.confirm(
        "Reset ALL progress — levels, reviews, XP, streaks? This cannot be undone.",
      )
    ) {
      await resetAllProgress();
      setMessage({ kind: "ok", text: "All progress reset." });
    }
  };

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 md:px-8">
      <h1 className="text-2xl font-bold tracking-tight">Settings</h1>

      <section className="mt-6 rounded-card border border-border bg-card p-5">
        <h2 className="text-sm font-semibold text-muted-foreground">
          Your data
        </h2>
        <div className="mt-3 grid grid-cols-2 gap-3 text-sm sm:grid-cols-4">
          <Stat label="Level" value={xp ? String(xp.level) : "—"} />
          <Stat label="Total XP" value={xp ? String(xp.totalXp) : "—"} />
          <Stat label="Streak" value={String(stats?.currentStreak ?? 0)} />
          <Stat label="Sessions" value={String(stats?.totalSessions ?? 0)} />
        </div>
        <p className="mt-4 text-xs leading-relaxed text-faint">
          Progress lives in this browser (IndexedDB). With sync on, an encrypted
          copy also lives on your Worker. Export a backup before clearing browser
          data — a file on disk is the one copy nothing else can touch.
        </p>
        <div className="mt-4 flex flex-wrap gap-3">
          <button
            onClick={handleExport}
            className="inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
          >
            <Download size={15} /> Export backup
          </button>
          <button
            onClick={() => fileInput.current?.click()}
            className="inline-flex items-center gap-2 rounded-lg border border-border bg-surface px-4 py-2 text-sm font-semibold transition-colors hover:border-border-strong"
          >
            <Upload size={15} /> Import backup
          </button>
          <input
            ref={fileInput}
            type="file"
            accept="application/json"
            className="hidden"
            onChange={(e) => {
              const f = e.target.files?.[0];
              if (f) void handleImport(f);
              e.target.value = "";
            }}
          />
        </div>
        {message && (
          <p
            className={`mt-3 text-sm ${
              message.kind === "ok" ? "text-success" : "text-danger"
            }`}
          >
            {message.text}
          </p>
        )}
      </section>

      <SyncSettings />

      <section className="mt-6 rounded-card border border-danger/30 bg-danger/5 p-5">
        <h2 className="flex items-center gap-2 text-sm font-semibold text-danger">
          <AlertTriangle size={15} /> Danger zone
        </h2>
        <p className="mt-2 text-xs leading-relaxed text-muted-foreground">
          Wipe every level pass, review card, confidence log, XP event, and
          streak.
        </p>
        <button
          onClick={handleReset}
          className="mt-3 inline-flex items-center gap-2 rounded-lg border border-danger/40 bg-danger/10 px-4 py-2 text-sm font-semibold text-danger transition-colors hover:bg-danger/20"
        >
          <HardDriveDownload size={15} /> Reset all progress
        </button>
      </section>
    </div>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-lg bg-surface p-3">
      <p className="text-[0.65rem] uppercase tracking-wide text-faint">
        {label}
      </p>
      <p className="mt-0.5 text-lg font-bold">{value}</p>
    </div>
  );
}
