"""
    returns encoded string by cycling groups of three characters.
    """
def encode_cyclic(s: str) -> str;
"""
    takes as input string encoded with encode_cyclic function. Returns decoded string.
    """
def decode_cyclic(s: str) -> str;

test "Check candidate function" {
    candidate = decode_cyclic;
    import from random { randint, choice }
    import string;
    letters = list(string.ascii_lowercase);
    for _ in range(100) {
        str = ''.join(choice(letters) for i in range(randint(10, 20)));
        encoded_str = encode_cyclic(str);
        assert (candidate(encoded_str) == str);
    }
}
