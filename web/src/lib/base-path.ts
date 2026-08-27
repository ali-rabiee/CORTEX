/**
 * Path prefix the app is served under. Empty for root-hosted deployments,
 * `/CORTEX` for the GitHub Pages project site. Inlined at build time by
 * `next.config.ts` so this is safe to read on the client.
 */
export const BASE_PATH = process.env.NEXT_PUBLIC_BASE_PATH ?? "";

/** Prefix an app-absolute path (`/icons/x.png`) with the deployment base path. */
export function withBasePath(path: string): string {
  return `${BASE_PATH}${path}`;
}
