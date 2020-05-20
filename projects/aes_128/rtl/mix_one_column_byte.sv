////////////////////////////////////////////////////////////////////////////////
//
// File name    : nix_one_column_byte.sv
// Date Created : 12

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: This module calculates a single column byte according to the AES
// 				protocol, using a fixed matrix. Each column byte is calculated
//				through the multiplication of each column byte with a fixed matrix.
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: This module is part of the round process of AES
//
////////////////////////////////////////////////////////////////////////////////

module mix_one_column_byte
	(
		// Inputs and outputs
		// The byte to be multiplied by three according to the matrix
		input logic [$bits(byte)-1:0] byte_of_three,

		// The byte to be multiplied by two according to the matrix
		input logic [$bits(byte)-1:0] byte_of_two,

		// The bytes to be added as is
		input logic [1:0][$bits(byte)-1:0] bytes_of_one,

		// Calculation output
		output logic [$bits(byte)-1:0] mixed_column_byte
	);
	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	logic [$bits(byte)-1:0] norm_xor   ;
	logic [$bits(byte)-1:0] added_xor  ;
	logic msb_xor;
	logic [$bits(byte)-1:0] two_shifted  ;
	logic [$bits(byte)-1:0] three_shifted;

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	assign two_shifted = byte_of_two << 1;
	assign three_shifted = byte_of_three << 1;

	// Calculation of the single column byte in case both the byte of two and byte of three have the same msb
	assign norm_xor = two_shifted ^ byte_of_three ^ three_shifted ^ bytes_of_one[0] ^ bytes_of_one[1];

	// Calculation of the single column byte in case one msb of either byte of two or three is 1
	assign added_xor = aes_model_pack::MATH_ADDITIVE ^ two_shifted ^ byte_of_three ^ three_shifted ^ bytes_of_one[0] ^ bytes_of_one[1];

	// The sel for the mux between the two XOR outputs
	assign msb_xor = byte_of_three[$bits(byte)-1] ^ byte_of_two[$bits(byte)-1];

	// Output
	assign mixed_column_byte = (msb_xor) ? added_xor : norm_xor;

endmodule