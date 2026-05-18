# Search products by color

Add `def:pub search_by_color(color: str) -> list[dict]` in
`app/services/catalog.sv.jac` returning active products with at
least one variant whose `color == color`. In
`app/pages/SearchPage.cl.jac`, surface the endpoint via a `By color:`
control.
