"""Return n-th Fibonacci number.
    >>> fib(10)
    55
    >>> fib(1)
    1
    >>> fib(8)
    21
    """
def fib(n: int) -> int;
test "Check candidate function" {
    candidate = fib;
    assert (candidate(10) == 55);
    assert (candidate(1) == 1);
    assert (candidate(8) == 21);
    assert (candidate(11) == 89);
    assert (candidate(12) == 144);
}
