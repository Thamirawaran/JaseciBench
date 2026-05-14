# Disable Add to Cart when selected variant is out of stock

In `app/pages/ProductPage.cl.jac`, the Add to Cart button is only
disabled when no variant is selected. Also disable it when the
currently selected variant has `stock_qty == 0`.
