""" For a given string, flip lowercase characters to uppercase and uppercase to lowercase.
    >>> flip_case('Hello')
    'hELLO'
    """
def flip_case(string: str) -> str;
test "Check candidate function" {
    candidate = flip_case;
    assert (candidate('') == '');
    assert (candidate('Hello!') == 'hELLO!');
    assert (
        candidate('These violent delights have violent ends') == 'tHESE VIOLENT DELIGHTS HAVE VIOLENT ENDS'
    );
}
