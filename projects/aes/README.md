# This folder is for the AES project

## Purpose
The purpose of this project is to test our capabilities at home to send packets to the FPGA and receive them.
The packets sent to the FPGA will be encrypted and sent back. 

## Qsys
Two QSYS systems:
- Jtag to avalon-mm
- Triple speed Ethernet MAC (1/2) (requires license, therefore each PNR will create a limited time SOF)
- Avalon-mm bridge (for other usages)
- Clock PLL

## Ethernet header handler
- Add/removes a constant header

## AES-128