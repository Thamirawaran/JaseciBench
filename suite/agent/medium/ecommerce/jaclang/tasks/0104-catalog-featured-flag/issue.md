# Featured flag on product cards

In `app/services/catalog.sv.jac`, `product_dict` (when
`include_variants=True`) should include a bool field `featured`
that is True for the first 3 active products and False otherwise.

In `app/components/ProductCard.cl.jac`, when `featured` is True,
render the literal label `Featured` somewhere on the card.
