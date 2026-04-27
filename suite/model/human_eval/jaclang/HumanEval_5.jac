import from typing { List }
""" Insert a number 'delimeter' between every two consecutive elements of input list `numbers'
    >>> intersperse([], 4)
    []
    >>> intersperse([1, 2, 3], 4)
    [1, 4, 2, 4, 3]
    """
def intersperse(numbers: List[int], delimeter: int) -> List[int];

test "Check candidate function" {
    candidate = intersperse;
    assert (candidate([], 7) == []);
    assert (candidate([5, 6, 3, 2], 8) == [5, 8, 6, 8, 3, 8, 2]);
    assert (candidate([2, 2, 2], 2) == [2, 2, 2, 2, 2]);
}
