'''
    There are eight planets in our solar system: the closerst to the Sun
    is Mercury, the next one is Venus, then Earth, Mars, Jupiter, Saturn,
    Uranus, Neptune.
    Write a function that takes two planet names as strings planet1 and planet2.
    The function should return a tuple containing all planets whose orbits are
    located between the orbit of planet1 and the orbit of planet2, sorted by
    the proximity to the sun.
    The function should return an empty tuple if planet1 or planet2
    are not correct planet names.
    Examples
    bf("Jupiter", "Neptune") ==> ("Saturn", "Uranus")
    bf("Earth", "Mercury") ==> ("Venus")
    bf("Mercury", "Uranus") ==> ("Venus", "Earth", "Mars", "Jupiter", "Saturn")
    '''
def bf(planet1: str, planet2: str) -> tuple;

test "Check candidate function" {
    candidate = bf;
    assert (candidate("Jupiter", "Neptune") == ("Saturn", "Uranus")) , (
        "First test error: " + str(len(candidate("Jupiter", "Neptune")))
    );
    assert (candidate("Earth", "Mercury") == ("Venus", )) , (
        "Second test error: " + str(candidate("Earth", "Mercury"))
    );
    assert (
        candidate("Mercury", "Uranus") == (
            "Venus",
            "Earth",
            "Mars",
            "Jupiter",
            "Saturn"
        )
    ) , ("Third test error: " + str(candidate("Mercury", "Uranus")));
    assert (
        candidate("Neptune", "Venus") == (
            "Earth",
            "Mars",
            "Jupiter",
            "Saturn",
            "Uranus"
        )
    ) , ("Fourth test error: " + str(candidate("Neptune", "Venus")));
    assert (candidate("Earth", "Earth") == ());
    assert (candidate("Mars", "Earth") == ());
    assert (candidate("Jupiter", "Makemake") == ());
}
