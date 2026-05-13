# Orders grouped by status

Add `orders_count_by_status()` to the orders service. Returns
`dict[str, int]` mapping each status value to the number of orders
in that status across the whole system. Statuses with zero orders
do not need to appear in the dict.
