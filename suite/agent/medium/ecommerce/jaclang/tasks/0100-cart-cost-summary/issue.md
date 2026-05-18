# Cart cost summary

Add `cart_cost_summary(user_id) -> {"subtotal", "tax", "grand_total"}` to `app/services/cart.sv.jac`. Tax is 8% of subtotal; grand_total is subtotal + tax. All floats rounded to 2 decimals.
