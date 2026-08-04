"""HumanEval model-eval runner, written in Jac.

Prompt a model, splice its completion into the task, and grade it.
pass@1 (greedy), two languages from the SAME 164 underlying HumanEval tasks:

  - jac     : tasks in ../jaclang/HumanEval_*.jac (bodyless `def ...;` + a
              `test "Check candidate function"` block). The model implements the
              body; we splice it back and grade with `jac test` (NOT `jac run`,
              which does not execute test blocks).
  - python  : the original HumanEval dataset (prompt / test / entry_point) from
              data/HumanEval.jsonl.gz; standard exec(prompt+completion+test).

Providers: OpenAI (gpt-*) and Anthropic (claude-*), inferred from --model.

Usage:
    jac run run_humaneval.jac --model gpt-5.4 --lang both --workers 8
    jac run run_humaneval.jac --model claude-sonnet-4-6 --lang jac --primed
"""

import os;
import sys;
import re;
import json;
import gzip;
import subprocess;
import tempfile;
import from pathlib { Path }
import from concurrent.futures { ThreadPoolExecutor, as_completed }

# Everything is resolved from this file's own location so the runner works on
# any checkout. The Python HumanEval dataset is not vendored (licence + size),
# so `--lang python|both` needs HUMANEVAL_DATASET pointing at HumanEval.jsonl.gz;
# `--lang jac` is self-contained and needs nothing.
glob HERE: Path = Path(__file__).resolve().parent;
glob SUITE: Path = HERE.parent;
glob REPO_ROOT: str = str(SUITE.parents[2]);
glob JAC_DIR: str = str(SUITE / "jaclang");
glob DATASET: str = os.environ.get("HUMANEVAL_DATASET", "");
glob TEST_HEADER: str = 'test "Check candidate function"';

glob JAC_SYSTEM: str =
    "You are an expert Jac programmer. Jac is a superset of Python with C-style "
    "braces and semicolons. Implement the requested function in idiomatic Jac. "
    "Return ONLY the complete function definition (def name(...) -> ret { ... }) "
    "plus any imports it needs. Do NOT include any test block, explanation, or "
    "markdown fences.";

glob JAC_PRIMER: str =
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
    "builtins (len/sum/sorted/range/enumerate/abs/min/max).";

glob PY_SYSTEM: str =
    "You are an expert Python programmer. Implement the requested function. "
    "Return ONLY the complete function definition plus any imports it needs. "
    "No explanation, no markdown fences, no tests.";


# --------------------------------------------------------------------------- #
# env + model client
# --------------------------------------------------------------------------- #
def load_dotenv(path: str) -> None {
    p = Path(path);
    if not p.exists() {
        return;
    }
    for line in p.read_text().splitlines() {
        m = re.match(r'\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*"?([^"]*)"?\s*$', line);
        if m {
            os.environ.setdefault(m.group(1), m.group(2));
        }
    }
}


def provider_for(model: str) -> str {
    m = model.lower();
    if m.startswith("claude") or m.startswith("anthropic") {
        return "anthropic";
    }
    return "openai";
}


def make_client(provider: str) -> any {
    if provider == "anthropic" {
        import anthropic;
        return anthropic.Anthropic();
    }
    import from openai { OpenAI }
    return OpenAI();
}


def complete(client: any, provider: str, model: str, system: str, user: str) -> str {
    if provider == "anthropic" {
        r = client.messages.create(
            model=model, max_tokens=8192, system=system,
            messages=[{"role": "user", "content": user}],
        );
        return "".join([b.text for b in r.content if b.type == "text"]);
    }
    r = client.chat.completions.create(
        model=model,
        messages=[{"role": "system", "content": system},
                  {"role": "user", "content": user}],
    );
    return r.choices[0].message.content or "";
}


def strip_fences(text: str) -> str {
    m = re.search(r"```[a-zA-Z]*\n(.*?)```", text, re.DOTALL);
    out = m.group(1) if m else text;
    return out.strip();
}


def dedupe_imports(blocks: list) -> tuple {
    imports: list = [];
    seen: dict = {};
    rest: list = [];
    for block in blocks {
        for line in block.splitlines() {
            if re.match(r"\s*import\b", line) {
                key = line.strip();
                # `import from X { ... }` takes NO trailing semicolon in Jac;
                # strip one if a model added it (a common, fatal mistake).
                if key.startswith("import from") and key.endswith("};") {
                    key = key[:-1];
                }
                if key not in seen {
                    seen[key] = True;
                    imports.append(key);
                }
            } else {
                rest.append(line);
            }
        }
    }
    return (imports, "\n".join(rest).strip());
}


def header_imports_only(header: str) -> str {
    lines = [l for l in header.splitlines() if re.match(r"\s*import\b", l)];
    return "\n".join(lines);
}


# --------------------------------------------------------------------------- #
# JAC
# --------------------------------------------------------------------------- #
def jac_prompt(task_text: str) -> tuple {
    idx = task_text.index(TEST_HEADER);
    header = task_text[:idx].rstrip();
    test_block = task_text[idx:].rstrip();
    return (header, test_block);
}


def build_jac_program(header: str, model_code: str, test_block: str) -> str {
    (imports, body) = dedupe_imports([header_imports_only(header), model_code]);
    body = re.split(r'\n\s*test\s+"', body)[0].rstrip();
    parts: list = [];
    if imports {
        parts.append("\n".join(imports));
    }
    parts.append(body);
    parts.append(test_block);
    return "\n\n".join(parts) + "\n";
}


def grade_jac(program: str, timeout: int = 60) -> tuple {
    with tempfile.TemporaryDirectory() as d {
        f = Path(d) / "task.jac";
        f.write_text(program);
        try {
            # JAC_TEST_NATIVE=1: serial native runner. jaclang 0.34.8 defaults
            # `jac test` to parallel pytest (xdist), whose cold-start worker
            # races make grading nondeterministic; the native runner is
            # deterministic (and returncode-correct on failure).
            env: dict[str, str] = dict(os.environ);
            env["JAC_TEST_NATIVE"] = "1";
            p = subprocess.run(["jac", "test", str(f)], capture_output=True,
                               text=True, timeout=timeout, cwd=d, env=env);
        } except subprocess.TimeoutExpired {
            return (False, "timeout");
        }
        detail = (p.stderr or p.stdout).strip();
        return (p.returncode == 0, detail[-800:]);
    }
}


def run_jac_task(client: any, provider: str, model: str, path: any,
                 primed: bool = False) -> dict {
    text = path.read_text();
    (header, test_block) = jac_prompt(text);
    user = "Implement the following Jac function. The docstring specifies the "
           "behavior. Replace the bodyless declaration with a full implementation.\n\n"
           + header + "\n";
    system = JAC_SYSTEM + (JAC_PRIMER if primed else "");
    try {
        raw = complete(client, provider, model, system, user);
    } except Exception as e {
        return {"task": path.stem, "status": "model_error", "detail": str(e)[:300]};
    }
    code = strip_fences(raw);
    program = build_jac_program(header, code, test_block);
    (ok, detail) = grade_jac(program);
    return {"task": path.stem, "status": "pass" if ok else "fail",
            "program": program, "detail": "" if ok else detail};
}


# --------------------------------------------------------------------------- #
# PYTHON
# --------------------------------------------------------------------------- #
def load_python_tasks() -> list {
    if not DATASET {
        raise SystemExit(
            "--lang python/both needs the upstream HumanEval dataset, which is "
            "not vendored here. Set HUMANEVAL_DATASET to a HumanEval.jsonl.gz "
            "(from openai/human-eval), or use --lang jac, which is self-contained."
        );
    }
    if not Path(DATASET).is_file() {
        raise SystemExit(f"HUMANEVAL_DATASET does not exist: {DATASET}");
    }
    return [json.loads(l) for l in gzip.open(DATASET, "rt")];
}


def build_py_program(prompt: str, model_code: str, tests: str, entry_pt: str) -> str {
    head_imports = "\n".join(
        [l for l in prompt.splitlines() if re.match(r"\s*(import|from)\b", l)]
    );
    (imports, body) = dedupe_imports([head_imports, model_code]);
    parts: list = [];
    if imports {
        parts.append("\n".join(imports));
    }
    parts.append(body);
    parts.append(tests);
    parts.append(f"check({entry_pt})");
    return "\n\n".join(parts) + "\n";
}


def grade_python(program: str, timeout: int = 30) -> tuple {
    with tempfile.TemporaryDirectory() as d {
        f = Path(d) / "task.py";
        f.write_text(program);
        try {
            p = subprocess.run([sys.executable, str(f)], capture_output=True,
                               text=True, timeout=timeout, cwd=d);
        } except subprocess.TimeoutExpired {
            return (False, "timeout");
        }
        return (p.returncode == 0, p.stderr.strip()[-800:]);
    }
}


def run_py_task(client: any, provider: str, model: str, row: dict) -> dict {
    name = row["task_id"].replace("/", "_");
    user = "Implement this Python function:\n\n" + row["prompt"];
    try {
        raw = complete(client, provider, model, PY_SYSTEM, user);
    } except Exception as e {
        return {"task": name, "status": "model_error", "detail": str(e)[:300]};
    }
    code = strip_fences(raw);
    program = build_py_program(row["prompt"], code, row["test"], row["entry_point"]);
    (ok, detail) = grade_python(program);
    return {"task": name, "status": "pass" if ok else "fail",
            "program": program, "detail": "" if ok else detail};
}


# --------------------------------------------------------------------------- #
# orchestration
# --------------------------------------------------------------------------- #
def run_lang(lang: str, client: any, provider: str, model: str, limit: int,
             workers: int, out_dir: any, primed: bool = False) -> dict {
    items: list = [];
    if lang == "jac" {
        items = sorted(
            [p for p in Path(JAC_DIR).glob("HumanEval_*.jac")],
            key=lambda (p: any) { int(p.stem.split("_")[1]); },
        );
    } else {
        items = load_python_tasks();
        items = sorted(items, key=lambda (r: dict) { int(r["task_id"].split("/")[1]); });
    }
    if limit {
        items = items[:limit];
    }

    lang_out = out_dir / lang;
    lang_out.mkdir(parents=True, exist_ok=True);
    results: list = [];
    print(f"[{lang}] running {len(items)} tasks with {workers} workers", flush=True);

    with ThreadPoolExecutor(max_workers=workers) as ex {
        futs: dict = {};
        for it in items {
            if lang == "jac" {
                fu = ex.submit(run_jac_task, client, provider, model, it, primed);
            } else {
                fu = ex.submit(run_py_task, client, provider, model, it);
            }
            futs[fu] = it;
        }
        done = 0;
        for fu in as_completed(futs) {
            r = fu.result();
            done += 1;
            if "program" in r {
                prog = r.pop("program");
                ext = "jac" if lang == "jac" else "py";
                (lang_out / (r["task"] + "." + ext)).write_text(prog);
            }
            results.append(r);
            mark = {"pass": "PASS", "fail": "fail",
                    "model_error": "ERR"}.get(r["status"], "?");
            print(f"[{lang} {done:3d}/{len(items)}] {r['task']}: {mark}", flush=True);
        }
    }

    passed = len([r for r in results if r["status"] == "pass"]);
    total = len(results);
    rate = round(passed / total, 4) if total else 0.0;
    summary = {
        "lang": lang, "model": model, "metric": "pass@1 (greedy)",
        "total": total, "passed": passed, "pass@1": rate,
        "results": sorted(results, key=lambda (r: dict) { r["task"]; }),
    };
    (out_dir / ("report_" + lang + ".json")).write_text(json.dumps(summary, indent=2));
    print(f"[{lang}] pass@1 = {passed}/{total} = {rate:.1%}", flush=True);
    return summary;
}


with entry {
    import argparse;
    ap = argparse.ArgumentParser();
    ap.add_argument("--lang", choices=["jac", "python", "both"], default="both");
    ap.add_argument("--model", default=os.environ.get("MODEL", "gpt-5.4"));
    ap.add_argument("--limit", type=int, default=0, help="0 = all 164 tasks");
    ap.add_argument("--workers", type=int, default=6);
    ap.add_argument("--out", default=REPO_ROOT + "/eval_runs/humaneval_modeleval");
    ap.add_argument("--primed", action="store_true",
                    help="prepend the verified Jac syntax primer (Jac only)");
    ap.add_argument("--tag", default="", help="suffix for the output dir");
    ap.add_argument("--provider", choices=["openai", "anthropic"], default=None);
    (args, unknown) = ap.parse_known_args();

    load_dotenv(REPO_ROOT + "/.env");
    provider = args.provider if args.provider else provider_for(args.model);
    key_var = "ANTHROPIC_API_KEY" if provider == "anthropic" else "OPENAI_API_KEY";
    if not os.environ.get(key_var) {
        print(f"{key_var} not set (.env or env)", file=sys.stderr);
        sys.exit(2);
    }
    client = make_client(provider);
    print(f"provider={provider} model={args.model}", flush=True);

    tag = args.tag if args.tag else ("primed" if args.primed else "");
    dir_name = (args.model + "_" + tag) if tag else args.model;
    out_dir = Path(args.out) / dir_name;
    out_dir.mkdir(parents=True, exist_ok=True);
    langs = ["jac", "python"] if args.lang == "both" else [args.lang];

    summaries: dict = {};
    for lang in langs {
        summaries[lang] = run_lang(lang, client, provider, args.model, args.limit,
                                   args.workers, out_dir, args.primed);
    }

    print("\n=== SUMMARY ===");
    out_results: dict = {};
    for (lang, s) in summaries.items() {
        print(f"{lang:7s} {args.model}: pass@1 {s['passed']}/{s['total']} = {s['pass@1']:.1%}");
        out_results[lang] = {"total": s["total"], "passed": s["passed"],
                             "pass@1": s["pass@1"]};
    }
    (out_dir / "summary.json").write_text(
        json.dumps({"model": args.model, "results": out_results}, indent=2)
    );
}
