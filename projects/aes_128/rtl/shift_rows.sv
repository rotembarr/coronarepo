////////////////////////////////////////////////////////////////////////////////
//
// File name    : shift_rows.sv
// Date Created : 14

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: Shift rows module
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module shift_rows
(
	// Inputs and outputs
	input aes_model_pack::byte_table state,
	output aes_model_pack::byte_table shift_block
);
	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	aes_model_pack::byte_table to_rows, shift_block_rows;

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	always_comb begin : proc_change_to_rows
		for (int i = 0; i < aes_model_pack::COLUMN_COUNT; i++) begin
			for (int j = 0; j < aes_model_pack::COLUMN_SIZE_IN_BYTES; j++) begin
				to_rows[j][i] = state[i][j];
			end
		end
	end

	always_comb begin : proc_shift
		for (int i = 0; i < aes_model_pack::COLUMN_COUNT; i++) begin
			for (int j = 0; j < aes_model_pack::COLUMN_SIZE_IN_BYTES; j++) begin
				shift_block_rows[aes_model_pack::COLUMN_COUNT-i-1][j] = to_rows[aes_model_pack::COLUMN_COUNT-i-1][(j+aes_model_pack::COLUMN_COUNT-i)%aes_model_pack::COLUMN_COUNT];	
			end
		end
	end

	always_comb begin : proc_change_to_columns
		for (int i = 0; i < aes_model_pack::COLUMN_COUNT; i++) begin
			for (int j = 0; j < aes_model_pack::COLUMN_SIZE_IN_BYTES; j++) begin
				shift_block[j][i] = shift_block_rows[i][j];
			end
		end
	end
endmodule // shift_rows