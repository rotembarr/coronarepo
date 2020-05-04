/***************************************************************************
- dynamic header adder tb -
sanity testbench
***************************************************************************/

module dynamic_header_adder_tb ();

	logic clk;
	logic rst;

	avalon_st_if #(.DATA_WIDTH_IN_BYTES(4)) msg_in_st 		(.clk(clk));
	avalon_st_if #(.DATA_WIDTH_IN_BYTES(4)) header_in_st 	(.clk(clk));
	avalon_st_if #(.DATA_WIDTH_IN_BYTES(4)) msg_out_st 		(.clk(clk));
	
	// module instantiation
	dynamic_header_adder #(.DATA_WIDTH_IN_BYTES(4))
	dynamic_header_adder_inst(
		.clk(clk),
		.rst(rst),
		.msg_in_st(msg_in_st),
		.header_in_st(header_in_st),
		.msg_out_st(msg_out_st)
	);

	initial begin 
		clk = 1'b0;
		rst = 1'b0;
		header_in_st.CLEAR_MASTER();
		msg_in_st.CLEAR_MASTER();
		msg_out_st.CLEAR_SLAVE();

		#10ns;
		rst = 1'b1;
	end

	always begin
		#5ns;
		clk = ~clk;
	end

	initial begin
		#15ns;
		@(posedge clk)

		// header with empty bytes, the sum of the last header word and the last msg word is bigger than one word
		msg_out_st.rdy <= 1'b1;
		header_in_st.valid <= 1'b1;
		header_in_st.sop <= 1'b1;
		header_in_st.data <= 32'h01234567;

		@(posedge clk)
		header_in_st.data <= 32'h89abcdef;
		header_in_st.sop <= 1'b0;

		@(posedge clk)
		header_in_st.data <= 32'h01234567;
		header_in_st.eop <= 1'b1;
		header_in_st.empty <= 2'b1;

		@(posedge clk)
		header_in_st.valid <= 1'b0;
		header_in_st.eop <= 1'b0;
		header_in_st.empty <= 2'b0;

		msg_in_st.valid <= 1'b1;
		msg_in_st.sop <= 1'b1;
		msg_in_st.data <= 32'h89abcdef;

		@(posedge clk)
		msg_in_st.data <= 32'h18181818;
		msg_in_st.sop <= 1'b0;

		@(posedge clk)
		msg_in_st.data <= 32'hf26a0028;

		@(posedge clk)
		msg_in_st.data <= 32'h67469fa1;
		msg_in_st.eop <= 1'b1;
		msg_in_st.empty <= 2'h2;

		@(posedge clk)
		msg_in_st.valid <= 1'b0;
		msg_in_st.eop <= 1'b0;
		msg_in_st.empty <= 2'b0;

		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)

		// header without empty bytes
		msg_out_st.rdy <= 1'b1;
		header_in_st.valid <= 1'b1;
		header_in_st.sop <= 1'b1;
		header_in_st.data <= 32'h01234567;

		@(posedge clk)
		header_in_st.data <= 32'h89abcdef;
		header_in_st.sop <= 1'b0;

		@(posedge clk)
		header_in_st.data <= 32'h01234567;
		header_in_st.eop <= 1'b1;

		@(posedge clk)
		header_in_st.valid <= 1'b0;
		header_in_st.eop <= 1'b0;

		msg_in_st.valid <= 1'b1;
		msg_in_st.sop <= 1'b1;
		msg_in_st.data <= 32'h89abcdef;

		@(posedge clk)
		msg_in_st.data <= 32'h18181818;
		msg_in_st.sop <= 1'b0;

		@(posedge clk)
		msg_in_st.data <= 32'hf26a0028;

		@(posedge clk)
		msg_in_st.data <= 32'h67469fa1;
		msg_in_st.eop <= 1'b1;
		msg_in_st.empty <= 2'h2;

		@(posedge clk)
		msg_in_st.valid <= 1'b0;
		msg_in_st.eop <= 1'b0;
		msg_in_st.empty <= 2'b0;

		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)

		// header with empty bytes, the sum of the last header word and the last msg word is smaller than one word
		msg_out_st.rdy <= 1'b1;
		header_in_st.valid <= 1'b1;
		header_in_st.sop <= 1'b1;
		header_in_st.data <= 32'h01234567;

		@(posedge clk)
		header_in_st.data <= 32'h89abcdef;
		header_in_st.sop <= 1'b0;

		@(posedge clk)
		header_in_st.data <= 32'h01234567;
		header_in_st.eop <= 1'b1;
		header_in_st.empty <= 2'h2;

		@(posedge clk)
		header_in_st.valid <= 1'b0;
		header_in_st.eop <= 1'b0;
		header_in_st.empty <= 2'b0;

		msg_in_st.valid <= 1'b1;
		msg_in_st.sop <= 1'b1;
		msg_in_st.data <= 32'h89abcdef;

		@(posedge clk)
		msg_in_st.data <= 32'h18181818;
		msg_in_st.sop <= 1'b0;

		@(posedge clk)
		msg_in_st.data <= 32'hf26a0028;

		@(posedge clk)
		msg_in_st.data <= 32'h67469fa1;
		msg_in_st.eop <= 1'b1;
		msg_in_st.empty <= 2'h2;

		@(posedge clk)
		msg_in_st.valid <= 1'b0;
		msg_in_st.eop <= 1'b0;
		msg_in_st.empty <= 2'b0;

		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		$finish();
	end

endmodule