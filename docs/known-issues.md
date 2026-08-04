# Known issues

Tracked defects in the public suite. Grading-integrity issues are tracked
privately in the vault, since publishing them would help submitters bypass
scoring.

---

## ModelEval

### HumanEval_115 has no specification

`suite/model/human_eval/jaclang/HumanEval_115.jac` is the only task of 164 with
no docstring:

```jac
def max_fill(grid: Any, capacity: Any) -> int;
```

Upstream `openai/human-eval` puts this problem's docstring *after* `import math`
inside the function body, so the port dropped it. The task is unsolvable from
the prompt and passable only by training-data recall, which deflates pass@1 for
every model measured.

Fix: restore the upstream prose as a leading docstring. Since it changes what
models are asked, any previously published `HumanEval_115` result is not
comparable across the change.

### 103 of 164 tasks type their parameters `Any`

Signatures such as `def max_fill(grid: Any, capacity: Any)` mirror upstream
Python, which is untyped there. It is a faithful port, but it means two thirds
of Layer 1 exercises none of Jac's strict typing, which is the thing this suite
exists to measure. Worth a deliberate decision: keep fidelity to upstream, or
fork a typed variant and report both.

---

## Tooling

### Both ModelEval runners hardcode an absolute path

`scripts/run_humaneval.jac:30` and `scripts/run_humaneval.py:37` both contain:

```
/Users/thami/Documents/Work/repo
```

The `.jac` runner additionally hardcodes `JAC_DIR` from it, while the `.py`
runner at least derives `HERE`/`SUITE` from `__file__`. Neither works on any
other checkout without editing source, in a repository that is public.

Both also point `DATASET` at `JaseciBenchmark-dev/layer1-model/...`, a path that
does not exist in a clean `official/` checkout, so `--lang python` and
`--lang both` fail with `FileNotFoundError`. Only `--lang jac` is self-contained.

Fix: derive the suite root from `__file__` (or the Jac equivalent) and vendor or
document the dataset.

### Two runners for one job

`scripts/run_humaneval.py` (362 loc) and `scripts/run_humaneval.jac` (388 loc)
are parallel implementations of the same runner. They have already drifted: the
0.34.8 syntax migration touched the `.jac` copy in `b134d1b` and left the `.py`
copy untouched.

Nothing in CI or docs invokes the `.py` version. Keeping both means every future
change needs doing twice, with no mechanism to detect divergence. The suite's
stated preference is Jac, so the `.py` copy is the one to retire, once the
hardcoded-path fix above lands in the `.jac` copy.
