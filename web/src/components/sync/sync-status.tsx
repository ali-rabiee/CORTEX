"use client";

import {
  AlertTriangle,
  Check,
  CloudOff,
  GitMerge,
  RefreshCw,
  UploadCloud,
} from "lucide-react";
import Link from "next/link";
import type { LucideIcon } from "lucide-react";

import { useSync } from "@/lib/sync/provider";

type Look = { icon: LucideIcon; label: string; tone: string; spin?: boolean };

function look(
  activity: ReturnType<typeof useSync>["activity"],
  dirty: boolean,
): Look {
  switch (activity) {
    case "syncing":
      return { icon: RefreshCw, label: "Syncing…", tone: "text-muted-foreground", spin: true };
    case "offline":
      return { icon: CloudOff, label: "Offline", tone: "text-muted-foreground" };
    case "error":
      return { icon: AlertTriangle, label: "Sync error", tone: "text-danger" };
    case "conflict":
      return { icon: GitMerge, label: "Needs review", tone: "text-warning" };
    default:
      return dirty
        ? { icon: UploadCloud, label: "Unsynced", tone: "text-warning" }
        : { icon: Check, label: "Synced", tone: "text-success" };
  }
}

/** Compact sync indicator for the sidebar. Hidden when sync isn't set up. */
export function SyncStatusPill() {
  const { status, activity, dirty, syncNow } = useSync();
  if (status !== "ready") return null;

  const { icon: Icon, label, tone, spin } = look(activity, dirty);
  const actionable = activity === "error" || activity === "conflict";

  const content = (
    <>
      <Icon size={13} className={spin ? "animate-spin" : undefined} />
      {label}
    </>
  );
  const className = `mb-3 flex w-full items-center gap-1.5 rounded-lg px-2 py-1.5 text-[0.7rem] font-medium ${tone} transition-colors hover:bg-card`;

  return actionable ? (
    <Link href="/settings" className={className}>
      {content}
    </Link>
  ) : (
    <button type="button" onClick={() => void syncNow()} className={className}>
      {content}
    </button>
  );
}
