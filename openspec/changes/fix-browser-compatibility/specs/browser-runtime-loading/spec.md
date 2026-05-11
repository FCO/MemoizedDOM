## ADDED Requirements

### Requirement: Runtime loads successfully
The NQP/Rakudo JS runtime (perl6.js) SHALL load and initialize without throwing uncaught errors in modern browsers (Chrome 90+, Firefox 90+, Safari 15+).

#### Scenario: Runtime loads without error
- **WHEN** the page loads and `Raku.init()` is called
- **THEN** the script element for `perl6.js` is appended to the document head
- **AND** no uncaught JavaScript errors occur during loading

#### Scenario: evalP6 is exposed after runtime loads
- **WHEN** `perl6.js` finishes loading
- **THEN** `window.evalP6` SHALL be a function
- **AND** `Raku.state` SHALL transition to "Ready"

### Requirement: Runtime failures are reported
If the runtime fails to load or initialize, the error SHALL be surfaced in the browser console.

#### Scenario: Missing perl6.js reports error
- **WHEN** `perl6.js` fails to load (404, timeout, etc.)
- **THEN** a descriptive error message SHALL be logged to console.error
- **AND** the page SHALL display a user-visible error message

#### Scenario: Initialization error is reported
- **WHEN** the runtime initializes but `window.evalP6` is not set
- **THEN** an error SHALL be logged indicating the eval bridge is missing

### Requirement: Raku code evaluates without error
Inline Raku source from `<script type="text/perl6">` tags SHALL compile and execute without uncaught exceptions.

#### Scenario: Inline Raku code executes
- **WHEN** `Raku.eval(code)` is called with valid Raku source
- **THEN** no uncaught error is thrown
- **AND** any compile errors are surfaced via console.error

#### Scenario: Compile errors are reported
- **WHEN** `Raku.eval(code)` is called with invalid Raku source
- **THEN** the compile error message SHALL be logged to console.error
