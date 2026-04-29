"""Methodology — explainer page for the three-layer architecture.

Three sections (one per layer) + closing "Not measured (yet)" section.
Each layer has a CANONICAL RANK number callout and a DRILL-DOWN list.
"""


def:pub Definition(label: str, term: str, note: str) -> JsxElement {
    return
        <div className="rounded-lg border border-zinc-200 bg-white p-4 mb-3">
            <div className="text-[11px] uppercase tracking-wider text-zinc-500 font-semibold mb-1.5">
                {label}
            </div>
            <div className="font-mono text-accent-700 text-sm font-semibold mb-1">
                {term}
            </div>
            <p className="text-sm text-zinc-600 leading-relaxed m-0">
                {note}
            </p>
        </div>;
}


def:pub LayerSection(title: str, description: str, metric_term: str, metric_note: str, drill_term: str, drill_note: str) -> JsxElement {
    return
        <section className="mb-12">
            <h2 className="text-xl font-semibold tracking-tight text-zinc-900 mb-3 m-0">
                {title}
            </h2>
            <p className="text-sm text-zinc-600 leading-relaxed mb-4">
                {description}
            </p>
            <Definition label="Canonical rank-defining number" term={metric_term} note={metric_note} />
            <Definition label="Drill-down" term={drill_term} note={drill_note} />
        </section>;
}


def:pub MethodologyPage -> JsxElement {
    return
        <div className="mx-auto max-w-3xl px-6 py-12">
            <h1 className="text-3xl font-bold tracking-tight text-zinc-900 m-0">
                Methodology
            </h1>
            <p className="mt-2 text-sm text-zinc-500 leading-relaxed mb-10">
                Three layers, one common pattern: every entry is a (model, agent, benchmark,
                run-date) tuple, scored against the same task set, ranked by one canonical
                number per layer.
            </p>

            <h2 className="text-lg font-semibold text-zinc-900 mb-2 m-0">The three layers</h2>
            <p className="text-sm text-zinc-600 leading-relaxed mb-8">
                A modern coding system is the composition of a model, an agent, and a deployment
                target. JaseciBench scores each independently so progress in one layer is
                visible without being absorbed into the others.
            </p>

            <LayerSection
                title="ModelEval"
                description="Measures the base model's ability to write Jac code without any agent loop — single inference per task, no retries, no tool use. Anchored on a Jac port of HumanEval generated via the jac py2jac transpiler."
                metric_term="pass@1"
                metric_note="The standard rate from the Codex paper: probability that a single sample passes every hidden test."
                drill_term="By difficulty (basic / intermediate / advanced) and by domain (graph, string, data structures, algorithms, systems, web/api, database, ML)."
                drill_note="Click any model row in the leaderboard to expand."
            />

            <LayerSection
                title="CodeAgentEval"
                description="Measures full agent loops on a real Jaseci codebase — the agent reads files, runs the test harness, iterates. Modeled on SWE-bench and adapted for Jac's .sv.jac / .cl.jac split."
                metric_term="resolve_rate"
                metric_note="Fraction of tasks for which the agent's patch passes hidden tests, baseline tests still pass, and jac check exits clean."
                drill_term="By layer (sv-only / cl-only / spanning) and by tier (1 / 2 / 3)."
                drill_note="Diagnostic axes: tool selection, error recovery, average tokens, average tool calls."
            />

            <LayerSection
                title="AppAgentEval"
                description="Measures app-builder agents that ship a complete Jaseci application from a spec. Quality is judged across functional and non-functional attributes."
                metric_term="composite / max"
                metric_note="Sum of weighted attribute scores normalized to a known maximum."
                drill_term="By attribute (correctness / completeness / security / performance / readability / maintainability) and by scope."
                drill_note="Each axis carries an explicit rubric used by the grading harness."
            />

            <h2 className="text-lg font-semibold text-zinc-900 mb-2 m-0 mt-8">
                What's deliberately not measured (yet)
            </h2>
            <ul className="list-disc pl-5 text-sm text-zinc-600 leading-relaxed space-y-1.5">
                <li>Cost-per-correct-solution charts — added in v0.2 once estimated_cost_usd lands across submissions.</li>
                <li>Latency / wall-clock time — agents are timed but not ranked on it until the harness wraps a sandboxed runner in v1.0.</li>
                <li>Adversarial submissions — current grading runs candidate code in CI; sandboxed grading is on the v1.0 roadmap.</li>
            </ul>
        </div>;
}
