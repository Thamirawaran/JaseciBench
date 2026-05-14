# Cancellable flag on orders

In `app/services/orders.sv.jac`, `order_dict` (in both branches)
should include a bool field `cancellable` that is True iff the
status is `pending` or `processed`.

In `app/pages/OrdersPage.cl.jac`, gate the Cancel button on
`o["cancellable"]` instead of the inline status check.
