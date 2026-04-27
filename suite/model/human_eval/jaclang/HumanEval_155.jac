"""Given an integer. return a tuple that has the number of even and odd digits respectively.

     Example:
        even_odd_count(-12) ==> (1, 1)
        even_odd_count(123) ==> (1, 2)
    """
def even_odd_count(num: Any) -> tuple;
test "Check candidate function" {
    candidate = even_odd_count;
    assert (candidate(7) == (0, 1));
    assert (candidate(-78) == (1, 1));
    assert (candidate(3452) == (2, 2));
    assert (candidate(346211) == (3, 3));
    assert (candidate(-345821) == (3, 3));
    assert (candidate(-2) == (1, 0));
    assert (candidate(-45347) == (2, 3));
    assert (candidate(0) == (1, 0));
    assert True;
}
