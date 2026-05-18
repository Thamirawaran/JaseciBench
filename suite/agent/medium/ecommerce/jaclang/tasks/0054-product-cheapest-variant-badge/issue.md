# Mark the cheapest variant on the product page

The product page at `/products/:id` lists every variant with the
same styling, even though one variant is cheaper than the others.
Surface which variant is cheapest server-side, and mark it with a
visible badge on the page.

## Expected behaviour

### Server (`app/services/catalog.sv.jac`)

`product_dict` (when `include_variants=True`) must include a string
field `cheapest_variant_id` equal to the `id` of the variant with the
minimum `price`. If two variants tie, the first one wins. Empty
string is acceptable when the product has no variants.

### Client (`app/pages/ProductPage.cl.jac`)

When a variant's id matches `product["cheapest_variant_id"]`, render
a small `Best price` badge inline with that variant entry. Other
variant rows must not show the badge.
