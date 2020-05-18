set JTAG_MASTER [lindex [get_service_paths master] 0];

set MAC_0_ADDRESS 				0x1000;
set MAC_1_ADDRESS 				0x1004;

set MAC_0					0x0000001C;	# MAC Address is 00-1C-24-17-4A-CB
set MAC_1					0x24174ACB;

open_service master $JTAG_MASTER;

master_write_32 $JTAG_MASTER $MAC_0_ADDRESS $MAC_0;
master_write_32 $JTAG_MASTER $MAC_1_ADDRESS $MAC_1;

close_service master $JTAG_MASTER;