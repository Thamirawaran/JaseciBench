import from typing { List }
""" Input is a space-delimited string of numberals from 'zero' to 'nine'.
    Valid choices are 'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight' and 'nine'.
    Return the string with numbers sorted from smallest to largest
    >>> sort_numbers('three one five')
    'one three five'
    """
def sort_numbers(numbers: str) -> str;

test "Check candidate function" {
    candidate = sort_numbers;
    assert (candidate('') == '');
    assert (candidate('three') == 'three');
    assert (candidate('three five nine') == 'three five nine');
    assert (
        candidate('five zero four seven nine eight') == 'zero four five seven eight nine'
    );
    assert (
        candidate('six five four three two one zero') == 'zero one two three four five six'
    );
}
