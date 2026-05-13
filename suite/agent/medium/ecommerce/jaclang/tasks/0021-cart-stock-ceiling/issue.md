# Enforce a stock ceiling across cumulative add-to-cart calls

`add_to_cart(user_id, variant_id, quantity)` rejects requests where
`quantity > stock_qty`, but it does **not** account for what the user
already has in the cart. A user with 5 of `var_001` (stock 10) who
adds 8 more lands at 13 in cart, oversold against the variant.

## Bug location

`app/services/cart.sv.jac`, the `add_to_cart` function. The stock
check compares only against the incoming `quantity`, not against the
existing cart-line plus the incoming `quantity`.

## Expected behaviour

- Look up any existing `CartItem` for `(user_id, variant_id)` and read
  its current `quantity` (default to 0 if none).
- Reject with `{"error": "Insufficient stock", "status": 400}` when
  `existing_qty + quantity > variant.stock_qty`.
- Otherwise: if a line exists, increment its quantity; if not, create
  a new line.
- The 404 (variant not found) and quantity<1 guards must keep working.
