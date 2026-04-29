"""Segmented control — pill-grouped layer tab switcher.

Mirrors the React Segmented<T> control: rounded border container with
pill-shaped buttons. Active button gets white bg + shadow + accent text;
inactive shows zinc-500 with hover. Optional count badge renders inline
after the label.

`options` is a list of [id, label] pairs (no count for v0.1 — empty
leaderboards make counts redundant). `value` is the active id; `on_change`
is a setter the parent provides.
"""


def:pub Segmented(
    options: list[list[str]],
    value: str,
    on_change: any
) -> JsxElement {
    return
        <div className="inline-flex items-center gap-1 p-1 rounded-lg border border-zinc-200 bg-white">
            {[<button
                key={opt[0]}
                onClick={lambda _e: MouseEvent { on_change(opt[0]); }}
                className={(
                    "rounded-md px-3.5 py-1.5 text-sm font-medium transition-colors "
                    + (
                        "bg-accent-50 text-accent shadow-sm"
                        if value == opt[0]
                        else "text-zinc-600 hover:text-zinc-900"
                    )
                )}
            >
                {opt[1]}
            </button> for opt in options]}
        </div>;
}
