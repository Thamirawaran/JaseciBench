# Low-stock warning on the product page

The product detail page at `/products/:id` renders `stock_qty`
per variant, but does not call out low-stock variants.

## Expected behaviour

In `app/pages/ProductPage.cl.jac`, when the currently selected
variant has `0 < stock_qty < 5`, render a warning element
containing the literal text `Only a few left` near the variant
list. Use an `orange` or `amber` color class for the warning
styling. The warning must NOT show when stock_qty is 0 (that
case is already handled by 0070's disable behaviour) or >= 5.
