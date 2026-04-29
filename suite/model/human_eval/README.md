# HumanEval — JaseciBench Layer 1 (Model)

Jac port of the HumanEval benchmark for evaluating base-model code-generation
capability. Built on top of the original [openai/human-eval](https://github.com/openai/human-eval)
dataset (Chen et al., 2021), with the Python tasks transpiled to Jac via the
`jac py2jac` compiler.

## Layout

```
human_eval/
├── README.md                # this file
├── LICENSE                  # OpenAI's MIT license, verbatim from upstream
├── CITATION.bib             # cite the original Codex paper + this benchmark
└── jaclang/                 # the Jac port
    ├── HumanEval_0.jac      # 164 .jac files, one per task
    ├── HumanEval_1.jac
    └── ...                  # HumanEval_2.jac … HumanEval_163.jac
```

## Provenance & modifications

- **Source**: HumanEval, [openai/human-eval](https://github.com/openai/human-eval),
  the dataset associated with the Codex paper (Chen et al., 2021).
- **License**: MIT (OpenAI). Their license is included verbatim at
  [`LICENSE`](LICENSE) and applies to the Jac task files in `jaclang/`.
- **Modification**: the 164 Python tasks are transpiled to Jac via `jac py2jac`
  (the official Jac compiler's Python-to-Jac mode). Test semantics are
  preserved verbatim — the same hidden assertions decide pass/fail in either
  language.

## Citation

If you use these results, please cite **both** the original Codex paper and
JaseciBench — see [`CITATION.bib`](CITATION.bib).

## Status

164 / 164 tasks transpile cleanly with `jac py2jac`. 164 / 164 pass `jac run`
on the canonical solution.
