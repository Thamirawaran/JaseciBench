# Flat $5 discount on the cart

In `app/services/cart.sv.jac`, `get_cart` should also return a
float `flat_discount` field equal to `5.0` when `total > 20`,
else `0.0`.

In `app/pages/CartPage.cl.jac`, render `Discount: $5.00` (or use
`cart["flat_discount"]`) when the discount is non-zero.
