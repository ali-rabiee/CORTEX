import type { Domain } from "@/lib/content/schema";

/** Hex values mirror the @theme tokens in globals.css. Used where colors are
 * chosen dynamically (inline styles), since Tailwind can't see runtime class
 * names. */
export const DOMAIN_HEX: Record<Domain, string> = {
  ml_fundamentals: "#e3b341",
  rl: "#58a6ff",
  robot_learning: "#3fb950",
  perception: "#d2a8ff",
  foundation_models: "#f0883e",
  generative_control: "#f778ba",
  systems: "#79c0ff",
};
