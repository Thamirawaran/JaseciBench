# AppAgentEval `design.md` Schema (v0.1)

A task in AppAgentEval is a **stack-neutral specification** that any agent, in any
tech stack, builds from scratch. The same `design.md` plus the same logical
contract is used for every stack column (Jac, Python/FastAPI, TypeScript/Next.js,
...), which is what makes the leaderboard an apples-to-apples comparison.

This file defines what a `design.md` must contain. It is the source of truth for
task authors. The agent receives: this `design.md`, the logical `contract/openapi.yaml`,
the per-stack **design guide** for its column, and the per-stack **adapter** map.
It never receives the hidden requirement graph, golden tests, or reference
solutions (those live in the vault).

## Authoring principles

1. **Behaviour, not implementation.** Describe what the app does and how it is
   judged. Never name a framework, file layout, library, or language in the spec
   body. Stack-specific help belongs in the per-stack guide, not here.
2. **Every requirement must be checkable** by one of: a contract test
   (HTTP request/response + status), a state assertion (DB/graph state after a
   flow), or a golden user-journey. If you cannot state how it is checked, it is
   not a requirement.
3. **Mandate a machine-readable contract.** Each `design.md` ships a
   `contract/openapi.yaml` with `operationId`s. Acceptance binds to the contract,
   not to the agent's file structure.
4. **Keep tasks realistic and multi-step.** A task must be auditable against a
   trivial/shortcut solver before inclusion (Online-Mind2Web lesson). State-
   dependent flows (e.g. "an order must actually persist") are preferred.

## Required sections

A `design.md` must contain these sections, in order:

### 1. Header
```yaml
id: ecommerce-mini            # kebab-case, unique
title: Mini E-Commerce
version: 0.1
archetype: multi-entity-workflow   # crud-auth | multi-entity-workflow | graph-natural
holdout: false                # true => lives in the private holdout, not public
```

### 2. Summary
One paragraph: what the app is, who uses it, the single core workflow that must work.

### 3. Domain Model
Entities as stack-neutral records: entity name, fields (name + type +
constraints), and relationships ("a User has many Orders"). No tables, no nodes,
no ORM. Types are abstract: `string`, `int`, `float`, `bool`, `datetime`, `id`.

### 4. Roles and Auth
The actor roles (e.g. `guest`, `user`), the auth mechanism in abstract terms
(e.g. "token returned on login, sent on subsequent requests"), and the data-
isolation rule (e.g. "a user can only read their own cart and orders").

### 5. Functional Requirements
A numbered list of user-facing capabilities. Each line becomes one or more nodes
in the hidden requirement graph. Write them as testable statements
("A logged-in user can add a product variant to their cart"), and note
dependencies in prose ("requires auth and a seeded catalog"). Mark soft ones as
*(preference)*.

### 6. API Contract
A pointer to `contract/openapi.yaml`, plus a short table of the `operationId`s
and their one-line purpose. The agent implements every listed operation; the
per-stack adapter maps each `operationId` to the concrete route for that stack.

### 7. Seed Data
The fixed initial data every build must start from (e.g. the product catalog),
given as literal records so every stack and every run is identical.

### 8. Non-Functional Requirements
Per-task SLAs (latency budget on key endpoints), security expectations (input
validation, auth enforcement, no secrets in source), and accessibility target
(e.g. Lighthouse a11y >= N). These feed the objective layer.

### 9. Out of Scope
What is explicitly NOT required (e.g. payment gateway, email, admin panel), so
agents are not penalised for omitting it and not rewarded for gold-plating.

## What the agent is given vs graded on

| Given to agent (public) | Hidden in vault (oracle) |
|---|---|
| `design.md` (sections 1-9) | requirement graph (`requirements.yaml`) |
| `contract/openapi.yaml` | golden contract tests, state assertions, journeys |
| per-stack `guides/<stack>.md` | reference solutions per stack |
| per-stack `adapters/<stack>.json` | `scoring.json` (layer weights, gates) |

## Cross-stack equivalence (the rule that keeps it fair)

- The **logical contract** (operations, request/response schemas, status codes,
  and state effects) is identical across stacks. It is the behaviour we grade.
- Only the **transport and auth mechanism** may differ per stack, declared once in
  `adapters/<stack>.json` (operationId -> `{method, path}`, an `auth` block, and
  the `api_base_url` / `app_base_url`) and explained in that stack's guide. The
  harness runs the same golden tests against any stack by resolving through the
  adapter.
- **Auth/identity is an adapter capability, not a domain contract operation.**
  Stacks differ fundamentally here (app-level token vs framework-native session),
  so register/login live in the adapter's `auth` block; the contract covers only
  domain operations. The behavioural auth requirements (a user can authenticate;
  data is per-user isolated; protected ops reject anonymous calls) are graded
  identically across stacks.
- **Columns are full-stack** (UI + API + persistence), e.g. `jac` and
  `fastapi-react`. Each must deliver a working UI, so the interaction journeys and
  the judge's visual dimension apply equally; the adapter carries both an
  `api_base_url` (contract tests) and an `app_base_url` (UI journeys).
- The per-stack guides are **normalised**: same sections, same depth, same level
  of how-to for every stack, audited so none leaks task-specific solution hints.
  This equalises framework familiarity so we measure agent capability in a stack,
  not how much of that stack the base model memorised.
