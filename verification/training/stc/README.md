# STC

The module has an 8 bit size input, and 1 bit sized output.

The module waits for a sync - a sequence of bits to be received.
Once a sync has been received, the input following the sync will be outputed, for a certain number of bits.
For each sync there is a matching size of payload.
