## Why

The MemoizedDOM todo demo at `https://fco.github.io/MemoizedDOM/todo6.html` no longer works in modern browsers — it gets stuck on "loading..." with no error output, making the project's main showcase unusable. Without a working demo, new contributors cannot see the project in action.

## What Changes

1. **Diagnose the runtime failure** — investigate why the 74MB `perl6.js` (NQP/Rakudo JS backend) fails to load or initialize in modern browsers
2. **Fix the runtime loading pipeline** — update `webperl.js` and/or `todo6.html` to load and initialize the Raku runtime correctly
3. **Restore the `EVAL :lang<JavaScript>` bridge** — ensure JS interop (`document` access, `addEventListener`) works for component rendering
4. **Rebuild or patch `perl6.js`** — if the compiled runtime has compatibility issues with modern JS engines (e.g., removed APIs, CSP restrictions), fix or replace the artifact
5. **Verify end-to-end** — the todo app should render and be interactive (add/remove todo items)

## Capabilities

### New Capabilities
- `browser-runtime-loading`: Loading and initializing the NQP/Rakudo JS runtime in modern browsers — script injection, eval bridge, and lifecycle management
- `raku-js-interop`: Raku↔JavaScript interoperability layer — `EVAL :lang<JavaScript>`, DOM access, event binding from Raku code
- `component-rendering`: MemoizedDOM component rendering pipeline — Tag role, Element creation/memoization, re-render cycle working in-browser

### Modified Capabilities
<!-- No existing specs to modify; this is the first structured change. -->

## Impact

- `examples/todo-webperl/` — `todo6.html`, `webperl.js`, and possibly `perl6.js` will be modified
- `examples/todo/` — may update the Parcel-based build config if needed for rebuilding
- GitHub Pages deployment (`gh-pages` branch) — updated static assets
- No impact on the Raku library source (`lib/`) or test suite (`t/`)
