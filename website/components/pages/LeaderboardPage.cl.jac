"""Leaderboard — Segmented switcher + active layer view.

Active layer is read from the `?layer=` query param on every render,
so deep-links from Home cards ("/leaderboard?layer=agent") land on the
right tab. Clicking a Segmented option uses useNavigate to update the
URL, which flows back through useLocation to flip the active layer.
Per-layer config (columns + blurb) lives in two helper functions
rather than a glob dict — sidesteps the `any`-typed-glob LSP issue
without changing the API.
"""

import from "@jac/runtime" { useLocation, useNavigate }
import from ..PageHeader { PageHeader }
import from ..Segmented { Segmented }
import from ..leaderboard.LayerView { LayerView }


def _columns_for(layer: str) -> list[list[str]] {
    if layer == "model" {
        return [
            ["model.display_name", "Model"],
            ["model.provider", "Provider"],
            ["benchmark", "Benchmark"],
            ["scores.pass_at_1", "pass@1"],
            ["scores.pass_at_10", "pass@10"],
            ["submitted_at", "Date"]
        ];
    }
    if layer == "agent" {
        return [
            ["model.display_name", "Model"],
            ["agent.display_name", "Agent"],
            ["benchmark", "Benchmark"],
            ["n_tasks", "Tasks"],
            ["scores.resolve_rate", "Resolve rate"],
            ["submitted_at", "Date"]
        ];
    }
    return [
        ["model.display_name", "Model"],
        ["agent.display_name", "Builder"],
        ["benchmark", "Benchmark"],
        ["scores.composite", "Composite"],
        ["scores.max_composite", "Max"],
        ["submitted_at", "Date"]
    ];
}


def _blurb_for(layer: str) -> str {
    if layer == "model" {
        return "Base-model capability across languages — same task semantics, different language targets — so you can compare model performance on Jac vs Python and see where the language choice changes the result.";
    }
    if layer == "agent" {
        return "Full-loop agent resolve rate on a real codebase. The agent reads files, runs the harness, iterates. Models are graded on the language(s) they targeted.";
    }
    return "Production-grade application quality. Composite of weighted attribute scores normalized to a known maximum — measured per (model, builder, target language) tuple.";
}


def _read_layer(search: str) -> str {
    marker = "layer=";
    idx = search.find(marker);
    if idx == -1 {
        return "model";
    }
    rest = search[(idx + len(marker)):];
    end = rest.find("&");
    candidate = rest[:end] if end != -1 else rest;
    if candidate in ["model", "agent", "app"] {
        return candidate;
    }
    return "model";
}


def:pub LeaderboardPage -> JsxElement {
    location = useLocation();
    nav = useNavigate();
    active = _read_layer(location.search);

    def set_active(layer: str) {
        nav("/leaderboard?layer=" + layer);
    }

    options = [["model", "ModelEval"], ["agent", "CodeAgentEval"], ["app", "AppAgentEval"]];

    return
        <div className="mx-auto max-w-7xl px-6 py-10">
            <PageHeader
                title="Leaderboard"
                description="One row per (model, agent, benchmark, run-date). Each layer presents its score in its native shape — pass@k for ModelEval, resolve_rate for CodeAgentEval, composite-out-of-max for AppAgentEval."
                metric=""
            />
            <div className="mb-6">
                <Segmented options={options} value={active} on_change={set_active} />
            </div>
            <LayerView
                layer={active}
                columns={_columns_for(active)}
                blurb={_blurb_for(active)}
            />
        </div>;
}
