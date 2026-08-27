import type { Metadata } from "next";

import { ProgressDashboard } from "@/components/progress/progress-dashboard";
import { buildSessionManifest } from "@/lib/content/manifest-server";

export const metadata: Metadata = { title: "Progress" };

export default function ProgressPage() {
  const manifest = buildSessionManifest();
  return (
    <div className="mx-auto max-w-5xl px-4 py-8 md:px-8">
      <header className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight">Progress</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Mastery, calibration, and consistency — the three things that decay
          if you stop.
        </p>
      </header>
      <ProgressDashboard manifest={manifest} />
    </div>
  );
}
