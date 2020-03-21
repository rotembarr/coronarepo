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


class DUT:
    def __init__(self, sequence):
        self.sequence = sequence

    def logic(self):
        # For every value that have been sent from the sequence
        for value in self.sequence.run():
            """
                TODO: All the logic of the DUT should be here
            """

            # Sends the output to the scoreboard but does not stops the execution of the function
            yield value
