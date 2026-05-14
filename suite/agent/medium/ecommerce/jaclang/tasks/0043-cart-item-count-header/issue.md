# Show item count next to the cart heading

The cart page at `/cart` renders a heading "Shopping Cart" with no
indication of how many items are in the cart. Reflect the current
item count in the heading area so the user can see it at a glance.

## Expected behaviour

In `app/pages/CartPage.cl.jac`, augment the `Shopping Cart` heading
(or render an inline element next to it) so that, once the cart has
loaded and contains items, the user sees the number of items and the
word `items` (e.g. `Shopping Cart (3 items)`). The count must be
derived from `len(items)` and must not be shown while loading or when
the cart is empty.
