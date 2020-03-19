class ReferenceModel:
    def __init__(self, scoreboard):
        self.scoreboard = scoreboard
        self.in_list = []

    def logic(self):
        """
            TODO: All the logic of the Reference Model should be in the for loop
        """
        for x in self.in_list:
            self.scoreboard.add_rm_word(x)

        # Gets a word from the sequence

    def append_word(self, word):
        self.in_list.append(word)
