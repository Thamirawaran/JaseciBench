# Server-side search count

Add `def:pub search_count(q: str) -> int` in
`app/services/catalog.sv.jac` returning the number of products
matching `q` (use `search_products(q)` internally).

In `app/pages/SearchPage.cl.jac`, after a search, render
`Total: <N> matches` using `search_count`.
