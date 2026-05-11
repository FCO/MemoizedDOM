## ADDED Requirements

### Requirement: EVAL :lang<JavaScript> works in modern browsers
The `EVAL :lang<JavaScript>` construct SHALL work to evaluate JavaScript strings from Raku code, even when CSP blocks `eval()`/`new Function()`.

#### Scenario: JavaScript eval returns document
- **WHEN** Raku code executes `EVAL :lang<JavaScript>, 'return document'`
- **THEN** the result SHALL be the browser's `document` object

#### Scenario: JavaScript eval returns function result
- **WHEN** Raku code executes `EVAL :lang<JavaScript>, 'return HTMLElement.prototype.defined = function() { return true }'`
- **THEN** the monkey-patch SHALL be applied to `HTMLElement.prototype.defined`

#### Scenario: Event listener attachment works
- **WHEN** Raku code calls `.addEventListener` on a DOM element
- **THEN** the event listener SHALL be attached to the native DOM element
- **AND** the listener SHALL fire when the event is triggered

### Requirement: DOM property access works
Raku code SHALL be able to read and write native DOM element properties.

#### Scenario: Style property access
- **WHEN** Raku code sets `$!dom-element<style>{$name} = $value`
- **THEN** the native DOM element's style property SHALL be updated

#### Scenario: Child node manipulation
- **WHEN** Raku code calls `$!dom-element.appendChild(...)` or `$!dom-element.removeChild(...)`
- **THEN** the native DOM element's children SHALL be modified accordingly
