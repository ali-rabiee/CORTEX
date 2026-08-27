/**
 * Persisted sync settings. Everything here lives in localStorage — it is
 * per-device configuration, not synced content.
 */

const KEYS = {
  endpoint: "cortex.sync.endpoint",
  passphrase: "cortex.sync.passphrase",
  remember: "cortex.sync.remember",
  baseVersion: "cortex.sync.baseVersion",
  lastSyncedRev: "cortex.sync.lastSyncedRev",
  lastSyncedAt: "cortex.sync.lastSyncedAt",
  device: "cortex.sync.device",
} as const;

function read(key: string): string | null {
  try {
    return globalThis.localStorage?.getItem(key) ?? null;
  } catch {
    return null;
  }
}

function write(key: string, value: string | null): void {
  try {
    if (value === null) globalThis.localStorage?.removeItem(key);
    else globalThis.localStorage?.setItem(key, value);
  } catch {
    /* private browsing — settings just won't persist */
  }
}

/** Trailing slashes break `${endpoint}/state`, so normalise them away. */
export function normaliseEndpoint(raw: string): string {
  return raw.trim().replace(/\/+$/, "");
}

export function getEndpoint(): string | null {
  const value = read(KEYS.endpoint);
  return value ? normaliseEndpoint(value) : null;
}

export function setEndpoint(endpoint: string | null): void {
  write(KEYS.endpoint, endpoint ? normaliseEndpoint(endpoint) : null);
}

export function getRememberPassphrase(): boolean {
  return read(KEYS.remember) !== "false";
}

export function setRememberPassphrase(remember: boolean): void {
  write(KEYS.remember, String(remember));
  if (!remember) write(KEYS.passphrase, null);
}

/**
 * The passphrase, if the user asked this device to remember it.
 *
 * This is a real trade-off and it is stated plainly in Settings: remembering it
 * means anyone who can use this unlocked device can open the app, while not
 * remembering it means retyping on every load. It never makes the *server* data
 * readable to anyone else either way.
 */
export function getStoredPassphrase(): string | null {
  return getRememberPassphrase() ? read(KEYS.passphrase) : null;
}

export function setStoredPassphrase(passphrase: string | null): void {
  if (passphrase === null || !getRememberPassphrase()) {
    write(KEYS.passphrase, null);
    return;
  }
  write(KEYS.passphrase, passphrase);
}

/** Remote version this device last successfully reconciled with. */
export function getBaseVersion(): number {
  return Number(read(KEYS.baseVersion) ?? 0) || 0;
}

export function setBaseVersion(version: number): void {
  write(KEYS.baseVersion, String(version));
}

/** Local revision at the moment of that reconciliation. */
export function getLastSyncedRev(): number {
  return Number(read(KEYS.lastSyncedRev) ?? 0) || 0;
}

export function setLastSyncedRev(rev: number): void {
  write(KEYS.lastSyncedRev, String(rev));
}

export function getLastSyncedAt(): string | null {
  return read(KEYS.lastSyncedAt);
}

export function setLastSyncedAt(iso: string | null): void {
  write(KEYS.lastSyncedAt, iso);
}

function guessPlatform(): string {
  const ua = globalThis.navigator?.userAgent ?? "";
  if (/iPhone|iPad|iPod/i.test(ua)) return "iOS";
  if (/Android/i.test(ua)) return "Android";
  if (/Mac OS X/i.test(ua)) return "Mac";
  if (/Windows/i.test(ua)) return "Windows";
  if (/Linux/i.test(ua)) return "Linux";
  return "Device";
}

/** Stable, human-readable label so conflict prompts can name the other device. */
export function getDeviceName(): string {
  const existing = read(KEYS.device);
  if (existing) return existing;
  const suffix = Math.random().toString(16).slice(2, 6);
  const name = `${guessPlatform()} · ${suffix}`;
  write(KEYS.device, name);
  return name;
}

export function setDeviceName(name: string): void {
  write(KEYS.device, name.slice(0, 64));
}

/** Forget this device's sync setup entirely (used by "Disconnect"). */
export function clearSyncConfig(): void {
  for (const key of Object.values(KEYS)) write(key, null);
}
