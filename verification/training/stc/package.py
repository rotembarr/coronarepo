NUM_OF_MSG = 100

MINUTE_IN_SECONDS = 60

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