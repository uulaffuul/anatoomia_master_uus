'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "d69458bcd796d153779f92c03dfa3027",
"assets/AssetManifest.bin.json": "5dee9d80b0598f2a5bf07baed6be1b5e",
"assets/assets/andmed.csv": "271cc9f5c0fad99cfcb61df2ec3a0109",
"assets/assets/AssetManifest.bin": "481cfd4939fd7a163b584f53bd17319c",
"assets/assets/AssetManifest.bin.json": "ae863caab9459caf31e78332941a5d11",
"assets/assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/ikoon.png": "46440d45f15b4fc8d2236a1da8cd6e17",
"assets/assets/NOTICES": "8085385b3a8ff30eb1caaff4a4bd7a4d",
"assets/assets/pildid/kasivarre%2520painutajalihased.png": "9ce3bea91d6ec3ca9ab37a8b8876d003",
"assets/assets/pildid/kasivarre%2520sirutajalihased.png": "ca01522f1cc0d004bdfcfc7dd1a29f52",
"assets/assets/pildid/kasivarre%252520painutajalihased.png": "9ce3bea91d6ec3ca9ab37a8b8876d003",
"assets/assets/pildid/kasivarre%252520sirutajalihased.png": "ca01522f1cc0d004bdfcfc7dd1a29f52",
"assets/assets/pildid/m.adductor%2520longus%2520brevis.png": "355073bf6a4a952d1fe065aecaf875dc",
"assets/assets/pildid/m.adductor%2520magnus.png": "1f8723c56227a53ccc8cb431c23d3175",
"assets/assets/pildid/m.adductor%252520longus%252520brevis.png": "355073bf6a4a952d1fe065aecaf875dc",
"assets/assets/pildid/m.adductor%252520magnus.png": "1f8723c56227a53ccc8cb431c23d3175",
"assets/assets/pildid/m.biceps%2520brachii.png": "664fbc5efd14567135e6e7c6519fc7e1",
"assets/assets/pildid/m.biceps%252520brachii.png": "664fbc5efd14567135e6e7c6519fc7e1",
"assets/assets/pildid/m.brachialis.png": "fc40ef62644bd8ba01daf88931f92e63",
"assets/assets/pildid/m.brachioradialis.png": "dbabef7d9f1f0f60c7e6f8c8567e73b2",
"assets/assets/pildid/m.coracobrachialis.png": "7ac55ef69807fd62abdd9408ca5284d0",
"assets/assets/pildid/m.deltoideus.png": "01e3b24b3c8e76ff450434e29ab5316d",
"assets/assets/pildid/m.diapraghma.png": "d030c7b54cd2a9767367a39583ad9980",
"assets/assets/pildid/m.erector%2520spinae.png": "7501fbe7b1c7e539b24046124b678b1d",
"assets/assets/pildid/m.erector%252520spinae.png": "7501fbe7b1c7e539b24046124b678b1d",
"assets/assets/pildid/m.gastrocnemius.png": "ee91a780077908e187ae35bb7beade79",
"assets/assets/pildid/m.gluteus%2520maximus.png": "54d71802c56102ab2bdff727713b6f85",
"assets/assets/pildid/m.gluteus%2520medius.png": "9192cfeed4e36e7e6468a980d491598e",
"assets/assets/pildid/m.gluteus%252520maximus.png": "54d71802c56102ab2bdff727713b6f85",
"assets/assets/pildid/m.gluteus%252520medius.png": "9192cfeed4e36e7e6468a980d491598e",
"assets/assets/pildid/m.gracilis.png": "3be28e27f4c1bcff724e508efb7d2144",
"assets/assets/pildid/m.iliacus.png": "8871dbc0e68cdda9eec53edf7183a66e",
"assets/assets/pildid/m.infraspinatus.png": "7195b8347492304319c54a7a002d6ca0",
"assets/assets/pildid/m.latissimus%2520dorsi.png": "1e981e239be415ead0560eba72f8030c",
"assets/assets/pildid/m.latissimus%252520dorsi.png": "1e981e239be415ead0560eba72f8030c",
"assets/assets/pildid/m.obliquus%2520externus.png": "431d3eab6654b5bb93386b2d4c07ca52",
"assets/assets/pildid/m.obliquus%2520internus.png": "faf7b1573ca192176e1830102c02184f",
"assets/assets/pildid/m.obliquus%252520externus.png": "431d3eab6654b5bb93386b2d4c07ca52",
"assets/assets/pildid/m.obliquus%252520internus.png": "faf7b1573ca192176e1830102c02184f",
"assets/assets/pildid/m.pectoralis%2520major.png": "54cbcc00c223770ee1acd7c89ed34605",
"assets/assets/pildid/m.pectoralis%2520minor.png": "c9af3d2cd8905c7f1d58802c3ed0aa09",
"assets/assets/pildid/m.pectoralis%252520major.png": "54cbcc00c223770ee1acd7c89ed34605",
"assets/assets/pildid/m.pectoralis%252520minor.png": "c9af3d2cd8905c7f1d58802c3ed0aa09",
"assets/assets/pildid/m.peroneuslongus%2520brevis.png": "8f8487fa7719d29a88b124431f9883cd",
"assets/assets/pildid/m.peroneuslongus%252520brevis.png": "8f8487fa7719d29a88b124431f9883cd",
"assets/assets/pildid/m.piriformis.png": "c6be50c7b91655b41ce7a6287445db6f",
"assets/assets/pildid/m.psoas%2520major.png": "aa54c259c525f7ec57356d8033e32086",
"assets/assets/pildid/m.psoas%252520major.png": "aa54c259c525f7ec57356d8033e32086",
"assets/assets/pildid/M.quadriceps%2520femoris.png": "3d45d927c5121c9b8a016a58c396b43a",
"assets/assets/pildid/M.quadriceps%252520femoris.png": "3d45d927c5121c9b8a016a58c396b43a",
"assets/assets/pildid/m.rectus%2520abdominis.png": "a937e1a80fed003172f493420269dddb",
"assets/assets/pildid/m.rectus%252520abdominis.png": "a937e1a80fed003172f493420269dddb",
"assets/assets/pildid/m.sartorius.png": "e95ffd585209387a7e6989fdc842a248",
"assets/assets/pildid/m.serratus%2520anterior.png": "bfa8c7d514ce4c34c9e4082f7316a073",
"assets/assets/pildid/m.serratus%252520anterior.png": "bfa8c7d514ce4c34c9e4082f7316a073",
"assets/assets/pildid/m.soleus.png": "087a731e0a4c0f57a694022495a1d4e9",
"assets/assets/pildid/m.subscapularis.png": "63fbf72be41ecc83b6b577b143f7442f",
"assets/assets/pildid/m.supraspinatus.png": "c3fb354fd9b3005e18dd792655943a59",
"assets/assets/pildid/m.tensor%2520fascia%2520latae.png": "d47a2dfc758c4b4e83ee37446e5c058d",
"assets/assets/pildid/m.tensor%252520fascia%252520latae.png": "d47a2dfc758c4b4e83ee37446e5c058d",
"assets/assets/pildid/m.teres%2520minor.png": "cab35031a5e3e2d0ad4b04ec513c0e92",
"assets/assets/pildid/m.teres%252520minor.png": "cab35031a5e3e2d0ad4b04ec513c0e92",
"assets/assets/pildid/m.tibialis%2520anterior.png": "8a74b4a280a9e097666b41428072fc27",
"assets/assets/pildid/m.tibialis%2520posterior.png": "7fcbbfbbe2c938d456e40785333bb91a",
"assets/assets/pildid/m.tibialis%252520anterior.png": "8a74b4a280a9e097666b41428072fc27",
"assets/assets/pildid/m.tibialis%252520posterior.png": "7fcbbfbbe2c938d456e40785333bb91a",
"assets/assets/pildid/m.transversus%2520abdominis.png": "131379f06e0d6bb7bb2df4ab2e89038b",
"assets/assets/pildid/m.transversus%252520abdominis.png": "131379f06e0d6bb7bb2df4ab2e89038b",
"assets/assets/pildid/m.trapezius.png": "452509cbaadf845fd3fc591ea5f6f8e4",
"assets/assets/pildid/m.triceps%2520brachii.png": "790417801583ead88de20c051ec02a81",
"assets/assets/pildid/m.triceps%252520brachii.png": "790417801583ead88de20c051ec02a81",
"assets/assets/pildid/mm.hamstring.png": "ec64e965723990339fc1eb1183312926",
"assets/assets/pildid/mm.rhomboideii.png": "dd11c238e997158cd697a60529fee1de",
"assets/assets/pildid/mm.suboccipitalis.png": "54ac06d9104df7b530f79f31a89787b1",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "8d229b7ed8fb9965980a8c4011efa2f6",
"assets/NOTICES": "8085385b3a8ff30eb1caaff4a4bd7a4d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "41e83156b94242ce9fda277b4dc41bec",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "107b7ddbecd8060380815fc252f80fe9",
"/": "107b7ddbecd8060380815fc252f80fe9",
"main.dart.js": "54c31a3b3c86cc82a3029987077b3315",
"manifest.json": "375b05e1966fc9bca7bbdc0982461335",
"version.json": "6de34c406a48c93e0adb8ce2240ddf66"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
