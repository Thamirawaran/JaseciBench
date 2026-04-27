""" Given a string, find out how many distinct characters (regardless of case) does it consist of
    >>> count_distinct_characters('xyzXYZ')
    3
    >>> count_distinct_characters('Jerry')
    4
    """
def count_distinct_characters(string: str) -> int;
test "Check candidate function" {
    candidate = count_distinct_characters;
    assert (candidate('') == 0);
    assert (candidate('abcde') == 5);
    assert (candidate(('abcde' + 'cade' + 'CADE')) == 5);
    assert (candidate('aaaaAAAAaaaa') == 1);
    assert (candidate('Jerry jERRY JeRRRY') == 5);
}
