const CACHE = 'labreagenser-v16';

const APP_SHELL = [
  './',
  './index.html',
  './manifest.json',
  './icon.svg',
  './icon-180.png',
  './icon-192.png',
];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE)
      .then(c => c.addAll(APP_SHELL))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k.startsWith('labreagenser-') && k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);

  // Never intercept API calls
  if (url.hostname === 'api.anthropic.com') return;

  // CDN resources (React): cache on first fetch, serve from cache thereafter
  if (url.hostname === 'unpkg.com') {
    e.respondWith(
      caches.open(CACHE).then(cache =>
        cache.match(e.request).then(hit => {
          if (hit) return hit;
          return fetch(e.request).then(resp => {
            if (resp.ok) cache.put(e.request, resp.clone());
            return resp;
          });
        })
      )
    );
    return;
  }

  // App files: serve from cache, fall back to network (never database or other external calls)
  if (e.request.method !== 'GET' || url.origin !== self.location.origin) return;
  e.respondWith(
    caches.match(e.request).then(hit => hit || fetch(e.request).then(resp => {
      if (resp.ok) caches.open(CACHE).then(c => c.put(e.request, resp.clone()));
      return resp;
    }))
  );
});
