###########################################################################################
#     __     __                _    __   _                  _     _                     ###
#     \ \   / /   ___   _ __  (_)  / _| (_)   ___    __ _  | |_  (_)   ___    _ __      ###
#      \ \ / /   / _ \ | '__| | | | |_  | |  / __|  / _` | | __| | |  / _ \  | '_ \     ###
#       \ V /   |  __/ | |    | | |  _| | | | (__  | (_| | | |_  | | | (_) | | | | |    ###
#        \_/     \___| |_|    |_| |_|   |_|  \___|  \__,_|  \__| |_|  \___/  |_| |_|    ###
###########################################################################################
#                                                                                       ###
# Searchs for a synchronization and if found it outputs some number of bytes            ###
# Input - List of byte                                                                  ###
# Output - List of byte                                                                 ###
###########################################################################################


class ReferenceModel:
    def __init__(self, sequence):
        self.sequence = sequence
        self.in_list = []

    def logic(self):
        # Gets the data from the sequence
        self.in_list = self.sequence.list_of_bytes

        """
                TODO: All the logic of the Reference Model should be here
        """

        # Sends the output to the scoreboard but does not stops the execution of the function
        yield self.in_list
