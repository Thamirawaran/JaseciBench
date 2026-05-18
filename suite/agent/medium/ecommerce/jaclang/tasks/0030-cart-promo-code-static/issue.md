# Static promo code support on the cart

## Background

We want a minimal promo-code feature: marketing has agreed on a
single fixed code `SAVE10` that gives 10% off the cart total.
Both the server endpoint and the input field need to land in the
same change.

## Bug location

Two files:

1. `app/services/cart.sv.jac`: add a new validator endpoint.
2. `app/pages/CartPage.cl.jac`: render an input + button to
   apply a code, and surface the discount.

## Expected behaviour

### Server (`app/services/cart.sv.jac`)

Add `def:pub apply_promo(user_id: str, code: str) -> dict`:

- Call `ensure_seeded()` first.
- Compute the user's cart total via the same loop as `get_cart`.
- If `code` is exactly `SAVE10`, return
  `{"valid": True, "code": "SAVE10", "discount": round(0.10 * total, 2)}`.
- Otherwise return `{"valid": False, "code": code, "discount": 0.0}`.

`get_cart` and other endpoints stay unchanged.

### Client (`app/pages/CartPage.cl.jac`)

- Add a `has promo_code: str = "";` state (or equivalent) plus a
  `has promo_discount: float = 0.0;` state.
- Render an `<input>` bound to `promo_code` and an
  `Apply` button. Clicking the button must call
  `apply_promo("user_001", promo_code)` and store the returned
  `discount` in `promo_discount`.
- Render `Promo discount: $<X>` somewhere visible whenever
  `promo_discount > 0`.
