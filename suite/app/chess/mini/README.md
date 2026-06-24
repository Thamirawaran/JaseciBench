# chess-mini (AppAgentEval task)

Greenfield spec-to-app task: build a two-player chess web app that enforces the
full rules of chess, from the specification alone.

- [`design.md`](design.md): the stack-neutral specification. Build exactly this.
- [`contract/openapi.yaml`](contract/openapi.yaml): the logical API contract
  (operationIds). Board state is FEN, moves are UCI.
- [`adapters/`](adapters/): per-stack route + auth maps. Build for your stack
  (`jac` or `fastapi-react`) and follow its guide in `../../guides/`.

Pick your stack, read the matching guide, and implement every operationId plus a
working UI exposing the `data-testid` contract in `design.md` section 8b. The
server is the single source of truth for move legality.
