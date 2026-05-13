# Show per-line subtotal on the cart page

The cart row layout shows the variant color/size, the unit price, the
quantity controls and the remove button, but not the per-line
subtotal (price * quantity). Customers have to do the math in their
head when reviewing a cart with mixed quantities. Add a subtotal
column.

## Bug location

`app/pages/CartPage.cl.jac`. Inside the cart-row map, the right-aligned
`<div>` that renders `"$" + str(item["subtotal"])` is missing.

## Expected behaviour

Inside the row, between the quantity controls and the Remove button,
render a small bold right-aligned `<div>` showing
`"$" + str(item["subtotal"])`. The server already exposes
`subtotal = price * quantity` on each cart item.
