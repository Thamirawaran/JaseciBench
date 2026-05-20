# Show "Currently unavailable" banner when all variants are out of stock

The product detail page at `/products/:id` lets the user select a variant
and click "Add to Cart" even when every variant has `stock_qty == 0`.
The button does become disabled, but there is no visual cue at the top of
the page telling the customer the product is unavailable. Add a banner
that surfaces the out-of-stock state.

## Bug location

`app/pages/ProductPage.cl.jac`. After the product name and description
block, an out-of-stock banner is missing.

## Expected behaviour

When the **sum** of `stock_qty` across all variants is zero, render a
visible banner element somewhere between the product description and
the variant list. The banner must:

- Contain the literal phrase `Currently unavailable`.
- Use a destructive/warning color palette (a `bg-red-` background or
  `text-red-` foreground class is fine).
- Not render at all when at least one variant has stock.

## Examples

`prod_001` with variants `[stock_qty=5, stock_qty=3, stock_qty=0]`:
- Banner does NOT render (sum is 8 > 0).

A product with variants all at `stock_qty=0`:
- Banner renders with the phrase and the red palette.

## Out of scope

Do not change the variant list, the Add to Cart disable logic, or
`get_product` on the server. The banner only reads from the existing
`product["variants"][i]["stock_qty"]` values.
