"""Sample test for SumHistory walker task."""

import from server.compute { SumHistory, ClearHistory }

test "sum_history returns zero for empty history" {
    root() spawn ClearHistory();
    out = root() spawn SumHistory();
    assert out.total == 0.0;
}
