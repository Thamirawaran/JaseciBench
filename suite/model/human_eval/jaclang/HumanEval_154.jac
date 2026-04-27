"""You are given 2 words. You need to return True if the second word or any of its rotations is a substring in the first word
    cycpattern_check("abcd","abd") => False
    cycpattern_check("hello","ell") => True
    cycpattern_check("whassup","psus") => False
    cycpattern_check("abab","baa") => True
    cycpattern_check("efef","eeff") => False
    cycpattern_check("himenss","simen") => True

    """
def cycpattern_check(a: Any, b: Any) -> bool;
test "Check candidate function" {
    candidate = cycpattern_check;
    assert (candidate("xyzw", "xyw") == False) , "test #0";
    assert (candidate("yello", "ell") == True) , "test #1";
    assert (candidate("whattup", "ptut") == False) , "test #2";
    assert (candidate("efef", "fee") == True) , "test #3";
    assert (candidate("abab", "aabb") == False) , "test #4";
    assert (candidate("winemtt", "tinem") == True) , "test #5";
}
