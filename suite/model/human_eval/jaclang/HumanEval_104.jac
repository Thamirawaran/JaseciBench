"""Given a list of positive integers x. return a sorted list of all
    elements that hasn't any even digit.

    Note: Returned list should be sorted in increasing order.

    For example:
    >>> unique_digits([15, 33, 1422, 1])
    [1, 15, 33]
    >>> unique_digits([152, 323, 1422, 10])
    []
    """
def unique_digits(x: Any) -> list;
test "Check candidate function" {
    candidate = unique_digits;
    assert (candidate([15, 33, 1422, 1]) == [1, 15, 33]);
    assert (candidate([152, 323, 1422, 10]) == []);
    assert (candidate([12345, 2033, 111, 151]) == [111, 151]);
    assert (candidate([135, 103, 31]) == [31, 135]);
    assert True;
}
