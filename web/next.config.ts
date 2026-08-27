import { withContentCollections } from "@content-collections/next";
import type { NextConfig } from "next";

// For GitHub Pages project sites set NEXT_BASE_PATH=/CORTEX at build time.
const basePath = process.env.NEXT_BASE_PATH ?? "";

const nextConfig: NextConfig = {
  output: "export",
  images: { unoptimized: true },
  basePath: basePath || undefined,
  env: {
    // Inlined at build time so client components and the manifest can build
    // correct absolute paths under the Pages subdirectory.
    NEXT_PUBLIC_BASE_PATH: basePath,
  },
};

export default withContentCollections(nextConfig);
