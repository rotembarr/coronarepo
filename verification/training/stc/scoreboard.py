class Scoreboard:
    def __init__(self):
        self.dut_list = []
        self.rm_list = []

        self.run()

    def run(self):
        while True:

            # Wait until a msg is received in both lists
            yield self.dut_list and self.rm_list

            # TODO add implementation
            pass

