# Color the order status badge by status

The orders page at `/orders` lists each order's status as plain
gray text. The customer can't distinguish a successfully-delivered
order from one that was cancelled. Style the status indicator with
color so the state is visually obvious.

## Expected behaviour

In `app/pages/OrdersPage.cl.jac`, replace (or wrap) the existing
status `<span>` with a small pill/badge whose color depends on the
order's `status` field. At minimum, `delivered` orders must use a
green palette, `cancelled` orders must use a red palette, and
`pending` orders must use a yellow/amber palette. Other statuses
(`processed`, `returned`) may keep neutral styling. The status text
itself must still be visible.
