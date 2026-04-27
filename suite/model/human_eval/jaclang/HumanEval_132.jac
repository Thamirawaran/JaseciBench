'''
    Create a function that takes a string as input which contains only square brackets.
    The function should return True if and only if there is a valid subsequence of brackets
    where at least one bracket in the subsequence is nested.

    is_nested('[[]]') ➞ True
    is_nested('[]]]]]]][[[[[]') ➞ False
    is_nested('[][]') ➞ False
    is_nested('[]') ➞ False
    is_nested('[[][]]') ➞ True
    is_nested('[[]][[') ➞ True
    '''
def is_nested(string: Any) -> bool;
test "Check candidate function" {
    candidate = is_nested;
    assert (candidate('[[]]') == True) , "This prints if this assert fails 1 (good for debugging!)";
    assert (candidate('[]]]]]]][[[[[]') == False);
    assert (candidate('[][]') == False);
    assert (candidate('[]') == False);
    assert (candidate('[[[[]]]]') == True);
    assert (candidate('[]]]]]]]]]]') == False);
    assert (candidate('[][][[]]') == True);
    assert (candidate('[[]') == False);
    assert (candidate('[]]') == False);
    assert (candidate('[[]][[') == True);
    assert (candidate('[[][]]') == True);
    assert (candidate('') == False) , "This prints if this assert fails 2 (also good for debugging!)";
    assert (candidate('[[[[[[[[') == False);
    assert (candidate(']]]]]]]]') == False);
}
