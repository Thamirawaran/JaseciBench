# Add a backspace key to the keypad

The keypad in `app/client/components/Keypad.cl.jac` lets the user type
digits, operators, equals, and clear. Add a **backspace** key.

## Behaviour

- New key on the keypad with label `⌫` and `data-testid="calc-key-backspace"`.
- The key should be styled as a `clear`-kind button (red background) so
  it visually matches the existing `C` clear key.
- Pressing it must call a new parent-supplied callback `on_backspace()`.
- Layout: place the backspace key adjacent to the clear key, the
  bottom row should read `=  =  =  C  ⌫` (the `=` button still spans
  three columns).

In `app/client/App.cl.jac` and `app/client/App.impl.jac`, add a
`press_backspace` handler with the following behaviour:

- If `awaiting_operand` is true, do nothing.
- Otherwise drop the last character of `display`.
- If the result is empty or just `"-"`, reset `display` to `"0"` and
  set `awaiting_operand = true`.
- Always clear `last_error`.

Wire `press_backspace` to the new `Keypad` prop.

## Out of scope

- No server-side changes for this task.
- No history-panel changes.

## Acceptance

- All baseline tests in `app/tests/baseline.jac` continue to pass.
- `jac check main.jac` runs clean (no errors).
- The hidden grader test exercises a `press_backspace`-equivalent code
  path on the in-memory state (mounted via the Keypad component
  contract); it asserts that `display` is shortened correctly and that
  emptying the display resets to `"0"`.
