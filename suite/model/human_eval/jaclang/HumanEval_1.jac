import from typing { List }
""" Input to this function is a string containing multiple groups of nested parentheses. Your goal is to
    separate those group into separate strings and return the list of those.
    Separate groups are balanced (each open brace is properly closed) and not nested within each other
    Ignore any spaces in the input string.
    >>> separate_paren_groups('( ) (( )) (( )( ))')
    ['()', '(())', '(()())']
    """
def separate_paren_groups(paren_string: str) -> List[str];

test "Check candidate function" {
    candidate = separate_paren_groups;
    assert (
        candidate('(()()) ((())) () ((())()())') == [
            '(()())',
            '((()))',
            '()',
            '((())()())'
        ]
    );
    assert (
        candidate('() (()) ((())) (((())))') == ['()', '(())', '((()))', '(((())))']
    );
    assert (candidate('(()(())((())))') == ['(()(())((())))']);
    assert (candidate('( ) (( )) (( )( ))') == ['()', '(())', '(()())']);
}
