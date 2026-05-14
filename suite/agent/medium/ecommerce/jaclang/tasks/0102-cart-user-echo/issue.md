# Cart echoes user_id

In `app/services/cart.sv.jac`, `get_cart` should also include the
field `user_id` echoing the input. In `app/pages/CartPage.cl.jac`,
render `Cart for: <id>` somewhere visible using `cart["user_id"]`.
