////////////////////////////////////////////////////////////////////////////////
//
// File name    : key_warm.sv
// Date Created : 18

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: The module for warming the key for the AES rounds
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

// Remove 1 clk, fit to encryptor changes

module key_warm
(
	// General
	input logic clk,
	input logic rst,

	// Inputs
	input aes_model_pack::byte_table key,
	input logic warm_key,

	// Outputs
	output aes_model_pack::byte_table key_round
);

	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// Next key block
	aes_model_pack::byte_table new_key;

	// Selects between initial round and the next key
	aes_model_pack::byte_table key_mux;

	// Shift the first column
	logic [aes_model_pack::COLUMN_SIZE_IN_BYTES-1:0][$bits(byte)-1:0] column_shift;

	// The first column through sbox
	logic [aes_model_pack::COLUMN_SIZE_IN_BYTES-1:0][$bits(byte)-1:0] sub_column;

	// The new key first column
	logic [aes_model_pack::COLUMN_SIZE_IN_BYTES-1:0][$bits(byte)-1:0] new_key_start;

	// The rcon register
	logic [aes_model_pack::ROUND_COUNT-1:0][aes_model_pack::COLUMN_SIZE_IN_BYTES-1:0][$bits(byte)-1:0] rcon_reg;



	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// Shift the first key column
	assign column_shift = {key_mux[0][aes_model_pack::COLUMN_SIZE_IN_BYTES-2:0], key_mux[0][aes_model_pack::COLUMN_SIZE_IN_BYTES-1]};

	// Shifted column through sbox
	always_comb begin : proc_sub_byte
		for (int i = 0; i < aes_model_pack::COLUMN_SIZE_IN_BYTES; i++) begin
			sub_column[i] = aes_model_pack::SUB_BYTES_TABLE[column_shift[i]];
		end
	end

	// The calculation for the new key start
	// Selects between the current to the next rcon in order to remove on clk
	assign new_key_start = key_mux[aes_model_pack::COLUMN_COUNT-1] ^ sub_column ^ ((warm_key) ? rcon_reg[1] : rcon_reg[0]);

	// Rcon register shift process
	always_ff @(posedge clk or negedge rst) begin : proc_shift_rcon
		if(~rst) begin
			rcon_reg <= aes_model_pack::RCON_TABLE;
		end else begin

			// if a reset key or warm key signals were given, it shifts the rcon reg
			if (warm_key) begin
				rcon_reg <= {rcon_reg[0], rcon_reg[aes_model_pack::ROUND_COUNT-1:1]};
			end
		end
	end

	// The key mux selects the initial key or the key that passed through the warming
	assign key_mux 	= (warm_key) ? key_round : key;
	
	// Warm key sample and changes the output when enabled
	always_ff @(posedge clk or negedge rst) begin : proc_key_round
		if(~rst) begin
			key_round <= 0;
		end else begin
			key_round <= new_key;
		end
	end

	// Creates the new key columns
	genvar i;
	generate
		for (i = 0; i < aes_model_pack::COLUMN_COUNT; i++) begin : gen_new_key_columns

			// The first column is saved immediatly as the first column
			if(i == aes_model_pack::COLUMN_COUNT - 1) begin
				assign new_key[i] = new_key_start;

			// Every other column depends on the prevoius column and the previous key
			end else begin
				assign new_key[i] = new_key[i+1] ^ key_mux[i];
			end
		end
	endgenerate
endmodule