# Known issues

Tracked defects in the public suite. Grading-integrity issues are tracked
privately in the vault, since publishing them would help submitters bypass
scoring.

| Issue | Status |
|---|---|
| HumanEval_115 has no specification | **fixed** |
| Runners hardcode an absolute path | **fixed** |
| Two runners for one job | **fixed** |
| 103 of 164 tasks type parameters `Any` | open, needs a decision |

---

## ModelEval

### HumanEval_115 has no specification — FIXED

`suite/model/human_eval/jaclang/HumanEval_115.jac` is the only task of 164 with
no docstring:

```jac
def max_fill(grid: Any, capacity: Any) -> int;
```

Upstream `openai/human-eval` puts this problem's docstring *after* `import math`
inside the function body, so the port dropped it. The task is unsolvable from
the prompt and passable only by training-data recall, which deflates pass@1 for
every model measured.

Fixed: the upstream prose is restored as a leading docstring, taken verbatim
from `HumanEval/115` in `openai/human-eval` rather than reconstructed. All 164
tasks now carry a specification.

Note the earlier statement that this was "the only file of 164 with no
docstring" is correct; a count of 18 seen mid-investigation was a bad grep that
missed the 17 tasks using `'''` instead of `"""`.

Because it changes what models are asked, any previously published
`HumanEval_115` result is not comparable across this change.

### 103 of 164 tasks type their parameters `Any`

Signatures such as `def max_fill(grid: Any, capacity: Any)` mirror upstream
Python, which is untyped there. It is a faithful port, but it means two thirds
of Layer 1 exercises none of Jac's strict typing, which is the thing this suite
exists to measure. Worth a deliberate decision: keep fidelity to upstream, or
fork a typed variant and report both.

---

## Tooling

### Both ModelEval runners hardcode an absolute path — FIXED

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

Fixed: `HERE`, `SUITE`, `JAC_DIR` and `REPO_ROOT` are now derived from
`Path(__file__).resolve().parent` (`__file__` works in Jac). The runner resolves
its 164 tasks on any checkout.

The dataset is not vendored (licence and size), so `--lang python|both` now reads
`HUMANEVAL_DATASET` and exits with an instruction naming `openai/human-eval`
when it is unset or missing, instead of a bare `FileNotFoundError` against a
path that only existed on one laptop. `--lang jac` needs nothing and stays
self-contained.

### Two runners for one job — FIXED

`scripts/run_humaneval.py` (362 loc) and `scripts/run_humaneval.jac` (388 loc)
are parallel implementations of the same runner. They have already drifted: the
0.34.8 syntax migration touched the `.jac` copy in `b134d1b` and left the `.py`
copy untouched.

Nothing in CI or docs invoked the `.py` version. Keeping both meant every future
change needed doing twice, with no mechanism to detect divergence.

Fixed: `run_humaneval.py` is deleted and the `.jac` copy carries the
`__file__`-relative path handling described above. **The public repo now
contains no Python at all.**
