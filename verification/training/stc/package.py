import random

# Simulation parameters
NUM_OF_BYTES_TO_SEND = 1000

# DUT parameters
BUS_WIDTH_IN_BYTES = 1

# Sequence
RAND_VALUE = '@'
RAND_BYTE_W = 1
RAND_BYTE_IN_SYNC_0_W = 30
RAND_BYTE_IN_SYNC_1_W = 0
RAND_BYTE_IN_SYNC_PARAM_W = 0

# Payload in bytes
# The sync series is in hexadecimal
PARAM_SYNC = {'sync': 'ads', 'payload': 10}
SYNCS = [{'sync': 'AABB0034', 'payload': 55},
         {'sync': '34569865543', 'payload': 124},
         PARAM_SYNC]


# define Python user-defined exceptions
class Error(Exception):
    """Base class for other exceptions"""
    pass


class ComparisionFailed(Error):
    """Raised When The Comparision In The Scoreboard Has Failed"""
    pass
