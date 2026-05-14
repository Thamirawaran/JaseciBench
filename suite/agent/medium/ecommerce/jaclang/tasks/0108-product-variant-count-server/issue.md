# Variant count on product dict

In `app/services/catalog.sv.jac`, `product_dict` (when
`include_variants=True`) should also include an int field
`variant_count` equal to the number of variants.

In `app/pages/ProductPage.cl.jac`, render the literal text
`<N> variants total` somewhere on the page using
`product["variant_count"]`.
