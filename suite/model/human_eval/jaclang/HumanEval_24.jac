""" For a given number n, find the largest number that divides n evenly, smaller than n
    >>> largest_divisor(15)
    5
    """
def largest_divisor(n: int) -> int;
test "Check candidate function" {
    candidate = largest_divisor;
    assert (candidate(3) == 1);
    assert (candidate(7) == 1);
    assert (candidate(10) == 5);
    assert (candidate(100) == 50);
    assert (candidate(49) == 7);
}
