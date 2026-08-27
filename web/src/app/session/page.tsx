import type { Metadata } from "next";

import { SessionPlayer } from "@/components/session/session-player";
import { buildSessionManifest } from "@/lib/content/manifest-server";

export const metadata: Metadata = { title: "Session" };

export default function SessionPage() {
  const manifest = buildSessionManifest();
  return <SessionPlayer manifest={manifest} />;
}
