////////////////////////////////////////////////////////////////////////////////
//
// File name    : aes_counter_mode.sv
// Date Created : 18

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: AES counter mode top
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module aes_counter_mode
(
	// General
	input logic 			clk,
	input logic 			rst,

	// Input and output streams
	avalon_st_if.slave 		msg_in_st,
	avalon_st_if.master 	msg_out_st,

	dvr_if.slave 			key_and_sync_in,

	// Errors
	output logic 			sync_overlapse_irq
);
	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// Signals the module needs a new key and sync
	logic key_and_sync_req;

	// Signals the sync needs to be raised by one
	logic new_sync_req;

	aes_model_pack::byte_table key, sync;
	logic key_and_sync_vld;

	key_and_sync_control key_and_sync_control_inst (
		.clk               (clk               ),
		.rst               (rst               ),

		.key_and_sync_in   (key_and_sync_in   ),	// DVR slave [2*BLOCK]

		.key_and_sync_req  (key_and_sync_req  ),	// Input [logic]
		.new_sync_req      (new_sync_req      ),	// Input [logic]

		.key               (key               ),	// Output [logic BLOCK] 
		.sync              (sync              ),	// Output [logic BLOCK]
		.key_and_sync_vld  (key_and_sync_vld  ),	// Output [logic]
		.sync_overlapse_irq(sync_overlapse_irq) 	// Output [logic]
	);

	aes_block aes_block_inst (
		.clk             (clk             ),
		.rst             (rst             ),

		.msg_in_st       (msg_in_st       ),	// Avalon st slave
		.msg_out_st      (msg_out_st      ),	// Avalon st master

		.key_and_sync_vld(key_and_sync_vld),	// Input [logic]
		.key             (key             ),	// Input [logic BLOCK]
		.sync            (sync            ),	// Input [logic BLOCK]

		.new_sync_req    (new_sync_req    ), 	// Output [logic]
		.key_and_sync_req(key_and_sync_req) 	// Output [logic]
	);

endmodule