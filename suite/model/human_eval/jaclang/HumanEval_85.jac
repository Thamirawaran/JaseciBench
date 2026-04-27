"""Given a non-empty list of integers lst. add the even elements that are at odd indices..


    Examples:
        add([4, 2, 6, 7]) ==> 2
    """
def add(lst: Any) -> int;
test "Check candidate function" {
    candidate = add;
    assert (candidate([4, 88]) == 88);
    assert (candidate([4, 5, 6, 7, 2, 122]) == 122);
    assert (candidate([4, 0, 6, 7]) == 0);
    assert (candidate([4, 4, 6, 8]) == 12);
}
