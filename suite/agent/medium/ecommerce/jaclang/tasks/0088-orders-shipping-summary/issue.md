# Combined shipping summary string on orders

In `app/services/orders.sv.jac`, `order_dict` (in both branches)
should also include a string `shipping_summary` formatted as
`<city>, <state> <zip>`.

In `app/pages/OrdersPage.cl.jac`, render `o["shipping_summary"]`
on each row (replacing or alongside the existing line).
