# Running an Evaluation

How to run a coding agent against JaseciBench and get a per-task pass/fail score from the hidden vault.

JaseciBench reports two complementary scores. Pick the one (or both) that matches what you want to measure.

| Mode | Question it answers | Submission shape | Tank-on-regression? |
|---|---|---|---|
| **Isolated** | "Given a clean codebase + one task, can the agent fix it?" | 1 snapshot per task | No — each task is independent |
| **Cumulative** | "Can the agent fix all N bugs in one coherent codebase without breaking what already worked?" | 1 final app | Yes — break baseline and every task fails |

Cumulative is the harder benchmark and the headline leaderboard number. Isolated is the per-task capability number — what you want during development and for fine-grained model comparisons. The two often diverge wildly: a model can score 88% isolated and 0% cumulative if mid-run it regresses a shared dependency.

## TL;DR

```bash
# 1. clone the public benchmark
git clone https://github.com/Thamirawaran/JaseciBench.git
cd JaseciBench

# 2. let your agent edit suite/agent/.../<app>/app/ for each task
#    (each task's spec is in tasks/<id>/issue.md)
#    Use the runner of your choice — see "Recommended runner" below.

# 3a. ISOLATED grading: 120 snapshots, one per task
./scripts/grade-isolated --snapshots /path/to/snapshots --suite medium/ecommerce/jaclang

# 3b. CUMULATIVE grading: one final app pushed to GitHub
git checkout -b eval/my-run && git add -A && git commit -m "eval run" && git push origin eval/my-run
JASECIBENCH_EVAL_TOKEN=ghp_xxx ./scripts/grade --repo YourOrg/JaseciBench --sha $(git rev-parse HEAD)
```

## Suite paths

| Suite | Path | Tasks |
|---|---|---:|
| Calculator (basic) | `suite/agent/basic/calculator/jaclang` | 3 |
| Ecommerce (medium) | `suite/agent/medium/ecommerce/jaclang` | 120 |
| **Total** | | **123** |

Each suite has:
- `app/` — the codebase the agent edits (compilable Jac fullstack app)
- `app/tests/baseline.jac` — sanity tests that must keep passing
- `tasks/<id>/issue.md` — public task description the agent reads as its prompt

## Recommended runner

The official runner at [`jaseci_repos/jac-code/eval/jasecibench/runner.py`](https://github.com/jaseci-labs/jac-code/blob/main/eval/jasecibench/runner.py) supports both modes:

```bash
# Isolated (default): reset app to clean baseline before each task,
# snapshot the agent's edited app afterwards. Produces a snapshots dir.
python eval/jasecibench/runner.py \
    --suite-dir /path/to/JaseciBench/suite/agent/medium/ecommerce/jaclang \
    --output /tmp/agent_metrics.json \
    --snapshots-dir /tmp/snapshots \
    --model gpt-5.4

# Cumulative: one shared app dir across all tasks (legacy behavior).
# Only the final state is preserved.
python eval/jasecibench/runner.py \
    --suite-dir /path/to/JaseciBench/suite/agent/medium/ecommerce/jaclang \
    --output /tmp/agent_metrics.json \
    --cumulative \
    --model gpt-5.4
```

`OPENAI_API_KEY` and/or `ANTHROPIC_API_KEY` must be exported in the calling environment.

## How grading works

Every task in the vault has a `scoring.json` declaring stages:

| Stage | Kind | Required gate? | Weight |
|---|---|---|---|
| `type_check` | `jac check main.jac` | Yes | 0 |
| `baseline` | `jac test tests/baseline.jac` | Yes | 0 |
| `hidden` | hidden tests injected from vault | Yes | up to 1.0 |
| `source_contains` | pattern match on specific source files | Often | partial credit |

A required-gate failure short-circuits the rest of the stages on that task. A task is "fully resolved" only when `score == max_score` and `status == pass`.

## Isolated grading (local, default)

For isolated mode you grade locally — the vault doesn't yet host an isolated workflow.

```bash
# You need read access to JaseciBench-vault (the hidden corpus).
git clone https://github.com/Thamirawaran/JaseciBench-vault.git ~/vault
cd /path/to/JaseciBench
./scripts/grade-isolated \
    --snapshots /tmp/snapshots \
    --suite medium/ecommerce/jaclang \
    --vault ~/vault
```

`scripts/grade-isolated` runs `jac run oracle/score.jac` on each snapshot and prints a per-task table plus per-tier / per-layer pass rates.

## Cumulative grading (the leaderboard path)

### `scripts/grade --sha <full-sha>` (no PR needed)

Push your branch and run:

```bash
JASECIBENCH_EVAL_TOKEN=ghp_xxx ./scripts/grade
```

The script dispatches the vault's grading workflow (`pr_number=0` / log-only), polls until done, and prints the score table to your terminal.

### `gh workflow run grade-pr` (PR-based)

Open a PR, then:

```bash
gh workflow run grade-pr -f pr_number=<N>
```

The vault posts the per-task results table as a PR comment.

## Required: full SHA (40 chars)

`actions/checkout` cannot fetch by short SHA. `./scripts/grade --sha 0655bb2` will fail; use `git rev-parse HEAD`.

## Required environment variable (cumulative only)

`JASECIBENCH_EVAL_TOKEN` — fine-grained GitHub PAT with:
- `Actions: write` on `Thamirawaran/JaseciBench-vault`
- `Actions: read` on `Thamirawaran/JaseciBench-vault`

Ask a maintainer for one. **Do NOT commit it to any repo.**

## What your agent sees (and doesn't)

**Visible:**
- The full source under `suite/agent/.../<app>/app/`
- Each task's `issue.md`
- `tests/baseline.jac`

**Hidden:**
- `tests_hidden.jac` per task (lives only in the private vault)
- `scoring.json` (the rubric)
- `solution/` (the maintainer-written reference fix)

## Cumulative-mode gotcha: a baseline break tanks every task

In cumulative mode the candidate is one final-state `app/`. When the vault grader runs task N, it copies that same final-state app into a per-task workspace and runs task N's hidden tests against it. Workspace-per-task does not protect you from regressions baked into the candidate itself. **If your agent breaks `tests/baseline.jac` or removes a function other tasks depend on while solving any one task, the baseline gate fails on every task in the suite.**

This is exactly the failure mode that makes cumulative the harder benchmark. Common causes:

- Agent adds its own test cases to `tests/baseline.jac` (some of which are wrong) → baseline gate fails universally.
- Agent refactors / renames / removes a shared service function that other tasks import.
- Agent introduces a syntax error in any module reachable from `main.jac` → `type_check` gate fails universally.

If you want a per-task capability score that ignores cross-task interference, use isolated mode.

## Local debugging (one task, oracle directly)

```bash
jac run ~/vault/oracle/score.jac -- \
    --task     1101-cart-total \
    --app      medium/ecommerce/jaclang \
    --codebase /path/to/your/JaseciBench/suite/agent/medium/ecommerce/jaclang/app
```

Output is JSON with per-stage `passed` flags.

## Known gotchas

| Gotcha | Workaround |
|---|---|
| Short SHA in `scripts/grade --sha` | Always pass full 40-char SHA |
| Cumulative mode: agent broke baseline once → all tasks fail | Use isolated mode for per-task scores; review what the agent changed in shared code |
| `actions/checkout` needs auth for private fork | Ensure `JASECIBENCH_PUBLIC_PR_COMMENT_TOKEN` has access |
| `OPENAI_API_KEY` / `ANTHROPIC_API_KEY` not set | The runner reads these from the calling environment; export before invoking |

## Reference

- Public bench: <https://github.com/Thamirawaran/JaseciBench>
- Private vault: <https://github.com/Thamirawaran/JaseciBench-vault>
- `scripts/grade` (cumulative): [scripts/grade](scripts/grade)
- `scripts/grade-isolated` (per-task): [scripts/grade-isolated](scripts/grade-isolated)
- Vault grading workflow: [`grade-submission.yml`](https://github.com/Thamirawaran/JaseciBench-vault/blob/main/.github/workflows/grade-submission.yml)
- Official runner: [`jac-code/eval/jasecibench/runner.py`](https://github.com/jaseci-labs/jac-code/blob/main/eval/jasecibench/runner.py)
