# Show product count on the catalog header

The catalog page at `/` greets the user with "Catalog" and a generic
subtitle, but never tells them how many products are currently
listed. Surface the total in the header.

## Expected behaviour

In `app/pages/CatalogPage.cl.jac`, once the products have loaded
(i.e. `loading` is `False`), the header area should include a small
piece of text containing the number of products and the word
`products` (e.g. `8 products`). The text must derive from
`len(products)` and must not appear while the page is still loading.
