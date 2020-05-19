module msg_dropper_tb ();

	logic clk;
	logic rst_n;
	logic drop;
	avalon_st_if msg_in();
	avalon_st_if msg_out();
	logic drop_indication;
msg_dropper dut (
	.clk            (clk            ),
	.rst_n          (rst_n          ),
	.drop           (drop           ),
	.msg_in         (msg_in         ),
	.msg_out        (msg_out        ),
	.drop_indication(drop_indication)
);

localparam logic [351:0] EXAMPLE_DATA = 352'h0000001c24174acb00e04c68004108004500001c4bfd000080110000a9fe96dfa9fe0101c17507d00008ebf6;

initial begin
	clk = 1'b0;
	forever begin
		#5ns clk = ~clk;
	end
end

initial begin
	rst_n = 1'b0;
	drop  = 1'b0;
	msg_in.ClearMaster();
	msg_out.ClearSlave();
	#20ns;
	@(posedge clk);
	rst_n = 1'b1;
	@(posedge clk);
	msg_out.ready = 1'b1;
	// Test full messages, drop comes one clock before sop
	for (int i = 0; i < 2; i++) begin
		drop = ~drop;
		@(posedge clk);
		msg_in.valid = 1'b1; 
		for (int j = 0; j < 11; j++) begin
			msg_in.data = EXAMPLE_DATA[351-i*32:352-32*(j+1)];
			msg_in.sop = j == 0;
			msg_in.eop = j == 10;
			@(posedge clk);
		end
		msg_in.valid = 1'b0;
		@(posedge clk);
	end
	#50ns;
	@(posedge clk);
	// Test full messages, drop comes with sop
	for (int i = 0; i < 2; i++) begin
		drop = ~drop;
		msg_in.valid = 1'b1; 
		for (int j = 0; j < 11; j++) begin
			msg_in.data = EXAMPLE_DATA[351-j*32:352-32*(j+1)];
			msg_in.sop = j == 0;
			msg_in.eop = j == 10;
			@(posedge clk);
		end
		msg_in.valid = 1'b0;
		@(posedge clk);
	end
	#50ns;
	@(posedge clk);
	// Drop only one clock with full message on sop
	msg_in.valid = 1'b1;
	for (int j = 0; j < 11; j++) begin
		drop = j == 0;
		msg_in.data = EXAMPLE_DATA[351-j*32:352-32*(j+1)];
		msg_in.sop = j == 0;
		msg_in.eop = j == 10;
		@(posedge clk);
	end
	msg_in.valid = 1'b0;
	#50ns;
	@(posedge clk);
	// One word drop
	drop = 1'b1;
	msg_in.valid = 1'b1;
	msg_in.sop   = 1'b1;
	msg_in.eop 	 = 1'b1;
	msg_in.data  = 0;
	@(posedge clk);
	msg_in.valid = 1'b0;
	// Test message right after another
	#50ns;
	@(posedge clk);
	msg_in.valid = 1'b1;
	@(posedge clk);
	drop = 1'b0;
	@(posedge clk);
	msg_in.valid = 1'b0;
	#100ns;
	$finish();
end

endmodule