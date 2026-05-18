# In-stock flag on product cards

Products in the catalog mix in-stock and out-of-stock items with
no visual cue. Compute a stock flag server-side and use it on the
card.

## Expected behaviour

### Server (`app/services/catalog.sv.jac`)

In `product_dict` (when `include_variants=True`), add a bool
field `in_stock` that is `True` if at least one variant has
`stock_qty > 0`, else `False`.

### Client (`app/components/ProductCard.cl.jac`)

When `in_stock` is True render the literal label `In stock` on
the card. When False render `Sold out`. Both labels must be
visible (no hidden CSS).
