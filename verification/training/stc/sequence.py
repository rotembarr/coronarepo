import package


class Sequence:
    def __init__(self, dut, rm):
        self.dut = dut
        self.rm = rm

    def run(self):

        for i in range(package.NUM_OF_MSG):
            word = self.gen_word()
            self.dut.append_word(word)
            self.rm.append_word(word)

    def gen_word(self):
        """
            TODO: Generate a msg to be send to the DUT.
        """
        return 10
