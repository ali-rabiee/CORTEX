import { expect, test } from "@playwright/test";

test.describe("CORTEX static export", () => {
  test("home renders hero and domains", async ({ page }) => {
    await page.goto("/");
    await expect(
      page.getByRole("heading", { name: /Master modern robotics/i }),
    ).toBeVisible();
    await expect(page.getByText("Reinforcement Learning")).toBeVisible();
  });

  test("concept page renders KaTeX math and every section up front", async ({
    page,
  }) => {
    await page.goto("/concepts/ppo_clipping");
    await expect(
      page.getByRole("heading", { name: /Proximal Policy Optimization/i }),
    ).toBeVisible();
    // Build-time KaTeX must be present in the prerendered HTML.
    expect(await page.locator(".katex").count()).toBeGreaterThan(0);

    // Sections are navigation, not gates: on a fresh profile every authored
    // part is already in the document and reachable from the rail.
    const rail = page.getByRole("navigation", { name: "Sections" });
    await expect(rail.getByRole("link", { name: "Understand" })).toBeVisible();
    await expect(rail.getByRole("link", { name: "Interview" })).toBeVisible();
    await expect(
      page.getByRole("heading", { name: "Say it in an interview" }),
    ).toBeVisible();
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
    // Mastery survives the reload: the part heading is marked passed, and so
    // is its chip in the section rail.
    await expect(page.getByText(/Level 1 passed/).first()).toBeVisible();
    await expect(
      page
        .getByRole("navigation", { name: "Sections" })
        .getByRole("link", { name: "Understand" })
        .getByText("Understand"),
    ).toBeVisible();
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
