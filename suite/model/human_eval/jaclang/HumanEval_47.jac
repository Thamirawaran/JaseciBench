"""Return median of elements in the list l.
    >>> median([3, 1, 2, 4, 5])
    3
    >>> median([-10, 4, 6, 1000, 10, 20])
    15.0
    """
def median(l: list) -> float;
test "Check candidate function" {
    candidate = median;
    assert (candidate([3, 1, 2, 4, 5]) == 3);
    assert (candidate([-10, 4, 6, 1000, 10, 20]) == 8.0);
    assert (candidate([5]) == 5);
    assert (candidate([6, 5]) == 5.5);
    assert (candidate([8, 1, 3, 9, 9, 2, 7]) == 7);
}
