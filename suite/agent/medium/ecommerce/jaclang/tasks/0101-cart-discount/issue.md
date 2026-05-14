# Cart discount when total >= 100

In `app/services/cart.sv.jac`, `get_cart` should also return a
float `discount` field equal to `round(0.10 * total, 2)` when
`total >= 100`, otherwise `0.0`.

In `app/pages/CartPage.cl.jac`, render `Discount: $<X>` near the
totals area using `cart["discount"]`.
