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
