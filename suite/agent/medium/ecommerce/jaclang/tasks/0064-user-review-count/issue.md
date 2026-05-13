# Endpoint: number of reviews authored by a user

Add `user_review_count(user_id)` to the reviews service. Returns an
`int`: the number of `Review` nodes whose `user_id` matches.

Returns 0 for unknown users.
