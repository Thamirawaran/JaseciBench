# Add a search icon to the submit button

The search page at `/search` ships with a plain text "Search"
submit button. Add a magnifying-glass cue.

## Expected behaviour

In `app/pages/SearchPage.cl.jac`, prefix or replace the button
label with the literal magnifying-glass emoji `🔍`. The button
must remain a `submit` type and keep its existing `bg-indigo-`
styling. Both the emoji and the word `Search` should be visible
to the user (e.g. `🔍 Search`).
