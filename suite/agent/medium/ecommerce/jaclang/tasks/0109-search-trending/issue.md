# Trending search terms

Add `def:pub trending_searches() -> list[str]` in
`app/services/catalog.sv.jac` returning the literal list
`["bag", "headphones", "watch"]`.

In `app/pages/SearchPage.cl.jac`, render those terms with the
literal label `Trending:` somewhere visible.
