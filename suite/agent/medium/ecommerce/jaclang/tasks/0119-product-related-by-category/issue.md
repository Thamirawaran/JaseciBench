# Related products on the product page

Product pages currently dead-end with a single product. Add a
related-products endpoint and render the section.

## Expected behaviour

### Server (`app/services/catalog.sv.jac`)

Add `def:pub related_products(product_id: str) -> list[dict]`
returning all other active products that share the same
`category_id` as `product_id`. Exclude `product_id` itself. Use
the same `product_dict` shape as `list_products`.

### Client (`app/pages/ProductPage.cl.jac`)

Below the variants list, render a section whose heading contains
the literal text `Related products`, populated from
`related_products(pid)`. If empty, do not render the section.
