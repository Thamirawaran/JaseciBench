"""Reusable page header — title + subtitle.

Tight letter-spacing on the title, zinc-500 subtitle, optional metric
chip on the right.
"""


def:pub PageHeader(title: str, description: str, metric: str) -> JsxElement {
    return
        <div className="flex items-start justify-between gap-6 mb-6 pb-4 border-b border-zinc-200">
            <div className="flex-1">
                <h1 className="m-0 text-2xl font-bold tracking-tight text-zinc-900">
                    {title}
                </h1>
                <p className="mt-1.5 mb-0 text-sm text-zinc-500 max-w-3xl leading-relaxed">
                    {description}
                </p>
            </div>
            {(<div className="px-3 py-1.5 rounded-md bg-accent-50 text-accent-700 text-xs font-semibold font-mono whitespace-nowrap">
                {metric}
            </div>) if metric else None}
        </div>;
}
