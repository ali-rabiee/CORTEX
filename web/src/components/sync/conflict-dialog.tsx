"use client";

import { GitMerge } from "lucide-react";

import { useSync } from "@/lib/sync/provider";

/**
 * Shown when this device and the server both changed since the last sync.
 * Rather than resolving by timestamp — which quietly discards a session — we
 * name both sides and let the user choose.
 */
export function ConflictDialog() {
  const { conflict, resolve, activity } = useSync();
  if (!conflict) return null;

  const busy = activity === "syncing";
  const when = conflict.updatedAt
    ? new Date(conflict.updatedAt).toLocaleString()
    : "unknown time";

  return (
    <div className="fixed inset-0 z-[110] flex items-center justify-center bg-background/85 px-5 backdrop-blur">
      <div className="w-full max-w-md rounded-card border border-warning/40 bg-card p-6">
        <h2 className="flex items-center gap-2 text-base font-bold">
          <GitMerge size={17} className="text-warning" /> Two versions of your
          progress
        </h2>
        <p className="mt-3 text-sm leading-relaxed text-muted-foreground">
          This device has changes that were never synced, and{" "}
          <strong className="text-foreground">
            {conflict.device ?? "another device"}
          </strong>{" "}
          uploaded its own at {when}. Keeping one replaces the other, so pick
          whichever has the work you care about.
        </p>
        <p className="mt-3 text-xs leading-relaxed text-faint">
          Not sure? Export a backup from Settings first — that file is a full
          copy of what is on this device right now.
        </p>

        <div className="mt-5 flex flex-col gap-2.5">
          <button
            disabled={busy}
            onClick={() => void resolve("local")}
            className="rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark disabled:opacity-50"
          >
            Keep this device&apos;s progress
          </button>
          <button
            disabled={busy}
            onClick={() => void resolve("remote")}
            className="rounded-lg border border-border bg-surface px-4 py-2.5 text-sm font-semibold transition-colors hover:border-border-strong disabled:opacity-50"
          >
            Use the synced version from {conflict.device ?? "the other device"}
          </button>
        </div>
      </div>
    </div>
  );
}
