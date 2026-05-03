// Boby Service Worker - Cache-first strategy for offline support
const CACHE_NAME = 'boby-cache-v1';
const STATIC_ASSETS = [
  '/',
  '/index.html',
  '/flutter_bootstrap.js',
  '/flutter.js',
  '/manifest.json',
  '/main.dart.js',
  '/assets/AssetManifest.json',
  '/assets/AssetManifest.bin',
  '/assets/FontManifest.json',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  '/splash/img/light-1x.png',
  '/splash/img/light-2x.png',
  '/splash/img/light-3x.png',
  '/splash/img/light-4x.png',
];

// Install event - cache static assets
self.addEventListener('install', (event) => {
  console.log('[Service Worker] Installing...');
  
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[Service Worker] Caching static assets');
        return cache.addAll(STATIC_ASSETS);
      })
      .then(() => {
        console.log('[Service Worker] Skip waiting');
        return self.skipWaiting();
      })
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('[Service Worker] Activating...');
  
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('[Service Worker] Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => {
      console.log('[Service Worker] Claiming clients');
      return self.clients.claim();
    })
  );
});

// Fetch event - serve from cache, fall back to network
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);
  
  // Skip non-GET requests
  if (request.method !== 'GET') {
    return;
  }
  
  // Skip Firebase and analytics requests
  if (url.hostname.includes('google') || 
      url.hostname.includes('firebase') ||
      url.hostname.includes('analytics')) {
    return;
  }
  
  // Cache-first strategy for assets
  if (url.pathname.startsWith('/assets/') || 
      url.pathname.startsWith('/icons/') ||
      url.pathname.startsWith('/splash/') ||
      url.pathname.endsWith('.png') ||
      url.pathname.endsWith('.jpg') ||
      url.pathname.endsWith('.jpeg') ||
      url.pathname.endsWith('.gif') ||
      url.pathname.endsWith('.svg') ||
      url.pathname.endsWith('.mp3') ||
      url.pathname.endsWith('.wav') ||
      url.pathname.endsWith('.mp4') ||
      url.pathname.endsWith('.otf') ||
      url.pathname.endsWith('.ttf') ||
      url.pathname.endsWith('.woff') ||
      url.pathname.endsWith('.woff2')) {
    
    event.respondWith(
      caches.match(request).then((cachedResponse) => {
        if (cachedResponse) {
          // Return cached version
          console.log('[Service Worker] Serving from cache:', url.pathname);
          return cachedResponse;
        }
        
        // Fetch and cache
        return fetch(request).then((networkResponse) => {
          if (!networkResponse || networkResponse.status !== 200 || networkResponse.type !== 'basic') {
            return networkResponse;
          }
          
          const responseToCache = networkResponse.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(request, responseToCache);
          });
          
          return networkResponse;
        });
      })
    );
    return;
  }
  
  // Network-first strategy for HTML and main files
  if (url.pathname === '/' || 
      url.pathname === '/index.html' ||
      url.pathname.endsWith('.js') ||
      url.pathname.endsWith('.dart.js')) {
    
    event.respondWith(
      fetch(request)
        .then((networkResponse) => {
          if (!networkResponse || networkResponse.status !== 200) {
            throw new Error('Network response was not ok');
          }
          
          // Update cache
          const responseToCache = networkResponse.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(request, responseToCache);
          });
          
          return networkResponse;
        })
        .catch(() => {
          // Fall back to cache
          console.log('[Service Worker] Serving from cache (fallback):', url.pathname);
          return caches.match(request);
        })
    );
    return;
  }
  
  // Default: try cache first, then network
  event.respondWith(
    caches.match(request).then((cachedResponse) => {
      if (cachedResponse) {
        return cachedResponse;
      }
      return fetch(request);
    })
  );
});

// Background sync for offline support
self.addEventListener('sync', (event) => {
  if (event.tag === 'background-sync') {
    console.log('[Service Worker] Background sync triggered');
  }
});

// Push notifications (future support)
self.addEventListener('push', (event) => {
  const title = 'Boby - Learn English';
  const options = {
    body: event.data.text(),
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
  };
  
  event.waitUntil(self.registration.showNotification(title, options));
});
