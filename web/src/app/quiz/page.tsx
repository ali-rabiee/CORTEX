import type { Metadata } from "next";

import { QuizPlayer } from "@/components/quiz/quiz-player";
import { buildSessionManifest } from "@/lib/content/manifest-server";

export const metadata: Metadata = { title: "Quiz" };

export default function QuizPage() {
  const manifest = buildSessionManifest();
  return <QuizPlayer manifest={manifest} />;
}
