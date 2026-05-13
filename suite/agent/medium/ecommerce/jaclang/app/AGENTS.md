# Agent instructions

You are working in the **e-commerce Jac fullstack reference app**. A task
description lives in `../tasks/<task-id>/issue.md`. Read it, edit the
app in place, and validate.

## Working directory

**Your cwd is this folder** (`suite/agent/medium/ecommerce/jaclang/app/`).
Every path mentioned in `issue.md` is relative to here. For example,
`services/catalog.sv.jac` means
`suite/agent/medium/ecommerce/jaclang/app/services/catalog.sv.jac`.

Do not `cd` elsewhere. Do not prefix paths with the suite path.

## Validate your change

```bash
jac check main.jac          # type check
jac test tests/baseline.jac # baseline regression suite
```

`jac check` should be clean. All baseline tests must pass.

## Layout

See [README.md](README.md) for the full source tree and conventions.
Quick map:

- `services/*.sv.jac` - backend `def:pub` endpoints (one file per domain)
- `pages/*.cl.jac` - client-side React-style pages
- `components/`, `lib/` - shared client code
- `models.jac` - node/edge declarations
- `seed.jac` - lazy seed (first endpoint call triggers it)
- `tests/baseline.jac` - regression suite
