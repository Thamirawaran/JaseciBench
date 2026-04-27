# Add a "Sum of history" feature

End-to-end task: a new server walker computes the sum of every result
in the user's calculation history, and a new client button surfaces
that sum on the display.

## Server side

In `app/server/compute.sv.jac`, add a new walker `SumHistory`:

- `walker:priv SumHistory` with `has total: float = 0.0;` on its state.
- It walks every `Calculation` node attached to the user's root and
  accumulates the `result` of each into `self.total`.
- It also calls `report self.total` so the HTTP response carries the
  same value.
- For an empty history, `total` is `0.0`.

## Client side

In `app/client/App.cl.jac` + `App.impl.jac`:

- Add a new button **next to the "Show history" / "Clear history" row**
  with label `Σ` (uppercase sigma) and `data-testid="history-sum"`.
- When pressed, it calls a new async helper `show_history_sum()` that
  spawns `SumHistory` and shows the returned total on the display via
  `display = str(out.total);`.
- Pressing it again should re-fetch the sum (it is not cached).

You will need to add the server walker to the import list at the top of
`App.cl.jac`'s `sv import` statement.

## Out of scope

- No changes to existing walkers (`Compute`, `ListHistory`, `ClearHistory`).
- No persistence of the sum itself.
- The button does not need to be disabled when history is empty.

## Acceptance

- `jac check main.jac` runs clean.
- All baseline server tests in `app/tests/baseline.jac` continue to pass.
- The hidden grader exercises both halves: a server test that
  `SumHistory` returns the correct accumulated total, and a static
  check that `App.cl.jac` references both `SumHistory` and a button
  with `data-testid="history-sum"`.
