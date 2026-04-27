"""Write a function that accepts a list of strings.
    The list contains different words. Return the word with maximum number
    of unique characters. If multiple strings have maximum number of unique
    characters, return the one which comes first in lexicographical order.

    find_max(["name", "of", "string"]) == "string"
    find_max(["name", "enam", "game"]) == "enam"
    find_max(["aaaaaaa", "bb" ,"cc"]) == ""aaaaaaa"
    """
def find_max(words: Any) -> str;
test "Check candidate function" {
    candidate = find_max;
    assert (candidate(["name", "of", "string"]) == "string") , "t1";
    assert (candidate(["name", "enam", "game"]) == "enam") , 't2';
    assert (candidate(["aaaaaaa", "bb", "cc"]) == "aaaaaaa") , 't3';
    assert (candidate(["abc", "cba"]) == "abc") , 't4';
    assert (candidate(["play", "this", "game", "of", "footbott"]) == "footbott") , 't5';
    assert (candidate(["we", "are", "gonna", "rock"]) == "gonna") , 't6';
    assert (candidate(["we", "are", "a", "mad", "nation"]) == "nation") , 't7';
    assert (candidate(["this", "is", "a", "prrk"]) == "this") , 't8';
    assert (candidate(["b"]) == "b") , 't9';
    assert (candidate(["play", "play", "play"]) == "play") , 't10';
}
