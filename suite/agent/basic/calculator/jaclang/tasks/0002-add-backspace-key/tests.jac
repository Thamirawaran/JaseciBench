"""Sample test verifies Keypad component type-checks with backspace addition."""

import from client.components.Keypad { Keypad }

test "keypad still imports cleanly after backspace addition" {
    assert Keypad is not None;
}
