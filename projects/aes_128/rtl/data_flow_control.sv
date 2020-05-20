////////////////////////////////////////////////////////////////////////////////
//
// File name    : data_flow_control.sv
// Date Created : 15

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: The module for controlling the avalon streams ready and valids,
//				sending key requests and new sync requests for the messages.
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/////// Revisions //////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Fix this module's ifs, and rdy for one clk too long

module data_flow_control
(
	// General
	input logic 			clk,
	input logic 			rst,

	// Input and output streams
	avalon_st_if.slave 		msg_in_st,
	avalon_st_if.master 	msg_out_st,

	// Inputs and outputs
	input logic 						key_and_sync_vld,
	input logic 						cipher_block_vld,
	input aes_model_pack::byte_table 	cipher_block,

	output logic new_sync_req,
	output logic key_and_sync_req
);

	///////////////////////////////////////////////////////////////////////////
	/////// Imports ///////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	import aes_model_pack::*;

	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// Signals the message in is valid and ready
	logic msg_in_act;

	// Signals the message out is valid and ready
	logic msg_out_act;

	// Signals the current word is ready for encryption
	logic msg_prepared;

	// Signals the current cipher word is ready for encryption
	logic cipher_prepared;

	// Signals that both the cipher and the message are prepared
	logic final_data_prepared;

	// The data structures
	byte_table msg_in_data;
	byte_table cipher_block_data;
	byte_table msg_out_data;

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// Message out stream assignments
	assign msg_out_st.empty = {$bits(msg_out_st.empty){1'b0}};
	assign msg_out_st.data 	= msg_out_data;


	always_comb begin : proc_async_calcs

		// Signals the msg acts
		msg_in_act 			= msg_in_st.valid & msg_in_st.rdy;
		msg_out_act 		= msg_out_st.valid & msg_out_st.rdy;

		final_data_prepared = msg_prepared & cipher_prepared;

		// The module requests a new sync when the message hasn't ended
		new_sync_req 		= msg_out_act & ~msg_out_st.eop;
	end

	always_ff @(posedge clk or negedge rst) begin : proc_data_control
		if(~rst) begin
			cipher_prepared 	<= 1'b0;
			msg_prepared 		<= 1'b0;
			msg_in_st.rdy 		<= 1'b0; // The message in isn't ready until given a key and sync
			msg_out_st.sop 		<= 1'b0;
			msg_out_st.eop 		<= 1'b0;
			msg_prepared 		<= 1'b0;
			msg_out_st.valid 	<= 1'b0;
			key_and_sync_req 	<= 1'b1; // The module requires a key and sync before starting
			msg_in_data 		<= {$bits(byte_table){1'b0}};
			cipher_block_data 	<= {$bits(byte_table){1'b0}};
			msg_out_data 		<= {$bits(byte_table){1'b0}};
		end else begin

			// The module is ready for input if a key and sync were given pre-sop
			// or the module keeps going with the current ones
			if(key_and_sync_vld | new_sync_req) begin
				msg_in_st.rdy <= 1'b1;
			end

			// If data has been given, downs the rdy, and samples all the data
			if(msg_in_act) begin
				msg_in_st.rdy 	<= 1'b0;
				msg_out_st.sop 	<= msg_in_st.sop;
				msg_out_st.eop 	<= msg_in_st.eop;
				msg_in_data 	<= msg_in_st.data;
				msg_prepared 	<= 1'b1; // Signals the data is ready for usage
			end

			// If the cipher block is valid, samples it
			if(cipher_block_vld) begin
				cipher_block_data 	<= cipher_block;
				cipher_prepared 	<= 1'b1; // Signals the data is ready for usage
			end

			// If the data is prepared, samples it to output
			if(final_data_prepared) begin
				msg_out_data 		<= cipher_block_data ^ msg_in_data;
				msg_out_st.valid 	<= 1'b1;
			end

			// If a key and sync were given, downs the request
			if(key_and_sync_vld) begin
				key_and_sync_req <= 1'b0;
			end

			// If a message has been outputted, downs the data prepared and such
			if(msg_out_act) begin
				msg_prepared 		<= 1'b0;
				cipher_prepared 	<= 1'b0;
				msg_out_st.valid 	<= 1'b0;
				// If the message has ended, requests new sync and key
				if(msg_out_st.eop) begin
					key_and_sync_req <= 1'b1;
				end
			end
		end
	end
endmodule