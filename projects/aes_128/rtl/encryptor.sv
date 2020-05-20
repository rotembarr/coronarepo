////////////////////////////////////////////////////////////////////////////////
//
// File name    : encryptor.sv
// Date Created : 14

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: Main encryption module
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/////// Revisions //////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


// Fix to this module, as it doesn't work on board, problem with cipher block valid

module encryptor
(
	// General
	input logic 						clk,
	input logic 						rst,

	// Inputs
	input aes_model_pack::byte_table 	sync,
	input aes_model_pack::byte_table 	key_round,
	input logic 					 	key_and_sync_vld,
	input logic 					 	new_sync_req,
	input aes_model_pack::byte_table 	key,

	// Outputs
	output logic 					  	warm_key,
	output logic 					  	cipher_block_vld,
	output aes_model_pack::byte_table 	cipher_block
);

	///////////////////////////////////////////////////////////////////////////
	/////// Imports ///////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	import aes_model_pack::*;

	typedef enum int {
		LIMIT,
		FULL,
		NEAR_FULL
	} cntr_fill_levels_e;

	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// The initial round block, equals to the sync and key XOR
	byte_table initial_round;
	byte_table initial_round_s;

	// The round calculation selection, between the previous round to the initial
	byte_table round_sel;

	// Round calculation output, and it's sample
	byte_table round_block;
	byte_table round_block_s;
	
	// Counter counts the round process
	logic [SIZE_OF_COUNTER-1:0] aes_rounds_cntr;
	// Counter first round flag (0)
	logic 						aes_first_round_flag;
	// Counter active flag
	logic 						aes_cntr_act_flag;
	// Counter last round flag (LIMIT-1)
	logic 						aes_last_round_flag;

	///////////////////////////////////////////////////////////////////////////
	/////// Instantiations ////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	round_cipher round_cipher_inst(
		.state(round_sel),
		.round_key(key_round),
		.last_round(aes_last_round_flag),
		.cipher_state(round_block)
	);

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// The key warms while the counter is active
	assign warm_key 		= aes_cntr_act_flag;

	always_ff @(posedge clk or negedge rst) begin : proc_cntr_control
		if(~rst) begin
			// The cntr resets to be at the limit, to not show the first round
			aes_rounds_cntr 		<= ROUND_COUNT;
			aes_first_round_flag 	<= 1'b0;
			aes_cntr_act_flag 		<= 1'b0;
			aes_last_round_flag 	<= 1'b0;
			initial_round_s 		<= {$bits(byte_table){1'b0}};
			round_block_s 			<= {$bits(byte_table){1'b0}};
			cipher_block 			<= {$bits(byte_table){1'b0}};
			cipher_block_vld 		<= 1'b0;
		end else begin
			if(aes_rounds_cntr < ROUND_COUNT) begin

				// Continuosly raises the counter
				aes_rounds_cntr <= aes_rounds_cntr + 1;

				// Drops the flag at the first clock after the start
				aes_first_round_flag <= 1'b0;

				// If one last round remains, raises the flag
				if(aes_rounds_cntr == ROUND_COUNT - NEAR_FULL) begin
					aes_last_round_flag <= 1'b1;
				end

				// Signals the counter ended
				if(aes_rounds_cntr == ROUND_COUNT - FULL) begin
					aes_last_round_flag <= 1'b0;
					aes_cntr_act_flag 	<= 1'b0;
					// The cipher block is valid when the rounds have ended
					cipher_block_vld 	<= 1'b1;
					// Samples the data to output
					cipher_block 		<= round_block;
				end
			end else begin

				// If at limit, resets all flags
				aes_first_round_flag 	<= 1'b0;
				aes_cntr_act_flag 		<= 1'b0;
				aes_last_round_flag 	<= 1'b0;
				cipher_block_vld 		<= 1'b0;

				// If a new key and sync were given, restarts the encryption
				if(key_and_sync_vld | new_sync_req) begin
					aes_rounds_cntr 		<= {SIZE_OF_COUNTER{1'b0}};
					aes_first_round_flag 	<= 1'b1;
					aes_cntr_act_flag 		<= 1'b1;
					// Samples the data in order to prevent timing problems
					initial_round_s 		<= initial_round;
				end
			end
			round_block_s <= round_block;
		end
	end

	always_comb begin : proc_async_calcs

		initial_round = key ^ sync;

		// Selects between the initial round and the round, according to the flag
		round_sel = (aes_first_round_flag) ? initial_round_s : round_block_s;
	end
endmodule