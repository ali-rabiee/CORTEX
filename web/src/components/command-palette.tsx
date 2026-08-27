"use client";

import { Command } from "cmdk";
import { Search } from "lucide-react";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

import { DOMAIN_LABELS, type Domain } from "@/lib/content/schema";
import { DOMAIN_HEX } from "@/lib/domains";

export type PaletteConcept = { id: string; title: string; domain: Domain };

/** ⌘K / Ctrl+K concept search. */
export function CommandPalette({ concepts }: { concepts: PaletteConcept[] }) {
  const [open, setOpen] = useState(false);
  const router = useRouter();

  useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if (e.key === "k" && (e.metaKey || e.ctrlKey)) {
        e.preventDefault();
        setOpen((o) => !o);
      }
    };
    document.addEventListener("keydown", down);
    return () => document.removeEventListener("keydown", down);
  }, []);

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="mb-4 flex w-full items-center gap-2 rounded-lg border border-border bg-card px-3 py-2 text-xs text-faint transition-colors hover:border-border-strong hover:text-muted-foreground"
      >
        <Search size={13} />
        Search concepts
        <kbd className="ml-auto rounded border border-border bg-surface px-1.5 py-0.5 text-[0.6rem]">
          ⌘K
        </kbd>
      </button>

      <Command.Dialog
        open={open}
        onOpenChange={setOpen}
        label="Search concepts"
        className="fixed inset-x-4 top-[15vh] z-50 mx-auto max-w-lg overflow-hidden rounded-card border border-border-strong bg-surface shadow-2xl"
      >
        <div className="flex items-center gap-2 border-b border-border px-4">
          <Search size={15} className="shrink-0 text-faint" />
          <Command.Input
            placeholder="Search 89 concepts…"
            className="h-12 w-full bg-transparent text-sm outline-none placeholder:text-faint"
          />
        </div>
        <Command.List className="max-h-72 overflow-y-auto p-2">
          <Command.Empty className="p-4 text-center text-sm text-faint">
            No concepts found.
          </Command.Empty>
          {concepts.map((c) => (
            <Command.Item
              key={c.id}
              value={`${c.title} ${c.id} ${DOMAIN_LABELS[c.domain]}`}
              onSelect={() => {
                setOpen(false);
                router.push(`/concepts/${c.id}`);
              }}
              className="flex cursor-pointer items-center gap-2.5 rounded-lg px-3 py-2 text-sm data-[selected=true]:bg-primary/15"
            >
              <span
                className="size-1.5 shrink-0 rounded-full"
                style={{ background: DOMAIN_HEX[c.domain] }}
              />
              <span className="truncate">{c.title}</span>
              <span className="ml-auto shrink-0 text-[0.65rem] text-faint">
                {DOMAIN_LABELS[c.domain]}
              </span>
            </Command.Item>
          ))}
        </Command.List>
      </Command.Dialog>

      {open && (
        <div
          className="fixed inset-0 z-40 bg-background/70 backdrop-blur-sm"
          onClick={() => setOpen(false)}
        />
      )}
    </>
  );
}
