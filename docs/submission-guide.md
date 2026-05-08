# Submission guide

Two ways to evaluate your agent on JaseciBench — local testing before
you're ready to go public, and a PR-based submission for the official
leaderboard.

---

## 1. Local evaluation (test before submitting)

Use this when you want fast feedback during development without opening
a PR. The hidden tests stay in the vault — you never see them, just the
score.

**Step 1 — Get an eval token**

Ask a maintainer for a `JASECIBENCH_EVAL_TOKEN`. It is a fine-grained
GitHub PAT scoped to the vault with Actions access only.

**Step 2 — Apply your fix and push**

Your code must be on GitHub for the vault to check it out.

```bash
# Apply your changes to the calculator app, then:
git add .
git commit -m "my agent's fix"
git push origin my-branch
```

**Step 3 — Run the grader**

```bash
cd /path/to/JaseciBench
export JASECIBENCH_EVAL_TOKEN=ghp_xxxx
./scripts/grade
```

The script detects your current branch and SHA automatically, triggers
the vault's grading workflow, and streams the results back to your
terminal — no PR, no browser.

**Example output**

```
JaseciBench local grade
  candidate : YourOrg/JaseciBench @ abc1234567
  vault     : Thamirawaran/JaseciBench-vault

Dispatching grading workflow ...
Run found: https://github.com/.../actions/runs/123456
Polling run 123456 ...

--- Results ---
**1 / 3 tasks passed**
| Task                       | Score     | Status    |
| `0001-add-modulo-operator` | 1.0 / 1.0 | PASS pass |
| `0002-add-backspace-key`   | 0.0 / 1.0 | FAIL pass |
| `0003-add-history-sum`     | 0.0 / 1.0 | FAIL pass |
```

---

## 2. Official leaderboard submission (open a PR)

Use this when your agent is ready and you want a row on the public
leaderboard.

**Step 1 — Fork and branch**

Fork `Thamirawaran/JaseciBench`, create a branch, and apply your
agent's changes to the calculator app.

**Step 2 — Open a PR**

Push your branch and open a pull request against `main`. Public CI
runs automatically — it checks that:
- `jac check main.jac` passes (your changes type-check)
- All 10 baseline tests still pass (you haven't broken existing behaviour)
- Every task directory has its required public files

**Step 3 — Request hidden grading**

Once CI is green, ask a maintainer to trigger the `grade-pr` workflow.
They click **Run workflow** in the Actions tab, enter your PR number,
and ~2 minutes later the vault posts a score table as a comment on
your PR.

**Step 4 — Iterate or merge**

If the score looks good, the maintainer merges your PR and your result
appears on the leaderboard. If not, push more commits to the same branch
and request grading again.

---

## What the grader checks

Each task in the calculator benchmark is scored across three stages:

| Stage | What it checks | Required? |
|---|---|---|
| `type_check` | `jac check main.jac` passes | Yes — fail = 0 score |
| `baseline` | All 10 existing tests still pass | Yes — fail = 0 score |
| `hidden` | Hidden tests specific to the task | No — weighted score |

A task is fully resolved only when `score == max_score`. Passing the
gates but failing the hidden tests gives partial credit.
