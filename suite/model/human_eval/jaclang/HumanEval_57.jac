"""Return True is list elements are monotonically increasing or decreasing.
    >>> monotonic([1, 2, 4, 20])
    True
    >>> monotonic([1, 20, 4, 10])
    False
    >>> monotonic([4, 1, 0, -10])
    True
    """
def monotonic(l: list) -> bool;
test "Check candidate function" {
    candidate = monotonic;
    assert (candidate([1, 2, 4, 10]) == True);
    assert (candidate([1, 2, 4, 20]) == True);
    assert (candidate([1, 20, 4, 10]) == False);
    assert (candidate([4, 1, 0, -10]) == True);
    assert (candidate([4, 1, 1, 0]) == True);
    assert (candidate([1, 2, 3, 2, 5, 60]) == False);
    assert (candidate([1, 2, 3, 4, 5, 60]) == True);
    assert (candidate([9, 9, 9, 9]) == True);
}
