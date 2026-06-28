# Stack Design Guide: Jac / Jaseci (v0.1)

Idioms only. Examples use a neutral toy `Widget` domain, never a task's entities.
Fill order and depth match `GUIDE_TEMPLATE.md`. Grounded in the Jac CLI skills
(`jac-sv-endpoints`, `jac-sv-auth`, `jac-sv-persistence`, `jac-fullstack-patterns`,
`jac-cl-auth`).

## 1. Project layout
A small full-stack Jac app:
```
app/
  main.jac              # entry + endpoint registry; server imports first, then a `cl { }` block
  services/             # one *.sv.jac per area; def:pub / def:priv functions are endpoints
    widgets.sv.jac
  components/           # *.cl.jac UI units
  pages/                # *.cl.jac routed pages
  jac.toml              # project/build config
```
`main.jac` mixes contexts: plain `import from services.X { fn, Types }` registers
server endpoints; a `cl { ... }` block holds the client, mounted from `def:pub app()`.

## 2. Data model and persistence
The graph IS the database. Entities are **nodes**; you persist one by attaching it
to `root` (or to another reachable node via an edge). Reads are list-comprehension
traversals.
```jac
node Widget {
    has name: str;
    has price: float = 0.0;
}
# create + commit (reachable from root => persisted)
w = (root ++> Widget(name="Bolt", price=2.5))[0];
# read all widgets
all = [root -->][?:Widget];
# filter / count
cheap = [root -->][?:Widget][?price <= 1.0];
total = len([root -->][?:Widget]);
```
Find-by-id uses `jid(node)` (the stable persistent id), never Python `id()`:
`for x in [root -->][?:Widget] { if jid(x) == wid { ... } }`.

## 3. Defining an API operation
A server operation is a `def:pub` or `def:priv` function in a `.sv.jac`, registered
by importing it into `main.jac`. **Adding an endpoint is always a 2-file change**
(the `.sv.jac` plus its import in `main.jac`), or calls 404. Endpoints register at
**`/function/<name>`** and are called by RPC (the harness POSTs a JSON body whose
keys are the parameter names). Pitfall: a missing optional param arrives as a
string (e.g. `limit="0"`), not the declared int default, so coerce numeric
optionals (`lim = int(limit)`) before using them. Return plain dicts for
dict-shaped contract responses (raw nodes serialise with extra `_jac_*` fields).
```jac
# services/widgets.sv.jac
def:pub list_widgets() -> list[Widget] {
    return [root -->][?:Widget];
}
def:pub add_widget(name: str, price: float) -> Widget {
    return (root ++> Widget(name=name, price=price))[0];
}
```
Return type IS the wire format; give every endpoint an explicit `-> T`. Use a
leading underscore (`def _helper(...)`) to keep a function OFF the API.

## 4. Auth pattern
Auth is a **runtime primitive, not app code**. You do not hash passwords or issue
tokens yourself.
- `def:pub` = anonymous; `root` is the shared global graph.
- `def:priv` = authenticated; `root` is the current user's **isolated subgraph**, so
  per-user data (cart, orders) is separated automatically with no `user_id` param
  and no manual filtering.
- There is no `current_user()`; identity is implicit in which `root` a `def:priv`
  endpoint sees. Store per-user metadata on nodes reachable from that root.
Client/runtime auth helpers from `@jac/runtime`: `jacSignup(email, password)`
(returns a dict, does NOT start a session), then `jacLogin(email, password)`
(returns bool, sets the session cookie), `jacLogout()`, `jacIsLoggedIn()`. Signup
must always be followed by login. The harness authenticates through these runtime
endpoints (see the adapter), then calls your `def:priv` operations with the session.
```jac
def:priv my_cart() -> list[Widget] {   # each caller sees only their own
    return [root -->][?:Widget];
}
```

## 5. Running and serving locally
```bash
jac start --dev main.jac      # dev server with hot reload (NOT the deprecated `jac serve`)
```
Default served on localhost; HMR reloads `.cl.jac` only - server (`.sv.jac`)
changes need a restart (`pkill -f "jac start"` then start again). The harness polls
the app before testing.

## 6. Testing entry point
Local Jac tests live in `tests/*.jac` (`jac test`). The AppAgentEval harness does
not score on your unit tests; it authenticates via the runtime, then drives your
endpoints over HTTP at `/function/<name>`, which is uniform across stacks.

## 7. Build and deploy command
The sandbox builds and boots the Jac column with:
```bash
jac check main.jac && jac start main.jac
```
Base image provides the `jaclang` toolchain; no external volume mounts.

## 8. Adapter note
See `adapters/jac.json`. Two conventions matter for Jac:
- **Operations**: each domain `operationId` is your `def:pub`/`def:priv` function of
  the same name, reached at `POST /function/<operationId>` with a JSON body of the
  named parameters. Name functions exactly as the contract `operationId`s.
- **Auth**: identity is provided by the Jac runtime (`jacSignup` + `jacLogin`), not
  by a contract endpoint. The adapter's `auth` block tells the harness how to
  register and log in and that the session is a cookie. Mark every per-user
  operation `def:priv`; mark public catalogue reads `def:pub`.
