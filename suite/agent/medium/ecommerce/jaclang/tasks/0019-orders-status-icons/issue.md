# Add status icons to the orders list

## Background

The orders page at `/orders` shows the status of every order as
plain text. We want a recognisable icon next to each status so
that customers can scan their list at a glance.

## Bug location

`app/pages/OrdersPage.cl.jac`. The status `<span>` currently
renders only `o["status"]` text and a `Cancel` button.

## Expected behaviour

For each order row, render an emoji icon directly to the left of
the status text using this mapping:

- `delivered`  → `✅`
- `shipped`    → `🚚`
- `processed`  → `⚙️`
- `pending`    → `⏳`
- `cancelled`  → `✖️`
- `returned`   → `↩️`

Implement the mapping inline (e.g. via a chained ternary or a
dict lookup keyed on `o["status"]`). The status text itself must
remain visible. Unknown statuses (defensive case) may render no
icon. The `Cancel` button must remain unchanged.
