# Show product count next to each category button

The catalog page lists every category as a clickable button. Customers
have no idea how many products are in each category until they click
through. Add a `product_count` field to each category in the
`list_categories` response and render it on the buttons as
`Category Name (N)`.

## Bug location

Two changes:

1. `app/services/catalog.sv.jac`, the `category_dict` helper. The
   returned dict has `id`, `name`, `description` but no count.
2. `app/pages/CatalogPage.cl.jac`. The category buttons render only
   `c["name"]` with no count.

## Expected behaviour

### Server (`category_dict`)

Add a `"product_count"` key whose value is the count of `Product`
nodes attached to root with matching `category_id` and `active=True`.

### Client (`CatalogPage`)

Each category button label becomes `name + " (" + str(product_count) + ")"`.
The "All" button is unchanged.
