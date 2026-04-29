"""LayerView — one of {model, agent, app} layer's table content.

Single parameterized component used by LeaderboardPage. Re-fetches when
the `layer` prop changes (via `can with [layer] entry`) so flipping
between Segmented tabs reuses the same instance.

`columns` is a list of [key, label] pairs; `blurb` is the per-layer
prose rendered above the table.
"""

sv import from services.leaderboard { get_submissions }
import from ..LeaderboardTable { LeaderboardTable }


def:pub LayerView(
    layer: str,
    columns: list[list[str]],
    blurb: str
) -> JsxElement {
    has rows: list[dict] = [],
        loading: bool = True,
        error: str = "";

    async def fetch_rows -> None {
        loading = True;
        error = "";
        try {
            data = await get_submissions(layer);
            rows = data;
        } except Exception as e {
            error = str(e);
            rows = [];
        }
        loading = False;
    }

    can with entry {
        fetch_rows();
    }

    can with [layer] entry {
        fetch_rows();
    }

    return
        <div>
            <p className="text-sm text-zinc-500 mb-4">{blurb}</p>
            {(<div className="text-center text-sm text-zinc-400 py-16">Loading…</div>)
                if loading
                else (
                    (<div className="rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-700">
                        {"Failed to load submissions: " + error}
                    </div>) if error
                    else <LeaderboardTable rows={rows} columns={columns} />
                )}
        </div>;
}
