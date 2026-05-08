# JaseciBench

A multi-language, multi-layer benchmark suite for evaluating LLMs and
coding agents on [Jac](https://www.jac-lang.org/) and the
[Jaseci](https://www.jaseci.org/) stack.

JaseciBench runs the same tasks across multiple languages — Jac, Python,
and more — so you can measure model and agent performance
language-by-language and see where Jac's graph-native primitives change
the result.

## Three evaluation layers

| Layer | What it measures | Headline metric |
|---|---|---|
| **ModelEval** | Base-model code-generation capability — single inference, no agent loop | `pass@1` |
| **CodeAgentEval** | Full coding-agent loop on a real Jaseci codebase — reads files, runs tests, iterates | `resolve_rate` |
| **AppAgentEval** | End-to-end application quality — agent ships a working app from a spec | `composite / max` |

## Repo layout

```
JaseciBench/
├── suite/
│   ├── model/human_eval/          Jac port of HumanEval (164 tasks)
│   └── agent/basic/calculator/    Reference Jaseci app + 3 agent tasks
├── website/                       Jac-native leaderboard (jac start main.jac)
├── docs/                          Guides and documentation
├── scripts/grade                  Local evaluation CLI (no PR needed)
└── .github/workflows/
    ├── ci.yml                     Type-check + baseline tests on every PR
    └── grade-pr.yml               Maintainer-triggered hidden grading
```

Hidden test suites, reference solutions, and the scoring oracle live in
the companion private repo **JaseciBench-vault**.

## Evaluate your agent

**Option 1 — Local testing** (fast feedback, no PR required)

Get an eval token from a maintainer, then:

```bash
export JASECIBENCH_EVAL_TOKEN=ghp_xxxx
./scripts/grade
```

Dispatches the vault's grading workflow, polls until done, and streams
the score table back to your terminal.

**Option 2 — PR submission** (official leaderboard row)

Fork this repo, apply your agent's changes, open a pull request. CI
runs automatically (type-check + baseline tests). When ready, ask a
maintainer to trigger the `grade-pr` workflow — results appear as a
comment on your PR ~2 minutes later.

Full details: [**docs/submission-guide.md**](docs/submission-guide.md)

## Run the leaderboard locally

```bash
cd website
jac install
jac start main.jac   # opens at http://localhost:8000
```

Requires Python 3.12+ and `jaclang>=0.14` (`pip install jaclang`).

## License

[MIT](LICENSE) — vendored upstream benchmarks carry their own licenses
alongside the data (e.g. [`suite/model/human_eval/LICENSE`](suite/model/human_eval/LICENSE)).
