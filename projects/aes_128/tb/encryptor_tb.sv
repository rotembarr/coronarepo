////////////////////////////////////////////////////////////////////////////////
//
// File name    : encryptor_tb.sv
// Date Created : 18

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: Testbench for encryptor
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module encryptor_tb();
	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////



	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	logic clk = 1'b0;
	logic rst = 1'b0;

	aes_model_pack::byte_table sync = 'h3243f6a8885a308d313198a2e0370734;
	aes_model_pack::byte_table key = 'h2b7e151628aed2a6abf7158809cf4f3c;
	aes_model_pack::byte_table key_round;

	logic new_sync_req = 1'b0;

	logic warm_key;

	logic cipher_block_vld;
	aes_model_pack::byte_table cipher_block;

	logic key_and_sync_vld = 0;

	key_warm key_warmer (
		.clk(clk),
		.rst(rst),
		.key(key),
		.warm_key(warm_key),
		.key_round(key_round)
	);

	encryptor dut (
		.clk(clk),
		.rst(rst),
		.sync(sync),
		.key_round(key_round),
		.new_sync_req(new_sync_req),
		.warm_key(warm_key),
		.cipher_block_vld(cipher_block_vld),
		.cipher_block(cipher_block),
		.key_and_sync_vld(key_and_sync_vld),
		.key(key)
	);

	always begin
		#aes_model_pack::CLK_FREQ clk = ~clk;
	end

	initial begin
		rst = 1'b0;
		#20ns;
		@(posedge clk);
		rst = 1'b1;
		@(posedge clk);
		key_and_sync_vld = 1'b1;
		@(posedge clk);
		key_and_sync_vld = 1'b0;
		#300ns;
		$finish();
	end

endmodule