# User orders summary endpoint

Customers want to see how many orders are in each lifecycle
state. Add a single summary endpoint and render it on the orders
page.

## Expected behaviour

### Server (`app/services/orders.sv.jac`)

Add `def:pub orders_summary(user_id: str) -> dict` that returns
`{"pending": int, "delivered": int, "total": int}` for the given
user, where `pending` counts orders with status `pending` or
`processed`, `delivered` counts status `delivered`, and `total`
is the count of all orders.

### Client (`app/pages/OrdersPage.cl.jac`)

Above the order list, render a summary header containing the
literal text `Pending:` and `Delivered:` followed by the counts
fetched from `orders_summary`.
