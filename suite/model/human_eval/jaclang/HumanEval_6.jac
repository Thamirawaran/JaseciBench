import from typing { List }
""" Input to this function is a string represented multiple groups for nested parentheses separated by spaces.
    For each of the group, output the deepest level of nesting of parentheses.
    E.g. (()()) has maximum two levels of nesting while ((())) has three.

    >>> parse_nested_parens('(()()) ((())) () ((())()())')
    [2, 3, 1, 3]
    """
def parse_nested_parens(paren_string: str) -> List[int];

test "Check candidate function" {
    candidate = parse_nested_parens;
    assert (candidate('(()()) ((())) () ((())()())') == [2, 3, 1, 3]);
    assert (candidate('() (()) ((())) (((())))') == [1, 2, 3, 4]);
    assert (candidate('(()(())((())))') == [4]);
}
