import { describe, expect, test } from "vitest";

import { DecryptionError, decryptJson, deriveKeys, encryptJson } from "../crypto";

const PASSPHRASE = "correct horse battery staple";

describe("deriveKeys", () => {
  // Pinned against `node sync/derive-token.mjs`. If this fails, the browser and
  // the CLI that provisions the Worker secret have drifted apart, and every
  // existing user's token would stop matching.
  test("matches the CLI test vector", async () => {
    const { authToken } = await deriveKeys(PASSPHRASE);
    expect(authToken).toBe(
      "7e73ff911acbe9e713e73ade2a16bd9896ef8bea4421b6e01e5db1120142e3de",
    );
  });

  test("different passphrases give different tokens", async () => {
    const a = await deriveKeys(PASSPHRASE);
    const b = await deriveKeys(`${PASSPHRASE}!`);
    expect(a.authToken).not.toBe(b.authToken);
  });

  test("normalises unicode so the same typed passphrase always works", async () => {
    // "é" as one codepoint vs. "e" + combining acute.
    const a = await deriveKeys("café passphrase");
    const b = await deriveKeys("café passphrase");
    expect(a.authToken).toBe(b.authToken);
  });
});

describe("encryptJson / decryptJson", () => {
  test("round-trips a backup-shaped payload", async () => {
    const { dataKey } = await deriveKeys(PASSPHRASE);
    const payload = { app: "cortex", data: { reviewCards: [{ conceptId: "ppo" }] } };
    expect(await decryptJson(dataKey, await encryptJson(dataKey, payload))).toEqual(
      payload,
    );
  });

  test("uses a fresh IV per encryption", async () => {
    const { dataKey } = await deriveKeys(PASSPHRASE);
    expect(await encryptJson(dataKey, { a: 1 })).not.toBe(
      await encryptJson(dataKey, { a: 1 }),
    );
  });

  test("rejects the wrong passphrase instead of returning garbage", async () => {
    const good = await deriveKeys(PASSPHRASE);
    const bad = await deriveKeys("some other passphrase");
    const blob = await encryptJson(good.dataKey, { secret: true });
    await expect(decryptJson(bad.dataKey, blob)).rejects.toBeInstanceOf(
      DecryptionError,
    );
  });

  test("rejects tampered ciphertext", async () => {
    const { dataKey } = await deriveKeys(PASSPHRASE);
    const blob = await encryptJson(dataKey, { secret: true });
    const tampered = `${blob.slice(0, -6)}AAAAA=`;
    await expect(decryptJson(dataKey, tampered)).rejects.toBeInstanceOf(
      DecryptionError,
    );
  });
});
