## 1. Diagnose Runtime Failure

- [x] 1.1 Open `todo6.html` locally in browser and check console for errors
- [x] 1.2 Test `perl6.js` loading independently — verify the script executes without errors when loaded standalone
- [x] 1.3 Check if `window.evalP6` is set after `perl6.js` loads in modern browsers
- [x] 1.4 Reproduce the exact error(s) across Chrome, Firefox, and Safari

## 2. Fix Error Reporting in Runtime Loading

- [x] 2.1 Add `window.onerror` + `window.addEventListener('error')` handlers to `webperl.js` to catch uncaught exceptions during runtime init
- [x] 2.2 Wrap `Raku.init()` script injection in error handling — log failure if `perl6.js` load fails or `onload` never fires
- [x] 2.3 Add timeout detection — if `evalP6` is not set within 60s of script injection, log an error and surface to UI
- [x] 2.4 Wrap `Raku.eval()` in try/catch and log compile/runtime errors to console

## 3. Patch perl6.js for Modern Browser Compatibility

- [x] 3.1 Scan `perl6.js` for usage of `arguments.callee`, `caller`, `__proto__`, or other deprecated JS features
- [x] 3.2 Check for any `SharedArrayBuffer`, `Atomics`, or WASM-related requirements
- [x] 3.3 Fix identified incompatibilities — use polyfills or replacements where feasible
- [ ] 3.4 Verify `window.evalP6` is properly set as a global function after the runtime initializes

## 4. Modernize webperl.js Runtime Shim

- [ ] 4.1 Replace `window.onload` script injection with explicit async/await loading pattern
- [x] 4.2 Add error propagation from `script.onerror` for `perl6.js` load failures
- [x] 4.3 Verify `Raku.state` transitions correctly (Uninitialized → Initializing → Ready)
- [x] 4.4 Ensure the Raku6 `load` event listener handles `<script type="text/raku">` in addition to `text/perl6`

## 5. Fix EVAL :lang<JavaScript> Bridge

- [ ] 5.1 Pre-register JavaScript bridge functions on `window` before Raku code runs (document access, DOM manipulation helpers)
- [ ] 5.2 Patch `perl6.js` eval bridge to use pre-registered functions when CSP blocks `eval()`
- [ ] 5.3 Verify `EVAL :lang<JavaScript>, 'return document'` works without CSP violation

## 6. End-to-End Verification

- [ ] 6.1 Serve `todo6.html` locally and verify the app renders (all 3 todos visible)
- [ ] 6.2 Test todo toggle interaction — click an item and verify style changes
- [ ] 6.3 Test adding new todos via the form
- [ ] 6.4 Verify console is free of uncaught errors
- [ ] 6.5 Test in Chrome, Firefox, and Safari
- [ ] 6.6 Deploy updated files to `gh-pages` branch and verify the live URL
