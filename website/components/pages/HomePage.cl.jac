"""Home — landing page with hero + three layer cards.

Mirrors the React Home.tsx: indigo-tinted gradient hero with title +
subtitle + two CTA buttons, then a three-column "explore the layers"
grid linking to each layer of the Leaderboard.
"""

import from "@jac/runtime" { Link }


def:pub LayerCard(slug: str, label: str, blurb: str, metric: str) -> JsxElement {
    return
        <Link
            to={"/leaderboard?layer=" + slug}
            className="group block rounded-xl border border-zinc-200 bg-white p-6 hover:border-accent hover:shadow-md transition-all"
        >
            <div className="flex items-center justify-between mb-3">
                <span className="text-xs font-mono uppercase tracking-wider text-zinc-400">
                    {slug}
                </span>
                <span className="px-2 py-0.5 rounded bg-accent-50 text-accent-700 text-[11px] font-mono font-semibold">
                    {metric}
                </span>
            </div>
            <h3 className="text-lg font-semibold text-zinc-900 mb-1.5 group-hover:text-accent transition-colors">
                {label}
            </h3>
            <p className="text-sm text-zinc-500 leading-relaxed m-0">
                {blurb}
            </p>
        </Link>;
}


def:pub HomePage -> JsxElement {
    return
        <div>
            <section className="bg-gradient-to-b from-accent-50 to-white">
                <div className="mx-auto max-w-7xl px-6 py-20 text-center">
                    <h1 className="text-4xl sm:text-5xl font-bold tracking-tight text-zinc-900 m-0">
                        How does language change what LLMs and coding agents can build — and where does
                        <span className="bg-gradient-to-r from-accent to-accent-700 bg-clip-text text-transparent">
                            {" Jac "}
                        </span>
                        change the result?
                    </h1>
                    <p className="mt-5 mx-auto max-w-2xl text-base sm:text-lg text-zinc-600 leading-relaxed">
                        JaseciBench runs the same tasks across multiple languages — Jac, Python, and
                        more — through three layers (model, agent, app) with one common methodology,
                        so you can see model performance language-by-language and quantify where Jac's
                        graph-native primitives change what's possible.
                    </p>
                    <div className="mt-8 flex items-center justify-center gap-3">
                        <Link
                            to="/leaderboard"
                            className="inline-flex items-center gap-2 rounded-lg bg-accent text-white px-5 py-2.5 text-sm font-medium hover:bg-accent-700 transition-colors shadow-sm"
                        >
                            View leaderboard
                        </Link>
                        <Link
                            to="/methodology"
                            className="inline-flex items-center gap-2 rounded-lg border border-zinc-300 bg-white text-zinc-800 px-5 py-2.5 text-sm font-medium hover:bg-zinc-50 transition-colors"
                        >
                            Methodology
                        </Link>
                        <Link
                            to="/submit"
                            className="inline-flex items-center gap-2 rounded-lg border border-zinc-300 bg-white text-zinc-800 px-5 py-2.5 text-sm font-medium hover:bg-zinc-50 transition-colors"
                        >
                            Submit a run
                        </Link>
                    </div>
                </div>
            </section>

            <section className="mx-auto max-w-7xl px-6 py-16">
                <div className="mb-8">
                    <h2 className="text-2xl font-bold tracking-tight text-zinc-900 m-0">
                        Explore the layers
                    </h2>
                    <p className="mt-1.5 text-sm text-zinc-500 m-0">
                        Three independent leaderboards, one common methodology — pick a layer to
                        dive in.
                    </p>
                </div>
                <div className="grid sm:grid-cols-3 gap-5">
                    <LayerCard
                        slug="model"
                        label="ModelEval"
                        metric="pass@1"
                        blurb="Base-model code-generation on the Jac port of HumanEval. Single inference per task, no agent loop."
                    />
                    <LayerCard
                        slug="agent"
                        label="CodeAgentEval"
                        metric="resolve_rate"
                        blurb="Coding-agent loop on a real Jaseci codebase. The agent reads files, runs the harness, iterates."
                    />
                    <LayerCard
                        slug="app"
                        label="AppAgentEval"
                        metric="composite / max"
                        blurb="Full application-build agents graded across functional and non-functional quality attributes."
                    />
                </div>
            </section>
        </div>;
}
