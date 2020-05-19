module header_remover_tb ();


	logic clk;
	logic rst_n;
	avalon_st_if #(.DATA_WIDTH(16)) same_in();
	avalon_st_if #(.DATA_WIDTH(16)) same_out();
	logic [15:0] same_data;
	logic same_valid;
header_remover #(.DATA_WIDTH(16), .HEADER_SIZE(16)) same_size_header (
	.clk         (clk         ),
	.rst_n       (rst_n       ),
	.data_in     (same_in     ),
	.header_data (same_data ),
	.header_valid(same_valid),
	.data_out    (same_out    )
);

	avalon_st_if #(.DATA_WIDTH(8)) diff_in();
	avalon_st_if #(.DATA_WIDTH(8)) diff_out();
	logic [15:0] diff_data;
	logic diff_valid;
header_remover #(.DATA_WIDTH(8), .HEADER_SIZE(16)) diff_size_remover (
	.clk         (clk         ),
	.rst_n       (rst_n       ),
	.data_in     (diff_in     ),
	.header_data (diff_data ),
	.header_valid(diff_valid),
	.data_out    (diff_out    )
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
	same_out.ClearSlave();
	#20ns;
	@(posedge clk);
	rst_n = 1'b1;
	diff_out.ready = 1'b1;
	same_out.ready = 1'b1;
	@(posedge clk);
	for (int i = 0; i < 10; i++) begin
		diff_in.valid = 1'b1;
		diff_in.data = i;
		diff_in.sop = i == 0;
		diff_in.eop = i == 9;
		same_in.valid = 1'b1;
		same_in.data = i;
		same_in.sop = i == 0;
		same_in.eop = i == 9;
		@(posedge clk);
	end
	diff_in.valid = 1'b0;
	same_in.valid = 1'b0;
end

endmodule