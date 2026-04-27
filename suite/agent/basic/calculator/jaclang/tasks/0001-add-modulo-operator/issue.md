# Add the modulo (`%`) operator

The `Compute` walker in `app/server/compute.sv.jac` currently supports
four binary operators: `+`, `-`, `*`, `/`. Add support for `%` (modulo).

## Behaviour

- `Compute(a=10.0, op="%", b=3.0)` should set `result = 1.0`, leave
  `error = ""`, and persist a `Calculation` node like the other operators
  do.
- Modulo by zero must be handled the same way division by zero is:
  set `error = "modulo by zero"`, leave `result = 0.0`, do **not**
  persist a node.
- The implementation should match the existing operator branches in
  style, a new `elif self.op == "%"` arm next to the others.

## Out of scope

- The client-side keypad does not need a `%` button for this task; only
  the server-side operator support is required.
- Floor-division (`//`) is **not** part of this task.

## Acceptance

- All baseline tests in `app/tests/baseline.jac` continue to pass.
- The new server tests injected by the grader for this task pass:
  positive-result modulo, negative-operand modulo, modulo-by-zero
  error path, and history persistence behaviour.
