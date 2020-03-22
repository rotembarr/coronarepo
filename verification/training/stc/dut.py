###########################################################################################
#     __     __                _    __   _                  _     _                     ###
#     \ \   / /   ___   _ __  (_)  / _| (_)   ___    __ _  | |_  (_)   ___    _ __      ###
#      \ \ / /   / _ \ | '__| | | | |_  | |  / __|  / _` | | __| | |  / _ \  | '_ \     ###
#       \ V /   |  __/ | |    | | |  _| | | | (__  | (_| | | |_  | | | (_) | | | | |    ###
#        \_/     \___| |_|    |_| |_|   |_|  \___|  \__,_|  \__| |_|  \___/  |_| |_|    ###
###########################################################################################
#                                                                                       ###
# DUT - device under test                                                               ###
# Searchs for a synchronization series and outputs a byte every time                    ###
# Input - Byte                                                                          ###
# Output - Byte                                                                         ###
###########################################################################################

import time

class DUT:
    def __init__(self, scoreboard):
        self.in_list = []
        self.scoreboard = scoreboard 

    def write_byte(self, word):
        self.in_list.append(word)

        time.sleep(0.01)
        self.scoreboard.write_byte_dut(word)

    def logic(self):
        # For every value that have been sent from the sequence
        # for value in self.sequence.run():
            # """
                # TODO: All the logic of the DUT should be here
            # """

            # Sends the output to the scoreboard but does not stops the execution of the function
        yield '1'
