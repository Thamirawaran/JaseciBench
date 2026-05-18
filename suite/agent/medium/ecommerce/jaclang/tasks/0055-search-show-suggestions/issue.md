# Show clickable search suggestions

The search page at `/search` opens with an empty input and no
guidance for the user. Add a server endpoint returning starter
queries and render them as clickable chips.

## Expected behaviour

### Server (`app/services/catalog.sv.jac`)

Add `def:pub search_suggestions() -> list[str]` returning exactly
`["shirt", "coffee", "wireless", "lamp"]`.

### Client (`app/pages/SearchPage.cl.jac`)

Fetch `search_suggestions()` on mount and render each as a
clickable button below the input, prefixed by the literal label
`Try:`. Clicking a chip populates the `query` state.
