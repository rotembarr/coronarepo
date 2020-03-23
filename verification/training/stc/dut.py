###########################################################################################
#     __     __                _    __   _                  _     _                     ###
#     \ \   / /   ___   _ __  (_)  / _| (_)   ___    __ _  | |_  (_)   ___    _ __      ###
#      \ \ / /   / _ \ | '__| | | | |_  | |  / __|  / _` | | __| | |  / _ \  | '_ \     ###
#       \ V /   |  __/ | |    | | |  _| | | | (__  | (_| | | |_  | | | (_) | | | | |    ###
#        \_/     \___| |_|    |_| |_|   |_|  \___|  \__,_|  \__| |_|  \___/  |_| |_|    ###
###########################################################################################
#                                                                                       ###
# DUT - device under test                                                               ###
# Searches for a synchronization series and outputs a byte every time                    ###
# Input - Byte                                                                          ###
# Output - Byte                                                                         ###
###########################################################################################

import time


class DUT:
    def __init__(self, scoreboard, sync='00', payload=10):
        self.scoreboard = scoreboard

        self.syncs = [{'sync': ['AA', 'BB', '00', '34'], 'payload': 55, 'curr_idx': 0, 'final_idx': len(['AA', 'BB', '00', '34'], )},
                      {'sync': ['34', '0A', 'BB'], 'payload': 124, 'curr_idx': 0, 'final_idx': len(['34', '0A', 'BB'])},
                      {'sync': sync, 'payload': payload, 'curr_idx': 0, 'final_idx': len(sync)}]
        self.found_sync = 0
        self.sync_payload_size = 0

    def write_byte(self, word):

        # Delay of the firmware
        time.sleep(0.001)

        # Searching for the next sync
        if self.found_sync == 0:
            self.find_sync(word)

        # Send the payload of the sync
        else:
            if self.sync_payload_size > 0:
                self.scoreboard.write_byte_dut(word)
                self.sync_payload_size -= 1

                if self.sync_payload_size == 0:
                    self.found_sync = 0

    def find_sync(self, word):
        for sync in self.syncs:
            if sync['sync'][sync['curr_idx']] == word:
                sync['curr_idx'] += 1
            else:
                sync['curr_idx'] = 0

            if sync['curr_idx'] == sync['final_idx']:
                self.found_sync = 1
                self.sync_payload_size = sync['payload']
                print('sync occ----------------------------------------------------------------------')
                print(sync['sync'])
                self.reset_syncs()

    def reset_syncs(self):
        for sync in self.syncs:
            sync['curr_idx'] = 0
