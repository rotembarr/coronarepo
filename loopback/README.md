# This folder is for the loopback project

## Purpose
The purpose of this project is to test our capabilities at home to send packets to the FPGA and receive them.</br>
This will be the base for two other projects: AES acceleration, TCP/IP management. 

## Qsys
Which contains:
- Jtag to avalon-mm
- Triple speed Ethernet MAC (requires license, therefore each PNR will create a limited time SOF)
- Avalon-st FIFO
- Avalon-mm bridge (for other usages)

## Registers controller
Currently only has a message counter and a useless register to test `read/write`.