"""Sample test for modulo operator task."""

import from server.compute { Compute, ClearHistory }

test "modulo basic positive case" {
    root() spawn ClearHistory();
    out = root() spawn Compute(a=10.0, op="%", b=3.0);
    assert out.result == 1.0;
    assert out.error == "";
}
