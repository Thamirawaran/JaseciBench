# Add an endpoint to mark an order as shipped

## Background

The orders service exposes `update_order_status` for arbitrary
status transitions, but the production warehouse system needs a
narrower, stricter endpoint for the "shipped" transition. We
want a dedicated `mark_shipped` function with an explicit state
guard so that callers cannot accidentally ship an order that
hasn't been processed yet.

## Bug location

`app/services/orders.sv.jac`. There is no `mark_shipped`
function today.

## Expected behaviour

Add `def:pub mark_shipped(order_id: str) -> dict` with these
rules, modelled on the existing `cancel_order` function for
naming and error-shape consistency:

- Call `ensure_seeded()` first.
- If no order with that id exists, return
  `{"error": "Order not found", "status": 404}`.
- If the current `status` is anything other than `processed`,
  return `{"error": "Only processed orders can be shipped (current status: <S>)", "status": 400}`.
- On success, set `status` to `shipped` and return the full
  `order_dict(o)`.

The existing `update_order_status` function must remain unchanged
and callable.
