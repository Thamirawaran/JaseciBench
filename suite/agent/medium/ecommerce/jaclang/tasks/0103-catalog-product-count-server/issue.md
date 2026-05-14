# Server-side product count

Add `def:pub product_count() -> int` in `app/services/catalog.sv.jac`
returning the number of active products. In `app/pages/CatalogPage.cl.jac`,
fetch and render the count somewhere in the header containing the
literal text `total products`.
