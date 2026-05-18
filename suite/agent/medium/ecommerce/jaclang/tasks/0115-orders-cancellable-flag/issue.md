# Cancellable flag on orders

In `app/services/orders.sv.jac`, `order_dict` (both branches) includes bool `cancellable` (True iff status is `pending` or `processed`). In `app/pages/OrdersPage.cl.jac`, gate the Cancel button on `o["cancellable"]`.
