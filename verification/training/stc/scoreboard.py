###########################################################################################
#     __     __                _    __   _                  _     _                     ###
#     \ \   / /   ___   _ __  (_)  / _| (_)   ___    __ _  | |_  (_)   ___    _ __      ###
#      \ \ / /   / _ \ | '__| | | | |_  | |  / __|  / _` | | __| | |  / _ \  | '_ \     ###
#       \ V /   |  __/ | |    | | |  _| | | | (__  | (_| | | |_  | | | (_) | | | | |    ###
#        \_/     \___| |_|    |_| |_|   |_|  \___|  \__,_|  \__| |_|  \___/  |_| |_|    ###
###########################################################################################
#                                                                                       ###
# Compares the outputs of the DUT and RM                                                ###
###########################################################################################


import package
import time


class Scoreboard:

    def __init__(self):
        self.dut_output_list = []
        self.rm_output_list = []
        # The number of msgs which compared
        self._msg_compared = 0

        # self.get_dut_output()
        # self.get_rm_output()

    def write_byte_dut(self, word):
        self.dut_output_list.append(word)
        self.compare()

    def write_byte_rm(self, word):
        self.rm_output_list.append(word)
        self.compare()

    def compare(self):
        try:
            if self.dut_output_list and self.rm_output_list:

                # Gets the first DUT item
                dut_item = self.dut_output_list.pop(0)

                # Gets the first RM item
                rm_item = self.rm_output_list.pop(0)

                if dut_item == rm_item:
                    # Updates the counter
                    self._msg_compared += 1
                    print('\n############# Item No.{} Has Compared Successfully #############\n'.format(self._msg_compared))
                else:
                    raise package.ComparisionFailed()

        except package.ComparisionFailed:

            print('\n############# Item No.{} Comparison Has Failed #############\n'.format(self._msg_compared))
            print('\n############# DUT ITEM #############\n')
            print(dut_item)
            print('\n############# REFERENCE MODEL ITEM #############\n')
            print(rm_item)

    def final_check(self):
        print('final check')
        print('##############################################################\n')
        print('############# The Test Has Finished Successfully #############\n')
        print('##############################################################\n')