# Add an endpoint to update a user's email

## Background

The user profile screen lets a user change their display name via
`update_username`, but there is no equivalent for email. Add a
new `update_email` endpoint with basic validation so the address
book can be kept in sync.

## Bug location

`app/services/users.sv.jac`. The function does not yet exist.

## Expected behaviour

Add `def:pub update_email(user_id: str, email: str) -> dict`:

- Call `ensure_seeded()` first.
- Locate the user via `find_user(user_id)`. If missing, return
  `{"error": "User not found", "status": 404}`.
- The new email must contain an `@`. If not, return
  `{"error": "Invalid email", "status": 400}` and do not
  modify the user.
- On success, set the user's `email` field, then return
  `{"id": u.id, "email": u.email}`.

`update_username` must keep working unchanged.
