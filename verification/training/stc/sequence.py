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
import random
import string


class Sequence:
    def __init__(self, reference_model, dut):
        self.rm = reference_model
        self.dut = dut
        self.syncs_idx = [{'sync': package.SYNCS[0]['sync'], 'idx': 0},
                          {'sync': package.SYNCS[1]['sync'], 'idx': 0},
                          {'sync': package.SYNCS[2]['sync'], 'idx': 0}]

    def run(self):

        rand_choices = random.choices(
            # Contains all the syncs and a specific value that displays whether to send random information
            population=[package.SYNCS[0], package.SYNCS[1], package.SYNCS[2], package.RAND_VALUE],
            # The weight for every element
            weights=[package.RAND_BYTE_IN_SYNC_0_W, package.RAND_BYTE_IN_SYNC_1_W, package.RAND_BYTE_IN_SYNC_PARAM_W,
                     package.RAND_BYTE_W],
            # The size of the returned list
            k=package.NUM_OF_BYTES_TO_SEND
        )

        for byte_num in range(package.NUM_OF_BYTES_TO_SEND):

            # Picks random element from the list
            rand_choice = random.choice(rand_choices)

            if rand_choice == package.RAND_VALUE:
                # Randomize a single byte
                # random_byte = random.choice(string.ascii_letters)
                random_byte = '{:02x}'.format(random.getrandbits(8))
                self.drive_byte(random_byte)
                self.reset_all_idx()
            else:
                # The sync which was chosen
                sync = rand_choice['sync']
                # Gets the current index of the sync from the list of dict
                curr_idx_of_byte_in_sync = next(item['idx'] for item in self.syncs_idx if sync == item['sync'])

                # Checks if the current index is the last char of the sync
                if curr_idx_of_byte_in_sync == len(sync) - 1:

                    random_byte = sync[curr_idx_of_byte_in_sync]
                    self.drive_byte(random_byte)
                    self.set_index_of_sync(sync, 0)
                    self.drive_payload(rand_choice['payload'])

                else:
                    random_byte = sync[curr_idx_of_byte_in_sync]
                    self.drive_byte(random_byte)
                    self.set_index_of_sync(sync, curr_idx_of_byte_in_sync + 1)

    # Drives given byte to the RM and DUT
    def drive_byte(self, random_byte):
        self.rm.write_byte(random_byte)
        self.dut.write_byte(random_byte)

    def set_index_of_sync(self, sync, idx):
        for item in self.syncs_idx:
            if sync == item['sync']:
                item['idx'] = idx

    def drive_payload(self, payload):
        for i in range(payload):
            self.drive_byte('{:02x}'.format(random.getrandbits(8)))

    def reset_all_idx(self):
        for item in self.syncs_idx:
            item['idx'] = 0
