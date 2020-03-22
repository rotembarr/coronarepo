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

import package

class ReferenceModel:
    def __init__(self, scoreboard):
        self.in_list = []
        self.scoreboard = scoreboard
        self.syncs = self.init_syncs()
        self.found_sync = 0
        self.sync_payload_size = 0

    def init_syncs(self):
        temp_syncs = package.SYNCS
        for sync in temp_syncs:        
            sync['curr_idx'] = 0
            sync['final_idx'] = len(sync['sync'])
        return temp_syncs

    def write_byte(self, word):
        self.in_list.append(word)

        if self.found_sync == 0:
            self.find_sync(word)
        else:
            if self.sync_payload_size > 0:
                self.scoreboard.write_byte_rm(word)
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