# Endpoint: edit a review

Add `edit_review(review_id, rating, title, body)` to the reviews
service. Updates the matching `Review` node in place and returns the
updated dict (same shape as items in `list_reviews`'s `reviews` list).

- If the review is missing, return
  `{"error": "...", "status": 404}`.
- If `rating` is not in the inclusive range 1..5, return
  `{"error": "...", "status": 400}`.
- `title` and `body` may be empty strings.
- `created_at` is preserved; only `rating`, `title`, `body` change.

Reviews live attached to `Product` nodes; you will need to walk the
graph to find a review by id.
