# Popular categories on the search page

Search lacks any starter content. Render category buttons from a
new endpoint that selects "popular" categories.

## Expected behaviour

### Server (`app/services/catalog.sv.jac`)

Add `def:pub popular_categories() -> list[dict]` returning the
first 3 categories from the catalog, each as the same shape
returned by `list_categories`.

### Client (`app/pages/SearchPage.cl.jac`)

Below the search input, fetch and render the popular categories
as clickable buttons with the literal label `Popular:` before the
list. Clicking a category should populate the `query` state with
the category's `name`.
