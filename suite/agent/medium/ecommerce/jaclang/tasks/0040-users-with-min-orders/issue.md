# Users with at least N orders

Add `def:pub users_with_min_orders(min_orders: int) -> list[dict]`
in `app/services/orders.sv.jac` returning every user whose count
of `Order` nodes (filtered by `user_id == user.id`) is greater than
or equal to `min_orders`. Each entry should be the same shape as
entries returned by `list_users()` in `services/users.sv.jac`.
Result order matches the order of users on the graph.
