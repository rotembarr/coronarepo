from time import sleep


class DUT:
    def __init__(self, in_list, out_list):
        self.in_list = in_list
        self.out_list = out_list
        self.run()

    def run(self):
        while True:

            # Wait until a msg is received in the input list
            if self.in_list:

                # TODO add implementation
                pass

            sleep(1)


