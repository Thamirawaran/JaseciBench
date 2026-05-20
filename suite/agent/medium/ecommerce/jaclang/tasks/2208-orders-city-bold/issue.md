# Bold the city in the orders address line

The orders list at `/orders` shows shipping address as one
muted-gray line. Make the destination city stand out.

## Expected behaviour

In `app/pages/OrdersPage.cl.jac`, on each order row, wrap the
`o["shipping_city"]` rendering in a `<span>` (or equivalent)
that uses a Tailwind `font-semibold` (or stronger) class. The
`shipping_state` and `shipping_zip` styling stays unchanged.
