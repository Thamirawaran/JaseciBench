# Show net amount paid on each order in the list

The order list at `/orders` shows the order id, date, address and
status, but not the net dollar amount the user has actually paid for
the order (after refunds). Add a `total_paid` field to
`order_dict(include_items=False)` and render it on each row.

## Bug location

Two changes:

1. `app/services/orders.sv.jac`, the `order_dict` helper. The branch
   for `include_items=False` (used by `list_orders`) does not include
   any payment-derived field.
2. `app/pages/OrdersPage.cl.jac`. The order row does not show a paid
   amount.

## Expected behaviour

### Server (`order_dict`, `include_items=False`)

Add `"total_paid"` whose value is the sum of every `Payment` attached
to the order, where `transaction_type == "payment"` is added and
`transaction_type == "refund"` is subtracted. Round to two decimals.

### Client (`OrdersPage`)

Render a small line under the address showing
`"Paid: $" + str(o["total_paid"])`.
