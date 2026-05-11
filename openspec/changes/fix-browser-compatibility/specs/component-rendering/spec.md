## ADDED Requirements

### Requirement: Todo app renders initial state
The todo demo SHALL render its initial state (3 todo items: bla/ble/bli) when the page loads.

#### Scenario: App mounts to DOM
- **WHEN** the page finishes loading and Raku code executes
- **THEN** the `<span id="todoapp">` element's inner HTML SHALL be replaced with the rendered todo list
- **AND** the text "loading..." SHALL no longer be visible

#### Scenario: Three todo items render
- **WHEN** the app renders
- **THEN** three `<li>` elements SHALL be visible inside the `<ul>`
- **AND** the text "bla", "ble", and "bli" SHALL appear

### Requirement: Todo items are interactive
Users SHALL be able to toggle todo completion status by clicking todo items.

#### Scenario: Click toggles done state
- **WHEN** user clicks an incomplete todo item
- **THEN** the todo SHALL become visually marked as done (line-through style, reduced opacity)
- **AND** clicking again SHALL unmark it

### Requirement: New todos can be added
Users SHALL be able to add new todo items via the input form.

#### Scenario: Submit form adds todo
- **WHEN** user types text in the input field and presses Enter
- **THEN** a new todo item with that text SHALL appear in the list
- **AND** the input field SHALL be cleared

### Requirement: Component style updates on re-render
When a component re-renders (`call-render`), the memoized DOM elements SHALL be updated with new styles/content rather than re-created.

#### Scenario: Memoization preserves DOM elements
- **WHEN** the app re-renders after a todo toggle
- **THEN** existing DOM elements SHALL be reused (not re-created)
- **AND** their style properties SHALL be updated to reflect new state
