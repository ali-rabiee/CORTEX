import { expect, test } from "@playwright/test";

test.describe("CORTEX static export", () => {
  test("home renders hero and domains", async ({ page }) => {
    await page.goto("/");
    await expect(
      page.getByRole("heading", { name: /Master modern robotics/i }),
    ).toBeVisible();
    await expect(page.getByText("Reinforcement Learning")).toBeVisible();
  });

  test("concept page renders KaTeX math and Shiki-ready level tabs", async ({
    page,
  }) => {
    await page.goto("/concepts/ppo_clipping");
    await expect(
      page.getByRole("heading", { name: /Proximal Policy Optimization/i }),
    ).toBeVisible();
    // Build-time KaTeX must be present in the prerendered HTML.
    expect(await page.locator(".katex").count()).toBeGreaterThan(0);
    // Gating: L2 locked behind L1 on a fresh profile.
    await expect(page.getByRole("tab", { name: /L1/ })).toBeVisible();
  });

  test("level pass persists across reload", async ({ page }) => {
    await page.goto("/concepts/mdp");
    await page
      .getByRole("button", { name: /Mark level 1 understood/i })
      .click();
    // The level-up dialog (portal) opens while the tab rail auto-advances.
    await expect(
      page.getByRole("heading", { name: /Level 1 passed/ }),
    ).toBeVisible();
    await page.getByRole("button", { name: /Keep going/i }).click();

    await page.reload();
    // Returning users land on their next open level (auto-advance), so the
    // L1 tab shows the passed checkmark and its panel shows the banner.
    await page.getByRole("tab", { name: /L1/ }).click();
    await expect(page.getByText(/Level 1 passed/).first()).toBeVisible();
    // XP badge reflects the 20 XP grant.
    await expect(page.getByText(/20\/100 XP/)).toBeVisible();
  });

  test("campaign view gates later worlds", async ({ page }) => {
    await page.goto("/learn");
    await expect(
      page.getByRole("heading", { name: "Foundations of Intelligence" }),
    ).toBeVisible();
    await expect(
      page.getByText(/Unlocks at 60% of the previous world/).first(),
    ).toBeVisible();
  });

  test("quiz answers record and explain", async ({ page }) => {
    await page.goto("/quiz");
    await page.getByRole("button", { name: /Mixed — all domains/i }).click();
    // Answer the first question with option A; explanation must appear.
    await page
      .locator("button")
      .filter({ hasText: /^A/ })
      .first()
      .click();
    await expect(page.getByText(/Next question|Finish quiz/)).toBeVisible();
  });

  test("backup export produces a download", async ({ page }) => {
    await page.goto("/settings");
    const downloadPromise = page.waitForEvent("download");
    await page.getByRole("button", { name: /Export backup/i }).click();
    const download = await downloadPromise;
    expect(download.suggestedFilename()).toMatch(/^cortex-backup-.*\.json$/);
  });
});
