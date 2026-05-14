# Search products by variant color

Add `def:pub search_by_color(color: str) -> list[dict]` in
`app/services/catalog.sv.jac` returning all active products that
have at least one variant whose `color` equals the input
(case-insensitive). Empty input returns `[]`.

In `app/pages/SearchPage.cl.jac`, render a "Color" set of buttons
(`Black`, `White`, `Blue`) below the search input. Clicking a
button populates results via `search_by_color(<color>)`.
