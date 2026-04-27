"""Circular shift the digits of the integer x, shift the digits right by shift
    and return the result as a string.
    If shift > number of digits, return digits reversed.
    >>> circular_shift(12, 1)
    "21"
    >>> circular_shift(12, 2)
    "12"
    """
def circular_shift(x: Any, shift: Any) -> str;
test "Check candidate function" {
    candidate = circular_shift;
    assert (candidate(100, 2) == "001");
    assert (candidate(12, 2) == "12");
    assert (candidate(97, 8) == "79");
    assert (candidate(12, 1) == "21") , "This prints if this assert fails 1 (good for debugging!)";
    assert (candidate(11, 101) == "11") , "This prints if this assert fails 2 (also good for debugging!)";
}
