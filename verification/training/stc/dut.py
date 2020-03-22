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
    def __init__(self, scoreboard, sync = 'a', payload = 10):
        self.in_list = []
        self.scoreboard = scoreboard
        self.syncs = [{'sync': 'AABB0034', 'payload': 55, 'curr_idx' : 0, 'final_idx' : len('AABB0034')}, 
                        {'sync': '34569865543', 'payload': 124, 'curr_idx' : 0, 'final_idx' : len('34569865543')},
                        {'sync': sync, 'payload': payload, 'curr_idx' : 0, 'final_idx' : len(sync)}]
        self.found_sync = 0
        self.sync_payload_size = 0

    def write_byte(self, word):
        self.in_list.append(word)

        time.sleep(0.001)

        if self.found_sync == 0:
            self.find_sync(word)
        else:
            if self.sync_payload_size > 0:
                self.scoreboard.write_byte_dut(word)
                self.sync_payload_size -= 1
            else:
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