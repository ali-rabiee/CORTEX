"use client";

import confetti from "canvas-confetti";
import { motion, AnimatePresence } from "motion/react";
import { useEffect, useState } from "react";
import { createPortal } from "react-dom";

import { LevelRing } from "@/components/level-ring";
import { LEVEL_INFO, type Level } from "@/lib/content/schema";

export function LevelUpDialog({
  open,
  onClose,
  conceptTitle,
  level,
  xpGained,
  color,
}: {
  open: boolean;
  onClose: () => void;
  conceptTitle: string;
  level: Level;
  xpGained: number;
  color: string;
}) {
  // Portal so the dialog overlays even when its host level panel is hidden
  // (the tab rail auto-advances to the next level on pass).
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  useEffect(() => {
    if (!open) return;
    // Restrained burst — an earned moment, not a casino.
    confetti({
      particleCount: 70,
      spread: 65,
      origin: { y: 0.6 },
      colors: [color, "#6c63ff", "#e6edf3"],
      disableForReducedMotion: true,
    });
  }, [open, color]);

  if (!mounted) return null;

  return createPortal(
    <AnimatePresence>
      {open && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 flex items-center justify-center bg-background/80 p-4 backdrop-blur-sm"
          onClick={onClose}
        >
          <motion.div
            initial={{ scale: 0.9, y: 12 }}
            animate={{ scale: 1, y: 0 }}
            exit={{ scale: 0.95, opacity: 0 }}
            transition={{ type: "spring", stiffness: 320, damping: 26 }}
            className="w-full max-w-sm rounded-card border border-border bg-surface p-8 text-center shadow-2xl"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="mx-auto w-fit">
              <LevelRing
                color={color}
                completedLevels={level}
                size={88}
                strokeWidth={7}
              />
            </div>
            <h2 className="mt-5 text-xl font-bold">
              Level {level} passed
            </h2>
            <p className="mt-1 text-sm font-medium" style={{ color }}>
              {LEVEL_INFO[level].title} · {conceptTitle}
            </p>
            <motion.p
              initial={{ opacity: 0, y: 6 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.25 }}
              className="mt-4 inline-block rounded-full bg-primary/15 px-4 py-1.5 text-sm font-bold text-primary-light"
            >
              +{xpGained} XP
            </motion.p>
            <div className="mt-6">
              <button
                onClick={onClose}
                className="w-full rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
              >
                {level < 5 ? "Keep going" : "Concept mastered"}
              </button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>,
    document.body,
  );
}
