import from typing { List }
""" Return list of all prefixes from shortest to longest of the input string
    >>> all_prefixes('abc')
    ['a', 'ab', 'abc']
    """
def all_prefixes(string: str) -> List[str];

test "Check candidate function" {
    candidate = all_prefixes;
    assert (candidate('') == []);
    assert (candidate('asdfgh') == ['a', 'as', 'asd', 'asdf', 'asdfg', 'asdfgh']);
    assert (candidate('WWW') == ['W', 'WW', 'WWW']);
}
