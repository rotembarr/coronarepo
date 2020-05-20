# ------------------ Constants & Defines ----------------- #

# Search for JTAG<->Avalon-MM masters, and get the first one
set JTAG_MASTER [lindex [get_service_paths master] 0];

set MAC_NET_BASE_ADDR 0x000;
set MAC_PC_BASE_ADDR  0x400;

# MAC configuration addresses
set REV_ADDRESS 				0x000;
set MAC_SCRATCH_ADDRESS 		0x004;
set COMMAND_CONFIG_ADDRESS		0x008;
set MAC_0_ADDRESS 				0x00C;
set MAC_1_ADDRESS 				0x010;
set FRM_LENGTH_ADDRESS 			0x014;
set PAUSE_QUANT_ADDRESS 		0x018;
set RX_SECTION_EMPTY_ADDRESS	0x01C;
set RX_SECTION_FULL_ADDRESS 	0x020;
set TX_SECTION_EMPTY_ADDRESS 	0x024;
set TX_SECTION_FULL_ADDRESS 	0x028;
set RX_ALMOST_EMPTY_ADDRESS 	0x02C;
set RX_ALMOST_FULL_ADDRESS 		0x030;
set TX_ALMOST_EMPTY_ADDRESS 	0x034;
set TX_ALMOST_FULL_ADDRESS 		0x038;
set MDIO_ADDR0_ADDRESS 			0x03C;
set MDIO_ADDR1_ADDRESS 			0x040;
set REG_STATUS_ADDRESS 			0x040;
set TX_IPG_LENGTH_ADDRESS 		0x05C;

set LINK_TIMER_ADDRESS			[expr (0x12+0x80)*4];
set LLINK_TIMER_ADDRESS			[expr (0x13+0x80)*4];
set IF_MODE_ADDRESS				0x250;
set PCS_CTRL_REGISTER_ADDRESS	[expr 0x80*4];

set LINK_TIMER			0x0D40;
set LLINK_TIMER			0x0003;
set IF_MODE				[expr {0b10<<2 | 1<<1 | 1<<0}];
set PCS_CTRL_REG		0x1140;
set PCS_CTRL_REG_RST	0x9140;

# MAC command addresses
set TX_CMD_STAT_ADDRESS 0x0E8;
set RX_CMD_STAT_ADDRESS 0x0EC;

# MAC configuration data
set MAC_0					0x17241C00;	# MAC Address is 00-1C-24-17-4A-CB
set MAC_1					0x0000CB4A;
set PHY_MDIO_ADDR_ARR(0)	0x00000000; # PHY 1 MDIO Address
set PHY_MDIO_ADDR_ARR(1)	0x00000000; # PHY 2 MDIO Address
# set PHY_MDIO_ADDR_ARR(2)	0x0000000E; # PHY 3 MDIO Address
set COMMAND_CONFIG_INIT		0x00000218;
set COMMAND_CONFIG			0x0000021B;	# Enable TX & RX, Promiscuous mode enabled, 1Gbps,
										# MAC address overwrite.
# SFP addresses
set SFP_I2C_EEPROM_ADDRESS		[expr 0xA0>>1];
set SFP_I2C_DIAGNOSTIC_ADDRESS	[expr 0xA2>>1];
set SPF_EEPROM_ID_ADDRESS		0x00;
set SFP_EEPROM_CON_ADDRESS		0x02;

# -------------------------------------------------------- #

# ------------------- Helper Functions ------------------- #

# Converts between a PHY MDIO address to a MAC MDIO Space 1 address
proc phy_addr_to_mac_addr {addr} {
	expr {[expr {$addr + 0xA0}] * 4};
}

# Read from the PHY Space 1
# Parameters:
#	addr - A register address number in the PHY (0 to 31)
# Returns:
#	A 32 bit number
proc phy1_read_32 {addr} {
	global JTAG_MASTER;
	master_read_32 $JTAG_MASTER [phy_addr_to_mac_addr $addr] 1;
}

# Write to the PHY Space 1
# Parameters:
#	addr - A register address number in the PHY (0 to 31)
#	data - 16 bit data to be written to the register
# Returns:
#	idk bro
proc phy1_write_32 {addr data} {
	global JTAG_MASTER;
	master_write_32 $JTAG_MASTER [phy_addr_to_mac_addr $addr] [expr {$data & 0x0000FFFF}];
}

# Write to the PHY Space 1, with a data mask
# Parameters:
#	addr - A register address number in the PHY (0 to 31)
#	data - 16 bit data to be written to the register
#	mask - Masks $data into the register.
#			If the mask is 0xFFFF, then the entire register is overwritten with $data.
#			If the mask is 0xFF00, then the first two MSBs of data are written,
#			and the last two LSBs in the register remain as they were.
# Returns:
#	idk bro
proc phy1_write_mask_32 {addr data mask} {
	global JTAG_MASTER;
	set current		[phy1_read_32 $addr];
	set data_masked	[expr {(($current & (~$mask)) | ($data & $mask)) & 0x0000FFFF}];
	master_write_32 $JTAG_MASTER [phy_addr_to_mac_addr $addr] $data_masked;
}

#		proc sfp_read_i2c {i2c_addr, reg_addr} {
#			phy1_write_32 22 4; # Page 4
#			
#			set twi_status [phy1_read_32 17]; # Read status
#			for {set n 0} {$n < 100} {incr n} {
#				if {$twi_status != 0b010} {
#					phy1_write_32 16 [expr {($i2c_addr<<9) | (1<<8) | ($reg_addr&0xFF)}]; # Write a read command
#					set n 200;
#			}
#			set twi_status [phy1_read_32 17];
#		} # Wait until the bus is free, and then read from it
#		
#		if {n == 200} {
#			for {set n 0} {$n < 100} {incr n} {
#				set twi_status [phy1_read_32 17];
#				if {$twi_status == 0b001} {
#					set n 200;
#				}
#			}
#		} # If the last timeout didn't time-out, that means the read operation was successful
#		
#		if {n == 200} {
#			expr {([phy1_read_32 17]) & 0xFF};
#		}
#		else {
#			expr {0xFFFF}; # Return 0xFFFF on error
#		}
#	}

# -------------------------------------------------------- #

# ---------------------- Main Code ----------------------- #

# Open the service
if {[is_service_open master $JTAG_MASTER] == 0} {
	open_service master $JTAG_MASTER;
}

# Configure the MAC
master_write_32 $JTAG_MASTER $MAC_0_ADDRESS				$MAC_0;
master_write_32 $JTAG_MASTER $MAC_1_ADDRESS				$MAC_1;
master_write_32 $JTAG_MASTER $MDIO_ADDR1_ADDRESS		$PHY_MDIO_ADDR_ARR(0);
# PCS Configuration
#master_write_32 $JTAG_MASTER $LINK_TIMER_ADDRESS		$LINK_TIMER
#master_write_32 $JTAG_MASTER $LLINK_TIMER_ADDRESS		$LLINK_TIMER
master_write_32 $JTAG_MASTER $IF_MODE_ADDRESS			$IF_MODE;
master_write_32 $JTAG_MASTER $PCS_CTRL_REGISTER_ADDRESS $PCS_CTRL_REG;
master_write_32 $JTAG_MASTER $PCS_CTRL_REGISTER_ADDRESS $PCS_CTRL_REG_RST;

# PHY configuration
#for {set n 0} {$n < 2} {incr n} {
	master_write_32 $JTAG_MASTER $MDIO_ADDR1_ADDRESS	$PHY_MDIO_ADDR_ARR(0);
	#					REG|DATA			|MASK									|Comment
	#----------------------|----------------|---------------------------------------|----------------
	phy1_write_32		22	0x0003; 												# Access page 3
	phy1_write_32		16	0x5340; 												# LED Configure (LOS - On when transmit, INIT - Blink when activity, STS1 - Blink when activity, STS0 - On when link )
	phy1_write_mask_32	18	[expr 0b011<<8] [expr 0b111<<8];						# LED Blink rate
	phy1_write_32		17	0x44aa;													# LOS/INIT LED Polarity
	
	#phy1_write_32		22	0x0001;													# Access page 1
	#phy1_write_mask_32	16	[expr 1<<9]		[expr 1<<9];							# SIGDET Polarity
	
	phy1_write_32		22	0x0002; 												# Access page 2
	phy1_write_mask_32	16	0x0A80			[expr {0b11<<10 | 0b111<<7}];			# Device operation (1000BASE-T)
	
	phy1_write_mask_32	0	[expr 1<<15]	[expr 1<<15];							# PHY Software Reset
	
	#phy1_write_mask_32	0	[expr {1<<14}]	[expr {1<<14}];							# Enable loopback on the fiber interface
#}

# Reselect PHY 1 (the first PHY)
#master_write_32 $JTAG_MASTER $MDIO_ADDR1_ADDRESS	$PHY_MDIO_ADDR_ARR(0);

# Last MAC Configuration
# This enables the TX/RX, and does some other configurations
master_write_32 $JTAG_MASTER $COMMAND_CONFIG_ADDRESS	$COMMAND_CONFIG;

# We're done, close the service
close_service master $JTAG_MASTER;

# -------------------------------------------------------- #
