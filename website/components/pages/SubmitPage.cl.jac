"""Submit a run — numbered-step instructions for adding a leaderboard row.

Mirrors React Submit.tsx: 5 numbered steps, each with title + body and
an accent-colored circle on the left. Closing amber notice about the
v1.0 sandboxed runner.
"""


def:pub Step(num: int, title: str, body: str) -> JsxElement {
    return
        <div className="flex gap-4 mb-6">
            <div className="flex-shrink-0 inline-flex h-8 w-8 items-center justify-center rounded-full bg-accent text-white text-sm font-semibold">
                {str(num)}
            </div>
            <div className="flex-1 pt-1">
                <h3 className="text-base font-semibold text-zinc-900 m-0">
                    {title}
                </h3>
                <p className="mt-1.5 text-sm text-zinc-600 leading-relaxed m-0">
                    {body}
                </p>
            </div>
        </div>;
}


def:pub SubmitPage -> JsxElement {
    return
        <div className="mx-auto max-w-3xl px-6 py-12">
            <h1 className="text-3xl font-bold tracking-tight text-zinc-900 m-0">
                Submit a run
            </h1>
            <p className="mt-2 text-sm text-zinc-500 leading-relaxed mb-10">
                Every leaderboard row is a PR adding one JSON file. CI validates the schema; the
                maintainer triggers a vault re-run to confirm scores reproduce; the entry merges;
                the leaderboard rebuilds.
            </p>

            <Step
                num={1}
                title="Run your agent against the benchmark"
                body="Pick a layer (model / agent / app), run the appropriate benchmark against your model or agent, capture the raw scores per task / domain / tier as required by the layer's schema."
            />

            <Step
                num={2}
                title="Format the result as JSON"
                body="Match the JSON Schema for your layer (model_eval_v1.json, agent_eval_v1.json, app_eval_v1.json). The fastest path is to copy a sibling submission as a template and edit the values."
            />

            <Step
                num={3}
                title="Open a PR"
                body="Save the file as leaderboard-data/<layer>/<id>.json where <id> follows the convention <model>[+<agent>]--<benchmark>--<YYYY-MM-DD>. Open a PR on JaseciBench."
            />

            <Step
                num={4}
                title="CI validates and the vault reproduces"
                body="Public CI checks the JSON against the schema. A maintainer triggers the grade-pr workflow to dispatch the candidate to the private vault — if the reproduced scores diverge from your self-report, the PR is rejected."
            />

            <Step
                num={5}
                title="Merged → live"
                body="The leaderboard rebuilds on every merge. Your row appears within minutes."
            />

            <div className="mt-10 rounded-lg border border-amber-200 bg-amber-50 p-5">
                <p className="text-sm font-semibold text-amber-800 m-0">
                    Self-reported scores require maintainer trust until v1.0.
                </p>
                <p className="mt-1.5 text-sm text-amber-700 leading-relaxed m-0">
                    Today the grade-pr workflow runs candidate code in CI alongside the hidden
                    tests, suitable for trusted contributors. v1.0 ships a sandboxed runner that
                    isolates candidate code so external teams can submit without a maintainer in
                    the loop.
                </p>
            </div>
        </div>;
}
