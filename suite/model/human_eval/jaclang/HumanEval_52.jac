"""Return True if all numbers in the list l are below threshold t.
    >>> below_threshold([1, 2, 4, 10], 100)
    True
    >>> below_threshold([1, 20, 4, 10], 5)
    False
    """
def below_threshold(l: list, t: int) -> bool;
test "Check candidate function" {
    candidate = below_threshold;
    assert candidate([1, 2, 4, 10], 100);
    assert not candidate([1, 20, 4, 10], 5);
    assert candidate([1, 20, 4, 10], 21);
    assert candidate([1, 20, 4, 10], 22);
    assert candidate([1, 8, 4, 10], 11);
    assert not candidate([1, 8, 4, 10], 10);
}
