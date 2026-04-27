import from typing { List }
""" Filter an input list of strings only for ones that contain given substring
    >>> filter_by_substring([], 'a')
    []
    >>> filter_by_substring(['abc', 'bacd', 'cde', 'array'], 'a')
    ['abc', 'bacd', 'array']
    """
def filter_by_substring(strings: List[str], substring: str) -> List[str];

test "Check candidate function" {
    candidate = filter_by_substring;
    assert (candidate([], 'john') == []);
    assert (
        candidate(['xxx', 'asd', 'xxy', 'john doe', 'xxxAAA', 'xxx'], 'xxx') == [
            'xxx',
            'xxxAAA',
            'xxx'
        ]
    );
    assert (
        candidate(['xxx', 'asd', 'aaaxxy', 'john doe', 'xxxAAA', 'xxx'], 'xx') == [
            'xxx',
            'aaaxxy',
            'xxxAAA',
            'xxx'
        ]
    );
    assert (
        candidate(['grunt', 'trumpet', 'prune', 'gruesome'], 'run') == [
            'grunt',
            'prune'
        ]
    );
}
