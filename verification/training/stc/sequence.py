import package
import random


class Sequence:
    def __init__(self, dut, rm):
        self.dut = dut
        self.rm = rm

    def run(self):

        for i in range(package.NUM_OF_MSG):
            self.gen_sync()

    def gen_sync(self):
        """
        The function generate each time whole sync,
        Sometimes correct and sometimes wrong.
        """

        # Generate correct sync
        if package.is_true_by_percentage(package.FULL_PERCENTAGE / 5):
            # TODO: generate good sync
            # Choice random correct sync from the list of all the correct syncs.
            sync = random.choice(package.SYNCS)['sync']

        # Generate random sync
        elif package.is_true_by_percentage(package.FULL_PERCENTAGE / 2):
            # TODO: Need to decide the size of the wrong sync (can be few sizes)
            # Padding the random sync with format of HEX according to TBD size.
            sync = '{:0{}X}'.format(random.getrandbits(package.SYNC_SIZE), package.SYNC_SIZE // package.NIBBLE_SIZE)

        # Generate wrong sync (similar to the correct)
        else:
            # Choice random correct sync from the list of all the correct syncs.
            sync = random.choice(package.SYNCS)['sync']

            # Random number that indicate how much nibbles we will change from the original.
            num_of_nibble_to_change = random.randrange(1, len(sync))

            # List with all the index of the nibbles in the current sync.
            nibbles_idx_list = [idx for idx in range(len(sync))]

            # Convert sync to a list of nibbles
            sync = [char for char in sync]

            # Change nibbles
            for idx in range(num_of_nibble_to_change):
                # Choice random nibble to change and deleted from the list so it will not be re-selected.
                nibble_idx = random.choice(nibbles_idx_list)
                nibbles_idx_list.remove(nibble_idx)
                # Change the selected nibble with XOR on 1. TODO not working
                val = sync[nibble_idx]
                sync[nibble_idx] = ''
                sync[nibble_idx] = '{:X}'.format(int(val, 16) ^ 1)

            # Convert sync back to a string
            sync = "".join(sync)

        # Sent the sync to DUT and RM.
        self.sent_sync_by_words(sync)

    def sent_sync_by_words(self, sync):
        """
        Received all the sync in str and insert to list according words.
        :param sync: The sync that we need sent to DUT and RM.
        :return: None, added to lists the sync.
        """
        word_size = package.BUS_WIDTH_IN // package.NIBBLE_SIZE
        # Cut the sync_str to list of words
        sync_by_words = [sync[idx:idx + word_size] for idx in range(0, len(sync), word_size)]

        # Run on all the words in the list(sync) and append to dut and rm lists.
        for word in sync_by_words:
            self.dut.append_word(word)
            self.rm.append_word(word)
