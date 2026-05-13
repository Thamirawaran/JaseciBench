# Endpoint: payment total for an order

Add `order_payment_total(order_id)` to the orders service. It returns
a dict `{"order_id": ..., "paid_total": <float>}` where `paid_total`
is the sum of `amount` across `Payment` nodes attached to that order
where `transaction_type == "payment"` (refunds excluded).

- If the order is missing, return `{"error": "...", "status": 404}`.
- If the order has no payment transactions, `paid_total` is `0.0`.

An order may have both `payment` and `refund` rows (see the seeded
returned and cancelled orders). Only the `payment` rows count toward
`paid_total`.
