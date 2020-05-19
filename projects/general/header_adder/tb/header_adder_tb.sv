module header_adder_tb ();

	logic clk;
	logic rst_n;
	avalon_st_if #(.DATA_WIDTH(16)) same_in();
	logic [15:0] header_data;
	logic header_vld;
	avalon_st_if #(.DATA_WIDTH(16)) same_out();
header_adder #(.DATA_WIDTH(16), .HEADER_SIZE(16)) same_size_header (
	.clk        (clk        ),
	.rst_n      (rst_n      ),
	.data_in    (same_in    ),
	.header_data(header_data),
	.header_vld (header_vld ),
	.data_out   (same_out   )
);

	avalon_st_if #(.DATA_WIDTH(8)) diff_in();
	avalon_st_if #(.DATA_WIDTH(8)), diff_out();
header_adder #(.DATA_WIDTH(8), .HEADER_SIZE(16)) diff_size_header (
	.clk        (clk        ),
	.rst_n      (rst_n      ),
	.data_in    (diff_in    ),
	.header_data(header_data),
	.header_vld (header_vld ),
	.data_out   (diff_out   )
);

initial begin
	clk = 1'b0;
	forever begin
		#5ns clk = ~clk;
	end
end

initial begin
	rst_n = 1'b0;
	same_in.ClearMaster();
	diff_in.ClearMaster();
	same_out.ClearSlave();
	diff_out.ClearSlave();
	header_vld = 1'b0;
	header_data = {16{1'b1}};
	#20ns;
	@(posedge clk);
	rst_n = 1'b1;
	same_out.ready = 1'b1;
	diff_out.ready = 1'b1;
	@(posedge clk);
	header_vld = 1'b1;
	@(posedge clk);
	header_vld = 1'b0;
	@(posedge clk);
	for (int i = 0; i < 10; i++) begin
		same_in.valid = 1'b1;
		diff_in.valid = 1'b1;
		same_in.sop = i == 0;
		diff_in.sop = i == 0;
		same_in.data = i;
		diff_in.data = i;
		same_in.eop = i == 9;
		diff_in.eop = i == 9;
		@(posedge clk);
	end
	same_in.valid = 1'b0;
	diff_in.valid = 1'b0;
	#100ns;
	@(posedge clk);
	$finish();
end

endmodule