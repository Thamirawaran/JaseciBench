# Out-of-stock badge on the product card

In `app/services/catalog.sv.jac`, extend `product_dict` (with
`include_variants=True`) to include an integer field
`total_stock_qty` summed across the product's variants.

In `app/components/ProductCard.cl.jac`, when `total_stock_qty == 0`
render a small red `Out of stock` badge on the card.
