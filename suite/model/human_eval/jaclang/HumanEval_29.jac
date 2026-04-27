import from typing { List }
""" Filter an input list of strings only for ones that start with a given prefix.
    >>> filter_by_prefix([], 'a')
    []
    >>> filter_by_prefix(['abc', 'bcd', 'cde', 'array'], 'a')
    ['abc', 'array']
    """
def filter_by_prefix(strings: List[str], prefix: str) -> List[str];

test "Check candidate function" {
    candidate = filter_by_prefix;
    assert (candidate([], 'john') == []);
    assert (
        candidate(['xxx', 'asd', 'xxy', 'john doe', 'xxxAAA', 'xxx'], 'xxx') == [
            'xxx',
            'xxxAAA',
            'xxx'
        ]
    );
}
