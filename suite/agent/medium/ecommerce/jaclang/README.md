# E-Commerce: Jac fullstack benchmark

Jac implementation of the JaseciBench e-commerce CodeAgentEval benchmark.

## Layout

```
jaclang/
├── app/      # Reference application (read-only; agents edit a working copy)
└── tasks/    # Per-task descriptions (issue.md per task; 120 tasks across 4×3 grid)
```

See [`app/README.md`](app/README.md) for the architecture, endpoints,
conventions, and quick-start.

## Status

- ✅ Base app: complete. Type-checks and passes its 32 baseline tests.
- ✅ Tasks: 120 published, one `issue.md` each, across the 4x3 grid.
- ✅ Vault: a reference solution for all 120 and hidden tests for 119. The
  remaining task is graded by `source_contains` alone, so it ships no hidden
  test. Every reference solution is swept in CI and must score 1.0 / 1.0.

## Pairs with

- `../python/`: equivalent FastAPI implementation
- `../../../JaseciBench-vault/oracle_jac/`: graders for Jac apps
