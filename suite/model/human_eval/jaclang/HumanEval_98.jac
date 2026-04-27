"""
    Given a string s, count the number of uppercase vowels in even indices.

    For example:
    count_upper('aBCdEf') returns 1
    count_upper('abcdefg') returns 0
    count_upper('dBBE') returns 0
    """
def count_upper(s: Any) -> int;
test "Check candidate function" {
    candidate = count_upper;
    assert (candidate('aBCdEf') == 1);
    assert (candidate('abcdefg') == 0);
    assert (candidate('dBBE') == 0);
    assert (candidate('B') == 0);
    assert (candidate('U') == 1);
    assert (candidate('') == 0);
    assert (candidate('EEEE') == 2);
    assert True;
}
