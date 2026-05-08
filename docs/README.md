# Docs

Documentation for JaseciBench — a multi-language, multi-layer benchmark
suite for evaluating LLMs and coding agents on Jac and the Jaseci stack.

## What's in this repo

| Path | What it is |
|---|---|
| `suite/model/human_eval/` | Jac port of HumanEval (164 tasks via `jac py2jac`) |
| `suite/agent/basic/calculator/` | Calculator reference app + 3 agent tasks |
| `website/` | Jac-native leaderboard site (`jac start main.jac`) |
| `.github/workflows/` | CI (type-check + baselines) + `grade-pr` dispatcher |

Hidden grading tests, reference solutions, and the scoring oracle live
in the companion private repo **JaseciBench-vault**.

## Quick links

- [Leaderboard](../website/) — `cd website && jac install && jac start main.jac`
- [Submit a run](../website/components/pages/SubmitPage.cl.jac) — open a PR adding a JSON file under `leaderboard-data/<layer>/`
- [Benchmark tasks](../suite/agent/basic/calculator/jaclang/tasks/) — each task has an `issue.md` with the agent's prompt

See [`submission-guide.md`](submission-guide.md) for how to evaluate your agent locally and how to submit to the leaderboard.

More docs — architecture, contributing — coming soon.
