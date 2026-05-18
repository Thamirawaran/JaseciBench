# Add a "Browse products" CTA to the empty orders page

When a user has no orders yet, `/orders` shows the muted text
`No orders yet.` but offers no path forward. Add a call-to-action
button or link that takes the user to the catalog so they can
actually place a first order.

## Bug location

`app/pages/OrdersPage.cl.jac`. The empty-state block currently
contains only a single `<p>`. There is no link element.

## Expected behaviour

When `len(orders) == 0`, render an empty-state block that contains:

- The existing copy (or equivalent), e.g. `No orders yet.`
- A `<Link to="/">` (imported from `@jac/runtime`) labelled to the
  effect of `Browse products`.

The non-empty branch (the order list and cancel buttons) must
continue to render as today.

## Examples

A user with zero orders (`list_orders("new_user") == []`):
- Renders "No orders yet." and a "Browse products" Link to "/".

A user with one or more orders:
- Renders the order list. Empty-state block is NOT rendered.

## Out of scope

Do not change `list_orders` or any server endpoint. The empty state
is a client-side rendering branch on `len(orders) == 0`.
