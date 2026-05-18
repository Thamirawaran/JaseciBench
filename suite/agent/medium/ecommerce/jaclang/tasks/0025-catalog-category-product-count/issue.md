# Show product count next to each category button

Once the catalog page renders one button per category (added by task
0009 — `select_category` plus an "All" button and one per
`categories` row), customers still have no idea how many products are
in each category until they click through. Add a `product_count` field
to each category in the `list_categories` response and render it on
the buttons as `Category Name (N)`.

## Bug location

Two changes:

1. `app/services/catalog.sv.jac`, the `category_dict` helper. The
   returned dict has `id`, `name`, `description` but no count.
2. `app/pages/CatalogPage.cl.jac`. The category buttons (added by task
   0009) render only `c["name"]` with no count. If you are solving
   0017 in isolation against a baseline that has not yet had 0009
   applied, you will need to render the per-category button row as
   well — the hidden test only depends on `list_categories` returning
   a correct `product_count`, but the source_contains stage on
   `CatalogPage.cl.jac` requires `product_count` to appear in the
   page.

## Expected behaviour

### Server (`category_dict`)

Add a `"product_count"` key whose value is the count of `Product`
nodes attached to root with matching `category_id` and `active=True`.

### Client (`CatalogPage`)

Each category button label becomes `name + " (" + str(product_count) + ")"`.
The "All" button is unchanged.
