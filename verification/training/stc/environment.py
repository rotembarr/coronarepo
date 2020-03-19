from sequence import Sequence
from dut import DUT
from reference_model import ReferenceModel
from scoreboard import Scoreboard
from threading import Thread

class Environment:
    def __init__(self):
        self.scoreboard = Scoreboard()
        self.reference_model = ReferenceModel(self.scoreboard)
        self.dut = DUT(self.scoreboard)
        self.sequence = Sequence(self.dut,  self.reference_model)

        self.run_test()

    def run_test(self):

        print("Started simulation")
        Thread(target=self.sequence.run()).start()
        Thread(target=self.dut.logic()).start()
        Thread(target=self.reference_model.logic()).start()
        Thread(target= self.scoreboard.run()).start()
        print("Finished simulation")


if __name__ == '__main__':
    # import argparse
    # import random
    #
    # parser = argparse.ArgumentParser(description='Simulation of STC')
    # parser.add_argument('-s', '--seed', dest='i_seed', action='store',
    #                     help='Set the seed of the simulation.')
    #
    # args = parser.parse_args()
    #
    # seed = random.randint(1, 2 ** 8 - 1)
    #
    # if args.i_seed:
    #     seed = args.i_seed
    #
    # print("Simulation seed : ", seed)
    #
    # random.seed(seed)

    env = Environment()
