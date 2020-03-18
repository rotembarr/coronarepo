class Sequence:
    def __init__(self):
        self.dut_list = []
        self.rm_list = []

    def run(self, num_of_messages):
        for i in range(num_of_messages):
            # gen msg
            # TODO add implementation
            msg = ''
            self.dut_list.append(msg)
            self.rm_list.append(msg)

        print("Finished sequence")
