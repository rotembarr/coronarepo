###########################################################################################
#     __     __                _    __   _                  _     _                     ###
#     \ \   / /   ___   _ __  (_)  / _| (_)   ___    __ _  | |_  (_)   ___    _ __      ###
#      \ \ / /   / _ \ | '__| | | | |_  | |  / __|  / _` | | __| | |  / _ \  | '_ \     ###
#       \ V /   |  __/ | |    | | |  _| | | | (__  | (_| | | |_  | | | (_) | | | | |    ###
#        \_/     \___| |_|    |_| |_|   |_|  \___|  \__,_|  \__| |_|  \___/  |_| |_|    ###
###########################################################################################
#                                                                                       ###
# The Environment contains all the components of the verification environment and     ###
# all the connection between them.                                                    ###
###########################################################################################

from sequence import Sequence
from dut import DUT
from reference_model import ReferenceModel
from scoreboard import Scoreboard


class Environment:
    def __init__(self):
        self.sequence = Sequence()
        self.dut = DUT(self.sequence)
        self.reference_model = ReferenceModel(self.sequence)
        self.scoreboard = Scoreboard(self.dut, self.reference_model)

        self.run_test()

    def run_test(self):
        self.scoreboard.run()


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
