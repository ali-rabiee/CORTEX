import { defineConfig } from "@playwright/test";

/** E2E runs against the real static export (out/), not the dev server —
 * export-only bugs never show up under `next dev`. Run `npm run build` first. */
export default defineConfig({
  testDir: "./e2e",
  fullyParallel: false,
  use: {
    baseURL: "http://localhost:4621",
    colorScheme: "dark",
  },
  webServer: {
    command: "npx serve out -l 4621",
    url: "http://localhost:4621",
    reuseExistingServer: !process.env.CI,
  },
});
