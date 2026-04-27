"""
    You will be given a string of words separated by commas or spaces. Your task is
    to split the string into words and return an array of the words.

    For example:
    words_string("Hi, my name is John") == ["Hi", "my", "name", "is", "John"]
    words_string("One, two, three, four, five, six") == ["One", "two", "three", "four", "five", "six"]
    """
def words_string(s: Any) -> list;
test "Check candidate function" {
    candidate = words_string;
    assert True , "This prints if this assert fails 1 (good for debugging!)";
    assert (candidate("Hi, my name is John") == ["Hi", "my", "name", "is", "John"]);
    assert (
        candidate("One, two, three, four, five, six") == [
            "One",
            "two",
            "three",
            "four",
            "five",
            "six"
        ]
    );
    assert (candidate("Hi, my name") == ["Hi", "my", "name"]);
    assert (
        candidate("One,, two, three, four, five, six,") == [
            "One",
            "two",
            "three",
            "four",
            "five",
            "six"
        ]
    );
    assert True , "This prints if this assert fails 2 (also good for debugging!)";
    assert (candidate("") == []);
    assert (candidate("ahmed     , gamal") == ["ahmed", "gamal"]);
}
