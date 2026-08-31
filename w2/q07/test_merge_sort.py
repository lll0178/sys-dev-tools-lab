from merge_sort import merge_sort


def test_given_input():
    assert merge_sort([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]


def test_duplicates():
    assert merge_sort([5, 3, 3, 2, 2, 5, 1]) == [1, 2, 2, 3, 3, 5, 5]
