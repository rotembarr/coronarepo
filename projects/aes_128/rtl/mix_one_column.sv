////////////////////////////////////////////////////////////////////////////////
//
// File name    : mix_one_column.sv
// Date Created : 12

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: This module mixes one column, 4 bytes of data according to the
// 				fixed matrix in the AES protocol.
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: This module doesn't have any logic on it's own, only splits the data
// 			 into four instantiations of the mix one column byte, when each time
//			 each byte is in a different role in the calculation.
//
////////////////////////////////////////////////////////////////////////////////

module mix_one_column
(
	// Inputs and outputs
	// The column to be calculated
	input logic [aes_model_pack::COLUMN_SIZE_IN_BYTES-1:0][$bits(byte)-1:0] column,

	// The output column
	output logic [aes_model_pack::COLUMN_SIZE_IN_BYTES-1:0][$bits(byte)-1:0] mixed_column

);

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	genvar i;
	// generate for function which creates a mixed_column_byte calculation module
	// for each byte in the column
	generate
		for (i = 0; i < aes_model_pack::COLUMN_SIZE_IN_BYTES; i++) begin : one_column_calc

			mix_one_column_byte mocb_inst(
				.byte_of_two	  (column[i]),
				.byte_of_three	  (column[(i+3)%aes_model_pack::COLUMN_SIZE_IN_BYTES]),
				.bytes_of_one  ({column[(i+2)%aes_model_pack::COLUMN_SIZE_IN_BYTES],column[(i+1)%aes_model_pack::COLUMN_SIZE_IN_BYTES]}),
				.mixed_column_byte(mixed_column[i])
			);
			
		end
	endgenerate
endmodule