////////////////////////////////////////////////////////////////////////////////
//
// File name    : aes_block.sv
// Date Created : 18

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: The main module for controlling the data, input and output
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module aes_block
(
	// General
	input logic 			clk,
	input logic 			rst,

	// Input and output streams
	avalon_st_if.slave 		msg_in_st,
	avalon_st_if.master 	msg_out_st,

	// Inputs
	input logic 						key_and_sync_vld,
	input aes_model_pack::byte_table 	key,
	input aes_model_pack::byte_table 	sync,

	// Outputs
	output logic 	new_sync_req,
	output logic 	key_and_sync_req
);
	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// Key warm control signals
	logic warm_key;

	aes_model_pack::byte_table key_round;

	aes_model_pack::byte_table cipher_block;
	logic cipher_block_vld;

	key_warm key_warm_inst (
		.clk      (clk      ),
		.rst      (rst      ),
		
		.key      (key      ), // Input [logic BLOCK]
		.warm_key (warm_key ), // Input [logic]
		
		.key_round(key_round)  // Output [logic BLOCK]
	);

	encryptor encryptor_inst (
		.clk             (clk             ),
		.rst             (rst             ),

		.sync            (sync            ),	// Input [logic BLOCK]
		.key_round       (key_round       ),	// Input [logic BLOCK]
		.key             (key             ),	// Input [logic BLOCK]
		.new_sync_req    (new_sync_req    ),	// Input [logic] 
		.key_and_sync_vld(key_and_sync_vld),	// Input [logic]

		.warm_key        (warm_key        ), 	// Output [logic]
		.cipher_block_vld(cipher_block_vld), 	// Output [logic]
		.cipher_block    (cipher_block    ) 	// Output [logic BLOCK]
	);

	data_flow_control data_flow_control_inst (
		.clk             (clk             ),
		.rst             (rst             ),

		.msg_in_st       (msg_in_st       ),	// Avalon st slave 	[BLOCK]
		.msg_out_st      (msg_out_st      ),	// Avalon st master [BLOCK]

		.key_and_sync_vld(key_and_sync_vld),	// Input [logic]
		.cipher_block_vld(cipher_block_vld),	// Input [logic]
		.cipher_block    (cipher_block    ),	// Input [logic BLOCK]

		.new_sync_req    (new_sync_req    ), 	// Output [logic]
		.key_and_sync_req(key_and_sync_req) 	// Output [logic]
	);
endmodule // aes_block