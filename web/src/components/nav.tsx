"use client";

import {
  BarChart3,
  Home,
  ListChecks,
  Map,
  Settings,
  Zap,
  type LucideIcon,
} from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";

const NAV_ITEMS: Array<{ href: string; label: string; icon: LucideIcon }> = [
  { href: "/", label: "Home", icon: Home },
  { href: "/learn", label: "Learn", icon: Map },
  { href: "/session", label: "Session", icon: Zap },
  { href: "/quiz", label: "Quiz", icon: ListChecks },
  { href: "/progress", label: "Progress", icon: BarChart3 },
  { href: "/settings", label: "Settings", icon: Settings },
];

function isActive(pathname: string, href: string): boolean {
  if (href === "/") return pathname === "/";
  if (href === "/learn") {
    return pathname.startsWith("/learn") || pathname.startsWith("/concepts");
  }
  return pathname.startsWith(href);
}

export function SidebarNav() {
  const pathname = usePathname();
  return (
    <nav className="flex flex-col gap-1">
      {NAV_ITEMS.map(({ href, label, icon: Icon }) => {
        const active = isActive(pathname, href);
        return (
          <Link
            key={href}
            href={href}
            className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
              active
                ? "bg-primary/15 text-primary-light"
                : "text-muted-foreground hover:bg-card hover:text-foreground"
            }`}
          >
            <Icon size={17} strokeWidth={active ? 2.4 : 2} />
            {label}
          </Link>
        );
      })}
    </nav>
  );
}

export function BottomNav() {
  const pathname = usePathname();
  return (
    <nav className="fixed inset-x-0 bottom-0 z-40 flex items-stretch justify-around border-t border-border bg-surface/95 pb-[env(safe-area-inset-bottom)] backdrop-blur md:hidden">
      {NAV_ITEMS.map(({ href, label, icon: Icon }) => {
        const active = isActive(pathname, href);
        return (
          <Link
            key={href}
            href={href}
            className={`flex min-h-11 flex-1 flex-col items-center justify-center gap-0.5 py-2 text-[0.65rem] font-medium ${
              active ? "text-primary-light" : "text-muted-foreground"
            }`}
          >
            <Icon size={19} strokeWidth={active ? 2.4 : 2} />
            {label}
          </Link>
        );
      })}
    </nav>
  );
}
