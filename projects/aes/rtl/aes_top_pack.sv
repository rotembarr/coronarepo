package aes_top_pack;

	// Registers addresses
	localparam int PERIPHERAL_ADDR 		= 'h1000; 	// The base for the peripheral addresses
	localparam int MSG_WORD_CNT 		= 'h0; 		// For the word generator
	localparam int ADDER_WORD_CNT		= 'h4;		// The word generator adder output
	localparam int REMOVER_WORD_CNT 	= 'h8;		// The word generator remover output

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