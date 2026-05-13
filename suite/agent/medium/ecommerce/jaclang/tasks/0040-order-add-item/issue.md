# Endpoint: add an item to an existing pending order

Add `order_add_item(order_id, variant_id, quantity)` to the orders
service. Appends a new `OrderItem` to the order with the variant's
current price snapshotted, then returns the updated order dict via
the existing `order_dict` helper.

- If the order is missing, return `{"error": "...", "status": 404}`.
- If the order is not in `pending` status, return
  `{"error": "...", "status": 400}` (cannot modify orders that have
  already been processed, shipped, etc.).
- If the variant is missing, return `{"error": "...", "status": 404}`.
- If `quantity < 1`, return `{"error": "...", "status": 400}`.

The new `OrderItem` must have a unique id (e.g. `oi_<n>`),
`price_snapshot` set to the variant's current `price` (do NOT
multiply by quantity), and `returned = False`.
