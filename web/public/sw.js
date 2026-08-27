/**
 * CORTEX service worker — offline support for the static export.
 *
 * Deliberately conservative:
 *   - Content-hashed assets under /_next/static/ are immutable, so cache-first.
 *   - Everything else (navigations included) is network-first with a cache
 *     fallback, so a deploy is picked up on the next online load instead of
 *     pinning you to a stale build.
 */

const VERSION = "v1";
const CACHE = `cortex-${VERSION}`;

// Scope is the deployment root, e.g. "https://user.github.io/CORTEX/".
const SCOPE = new URL(self.registration.scope);

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches
      .open(CACHE)
      .then((cache) => cache.add(new Request(SCOPE.pathname, { cache: "reload" })))
      .catch(() => undefined)
      .then(() => self.skipWaiting()),
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches
      .keys()
      .then((keys) =>
        Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))),
      )
      .then(() => self.clients.claim()),
  );
});

function isImmutable(url) {
  return (
    url.pathname.includes("/_next/static/") || url.pathname.includes("/icons/")
  );
}

async function cacheFirst(request) {
  const cached = await caches.match(request);
  if (cached) return cached;
  const response = await fetch(request);
  if (response.ok) {
    const cache = await caches.open(CACHE);
    cache.put(request, response.clone());
  }
  return response;
}

async function networkFirst(request) {
  try {
    const response = await fetch(request);
    if (response.ok && response.type === "basic") {
      const cache = await caches.open(CACHE);
      cache.put(request, response.clone());
    }
    return response;
  } catch (err) {
    const cached = await caches.match(request);
    if (cached) return cached;
    if (request.mode === "navigate") {
      const shell = await caches.match(SCOPE.pathname);
      if (shell) return shell;
    }
    throw err;
  }
}

self.addEventListener("fetch", (event) => {
  const { request } = event;
  if (request.method !== "GET") return;

  const url = new URL(request.url);
  if (url.origin !== SCOPE.origin) return;
  if (!url.pathname.startsWith(SCOPE.pathname)) return;

  event.respondWith(isImmutable(url) ? cacheFirst(request) : networkFirst(request));
});
