# Category name on product page

In `app/services/catalog.sv.jac`, `product_dict` (when
`include_variants=True`) should include a string field
`category_name` resolved from `category_id` (lookup the matching
Category and use its `name`; empty string if not found).

In `app/pages/ProductPage.cl.jac`, render `product["category_name"]`
near the product header.
