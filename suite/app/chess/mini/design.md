---
id: chess-mini
title: Mini Chess
version: 0.1
archetype: stateful-rules-engine
holdout: false
---

# Mini Chess

## 2. Summary
Build a two-player chess web application that enforces the full rules of chess.
Two registered users play one game: they alternate moves, the server validates
every move against the complete FIDE rules, and it persists the game so either
player can resume and review it. The single core workflow that must work end to
end is: **two users register and log in, one creates a game naming the other as
opponent, they alternate legal moves through to a terminal result (checkmate,
stalemate, or draw), and the final game state is persisted and visible to both.**

The deliverable is **full-stack**: a working browser UI showing a chessboard the
two players can move pieces on, plus the turn, check, and result indicators,
backed by the API and persistent storage. The UI is exercised by the interaction
journey, so it must actually function, not merely render.

This is a **rules engine** task: the value is in correct, complete move
legality. The server is the single source of truth for legality; a client must
never be trusted to decide whether a move is legal.

## 3. Representation
Use the standard, compact encodings so the contract is unambiguous:

- **Board state = FEN** (Forsyth-Edwards Notation): the full position in one
  string, including piece placement, side to move, castling rights, en passant
  target square, halfmove clock, and fullmove number. The standard start position
  is `rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1`.
- **Move = UCI**: origin square + destination square, with a promotion piece
  suffix when promoting. Examples: `e2e4`, `g1f3`, `e1g1` (kingside castle),
  `e5d6` (en passant), `e7e8q` (promote to queen), `a7a8n` (under-promote to
  knight). Castling is encoded as the king's two-square move.

## 4. Domain Model
Stack-neutral records. Types: `id`, `string`, `int`, `bool`, `datetime`.

- **User**: `id`, `email` (unique), `password` (stored hashed, never returned),
  `created_at`.
- **Game**: `id`, `white_user`, `black_user` (each is the stable **user id** its
  stack's auth exposes: for example the runtime root id, or the account email),
  `fen`
  (current position), `turn` (`white`|`black`, derived from the FEN), `status`
  (`active`|`checkmate`|`stalemate`|`draw`), `check` (bool: is the side to move in
  check), `winner` (`white`|`black`|`null`), `created_at`. Has many Moves.
- **Move**: `id`, `game_id`, `ply` (1-based move index), `color` (`white`|`black`),
  `uci` (the move played), `fen_after` (position after the move). Belongs to one
  Game.

## 5. Roles and Auth
- Roles: `guest` (unauthenticated) and `user` (authenticated).
- Auth uses your **stack's native mechanism** (see your stack guide): a user can
  register and log in, and after logging in is recognised on subsequent requests.
  Register and log in are **not** domain contract operations; the harness
  authenticates through the adapter.
- Credentials must be handled securely: never stored in plaintext, never returned.
- A user is identified by the stable id their stack's auth surfaces at login (the
  value the harness receives: the runtime root id for Jac, the account email for an
  app token). `create_game` names the opponent by that id, and `white_user` /
  `black_user` are reported as those ids.
- Data isolation: only a game's two players (`white_user`, `black_user`) may view
  it, list it among their games, or move in it. A `guest` cannot touch any game.

## 6. Functional Requirements
1. A user can register and then authenticate, and is recognised on protected
   requests. *(no deps)*
2. A logged-in user can create a game, naming a registered opponent by their user
   id; the
   creator is White, the opponent is Black, the position is the standard start
   (or an optional supplied FEN), the turn is White, status is `active`. *(requires 1)*
3. A player can fetch a game and receive its full state: `fen`, `turn`, `status`,
   `check`, `winner`, both players, and the move list. *(requires 2)*
4. A player can make a legal move (UCI) on their turn; the server applies it,
   updates the FEN, flips the turn, and appends it to the move history. *(requires 2)*
5. An **illegal** move is rejected with HTTP 400 and the game is unchanged: wrong
   geometry for the piece, a blocked sliding path, capturing one's own piece, an
   empty origin square, or an off-board square. *(requires 4)*
6. **Turn and ownership** are enforced: only the player whose turn it is may move
   (the other player moving out of turn is rejected), and a player may only move
   their own colour's pieces. *(requires 4)*
7. **King safety**: a move that leaves the mover's own king in check is illegal
   (HTTP 400), including moving a pinned piece or the king into an attacked
   square; `check` is reported true whenever the side to move is in check. *(requires 4)*
8. **Castling** (kingside and queenside) is legal only with the right still
   available, all squares between king and rook empty, and the king not in,
   through, or into check; it moves both king and rook and clears the relevant
   castling rights. *(requires 7)*
9. **En passant** capture is legal only on the move immediately following the
   enabling two-square pawn advance; it removes the passed pawn and is reflected
   by the en passant target square in the FEN. *(requires 4)*
10. **Promotion**: a pawn reaching the last rank must promote via the UCI suffix
    (`q`/`r`/`b`/`n`); under-promotion is honoured; a promoting move with no
    suffix is rejected with HTTP 400. *(requires 4)*
11. **Checkmate** is detected: when the side to move has no legal move and is in
    check, status becomes `checkmate` and `winner` is the other colour. *(requires 7)*
12. **Stalemate** is detected: when the side to move has no legal move and is not
    in check, status becomes `stalemate`, `winner` is null. *(requires 7)*
13. Protected operations reject requests with no/invalid token using HTTP 401, and
    a user who is not one of the game's two players cannot view or move in it. *(requires 1)*
14. *(preference)* Draw by **insufficient material** (e.g. king vs king) sets
    status `draw`.
15. *(preference)* Draw by the **fifty-move rule** (halfmove clock reaches 100)
    sets status `draw`.
16. *(preference)* Draw by **threefold repetition** of the position sets status
    `draw`.
17. *(preference)* A player can **resign**; the opponent becomes `winner` and
    status is set accordingly.
18. *(preference)* `list_games` supports `limit` and `offset`; the server
    publishes its OpenAPI document and a health route.

## 7. API Contract
Implement every **domain** operation in [`contract/openapi.yaml`](contract/openapi.yaml).
The per-stack adapter (`adapters/<your-stack>.json`) gives the exact route for
each. Registration and login are **not** in this list (section 5). Operations
marked *(auth)* require a logged-in user.

| operationId | Purpose |
|---|---|
| `create_game` *(auth)* | Create a game vs a named opponent; optional starting FEN. |
| `get_game` *(auth)* | Get one game's full state (only its two players). |
| `make_move` *(auth)* | Play a legal UCI move on your turn; returns the updated game. |
| `list_moves` *(auth)* | List a game's move history. |
| `list_games` *(auth)* | List the caller's games (supports `limit`/`offset`). |
| `resign` *(auth)* | Resign the game; the opponent wins. |
| `health` | Liveness check (returns 200 when the app is up). |

## 8. Non-Functional Requirements
- **Latency**: `get_game` and `make_move` respond within 300 ms p95 under a light
  load on the reference sandbox.
- **Security**: credentials handled securely (never plaintext, never returned);
  protected operations enforce authentication (FR 13); legality is decided only by
  the server; no secrets committed in source.
- **Accessibility**: the game page targets a Lighthouse accessibility score of at
  least 80.

## 8b. UI Contract (data-testid)

The delivered app must include a browsable UI for the core flow, and that UI must
expose these stable `data-testid` attributes so automated user-journeys can drive
it (the UI counterpart of the API contract):

- **Auth screen**: a logged-out visitor must land on (or reach in one obvious
  step) a single auth view exposing `email`, `password`, `signup`, and `login`
  together. The journey signs up and then logs in from this one screen, so these
  four controls must coexist on the logged-out auth view, not be split across
  separate, separately-navigated pages. If the auth view is not the initial page,
  the entry point to it must carry a `data-testid` of `nav-login`.
- `email`, `password`: the credential inputs.
- `signup`, `login`: the auth buttons. `auth-msg`: a status line that reads
  `registered` after a successful sign up.
- `new-game-opponent`: the input for the opponent's email. `create-game`: the
  button that creates a game.
- `turn`: an element whose text contains whose move it is (for example `white` or
  `black`). `status`: an element whose text contains the game status (for example
  `active`, `check`, `checkmate`).
- `move`: a text input that accepts a UCI move (for example `e2e4`). `submit-move`:
  the button that submits the move in `move`.
- `result`: an element whose text contains the terminal result once the game ends
  (for example `checkmate` and the winning colour).

A board rendering of the pieces is encouraged for human play, but the journey
drives moves through the `move` + `submit-move` controls so it stays robust.

## 9. Out of Scope
No chess engine opponent / AI (games are human vs human), no clocks or time
control, no ratings or matchmaking, no opening book, no PGN import/export, no
analysis or move suggestions, no spectator/chat. Building these is neither
required nor rewarded.
