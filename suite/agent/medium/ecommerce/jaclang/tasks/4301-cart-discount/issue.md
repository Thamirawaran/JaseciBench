# Cart discount when total >= 100

In `app/services/cart.sv.jac`, `get_cart` returns float `discount = round(0.10 * total, 2)` if `total >= 100` else `0.0`. In `app/pages/CartPage.cl.jac`, render `Discount: $<X>` using `cart["discount"]`.
