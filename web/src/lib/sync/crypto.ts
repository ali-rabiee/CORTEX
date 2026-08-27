/**
 * Passphrase → keys, and the envelope format for synced progress.
 *
 * One passphrase produces two independent secrets:
 *
 *   passphrase --PBKDF2(210k, SHA-256)--> master
 *                                          ├─HKDF(info="auth")--> bearer token
 *                                          └─HKDF(info="enc") --> AES-GCM key
 *
 * The Worker only ever sees SHA-256 of the bearer token, so nothing stored
 * server-side can be walked back to the passphrase or to the data key. The
 * blob it stores is ciphertext.
 *
 * `sync/derive-token.mjs` reimplements the auth half for the CLI; the test
 * vector in `__tests__/crypto.test.ts` pins the two together.
 */

export const SALT = "cortex-sync-v1";
export const PBKDF2_ITERATIONS = 210_000;

const enc = new TextEncoder();
const dec = new TextDecoder();

export type SyncKeys = {
  /** Sent as `Authorization: Bearer …`. Hex, 64 chars. */
  authToken: string;
  /** AES-GCM key; never leaves the browser. */
  dataKey: CryptoKey;
};

function toHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

function toBase64(bytes: Uint8Array): string {
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary);
}

function fromBase64(value: string): Uint8Array<ArrayBuffer> {
  const binary = atob(value);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return bytes;
}

async function deriveMaster(passphrase: string): Promise<ArrayBuffer> {
  const material = await crypto.subtle.importKey(
    "raw",
    enc.encode(passphrase.normalize("NFKC")),
    "PBKDF2",
    false,
    ["deriveBits"],
  );
  return crypto.subtle.deriveBits(
    {
      name: "PBKDF2",
      salt: enc.encode(SALT),
      iterations: PBKDF2_ITERATIONS,
      hash: "SHA-256",
    },
    material,
    256,
  );
}

/** Roughly 200 ms of work — deliberately slow, so run it once and hold on. */
export async function deriveKeys(passphrase: string): Promise<SyncKeys> {
  const master = await deriveMaster(passphrase);
  const hkdf = await crypto.subtle.importKey("raw", master, "HKDF", false, [
    "deriveBits",
    "deriveKey",
  ]);

  const authBits = await crypto.subtle.deriveBits(
    { name: "HKDF", hash: "SHA-256", salt: enc.encode(SALT), info: enc.encode("auth") },
    hkdf,
    256,
  );
  const dataKey = await crypto.subtle.deriveKey(
    { name: "HKDF", hash: "SHA-256", salt: enc.encode(SALT), info: enc.encode("enc") },
    hkdf,
    { name: "AES-GCM", length: 256 },
    false,
    ["encrypt", "decrypt"],
  );

  return { authToken: toHex(authBits), dataKey };
}

/** Encrypt a JSON-serialisable value into `base64(iv ‖ ciphertext)`. */
export async function encryptJson(
  key: CryptoKey,
  value: unknown,
): Promise<string> {
  const iv = crypto.getRandomValues(new Uint8Array(12));
  const ciphertext = await crypto.subtle.encrypt(
    { name: "AES-GCM", iv },
    key,
    enc.encode(JSON.stringify(value)),
  );
  const packed = new Uint8Array(iv.length + ciphertext.byteLength);
  packed.set(iv, 0);
  packed.set(new Uint8Array(ciphertext), iv.length);
  return toBase64(packed);
}

export class DecryptionError extends Error {
  constructor() {
    super("Could not decrypt the synced data — wrong passphrase?");
    this.name = "DecryptionError";
  }
}

export async function decryptJson(key: CryptoKey, blob: string): Promise<unknown> {
  let packed: Uint8Array<ArrayBuffer>;
  try {
    packed = fromBase64(blob);
  } catch {
    throw new DecryptionError();
  }
  if (packed.length <= 12) throw new DecryptionError();

  try {
    const plaintext = await crypto.subtle.decrypt(
      { name: "AES-GCM", iv: packed.subarray(0, 12) },
      key,
      packed.subarray(12),
    );
    return JSON.parse(dec.decode(plaintext));
  } catch {
    // AES-GCM authenticates, so a wrong key fails here rather than yielding junk.
    throw new DecryptionError();
  }
}
