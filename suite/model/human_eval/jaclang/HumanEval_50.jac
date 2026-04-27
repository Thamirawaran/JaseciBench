"""
    returns encoded string by shifting every character by 5 in the alphabet.
    """
def encode_shift(s: str) -> str;
"""
    takes as input string encoded with encode_shift function. Returns decoded string.
    """
def decode_shift(s: str) -> str;

test "Check candidate function" {
    candidate = decode_shift;
    import from random { randint, choice }
    import copy;
    import string;
    letters = list(string.ascii_lowercase);
    for _ in range(100) {
        str = ''.join(choice(letters) for i in range(randint(10, 20)));
        encoded_str = encode_shift(str);
        assert (candidate(copy.deepcopy(encoded_str)) == str);
    }
}
