////////////////////////////////////////////////////////////////////////////////
//
// File name    : data_flow_control_tb.sv
// Date Created : 18

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: Data flow testbench
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module data_flow_control_tb();

	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	logic clk = 1'b0;
	logic rst = 1'b0;

	avalon_st_if msg_in_st(clk);
	avalon_st_if msg_out_st(clk);

	logic 					   key_and_sync_vld = 1'b0;
	logic 					   cipher_block_vld = 1'b0;
	aes_model_pack::byte_table cipher_block 	= 0;

	logic key_and_sync_req;
	logic new_sync_req;

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	data_flow_control dut(
		.clk             (clk),
		.rst             (rst),
		.msg_in_st       (msg_in_st),
		.msg_out_st      (msg_out_st),
		.key_and_sync_vld(key_and_sync_vld),
		.cipher_block_vld(cipher_block_vld),
		.cipher_block    (cipher_block),
		.new_sync_req    (new_sync_req),
		.key_and_sync_req(key_and_sync_req)
	);

	always begin
		#aes_model_pack::CLK_FREQ clk = ~clk;
	end

	initial	begin
		// Initial values
		msg_out_st.rdy = 1'b1;
		msg_in_st.sop = 1'b1;
		msg_in_st.eop = 1'b1;
		msg_in_st.empty = 0;
		msg_in_st.valid = 1'b0;
		msg_in_st.data = 128'd0;
		// rst stop
		#20ns;
		@(posedge clk);
		rst = 1'b1;

		// send key and sync vld
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		key_and_sync_vld = 1'b1;
	
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		key_and_sync_vld = 1'b0;
	
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		msg_in_st.valid = 1'b1;
		
		// down msg in vld, cipher block vld
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		msg_in_st.valid = 1'b0;
		cipher_block_vld = 1'b1;
		cipher_block = 128'd0;
			
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		cipher_block_vld = 1'b0;

		// Should send 0, valid, and be ready
		// New message, length of two
		repeat (5) begin
			#aes_model_pack::CLK_FREQ;
		end
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		key_and_sync_vld = 1'b1;
			
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		msg_in_st.eop = 1'b0;
		msg_in_st.valid = 1'b1;
		key_and_sync_vld = 1'b0;
			
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		msg_in_st.valid = 1'b0;
		msg_in_st.eop = 1'b1;
		msg_in_st.sop = 1'b0;
		cipher_block = 128'd1;
		cipher_block_vld = 1'b1;
			
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		cipher_block_vld = 1'b0;

		repeat (5) begin
			#aes_model_pack::CLK_FREQ;
			end
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		cipher_block = 128'd2;
		cipher_block_vld = 1'b1;
		msg_in_st.valid = 1'b1;
			
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		cipher_block_vld = 1'b0;
		msg_in_st.valid = 1'b0;

		repeat(5) begin
			#aes_model_pack::CLK_FREQ;
		end
		$finish();
	end

endmodule