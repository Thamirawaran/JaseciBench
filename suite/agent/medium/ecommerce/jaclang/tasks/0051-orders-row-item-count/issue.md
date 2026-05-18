# Surface item count on each row of the orders list

The orders page at `/orders` shows the order id, date, address, and
status, but not how many items were in each order. The list endpoint
also doesn't expose that count, so the client can't render it
without an extra round-trip per order. Add the count on both sides.

## Expected behaviour

### Server (`app/services/orders.sv.jac`)

In `order_dict`, the `include_items=False` branch (used by
`list_orders`) must include an integer field `item_count` equal to
the number of `OrderItem` nodes attached to the order.

### Client (`app/pages/OrdersPage.cl.jac`)

On each order row, render a small line that contains the count and
the word `items` (e.g. `3 items`), pulled from `o["item_count"]`.
