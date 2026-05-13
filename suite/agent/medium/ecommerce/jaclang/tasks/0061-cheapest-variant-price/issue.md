# Cheapest variant price for a product

Add `cheapest_variant_price(product_id)` to the catalog service.
Returns `{"product_id": str, "min_price": float}` of the lowest-priced
variant. If the product is missing returns
`{"error": "...", "status": 404}`.
