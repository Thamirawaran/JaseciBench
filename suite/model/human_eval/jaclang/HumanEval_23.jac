""" Return length of given string
    >>> strlen('')
    0
    >>> strlen('abc')
    3
    """
def strlen(string: str) -> int;
test "Check candidate function" {
    candidate = strlen;
    assert (candidate('') == 0);
    assert (candidate('x') == 1);
    assert (candidate('asdasnakj') == 9);
}
