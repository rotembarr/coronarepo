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

## Directions
### Configuring the MAC
Open system console in the debugging tools in quartus, and execute the tcl script in the system_console_tcl.  
If there is one MAC, use only net_mac_config, otherwise use both.

### Setting up the PC
In order to send messages to the PC, the ARP table must be configured to contain the destination MAC address with a fabricated IP address.  
Firstly, open the command line, and type `netsh interface show interface`. This command will show all the active network interfaces.  
After viewing the interfaces, and finding the one connected to the FPGA, you need to set a new connection.  
`netsh interface ip add neighbors "interface" "fabricated ip" "FPGA MAC address"`