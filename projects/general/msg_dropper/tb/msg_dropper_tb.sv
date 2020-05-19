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

initial begin
	clk = 1'b0;
	forever begin
		#5ns clk = ~clk;
	end
end

initial begin
	#1000ns;
	$finish();
end

endmodule