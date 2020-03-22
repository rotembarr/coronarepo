import random

# Simulation parameters
NUM_OF_BYTES_TO_SEND = 3000
FULL_PERCENTAGE = 100

# DUT parameters
BUS_WIDTH_IN = 1

# Sequence
GEN_GOOD_SYNC_P = 20
GEN_RAND_SYNC_PROB = 50
RAND_SYNC_MIN_SIZE = BUS_WIDTH_IN
RAND_SYNC_MAX_SIZE = BUS_WIDTH_IN * 3

# Payload in bytes
# The sync series is in hexadecimal
PARAM_SYNC = {'sync': 'c', 'payload': 10}
SYNCS = [{'sync': 'AABB0034', 'payload': 55}, 
         {'sync': '34569865543', 'payload': 124},
         PARAM_SYNC]

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
