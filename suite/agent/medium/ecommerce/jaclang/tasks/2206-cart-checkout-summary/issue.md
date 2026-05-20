# Add a checkout-summary line above the checkout button

The cart at `/cart` jumps straight from the items grid into a
naked total + checkout button. Add a small summary line directly
above the checkout button.

## Expected behaviour

In `app/pages/CartPage.cl.jac`, when the cart has at least one
item, render a paragraph above the checkout button containing the
literal phrase `Ready to check out?`. It must not appear in the
empty-cart branch.
