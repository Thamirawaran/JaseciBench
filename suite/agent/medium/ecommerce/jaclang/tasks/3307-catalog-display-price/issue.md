# Pre-formatted display price on product_dict

In `app/services/catalog.sv.jac`, `product_dict` (when
`include_variants=True`) should also include a string
`display_price` formatted as `$X.XX` from the minimum variant
price (e.g. `"$19.99"`). Empty string when no variants.

In `app/components/ProductCard.cl.jac`, render `display_price`
on the card.
