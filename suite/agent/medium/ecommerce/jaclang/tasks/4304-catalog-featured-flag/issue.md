# Featured flag on product cards

In `app/services/catalog.sv.jac`, `product_dict` (variants branch) includes bool `featured` (True for first 3 active products). In `app/components/ProductCard.cl.jac`, render `Featured` when `featured` is True.
