# Render category names on the catalog page

`app/pages/CatalogPage.cl.jac` fetches `categories` but never shows
them. After the header and before the products grid, render each
category's `name` as a small inline pill/badge.
