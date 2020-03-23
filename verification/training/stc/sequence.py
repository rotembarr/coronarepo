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
import random
import string


class Sequence:
    def __init__(self, reference_model, dut):
        self.rm = reference_model
        self.dut = dut

    def run(self):

        for byte_num in range(package.NUM_OF_BYTES_TO_SEND):

            """
                TODO: Insert your code Here
            """
            # 02x - means hexadecimal
            # casts 8 bit to hexadecimal
            random_byte = '{:02x}'.format(random.getrandbits(8))
            # Randomize an input
            self.drive_byte(random_byte)

    # Drives given byte to the RM and DUT
    def drive_byte(self, random_byte):
        self.rm.write_byte(random_byte)
        self.dut.write_byte(random_byte)
