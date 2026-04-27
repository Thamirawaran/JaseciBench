"""The Brazilian factorial is defined as:
    brazilian_factorial(n) = n! * (n-1)! * (n-2)! * ... * 1!
    where n > 0

    For example:
    >>> special_factorial(4)
    288

    The function will receive an integer as input and should return the special
    factorial of this integer.
    """
def special_factorial(n: Any) -> int;
test "Check candidate function" {
    candidate = special_factorial;
    assert (candidate(4) == 288) , "Test 4";
    assert (candidate(5) == 34560) , "Test 5";
    assert (candidate(7) == 125411328000) , "Test 7";
    assert (candidate(1) == 1) , "Test 1";
}
