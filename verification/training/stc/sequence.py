import package
import random


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

        if package.is_true_by_percentage(package.FULL_PERCENTAGE / 5, package.FULL_PERCENTAGE):
            word = random.choice(package.SYNCS['sync'])
        else:
            word = '{:0{}X}'.format(random.getrandbits(package.BUS_WIDTH_IN), package.BUS_WIDTH_IN)
        return word
