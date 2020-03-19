import package
import time


class Scoreboard:

    def __init__(self):
        self.dut_list = []
        self.rm_list = []
        self._msg_compared = 0

        # Starts the Main Function
        self.run()

    def run(self):

        # 1 minutes from now
        timeout = time.time() + package.MINUTE_IN_SECONDS

        try:
            while True:

                if self._msg_compared < package.NUM_OF_MSG - 1:

                    # Wait until a msg is received in both lists
                    if self.dut_list and self.rm_list:

                        # 1 minutes from now
                        timeout = time.time() + package.MINUTE_IN_SECONDS

                        # Gets the first item from the DUT queue
                        dut_item = self.dut_list.pop(0)

                        # Gets the first item from the RM queue
                        rm_item = self.rm_list.pop(0)

                        if dut_item == rm_item:
                            self._msg_compared += 1
                            print '\n############# Item No.{} Has Compared Successfully #############\n'.format(self._msg_compared)
                        else:
                            raise package.ComparisionFailed()

                    elif time.time() > timeout:
                        raise package.TimeoutOccurred()

                else:
                    break

            print '##############################################################\n'
            print '############# The Test Has Finished Successfully #############\n'
            print '##############################################################\n'

        except package.ComparisionFailed:

            print '\n############# Item No.{} Comparison Has Failed #############\n'.format(self._msg_compared)
            print '\n############# DUT ITEM #############\n'
            print dut_item
            print '\n############# REFERENCE MODEL ITEM #############\n'
            print rm_item

        except package.TimeoutOccurred:

            print "\nThe Timeout Reached His Limit\n"

            if (not self.dut_list) and not (self.rm_list):
                print "\nNo messages were sent to both DUT and Reference Model\n"

            elif not self.dut_list:
                print "\nThe DUT Is Missing An Item\n"

            elif not self.rm_list:
                print "\nThe Reference Model Is Missing An Item\n"