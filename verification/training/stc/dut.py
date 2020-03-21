class DUT:
    def __init__(self, sequence):
        self.sequence = sequence
        self.in_list = []

    def logic(self):
        # For every value that have been sent from the sequence
        for value in self.sequence.run():
            print "dut"
            print value
            """
                TODO: All the logic of the DUT should be here
            """

            # Sends the output tp the scoreboard
            yield value
