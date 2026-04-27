import from typing { List }
""" Input are two strings a and b consisting only of 1s and 0s.
    Perform binary XOR on these inputs and return result also as a string.
    >>> string_xor('010', '110')
    '100'
    """
def string_xor(a: str, b: str) -> str;

test "Check candidate function" {
    candidate = string_xor;
    assert (candidate('111000', '101010') == '010010');
    assert (candidate('1', '1') == '0');
    assert (candidate('0101', '0000') == '0101');
}
