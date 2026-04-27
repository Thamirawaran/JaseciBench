import from typing { List }
""" For a given list of input numbers, calculate Mean Absolute Deviation
    around the mean of this dataset.
    Mean Absolute Deviation is the average absolute difference between each
    element and a centerpoint (mean in this case):
    MAD = average | x - x_mean |
    >>> mean_absolute_deviation([1.0, 2.0, 3.0, 4.0])
    1.0
    """
def mean_absolute_deviation(numbers: List[float]) -> float;

test "Check candidate function" {
    candidate = mean_absolute_deviation;
    assert (`abs((candidate([1.0, 2.0, 3.0]) - (2.0 / 3.0))) < 1e-06);
    assert (`abs((candidate([1.0, 2.0, 3.0, 4.0]) - 1.0)) < 1e-06);
    assert (`abs((candidate([1.0, 2.0, 3.0, 4.0, 5.0]) - (6.0 / 5.0))) < 1e-06);
}
