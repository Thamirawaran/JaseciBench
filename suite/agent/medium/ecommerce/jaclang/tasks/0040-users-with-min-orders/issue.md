# Users with at least N orders

Add `def:pub users_with_min_orders(min_orders: int) -> list[dict]`
in `app/services/users.sv.jac` returning every user whose count of
orders (filtered by `Order.user_id == user.id`) is greater than or
equal to `min_orders`. Each entry should be the same shape as
entries returned by `list_users()`. Result order matches the order
of users on the graph.
