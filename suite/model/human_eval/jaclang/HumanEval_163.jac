"""
    Given two positive integers a and b, return the even digits between a
    and b, in ascending order.

    For example:
    generate_integers(2, 8) => [2, 4, 6, 8]
    generate_integers(8, 2) => [2, 4, 6, 8]
    generate_integers(10, 14) => []
    """
def generate_integers(a: Any, b: Any) -> list;
test "Check candidate function" {
    candidate = generate_integers;
    assert (candidate(2, 10) == [2, 4, 6, 8]) , "Test 1";
    assert (candidate(10, 2) == [2, 4, 6, 8]) , "Test 2";
    assert (candidate(132, 2) == [2, 4, 6, 8]) , "Test 3";
    assert (candidate(17, 89) == []) , "Test 4";
    assert True , "This prints if this assert fails 2 (also good for debugging!)";
}
