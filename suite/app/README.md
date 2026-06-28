# Layer 3: AppAgentEval

**Question answered**: How good is the *delivered* application? Given a
stack-neutral spec (a `design.md`), the agent builds a complete full-stack
app from scratch (frontend + backend + data persistence); we evaluate whether
it builds, boots, satisfies the spec end to end, survives user-emulation, and
holds up under quality review.

This is the **greenfield spec-to-app** paradigm (not feature integration into
an existing repo). The benchmark is language-agnostic: Jac/Jaseci is one
comparability column (MultiPL-E-style) alongside mainstream stacks
(Python/FastAPI, TS/Next.js), with Jac-specific axes (walker correctness,
graph-state integrity, cloud-deploy readiness) reported as additive
Jac-column sub-scores.

## How it is scored

Three combined layers (full design and citations in the research doc linked
below):

1. **Automated / objective**: build + boot gates, spec-derived
   unit/integration/e2e tests run in a containerized sandbox, runtime health,
   performance/latency, SAST, accessibility.
2. **Interaction-agent / user-emulation**: scripted Playwright golden
   journeys (plus a free-form Selenium agent for coverage) that drive the
   running app and assert on resulting backend/graph state, with
   collateral-change checks; not action-trajectory matching.
3. **LLM-as-judge rubric**: structured multi-step judging over the full
   trajectory plus screenshots, across human-centered dimensions (ease of
   use, visual appeal, perceived completeness, trust), calibrated against a
   human pairwise study.

Functional correctness gates the visual/quality sub-scores: a broken app
cannot be rescued by polish. Scores aggregate into one headline number plus
sub-scores per stack column, weighted by human preference.

The greenfield oracle (no fixed file structure) is handled by compiling the
spec into a hierarchical requirement DAG bound to API-contract tests and
state-based assertions, scored both independent (partial credit) and gated.

## Structure (v0.1)

```
suite/app/
  README.md                 # this file
  SCHEMA.md                 # how to author a stack-neutral design.md
  guides/                   # normalised per-stack design guides (full-stack columns)
    GUIDE_TEMPLATE.md       #   the fixed sections every stack guide fills
    jac.md                  #   full-stack: cl frontend + def:pub/priv backend + graph
    fastapi-react.md        #   full-stack: React frontend + FastAPI backend + DB
  ecommerce/                # the e-commerce app domain
    mini/                   #   first task (Phase 0 cross-stack proof)
      design.md             #     stack-neutral spec (agent reads this)
      contract/openapi.yaml #     logical contract: operationIds + schemas + status
      adapters/<stack>.json #     operationId -> route map + auth per stack
      README.md
```

Tasks are grouped by app domain (`ecommerce/`), with complexity variants under it
(`mini/`, and later `full/`). Columns are **full-stack** stacks (`jac`,
`fastapi-react`), so each delivers UI + API + persistence; the comparison is
full-stack vs full-stack. The hidden oracle for each task (requirement graph,
golden tests, reference solutions, scoring config) lives in
`JaseciBenchmark-vault/tasks/app/<domain>/<variant>/`.

## Status

**Planned for v0.1; Phase 0 in progress.** The `ecommerce-mini` task and the
authoring scaffolding (schema, guides, contract, adapters) are the first
artifacts. The illustrative entries on the leaderboard's
`AppAgentEval` tab are sample data labelled
`"submitted_by": "JaseciBenchmark team (illustrative)"` and will be replaced
when the first scored run lands. The illustrative entries on the leaderboard's
`AppAgentEval` tab are sample data labelled
`"submitted_by": "JaseciBenchmark team (illustrative)"` and will be replaced
when the first benchmark lands.

Full pipeline architecture, scoring model, the Jac comparability-column
design, the oracle design, harness tooling, a phased build plan, and the
references behind all of the above are in
[JaseciBenchmark-dev / discussion / appagenteval-pipeline-research.md](https://github.com/Thamirawaran/JaseciBenchmark-dev/blob/main/discussion/appagenteval-pipeline-research.md).
Historical framing (the earlier feature-integration design, now superseded)
is in
[three-dataset-proposal.md section 4](https://github.com/Thamirawaran/JaseciBenchmark-dev/blob/main/discussion/three-dataset-proposal.md#4-appagenteval-greenfield-spec-to-app-delivery).

## Smallest credible first task set

Roughly 8-12 realistic (not toy) app specs across a few archetypes that force
multi-step, state-dependent flows and a real data model: CRUD + auth, a
multi-entity workflow (e.g. mini e-commerce where orders must actually
persist), and a graph-natural app to exercise the Jac walker/graph axes. Each
ships a stack-neutral `design.md`, a requirement DAG, an API contract, golden
journeys, and a shortcut-solver audit; half are held in a private holdout to
resist contamination and saturation.
