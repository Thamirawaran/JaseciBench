# Show total stock summary on the product page

The product detail page at `/products/:id` lists each variant's
individual stock count, but never tells the shopper how much total
inventory is available for the product as a whole. Surface a
combined total near the product description.

## Expected behaviour

In `app/pages/ProductPage.cl.jac`, after the product name +
description block (and before the variants list), render a small
line containing the sum of `stock_qty` across every variant, with
the words `total` and `in stock` (e.g. `42 total in stock`). The
line must compute the total from `product["variants"]` and must
render only when a product has loaded.
