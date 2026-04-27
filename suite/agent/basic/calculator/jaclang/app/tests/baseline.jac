"""Baseline regression tests for Calculator walkers."""

import from server.compute { Compute, ListHistory, ClearHistory }

test "compute add" {
    root() spawn ClearHistory();
    out = root() spawn Compute(a=2.0, op="+", b=3.0);
    assert out.result == 5.0;
    assert out.error == "";
    assert out.saved_id != "";
}

test "compute subtract" {
    root() spawn ClearHistory();
    out = root() spawn Compute(a=10.0, op="-", b=4.0);
    assert out.result == 6.0;
    assert out.error == "";
}

test "compute multiply" {
    root() spawn ClearHistory();
    out = root() spawn Compute(a=6.0, op="*", b=7.0);
    assert out.result == 42.0;
    assert out.error == "";
}

test "compute divide" {
    root() spawn ClearHistory();
    out = root() spawn Compute(a=20.0, op="/", b=4.0);
    assert out.result == 5.0;
    assert out.error == "";
}

# ---------------------------------------------------------------------------
# Compute - error paths
# ---------------------------------------------------------------------------

test "compute reports error on division by zero instead of raising" {
    root() spawn ClearHistory();
    out = root() spawn Compute(a=1.0, op="/", b=0.0);
    assert out.error == "division by zero";
    assert out.saved_id == "";
}

test "compute reports error on unknown operator" {
    root() spawn ClearHistory();
    out = root() spawn Compute(a=1.0, op="?", b=2.0);
    assert "unknown operator" in out.error;
    assert out.saved_id == "";
}

test "errored compute is not persisted to history" {
    root() spawn ClearHistory();
    root() spawn Compute(a=1.0, op="/", b=0.0);
    root() spawn Compute(a=1.0, op="?", b=2.0);
    out = root() spawn ListHistory();
    assert len(out.items) == 0;
}

# ---------------------------------------------------------------------------
# History - listing and clearing
# ---------------------------------------------------------------------------

test "history is empty for a fresh root" {
    root() spawn ClearHistory();
    out = root() spawn ListHistory();
    assert out.items == [];
}

test "history records successful computes in order" {
    root() spawn ClearHistory();
    root() spawn Compute(a=1.0, op="+", b=2.0);
    root() spawn Compute(a=10.0, op="*", b=10.0);
    out = root() spawn ListHistory();
    assert len(out.items) == 2;
    assert out.items[0]["result"] == 3.0;
    assert out.items[1]["result"] == 100.0;
}

test "clear_history empties history and reports the count deleted" {
    root() spawn ClearHistory();
    root() spawn Compute(a=1.0, op="+", b=2.0);
    root() spawn Compute(a=4.0, op="-", b=1.0);
    cleared = root() spawn ClearHistory();
    assert cleared.deleted == 2;
    after = root() spawn ListHistory();
    assert after.items == [];
}
