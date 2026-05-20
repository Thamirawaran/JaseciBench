# Show order subtotal on each order list row

In `app/services/orders.sv.jac`, extend `order_dict` so that the
`include_items=False` branch carries a float field `total` equal to
the sum of `price_snapshot * quantity` across the order's items.

Then in `app/pages/OrdersPage.cl.jac`, render that total as a price
on each row.
