/**
 * Reconciliation between this device's IndexedDB and the encrypted snapshot on
 * the sync Worker.
 *
 * The rule is: never silently lose work. Whenever both sides have moved since
 * this device last reconciled, we stop and hand the choice to the user instead
 * of picking a winner by timestamp.
 */

import { exportBackup, importBackup } from "@/lib/db/backup";
import { db, localRev } from "@/lib/db/db";

import { fetchState, pushState, type RemoteState } from "./client";
import {
  getBaseVersion,
  getLastSyncedRev,
  setBaseVersion,
  setLastSyncedAt,
  setLastSyncedRev,
} from "./config";
import { decryptJson, encryptJson } from "./crypto";

export type SyncSession = {
  endpoint: string;
  token: string;
  dataKey: CryptoKey;
  device: string;
};

export type SyncAction = "noop" | "push" | "pull" | "conflict";

export type SyncInputs = {
  remoteVersion: number;
  remoteHasBlob: boolean;
  baseVersion: number;
  localRev: number;
  lastSyncedRev: number;
  hasLocalData: boolean;
};

/**
 * Pure decision step — the interesting logic, kept testable.
 *
 * "Dirty" means this device has written something since its last successful
 * sync. "Diverged" means the server has moved on from the version this device
 * last reconciled with (another device pushed).
 */
export function decideSync(inputs: SyncInputs): SyncAction {
  const dirty = inputs.localRev !== inputs.lastSyncedRev;

  // Server is empty — either first ever sync, or it was reset. Restoring it
  // from this device is always safer than wiping this device to match.
  if (!inputs.remoteHasBlob) {
    return dirty || inputs.hasLocalData ? "push" : "noop";
  }

  if (inputs.remoteVersion === inputs.baseVersion) {
    return dirty ? "push" : "noop";
  }

  // Server moved. If we have nothing of our own to lose, take theirs.
  return dirty ? "conflict" : "pull";
}

export type SyncOutcome =
  | { kind: "noop"; state: RemoteState }
  | { kind: "pushed"; state: RemoteState }
  | { kind: "pulled"; state: RemoteState }
  | { kind: "conflict"; remote: RemoteState };

async function hasAnyLocalData(): Promise<boolean> {
  const counts = await Promise.all([
    db.conceptProgress.count(),
    db.reviewCards.count(),
    db.xpEvents.count(),
    db.sessionLogs.count(),
  ]);
  return counts.some((n) => n > 0);
}

function markSynced(version: number, rev: number): void {
  setBaseVersion(version);
  setLastSyncedRev(rev);
  setLastSyncedAt(new Date().toISOString());
}

async function doPush(
  session: SyncSession,
  baseVersion: number,
  force = false,
): Promise<SyncOutcome> {
  // Snapshot the revision *before* exporting: if a write lands mid-export we
  // stay marked dirty and push again, rather than declaring it synced.
  const rev = localRev();
  const blob = await encryptJson(session.dataKey, await exportBackup());

  const result = await pushState(session.endpoint, session.token, {
    baseVersion,
    blob,
    device: session.device,
    force,
  });

  if (!result.ok) return { kind: "conflict", remote: result.conflict };

  markSynced(result.state.version, rev);
  return { kind: "pushed", state: result.state };
}

async function doPull(
  session: SyncSession,
  remote: RemoteState,
): Promise<SyncOutcome> {
  if (!remote.blob) return { kind: "noop", state: remote };

  const backup = await decryptJson(session.dataKey, remote.blob);
  await importBackup(backup, { markDirty: false });
  markSynced(remote.version, localRev());
  return { kind: "pulled", state: remote };
}

/** One full reconcile pass. Throws `SyncError` / `DecryptionError` on failure. */
export async function runSync(session: SyncSession): Promise<SyncOutcome> {
  const remote = await fetchState(session.endpoint, session.token);
  const baseVersion = getBaseVersion();

  const action = decideSync({
    remoteVersion: remote.version,
    remoteHasBlob: remote.blob !== null,
    baseVersion,
    localRev: localRev(),
    lastSyncedRev: getLastSyncedRev(),
    hasLocalData: await hasAnyLocalData(),
  });

  switch (action) {
    case "noop":
      // Still record that we agree with the server, so a later push has the
      // right base version even if this device never wrote anything.
      if (remote.version !== baseVersion && remote.blob === null) {
        setBaseVersion(remote.version);
      }
      return { kind: "noop", state: remote };
    case "push":
      return doPush(session, remote.blob === null ? remote.version : baseVersion);
    case "pull":
      return doPull(session, remote);
    case "conflict":
      return { kind: "conflict", remote };
  }
}

/** User's answer to a conflict: keep this device's data, or the server's. */
export async function resolveConflict(
  session: SyncSession,
  keep: "local" | "remote",
): Promise<SyncOutcome> {
  if (keep === "local") return doPush(session, 0, true);
  return doPull(session, await fetchState(session.endpoint, session.token));
}
