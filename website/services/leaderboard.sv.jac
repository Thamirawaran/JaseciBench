"""Leaderboard data service — load submissions from disk + serve them.

JSON files live at <website-jac>/leaderboard-data/<layer>/*.json. The
layer is one of: model, agent, app. Each file matches the JSON Schema
at the public repo's leaderboard-data/schemas/<layer>_eval_v1.json.

Loaded once at server startup into a module-level cache. Served via
def:pub get_submissions(layer) — the rows are flattened to dotted-key
form on the server (e.g. `{"model.display_name": "X", "scores.pass_at_1":
0.5}`) so the client can render them with a single .keys() loop and no
nested-dict gymnastics. (The cl→JS transpiler chokes on isinstance +
dynamic dict access.)
"""

import json;
import from pathlib { Path }


# Module-level cache keyed by layer ("model" / "agent" / "app").
glob submissions_cache: dict[str, list[dict[str, any]]] = {};


def _data_root -> Path {
    here = Path(str(__file__)).resolve();
    return here.parent.parent / "leaderboard-data";
}


def _flatten(d: dict, prefix: str, out: dict) {
    # Recursively flatten {"a": {"b": 1}} -> {"a.b": 1}. Lists land as-is.
    for (k, v) in d.items() {
        key = (prefix + "." + str(k)) if prefix else str(k);
        if isinstance(v, dict) {
            _flatten(v, key, out);
        } else {
            out[key] = v;
        }
    }
}


def load_submissions_from_disk {
    global submissions_cache;
    root = _data_root();
    layers = ["model", "agent", "app"];
    submissions_cache = {};
    for layer in layers {
        layer_dir = root / layer;
        rows = [];
        if layer_dir.is_dir() {
            for p in sorted(layer_dir.iterdir()) {
                if p.is_file() and p.suffix == ".json" {
                    raw = json.loads(p.read_text(encoding="utf-8"));
                    flat = {};
                    _flatten(raw, "", flat);
                    rows.append(flat);
                }
            }
        }
        submissions_cache[layer] = rows;
    }
}


def:pub get_submissions(layer: str) -> list[dict] {
    return submissions_cache.get(layer, []);
}
