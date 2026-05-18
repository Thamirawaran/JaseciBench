# Server-side search count

Add `def:pub search_count(q: str) -> int` in `app/services/catalog.sv.jac` returning `len(search_products(q))`. In `app/pages/SearchPage.cl.jac`, after a search render `Total: <N> matches`.
