# Endpoint: payment-method count for a user

Add `user_payment_method_count(user_id)` to the users service.
Returns an `int`: the number of `PaymentMethod` nodes attached to
the user.

Returns `0` for users who do not exist (no error dict, just 0).
