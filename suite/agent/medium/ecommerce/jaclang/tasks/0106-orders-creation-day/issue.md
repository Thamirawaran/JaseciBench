# Creation day on orders rows

In `app/services/orders.sv.jac`, `order_dict` (in both branches)
should include a string field `created_day` equal to
`o.created_at[0:10]` (the YYYY-MM-DD prefix).

In `app/pages/OrdersPage.cl.jac`, render `o["created_day"]` on
each row.
