package aes_top_pack;

	// Registers addresses
	localparam int PERIPHERAL_ADDR 		= 'h1000; 	// The base for the peripheral addresses
	localparam int FIRST_HEADER_ADDR	= 'h0; 		// The ip header first word
	localparam int LAST_HEADER_ADDR		= 'h4;		// The ip header last word

	// Avalon MM parameters
	localparam int ADDRESS_SIZE 		= 32;
	localparam int REG_SIZE 			= 32;

	// Counter size
	localparam int WORD_COUNTER_SIZE 	= 8;

	// General
	localparam int AES_DATA_WIDTH 		= 128;
	localparam int IP_HEADER_WIDTH 		= 160;

	localparam int MAC_STREAM_WIDTH 	= 32; 		// DO NOT CHANGE, from the tse ip core 

endpackage