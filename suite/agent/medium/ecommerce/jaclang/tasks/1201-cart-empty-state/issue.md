# Add empty-cart state to /cart page

When a user opens `/cart` and their cart is empty, the page renders a
blank area with no message and no way to navigate back to the catalog.
Add an empty-state block that tells the user the cart is empty and
gives them a button or link to browse products.

## Bug location

`app/pages/CartPage.cl.jac`. The page currently renders only the
"items + total" block, gated on `len(items) > 0`. The complementary
`len(items) == 0` block is missing.

## Expected behaviour

When `len(items) == 0`, the page must show:

- A short message containing the phrase `cart is empty` (for example,
  "Your cart is empty.").
- A `<Link to="/">` (or equivalent navigation) labelled to the effect
  of `Browse products`.

The non-empty state must continue to render the items, total, and
checkout button as today.

## Examples

Empty cart for a user with no items:
- Renders the phrase "Your cart is empty." and a Browse products link.

Cart with one item:
- Renders the items list, total, and checkout button as today; the
  empty-state block is NOT rendered.

## Out of scope

Do not change `get_cart`, `add_to_cart`, or any server endpoint. The
empty state is purely a client-side rendering branch.
