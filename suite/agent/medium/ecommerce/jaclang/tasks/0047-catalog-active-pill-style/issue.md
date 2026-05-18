# Indicate the active category pill on the catalog

The catalog at `/` keeps a `selected_cat` state value but never
visually distinguishes the chosen category. Highlight the active
pill.

## Expected behaviour

In `app/pages/CatalogPage.cl.jac`, when rendering the categories
list (which the agent must add if missing - see related task
0067), use a conditional className so the pill whose id matches
`selected_cat` carries an `indigo` background or border class
(e.g. `bg-indigo-600` or `border-indigo-600`). Inactive pills
keep neutral styling. Use `selected_cat ==` somewhere in the
conditional.
