## Context

The MemoizedDOM todo demo (`examples/todo-webperl/todo6.html`) relies on a multi-stage runtime loading pipeline:

1. `webperl.js` loads → finds `<script type="text/perl6">` tags → calls `Raku.init()`
2. `Raku.init()` injects a `<script>` tag to load `perl6.js` (74MB NQP/Rakudo JS backend)
3. `perl6.js` initializes the NQP runtime, then sets `window.evalP6 = cb` 
4. `Raku.init()` detects `evalP6`, calls the ready callback
5. `Raku.eval(code)` passes the inline Raku source to the compiler
6. The compiled Raku code manipulates the DOM via `EVAL :lang<JavaScript>`

The 74MB `perl6.js` was compiled ~2018 using an old NQP JS backend (by Paweł Murias). Modern browsers have tightened CSP, deprecated `caller`/`arguments.callee`, and changed how large scripts are parsed. The runtime hangs silently ("loading..." never updates).

## Goals / Non-Goals

**Goals:**
- The todo demo renders and is interactive in current Chrome, Firefox, and Safari
- Error messages are visible in console when something fails
- Fixes are minimally invasive (prefer patching over full rebuild)

**Non-Goals:**
- Rebuilding the NQP/Rakudo JS backend from scratch
- Reducing the 74MB runtime size (impractical without full rebuild)
- Supporting Internet Explorer or very old browsers

## Decisions

1. **Patch `perl6.js` over rebuild** — The NQP JS backend toolchain (`parcel-plugin-nqp`, ancient NQP version) is unavailable and would be extremely complex to reproduce. Isolating and patching the JS compatibility issues is far more practical.

2. **Add console error reporting** — The runtime silently fails. Add `window.onerror` and explicit try/catch around `Raku.eval()` to surface errors.

3. **Modernize `webperl.js`** — Update `Raku.init()` to use `fetch()` instead of creating script elements with `onload`, add proper error handling, and verify `window.evalP6` exists after load.

4. **Replace `EVAL :lang<JavaScript>` with pre-loaded bridge** — Modern CSP often blocks `eval()`. Pre-load JavaScript bridge functions onto `window` so Raku code can call them without runtime `eval`.

## Risks / Trade-offs

- [Patching `perl6.js` is fragile] → Isolate patches to well-defined wrapper functions; document each change
- [74MB file may hit browser tab memory limits] → Accept as-is; the original demo worked with this file size
- [Cannot rebuild runtime] → Fixes are limited to what we can patch in the compiled JS output
- [CSP in strict environments] → Recommend users disable CSP for the demo page, or document the requirement
