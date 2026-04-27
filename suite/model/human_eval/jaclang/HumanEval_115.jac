def max_fill(grid: Any, capacity: Any) -> int;

test "Check candidate function" {
    candidate = max_fill;
    assert True , "This prints if this assert fails 1 (good for debugging!)";
    assert (candidate([[0, 0, 1, 0], [0, 1, 0, 0], [1, 1, 1, 1]], 1) == 6) , "Error";
    assert (
        candidate([[0, 0, 1, 1], [0, 0, 0, 0], [1, 1, 1, 1], [0, 1, 1, 1]], 2) == 5
    ) , "Error";
    assert (candidate([[0, 0, 0], [0, 0, 0]], 5) == 0) , "Error";
    assert True , "This prints if this assert fails 2 (also good for debugging!)";
    assert (candidate([[1, 1, 1, 1], [1, 1, 1, 1]], 2) == 4) , "Error";
    assert (candidate([[1, 1, 1, 1], [1, 1, 1, 1]], 9) == 2) , "Error";
}
