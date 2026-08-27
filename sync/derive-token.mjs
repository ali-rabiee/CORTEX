#!/usr/bin/env node
/**
 * Derives the value for the SYNC_TOKEN_SHA256 Worker secret from your passphrase.
 *
 *   node derive-token.mjs                 # prompts (input hidden)
 *   node derive-token.mjs --token         # also print the raw bearer token
 *
 * This mirrors web/src/lib/sync/crypto.ts exactly; the web app's crypto tests
 * pin both to the same vector so the two cannot drift apart.
 *
 * The passphrase never leaves your machine, and the printed digest cannot be
 * turned back into the passphrase or into the key that encrypts your data.
 */

import { createInterface } from "node:readline";
import { Writable } from "node:stream";
import { webcrypto as crypto } from "node:crypto";

export const SALT = "cortex-sync-v1";
export const PBKDF2_ITERATIONS = 210000;

const enc = new TextEncoder();

function hex(buffer) {
  return [...new Uint8Array(buffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

/**
 * passphrase --PBKDF2--> master --HKDF(info)--> per-purpose key material.
 * "auth" produces the bearer token; "enc" produces the AES-GCM data key. They
 * are computationally independent, so the server holding one learns nothing
 * about the other.
 */
export async function deriveMaster(passphrase) {
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

export async function deriveAuthToken(passphrase) {
  const master = await deriveMaster(passphrase);
  const key = await crypto.subtle.importKey("raw", master, "HKDF", false, [
    "deriveBits",
  ]);
  const bits = await crypto.subtle.deriveBits(
    {
      name: "HKDF",
      hash: "SHA-256",
      salt: enc.encode(SALT),
      info: enc.encode("auth"),
    },
    key,
    256,
  );
  return hex(bits);
}

export async function sha256Hex(input) {
  return hex(await crypto.subtle.digest("SHA-256", enc.encode(input)));
}

/** Prompt on stderr with the typed characters suppressed. */
function promptHidden(question) {
  // Piped input (CI, `echo … | npm run token`): just read the line.
  if (!process.stdin.isTTY) {
    return new Promise((resolve) => {
      let data = "";
      process.stdin.setEncoding("utf8");
      process.stdin.on("data", (chunk) => (data += chunk));
      process.stdin.on("end", () => resolve(data.split("\n")[0]));
    });
  }

  let muted = false;
  const output = new Writable({
    write(chunk, encoding, callback) {
      if (!muted) process.stderr.write(chunk, encoding);
      callback();
    },
  });
  const rl = createInterface({ input: process.stdin, output, terminal: true });
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      process.stderr.write("\n");
      resolve(answer);
    });
    muted = true;
  });
}

async function main() {
  const showToken = process.argv.includes("--token");
  const passphrase = (await promptHidden("Passphrase: ")).trim();
  if (passphrase.length < 12) {
    console.error("Refusing: use at least 12 characters — this passphrase is the");
    console.error("only thing standing between the internet and your progress data.");
    process.exit(1);
  }

  const token = await deriveAuthToken(passphrase);
  if (showToken) {
    console.error("\nBearer token (what the browser sends):");
    console.log(token);
    console.error("");
  }
  console.error("SYNC_TOKEN_SHA256 (what the Worker stores):");
  console.log(await sha256Hex(token));
}

if (import.meta.url === `file://${process.argv[1]}`) {
  await main();
}
