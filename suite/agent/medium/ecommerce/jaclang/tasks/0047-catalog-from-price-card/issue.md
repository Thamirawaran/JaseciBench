# Show "From $X" price on each product card

The catalog and search pages render a `ProductCard` per product, but
the card shows variant count without any price information. Surface
the cheapest variant price both server-side and on the card.

## Expected behaviour

### Server (`app/services/catalog.sv.jac`)

`product_dict` (when `include_variants=True`) must include a float
field `min_price` equal to the minimum `price` across the product's
variants. Products with no variants should report `0.0`.

### Client (`app/components/ProductCard.cl.jac`)

Render the price using `product["min_price"]` in a `From $X` format
(e.g. `From $19.99`) somewhere on the card. The existing variant
count line may stay or be replaced.
