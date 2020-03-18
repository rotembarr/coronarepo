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

        self.run()

    def run(self):

        self.sequence.run(num_of_messages=10)


if __name__ == '__main__':
    import argparse
    import random

    parser = argparse.ArgumentParser(description='Simulation of STC')
    parser.add_argument('-s', '--seed', dest='i_seed', action='store',
                        help='Set the seed of the simulation.')

    args = parser.parse_args()

    seed = random.randint(1, 2**8 - 1)

    if args.i_seed:
        seed = args.i_seed

    print("Simulation seed : ", seed)

    random.seed(seed)

    env = Environment()


