# Promo savings on the cart

Customers don't see how much they would save with a promo. Add a
server-computed promo and surface it on the cart page.

## Expected behaviour

### Server (`app/services/cart.sv.jac`)

`get_cart` must return an additional float field `promo_savings`
equal to `round(0.05 * total, 2)` when `total >= 30`, otherwise
`0.0`. The original `total` field stays unchanged.

### Client (`app/pages/CartPage.cl.jac`)

Render the savings as a line containing the literal phrase
`Promo savings:` followed by the dollar amount, using
`cart["promo_savings"]`. The line should only appear when the
savings is non-zero.
