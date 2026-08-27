"use client";

import { useEffect } from "react";

import { BASE_PATH } from "@/lib/base-path";

/**
 * Registers the offline service worker. Kept out of the render tree — it only
 * runs an effect, and silently no-ops where service workers are unavailable
 * (Safari private browsing, insecure origins, older browsers).
 */
export function ServiceWorker() {
  useEffect(() => {
    if (process.env.NODE_ENV !== "production") return;
    if (!("serviceWorker" in navigator)) return;

    const scope = `${BASE_PATH}/`;
    navigator.serviceWorker
      .register(`${BASE_PATH}/sw.js`, { scope })
      .catch(() => {
        /* offline support is best-effort; the app works without it */
      });
  }, []);

  return null;
}
