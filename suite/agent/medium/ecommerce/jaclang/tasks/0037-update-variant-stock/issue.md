# Endpoint: update a variant's stock level

Add `update_variant_stock(variant_id, new_stock)` to the catalog
service.

- If the variant is missing, return
  `{"error": "...", "status": 404}`.
- If `new_stock` is negative, return
  `{"error": "...", "status": 400}`. Zero is fine (the item is out
  of stock but still tracked).
- Otherwise set `v.stock_qty = new_stock` and return the updated
  variant dict (same shape as the entries in `get_product`'s
  `variants` list).

The change must persist: subsequent reads through `list_products` /
`get_product` should reflect the new stock.
