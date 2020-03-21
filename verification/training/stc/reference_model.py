class ReferenceModel:
    def __init__(self, sequence):
        self.sequence = sequence
        self.in_list = []

    def logic(self):

        # Gets the data from the sequence
        self.in_list = self.sequence.data_for_rm

        for value in self.in_list:
            print "rm"
            print value

        """
                TODO: All the logic of the Reference Model should be here
        """
        # Sends the the output to the scoreboard
        yield self.in_list