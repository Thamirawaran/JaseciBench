# Lowest price across search results

Add a new `def:pub search_min_price(q: str) -> float` to
`app/services/catalog.sv.jac` that returns the minimum variant price
across all products matched by `q`. Return `0.0` if there are no
matches.

Then in `app/pages/SearchPage.cl.jac`, after a successful search,
render a line such as `Lowest: $<X>` using that endpoint.
