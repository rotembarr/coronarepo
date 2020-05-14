package aes_top_pack;

	// Registers addresses
	localparam int PERIPHERAL_ADDR 		= 'h1000; 	// The base for the peripheral addresses

	// MAC addresses for the output
	localparam int SOURCE_MAC_ADDR_1	= 'h0; 		// The MAC source part 1 [47:32]
	localparam int SOURCE_MAC_ADDR_2	= 'h4;		// The MAC source part 2 [31:0]

	localparam int DEST_MAC_ADDR_1 		= 'h8; 		// Same as the source
	localparam int DEST_MAC_ADDR_2		= 'hc;

	// Avalon MM parameters
	localparam int ADDRESS_SIZE 		= 32;
	localparam int REG_SIZE 			= 32;

	// Counter size
	localparam int WORD_COUNTER_SIZE 	= 8;

	// General
	localparam int AES_DATA_WIDTH 		= 128;

	// Mac
	localparam int MAC_ADDR_WIDTH	 	= 48;
	localparam int MAC_HEADER_WIDTH		= 128;
	localparam int MAC_ADDR_PAD 		= 16;
	localparam logic [15:0] ETH_TYPE  	= 16'h0800;

	localparam int IP_HEADER_WIDTH 		= 160;

	localparam int MAC_STREAM_WIDTH 	= 32; 		// DO NOT CHANGE, from the tse ip core 

endpackage