import type { MetadataRoute } from "next";

import { withBasePath } from "@/lib/base-path";

// Required by `output: "export"` — emit the manifest as a static file.
export const dynamic = "force-static";

/**
 * Web app manifest. Next prefixes the <link> href with basePath automatically,
 * but the URLs *inside* the manifest are ours to build.
 */
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "CORTEX — Daily Cognitive Training",
    short_name: "CORTEX",
    description:
      "Leveled robotics/ML concepts with spaced repetition, daily sessions, and mastery tracking.",
    start_url: withBasePath("/"),
    scope: withBasePath("/"),
    display: "standalone",
    orientation: "portrait",
    background_color: "#0d1117",
    theme_color: "#0d1117",
    categories: ["education", "productivity"],
    icons: [
      {
        src: withBasePath("/icons/icon-192.png"),
        sizes: "192x192",
        type: "image/png",
        purpose: "any",
      },
      {
        src: withBasePath("/icons/icon-512.png"),
        sizes: "512x512",
        type: "image/png",
        purpose: "any",
      },
      {
        src: withBasePath("/icons/maskable-192.png"),
        sizes: "192x192",
        type: "image/png",
        purpose: "maskable",
      },
      {
        src: withBasePath("/icons/maskable-512.png"),
        sizes: "512x512",
        type: "image/png",
        purpose: "maskable",
      },
    ],
  };
}
