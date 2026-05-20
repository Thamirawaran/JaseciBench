# Creation day on orders rows

In `app/services/orders.sv.jac`, `order_dict` (both branches) includes string `created_day = o.created_at[0:10]`. In `app/pages/OrdersPage.cl.jac`, render `o["created_day"]` on each row.
