"use client";

import {
  CheckCircle2,
  Cloud,
  CloudOff,
  Loader2,
  LockKeyhole,
  RefreshCw,
  Unplug,
  XCircle,
} from "lucide-react";
import { useState } from "react";

import { checkHealth } from "@/lib/sync/client";
import { normaliseEndpoint, setRememberPassphrase } from "@/lib/sync/config";
import { useSync } from "@/lib/sync/provider";

export function SyncSettings() {
  const {
    status,
    activity,
    error,
    dirty,
    lastSyncedAt,
    endpoint,
    deviceName,
    rememberPassphrase,
    configure,
    disconnect,
    lock,
    syncNow,
  } = useSync();

  const [draft, setDraft] = useState(endpoint ?? "");
  const [probe, setProbe] = useState<"idle" | "checking" | "ok" | "fail">("idle");
  const [remember, setRemember] = useState(rememberPassphrase);

  const connected = status === "ready";

  const runProbe = async () => {
    const url = normaliseEndpoint(draft);
    if (!url) return;
    setProbe("checking");
    setProbe((await checkHealth(url)) ? "ok" : "fail");
  };

  return (
    <section className="mt-6 rounded-card border border-border bg-card p-5">
      <h2 className="flex items-center gap-2 text-sm font-semibold text-muted-foreground">
        {connected ? <Cloud size={15} /> : <CloudOff size={15} />} Sync across
        devices
      </h2>

      {connected ? (
        <>
          <div className="mt-3 space-y-1.5 text-sm">
            <Row label="Server" value={endpoint ?? "—"} mono />
            <Row label="This device" value={deviceName} />
            <Row
              label="Last synced"
              value={
                lastSyncedAt ? new Date(lastSyncedAt).toLocaleString() : "never"
              }
            />
            <Row
              label="Pending changes"
              value={dirty ? "yes — will upload shortly" : "none"}
            />
          </div>

          {error && <p className="mt-3 text-sm text-danger">{error}</p>}

          <label className="mt-4 flex items-center gap-2.5 text-sm text-muted-foreground">
            <input
              type="checkbox"
              checked={remember}
              onChange={(e) => {
                setRemember(e.target.checked);
                setRememberPassphrase(e.target.checked);
              }}
              className="size-4 accent-[var(--color-primary)]"
            />
            Stay unlocked on this device
          </label>
          <p className="mt-1.5 text-xs leading-relaxed text-faint">
            On means you never retype the passphrase here — convenient on your
            own phone, but anyone who can unlock this device can open CORTEX.
            Off means typing it on every load. Either way, nobody can read your
            data on the server without it.
          </p>

          <div className="mt-4 flex flex-wrap gap-3">
            <button
              onClick={() => void syncNow()}
              disabled={activity === "syncing"}
              className="inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark disabled:opacity-50"
            >
              {activity === "syncing" ? (
                <Loader2 size={15} className="animate-spin" />
              ) : (
                <RefreshCw size={15} />
              )}
              Sync now
            </button>
            <button
              onClick={lock}
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-surface px-4 py-2 text-sm font-semibold transition-colors hover:border-border-strong"
            >
              <LockKeyhole size={15} /> Lock
            </button>
            <button
              onClick={() => {
                if (
                  window.confirm(
                    "Disconnect sync on this device? Local progress stays put, and the server copy is untouched.",
                  )
                ) {
                  disconnect();
                  setDraft("");
                }
              }}
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-surface px-4 py-2 text-sm font-semibold text-muted-foreground transition-colors hover:border-border-strong"
            >
              <Unplug size={15} /> Disconnect
            </button>
          </div>
        </>
      ) : (
        <>
          <p className="mt-2 text-xs leading-relaxed text-muted-foreground">
            Point CORTEX at your own sync Worker to keep progress in step across
            your laptop and phone. Your passphrase encrypts everything before it
            leaves the browser, so the server stores ciphertext it can&apos;t
            read.
          </p>

          <label
            htmlFor="sync-endpoint"
            className="mt-4 block text-xs font-medium text-muted-foreground"
          >
            Worker URL
          </label>
          <div className="mt-1.5 flex flex-wrap gap-2">
            <input
              id="sync-endpoint"
              type="url"
              inputMode="url"
              autoCapitalize="none"
              autoCorrect="off"
              spellCheck={false}
              value={draft}
              onChange={(e) => {
                setDraft(e.target.value);
                setProbe("idle");
              }}
              placeholder="https://cortex-sync.your-name.workers.dev"
              className="min-w-0 flex-1 rounded-lg border border-border bg-surface px-3 py-2 font-mono text-sm outline-none transition-colors placeholder:text-faint focus:border-primary"
            />
            <button
              onClick={() => void runProbe()}
              disabled={!draft.trim() || probe === "checking"}
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-surface px-3 py-2 text-sm font-semibold transition-colors hover:border-border-strong disabled:opacity-50"
            >
              {probe === "checking" && <Loader2 size={14} className="animate-spin" />}
              {probe === "ok" && <CheckCircle2 size={14} className="text-success" />}
              {probe === "fail" && <XCircle size={14} className="text-danger" />}
              Test
            </button>
          </div>
          {probe === "ok" && (
            <p className="mt-2 text-xs text-success">
              Worker is up. Connect, then unlock with your passphrase.
            </p>
          )}
          {probe === "fail" && (
            <p className="mt-2 text-xs text-danger">
              No response. Check the URL — it should end in{" "}
              <code className="font-mono">.workers.dev</code> with no trailing
              path.
            </p>
          )}

          <button
            onClick={() => configure(draft)}
            disabled={!draft.trim()}
            className="mt-4 inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark disabled:opacity-50"
          >
            <Cloud size={15} /> Connect
          </button>

          <details className="mt-4 text-xs text-muted-foreground">
            <summary className="cursor-pointer text-faint hover:text-muted-foreground">
              Don&apos;t have a Worker yet?
            </summary>
            <p className="mt-2 leading-relaxed">
              From a clone of the repo, run{" "}
              <code className="font-mono text-foreground">npm run setup</code> in{" "}
              <code className="font-mono text-foreground">sync/</code>. It creates
              the database, stores the hash of your passphrase, and deploys the
              Worker — then prints the URL to paste above. Full walkthrough is in{" "}
              <code className="font-mono text-foreground">sync/README.md</code>.
            </p>
          </details>
        </>
      )}
    </section>
  );
}

function Row({
  label,
  value,
  mono,
}: {
  label: string;
  value: string;
  mono?: boolean;
}) {
  return (
    <div className="flex flex-wrap items-baseline justify-between gap-2">
      <span className="text-xs text-faint">{label}</span>
      <span
        className={`min-w-0 break-all text-right text-sm ${mono ? "font-mono text-xs" : ""}`}
      >
        {value}
      </span>
    </div>
  );
}
