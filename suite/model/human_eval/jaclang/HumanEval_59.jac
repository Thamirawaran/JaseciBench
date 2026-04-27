"""Return the largest prime factor of n. Assume n > 1 and is not a prime.
    >>> largest_prime_factor(13195)
    29
    >>> largest_prime_factor(2048)
    2
    """
def largest_prime_factor(n: int) -> int;
test "Check candidate function" {
    candidate = largest_prime_factor;
    assert (candidate(15) == 5);
    assert (candidate(27) == 3);
    assert (candidate(63) == 7);
    assert (candidate(330) == 11);
    assert (candidate(13195) == 29);
}
