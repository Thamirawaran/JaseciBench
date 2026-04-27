import from typing { List, Any }
""" Filter given list of any python values only for integers
    >>> filter_integers(['a', 3.14, 5])
    [5]
    >>> filter_integers([1, 2, 3, 'abc', {}, []])
    [1, 2, 3]
    """
def filter_integers(values: List[Any]) -> List[int];

test "Check candidate function" {
    candidate = filter_integers;
    assert (candidate([]) == []);
    assert (candidate([4, {}, [], 23.2, 9, 'adasd']) == [4, 9]);
    assert (candidate([3, 'c', 3, 3, 'a', 'b']) == [3, 3, 3]);
}
