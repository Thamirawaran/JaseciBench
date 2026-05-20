# Total unit count on the cart

Add an integer field `unit_count` to the dict returned by `get_cart`
in `app/services/cart.sv.jac`, equal to the sum of `quantity` across
every item.

In `app/pages/CartPage.cl.jac`, render that count next to the
`Total` line as the literal text `<N> units`.
