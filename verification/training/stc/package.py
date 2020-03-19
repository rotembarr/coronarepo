import random

NUM_OF_MSG = 3

MINUTE_IN_SECONDS = 60

BUS_WIDTH_IN = 8
BUS_WIDTH_OUT = 1

# Payload in bits
SYNC_0 = {'sync': 'aa', 'payload': 1}
SYNC_1 = {'sync': 'bb', 'payload': 2}
SYNC_2 = {'sync': 'cc', 'payload': 3}
SYNC_3 = {'sync': 'dd', 'payload': 4}
SYNCS = [SYNC_0, SYNC_1, SYNC_2, SYNC_3]


def is_true_by_percentage(percent, max_percent=100, min_percent=1):
    """
    The function received the number and checks if the number is greater than the random number we produce(in the range)

    :param percent: The user number that indicate the percentage to return True from the max percent.
    :param min_percent: The min percent on the range.
    :param max_percent: The max percent on the range.
    :return: True if the percent bigger then the random number else False.
    """

    # Check if the user percent bigger then the max range.
    assert percent <= max_percent

    # Generate random number between the range.
    random_num = random.randrange(min_percent, max_percent)

    return True if percent > random_num else False


# define Python user-defined exceptions
class Error(Exception):
    """Base class for other exceptions"""
    pass


class ComparisionFailed(Error):
    """Raised When The Comparision In The Scoreboard Has Failed"""
    pass


class TimeoutOccurred(Error):
    """Raised When The Timeout Reached His Limit"""
    pass


if __name__ == "__main__":
    print(is_true_by_percentage(100))
