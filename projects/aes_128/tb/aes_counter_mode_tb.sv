////////////////////////////////////////////////////////////////////////////////
//
// File name    : aes_counter_mode_tb.sv
// Date Created : 18

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: Testbench for TOP of aes counter mode
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module aes_counter_mode_tb();

	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////
	logic clk = 1'b0;
	logic rst = 1'b0;

	avalon_st_if msg_in_st(clk);
	avalon_st_if msg_out_st(clk);

	dvr_if #(aes_model_pack::BLOCK_SIZE * 2) key_and_sync_in(clk);

	logic sync_overlapse_irq;

	logic [aes_model_pack::BLOCK_SIZE-1:0] expected_result = 128'h3925841d02dc09fbdc118597196a0b32;

	///////////////////////////////////////////////////////////////////////////
	/////// Instantiations ////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	aes_counter_mode dut (
		.clk               (clk               ),
		.rst               (rst               ),
		.msg_in_st         (msg_in_st         ),
		.msg_out_st        (msg_out_st        ),
		.key_and_sync_in   (key_and_sync_in   ),
		.sync_overlapse_irq(sync_overlapse_irq)
	);

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	always begin
		#aes_model_pack::CLK_FREQ clk = ~clk;
	end

	initial begin
		msg_in_st.data 	= 128'd0;
		msg_in_st.valid = 1'b0;
		msg_in_st.sop 	= 1'b1;
		msg_in_st.eop 	= 1'b1;
		msg_in_st.empty = 7'd0;
		msg_out_st.rdy  = 1'b1;
		key_and_sync_in.data  = {128'h3243f6a8885a308d313198a2e0370734, 128'h2b7e151628aed2a6abf7158809cf4f3c};
		key_and_sync_in.valid = 1'b0;
		#20ns;
		@(posedge clk);
		rst = 1'b1;

		// Send key and sync vld
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		key_and_sync_in.valid = 1'b1;

		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		key_and_sync_in.valid = 1'b0;

		// Send message valid
		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		msg_in_st.valid = 1'b1;

		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		msg_in_st.valid = 1'b0;

		// Should output earlier, but to check if it works
		repeat (15) begin
			#aes_model_pack::CLK_FREQ;
			@(posedge clk);
		end
		assert (msg_out_st.data == expected_result) begin
			$display("Everything okay");
		end else begin
			$display("wrong result, outputs %p", msg_out_st.data);
			$display("should be %p", expected_result);
		end
		$finish();
	end

endmodule // aes_counter_mode_tb