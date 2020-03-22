###########################################################################################
#     __     __                _    __   _                  _     _                     ###
#     \ \   / /   ___   _ __  (_)  / _| (_)   ___    __ _  | |_  (_)   ___    _ __      ###
#      \ \ / /   / _ \ | '__| | | | |_  | |  / __|  / _` | | __| | |  / _ \  | '_ \     ###
#       \ V /   |  __/ | |    | | |  _| | | | (__  | (_| | | |_  | | | (_) | | | | |    ###
#        \_/     \___| |_|    |_| |_|   |_|  \___|  \__,_|  \__| |_|  \___/  |_| |_|    ###
###########################################################################################
#                                                                                       ###
# The Sequence randomize input items and sends them to the DUT and RM                   ###
# Sends every time a byte to the DUT                                                    ###
# Sends a list of bytes to the RM when finished sending all the bytes to the DUT        ###
###########################################################################################

import package
import os


class Sequence:
    def __init__(self, reference_model, dut):
        # List of the items which will be sent to the rm
        self.list_of_bytes = []
        self.rm = reference_model
        self.dut = dut

    def run(self):
        for byte_num in range(package.NUM_OF_BYTES_TO_SEND):
            # randomize an input
            random_byte = os.urandom(package.BUS_WIDTH_IN)
            # Adds the input to the rm list
            self.rm.write_byte(random_byte)
            self.dut.write_byte(random_byte)
            # self.list_of_bytes.append(random_byte)
            # Returns the input but does not stops the execution of the function
            # yield random_byte


# def gen_sync():
#     """
#     The function generate each time whole sync,
#     Sometimes correct and sometimes wrong.
#     """
#     # TODO Dont use FULL_PERCENTAGE plssss
#     # Use probability written in the package
#
#     # Generate correct sync
#     if package.is_true_by_percentage(package.GEN_GOOD_SYNC_P):
#         # Choose a random correct sync from the list of all the correct syncs.
#         sync = random.choice(package.SYNCS)['sync']
#
#     # Generate random sync
#     elif package.is_true_by_percentage(package.GEN_RAND_SYNC_PROB):
#         # Padding the random sync with format of HEX according to TBD size.
#         rand_sync_size = random.randrange(package.RAND_SYNC_MIN_SIZE, package.RAND_SYNC_MAX_SIZE)
#         sync = '{:0{}X}'.format(random.getrandbits(rand_sync_size), rand_sync_size // package.NIBBLE_SIZE)
#
#     # Generate wrong sync (similar to the correct)
#     else:
#         # Choose random correct sync from the list of all the correct syncs.
#         sync = random.choice(package.SYNCS)['sync']
#
#         # Random number that indicate how much nibbles we will change from the original.
#         num_of_nibble_to_change = random.randrange(1, len(sync))
#
#         # List with all the index of the nibbles in the current sync.
#         nibbles_idx_list = [idx for idx in range(len(sync))]
#
#         # Convert sync to a list of nibbles
#         sync = [char for char in sync]
#
#         # Change nibbles
#         for idx in range(num_of_nibble_to_change):
#             # Choice random nibble to change and deleted from the list so it will not be re-selected.
#             nibble_idx = random.choice(nibbles_idx_list)
#             nibbles_idx_list.remove(nibble_idx)
#             # Change the selected nibble with XOR on 1.
#             sync[nibble_idx] = '{:X}'.format(int(sync[nibble_idx], 16) ^ 1)
#
#         # Convert sync back to a string
#         sync = "".join(sync)
#
#     # Sent the sync to DUT and RM.
#     sent_sync_by_words(sync)
#
#
# def sent_sync_by_words(sync):
#     """
#     Received all the sync in str and insert to list according words.
#     :param sync: The sync that we need sent to DUT and RM.
#     :return: None, added to lists the sync.
#     """
#     word_size = package.BUS_WIDTH_IN // package.NIBBLE_SIZE
#     # Cut the sync_str to list of words
#     sync_by_words = [sync[idx:idx + word_size] for idx in range(0, len(sync), word_size)]
#
#     # Run on all the words in the list(sync) and append to dut and rm lists.
#     for word in sync_by_words:
#         self.dut.append_word(word)
#         self.rm.append_word(word)
