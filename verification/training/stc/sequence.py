from package import *


class Sequence:
    def __init__(self, dut, rm):
        self.dut = dut
        self.rm = rm

    def run(self):
        print("Seq")
        for i in range(NUM_OF_MSG):
            msg = self.gen_msg()
            yield self.driver(msg)
        print("Finished sequence")

    def gen_msg(self):
        """
        Generate a msg to be send to the DUT.

        :return: TODO
        """
        print("Gen msg")
        msg = [1, 2, 3]

        return msg

    def driver(self, msg):
        """

        :param msg: The msg we wish to send (Type is undefined)

        Split the msg into words and send it to the DUT and RM
        """

        # Debug
        for word in msg:
            self.dut.append_word(word)
            self.rm.append_word(word)

