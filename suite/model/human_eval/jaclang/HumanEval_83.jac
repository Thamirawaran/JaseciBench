"""
    Given a positive integer n, return the count of the numbers of n-digit
    positive integers that start or end with 1.
    """
def starts_one_ends(n: Any) -> int;
test "Check candidate function" {
    candidate = starts_one_ends;
    assert True , "This prints if this assert fails 1 (good for debugging!)";
    assert (candidate(1) == 1);
    assert (candidate(2) == 18);
    assert (candidate(3) == 180);
    assert (candidate(4) == 1800);
    assert (candidate(5) == 18000);
    assert True , "This prints if this assert fails 2 (also good for debugging!)";
}
