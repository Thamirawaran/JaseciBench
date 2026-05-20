# Variant count on product dict

In `app/services/catalog.sv.jac`, `product_dict` (variants branch) includes int `variant_count = len(variants)`. In `app/pages/ProductPage.cl.jac`, render `<N> variants total` using `product["variant_count"]`.
