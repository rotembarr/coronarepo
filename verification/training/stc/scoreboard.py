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

    def __init__(self, dut, rm):
        self.dut = dut
        self.rm = rm
        self.dut_output_list = []
        self.rm_output_list = []
        # The number of msgs which compared
        self._msg_compared = 0

        self.get_dut_output()
        self.get_rm_output()

    # Gets the output from the dut
    def get_dut_output(self):
        for value in self.dut.logic():
            self.dut_output_list.append(value)

    # Gets the output from the rm
    def get_rm_output(self):
        for value in self.rm.logic():
            self.rm_output_list += value

    def run(self):

        # Sets the timeout to 1 minutes from now
        timeout = time.time() + package.MINUTE_IN_SECONDS

        try:
            while True:

                # Wait until an item is received in both lists
                if self.dut_output_list and self.rm_output_list:

                    # Sets the timeout to 1 minutes from now
                    timeout = time.time() + package.MINUTE_IN_SECONDS

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

                elif time.time() > timeout:
                    raise package.TimeoutOccurred()
                else:
                    print('##############################################################\n')
                    print('############# The Test Has Finished Successfully #############\n')
                    print('##############################################################\n')
                    break

        except package.ComparisionFailed:

            print('\n############# Item No.{} Comparison Has Failed #############\n'.format(self._msg_compared))
            print('\n############# DUT ITEM #############\n')
            print(dut_item)
            print('\n############# REFERENCE MODEL ITEM #############\n')
            print(rm_item)

        except package.TimeoutOccurred:

            print("\nThe Timeout Reached His Limit\n")

            if (not self.dut_output_list) and not (self.rm_output_list):
                print("\nNo messages were sent to both DUT and Reference Model\n")

            elif not self.dut_output_list:
                print("\nThe DUT Is Missing An Item\n")

            elif not self.rm_output_list:
                print("\nThe Reference Model Is Missing An Item\n")