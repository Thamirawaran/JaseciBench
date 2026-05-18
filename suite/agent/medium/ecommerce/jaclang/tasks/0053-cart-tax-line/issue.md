# Add tax + grand total to the cart

The cart at `/cart` displays a single `Total` line and immediately
sends the user to checkout, but never shows tax or what they will
actually be charged. Compute tax server-side and surface it on the
page along with a final grand total.

## Expected behaviour

### Server (`app/services/cart.sv.jac`)

`get_cart` must return two additional float fields alongside the
existing `total`:

- `tax`: 8% of `total`, rounded to two decimals.
- `grand_total`: `total + tax`, rounded to two decimals.

### Client (`app/pages/CartPage.cl.jac`)

In the totals block (the panel that currently shows just `Total`),
also render a `Tax` line using `cart["tax"]` and a `Grand Total`
line using `cart["grand_total"]`. The original `Total` line stays.
