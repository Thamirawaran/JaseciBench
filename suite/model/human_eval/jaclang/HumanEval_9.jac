import from typing { List, Tuple }
""" From a given list of integers, generate a list of rolling maximum element found until given moment
    in the sequence.
    >>> rolling_max([1, 2, 3, 2, 3, 4, 2])
    [1, 2, 3, 3, 3, 4, 4]
    """
def rolling_max(numbers: List[int]) -> List[int];

test "Check candidate function" {
    candidate = rolling_max;
    assert (candidate([]) == []);
    assert (candidate([1, 2, 3, 4]) == [1, 2, 3, 4]);
    assert (candidate([4, 3, 2, 1]) == [4, 4, 4, 4]);
    assert (candidate([3, 2, 3, 100, 3]) == [3, 3, 3, 100, 100]);
}
