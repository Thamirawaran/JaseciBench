"""Top-level shell — sticky header + Router + footer.

Mirrors JaseciBenchmark/website/frontend/src/components/Layout.tsx.
"""

import from "@jac/runtime" { Router, Routes, Route, Navigate, Link, useLocation }
import from .pages.HomePage { HomePage }
import from .pages.LeaderboardPage { LeaderboardPage }
import from .pages.MethodologyPage { MethodologyPage }
import from .pages.SubmitPage { SubmitPage }


def:pub NavItem(to_path: str, label: str, current_path: str, exact: bool) -> JsxElement {
    is_active = (current_path == to_path) if exact else (current_path == to_path or (to_path != "/" and current_path.startswith(to_path)));
    classes = "rounded-md px-3 py-2 text-sm font-medium transition-colors " + (
        "text-accent bg-accent-50" if is_active
        else "text-zinc-600 hover:text-zinc-900 hover:bg-zinc-100"
    );
    return <Link to={to_path} className={classes}>{label}</Link>;
}


def:pub Brand -> JsxElement {
    return
        <Link
            to="/"
            className="flex items-center gap-3 font-semibold text-zinc-900"
        >
            <span className="inline-flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-accent to-accent-700 text-white text-base font-bold tracking-tight shadow-sm">
                JB
            </span>
            <span className="text-xl tracking-tight">JaseciBench</span>
        </Link>;
}


def:pub Header -> JsxElement {
    location = useLocation();
    pathname = location.pathname;

    return
        <header className="sticky top-0 z-30 backdrop-blur-md bg-white/85 border-b border-zinc-200/70">
            <div className="mx-auto max-w-7xl px-6 h-16 flex items-center justify-between">
                <Brand />
                <nav className="flex items-center gap-1">
                    <NavItem to_path="/" label="Home" current_path={pathname} exact={True} />
                    <NavItem to_path="/leaderboard" label="Leaderboard" current_path={pathname} exact={False} />
                    <NavItem to_path="/methodology" label="Methodology" current_path={pathname} exact={False} />
                    <NavItem to_path="/submit" label="Submit" current_path={pathname} exact={False} />
                    <a
                        href="https://github.com/Thamirawaran/JaseciBench"
                        target="_blank"
                        rel="noreferrer"
                        className="ml-2 inline-flex items-center text-zinc-500 hover:text-zinc-900 px-2 py-2 text-sm rounded-md hover:bg-zinc-100"
                        aria-label="GitHub"
                    >
                        GitHub
                    </a>
                </nav>
            </div>
        </header>;
}


def:pub Footer -> JsxElement {
    return
        <footer className="border-t border-zinc-200 bg-white mt-16">
            <div className="mx-auto max-w-7xl px-6 py-10 grid sm:grid-cols-3 gap-8 text-sm">
                <div>
                    <div className="flex items-center gap-2 mb-2">
                        <span className="inline-flex h-6 w-6 items-center justify-center rounded bg-gradient-to-br from-accent to-accent-700 text-white text-[10px] font-bold">
                            JB
                        </span>
                        <span className="font-semibold text-zinc-900">JaseciBench</span>
                    </div>
                    <p className="text-zinc-500 leading-relaxed m-0">
                        Public leaderboard for evaluating LLMs and coding agents on Jac and Jaseci.
                    </p>
                </div>
                <div>
                    <div className="text-[11px] uppercase tracking-wider text-zinc-500 font-semibold mb-2">
                        Resources
                    </div>
                    <ul className="space-y-1.5 text-zinc-600 list-none p-0 m-0">
                        <li><Link to="/leaderboard" className="hover:text-zinc-900">Leaderboard</Link></li>
                        <li><Link to="/methodology" className="hover:text-zinc-900">Methodology</Link></li>
                        <li><Link to="/submit" className="hover:text-zinc-900">Submit a run</Link></li>
                    </ul>
                </div>
                <div>
                    <div className="text-[11px] uppercase tracking-wider text-zinc-500 font-semibold mb-2">
                        Source
                    </div>
                    <ul className="space-y-1.5 text-zinc-600 list-none p-0 m-0">
                        <li>
                            <a href="https://github.com/Thamirawaran/JaseciBench" className="hover:text-zinc-900">
                                JaseciBench
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/Thamirawaran/JaseciBench/tree/main/leaderboard-data" className="hover:text-zinc-900">
                                leaderboard-data/
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div className="border-t border-zinc-100">
                <div className="mx-auto max-w-7xl px-6 py-4 text-[11px] text-zinc-400 flex justify-between">
                    <span>© 2026 Jaseci Labs</span>
                    <span>Built fully in Jac · Jaseci</span>
                </div>
            </div>
        </footer>;
}


def:pub AppShell -> JsxElement {
    return
        <Router>
            <div className="min-h-screen flex flex-col bg-zinc-50">
                <Header />
                <main className="flex-1">
                    <Routes>
                        <Route path="/" element={<HomePage />} />
                        <Route path="/leaderboard" element={<LeaderboardPage />} />
                        <Route path="/methodology" element={<MethodologyPage />} />
                        <Route path="/submit" element={<SubmitPage />} />
                    </Routes>
                </main>
                <Footer />
            </div>
        </Router>;
}
