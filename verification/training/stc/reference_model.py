###########################################################################################
#     __     __                _    __   _                  _     _                     ###
#     \ \   / /   ___   _ __  (_)  / _| (_)   ___    __ _  | |_  (_)   ___    _ __      ###
#      \ \ / /   / _ \ | '__| | | | |_  | |  / __|  / _` | | __| | |  / _ \  | '_ \     ###
#       \ V /   |  __/ | |    | | |  _| | | | (__  | (_| | | |_  | | | (_) | | | | |    ###
#        \_/     \___| |_|    |_| |_|   |_|  \___|  \__,_|  \__| |_|  \___/  |_| |_|    ###
###########################################################################################
#                                                                                       ###
# Searches for a synchronization and if found it outputs some number of bytes           ###
# Input - List of byte                                                                  ###
# Output - List of byte                                                                 ###
###########################################################################################

import package


class ReferenceModel:
    def __init__(self, scoreboard):
        self.scoreboard = scoreboard
        self.in_list = []

    # Gets the output of the Scoreboard
    def write_byte(self, word):
        # Sends the output of the RM to the Scoreboard
        self.scoreboard.write_byte_rm(word)