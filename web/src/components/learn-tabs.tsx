"use client";

import { LayoutGrid, Route } from "lucide-react";
import { useState, type ReactNode } from "react";

/** Toggles between the campaign path and the flat concept browser. Both are
 * server-rendered; this only flips visibility. */
export function LearnTabs({
  path,
  browse,
}: {
  path: ReactNode;
  browse: ReactNode;
}) {
  const [view, setView] = useState<"path" | "browse">("path");

  return (
    <div>
      <div className="mb-6 inline-flex rounded-lg border border-border bg-surface p-1">
        {(
          [
            { id: "path", label: "Campaign", icon: Route },
            { id: "browse", label: "All concepts", icon: LayoutGrid },
          ] as const
        ).map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            onClick={() => setView(id)}
            className={`inline-flex items-center gap-2 rounded-md px-3.5 py-1.5 text-sm font-medium transition-colors ${
              view === id
                ? "bg-primary/20 text-primary-light"
                : "text-muted-foreground hover:text-foreground"
            }`}
          >
            <Icon size={14} /> {label}
          </button>
        ))}
      </div>
      <div hidden={view !== "path"}>{path}</div>
      <div hidden={view !== "browse"}>{browse}</div>
    </div>
  );
}
