"""JaseciBench leaderboard — full-stack entry point.

Server is the default context — endpoints/imports go at the top with
no section header. `to cl:` opens the client section that follows.

The `with entry` block runs once at server startup and populates the
in-memory submissions cache from leaderboard-data/.
"""

import from services.leaderboard { load_submissions_from_disk, get_submissions }

with entry {
    load_submissions_from_disk();
}

to cl:

import "./styles/global.css";

import from components.AppShell { AppShell }

def:pub app -> JsxElement {
    return <AppShell />;
}
