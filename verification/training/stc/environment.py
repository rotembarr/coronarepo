from sequence import Sequence
from dut import DUT
from reference_model import ReferenceModel
from scoreboard import Scoreboard


class Environment:
    def __init__(self):
        self.sequence = Sequence()
        self.scoreboard = Scoreboard()
        self.reference_model = ReferenceModel(self.sequence.rm_list, self.scoreboard.rm_list)
        self.dut = DUT(self.sequence.dut_list, self.scoreboard.rm_list)

        # Set Scoreboard lists
        self.scoreboard.dut_list = self.dut.out_list
        self.scoreboard.rm_list = self.reference_model.out_list

    def run(self):

        self.sequence.run(num_of_messages=10)


if __name__ == '__main__':
    # TODO Handle args pars
    pass
    env = Environment()


