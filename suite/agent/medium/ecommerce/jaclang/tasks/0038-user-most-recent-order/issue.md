# Endpoint: a user's most recent order

Add `user_most_recent_order(user_id)` to the orders service. Returns
the single most recent `Order` (by `created_at`) for the given user
as a dict, with the same shape as items in `list_orders(user_id)`.

- If the user has no orders, return
  `{"error": "...", "status": 404}`.

The user does not have to exist in the users service: only the
existence of an `Order` with `user_id == <user_id>` matters. Sort by
`created_at` descending; ties are unlikely but you may break them
arbitrarily.
