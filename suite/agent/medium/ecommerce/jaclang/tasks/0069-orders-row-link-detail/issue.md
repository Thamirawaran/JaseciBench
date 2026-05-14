# Linkify the order id on the orders list

In `app/pages/OrdersPage.cl.jac`, wrap each order's `id` text in a
`Link` (from `@jac/runtime`) that navigates to `/orders/<id>`.
