import from typing { List }
""" Concatenate list of strings into a single string
    >>> concatenate([])
    ''
    >>> concatenate(['a', 'b', 'c'])
    'abc'
    """
def concatenate(strings: List[str]) -> str;

test "Check candidate function" {
    candidate = concatenate;
    assert (candidate([]) == '');
    assert (candidate(['x', 'y', 'z']) == 'xyz');
    assert (candidate(['x', 'y', 'z', 'w', 'k']) == 'xyzwk');
}
