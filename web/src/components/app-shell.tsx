import { BrainCircuit } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { CommandPalette, type PaletteConcept } from "./command-palette";
import { BottomNav, SidebarNav } from "./nav";
import { ConflictDialog } from "./sync/conflict-dialog";
import { SyncGate } from "./sync/sync-gate";
import { SyncStatusPill } from "./sync/sync-status";
import { XpBadge } from "./xp-badge";
import { SyncProvider } from "@/lib/sync/provider";

export function AppShell({
  children,
  concepts,
}: {
  children: ReactNode;
  concepts: PaletteConcept[];
}) {
  return (
    <SyncProvider>
      {/* `id` is the hook the pre-paint lock script in layout.tsx hides. */}
      <div id="app-root" className="flex min-h-dvh">
        <aside className="fixed inset-y-0 left-0 z-30 hidden w-56 flex-col border-r border-border bg-surface/60 p-4 md:flex">
          <Link href="/" className="mb-8 flex items-center gap-2.5 px-2">
            <span className="rounded-lg bg-primary/20 p-1.5 text-primary-light">
              <BrainCircuit size={20} strokeWidth={2.2} />
            </span>
            <span className="text-lg font-bold tracking-tight">CORTEX</span>
          </Link>
          <XpBadge />
          <CommandPalette concepts={concepts} />
          <SidebarNav />
          <div className="mt-auto">
            <SyncStatusPill />
            <div className="px-2 text-[0.7rem] leading-relaxed text-faint">
              Daily cognitive training
              <br />
              for robotics &amp; ML
            </div>
          </div>
        </aside>
        <main className="min-w-0 flex-1 pb-[calc(5rem+env(safe-area-inset-bottom))] md:ml-56 md:pb-0">
          {children}
        </main>
        <BottomNav />
      </div>
      <SyncGate />
      <ConflictDialog />
    </SyncProvider>
  );
}
