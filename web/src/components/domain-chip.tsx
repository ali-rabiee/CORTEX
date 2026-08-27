import { DOMAIN_LABELS, type Domain } from "@/lib/content/schema";
import { DOMAIN_HEX } from "@/lib/domains";

export function DomainChip({
  domain,
  size = "sm",
}: {
  domain: Domain;
  size?: "sm" | "md";
}) {
  const color = DOMAIN_HEX[domain];
  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-full font-medium ${
        size === "sm" ? "px-2 py-0.5 text-[0.7rem]" : "px-2.5 py-1 text-xs"
      }`}
      style={{
        color,
        background: `color-mix(in srgb, ${color} 12%, transparent)`,
        border: `1px solid color-mix(in srgb, ${color} 30%, transparent)`,
      }}
    >
      <span
        className="size-1.5 rounded-full"
        style={{ background: color }}
        aria-hidden
      />
      {DOMAIN_LABELS[domain]}
    </span>
  );
}
