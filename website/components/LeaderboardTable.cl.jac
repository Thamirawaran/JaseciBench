"""Polished leaderboard table — Tailwind-styled.

Empty state: dashed-border card with centered "no submissions" message.
Table: zinc-200 borders, zinc-50 header, mono numerics for score columns.
"""


def:pub LeaderboardTable(
    rows: list[dict],
    columns: list[list[str]]
) -> JsxElement {
    if len(rows) == 0 {
        return
            <div className="rounded-lg border border-dashed border-zinc-200 bg-white py-16 text-center">
                <p className="text-sm font-medium text-zinc-500 m-0">No submissions yet.</p>
                <p className="mt-1 text-xs text-zinc-400">
                    Open a PR adding a JSON file under
                    <code className="font-mono text-[11px] bg-zinc-100 px-1 py-0.5 rounded ml-1">
                        leaderboard-data/
                    </code>
                    to appear here.
                </p>
            </div>;
    }

    return
        <div className="rounded-lg border border-zinc-200 bg-white overflow-hidden">
            <table className="w-full text-sm">
                <thead>
                    <tr className="bg-zinc-50 border-b border-zinc-200">
                        {[<th
                            key={col[0]}
                            className="text-left px-4 py-2.5 text-[11px] font-semibold uppercase tracking-wider text-zinc-500"
                        >
                            {col[1]}
                        </th> for col in columns]}
                    </tr>
                </thead>
                <tbody>
                    {[<tr key={str(idx)} className="border-b border-zinc-100 last:border-b-0 hover:bg-zinc-50">
                        {[<td
                            key={col[0]}
                            className={(
                                "px-4 py-2.5 text-zinc-800 "
                                + ("font-mono" if col[0].startswith("scores.") or col[0] == "n_tasks" else "")
                            )}
                        >
                            {(str(row[col[0]]) if col[0] in row else "—")}
                        </td> for col in columns]}
                    </tr> for (idx, row) in enumerate(rows)]}
                </tbody>
            </table>
        </div>;
}
