import { withContentCollections } from "@content-collections/next";
import type { NextConfig } from "next";

// For GitHub Pages project sites set NEXT_BASE_PATH=/CORTEX at build time.
const basePath = process.env.NEXT_BASE_PATH ?? "";

const nextConfig: NextConfig = {
  output: "export",
  images: { unoptimized: true },
  basePath: basePath || undefined,
  // Emit `learn/index.html` rather than `learn.html`. Static hosts then serve
  // both `/learn` and `/learn/`, and — under a basePath — Next's RSC prefetch
  // resolves to `<base>/index.txt` instead of 404ing on `<base>.txt`.
  trailingSlash: true,
  env: {
    // Inlined at build time so client components and the manifest can build
    // correct absolute paths under the Pages subdirectory.
    NEXT_PUBLIC_BASE_PATH: basePath,
  },
};

export default withContentCollections(nextConfig);
