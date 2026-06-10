# Per-Stack Design Guide Template (v0.1)

Every stack column ships a guide that fills **these exact sections, at equal
depth**. The purpose is to equalise framework familiarity so AppAgentEval
measures agent capability in a stack, not how much of that stack the base model
happened to memorise. A guide teaches stack idioms and conventions; it must never
contain task-specific logic, entity names from a task, or anything that amounts
to a partial solution.

## Normalisation rules (audited per release)

1. **Same sections, same order** as below, for every stack.
2. **Comparable depth**: each section is roughly the same length and detail
   across stacks. No stack gets a 20-page tutorial while another gets two lines.
3. **No task leakage**: examples use a neutral toy domain (a `Widget` with a
   `name` and `price`), never a task's real entities or flows.
4. **Idioms only**: how to define data, an endpoint, auth, how to run and test,
   how the harness reaches the app. Not "how to solve task X".

## Required sections

### 1. Project layout
The conventional directory/file structure for a small full-stack app in this
stack, with a one-line role for each file. Neutral toy domain only.

### 2. Data model and persistence
How to declare an entity and persist it: the idiom for defining a record/model,
relationships, and how data survives across requests. Show one `Widget` example.

### 3. Defining an API operation
How to expose a server operation in this stack, and **how an `operationId` from
the contract maps to a concrete route here** (the path convention). Show one
operation end to end for the toy `Widget` (input, handler, output, status code).

### 4. Auth pattern
The idiom for issuing a token on login and requiring it on protected operations,
plus how to scope data to the current actor. Neutral example.

### 5. Running and serving locally
The exact command(s) to install dependencies and start the app, the default
host/port, and where the health endpoint lives.

### 6. Testing entry point
How the harness runs this stack's tests, and how it reaches the running app over
HTTP (which is stack-neutral once the server is up).

### 7. Build and deploy command
The single command the sandbox uses to build/boot this stack, and any container
base image expectations.

### 8. Adapter note
A pointer to `adapters/<stack>.json` and a one-paragraph explanation of this
stack's `operationId` -> route convention, so the agent knows exactly where the
harness will look for each operation.

## Anti-patterns (reject in review)

- A guide longer or more detailed than its peers (reintroduces bias).
- Any real task entity (`Order`, `CartItem`, ...) or flow in the examples.
- Library recommendations that effectively pick the architecture for the agent.
- Copy-paste handlers the agent can submit verbatim.
