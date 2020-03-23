# STC

The module has an 8 bit size input, and 8 bit sized output.

The module waits for a sync - a sequence of chars to be received.
Every sync has a payload, the payload is an Integer which indicates on the number of outputs
the module have to drive.
Once a sync has been received, the input following the sync will be outputed, for the number of the payload.
For each sync there is a matching size of payload.

NOTE:
Your Python version should be 3.6.10 or greater