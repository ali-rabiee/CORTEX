/** Visual smoke check against the static export. Usage:
 *    node scripts/screenshot.mjs [baseUrl]
 *  Screenshots land in /tmp/cortex-shots/.
 */
import { chromium } from "@playwright/test";
import * as fs from "node:fs";

const base = process.argv[2] ?? "http://localhost:4173";
const outDir = "/tmp/cortex-shots";
fs.mkdirSync(outDir, { recursive: true });

const browser = await chromium.launch();
const page = await browser.newPage({
  viewport: { width: 1440, height: 900 },
  colorScheme: "dark",
});

async function shot(path, name, action) {
  await page.goto(`${base}${path}`, { waitUntil: "networkidle" });
  if (action) await action(page);
  await page.screenshot({ path: `${outDir}/${name}.png`, fullPage: false });
  console.log(`✓ ${name}`);
}

await shot("/", "01-home");
await shot("/learn", "02-learn");
await shot("/concepts/ppo_clipping", "03-concept-l1");
await shot("/concepts/ppo_clipping", "04-concept-l2-math", async (p) => {
  // L2 is the next authored level only after L1 passes; on fresh DB L1 is open.
  // Pass L1 via the self-attest button, then open L2.
  await p.getByRole("button", { name: /Mark level 1 understood/i }).click();
  await p.getByRole("button", { name: /Keep going/i }).click();
  await p.getByRole("tab", { name: /L2/i }).click();
  await p.waitForTimeout(400);
});
await shot("/session", "05-session-idle");
await shot("/settings", "06-settings");

await browser.close();
console.log(`Screenshots in ${outDir}`);
