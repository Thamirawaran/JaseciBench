# Task: ecommerce-mini (AppAgentEval v0.1, Phase 0)

The first AppAgentEval task and the Phase 0 cross-stack proof. A multi-entity
**full-stack** e-commerce app (UI + API + persistence) with auth, a per-user cart,
and persisted orders. Chosen because it forces real, state-dependent flows (an
order must actually persist, mirroring WebArena's "was an order placed" check) and
reuses the e-commerce domain already present elsewhere in the suite.

Columns are full-stack: `jac` (cl frontend + def:pub/priv backend + graph) and
`fastapi-react` (React frontend + FastAPI backend + DB). Each delivers a working
UI so the interaction journeys and the judge's visual dimension have something to
act on; the comparison is full-stack vs full-stack.

## What the agent receives (this folder, public)
- [`design.md`](design.md) - the stack-neutral specification.
- [`contract/openapi.yaml`](contract/openapi.yaml) - the logical domain contract (operationIds, schemas, status codes).
- [`adapters/<stack>.json`](adapters/) - operationId -> route map, plus the auth mechanism and the api/app base URLs, for the chosen stack.
- `../../guides/<stack>.md` - the normalised full-stack design guide.

## What grades it (in JaseciBench-vault, hidden)
`JaseciBench-vault/tasks/app/ecommerce/mini/`:
- `requirements.yaml` - the requirement graph (hard requirements + preferences + dependency edges).
- `acceptance/contract_tests.jac` - stack-neutral golden tests that hit the running app via the adapter.
- `acceptance/journeys.md` - golden user-journey specs (Playwright).
- `scoring.json` - layer weights and gates (function-gates-polish).
- `solution/<stack>/` - reference builds.
- `notes.md` - design rationale and the cross-stack fairness analysis.

## How a run works
1. The harness gives the agent `design.md`, `contract/openapi.yaml`, the chosen
   stack's guide, and that stack's adapter.
2. The agent builds the app from scratch in an isolated workspace.
3. The sandbox builds and boots it (per the stack guide), then waits for `health`.
4. The vault oracle runs the golden contract tests and journeys **through the
   adapter**, so the same tests grade any stack, and scores against the
   requirement graph and `scoring.json`.

## Why this is apples-to-apples
The behaviour graded (operations, schemas, status codes, and state effects) is
identical for every stack. Only the transport and the auth mechanism differ, and
both are declared once per stack in `adapters/<stack>.json`. The per-stack guides
are normalised to equal depth so no stack is advantaged by base-model familiarity,
and both columns are full-stack so neither is handicapped on the UI-dependent
layers. See the vault `notes.md` for the worked fairness check between the `jac`
and `fastapi-react` columns (including why auth is an adapter capability, not a
contract endpoint).
