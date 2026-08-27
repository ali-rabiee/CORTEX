"use client";

import { BrainCircuit, Loader2, LockKeyhole } from "lucide-react";
import { useEffect, useState, type FormEvent } from "react";

import { useSync } from "@/lib/sync/provider";

/**
 * Passphrase prompt shown when this device has sync configured but no key in
 * memory.
 *
 * Worth being precise about what this does: the app itself is a public static
 * page, so this is not a wall around the *code* or the *content*. It is the
 * gate on your progress data — without the passphrase, the sync server refuses
 * the request and the stored snapshot stays undecryptable.
 */
export function SyncGate() {
  const { status, error, unlock, disconnect, rememberPassphrase } = useSync();
  const [passphrase, setPassphrase] = useState("");
  const [remember, setRemember] = useState(rememberPassphrase);

  useEffect(() => setRemember(rememberPassphrase), [rememberPassphrase]);

  if (status !== "locked" && status !== "unlocking") return null;

  const busy = status === "unlocking";

  const onSubmit = async (event: FormEvent) => {
    event.preventDefault();
    if (!passphrase || busy) return;
    try {
      await unlock(passphrase, remember);
      setPassphrase("");
    } catch {
      /* surfaced via `error` */
    }
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-background px-5 py-[env(safe-area-inset-top)]">
      <div className="w-full max-w-sm">
        <div className="flex items-center gap-2.5">
          <span className="rounded-lg bg-primary/20 p-1.5 text-primary-light">
            <BrainCircuit size={20} strokeWidth={2.2} />
          </span>
          <span className="text-lg font-bold tracking-tight">CORTEX</span>
        </div>

        <h1 className="mt-7 flex items-center gap-2 text-xl font-bold tracking-tight">
          <LockKeyhole size={18} className="text-primary-light" /> Unlock
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
          Your passphrase decrypts your progress and authenticates you to the
          sync server. It never leaves this device.
        </p>

        <form onSubmit={onSubmit} className="mt-5">
          <label htmlFor="passphrase" className="sr-only">
            Passphrase
          </label>
          <input
            id="passphrase"
            type="password"
            autoComplete="current-password"
            autoFocus
            value={passphrase}
            onChange={(e) => setPassphrase(e.target.value)}
            placeholder="Passphrase"
            disabled={busy}
            className="w-full rounded-lg border border-border bg-surface px-4 py-3 text-base outline-none transition-colors placeholder:text-faint focus:border-primary disabled:opacity-60"
          />

          <label className="mt-3 flex items-center gap-2.5 text-sm text-muted-foreground">
            <input
              type="checkbox"
              checked={remember}
              onChange={(e) => setRemember(e.target.checked)}
              className="size-4 accent-[var(--color-primary)]"
            />
            Stay unlocked on this device
          </label>

          {error && <p className="mt-3 text-sm text-danger">{error}</p>}

          <button
            type="submit"
            disabled={busy || passphrase.length === 0}
            className="mt-5 flex w-full items-center justify-center gap-2 rounded-lg bg-primary px-4 py-3 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark disabled:opacity-50"
          >
            {busy && <Loader2 size={15} className="animate-spin" />}
            {busy ? "Unlocking…" : "Unlock"}
          </button>
        </form>

        <button
          type="button"
          onClick={() => {
            if (
              window.confirm(
                "Turn off sync on this device? Your progress stays on the server and on your other devices — you can reconnect any time with the same passphrase.",
              )
            ) {
              disconnect();
            }
          }}
          className="mt-6 w-full text-center text-xs text-faint underline underline-offset-4 transition-colors hover:text-muted-foreground"
        >
          Forgot it? Use this device offline instead
        </button>
      </div>
    </div>
  );
}
