# Depth pack: PWA

Triggered when the app ships (or will ship) as an installable PWA, or the
conversation touches service workers, offline, push, or add-to-home-screen.

Platform capabilities here change with every browser release. If you are not
certain a constraint still holds, verify quickly (caniuse, WebKit release notes,
web.dev) BEFORE asking — deep questions built on stale facts are worse than
shallow ones.

## Install experience (ask per platform, not in general)

1. iOS Safari has no install prompt event (`beforeinstallprompt` does not exist
   there) — what does the user SEE that tells them to install? Is the
   add-to-home-screen instruction shown contextually, or are we hoping they find
   the share menu on their own?
2. Android/Chrome: the install prompt fires on browser heuristics you do not
   control — what is the fallback UI when it never fires? When it does, where and
   when do we surface it (not on first paint)?
3. Desktop: does installing even make sense for this product? What changes for an
   installed desktop user (window chrome, shortcuts, file handling)?

## Storage and lifecycle

4. Safari can evict site storage after ~7 days without user interaction (ITP) —
   what does the user lose that day? Is anything critical stored ONLY client-side?
5. Service worker update cycle: a user keeps the app open for days — how do they
   learn a new version exists? Two tabs open during an update — what happens?
   (Is your skipWaiting/clients.claim policy chosen, or default by accident?)
6. What exactly is cached, and what is the invalidation story when you deploy?
   (Stale HTML shell serving new API responses is the classic silent breakage.)

## Capabilities matrix

7. Push notifications: iOS requires 16.4+ AND the app installed to home screen —
   is that reach acceptable, and what is the fallback channel (email, SMS) for
   everyone else?
8. List every platform API this app leans on (background sync, badging, camera,
   file system, geolocation) — for each: which platforms lack it, and is the
   answer a fallback or a feature-gate?

## Display and ergonomics

9. Standalone mode strips the browser UI — does every flow still work without the
   browser back button? Are safe-area insets (notch, home indicator) handled?
10. Are maskable icons provided (Android adaptive)? apple-touch-icon set? What
    does the splash/launch experience look like on each platform?

## Testing

11. On which REAL devices and browsers will this be verified before shipping?
    (iOS Safari on a real device ≠ responsive mode in desktop devtools — storage,
    gestures, and install behavior all differ.)
