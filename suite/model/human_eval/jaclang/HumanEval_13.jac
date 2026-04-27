""" Return a greatest common divisor of two integers a and b
    >>> greatest_common_divisor(3, 5)
    1
    >>> greatest_common_divisor(25, 15)
    5
    """
def greatest_common_divisor(a: int, b: int) -> int;
test "Check candidate function" {
    candidate = greatest_common_divisor;
    assert (candidate(3, 7) == 1);
    assert (candidate(10, 15) == 5);
    assert (candidate(49, 14) == 7);
    assert (candidate(144, 60) == 12);
}
