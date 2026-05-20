# Similar products by shared name token

Add `def:pub similar_products(product_id: str) -> list[dict]` in
`app/services/catalog.sv.jac` returning active products (excluding
`product_id`) whose `name` shares any whitespace-separated token
with the target product's name (case-insensitive).

In `app/pages/ProductPage.cl.jac`, render the result under a
heading containing the literal text `Similar products`.
