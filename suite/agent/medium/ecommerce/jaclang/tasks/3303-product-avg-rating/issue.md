# Show average review rating on the product page

In `app/services/catalog.sv.jac`, extend `product_dict` so that the
`include_variants=True` branch carries a float field `avg_rating`
equal to the average of `rating` across the product's reviews. Use
`0.0` when the product has no reviews.

Then in `app/pages/ProductPage.cl.jac`, render the rating below the
product name as `Rating: <X>` (e.g. `Rating: 4.5`).
