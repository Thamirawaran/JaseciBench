# Category name on product page

In `app/services/catalog.sv.jac`, `product_dict` (variants branch) includes string `category_name` (lookup matching `Category.name` by `category_id`, empty string if missing). In `app/pages/ProductPage.cl.jac`, render `product["category_name"]`.
