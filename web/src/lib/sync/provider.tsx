"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
  type ReactNode,
} from "react";

import { localRev, onLocalRevChange } from "@/lib/db/db";

import { SyncError, type RemoteState } from "./client";
import {
  clearSyncConfig,
  getDeviceName,
  getEndpoint,
  getLastSyncedAt,
  getLastSyncedRev,
  getRememberPassphrase,
  getStoredPassphrase,
  setEndpoint as persistEndpoint,
  setRememberPassphrase,
  setStoredPassphrase,
} from "./config";
import { DecryptionError, deriveKeys } from "./crypto";
import { resolveConflict, runSync, type SyncSession } from "./engine";

/** How often to reconcile while the tab is open. */
const POLL_MS = 2 * 60 * 1000;
/** Quiet period after a local write before pushing it. */
const DEBOUNCE_MS = 8 * 1000;

export type SyncStatus =
  /** Still reading localStorage — we don't know yet. */
  | "init"
  /** No endpoint configured; the app is purely local. */
  | "disabled"
  /** Endpoint configured, waiting for the passphrase. */
  | "locked"
  | "unlocking"
  | "ready";

export type SyncActivity = "idle" | "syncing" | "offline" | "error" | "conflict";

type SyncContextValue = {
  status: SyncStatus;
  activity: SyncActivity;
  error: string | null;
  lastSyncedAt: string | null;
  dirty: boolean;
  conflict: RemoteState | null;
  endpoint: string | null;
  deviceName: string;
  rememberPassphrase: boolean;
  configure: (endpoint: string) => void;
  unlock: (passphrase: string, remember: boolean) => Promise<void>;
  lock: () => void;
  disconnect: () => void;
  syncNow: () => Promise<void>;
  resolve: (keep: "local" | "remote") => Promise<void>;
};

const SyncContext = createContext<SyncContextValue | null>(null);

export function useSync(): SyncContextValue {
  const value = useContext(SyncContext);
  if (!value) throw new Error("useSync must be used inside <SyncProvider>");
  return value;
}

function describe(err: unknown): string {
  if (err instanceof SyncError) return err.message;
  if (err instanceof DecryptionError) return err.message;
  return err instanceof Error ? err.message : "Sync failed.";
}

export function SyncProvider({ children }: { children: ReactNode }) {
  const [status, setStatus] = useState<SyncStatus>("init");
  const [activity, setActivity] = useState<SyncActivity>("idle");
  const [error, setError] = useState<string | null>(null);
  const [lastSyncedAt, setLastSyncedAt] = useState<string | null>(null);
  const [conflict, setConflict] = useState<RemoteState | null>(null);
  const [endpoint, setEndpointState] = useState<string | null>(null);
  const [deviceName, setDeviceName] = useState("");
  const [remember, setRemember] = useState(true);
  const [rev, setRev] = useState(0);
  const [syncedRev, setSyncedRev] = useState(0);

  const sessionRef = useRef<SyncSession | null>(null);
  /** Serialises reconciles so a poll can't race a manual sync. */
  const inFlight = useRef<Promise<void> | null>(null);

  const dirty = status === "ready" && rev !== syncedRev;

  const refreshRevState = useCallback(() => {
    setRev(localRev());
    setSyncedRev(getLastSyncedRev());
    setLastSyncedAt(getLastSyncedAt());
  }, []);

  const sync = useCallback(async () => {
    const session = sessionRef.current;
    if (!session) return;
    if (inFlight.current) return inFlight.current;

    const run = (async () => {
      setActivity("syncing");
      try {
        const outcome = await runSync(session);
        if (outcome.kind === "conflict") {
          setConflict(outcome.remote);
          setActivity("conflict");
        } else {
          setConflict(null);
          setError(null);
          setActivity("idle");
        }
      } catch (err) {
        setError(describe(err));
        setActivity(
          err instanceof SyncError && err.kind === "network" ? "offline" : "error",
        );
      } finally {
        refreshRevState();
        inFlight.current = null;
      }
    })();

    inFlight.current = run;
    return run;
  }, [refreshRevState]);

  const unlock = useCallback(
    async (passphrase: string, rememberIt: boolean) => {
      const url = getEndpoint();
      if (!url) throw new Error("No sync endpoint configured.");

      setStatus("unlocking");
      setError(null);
      try {
        const keys = await deriveKeys(passphrase);
        sessionRef.current = {
          endpoint: url,
          token: keys.authToken,
          dataKey: keys.dataKey,
          device: getDeviceName(),
        };

        setRememberPassphrase(rememberIt);
        setRemember(rememberIt);
        setStoredPassphrase(rememberIt ? passphrase : null);

        setStatus("ready");
        document.documentElement.removeAttribute("data-sync-locked");
        await sync();
      } catch (err) {
        sessionRef.current = null;
        setStatus("locked");
        setError(describe(err));
        throw err;
      }
    },
    [sync],
  );

  const lock = useCallback(() => {
    sessionRef.current = null;
    setStoredPassphrase(null);
    setConflict(null);
    setActivity("idle");
    setStatus(getEndpoint() ? "locked" : "disabled");
  }, []);

  const configure = useCallback((url: string) => {
    persistEndpoint(url || null);
    setEndpointState(getEndpoint());
    setStatus(getEndpoint() ? "locked" : "disabled");
    setError(null);
  }, []);

  const disconnect = useCallback(() => {
    sessionRef.current = null;
    clearSyncConfig();
    setEndpointState(null);
    setConflict(null);
    setError(null);
    setActivity("idle");
    setStatus("disabled");
    refreshRevState();
  }, [refreshRevState]);

  const resolve = useCallback(
    async (keep: "local" | "remote") => {
      const session = sessionRef.current;
      if (!session) return;
      setActivity("syncing");
      try {
        await resolveConflict(session, keep);
        setConflict(null);
        setError(null);
        setActivity("idle");
      } catch (err) {
        setError(describe(err));
        setActivity("error");
      } finally {
        refreshRevState();
      }
    },
    [refreshRevState],
  );

  // Boot: read persisted config, and unlock straight away if this device
  // remembers the passphrase.
  useEffect(() => {
    const url = getEndpoint();
    setEndpointState(url);
    setDeviceName(getDeviceName());
    setRemember(getRememberPassphrase());
    refreshRevState();

    if (!url) {
      setStatus("disabled");
      document.documentElement.removeAttribute("data-sync-locked");
      return;
    }

    const stored = getStoredPassphrase();
    if (stored) {
      void unlock(stored, true).catch(() => {
        /* surfaced through `error` */
      });
    } else {
      setStatus("locked");
    }
    // Boot must run exactly once; `unlock` is stable enough for this purpose.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Track local writes so the UI can show "unsynced changes".
  useEffect(() => onLocalRevChange(setRev), []);

  // Debounced push after local activity settles.
  useEffect(() => {
    if (status !== "ready" || !dirty) return;
    const timer = setTimeout(() => void sync(), DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [status, dirty, rev, sync]);

  // Poll, plus the moments that matter most: coming back to the tab, and
  // regaining connectivity.
  useEffect(() => {
    if (status !== "ready") return;

    const timer = setInterval(() => void sync(), POLL_MS);
    const onVisible = () => {
      if (document.visibilityState === "visible") void sync();
    };
    const onOnline = () => void sync();

    document.addEventListener("visibilitychange", onVisible);
    window.addEventListener("online", onOnline);
    window.addEventListener("focus", onVisible);
    return () => {
      clearInterval(timer);
      document.removeEventListener("visibilitychange", onVisible);
      window.removeEventListener("online", onOnline);
      window.removeEventListener("focus", onVisible);
    };
  }, [status, sync]);

  const value = useMemo<SyncContextValue>(
    () => ({
      status,
      activity,
      error,
      lastSyncedAt,
      dirty,
      conflict,
      endpoint,
      deviceName,
      rememberPassphrase: remember,
      configure,
      unlock,
      lock,
      disconnect,
      syncNow: async () => {
        await sync();
      },
      resolve,
    }),
    [
      status,
      activity,
      error,
      lastSyncedAt,
      dirty,
      conflict,
      endpoint,
      deviceName,
      remember,
      configure,
      unlock,
      lock,
      disconnect,
      sync,
      resolve,
    ],
  );

  return <SyncContext.Provider value={value}>{children}</SyncContext.Provider>;
}
