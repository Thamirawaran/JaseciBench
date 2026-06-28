"""HumanEval model-eval runner: prompt a model, splice its completion, grade it.

Evaluates a base model's single-shot code generation (pass@1, greedy) on
HumanEval in two languages from the SAME 164 underlying tasks:

  - jac     : tasks in ../jaclang/HumanEval_*.jac (bodyless `def ...;` + a
              `test "Check candidate function"` block). The model implements the
              body; we splice it back and grade with `jac test`.
              IMPORTANT: `jac run` does NOT execute test blocks, so grading uses
              `jac test`.
  - python  : the original HumanEval dataset (prompt / test / entry_point) read
              from data/HumanEval.jsonl.gz. Standard exec(prompt+completion+test)
              grading.

Usage:
    export MODEL=gpt-5.4            # or pass --model
    python scripts/run_humaneval.py --lang both
    python scripts/run_humaneval.py --lang jac --limit 5     # quick smoke test
"""

from __future__ import annotations

import argparse
import gzip
import json
import os
import re
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

HERE = Path(__file__).resolve().parent
SUITE = HERE.parent                       # .../model/human_eval
JAC_DIR = SUITE / "jaclang"
REPO_ROOT = Path("/Users/thami/Documents/Work/repo")
DATASET = REPO_ROOT / "JaseciBenchmark-dev/layer1-model/humaneval-jac/data/HumanEval.jsonl.gz"

TEST_HEADER = 'test "Check candidate function"'


# --------------------------------------------------------------------------- #
# env + model client
# --------------------------------------------------------------------------- #
def load_dotenv(path: Path) -> None:
    if not path.exists():
        return
    for line in path.read_text().splitlines():
        m = re.match(r'\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*"?([^"]*)"?\s*$', line)
        if m:
            os.environ.setdefault(m.group(1), m.group(2))


def provider_for(model: str) -> str:
    """Infer the API provider from the model id."""
    m = model.lower()
    if m.startswith(("claude", "anthropic")):
        return "anthropic"
    return "openai"


def make_client(provider: str):
    if provider == "anthropic":
        import anthropic
        return anthropic.Anthropic()
    from openai import OpenAI
    return OpenAI()


def complete(client, provider: str, model: str, system: str, user: str) -> str:
    if provider == "anthropic":
        r = client.messages.create(
            model=model,
            max_tokens=8192,
            system=system,
            messages=[{"role": "user", "content": user}],
        )
        return "".join(b.text for b in r.content if b.type == "text")
    r = client.chat.completions.create(
        model=model,
        messages=[{"role": "system", "content": system},
                  {"role": "user", "content": user}],
    )
    return r.choices[0].message.content or ""


def strip_fences(text: str) -> str:
    """Pull code out of a ```lang ... ``` block if the model wrapped it."""
    m = re.search(r"```[a-zA-Z]*\n(.*?)```", text, re.DOTALL)
    return (m.group(1) if m else text).strip()


def dedupe_imports(*blocks: str) -> tuple[list[str], str]:
    """Return (ordered unique import lines, remaining non-import lines joined)."""
    imports: list[str] = []
    seen: set[str] = set()
    rest: list[str] = []
    for block in blocks:
        for line in block.splitlines():
            if re.match(r"\s*import\b", line):
                key = line.strip()
                # `import from X { ... }` takes NO trailing semicolon in Jac;
                # strip one if a model added it (a common, fatal mistake).
                if key.startswith("import from") and key.endswith("};"):
                    key = key[:-1]
                if key not in seen:
                    seen.add(key)
                    imports.append(key)
            else:
                rest.append(line)
    return imports, "\n".join(rest).strip()


# --------------------------------------------------------------------------- #
# JAC
# --------------------------------------------------------------------------- #
JAC_SYSTEM = (
    "You are an expert Jac programmer. Jac is a superset of Python with C-style "
    "braces and semicolons. Implement the requested function in idiomatic Jac. "
    "Return ONLY the complete function definition (def name(...) -> ret { ... }) "
    "plus any imports it needs. Do NOT include any test block, explanation, or "
    "markdown fences."
)

# Verified Jac syntax primer. Every rule checked against the real grader (`jac test`).
# Targets only the actual parse-level failure modes seen zero-shot; does NOT discourage
# valid Python-shared syntax, and says nothing about the static type checker (which
# `jac test` does not enforce).
JAC_PRIMER = (
    "\n\nJac syntax rules you MUST follow (Jac uses braces and semicolons):\n"
    "- Declare variables with a plain assignment. There is NO `let`/`var`/`const`. "
    "Write `x = 5;`  (NEVER `let x = 5;`).\n"
    "- Every statement ends with `;`. Code blocks use `{ }`.\n"
    "- Logical negation is the word `not`, not `!`. Use `and`/`or`; `!=` is fine.\n"
    "- Imports have two forms with DIFFERENT punctuation:\n"
    "    `import from typing { List, Optional }`   (block form, NO trailing semicolon)\n"
    "    `import math;`                            (simple form, WITH a semicolon)\n"
    "  NEVER use Python's `from typing import List`.\n"
    "- Tuple targets MUST be parenthesized: `for (k, v) in d.items() { ... }` and "
    "`(a, b) = (1, 2);` (NEVER `for k, v in ...`).\n"
    "- These work exactly like Python and are fine to use: f-strings, list/dict "
    "comprehensions, ternary `a if c else b`, slicing `s[::-1]`, `elif`, `while`, and "
    "builtins (len/sum/sorted/range/enumerate/abs/min/max)."
)


def jac_prompt(task_text: str) -> tuple[str, str]:
    """Split a .jac task into (prompt-shown-to-model, hidden test block)."""
    idx = task_text.index(TEST_HEADER)
    header = task_text[:idx].rstrip()        # imports + docstring + `def ...;`
    test_block = task_text[idx:].rstrip()
    return header, test_block


def build_jac_program(header: str, model_code: str, test_block: str) -> str:
    imports, body = dedupe_imports(header_imports_only(header), model_code)
    # body must not contain a stray test block the model emitted
    body = re.split(r'\n\s*test\s+"', body)[0].rstrip()
    parts = []
    if imports:
        parts.append("\n".join(imports))
    parts.append(body)
    parts.append(test_block)
    return "\n\n".join(parts) + "\n"


def header_imports_only(header: str) -> str:
    return "\n".join(l for l in header.splitlines() if re.match(r"\s*import\b", l))


def grade_jac(program: str, timeout: int = 60) -> tuple[bool, str]:
    with tempfile.TemporaryDirectory() as d:
        f = Path(d) / "task.jac"
        f.write_text(program, encoding="utf-8")
        try:
            # JAC_TEST_NATIVE=1: serial native runner. jaclang 0.30.2 defaults
            # `jac test` to parallel pytest (xdist), whose cold-start worker
            # races make grading nondeterministic; the native runner is
            # deterministic (and returncode-correct on failure).
            p = subprocess.run(["jac", "test", str(f)], capture_output=True,
                               text=True, timeout=timeout, cwd=d,
                               env={**os.environ, "JAC_TEST_NATIVE": "1"})
        except subprocess.TimeoutExpired:
            return False, "timeout"
        return p.returncode == 0, (p.stderr or p.stdout).strip()[-800:]


def run_jac_task(client, provider, model, path: Path, primed: bool = False) -> dict:
    text = path.read_text(encoding="utf-8")
    header, test_block = jac_prompt(text)
    user = (
        "Implement the following Jac function. The docstring specifies the "
        "behavior. Replace the bodyless declaration with a full implementation.\n\n"
        f"{header}\n"
    )
    system = JAC_SYSTEM + (JAC_PRIMER if primed else "")
    try:
        raw = complete(client, provider, model, system, user)
    except Exception as e:
        return {"task": path.stem, "status": "model_error", "detail": str(e)[:300]}
    code = strip_fences(raw)
    program = build_jac_program(header, code, test_block)
    ok, detail = grade_jac(program)
    return {"task": path.stem, "status": "pass" if ok else "fail",
            "program": program, "detail": "" if ok else detail}


# --------------------------------------------------------------------------- #
# PYTHON
# --------------------------------------------------------------------------- #
PY_SYSTEM = (
    "You are an expert Python programmer. Implement the requested function. "
    "Return ONLY the complete function definition plus any imports it needs. "
    "No explanation, no markdown fences, no tests."
)


def load_python_tasks() -> list[dict]:
    return [json.loads(l) for l in gzip.open(DATASET, "rt")]


def build_py_program(prompt: str, model_code: str, test: str, entry: str) -> str:
    imports, body = dedupe_imports(
        "\n".join(l for l in prompt.splitlines() if re.match(r"\s*(import|from)\b", l)),
        model_code,
    )
    parts = []
    if imports:
        parts.append("\n".join(imports))
    parts.append(body)
    parts.append(test)
    parts.append(f"check({entry})")
    return "\n\n".join(parts) + "\n"


def grade_python(program: str, timeout: int = 30) -> tuple[bool, str]:
    with tempfile.TemporaryDirectory() as d:
        f = Path(d) / "task.py"
        f.write_text(program, encoding="utf-8")
        try:
            p = subprocess.run([sys.executable, str(f)], capture_output=True,
                               text=True, timeout=timeout, cwd=d)
        except subprocess.TimeoutExpired:
            return False, "timeout"
        return p.returncode == 0, p.stderr.strip()[-800:]


def run_py_task(client, provider, model, row: dict) -> dict:
    name = row["task_id"].replace("/", "_")
    user = "Implement this Python function:\n\n" + row["prompt"]
    try:
        raw = complete(client, provider, model, PY_SYSTEM, user)
    except Exception as e:
        return {"task": name, "status": "model_error", "detail": str(e)[:300]}
    code = strip_fences(raw)
    program = build_py_program(row["prompt"], code, row["test"], row["entry_point"])
    ok, detail = grade_python(program)
    return {"task": name, "status": "pass" if ok else "fail",
            "program": program, "detail": "" if ok else detail}


# --------------------------------------------------------------------------- #
# orchestration
# --------------------------------------------------------------------------- #
def run_lang(lang: str, client, provider: str, model: str, limit: int, workers: int,
             out_dir: Path, primed: bool = False) -> dict:
    if lang == "jac":
        items = sorted(JAC_DIR.glob("HumanEval_*.jac"),
                       key=lambda p: int(p.stem.split("_")[1]))
        if limit:
            items = items[:limit]
        fn = lambda it: run_jac_task(client, provider, model, it, primed=primed)
    else:
        items = load_python_tasks()
        items.sort(key=lambda r: int(r["task_id"].split("/")[1]))
        if limit:
            items = items[:limit]
        fn = lambda it: run_py_task(client, provider, model, it)

    lang_out = out_dir / lang
    lang_out.mkdir(parents=True, exist_ok=True)
    results: list[dict] = []
    print(f"[{lang}] running {len(items)} tasks with {workers} workers", flush=True)
    with ThreadPoolExecutor(max_workers=workers) as ex:
        futs = {ex.submit(fn, it): it for it in items}
        done = 0
        for fut in as_completed(futs):
            r = fut.result()
            done += 1
            prog = r.pop("program", None)
            if prog is not None:
                ext = "jac" if lang == "jac" else "py"
                (lang_out / f"{r['task']}.{ext}").write_text(prog, encoding="utf-8")
            results.append(r)
            mark = {"pass": "PASS", "fail": "fail", "model_error": "ERR"}.get(r["status"], "?")
            print(f"[{lang} {done:3d}/{len(items)}] {r['task']}: {mark}", flush=True)

    passed = sum(1 for r in results if r["status"] == "pass")
    total = len(results)
    summary = {
        "lang": lang, "model": model, "metric": "pass@1 (greedy)",
        "total": total, "passed": passed,
        "pass@1": round(passed / total, 4) if total else 0.0,
        "results": sorted(results, key=lambda r: r["task"]),
    }
    (out_dir / f"report_{lang}.json").write_text(json.dumps(summary, indent=2),
                                                encoding="utf-8")
    print(f"[{lang}] pass@1 = {passed}/{total} = {summary['pass@1']:.1%}", flush=True)
    return summary


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lang", choices=["jac", "python", "both"], default="both")
    ap.add_argument("--model", default=os.environ.get("MODEL", "gpt-5.4"))
    ap.add_argument("--limit", type=int, default=0, help="0 = all 164 tasks")
    ap.add_argument("--workers", type=int, default=6)
    ap.add_argument("--out", default=str(REPO_ROOT / "eval_runs" /
                                        "humaneval_modeleval"))
    ap.add_argument("--primed", action="store_true",
                    help="prepend the verified Jac syntax primer (Jac only)")
    ap.add_argument("--tag", default="",
                    help="suffix for the output dir (keeps runs separate)")
    ap.add_argument("--provider", choices=["openai", "anthropic"], default=None,
                    help="default: inferred from --model (gpt*->openai, claude*->anthropic)")
    args = ap.parse_args()

    load_dotenv(REPO_ROOT / ".env")
    provider = args.provider or provider_for(args.model)
    key_var = "ANTHROPIC_API_KEY" if provider == "anthropic" else "OPENAI_API_KEY"
    if not os.environ.get(key_var):
        print(f"{key_var} not set (.env or env)", file=sys.stderr)
        return 2
    client = make_client(provider)
    print(f"provider={provider} model={args.model}", flush=True)

    tag = args.tag or ("primed" if args.primed else "")
    out_dir = Path(args.out) / (f"{args.model}_{tag}" if tag else f"{args.model}")
    out_dir.mkdir(parents=True, exist_ok=True)
    langs = ["jac", "python"] if args.lang == "both" else [args.lang]

    summaries = {}
    for lang in langs:
        summaries[lang] = run_lang(lang, client, provider, args.model, args.limit,
                                   args.workers, out_dir, primed=args.primed)

    print("\n=== SUMMARY ===")
    for lang, s in summaries.items():
        print(f"{lang:7s} {args.model}: pass@1 {s['passed']}/{s['total']} "
              f"= {s['pass@1']:.1%}")
    (out_dir / "summary.json").write_text(
        json.dumps({"model": args.model,
                    "results": {k: {kk: v[kk] for kk in
                                    ("total", "passed", "pass@1")}
                                for k, v in summaries.items()}}, indent=2),
        encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
