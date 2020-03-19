import package
import time
from myhdl import *


class Scoreboard:

    def __init__(self):
        self.dut_list = []
        self.rm_list = []
        # TODO : Note it compares by bits
        self._msg_compared = 0

    def run(self):


        # 1 minutes from now
        timeout = time.time() + package.MINUTE_IN_SECONDS

        yield (self.dut_list and self.rm_list), timeout

        try:
            while True:

                # Wait until a msg is received in both lists, or reached timeout
                yield len(self.dut_list), timeout

                if self.dut_list and self.rm_list:

                    # Gets the first item from the DUT queue
                    dut_item = self.dut_list.pop(0)

                    # Gets the first item from the RM queue
                    rm_item = self.rm_list.pop(0)

                    if dut_item == rm_item:
                        self._msg_compared += 1
                        print('\n############# Item No.{} Has Compared Successfully #############\n'.format(self._msg_compared))
                    else:
                        raise package.ComparisionFailed()

                else:
                    # Reached timeout
                    raise package.TimeoutOccurred()

            print('##############################################################\n')
            print('############# The Test Has Finished Successfully #############\n')
            print('##############################################################\n')

        except package.ComparisionFailed:

            print('\n############# Item No.{} Comparison Has Failed #############\n'.format(self._msg_compared))
            print('\n############# DUT ITEM #############\n')
            print(dut_item)
            print('\n############# REFERENCE MODEL ITEM #############\n')
            print(rm_item)

        except package.TimeoutOccurred:

            print("\nThe Timeout Reached His Limit\n")

            if not (self.dut_list or self.rm_list):
                print("\nNo messages were sent to both DUT and Reference Model\n")

            elif not self.dut_list:
                print("\nThe DUT Is Missing An Item\n")


if __name__ == '__main__':
    # Add unit-test if possible
    pass
