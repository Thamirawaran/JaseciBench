# Show clickable search suggestions on the search page

The search page at `/search` opens with an empty input and no
guidance for the user. Add a server-provided list of suggested
queries and surface them as clickable chips below the search bar so
the user has somewhere to start.

## Expected behaviour

### Server (`app/services/catalog.sv.jac`)

Add a new public function:

```
def:pub search_suggestions() -> list[str]
```

It returns a non-empty static list of suggested search terms (use
`["shirt", "coffee", "wireless", "lamp"]` exactly).

### Client (`app/pages/SearchPage.cl.jac`)

On mount, fetch `search_suggestions()` and render each entry as a
clickable button below the search input. Clicking a chip must
populate the `query` state with that string. Use the word
`Try:` as a label before the chips.
