# Show result count after a search

The search page at `/search` runs the user's query and renders a grid
of matching products, but it never tells the user how many matches
came back. Add a small line that shows the count once a search has
been performed.

## Expected behaviour

In `app/pages/SearchPage.cl.jac`, after a search has run (i.e.
`searched` is `True` and the page is no longer in the `searching`
state), render a line above the results grid that contains the number
of results and the word `result` (e.g. `12 results` or
`1 result for "shirt"`). It must not appear before the user has
searched.
