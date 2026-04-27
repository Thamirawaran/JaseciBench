# Calculator - reference app

A login-gated, full-stack Jaseci calculator. Per-user persistent calculation history, basic 4-function arithmetic, JSX client. ~600 LOC across 9 files.

This is the codebase the JacAgentBench-v0.1 tasks operate on. Don't change anything here unless you're adding a new task - the baseline is part of the contract.

## Run it locally

Requires conda env with `jaclang>=0.14`.

```bash
conda activate jacenv

# Type-check the whole app
jac check main.jac

# Run the baseline test suite (10 tests, all must pass)
jac test tests/baseline.jac

# Start the dev server (requires `jac install` to fetch npm deps first)
jac install
jac start main.jac
```

## Layout

```
app/
├── jac.toml                       # Project config
├── main.jac                       # Entry point (sv + cl section headers)
├── server/
│   ├── models.sv.jac              # node Calculation
│   └── compute.sv.jac             # walkers: Compute / ListHistory / ClearHistory
├── client/
│   ├── App.cl.jac                 # State + JSX root
│   ├── App.impl.jac               # Function bodies (separated for readability)
│   └── components/
│       ├── Display.cl.jac         # The readout
│       └── Keypad.cl.jac          # Digit/operator/control buttons
└── tests/
    └── baseline.jac               # 10 regression tests - gates every task submission
```

## Public API

| Walker | Inputs | Reports | Notes |
|---|---|---|---|
| `Compute(a, op, b)` | `a: float`, `op: str`, `b: float` | `{id, a, op, b, result}` on success, `{error: str}` on bad input | `op` ∈ `{+, -, *, /}` in baseline. Errors do **not** persist a node. |
| `ListHistory()` | - | `list[dict]` of every Calculation in insertion order | |
| `ClearHistory()` | - | `{deleted: int}` | Deletes every Calculation node attached to the user's root |

All walkers are `walker:priv` - they require an authenticated session and operate on the calling user's personal subgraph (`Root entry`).

## Test contract

`tests/baseline.jac` pins the contract above with 10 tests:

- 4 tests - one per operator (`+`, `-`, `*`, `/`) - assert `result` and `error == ""`.
- 3 tests - error paths (division by zero, unknown operator, errors not persisted).
- 3 tests - history (empty, ordered insertion, clear-and-count).

If a benchmark task makes any of these fail, the agent's submission is treated as a regression and scores zero on the gating stage.
